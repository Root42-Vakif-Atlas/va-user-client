import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'mock_api.dart';

/// Mock nesne deposuna yüklenmiş (veya yüklenmeyi bekleyen) fotoğraf.
final class MockPhotoUpload {
  MockPhotoUpload({
    required this.id,
    required this.ownerId,
    required this.byteSize,
    required this.width,
    required this.height,
    required this.expiresAt,
  });

  final String id;
  final String ownerId;
  final int byteSize;
  final int width;
  final int height;
  final DateTime expiresAt;

  /// `PUT` tamamlanınca dolar.
  Uint8List? bytes;
}

/// Gerçek sistemdeki ön imzalı nesne deposu yüklemesinin taklidi
/// (`docs/api-contracts.md`): servis kısa ömürlü bir yükleme adresi verir,
/// istemci baytları kimlik bilgisi olmadan `PUT` eder, servis ardından
/// yüklemeyi kayda bağlar.
///
/// Fotoğraflar `data:image/jpeg;base64,…` adresiyle döner (gerçek sistemde
/// CDN adresi). Anı Köşesi ve Sivil Koruma mock servisleri ayrı kovalarla
/// kullanır.
class MockPhotoStorage implements MockApi {
  MockPhotoStorage({
    required this.bucket,
    required DateTime Function() clock,
    Random? random,
  }) : _now = clock,
       _random = random ?? Random.secure();

  /// Adres öneki: `mock-storage/<bucket>/<id>`.
  final String bucket;
  final DateTime Function() _now;
  final Random _random;

  static const Duration uploadLifetime = Duration(minutes: 15);
  static const String contentType = 'image/jpeg';

  final Map<String, MockPhotoUpload> _uploads = {};

  String get _path => 'mock-storage/$bucket';

  @override
  List<MockRoute> get routes => [MockRoute('PUT', '$_path/:id', _upload)];

  /// `{contentType, byteSize, width, height}` gövdesinden yükleme adresi.
  /// Geçersiz gövde `400 invalid_request`, büyük dosya `400 photo_too_large`.
  MockResponse issueTicket({
    required String ownerId,
    required Object? body,
    required int maxBytes,
  }) {
    if (body is! Map<String, dynamic>) {
      return MockResponse.error(400, 'invalid_request');
    }
    final byteSize = body['byteSize'];
    final width = body['width'];
    final height = body['height'];
    if (body['contentType'] != contentType ||
        byteSize is! int ||
        width is! int ||
        height is! int ||
        byteSize <= 0 ||
        width <= 0 ||
        height <= 0) {
      return MockResponse.error(400, 'invalid_request');
    }
    if (byteSize > maxBytes) {
      return MockResponse.error(400, 'photo_too_large');
    }
    final id = 'up_${_randomHex(12)}';
    final expiresAt = _now().add(uploadLifetime);
    _uploads[id] = MockPhotoUpload(
      id: id,
      ownerId: ownerId,
      byteSize: byteSize,
      width: width,
      height: height,
      expiresAt: expiresAt,
    );
    return MockResponse(
      201,
      body: {
        'id': id,
        'uploadUrl': '$_path/$id',
        'uploadHeaders': const <String, String>{},
        'expiresAt': expiresAt.toUtc().toIso8601String(),
      },
    );
  }

  /// [ids] yüklemelerinin hepsi [ownerId]'ye aitse, tamamlanmışsa, süresi
  /// dolmamışsa ve tekrarlanmıyorsa döndürür; aksi halde `null`.
  List<MockPhotoUpload>? claim(List<String> ids, String ownerId) {
    if (ids.toSet().length != ids.length) {
      return null;
    }
    final uploads = <MockPhotoUpload>[];
    for (final id in ids) {
      final upload = _uploads[id];
      if (upload == null ||
          upload.ownerId != ownerId ||
          upload.bytes == null ||
          !_now().isBefore(upload.expiresAt)) {
        return null;
      }
      uploads.add(upload);
    }
    return uploads;
  }

  /// Kayda bağlanan yüklemeler bir daha kullanılamaz.
  void release(Iterable<String> ids) => ids.forEach(_uploads.remove);

  /// Hesap silindiğinde bekleyen yüklemeler de silinir.
  void removeOwner(String ownerId) =>
      _uploads.removeWhere((_, upload) => upload.ownerId == ownerId);

  /// Kayıtta saklanan fotoğraf nesnesi (API'nin `photos[]` biçimi).
  static Map<String, dynamic> photoJson(
    MockPhotoUpload upload, {
    String? description,
  }) {
    final url = 'data:$contentType;base64,${base64Encode(upload.bytes!)}';
    final text = description?.trim();
    return {
      'id': 'ph_${upload.id.substring(3)}',
      'url': url,
      'thumbnailUrl': url,
      'width': upload.width,
      'height': upload.height,
      if (text != null && text.isNotEmpty) 'description': text,
    };
  }

  Future<MockResponse> _upload(MockRequest request) async {
    final upload = _uploads[request.pathParameters['id']];
    final bytes = request.body;
    if (upload == null || !_now().isBefore(upload.expiresAt)) {
      return MockResponse.error(403, 'upload_expired');
    }
    if (bytes is! Uint8List ||
        bytes.length != upload.byteSize ||
        !_isJpeg(bytes)) {
      return MockResponse.error(400, 'invalid_upload');
    }
    upload.bytes = bytes;
    return const MockResponse(200);
  }

  static bool _isJpeg(Uint8List bytes) =>
      bytes.length > 3 && bytes[0] == 0xFF && bytes[1] == 0xD8;

  String _randomHex(int bytes) => [
    for (var i = 0; i < bytes; i++)
      _random.nextInt(256).toRadixString(16).padLeft(2, '0'),
  ].join();
}
