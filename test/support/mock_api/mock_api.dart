import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:vakif_atlas/core/network/http_transport.dart';

/// Mock API'ye gelen, ayrıştırılmış istek.
@immutable
final class MockRequest {
  const MockRequest({
    required this.method,
    required this.path,
    required this.pathParameters,
    required this.queryParameters,
    required this.headers,
    required this.body,
  });

  final String method;

  /// Kök adrese göre göreli yol (ör. `auth/login`).
  final String path;
  final Map<String, String> pathParameters;
  final Map<String, String> queryParameters;

  /// Küçük harfe çevrilmiş başlık adları.
  final Map<String, String> headers;

  /// JSON gövde çözülmüş haliyle (`Map`, `List`), ikili yüklemelerde
  /// (`image/*`, `application/octet-stream`) `Uint8List` veya `null`.
  final Object? body;

  /// `Authorization: Bearer <token>` başlığındaki anahtar.
  String? get bearerToken {
    final header = headers['authorization'];
    const prefix = 'Bearer ';
    if (header == null || !header.startsWith(prefix)) {
      return null;
    }
    return header.substring(prefix.length);
  }

  /// JSON nesne gövdesindeki [key] alanı.
  Object? field(String key) {
    final data = body;
    return data is Map<String, dynamic> ? data[key] : null;
  }
}

/// Mock API yanıtı.
@immutable
final class MockResponse {
  const MockResponse(this.statusCode, {this.body});

  const MockResponse.ok(Object this.body) : statusCode = 200;

  const MockResponse.noContent() : statusCode = 204, body = null;

  /// Gerçek API ile aynı hata gövdesi sözleşmesi: `{"code": "..."}`.
  MockResponse.error(this.statusCode, String code)
    : body = <String, Object>{'code': code};

  final int statusCode;
  final Object? body;
}

typedef MockHandler = FutureOr<MockResponse> Function(MockRequest request);

/// Yöntem + yol kalıbı (`monuments/:id`) ile eşleşen mock uç nokta.
final class MockRoute {
  MockRoute(this.method, this.pattern, this.handler)
    : _segments = _split(pattern);

  final String method;
  final String pattern;
  final MockHandler handler;
  final List<String> _segments;

  /// Eşleşirse yol parametrelerini, aksi halde `null` döndürür.
  Map<String, String>? match(String method, String path) {
    if (method.toUpperCase() != this.method.toUpperCase()) {
      return null;
    }
    final segments = _split(path);
    if (segments.length != _segments.length) {
      return null;
    }
    final parameters = <String, String>{};
    for (var i = 0; i < segments.length; i++) {
      final expected = _segments[i];
      if (expected.startsWith(':')) {
        parameters[expected.substring(1)] = Uri.decodeComponent(segments[i]);
      } else if (expected != segments[i]) {
        return null;
      }
    }
    return parameters;
  }

  static List<String> _split(String path) =>
      path.split('/').where((segment) => segment.isNotEmpty).toList();
}

/// Bir feature'ın mock uç noktalarını bir arada sunan sözleşme.
abstract interface class MockApi {
  List<MockRoute> get routes;
}

/// Testlerde ağa hiç çıkmadan, gerçek API sözleşmesiyle yanıt veren HTTP
/// adaptörü (bellek içi sahte backend).
///
/// Dio'nun en alt katmanında çalıştığından uygulamanın interceptor
/// zinciri, DTO ayrıştırma ve hata eşleme testlerde de birebir çalışır.
class MockApiAdapter implements HttpClientAdapter {
  MockApiAdapter({required List<MockApi> apis, this.latency = Duration.zero})
    : _routes = [for (final api in apis) ...api.routes];

  final List<MockRoute> _routes;
  final Duration latency;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final body = await _readBody(requestStream, options.contentType);
    if (latency > Duration.zero) {
      await Future<void>.delayed(latency);
    }

    final path = _relativePath(options);
    for (final route in _routes) {
      final parameters = route.match(options.method, path);
      if (parameters == null) {
        continue;
      }
      final response = await route.handler(
        MockRequest(
          method: options.method.toUpperCase(),
          path: path,
          pathParameters: parameters,
          queryParameters: options.uri.queryParameters,
          headers: {
            for (final MapEntry(:key, :value) in options.headers.entries)
              key.toLowerCase(): '$value',
          },
          body: body,
        ),
      );
      return _toResponseBody(response);
    }
    return _toResponseBody(MockResponse.error(404, 'not_found'));
  }

  @override
  void close({bool force = false}) {}

  static String _relativePath(RequestOptions options) {
    final basePath = Uri.parse(options.baseUrl).path;
    final fullPath = options.uri.path;
    final relative = fullPath.startsWith(basePath)
        ? fullPath.substring(basePath.length)
        : fullPath;
    return relative.replaceFirst(RegExp('^/+'), '');
  }

  static Future<Object?> _readBody(
    Stream<Uint8List>? stream,
    String? contentType,
  ) async {
    if (stream == null) {
      return null;
    }
    final builder = BytesBuilder(copy: false);
    await stream.forEach(builder.add);
    if (builder.isEmpty) {
      return null;
    }
    final bytes = builder.takeBytes();
    if (_isBinary(contentType)) {
      return bytes;
    }
    try {
      final text = utf8.decode(bytes);
      try {
        return jsonDecode(text);
      } on FormatException {
        return text;
      }
    } on FormatException {
      return bytes;
    }
  }

  static bool _isBinary(String? contentType) {
    final type = contentType?.toLowerCase() ?? '';
    return type.startsWith('image/') ||
        type.startsWith('application/octet-stream');
  }

  static ResponseBody _toResponseBody(MockResponse response) {
    final headers = <String, List<String>>{
      Headers.contentTypeHeader: [Headers.jsonContentType],
    };
    if (response.body == null) {
      return ResponseBody.fromString('', response.statusCode, headers: headers);
    }
    return ResponseBody.fromBytes(
      utf8.encode(jsonEncode(response.body)),
      response.statusCode,
      headers: headers,
    );
  }
}

/// Bağlantı denetimi için `GET/HEAD health` uç noktası.
final class HealthMockApi implements MockApi {
  const HealthMockApi();

  @override
  List<MockRoute> get routes => [
    MockRoute('GET', 'health', (_) => const MockResponse.ok({'status': 'ok'})),
    MockRoute('HEAD', 'health', (_) => const MockResponse.noContent()),
  ];
}

/// Uygulamanın tüm `Dio` istemcilerini [adapter]'a bağlar
/// (`HttpTransport` test yerine geçeni).
final class MockHttpTransport implements HttpTransport {
  const MockHttpTransport(this.adapter);

  final MockApiAdapter adapter;

  @override
  HttpClientAdapter createAdapter({
    TransportScope scope = TransportScope.api,
  }) => adapter;
}
