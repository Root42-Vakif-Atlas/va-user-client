import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/civil_protection/domain/entities/damage_report.dart';
import 'package:vakif_atlas/features/civil_protection/presentation/civil_protection_presentation.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';

/// Rapor durumu: ikon + metin; renk yalnızca destekleyicidir (WCAG 1.4.1).
/// Metin nötr yüzeyde ön plan renginde kalır (kontrast her temada ≥ 4.5:1).
class ReportStatusBadge extends StatelessWidget {
  const ReportStatusBadge({required this.status, super.key});

  final DamageReportStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.xs),
        border: Border(
          left: BorderSide(color: status.color(colors), width: AppSpacing.xxs),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon.decorative(
              status.icon,
              size: AppSizes.iconSm,
              color: status.color(colors),
            ),
            const SizedBox(width: AppSpacing.xxs),
            Flexible(
              child: AppText(
                status.label(context.l10n),
                role: AppTextRole.labelMedium,
                color: colors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Aciliyet: ikon + metin.
class ReportUrgencyLabel extends StatelessWidget {
  const ReportUrgencyLabel({required this.urgency, super.key});

  final ReportUrgency urgency;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppIcon.decorative(
          urgency.icon,
          size: AppSizes.iconSm,
          color: urgency.color(colors),
        ),
        const SizedBox(width: AppSpacing.xxs),
        Flexible(
          child: AppText(
            urgency.label(context.l10n),
            role: AppTextRole.bodyMedium,
          ),
        ),
      ],
    );
  }
}
