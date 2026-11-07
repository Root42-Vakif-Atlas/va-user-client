import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/nearby_alerts/presentation/cubit/nearby_alerts_cubit.dart';
import 'package:vakif_atlas/features/nearby_alerts/presentation/widgets/nearby_alerts_setting.dart';
import 'package:vakif_atlas/features/settings/presentation/cubit/app_settings_cubit.dart';
import 'package:vakif_atlas/features/settings/presentation/cubit/app_settings_state.dart';
import 'package:vakif_atlas/features/settings/presentation/widgets/app_about_card.dart';
import 'package:vakif_atlas/features/settings/presentation/widgets/permission_card_list.dart';
import 'package:vakif_atlas/features/settings/presentation/widgets/preference_settings.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/atoms/leading_icon_tile.dart';
import 'package:vakif_atlas/shared/widgets/molecules/grouped_section.dart';
import 'package:vakif_atlas/shared/widgets/molecules/section_header.dart';

/// Uygulama, görünüm (tema), dil ve izin ayarları.
///
/// Erişilebilirlik tercihleri burada değil, tek yapılandırma noktası olan
/// Erişilebilirlik sayfasındadır; buradaki satır yalnızca oraya götürür.
/// İlk açılış tanıtımında seçilen tercihler burada değiştirilir.
/// `LocationPermissionCubit` ve `DevicePermissionsCubit` üst ağaçtan
/// (router), `NearbyAlertsCubit` uygulama kökünden sağlanır.
class SettingsPage extends StatelessWidget {
  const SettingsPage({
    required this.onReplayOnboarding,
    required this.onOpenAccessibility,
    required this.onOpenPrivacyNotice,
    required this.onOpenTermsOfUse,
    required this.onOpenFeedback,
    required this.appVersion,
    super.key,
  });

  final VoidCallback onReplayOnboarding;
  final VoidCallback onOpenAccessibility;
  final VoidCallback onOpenPrivacyNotice;
  final VoidCallback onOpenTermsOfUse;
  final VoidCallback onOpenFeedback;

  /// Hakkında bölümünde gösterilen sürüm (ör. "1.0.0 (42)").
  final String appVersion;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: BlocListener<AppSettingsCubit, AppSettingsState>(
        listenWhen: (previous, current) =>
            current.saveFailure != null &&
            previous.saveFailure != current.saveFailure,
        listener: (context, state) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(l10n.settingsSaveFailed)));
        },
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSizes.maxContentWidth,
              ),
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  SectionHeader(l10n.settingsAppearanceSection),
                  const ThemeSetting(),
                  const SizedBox(height: AppSpacing.lg),
                  SectionHeader(l10n.settingsLanguageSection),
                  const LanguageSetting(),
                  const SizedBox(height: AppSpacing.lg),
                  SectionHeader(l10n.settingsAccessibilitySection),
                  const SizedBox(height: AppSpacing.xs),
                  GroupedSection(
                    children: [
                      ListTile(
                        key: const Key('settings_accessibility_tile'),
                        leading: const LeadingIconTile(
                          icon: Icons.accessibility_new_outlined,
                          tone: LeadingIconTone.primary,
                        ),
                        title: Text(l10n.accessibilityTitle),
                        subtitle: Text(l10n.settingsAccessibilityDescription),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: onOpenAccessibility,
                      ),
                      const AccessibilityButtonSetting(),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (context.read<NearbyAlertsCubit>().isSupported) ...[
                    SectionHeader(l10n.settingsNotificationsSection),
                    const SizedBox(height: AppSpacing.xs),
                    const NearbyAlertsSetting(),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                  SectionHeader(l10n.settingsPermissionsSection),
                  const SizedBox(height: AppSpacing.xs),
                  const PermissionCardList(),
                  const SizedBox(height: AppSpacing.sm),
                  AppText(
                    l10n.permissionOnDemandNote,
                    role: AppTextRole.bodyMedium,
                    color: context.colors.onSurfaceVariant,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SectionHeader(l10n.settingsAboutSection),
                  const SizedBox(height: AppSpacing.xs),
                  AppAboutCard(version: appVersion),
                  const SizedBox(height: AppSpacing.sm),
                  GroupedSection(
                    children: [
                      ListTile(
                        key: const Key('settings_feedback_tile'),
                        leading: const LeadingIconTile(
                          icon: Icons.rate_review_outlined,
                          tone: LeadingIconTone.heritage,
                        ),
                        title: Text(l10n.settingsFeedback),
                        subtitle: Text(l10n.settingsFeedbackSubtitle),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: onOpenFeedback,
                      ),
                      ListTile(
                        key: const Key('settings_replay_onboarding_tile'),
                        leading: const LeadingIconTile(
                          icon: Icons.school_outlined,
                        ),
                        title: Text(l10n.settingsReplayOnboarding),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: onReplayOnboarding,
                      ),
                      ListTile(
                        key: const Key('settings_privacy_notice_tile'),
                        leading: const LeadingIconTile(
                          icon: Icons.privacy_tip_outlined,
                          tone: LeadingIconTone.complex,
                        ),
                        title: Text(l10n.settingsPrivacyNotice),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: onOpenPrivacyNotice,
                      ),
                      ListTile(
                        key: const Key('settings_terms_tile'),
                        leading: const LeadingIconTile(
                          icon: Icons.gavel_outlined,
                          tone: LeadingIconTone.complex,
                        ),
                        title: Text(l10n.settingsTermsOfUse),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: onOpenTermsOfUse,
                      ),
                      ListTile(
                        key: const Key('settings_licenses_tile'),
                        leading: const LeadingIconTile(
                          icon: Icons.description_outlined,
                        ),
                        title: Text(l10n.settingsLicenses),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => showLicensePage(
                          context: context,
                          applicationName: l10n.appTitle,
                          applicationVersion: appVersion,
                          applicationIcon: Padding(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            child: AppAboutCard.appIcon(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
