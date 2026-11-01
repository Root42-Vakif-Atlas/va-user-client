import 'dart:typed_data';

/// Yüklenmek üzere hazırlanmış (cihazda küçültülmüş, meta verisi
/// temizlenmiş) fotoğraf: Anı Köşesi ve Sivil Koruma ortak kullanır.
///
/// Saf Dart'tır; Domain katmanları içe aktarabilir.
final class PhotoDraft {
  const PhotoDraft({
    required this.localId,
    required this.bytes,
    required this.width,
    required this.height,
    this.description = '',
  });

  /// Form içinde fotoğrafı ayırt eden yerel kimlik (sunucuya gitmez).
  final String localId;

  /// JPEG baytları (EXIF / GPS içermez).
  final Uint8List bytes;
  final int width;
  final int height;

  /// Ekran okuyucu için betim; boşsa gönderilmez.
  final String description;

  PhotoDraft withDescription(String value) => PhotoDraft(
    localId: localId,
    bytes: bytes,
    width: width,
    height: height,
    description: value,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhotoDraft &&
          other.localId == localId &&
          identical(other.bytes, bytes) &&
          other.width == width &&
          other.height == height &&
          other.description == description;

  @override
  int get hashCode => Object.hash(localId, width, height, description);

  @override
  String toString() => 'PhotoDraft(localId: $localId)';
}
