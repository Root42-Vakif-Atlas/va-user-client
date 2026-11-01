import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/map/map_defaults.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_detail.dart';
import 'package:vakif_atlas/features/catalog/presentation/catalog_presentation.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/widgets/monument_sections.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/organisms/app_map.dart';
import 'package:vakif_atlas/shared/widgets/organisms/map_pin.dart';

/// Açık adres, konumu gösteren küçük harita ve "Haritada göster".
///
/// Küçük harita yalnızca görseldir ve ekran okuyucudan gizlenir; metin
/// karşılığı hemen üstündeki adrestir (WCAG 1.1.1).
class MonumentLocationSection extends StatelessWidget {
  const MonumentLocationSection({
    required this.monument,
    required this.onShowOnMap,
    super.key,
  });

  final MonumentDetail monument;
  final VoidCallback onShowOnMap;

  static const double _mapAspectRatio = 16 / 9;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final location = monument.location;
    final point = location != null && location.isValid
        ? location.toLatLng()
        : null;
    return MonumentSection(
      title: l10n.monumentLocationHeading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            label: l10n.monumentAddressSemantics(monument.address),
            excludeSemantics: true,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppIcon.decorative(
                  Icons.signpost_outlined,
                  color: colors.accentText,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: AppText(
                    monument.address,
                    key: const Key('monument_detail_address'),
                  ),
                ),
              ],
            ),
          ),
          // VGM verisi koordinat taşımaz: konum girilene kadar harita yok.
          if (point == null) ...[
            const SizedBox(height: AppSpacing.sm),
            AppText(
              l10n.monumentLocationPending,
              key: const Key('monument_detail_location_pending'),
              role: AppTextRole.bodyMedium,
              color: colors.onSurfaceVariant,
            ),
          ] else ...[
            const SizedBox(height: AppSpacing.md),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: AspectRatio(
                aspectRatio: _mapAspectRatio,
                child: AppMap(
                  key: const Key('monument_detail_map'),
                  interactive: false,
                  initialCenter: point,
                  initialZoom: MapDefaults.focusZoom,
                  markers: [
                    Marker(
                      point: point,
                      width: MapPin.extent(selected: true),
                      height: MapPin.extent(selected: true),
                      child: MapPin(
                        icon: monument.category.icon,
                        semanticsLabel: monument.name,
                        selected: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton.secondary(
              key: const Key('monument_detail_show_on_map_button'),
              label: l10n.monumentShowOnMap,
              icon: Icons.map_outlined,
              expand: true,
              onPressed: onShowOnMap,
            ),
          ],
        ],
      ),
    );
  }
}
