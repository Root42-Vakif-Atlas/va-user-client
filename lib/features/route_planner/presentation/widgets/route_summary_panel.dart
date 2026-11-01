import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/l10n/measure_format.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/travel_route.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';

/// Rotanın süre ve mesafe dökümü: toplam süre öne çıkar, ardından
/// yolculuk, ziyaret, mola ve karayolu mesafesi.
class RouteSummaryPanel extends StatelessWidget {
  const RouteSummaryPanel({required this.summary, super.key});

  final RouteSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final metrics = [
      (Icons.directions_car_outlined, l10n.routeTravelTime, summary.travel),
      (Icons.account_balance_outlined, l10n.routeVisitTime, summary.visit),
      (Icons.local_cafe_outlined, l10n.routeBreakTime, summary.breaks),
    ];

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: colors.outlineVariant,
          width: AppSizes.borderThin,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              label: l10n.routeMetricSemantics(
                l10n.routeTotalDuration,
                l10n.durationLong(summary.total),
              ),
              excludeSemantics: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    l10n.routeTotalDuration,
                    role: AppTextRole.labelLarge,
                    color: colors.onSurfaceVariant,
                  ),
                  AppText(
                    l10n.durationShort(summary.total),
                    key: const Key('route_summary_total'),
                    role: AppTextRole.headlineMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.sm,
              children: [
                for (final (icon, label, duration) in metrics)
                  _Metric(
                    icon: icon,
                    label: label,
                    value: l10n.durationShort(duration),
                    semanticsValue: l10n.durationLong(duration),
                  ),
                _Metric(
                  icon: Icons.straighten,
                  label: l10n.routeDistance,
                  value: l10n.distance(summary.distanceMeters),
                  semanticsValue: l10n.distance(summary.distanceMeters),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            AppText(l10n.routeEstimateNote, role: AppTextRole.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.icon,
    required this.label,
    required this.value,
    required this.semanticsValue,
  });

  final IconData icon;
  final String label;
  final String value;
  final String semanticsValue;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      label: context.l10n.routeMetricSemantics(label, semanticsValue),
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIcon.decorative(
            icon,
            size: AppSizes.iconInline,
            color: colors.accentText,
          ),
          const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  label,
                  role: AppTextRole.labelMedium,
                  color: colors.onSurfaceVariant,
                ),
                AppText(value, role: AppTextRole.titleMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
