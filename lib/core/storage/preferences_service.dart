import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vakif_atlas/core/error/exceptions.dart';
import 'package:vakif_atlas/core/theme/color_blindness_profile.dart';
import 'package:vakif_atlas/core/theme/theme_preference.dart';

/// Hafif anahtar-değer kullanıcı tercihleri (TRD §10.B).
///
/// Değerler uygulama açılışında bir kez yüklenir ve senkron okunur.
/// Yazma hataları [CacheException] olarak fırlatılır.
@lazySingleton
class PreferencesService {
  PreferencesService(this._preferences);

  final SharedPreferences _preferences;

  static const String _themeKey = 'settings.theme';
  static const String _highContrastKey = 'settings.high_contrast';
  static const String _languageKey = 'settings.language_code';
  static const String _colorBlindnessKey = 'settings.color_blindness';
  static const String _textScaleKey = 'settings.text_scale';
  static const String _reduceMotionKey = 'settings.reduce_motion';
  static const String _hapticFeedbackKey = 'settings.haptic_feedback';
  static const String _accessibilityKey = 'settings.accessibility.v1';
  static const String _accessibilityButtonKey =
      'settings.show_accessibility_button';
  static const String _nearbyAlertsKey = 'settings.nearby_alerts';
  static const String _nearbyAlertLogKey = 'nearby_alerts.log.v1';
  static const String _onboardingVersionKey = 'onboarding.completed_version';
  static const String _installationIdKey = 'device.installation_id';

  /// İlk açılışta cihazın açık/koyu ayarı izlenir (platform kuralı).
  static const ThemePreference defaultTheme = ThemePreference.system;
  static const double minTextScale = 1;
  static const double maxTextScale = 2;

  ThemePreference get themePreference =>
      _enumByName(ThemePreference.values, _preferences.getString(_themeKey)) ??
      defaultTheme;

  /// Erişilebilirlik paneli seviyeleri (`özellik adı → seviye`). Hiç
  /// kaydedilmediyse veya bozuksa `null`: eski sürümün ayrı anahtarları
  /// ([highContrast], [colorBlindnessProfile], [textScaleFactor],
  /// [reduceMotion], [hapticFeedback]) okunarak geçiş yapılır.
  Map<String, int>? get accessibilityLevels {
    final raw = _preferences.getString(_accessibilityKey);
    if (raw == null) {
      return null;
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }
      return {
        for (final MapEntry(:key, :value) in decoded.entries)
          if (value is int) key: value,
      };
    } on FormatException {
      return null;
    }
  }

  /// Haritadaki Erişilebilirlik butonu; varsayılan görünür.
  bool get showAccessibilityButton =>
      _preferences.getBool(_accessibilityButtonKey) ?? true;

  Future<void> setShowAccessibilityButton({required bool visible}) =>
      _guard(() => _preferences.setBool(_accessibilityButtonKey, visible));

  /// Yakındaki eser bildirimleri; varsayılan kapalı (konum tabanlı
  /// bildirim açık rızayla açılır).
  bool get nearbyAlerts => _preferences.getBool(_nearbyAlertsKey) ?? false;

  Future<void> setNearbyAlerts({required bool enabled}) =>
      _guard(() => _preferences.setBool(_nearbyAlertsKey, enabled));

  /// Son yakınlık bildirimlerinin zamanları (`anahtar → epoch ms`). Yalnızca
  /// cihazda tutulur; kayıt yoksa veya bozuksa boş.
  Map<String, int> get nearbyAlertLog {
    final raw = _preferences.getString(_nearbyAlertLogKey);
    if (raw == null) {
      return const {};
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return const {};
      }
      return {
        for (final MapEntry(:key, :value) in decoded.entries)
          if (value is int) key: value,
      };
    } on FormatException {
      return const {};
    }
  }

  Future<void> setNearbyAlertLog(Map<String, int> log) =>
      _guard(() => _preferences.setString(_nearbyAlertLogKey, jsonEncode(log)));

  Future<void> setAccessibilityLevels(Map<String, int> levels) => _guard(
    () => _preferences.setString(_accessibilityKey, jsonEncode(levels)),
  );

  /// Eski sürüm (erişilebilirlik paneli öncesi) anahtarı; yalnızca geçişte
  /// okunur.
  bool get highContrast => _preferences.getBool(_highContrastKey) ?? false;

  /// `null` → cihaz dili kullanılır.
  String? get languageCode => _preferences.getString(_languageKey);

  ColorBlindnessProfile get colorBlindnessProfile =>
      _enumByName(
        ColorBlindnessProfile.values,
        _preferences.getString(_colorBlindnessKey),
      ) ??
      ColorBlindnessProfile.none;

  /// Uygulama içi metin ölçeği çarpanı (sistem ölçeğiyle çarpılır).
  double get textScaleFactor =>
      (_preferences.getDouble(_textScaleKey) ?? minTextScale).clamp(
        minTextScale,
        maxTextScale,
      );

  /// Cihaz ayarına ek olarak uygulama içinde hareketi azaltma.
  bool get reduceMotion => _preferences.getBool(_reduceMotionKey) ?? false;

  bool get hapticFeedback => _preferences.getBool(_hapticFeedbackKey) ?? true;

  /// Tamamlanan son tanıtım sürümü; hiç tamamlanmadıysa `null`.
  int? get onboardingVersion => _preferences.getInt(_onboardingVersionKey);

  Future<void> setOnboardingVersion(int version) =>
      _guard(() => _preferences.setInt(_onboardingVersionKey, version));

  /// Uygulama kurulumunun anonim kimliği (`InstallationIdService`).
  String? get installationId => _preferences.getString(_installationIdKey);

  Future<void> setInstallationId(String value) =>
      _guard(() => _preferences.setString(_installationIdKey, value));

  Future<void> setThemePreference(ThemePreference value) =>
      _guard(() => _preferences.setString(_themeKey, value.name));

  Future<void> setHighContrast({required bool enabled}) =>
      _guard(() => _preferences.setBool(_highContrastKey, enabled));

  Future<void> setLanguageCode(String? languageCode) => _guard(
    () => languageCode == null
        ? _preferences.remove(_languageKey)
        : _preferences.setString(_languageKey, languageCode),
  );

  Future<void> setColorBlindnessProfile(ColorBlindnessProfile value) =>
      _guard(() => _preferences.setString(_colorBlindnessKey, value.name));

  Future<void> setTextScaleFactor(double value) => _guard(
    () => _preferences.setDouble(
      _textScaleKey,
      value.clamp(minTextScale, maxTextScale),
    ),
  );

  Future<void> setReduceMotion({required bool enabled}) =>
      _guard(() => _preferences.setBool(_reduceMotionKey, enabled));

  Future<void> setHapticFeedback({required bool enabled}) =>
      _guard(() => _preferences.setBool(_hapticFeedbackKey, enabled));

  static Future<void> _guard(Future<bool> Function() write) async {
    final bool succeeded;
    try {
      succeeded = await write();
    } on Exception {
      throw const CacheException('preferences.write');
    }
    if (!succeeded) {
      throw const CacheException('preferences.write');
    }
  }

  static T? _enumByName<T extends Enum>(List<T> values, String? name) {
    for (final value in values) {
      if (value.name == name) {
        return value;
      }
    }
    return null;
  }
}
