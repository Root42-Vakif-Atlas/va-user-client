import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/civil_protection/domain/entities/damage_report.dart';
import 'package:vakif_atlas/features/civil_protection/presentation/civil_protection_presentation.dart';
import 'package:vakif_atlas/features/civil_protection/presentation/widgets/report_badges.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';

/// "Bildirimlerim" satırı: eser, tür, kayıt numarası, durum ve tarih. Kartın
/// tamamı tek bir butondur.
class DamageReportCard extends StatelessWidget {
  const DamageReportCard({
    required this.report,
    required this.onTap,
    super.key,
  });

  final DamageReport report;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final date = ReportDates.day(l10n, report.updatedAt);
    return Semantics(
      button: true,
      label: l10n.cpReportItemSemantics(
        report.monument.name,
        report.category.label(l10n),
        report.referenceCode,
        report.status.label(l10n),
        date,
      ),
      onTap: onTap,
      excludeSemantics: true,
      child: Material(
        key: Key('damage_report_${report.id}'),
        color: colors.surfaceElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(
            color: colors.outlineVariant,
            width: AppSizes.borderThin,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: AppSizes.minTouchTarget,
                  height: AppSizes.minTouchTarget,
                  decoration: BoxDecoration(
                    color: colors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: AppIcon.decorative(
                    report.category.icon,
                    color: colors.accentText,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        report.monument.name,
                        role: AppTextRole.titleMedium,
                      ),
                      AppText(
                        report.category.label(l10n),
                        role: AppTextRole.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Wrap(
                        spacing: AppSpacing.xs,
                        runSpacing: AppSpacing.xxs,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          ReportStatusBadge(status: report.status),
                          AppText(
                            '${report.referenceCode} · $date',
                            role: AppTextRole.bodySmall,
                            color: colors.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                AppIcon.decorative(
                  Icons.chevron_right,
                  color: colors.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
