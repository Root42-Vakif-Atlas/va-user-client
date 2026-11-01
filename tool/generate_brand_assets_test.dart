// Native açılış ekranı görsellerini `BrandEmblem` vektör çiziminden üretir.
//
// Amblem veya açılış renkleri değiştiğinde çalıştırın:
//   flutter test tool/generate_brand_assets_test.dart
//
// `test/` dışında olduğundan normal `flutter test` çalıştırmasına dahil
// değildir. Çıktılar sürüm kontrolüne eklenir.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/theme/launch_colors.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/shared/widgets/atoms/brand_emblem.dart';

/// Android yoğunluk klasörleri ve dp → px çarpanları.
const Map<String, double> _androidDensities = {
  'mdpi': 1,
  'hdpi': 1.5,
  'xhdpi': 2,
  'xxhdpi': 3,
  'xxxhdpi': 4,
};

const List<int> _iosScales = [1, 2, 3];

const BrandEmblemPainter _painter = BrandEmblemPainter(
  frameColor: LaunchColors.foreground,
  accentColor: LaunchColors.accent,
);

Future<void> _writePng({
  required String path,
  required double canvas,
  required double emblem,
  required double scale,
}) async {
  final pixels = (canvas * scale).round();
  final emblemPixels = emblem * scale;
  final recorder = ui.PictureRecorder();
  final offset = (pixels - emblemPixels) / 2;
  final canvasRef = Canvas(recorder)..translate(offset, offset);
  _painter.paint(canvasRef, Size.square(emblemPixels));
  final image = await recorder.endRecording().toImage(pixels, pixels);
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  File(path)
    ..createSync(recursive: true)
    ..writeAsBytesSync(bytes!.buffer.asUint8List());
}

void main() {
  test('native açılış görsellerini üretir', () async {
    // Android: 12+ SplashScreen simgesi (288 dp tuval, 192 dp görünür daire)
    // ve eski sürümlerin `launch_background` katmanı aynı görseli kullanır.
    for (final MapEntry(key: density, value: scale)
        in _androidDensities.entries) {
      await _writePng(
        path: 'android/app/src/main/res/drawable-$density/splash_icon.png',
        canvas: AppSizes.splashIconCanvas,
        emblem: AppSizes.splashEmblem,
        scale: scale,
      );
    }
    // iOS: LaunchScreen.storyboard görseli ortalar.
    for (final scale in _iosScales) {
      final suffix = scale == 1 ? '' : '@${scale}x';
      await _writePng(
        path:
            'ios/Runner/Assets.xcassets/LaunchImage.imageset/'
            'LaunchImage$suffix.png',
        canvas: AppSizes.splashEmblem,
        emblem: AppSizes.splashEmblem,
        scale: scale.toDouble(),
      );
    }
  });
}
