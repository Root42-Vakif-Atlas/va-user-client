import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';
import 'package:vakif_atlas/features/catalog/presentation/catalog_presentation.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_progress_indicator.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/molecules/inline_message.dart';

/// Yakınlaştırmayla ayrışmayan (aynı konumdaki) kümenin eser listesi.
class MonumentClusterSheet extends StatelessWidget {
  const MonumentClusterSheet({
    required this.pins,
    required this.onSelected,
    this.isLoading = false,
    this.hasError = false,
    this.onRetry,
    super.key,
  });

  final List<MonumentPin> pins;
  final ValueChanged<String> onSelected;

  /// Eserler sunucudan (`bbox`) isteniyor.
  final bool isLoading;
  final bool hasError;
  final VoidCallback? onRetry;

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
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.xs,
            ),
            child: AppText(
              l10n.mapClusterSheetTitle,
              role: AppTextRole.headlineMedium,
              isHeading: true,
            ),
          ),
          if (isLoading)
            Semantics(
              label: l10n.commonLoading,
              liveRegion: true,
              excludeSemantics: true,
              child: const Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Center(child: AppProgressIndicator(strokeWidth: 4)),
              ),
            )
          else if (hasError)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InlineMessage(
                    message: l10n.mapClusterLoadFailed,
                    type: InlineMessageType.error,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppButton.secondary(
                    key: const Key('monument_cluster_retry'),
                    label: l10n.commonRetry,
                    icon: Icons.refresh,
                    onPressed: onRetry,
                  ),
                ],
              ),
            )
          else
            Flexible(
              child: ListView.separated(
                key: const Key('monument_cluster_list'),
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                itemCount: pins.length,
                separatorBuilder: (_, _) => const Divider(height: 0),
                itemBuilder: (context, index) {
                  final pin = pins[index];
                  return ListTile(
                    key: Key('monument_cluster_item_${pin.id}'),
                    leading: AppIcon.decorative(
                      pin.category.icon,
                      color: colors.accentText,
                    ),
                    title: Text(pin.name),
                    subtitle: Text(
                      l10n.monumentListItemSubtitle(
                        l10n.monumentLocation(pin.district, pin.city),
                        pin.category.label(l10n),
                      ),
                    ),
                    onTap: () => onSelected(pin.id),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
