import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/theme/theme_preference.dart';
import 'package:vakif_atlas/features/settings/domain/entities/app_settings.dart';

/// Domain tercihlerini Flutter tiplerine dönüştürür.
extension AppSettingsPresentation on AppSettings {
  ThemeMode get themeMode => switch (themePreference) {
    ThemePreference.system => ThemeMode.system,
    ThemePreference.light => ThemeMode.light,
    ThemePreference.dark => ThemeMode.dark,
  };

  /// `null` → `MaterialApp` cihaz dilini kullanır.
  Locale? get locale {
    final code = languageCode;
    return code == null ? null : Locale(code);
  }
}
