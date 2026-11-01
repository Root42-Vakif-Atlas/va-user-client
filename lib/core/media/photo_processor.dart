import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:injectable/injectable.dart';

/// Paylaşıma hazır fotoğraf.
@immutable
final class ProcessedPhoto {
  const ProcessedPhoto({
    required this.bytes,
    required this.width,
    required this.height,
  });

  /// JPEG; EXIF (GPS, cihaz, tarih) ve diğer meta veri içermez.
  final Uint8List bytes;
  final int width;
  final int height;
}

/// Fotoğrafı yüklemeye hazırlar (KVKK / MASVS-PRIVACY):
///
/// 1. EXIF yönü piksellere uygulanır (meta veri silindiğinde döndürülmüş
///    görünmesin).
/// 2. Uzun kenar [maxDimension] px'e indirilir.
/// 3. Saydam alan beyaza oturtulur ve JPEG olarak yeniden kodlanır; EXIF
///    yazılmadığından konum ve cihaz bilgisi fotoğraftan çıkar.
///
/// Çözümleme ağır olduğundan arka plan isolate'ında çalışır (web'de aynı
/// iş parçacığında). Sunucu da yüklenen fotoğrafı yeniden kodlar.
@lazySingleton
class PhotoProcessor {
  const PhotoProcessor();

  static const int maxDimension = 1600;
  static const int jpegQuality = 82;

  /// Desteklenmeyen veya bozuk görselde `null`.
  Future<ProcessedPhoto?> process(Uint8List bytes) =>
      compute(processPhotoSync, bytes);
}

/// [PhotoProcessor.process]'in senkron gövdesi (isolate giriş noktası).
@visibleForTesting
ProcessedPhoto? processPhotoSync(Uint8List bytes) {
  final img.Image? decoded;
  try {
    decoded = img.decodeImage(bytes);
  } on Exception {
    return null;
  }
  if (decoded == null || decoded.width == 0 || decoded.height == 0) {
    return null;
  }
  var image = img.bakeOrientation(decoded);

  final longest = max(image.width, image.height);
  if (longest > PhotoProcessor.maxDimension) {
    final scale = PhotoProcessor.maxDimension / longest;
    image = img.copyResize(
      image,
      width: max(1, (image.width * scale).round()),
      height: max(1, (image.height * scale).round()),
      interpolation: img.Interpolation.average,
    );
  }

  if (image.hasAlpha) {
    final background = img.Image(width: image.width, height: image.height)
      ..clear(img.ColorRgb8(255, 255, 255));
    image = img.compositeImage(background, image);
  }

  image
    ..exif = img.ExifData()
    ..textData = null;
  final encoded = img.encodeJpg(image, quality: PhotoProcessor.jpegQuality);
  return ProcessedPhoto(
    bytes: encoded,
    width: image.width,
    height: image.height,
  );
}
