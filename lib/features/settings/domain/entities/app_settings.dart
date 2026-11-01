import 'package:vakif_atlas/core/theme/color_blindness_profile.dart';
import 'package:vakif_atlas/core/theme/theme_preference.dart';
import 'package:vakif_atlas/features/settings/domain/entities/accessibility_preferences.dart';

/// Kullanıcının uygulama, görünüm ve erişilebilirlik tercihleri.
final class AppSettings {
  const AppSettings({
    required this.themePreference,
    required this.languageCode,
    required this.accessibility,
    this.showAccessibilityButton = true,
  });

  /// İlk açılış değerleri: cihazın açık/koyu ayarı ve dili.
  static final AppSettings defaults = AppSettings(
    themePreference: ThemePreference.system,
    languageCode: null,
    accessibility: AccessibilityPreferences.defaults,
  );

  static const double minTextScale = 1;
  static const double maxTextScale = AccessibilityPreferences.maxTextScale;

  final ThemePreference themePreference;

  /// `null` → cihaz dili.
  final String? languageCode;

  /// Erişilebilirlik panelinin tüm tercihleri (tek yapılandırma noktası).
  final AccessibilityPreferences accessibility;

  /// Haritadaki Erişilebilirlik butonu gösterilir. Erişilebilirlik tercihi
  /// değildir (görünürlük ayarı): "Varsayılanlara dön" bunu değiştirmez.
  final bool showAccessibilityButton;

  // Kökte en sık okunan erişilebilirlik değerleri.
  bool get highContrast => accessibility.highContrast;

  ColorBlindnessProfile get colorBlindnessProfile =>
      accessibility.colorBlindnessProfile;

  double get textScaleFactor => accessibility.textScaleFactor;

  /// Cihazın "hareketi azalt" ayarına ek olarak uygulama içinde animasyonları
  /// kapatır (WCAG 2.3.3). Cihaz ayarı açıksa bu değerden bağımsız uygulanır.
  bool get reduceMotion => accessibility.reduceMotion;

  /// Durum titreşimleri (başarı, uyarı, hata, seçim).
  bool get hapticFeedback => accessibility.hapticFeedback;

  /// Erişilebilirlik tercihleri varsayılanda mı; tema ve dil hariç.
  bool get hasDefaultAccessibility => accessibility.isDefault;

  /// Erişilebilirlik tercihlerini [source]'takilerle değiştirir; tema ve dil
  /// korunur.
  AppSettings withAccessibilityOf(AppSettings source) =>
      copyWith(accessibility: source.accessibility);

  static const Object _unchanged = Object();

  /// [languageCode] için `null` geçmek cihaz diline döner; parametreyi hiç
  /// vermemek mevcut değeri korur.
  AppSettings copyWith({
    ThemePreference? themePreference,
    Object? languageCode = _unchanged,
    AccessibilityPreferences? accessibility,
    bool? showAccessibilityButton,
  }) {
    return AppSettings(
      themePreference: themePreference ?? this.themePreference,
      languageCode: identical(languageCode, _unchanged)
          ? this.languageCode
          : languageCode as String?,
      accessibility: accessibility ?? this.accessibility,
      showAccessibilityButton:
          showAccessibilityButton ?? this.showAccessibilityButton,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettings &&
          other.themePreference == themePreference &&
          other.languageCode == languageCode &&
          other.accessibility == accessibility &&
          other.showAccessibilityButton == showAccessibilityButton;

  @override
  int get hashCode => Object.hash(
    themePreference,
    languageCode,
    accessibility,
    showAccessibilityButton,
  );

  @override
  String toString() =>
      'AppSettings(theme: $themePreference, language: $languageCode, '
      'a11yButton: $showAccessibilityButton, $accessibility)';
}
