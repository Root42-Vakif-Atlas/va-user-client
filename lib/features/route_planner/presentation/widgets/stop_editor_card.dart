import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/l10n/measure_format.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/route_plan.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/travel_route.dart';
import 'package:vakif_atlas/features/route_planner/presentation/route_presentation.dart';
import 'package:vakif_atlas/features/route_planner/presentation/widgets/duration_stepper.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';

/// Oluşturucudaki durak: sıra, eser, ziyaret süresi ve molalar.
///
/// Sürükle-bırak tutamacına ek olarak yukarı/aşağı butonları sunulur
/// (WCAG 2.5.7 Sürükleme Hareketleri); ekran okuyucu bu butonları kullanır.
class StopEditorCard extends StatelessWidget {
  const StopEditorCard({
    required this.index,
    required this.count,
    required this.stop,
    required this.monument,
    required this.onMoveUp,
    required this.onMoveDown,
    required this.onRemove,
    required this.onVisitChanged,
    required this.onAddBreak,
    required this.onBreakChanged,
    required this.onBreakRemoved,
    this.straightLineToNextMeters,
    this.nextLeg,
    super.key,
  });

  final int index;
  final int count;
  final RouteStopPlan stop;

  /// Katalog yüklenmediyse `null` (kimlik gösterilir).
  final MonumentPin? monument;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;
  final VoidCallback onRemove;
  final ValueChanged<Duration> onVisitChanged;
  final VoidCallback onAddBreak;
  final void Function(int breakIndex, Duration duration) onBreakChanged;
  final ValueChanged<int> onBreakRemoved;

  /// Ön hesap yoksa (bekleniyor, bağlantı yok) gösterilir.
  final double? straightLineToNextMeters;

  /// Sonraki durağa karayolu (bizim OSRM); varsa kuş uçuşunun yerine geçer.
  final RouteLeg? nextLeg;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final name = monument?.name ?? stop.monumentId;
    final distance = straightLineToNextMeters;
    final leg = nextLeg;
    final toNext = leg != null
        ? l10n.routeRoadToNext(
            l10n.distance(leg.distanceMeters),
            l10n.durationShort(leg.duration),
          )
        : distance != null
        ? l10n.routeStraightLineToNext(l10n.distance(distance))
        : null;
    final canAddBreak = stop.breaks.length < RoutePlanRules.maxBreaksPerStop;

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
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _OrderBadge(number: index + 1),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        name,
                        role: AppTextRole.titleMedium,
                        isHeading: true,
                      ),
                      if (monument case final value?)
                        AppText(
                          l10n.monumentLocation(value.district, value.city),
                          role: AppTextRole.bodySmall,
                        ),
                    ],
                  ),
                ),
                // Sürükleme tutamacı; ekran okuyucu yukarı/aşağı butonlarını
                // kullanır.
                ExcludeSemantics(
                  child: ReorderableDragStartListener(
                    index: index,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      child: AppIcon.decorative(
                        Icons.drag_indicator,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                DurationStepper(
                  key: Key('route_stop_visit_$index'),
                  label: l10n.routeVisitDuration,
                  value: stop.visit,
                  min: RoutePlanRules.minVisit,
                  max: RoutePlanRules.maxVisit,
                  onChanged: onVisitChanged,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      key: Key('route_stop_up_$index'),
                      tooltip: l10n.routeMoveUp(name),
                      icon: const Icon(Icons.arrow_upward),
                      onPressed: index > 0 ? onMoveUp : null,
                    ),
                    IconButton(
                      key: Key('route_stop_down_$index'),
                      tooltip: l10n.routeMoveDown(name),
                      icon: const Icon(Icons.arrow_downward),
                      onPressed: index < count - 1 ? onMoveDown : null,
                    ),
                    IconButton(
                      key: Key('route_stop_remove_$index'),
                      tooltip: l10n.routeRemoveStop(name),
                      icon: const Icon(Icons.delete_outlined),
                      onPressed: onRemove,
                    ),
                  ],
                ),
              ],
            ),
            for (
              var breakIndex = 0;
              breakIndex < stop.breaks.length;
              breakIndex++
            )
              _BreakEditor(
                key: Key('route_stop_${index}_break_$breakIndex'),
                pause: stop.breaks[breakIndex],
                onChanged: (duration) => onBreakChanged(breakIndex, duration),
                onRemove: () => onBreakRemoved(breakIndex),
              ),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: canAddBreak
                  ? TextButton.icon(
                      key: Key('route_stop_add_break_$index'),
                      onPressed: onAddBreak,
                      icon: const Icon(Icons.add),
                      label: Text(l10n.routeAddBreak),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(AppSpacing.xs),
                      child: AppText(
                        l10n.routeBreakLimit(RoutePlanRules.maxBreaksPerStop),
                        role: AppTextRole.bodySmall,
                      ),
                    ),
            ),
            if (toNext != null) ...[
              const Divider(),
              Row(
                children: [
                  AppIcon.decorative(
                    Icons.south,
                    size: AppSizes.iconSm,
                    color: colors.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: AppText(
                      toNext,
                      key: Key('route_stop_next_$index'),
                      role: AppTextRole.bodySmall,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _OrderBadge extends StatelessWidget {
  const _OrderBadge({required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      constraints: const BoxConstraints(
        minWidth: AppSizes.iconLg,
        minHeight: AppSizes.iconLg,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        '$number',
        style: context.textStyles.labelLarge.copyWith(color: colors.onPrimary),
      ),
    );
  }
}

class _BreakEditor extends StatelessWidget {
  const _BreakEditor({
    required this.pause,
    required this.onChanged,
    required this.onRemove,
    super.key,
  });

  final RouteBreak pause;
  final ValueChanged<Duration> onChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final kind = pause.kind.label(l10n);
    // Tür + kaldır üst satırda, süre ayarlayıcı altında: dar ekranda ve
    // %200 metinde kaldır butonu tek başına satıra düşmez.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(width: AppSpacing.sm),
            AppIcon.decorative(pause.kind.icon, color: colors.accentText),
            const SizedBox(width: AppSpacing.xs),
            Expanded(child: AppText(kind, role: AppTextRole.labelLarge)),
            IconButton(
              tooltip: l10n.routeRemoveBreak(kind),
              icon: const Icon(Icons.close),
              onPressed: onRemove,
            ),
          ],
        ),
        DurationStepper(
          label: kind,
          value: pause.duration,
          min: RoutePlanRules.minBreak,
          max: RoutePlanRules.maxBreak,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
