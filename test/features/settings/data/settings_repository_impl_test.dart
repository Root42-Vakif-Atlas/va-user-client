import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vakif_atlas/core/error/exceptions.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/storage/preferences_service.dart';
import 'package:vakif_atlas/core/theme/color_blindness_profile.dart';
import 'package:vakif_atlas/core/theme/theme_preference.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:vakif_atlas/features/settings/domain/entities/accessibility_preferences.dart';
import 'package:vakif_atlas/features/settings/domain/entities/app_settings.dart';

class _MockPreferences extends Mock implements PreferencesService {}

void main() {
  test('kaydedilen ayarlar yeni oturumda aynen yüklenir', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = PreferencesService(
      await SharedPreferences.getInstance(),
    );
    final repository = SettingsRepositoryImpl(preferences);
    final settings = AppSettings(
      themePreference: ThemePreference.light,
      languageCode: 'en',
      accessibility: AccessibilityPreferences({
        for (final feature in AccessibilityFeature.values)
          feature: feature.levels,
      }).withLevel(AccessibilityFeature.haptics, 0),
      showAccessibilityButton: false,
    );

    final result = await repository.save(settings);

    expect(result, const Right<Failure, Unit>(unit));
    final reloaded = SettingsRepositoryImpl(
      PreferencesService(await SharedPreferences.getInstance()),
    ).load();
    expect(reloaded, settings);
  });

  test(
    'panel kaydı yokken eski sürümün ayrı anahtarlarından geçilir',
    () async {
      SharedPreferences.setMockInitialValues({
        'settings.high_contrast': true,
        'settings.color_blindness': 'deuteranopia',
        'settings.text_scale': 1.5,
        'settings.reduce_motion': true,
        'settings.haptic_feedback': false,
      });
      final repository = SettingsRepositoryImpl(
        PreferencesService(await SharedPreferences.getInstance()),
      );

      final a11y = repository.load().accessibility;

      expect(a11y.contrast, ContrastMode.auto);
      expect(a11y.colorBlindnessProfile, ColorBlindnessProfile.deuteranopia);
      expect(a11y.textScaleFactor, 1.5);
      expect(a11y.reduceMotion, isTrue);
      expect(a11y.hapticFeedback, isFalse);
    },
  );

  test('bozuk panel kaydı eski anahtarlara (varsayılanlara) düşer', () async {
    SharedPreferences.setMockInitialValues({
      'settings.accessibility.v1': '{bozuk',
    });
    final repository = SettingsRepositoryImpl(
      PreferencesService(await SharedPreferences.getInstance()),
    );

    expect(repository.load().accessibility.isDefault, isTrue);
  });

  test('yazma hatası CacheFailure olarak döner', () async {
    final preferences = _MockPreferences();
    when(() => preferences.setThemePreference(ThemePreference.system))
        .thenThrow(const CacheException('preferences.write'));

    final result = await SettingsRepositoryImpl(preferences)
        .save(AppSettings.defaults);

    expect(result, const Left<Failure, Unit>(CacheFailure()));
  });
}
