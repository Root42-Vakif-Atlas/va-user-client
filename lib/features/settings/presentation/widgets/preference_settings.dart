import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_preference.dart';
import 'package:vakif_atlas/features/settings/domain/entities/app_settings.dart';
import 'package:vakif_atlas/features/settings/presentation/cubit/app_settings_cubit.dart';
import 'package:vakif_atlas/features/settings/presentation/widgets/settings_radio_group.dart';
import 'package:vakif_atlas/shared/widgets/atoms/leading_icon_tile.dart';

// Ayarlar sayfası ve ilk açılış tanıtımı aynı tercih denetimlerini (tema,
// dil) kullanır; değişiklik `AppSettingsCubit` üzerinden anında uygulanır ve
// kaydedilir. Erişilebilirlik denetimleri yalnızca Erişilebilirlik
// sayfasındadır (`features/accessibility`).

T _select<T>(BuildContext context, T Function(AppSettings settings) pick) =>
    context.select<AppSettingsCubit, T>((cubit) => pick(cubit.state.settings));

class ThemeSetting extends StatelessWidget {
  const ThemeSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SettingsRadioGroup<ThemePreference>(
      keyPrefix: 'settings_theme',
      label: l10n.settingsThemeLabel,
      value: _select(context, (s) => s.themePreference),
      options: [
        (ThemePreference.system, l10n.themeSystem),
        (ThemePreference.light, l10n.themeLight),
        (ThemePreference.dark, l10n.themeDark),
      ],
      onChanged: context.read<AppSettingsCubit>().setThemePreference,
    );
  }
}

/// Haritadaki Erişilebilirlik butonunun görünürlüğü. Tercihlerini bir kez
/// ayarlayan kullanıcı butonu gizleyebilir; panel Ayarlar'dan açılmaya
/// devam eder.
class AccessibilityButtonSetting extends StatelessWidget {
  const AccessibilityButtonSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SwitchListTile(
      key: const Key('settings_show_accessibility_button_switch'),
      secondary: const LeadingIconTile(icon: Icons.map_outlined),
      title: Text(l10n.settingsShowAccessibilityButton),
      subtitle: Text(l10n.settingsShowAccessibilityButtonDescription),
      value: _select(context, (s) => s.showAccessibilityButton),
      onChanged: (visible) => context
          .read<AppSettingsCubit>()
          .setShowAccessibilityButton(visible: visible),
    );
  }
}

enum _LanguageOption {
  system(null),
  turkish('tr'),
  english('en');

  const _LanguageOption(this.code);

  final String? code;

  static _LanguageOption fromCode(String? code) =>
      values.firstWhere((option) => option.code == code, orElse: () => system);
}

class LanguageSetting extends StatelessWidget {
  const LanguageSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SettingsRadioGroup<_LanguageOption>(
      keyPrefix: 'settings_language',
      label: l10n.settingsLanguageLabel,
      value: _LanguageOption.fromCode(_select(context, (s) => s.languageCode)),
      options: [
        (_LanguageOption.system, l10n.languageSystem),
        (_LanguageOption.turkish, l10n.languageTurkish),
        (_LanguageOption.english, l10n.languageEnglish),
      ],
      onChanged: (option) =>
          context.read<AppSettingsCubit>().setLanguageCode(option.code),
    );
  }
}
