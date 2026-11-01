import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/exceptions.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/storage/preferences_service.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/settings/domain/entities/accessibility_preferences.dart';
import 'package:vakif_atlas/features/settings/domain/entities/app_settings.dart';
import 'package:vakif_atlas/features/settings/domain/repositories/settings_repository.dart';

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._preferences);

  final PreferencesService _preferences;

  @override
  AppSettings load() {
    return AppSettings(
      themePreference: _preferences.themePreference,
      languageCode: _preferences.languageCode,
      accessibility: _loadAccessibility(),
      showAccessibilityButton: _preferences.showAccessibilityButton,
    );
  }

  /// Panel kaydı yoksa eski sürümün ayrı anahtarlarından geçiş yapılır
  /// (yüksek kontrast, renk profili, metin ölçeği, hareket, titreşim).
  AccessibilityPreferences _loadAccessibility() {
    final stored = _preferences.accessibilityLevels;
    if (stored != null) {
      return AccessibilityPreferences({
        for (final feature in AccessibilityFeature.values)
          feature: ?stored[feature.name],
      });
    }
    return AccessibilityPreferences({
      AccessibilityFeature.contrast: _preferences.highContrast ? 1 : 0,
      AccessibilityFeature.colorBlindness:
          _preferences.colorBlindnessProfile.index,
      AccessibilityFeature.zoom: ((_preferences.textScaleFactor - 1) / 0.25)
          .round(),
      AccessibilityFeature.stopAnimations: _preferences.reduceMotion ? 1 : 0,
      AccessibilityFeature.haptics: _preferences.hapticFeedback ? 1 : 0,
    });
  }

  @override
  ResultFuture<Unit> save(AppSettings settings) async {
    try {
      await _preferences.setThemePreference(settings.themePreference);
      await _preferences.setLanguageCode(settings.languageCode);
      await _preferences.setShowAccessibilityButton(
        visible: settings.showAccessibilityButton,
      );
      await _preferences.setAccessibilityLevels({
        for (final MapEntry(:key, :value)
            in settings.accessibility.levels.entries)
          key.name: value,
      });
      return const Right(unit);
    } on CacheException {
      return const Left(CacheFailure());
    }
  }
}
