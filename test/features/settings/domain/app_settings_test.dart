import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/theme/color_blindness_profile.dart';
import 'package:vakif_atlas/core/theme/theme_preference.dart';
import 'package:vakif_atlas/features/settings/domain/entities/accessibility_preferences.dart';
import 'package:vakif_atlas/features/settings/domain/entities/app_settings.dart';

void main() {
  group('AppSettings', () {
    test('varsayılanlar cihazın teması ve dilidir', () {
      expect(AppSettings.defaults.themePreference, ThemePreference.system);
      expect(AppSettings.defaults.languageCode, isNull);
      expect(AppSettings.defaults.textScaleFactor, 1.0);
      // Cihazın hareket ayarı ayrıca uygulanır; titreşim varsayılan açıktır.
      expect(AppSettings.defaults.reduceMotion, isFalse);
      expect(AppSettings.defaults.hapticFeedback, isTrue);
      expect(AppSettings.defaults.hasDefaultAccessibility, isTrue);
    });

    test('copyWith languageCode verilmezse korur, null verilirse temizler', () {
      final english = AppSettings.defaults.copyWith(languageCode: 'en');
      expect(
        english.copyWith(themePreference: ThemePreference.dark).languageCode,
        'en',
      );
      expect(english.copyWith(languageCode: null).languageCode, isNull);
    });

    test('erişilebilirlik varsayılana dönerken tema ve dil korunur', () {
      final custom = AppSettings.defaults.copyWith(
        themePreference: ThemePreference.dark,
        languageCode: 'en',
        accessibility: AccessibilityPreferences.defaults.cycle(
          AccessibilityFeature.grayscale,
        ),
      );

      final reset = custom.withAccessibilityOf(AppSettings.defaults);

      expect(reset.themePreference, ThemePreference.dark);
      expect(reset.languageCode, 'en');
      expect(reset.hasDefaultAccessibility, isTrue);
      // Buton görünürlüğü erişilebilirlik tercihi değildir; sıfırlanmaz.
      expect(
        custom
            .copyWith(showAccessibilityButton: false)
            .withAccessibilityOf(AppSettings.defaults)
            .showAccessibilityButton,
        isFalse,
      );
    });

    test('değer eşitliği uygular', () {
      AppSettings protan() => AppSettings.defaults.copyWith(
        accessibility: AccessibilityPreferences({
          AccessibilityFeature.colorBlindness: 1,
        }),
      );
      expect(protan(), protan());
      expect(protan().hashCode, protan().hashCode);
      expect(protan(), isNot(AppSettings.defaults));
    });
  });

  group('AccessibilityPreferences', () {
    test('her dokunuş bir sonraki seviyeye geçer; sondan sonra kapanır', () {
      var prefs = AccessibilityPreferences.defaults;
      final seen = <int>[];
      for (var i = 0; i < 5; i++) {
        prefs = prefs.cycle(AccessibilityFeature.contrast);
        seen.add(prefs.level(AccessibilityFeature.contrast));
      }
      expect(seen, [1, 2, 3, 4, 0]);
      // Açma/kapama: 0 ↔ 1; titreşim varsayılan açıktır.
      expect(
        AccessibilityPreferences.defaults
            .cycle(AccessibilityFeature.haptics)
            .hapticFeedback,
        isFalse,
      );
    });

    test('seviyeler türetilmiş değerlere eşlenir', () {
      final prefs = AccessibilityPreferences({
        AccessibilityFeature.grayscale: 2,
        AccessibilityFeature.contrast: 4,
        AccessibilityFeature.zoom: 3,
        AccessibilityFeature.colorBlindness: 3,
        AccessibilityFeature.blueLightFilter: 1,
        AccessibilityFeature.dyslexiaFriendly: 3,
        AccessibilityFeature.lineHeight: 2,
        AccessibilityFeature.stopAnimations: 1,
      });

      expect(prefs.grayscale, 0.5);
      expect(prefs.invertColors, isTrue);
      expect(prefs.highContrast, isFalse);
      expect(prefs.textScaleFactor, 1.75);
      expect(prefs.colorBlindnessProfile, ColorBlindnessProfile.tritanopia);
      expect(prefs.blueLightFilter, 0.5);
      expect(prefs.legibleFont, isTrue);
      expect(prefs.wideTextSpacing, isTrue);
      expect(prefs.creamBackground, isTrue);
      expect(prefs.lineHeight, 1.75);
      expect(prefs.reduceMotion, isTrue);
      expect(prefs.isDefault, isFalse);
    });

    test('kapsam dışı seviyeler sıkıştırılır', () {
      final prefs = AccessibilityPreferences({
        AccessibilityFeature.zoom: 9,
        AccessibilityFeature.grayscale: -2,
      });
      expect(prefs.level(AccessibilityFeature.zoom), 4);
      expect(prefs.textScaleFactor, AppSettings.maxTextScale);
      expect(prefs.level(AccessibilityFeature.grayscale), 0);
    });
  });
}
