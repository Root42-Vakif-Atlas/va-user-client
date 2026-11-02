import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/l10n/measure_format.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/route_plan.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';

/// 15 dakikalık adımlarla süre ayarlayıcı (− değer +).
///
/// Ekran okuyucuya ayarlanabilir öğe olarak sunulur: değer uzun biçimde
/// okunur, yukarı/aşağı kaydırma hareketiyle de artırılıp azaltılır.
class DurationStepper extends StatelessWidget {
  const DurationStepper({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    super.key,
  });

  final String label;
  final Duration value;
  final Duration min;
  final Duration max;
  final ValueChanged<Duration> onChanged;

  static const Duration _step = RoutePlanRules.durationStep;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final canDecrease = value > min;
    final canIncrease = value < max;
    void decrease() => onChanged(value - _step);
    void increase() => onChanged(value + _step);

    return Semantics(
      container: true,
      label: label,
      value: l10n.durationLong(value),
      increasedValue: canIncrease ? l10n.durationLong(value + _step) : null,
      decreasedValue: canDecrease ? l10n.durationLong(value - _step) : null,
      onIncrease: canIncrease ? increase : null,
      onDecrease: canDecrease ? decrease : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: l10n.routeDurationDecrease(label),
            icon: const Icon(Icons.remove_circle_outlined),
            onPressed: canDecrease ? decrease : null,
          ),
          ExcludeSemantics(
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: AppSpacing.x4l),
              child: AppText(
                l10n.durationShort(value),
                role: AppTextRole.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          IconButton(
            tooltip: l10n.routeDurationIncrease(label),
            icon: const Icon(Icons.add_circle_outline),
            onPressed: canIncrease ? increase : null,
          ),
        ],
      ),
    );
  }
}
