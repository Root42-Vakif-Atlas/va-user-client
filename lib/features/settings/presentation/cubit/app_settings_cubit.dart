import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/a11y/haptic_feedback_service.dart';
import 'package:vakif_atlas/core/theme/theme_preference.dart';
import 'package:vakif_atlas/features/settings/domain/entities/accessibility_preferences.dart';
import 'package:vakif_atlas/features/settings/domain/entities/app_settings.dart';
import 'package:vakif_atlas/features/settings/domain/usecases/get_app_settings_usecase.dart';
import 'package:vakif_atlas/features/settings/domain/usecases/save_app_settings_usecase.dart';
import 'package:vakif_atlas/features/settings/presentation/cubit/app_settings_state.dart';

/// Tema, dil ve erişilebilirlik tercihlerinin global durum yöneticisi.
///
/// Değişiklik anında uygulanır, ardından kalıcı olarak kaydedilir.
/// Titreşim tercihi [HapticFeedbackService]'e de yansıtılır.
@lazySingleton
class AppSettingsCubit extends Cubit<AppSettingsState> {
  AppSettingsCubit(
    GetAppSettingsUseCase getAppSettings,
    this._saveAppSettings,
    this._haptics,
  ) : super(AppSettingsState(settings: getAppSettings())) {
    _haptics.enabled = state.settings.hapticFeedback;
  }

  final SaveAppSettingsUseCase _saveAppSettings;
  final HapticFeedbackService _haptics;

  Future<void> setThemePreference(ThemePreference value) =>
      _update(state.settings.copyWith(themePreference: value));

  /// `null` → cihaz dili.
  Future<void> setLanguageCode(String? languageCode) =>
      _update(state.settings.copyWith(languageCode: languageCode));

  /// Haritadaki Erişilebilirlik butonunu gösterir / gizler.
  Future<void> setShowAccessibilityButton({required bool visible}) =>
      _update(state.settings.copyWith(showAccessibilityButton: visible));

  /// Erişilebilirlik panelindeki kutucuğu bir sonraki seviyeye geçirir
  /// (son seviyeden sonra kapalı). Titreşim açılırken tek bir seçim tıkıyla
  /// yeni durum hissettirilir.
  Future<void> cycleAccessibility(AccessibilityFeature feature) async {
    final next = state.settings.accessibility.cycle(feature);
    final update = _update(state.settings.copyWith(accessibility: next));
    if (feature == AccessibilityFeature.haptics && next.hapticFeedback) {
      await _haptics.selection();
    }
    await update;
  }

  Future<void> setAccessibilityLevel(AccessibilityFeature feature, int level) =>
      _update(
        state.settings.copyWith(
          accessibility: state.settings.accessibility.withLevel(feature, level),
        ),
      );

  /// Erişilebilirlik tercihlerini varsayılana döndürür (tema ve dil
  /// korunur). Geri almak için önceki ayarları döndürür.
  Future<AppSettings> resetAccessibility() async {
    final previous = state.settings;
    await _update(previous.withAccessibilityOf(AppSettings.defaults));
    return previous;
  }

  /// [resetAccessibility]'yi geri alır.
  Future<void> restoreAccessibility(AppSettings previous) =>
      _update(state.settings.withAccessibilityOf(previous));

  Future<void> _update(AppSettings next) async {
    if (next == state.settings) {
      return;
    }
    _haptics.enabled = next.hapticFeedback;
    emit(AppSettingsState(settings: next));
    final result = await _saveAppSettings(next);
    if (isClosed) {
      return;
    }
    result.fold(
      (failure) => emit(state.copyWith(saveFailure: failure)),
      (_) {},
    );
  }
}
