import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/molecules/map_control_surface.dart';

/// Arama veya filtre etkinken haritanın kaç eser gösterdiğini bildirir ve
/// tek dokunuşla temizlemeyi sunar.
///
/// Boş sonuçta harita boş kaldığında kullanıcı nedenini görür (WCAG 3.3.1).
/// Sayı değişimleri sayfa tarafından duyurulur.
class MapResultsBanner extends StatelessWidget {
  const MapResultsBanner({
    required this.visibleCount,
    required this.onClear,
    super.key,
  });

  final int visibleCount;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final empty = visibleCount == 0;
    return MapControlSurface(
      child: Padding(
        padding: const EdgeInsetsDirectional.only(start: AppSpacing.sm),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon.decorative(
              empty ? Icons.search_off : Icons.filter_alt_outlined,
              size: AppSizes.iconInline,
              color: empty ? colors.warning : colors.accentText,
            ),
            const SizedBox(width: AppSpacing.xs),
            Flexible(
              child: AppText(
                empty
                    ? l10n.mapNoMatches
                    : l10n.mapResultsShowing(visibleCount),
                key: const Key('map_results_banner_text'),
                role: AppTextRole.labelLarge,
              ),
            ),
            const SizedBox(width: AppSpacing.xxs),
            TextButton(
              key: const Key('map_clear_refinements_button'),
              onPressed: onClear,
              child: Text(
                l10n.mapClearRefinements,
                semanticsLabel: l10n.mapClearRefinementsSemantics,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
