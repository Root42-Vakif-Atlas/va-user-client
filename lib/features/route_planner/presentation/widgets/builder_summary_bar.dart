import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/l10n/measure_format.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/molecules/inline_message.dart';
import 'package:vakif_atlas/shared/widgets/templates/bottom_action_bar.dart';

/// Oluşturucunun altında sabit duran ön özet ve gönderim butonu.
///
/// Karayolu ön hesabı ([roadMeters], [travel]; bizim OSRM) geldiyse karayolu
/// mesafe ve yolculuk süresi, gelmediyse kuş uçuşu mesafe; ayrıca ziyaret ve
/// mola toplamları gösterilir.
class BuilderSummaryBar extends StatelessWidget {
  const BuilderSummaryBar({
    required this.stopCount,
    required this.straightLineMeters,
    required this.visitTotal,
    required this.breakTotal,
    required this.isEditing,
    required this.isSubmitting,
    required this.onSubmit,
    this.roadMeters,
    this.travel,
    this.errorMessage,
    super.key,
  });

  final int stopCount;
  final double straightLineMeters;
  final int? roadMeters;
  final Duration? travel;
  final Duration visitTotal;
  final Duration breakTotal;
  final bool isEditing;
  final bool isSubmitting;
  final VoidCallback onSubmit;

  /// Doğrulama veya kaydetme hatası.
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final error = errorMessage;
    final road = roadMeters;
    final driving = travel;
    return BottomActionBar(
      header: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (error != null) ...[
            InlineMessage(
              key: const Key('route_builder_error'),
              message: error,
              type: InlineMessageType.error,
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          AppText(
            road != null && driving != null
                ? l10n.routeBuilderRoadSummary(
                    l10n.routeStopCount(stopCount),
                    l10n.distance(road),
                    l10n.durationShort(driving),
                  )
                : l10n.routeBuilderSummary(
                    l10n.routeStopCount(stopCount),
                    l10n.distance(straightLineMeters),
                  ),
            key: const Key('route_builder_summary'),
            role: AppTextRole.titleMedium,
          ),
          AppText(
            l10n.routeBuilderTimes(
              l10n.durationShort(visitTotal),
              l10n.durationShort(breakTotal),
            ),
            role: AppTextRole.bodyMedium,
            color: colors.onSurfaceVariant,
          ),
        ],
      ),
      primary: AppButton.primary(
        key: const Key('route_submit_button'),
        label: isEditing ? l10n.routeSaveChanges : l10n.routeCreate,
        icon: Icons.check,
        isLoading: isSubmitting,
        expand: true,
        onPressed: isSubmitting ? null : onSubmit,
      ),
    );
  }
}
