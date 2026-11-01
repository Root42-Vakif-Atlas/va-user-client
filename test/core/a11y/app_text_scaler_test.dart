import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/a11y/app_text_scaler.dart';

void main() {
  test('sistem ölçeği ile uygulama çarpanı çarpılır', () {
    final scaler = AppTextScaler.resolve(const TextScaler.linear(1.2), 1.5);
    expect(scaler.scale(10), closeTo(18, 0.001));
  });

  test('sonuç %200 ile sınırlanır', () {
    final scaler = AppTextScaler.resolve(const TextScaler.linear(1.5), 2);
    expect(scaler.scale(10), closeTo(20, 0.001));
  });

  test('sonuç %100 altına düşmez', () {
    final scaler = AppTextScaler.resolve(const TextScaler.linear(0.85), 1);
    expect(scaler.scale(10), closeTo(10, 0.001));
  });
}
