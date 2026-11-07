import 'dart:async';
import 'dart:math' as math;

import 'package:http/http.dart' as http;

/// Altlık harita karoları için zaman aşımlı ve yeniden denemeli HTTP
/// istemcisi.
///
/// flutter_map'in varsayılan istemcisinde zaman aşımı yoktur ve yalnızca
/// 503 yeniden denenir. Takılan istek veya OSM'nin hız sınırı (429) karoyu
/// kalıcı olarak boş (gri) bırakıyordu. Burada:
/// - Başlıklar ve gövde [timeout] içinde gelmezse istek düşer.
/// - Geçici hatalar ([retryableStatuses], zaman aşımı, bağlantı hatası)
///   [retries] kez, üstel beklemeyle yeniden denenir; 429/503'te sunucunun
///   `Retry-After` başlığına uyulur ([maxRetryAfter] ile sınırlı).
/// - Kalıcı hatalar (404 vb.) hemen döner.
///
/// `dart:io`'ya bağımlı değildir (web): bağlantı hataları `http` paketinde
/// [http.ClientException] olarak gelir.
class TileHttpClient extends http.BaseClient {
  TileHttpClient({
    http.Client? inner,
    this.timeout = const Duration(seconds: 10),
    this.retries = 3,
    this.baseDelay = const Duration(milliseconds: 500),
    this.maxRetryAfter = const Duration(seconds: 5),
    Future<void> Function(Duration delay)? sleep,
  }) : _inner = inner ?? http.Client(),
       _sleep = sleep ?? Future<void>.delayed;

  final http.Client _inner;
  final Future<void> Function(Duration delay) _sleep;

  final Duration timeout;
  final int retries;
  final Duration baseDelay;
  final Duration maxRetryAfter;

  /// Geçici sunucu yanıtları (hız sınırı, ağ geçidi, bakım).
  static const Set<int> retryableStatuses = {429, 502, 503, 504};

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    for (var attempt = 0; ; attempt++) {
      // Yalnızca gövdesi kopyalanabilen istekler yeniden gönderilebilir.
      final canRetry = request is http.Request && attempt < retries;
      final http.StreamedResponse response;
      try {
        response = await _inner
            .send(attempt == 0 ? request : _copy(request as http.Request))
            .timeout(timeout);
      } on Object catch (error) {
        if (!canRetry || !_isTransient(error)) {
          rethrow;
        }
        await _sleep(_backoff(attempt));
        continue;
      }
      if (!canRetry || !retryableStatuses.contains(response.statusCode)) {
        return _withBodyTimeout(response);
      }
      final wait = _retryAfter(response) ?? _backoff(attempt);
      // Atılan yanıtın bağlantısı serbest bırakılır.
      unawaited(response.stream.drain<void>().catchError((Object _) {}));
      await _sleep(wait);
    }
  }

  static bool _isTransient(Object error) =>
      error is TimeoutException || error is http.ClientException;

  /// 0,5 · 1 · 2 sn …
  Duration _backoff(int attempt) => baseDelay * math.pow(2, attempt).toInt();

  /// `Retry-After: <saniye>`; tarih biçimi ve geçersiz değer yok sayılır.
  Duration? _retryAfter(http.BaseResponse response) {
    final seconds = int.tryParse(response.headers['retry-after'] ?? '');
    if (seconds == null || seconds < 0) {
      return null;
    }
    final wait = Duration(seconds: seconds);
    return wait > maxRetryAfter ? maxRetryAfter : wait;
  }

  static http.Request _copy(http.Request request) =>
      http.Request(request.method, request.url)
        ..headers.addAll(request.headers)
        ..followRedirects = request.followRedirects
        ..maxRedirects = request.maxRedirects
        ..persistentConnection = request.persistentConnection
        ..bodyBytes = request.bodyBytes;

  /// Gövde akışı da takılabilir (yarım kalan bağlantı); karo boş kalmasın
  /// diye parça aralarında [timeout] uygulanır.
  http.StreamedResponse _withBodyTimeout(http.StreamedResponse response) =>
      http.StreamedResponse(
        response.stream.timeout(timeout),
        response.statusCode,
        contentLength: response.contentLength,
        request: response.request,
        headers: response.headers,
        isRedirect: response.isRedirect,
        persistentConnection: response.persistentConnection,
        reasonPhrase: response.reasonPhrase,
      );

  @override
  void close() => _inner.close();
}
