import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/theme/app_theme.dart';
import 'package:vakif_atlas/core/theme/extensions/app_color_scheme.dart';
import 'package:vakif_atlas/core/theme/extensions/app_text_theme.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';

void main() {
  group('AppColorScheme', () {
    test('copyWith yalnızca verilen alanı değiştirir', () {
      const changed = Color(0xFF123456);
      final copy = AppColorScheme.dark.copyWith(primary: changed);
      expect(copy.primary, changed);
      expect(copy.surface, AppColorScheme.dark.surface);
      expect(copy.brightness, AppColorScheme.dark.brightness);
    });

    test('lerp uç değerlerde kaynak ve hedef renkleri verir', () {
      final start = AppColorScheme.dark.lerp(AppColorScheme.light, 0);
      final end = AppColorScheme.dark.lerp(AppColorScheme.light, 1);
      expect(start.surface, AppColorScheme.dark.surface);
      expect(end.surface, AppColorScheme.light.surface);
      expect(end.brightness, Brightness.light);
    });

    test('farklı tipte extension ile lerp kendisini döndürür', () {
      expect(AppColorScheme.dark.lerp(null, 0.5), same(AppColorScheme.dark));
    });
  });

  group('AppTextTheme', () {
    test('lerp uç değerlerde kaynak ve hedef stilleri verir', () {
      final dark = AppTextTheme.fromColors(AppColorScheme.dark);
      final light = AppTextTheme.fromColors(AppColorScheme.light);
      expect(dark.lerp(light, 1).bodyLarge.color, light.bodyLarge.color);
    });
  });

  testWidgets('context.colors ve context.textStyles aktif temayı verir', (
    tester,
  ) async {
    late AppColorScheme colors;
    late AppTextTheme textStyles;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.highContrastLight(),
        home: Builder(
          builder: (context) {
            colors = context.colors;
            textStyles = context.textStyles;
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    expect(colors, same(AppColorScheme.highContrastLight));
    expect(textStyles.bodyLarge.color, colors.onSurface);
  });
}
