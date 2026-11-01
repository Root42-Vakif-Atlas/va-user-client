import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';

/// İzin kartlarının ortak yerleşimi: amaç, durum ve tek eylem.
///
/// Durum ikon + metinle gösterilir (WCAG 1.4.1) ve canlı bölgedir; izin
/// penceresinden veya sistem ayarlarından dönüldüğünde yeni durum ekran
/// okuyucuyla okunur (WCAG 4.1.3).
class PermissionCardLayout extends StatelessWidget {
  const PermissionCardLayout({
    required this.icon,
    required this.title,
    required this.purpose,
    required this.statusIcon,
    required this.statusColor,
    required this.statusText,
    required this.statusKey,
    this.action,
    super.key,
  });

  final IconData icon;
  final String title;
  final String purpose;
  final IconData statusIcon;
  final Color statusColor;
  final String statusText;
  final Key statusKey;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final action = this.action;
    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surfaceElevated,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: colors.outlineVariant),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppIcon.decorative(icon, color: colors.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          title,
                          role: AppTextRole.titleMedium,
                          isHeading: true,
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        AppText(
                          purpose,
                          role: AppTextRole.bodyMedium,
                          color: colors.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Semantics(
                key: statusKey,
                container: true,
                liveRegion: true,
                label: l10n.permissionStatusSemantics(title, statusText),
                excludeSemantics: true,
                child: Row(
                  children: [
                    AppIcon.decorative(statusIcon, color: statusColor),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: AppText(statusText, role: AppTextRole.labelLarge),
                    ),
                  ],
                ),
              ),
              if (action != null) ...[
                const SizedBox(height: AppSpacing.sm),
                action,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
