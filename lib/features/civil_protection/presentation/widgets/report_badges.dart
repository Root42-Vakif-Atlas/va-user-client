import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/civil_protection/domain/entities/damage_report.dart';
import 'package:vakif_atlas/features/civil_protection/presentation/civil_protection_presentation.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/atoms/status_badge.dart';

/// Rapor durumu: ikon + metin; renk yalnızca destekleyicidir (WCAG 1.4.1).
/// Ortak `StatusBadge` görünümü (kontrast her temada ≥ 4.5:1).
class ReportStatusBadge extends StatelessWidget {
  const ReportStatusBadge({required this.status, super.key});

  final DamageReportStatus status;

  @override
  Widget build(BuildContext context) {
    return StatusBadge(
      icon: status.icon,
      label: status.label(context.l10n),
      color: status.color(context.colors),
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
