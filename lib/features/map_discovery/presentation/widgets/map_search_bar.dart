import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/molecules/map_control_surface.dart';

/// Haritanın üstündeki arama çubuğu: dokununca tam ekran arama açılır;
/// sağında filtre butonu bulunur.
///
/// Uygulanmış bir sorgu varsa yer tutucu yerine sorgu ve temizle butonu
/// gösterilir. Etkin filtre sayısı rozetle ve ekran okuyucu etiketiyle
/// bildirilir (WCAG 1.4.1).
class MapSearchBar extends StatelessWidget {
  const MapSearchBar({
    required this.query,
    required this.activeFilterCount,
    required this.onOpenSearch,
    required this.onClearQuery,
    required this.onOpenFilters,
    super.key,
  });

  /// Haritaya uygulanmış sorgu; boş → yer tutucu.
  final String query;
  final int activeFilterCount;
  final VoidCallback onOpenSearch;
  final VoidCallback onClearQuery;

  /// `null` → eserler yüklenmeden filtre devre dışı.
  final VoidCallback? onOpenFilters;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final hasQuery = query.isNotEmpty;
    final filterLabel = activeFilterCount == 0
        ? l10n.mapFiltersButton
        : l10n.mapFiltersButtonActive(activeFilterCount);

    return MapControlSurface(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppSizes.mapSearchBar),
        child: Row(
          children: [
            Expanded(
              child: Semantics(
                button: true,
                label: hasQuery
                    ? l10n.mapSearchEditSemantics(query)
                    : l10n.mapSearchHint,
                excludeSemantics: true,
                onTap: onOpenSearch,
                child: InkWell(
                  key: const Key('map_search_bar'),
                  onTap: onOpenSearch,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      AppSpacing.md,
                      AppSpacing.sm,
                      AppSpacing.xs,
                      AppSpacing.sm,
                    ),
                    child: Row(
                      children: [
                        AppIcon.decorative(
                          Icons.search,
                          color: colors.onSurfaceVariant,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: AppText(
                            hasQuery ? query : l10n.mapSearchHint,
                            role: AppTextRole.bodyLarge,
                            color: hasQuery
                                ? colors.onSurface
                                : colors.onSurfaceVariant,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (hasQuery)
              IconButton(
                key: const Key('map_search_clear_button'),
                tooltip: l10n.mapSearchClear,
                onPressed: onClearQuery,
                icon: const Icon(Icons.close),
                color: colors.onSurface,
              ),
            IconButton(
              key: const Key('map_filter_button'),
              tooltip: filterLabel,
              onPressed: onOpenFilters,
              color: colors.onSurface,
              isSelected: activeFilterCount > 0,
              icon: Badge(
                isLabelVisible: activeFilterCount > 0,
                backgroundColor: colors.primary,
                textColor: colors.onPrimary,
                label: Text(
                  '$activeFilterCount',
                  textScaler: TextScaler.noScaling,
                ),
                child: const Icon(Icons.tune),
              ),
            ),
            const SizedBox(width: AppSpacing.xxs),
          ],
        ),
      ),
    );
  }
}
