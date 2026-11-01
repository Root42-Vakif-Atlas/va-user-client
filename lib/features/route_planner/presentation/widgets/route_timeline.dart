import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/l10n/measure_format.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/catalog/presentation/catalog_presentation.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/route_plan.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/travel_route.dart';
import 'package:vakif_atlas/features/route_planner/presentation/route_presentation.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';

/// Rotanın ekran okuyucu dostu adım adım anlatımı (TRD §10.D):
/// durak → ziyaret → molalar → sonraki durağa yolculuk.
///
/// Haritadaki çizginin metin karşılığıdır (WCAG 1.1.1); her satır kendi
/// başına anlamlı bir semantik etiket taşır.
class RouteTimeline extends StatelessWidget {
  const RouteTimeline({required this.route, super.key});

  final TravelRoute route;

  @override
  Widget build(BuildContext context) {
    final stops = route.stops;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < stops.length; index++) ...[
          _StopRow(index: index, count: stops.length, stop: stops[index]),
          for (final pause in stops[index].breaks) _BreakRow(pause: pause),
          if (index < route.legs.length)
            _LegRow(leg: route.legs[index], next: stops[index + 1]),
        ],
      ],
    );
  }
}

/// Satırları dikey çizgiyle bağlayan sol sütun.
class _Rail extends StatelessWidget {
  const _Rail({required this.child, this.showLine = true});

  final Widget child;
  final bool showLine;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      width: AppSizes.minTouchTarget,
      child: Column(
        children: [
          child,
          if (showLine)
            Expanded(
              child: VerticalDivider(
                width: AppSizes.borderThick,
                thickness: AppSizes.borderThick,
                color: colors.outlineVariant,
              ),
            ),
        ],
      ),
    );
  }
}

class _StopRow extends StatelessWidget {
  const _StopRow({
    required this.index,
    required this.count,
    required this.stop,
  });

  final int index;
  final int count;
  final RouteStop stop;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final location = l10n.monumentLocation(stop.district, stop.city);
    return Semantics(
      key: Key('route_step_stop_$index'),
      container: true,
      label: l10n.routeStopSemantics(
        index + 1,
        count,
        stop.name,
        location,
        l10n.durationLong(stop.visit),
      ),
      excludeSemantics: true,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Rail(
              showLine: index < count - 1 || stop.breaks.isNotEmpty,
              child: Container(
                width: AppSizes.iconLg,
                height: AppSizes.iconLg,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  '${index + 1}',
                  style: context.textStyles.labelLarge.copyWith(
                    color: colors.onPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AppIcon.decorative(
                          stop.category.icon,
                          size: AppSizes.iconInline,
                          color: colors.accentText,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: AppText(
                            stop.name,
                            role: AppTextRole.titleMedium,
                          ),
                        ),
                      ],
                    ),
                    AppText(
                      location,
                      role: AppTextRole.bodyMedium,
                      color: colors.onSurfaceVariant,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    AppText(
                      l10n.routeVisitLabel(l10n.durationShort(stop.visit)),
                      role: AppTextRole.labelLarge,
                      color: colors.accentText,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BreakRow extends StatelessWidget {
  const _BreakRow({required this.pause});

  final RouteBreak pause;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final kind = pause.kind.label(l10n);
    return Semantics(
      container: true,
      label: l10n.routeBreakSemantics(kind, l10n.durationLong(pause.duration)),
      excludeSemantics: true,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Rail(
              child: AppIcon.decorative(
                pause.kind.icon,
                size: AppSizes.iconInline,
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: AppText(
                  l10n.routeBreakLabel(
                    kind,
                    l10n.durationShort(pause.duration),
                  ),
                  role: AppTextRole.bodyMedium,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegRow extends StatelessWidget {
  const _LegRow({required this.leg, required this.next});

  final RouteLeg leg;
  final RouteStop next;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final distance = l10n.distance(leg.distanceMeters);
    return Semantics(
      container: true,
      label: l10n.routeLegSemantics(
        next.name,
        distance,
        l10n.durationLong(leg.duration),
      ),
      excludeSemantics: true,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Rail(
              child: AppIcon.decorative(
                Icons.directions_car_outlined,
                size: AppSizes.iconInline,
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: AppText(
                  l10n.routeLegLabel(
                    distance,
                    l10n.durationShort(leg.duration),
                  ),
                  role: AppTextRole.bodyMedium,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
