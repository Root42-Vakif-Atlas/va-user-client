import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/atoms/diamond_divider.dart';

/// Vatandaş profili.
///
/// Seviye ve rozet bölümü ([progressSection]) ile "Anılarım" ([memoriesSection])
/// profil bu özelliklere bağımlı olmasın diye kompozisyon kökünde kurulur.
class ProfilePage extends StatelessWidget {
  const ProfilePage({
    required this.onOpenSettings,
    required this.onOpenExports,
    required this.onChangePassword,
    required this.onDeleteAccount,
    required this.onLogoutConfirmed,
    this.progressSection,
    this.memoriesSection,
    super.key,
  });

  /// Seviye, XP ve son rozetler; `null` ise gösterilmez.
  final Widget? progressSection;

  /// Kullanıcının paylaştığı anılar; `null` ise gösterilmez.
  final Widget? memoriesSection;

  final VoidCallback onOpenSettings;

  /// "Dışa aktarımlarım": rota PDF'leri.
  final VoidCallback onOpenExports;
  final VoidCallback onChangePassword;
  final VoidCallback onDeleteAccount;

  /// Kullanıcı çıkışı onayladığında çağrılır.
  final VoidCallback onLogoutConfirmed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final user = switch (context.watch<AuthBloc>().state) {
      AuthAuthenticated(:final user) => user,
      AuthUnknown() || AuthGuest() => null,
    };

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSizes.maxContentWidth,
            ),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                if (user != null) ...[
                  AppText(
                    user.displayName,
                    role: AppTextRole.headlineLarge,
                    isHeading: true,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  AppText(
                    l10n.profileEmailValue(user.email),
                    color: context.colors.onSurfaceVariant,
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                const DiamondDivider(),
                const SizedBox(height: AppSpacing.md),
                if (progressSection case final section?) ...[
                  section,
                  const SizedBox(height: AppSpacing.md),
                ],
                if (memoriesSection case final section?) ...[
                  section,
                  const SizedBox(height: AppSpacing.md),
                ],
                ListTile(
                  key: const Key('profile_exports_tile'),
                  leading: const Icon(Icons.picture_as_pdf_outlined),
                  title: Text(l10n.routeExportsTitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: onOpenExports,
                ),
                ListTile(
                  key: const Key('profile_settings_tile'),
                  leading: const Icon(Icons.settings_outlined),
                  title: Text(l10n.settingsTitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: onOpenSettings,
                ),
                const SizedBox(height: AppSpacing.md),
                AppText(
                  l10n.profileSecuritySection,
                  role: AppTextRole.titleMedium,
                  color: context.colors.accentText,
                  isHeading: true,
                ),
                ListTile(
                  key: const Key('profile_change_password_tile'),
                  leading: const Icon(Icons.password),
                  title: Text(l10n.changePasswordTitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: onChangePassword,
                ),
                ListTile(
                  key: const Key('profile_delete_account_tile'),
                  leading: Icon(
                    Icons.delete_forever_outlined,
                    color: context.colors.error,
                  ),
                  title: Text(l10n.deleteAccountTitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: onDeleteAccount,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton.destructive(
                  key: const Key('profile_logout_button'),
                  label: l10n.profileLogout,
                  icon: Icons.logout,
                  expand: true,
                  onPressed: () => _confirmLogout(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.profileLogoutConfirmTitle),
        content: Text(l10n.profileLogoutConfirmBody),
        actions: [
          AppButton.secondary(
            label: l10n.commonCancel,
            onPressed: () => Navigator.of(dialogContext).pop(false),
          ),
          AppButton.destructive(
            key: const Key('profile_logout_confirm_button'),
            label: l10n.profileLogout,
            onPressed: () => Navigator.of(dialogContext).pop(true),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      onLogoutConfirmed();
    }
  }
}
