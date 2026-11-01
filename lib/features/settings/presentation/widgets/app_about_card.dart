import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/launch_colors.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/atoms/brand_emblem.dart';

/// Ayarlar → Hakkında başlığı: uygulama simgesi, ad, sürüm, kısa kurumsal
/// mesaj ve geliştirici. Ekran okuyucu tek parça okur.
class AppAboutCard extends StatelessWidget {
  const AppAboutCard({required this.version, super.key});

  /// Görünen sürüm (ör. "1.0.0 (42)").
  final String version;

  /// Uygulama simgesiyle aynı kare (marka zemini + amblem).
  static Widget appIcon({double size = AppSizes.aboutIcon}) =>
      _AppIcon(size: size);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Padding(
      key: const Key('settings_about_card'),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.xs,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: MergeSemantics(
        child: Column(
          children: [
            appIcon(),
            const SizedBox(height: AppSpacing.sm),
            AppText(
              l10n.appTitle,
              role: AppTextRole.titleLarge,
              textAlign: TextAlign.center,
            ),
            AppText(
              l10n.aboutVersion(version),
              key: const Key('settings_about_version'),
              role: AppTextRole.bodyMedium,
              color: colors.onSurfaceVariant,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            AppText(
              l10n.aboutMission,
              role: AppTextRole.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            AppText(
              l10n.aboutDeveloper,
              role: AppTextRole.bodySmall,
              color: colors.onSurfaceVariant,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Koyu temada marka zemini sayfa zeminine yakın olduğundan simge ince
/// kenarlıkla ayrışır.
class _AppIcon extends StatelessWidget {
  const _AppIcon({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: LaunchColors.background,
      borderRadius: BorderRadius.circular(size * 0.22),
      border: Border.all(color: context.colors.outlineVariant),
    ),
    alignment: Alignment.center,
    child: BrandEmblem(
      size: size * 0.66,
      frameColor: LaunchColors.foreground,
      accentColor: LaunchColors.accent,
    ),
  );
}
