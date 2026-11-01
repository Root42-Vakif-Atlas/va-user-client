import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/l10n/measure_format.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/molecules/inline_message.dart';

/// Oluşturucunun altında sabit duran ön özet ve gönderim butonu.
///
/// Karayolu süresi sunucuda hesaplandığından burada kuş uçuşu mesafe ile
/// ziyaret ve mola toplamları gösterilir.
class BuilderSummaryBar extends StatelessWidget {
  const BuilderSummaryBar({
    required this.stopCount,
    required this.straightLineMeters,
    required this.visitTotal,
    required this.breakTotal,
    required this.isEditing,
    required this.isSubmitting,
    required this.onSubmit,
    this.errorMessage,
    super.key,
  });

  final int stopCount;
  final double straightLineMeters;
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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          top: BorderSide(
            color: colors.outlineVariant,
            width: AppSizes.borderThin,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        // Alt yuvada dikeyde genişlememesi için yalnızca içerik kadar yükseklik.
        child: Align(
          alignment: Alignment.topCenter,
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSizes.maxContentWidth,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
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
                    l10n.routeBuilderSummary(
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
                  const SizedBox(height: AppSpacing.sm),
                  AppButton.primary(
                    key: const Key('route_submit_button'),
                    label: isEditing ? l10n.routeSaveChanges : l10n.routeCreate,
                    icon: Icons.check,
                    isLoading: isSubmitting,
                    expand: true,
                    onPressed: isSubmitting ? null : onSubmit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
