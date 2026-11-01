import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vakif_atlas/core/storage/preferences_service.dart';
import 'package:vakif_atlas/core/theme/color_blindness_profile.dart';
import 'package:vakif_atlas/core/theme/theme_preference.dart';

Future<PreferencesService> _service([
  Map<String, Object> values = const {},
]) async {
  SharedPreferences.setMockInitialValues(values);
  return PreferencesService(await SharedPreferences.getInstance());
}

void main() {
  test(
    'varsayılanlar: sistem teması, kontrast kapalı, cihaz dili, filtre yok',
    () async {
      final service = await _service();

      expect(service.themePreference, ThemePreference.system);
      expect(service.highContrast, isFalse);
      expect(service.languageCode, isNull);
      expect(service.colorBlindnessProfile, ColorBlindnessProfile.none);
      expect(service.textScaleFactor, 1.0);
      expect(service.reduceMotion, isFalse);
      expect(service.hapticFeedback, isTrue);
      expect(service.onboardingVersion, isNull);
    },
  );

  test('tema, dil ve erişilebilirlik tercihleri yazılır ve okunur', () async {
    final service = await _service();

    await service.setThemePreference(ThemePreference.light);
    await service.setHighContrast(enabled: true);
    await service.setLanguageCode('en');
    await service.setColorBlindnessProfile(ColorBlindnessProfile.tritanopia);
    await service.setTextScaleFactor(1.5);
    await service.setReduceMotion(enabled: true);
    await service.setHapticFeedback(enabled: false);
    await service.setOnboardingVersion(1);

    expect(service.reduceMotion, isTrue);
    expect(service.hapticFeedback, isFalse);
    expect(service.onboardingVersion, 1);
    expect(service.themePreference, ThemePreference.light);
    expect(service.highContrast, isTrue);
    expect(service.languageCode, 'en');
    expect(service.colorBlindnessProfile, ColorBlindnessProfile.tritanopia);
    expect(service.textScaleFactor, 1.5);
  });

  test('tercihler yeni örnekte (uygulama yeniden açılışı) korunur', () async {
    final first = await _service();
    await first.setThemePreference(ThemePreference.system);
    await first.setLanguageCode('tr');

    final reopened = PreferencesService(await SharedPreferences.getInstance());

    expect(reopened.themePreference, ThemePreference.system);
    expect(reopened.languageCode, 'tr');
  });

  test('dil kodu null verilince cihaz diline döner', () async {
    final service = await _service({'settings.language_code': 'en'});

    await service.setLanguageCode(null);

    expect(service.languageCode, isNull);
  });

  test('metin ölçeği 1.0–2.0 aralığına sıkıştırılır', () async {
    final service = await _service({'settings.text_scale': 3.5});
    expect(service.textScaleFactor, 2.0);

    await service.setTextScaleFactor(0.5);
    expect(service.textScaleFactor, 1.0);
  });

  test('bilinmeyen enum değeri varsayılana düşer', () async {
    final service = await _service({
      'settings.theme': 'neon',
      'settings.color_blindness': 'unknown',
    });

    expect(service.themePreference, ThemePreference.system);
    expect(service.colorBlindnessProfile, ColorBlindnessProfile.none);
  });
}
