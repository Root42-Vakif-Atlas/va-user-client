import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/l10n/measure_format.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/route_plan.dart';
import 'package:vakif_atlas/features/route_planner/presentation/route_presentation.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';

/// Mola türü seçimi; seçilen tür önerilen süresiyle eklenir.
class BreakPickerSheet extends StatelessWidget {
  const BreakPickerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: AppText(
              l10n.routeBreakPickerTitle,
              role: AppTextRole.headlineMedium,
              isHeading: true,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          for (final kind in RouteBreakKind.values)
            ListTile(
              key: Key('route_break_kind_${kind.name}'),
              leading: AppIcon.decorative(kind.icon, color: colors.accentText),
              title: Text(kind.label(l10n)),
              subtitle: Text(
                l10n.routeBreakPickerDefault(
                  l10n.durationShort(kind.defaultDuration),
                ),
              ),
              onTap: () => Navigator.of(context).pop(kind),
            ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}
