import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/theme/app_theme.dart';
import 'package:vakif_atlas/core/theme/extensions/app_color_scheme.dart';
import 'package:vakif_atlas/core/theme/extensions/app_text_theme.dart';
import 'package:vakif_atlas/core/theme/tokens/app_colors.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/core/theme/tokens/app_typography.dart';

void main() {
  final themes = {
    'dark': (AppTheme.dark(), AppColorScheme.dark),
    'light': (AppTheme.light(), AppColorScheme.light),
    'highContrastDark': (
      AppTheme.highContrastDark(),
      AppColorScheme.highContrastDark,
    ),
    'highContrastLight': (
      AppTheme.highContrastLight(),
      AppColorScheme.highContrastLight,
    ),
  };

  for (final MapEntry(key: name, value: (theme, scheme)) in themes.entries) {
    group('AppTheme.$name', () {
      test('Material 3 ve doğru parlaklık kullanır', () {
        expect(theme.useMaterial3, isTrue);
        expect(theme.brightness, scheme.brightness);
        expect(theme.colorScheme.brightness, scheme.brightness);
      });

      test('extension olarak AppColorScheme ve AppTextTheme taşır', () {
        expect(theme.extension<AppColorScheme>(), same(scheme));
        expect(theme.extension<AppTextTheme>(), isNotNull);
      });

      test('ColorScheme semantik token\'larla eşleşir', () {
        expect(theme.colorScheme.primary, scheme.primary);
        expect(theme.colorScheme.onPrimary, scheme.onPrimary);
        expect(theme.colorScheme.surface, scheme.surface);
        expect(theme.colorScheme.onSurface, scheme.onSurface);
        expect(theme.colorScheme.error, scheme.error);
        expect(theme.colorScheme.primaryContainer, scheme.primaryContainer);
        expect(theme.colorScheme.tertiary, scheme.brandAccent);
        expect(theme.scaffoldBackgroundColor, scheme.surface);
        expect(theme.bottomSheetTheme.backgroundColor, scheme.surfaceElevated);
        expect(
          theme.navigationBarTheme.indicatorColor,
          scheme.secondaryContainer,
        );
      });

      test('metin stilleri tema rengini kullanır; Cinzel yalnızca marka '
          'başlıklarında (display)', () {
        final text = theme.extension<AppTextTheme>()!;
        expect(text.bodyLarge.color, scheme.onSurface);
        expect(text.bodyLarge.fontFamily, AppFonts.inter);
        expect(text.headlineLarge.fontFamily, AppFonts.inter);
        expect(text.headlineMedium.fontFamily, AppFonts.inter);
        expect(text.displayMedium.fontFamily, AppFonts.cinzel);
        expect(theme.textTheme.bodyLarge?.color, scheme.onSurface);
      });

      test('dokunma hedefleri 48 dp\'ye genişletilir', () {
        expect(theme.materialTapTargetSize, MaterialTapTargetSize.padded);
        final minimumSize = theme.filledButtonTheme.style?.minimumSize?.resolve(
          {},
        );
        expect(
          minimumSize,
          const Size(AppSizes.minTouchTarget, AppSizes.minTouchTarget),
        );
      });
    });
  }

  test(
    'marka rolleri: nötr yüzeyler, logo yeşili eylem, Antik Altın vurgu',
    () {
      final dark = AppTheme.dark().extension<AppColorScheme>()!;
      expect(dark.surface, AppColors.ink);
      expect(dark.onSurface, AppColors.inkText);
      expect(dark.primary, AppColors.tealOnDark);
      expect(dark.brandAccent, AppColors.antiqueGold);

      final light = AppTheme.light().extension<AppColorScheme>()!;
      expect(light.onSurface, AppColors.slateText);
      expect(light.primary, AppColors.green30);
      expect(light.surfaceElevated, AppColors.white);
      expect(light.brandAccent, AppColors.antiqueGold);
    },
  );

  test('yüksek kontrast temaları kalın kenarlık kullanır', () {
    final border =
        AppTheme.highContrastDark().inputDecorationTheme.enabledBorder;
    expect(border?.borderSide.width, AppSizes.borderThick);
  });

  testWidgets('tema widget ağacından okunabilir', (tester) async {
    late AppColorScheme resolved;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Builder(
          builder: (context) {
            resolved = Theme.of(context).extension<AppColorScheme>()!;
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    expect(resolved, same(AppColorScheme.light));
  });
}
