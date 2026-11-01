import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/auth/domain/entities/user_entity.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/molecules/account_avatar.dart';

/// Haritadaki profil görselinin açtığı hesap menüsü: kimlik özeti,
/// profil veya giriş ve ayarlar.
///
/// Ayarlar (tema, dil, izinler, erişilebilirlik) misafirler için de buradan
/// erişilebilir.
class AccountMenuSheet extends StatelessWidget {
  const AccountMenuSheet({
    required this.user,
    required this.onOpenProfile,
    required this.onSignIn,
    required this.onOpenSettings,
    super.key,
  });

  /// `null` → misafir.
  final UserEntity? user;
  final VoidCallback onOpenProfile;
  final VoidCallback onSignIn;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final user = this.user;
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                0,
                AppSpacing.md,
                AppSpacing.md,
              ),
              child: Row(
                children: [
                  AccountAvatar(
                    displayName: user?.displayName,
                    size: AppSizes.avatarLarge,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          user?.displayName ?? l10n.accountMenuGuestTitle,
                          role: AppTextRole.titleLarge,
                          isHeading: true,
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        AppText(
                          user?.email ?? l10n.accountMenuGuestBody,
                          role: AppTextRole.bodyMedium,
                          color: colors.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 0),
            if (user != null)
              ListTile(
                key: const Key('account_menu_profile'),
                leading: const Icon(Icons.person_outline),
                title: Text(l10n.accountMenuProfile),
                trailing: const Icon(Icons.chevron_right),
                onTap: onOpenProfile,
              )
            else
              ListTile(
                key: const Key('account_menu_sign_in'),
                leading: const Icon(Icons.login),
                title: Text(l10n.accountMenuSignIn),
                trailing: const Icon(Icons.chevron_right),
                onTap: onSignIn,
              ),
            ListTile(
              key: const Key('account_menu_settings'),
              leading: const Icon(Icons.settings_outlined),
              title: Text(l10n.settingsTitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: onOpenSettings,
            ),
          ],
        ),
      ),
    );
  }
}
