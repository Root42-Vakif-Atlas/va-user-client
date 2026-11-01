import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/a11y/reduce_motion.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/l10n/failure_messages.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/molecules/inline_message.dart';

/// Harita üzerinde "Eserler yükleniyor" göstergesi (canlı bölge).
class MapLoadingBadge extends StatelessWidget {
  const MapLoadingBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final label = context.l10n.mapLoadingMonuments;
    return Semantics(
      container: true,
      liveRegion: true,
      label: label,
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surfaceElevated,
          border: Border.all(color: colors.outline, width: AppSizes.borderThin),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (context.reduceMotion)
                AppIcon.decorative(
                  Icons.hourglass_top,
                  size: AppSizes.spinner,
                  color: colors.accentText,
                )
              else
                SizedBox.square(
                  dimension: AppSizes.spinner,
                  child: CircularProgressIndicator(
                    strokeWidth: AppSizes.spinnerStroke,
                    color: colors.accentText,
                  ),
                ),
              const SizedBox(width: AppSpacing.xs),
              Flexible(child: AppText(label, role: AppTextRole.labelLarge)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Eserler yüklenemediğinde haritanın altında tekrar deneme paneli.
class MapLoadErrorPanel extends StatelessWidget {
  const MapLoadErrorPanel({
    required this.failure,
    required this.onRetry,
    super.key,
  });

  final Failure failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppText(
                l10n.mapLoadErrorTitle,
                role: AppTextRole.titleMedium,
                isHeading: true,
              ),
              const SizedBox(height: AppSpacing.xs),
              InlineMessage(
                message: failure.toUserMessage(l10n),
                type: InlineMessageType.error,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppButton.primary(
                key: const Key('map_retry_button'),
                label: l10n.commonRetry,
                icon: Icons.refresh,
                expand: true,
                onPressed: onRetry,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
