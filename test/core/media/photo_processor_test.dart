import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:vakif_atlas/core/media/photo_processor.dart';

import '../../helpers/memory_test_utils.dart';

void main() {
  group('processPhotoSync', () {
    test('EXIF (GPS, cihaz) silinir', () {
      final exif = img.ExifData();
      exif.gpsIfd['GPSLatitude'] = img.IfdValueRational(41, 1);
      exif.gpsIfd['GPSLongitude'] = img.IfdValueRational(26, 1);
      exif.imageIfd['Make'] = img.IfdValueAscii('Test Phone');
      final source = testJpeg(exif: exif);
      expect(img.decodeJpgExif(source)?.gpsIfd.isEmpty, isFalse);

      final processed = processPhotoSync(source)!;
      final remaining = img.decodeJpgExif(processed.bytes);

      expect(remaining == null || remaining.isEmpty, isTrue);
      expect(processed.width, 64);
      expect(processed.height, 48);
    });

    test('uzun kenar ${PhotoProcessor.maxDimension} px\'e indirilir, oran '
        'korunur', () {
      final processed = processPhotoSync(testJpeg(width: 3200, height: 1800))!;

      expect(processed.width, PhotoProcessor.maxDimension);
      expect(processed.height, 900);
      final decoded = img.decodeJpg(processed.bytes)!;
      expect(decoded.width, PhotoProcessor.maxDimension);
    });

    test('EXIF yönü piksellere uygulanır', () {
      final exif = img.ExifData();
      exif.imageIfd.orientation = 6; // 90° saat yönünde
      final processed = processPhotoSync(
        testJpeg(width: 80, height: 40, exif: exif),
      )!;

      expect(processed.width, 40);
      expect(processed.height, 80);
    });

    test('saydam PNG beyaz zemine oturtulup JPEG olur', () {
      final png = img.encodePng(
        img.Image(width: 10, height: 10, numChannels: 4)
          ..clear(img.ColorRgba8(0, 0, 0, 0)),
      );
      final processed = processPhotoSync(png)!;
      final decoded = img.decodeJpg(processed.bytes)!;
      final pixel = decoded.getPixel(5, 5);

      expect(processed.bytes.sublist(0, 2), [0xFF, 0xD8]);
      expect(pixel.r, greaterThan(240));
      expect(pixel.g, greaterThan(240));
    });

    test('çözümlenemeyen veri null döner', () {
      expect(processPhotoSync(Uint8List.fromList([1, 2, 3, 4])), isNull);
    });
  });
}
