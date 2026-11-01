import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_shadows.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/map_tile.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';
import 'package:vakif_atlas/features/catalog/presentation/catalog_presentation.dart';

/// Yakın zum'da açılan külliyelerin yerleşim alanı: İznik mavisi yarı saydam
/// dolgulu, konturlu çokgen ve ortasında külliyeyi seçen ad etiketi.
///
/// Pin katmanının altında çizilir; üye pinleri alanın içinde görünür. Çokgen
/// dekoratiftir (ekran okuyucuda yer almaz); etiket 48 dp dokunma alanlı,
/// adlandırılmış bir butondur.
class ComplexFootprintLayer extends StatelessWidget {
  const ComplexFootprintLayer({
    required this.complexes,
    required this.selectedId,
    required this.onSelected,
    super.key,
  });

  final List<MapTileComplex> complexes;
  final String? selectedId;
  final ValueChanged<MonumentPin> onSelected;

  /// Dolgunun saydamlığı: altlık (sokak adları) okunur kalır.
  static const double _fillOpacity = 0.12;
  static const double _selectedFillOpacity = 0.2;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final areas = [
      for (final complex in complexes)
        if (complex.footprint.length >= 3) complex,
    ];
    if (complexes.isEmpty) {
      return const SizedBox.shrink();
    }
    return Stack(
      children: [
        PolygonLayer(
          polygons: [
            for (final complex in areas)
              Polygon(
                points: [
                  for (final point in complex.footprint) point.toLatLng(),
                ],
                color: colors.complexAccent.withValues(
                  alpha: complex.pin.id == selectedId
                      ? _selectedFillOpacity
                      : _fillOpacity,
                ),
                borderColor: colors.complexAccent,
                borderStrokeWidth: AppSizes.mapComplexOutline,
              ),
          ],
        ),
        MarkerLayer(
          markers: [
            for (final complex in complexes)
              Marker(
                key: ValueKey('complex_label_${complex.pin.id}'),
                point: _labelPoint(complex),
                // Alanın güney kenarının hemen altında (dışında) durur.
                alignment: Alignment.bottomCenter,
                // Etiket metinle genişler; işaretçi kutusu sabit olmalı.
                width: _labelWidth,
                height: AppSizes.minTouchTarget,
                child: _ComplexLabel(
                  pin: complex.pin,
                  selected: complex.pin.id == selectedId,
                  onTap: () => onSelected(complex.pin),
                ),
              ),
          ],
        ),
      ],
    );
  }

  static const double _labelWidth = 220;

  /// Etiket alanın güney kenarının dışına asılır: içerideki yapı pinlerini
  /// örtmez; üstteki arama çubuğu da kuzey kenarı kapatabilir.
  static LatLng _labelPoint(MapTileComplex complex) {
    final footprint = complex.footprint;
    if (footprint.length < 3) {
      return complex.location.toLatLng();
    }
    final south = footprint
        .map((point) => point.latitude)
        .reduce((a, b) => a < b ? a : b);
    return LatLng(south, complex.location.longitude);
  }
}

class _ComplexLabel extends StatelessWidget {
  const _ComplexLabel({
    required this.pin,
    required this.selected,
    required this.onTap,
  });

  final MonumentPin pin;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fill = selected ? colors.onSurface : colors.complexAccent;
    final onFill = selected ? colors.surface : colors.onComplexAccent;
    return Center(
      child: Semantics(
        container: true,
        button: true,
        selected: selected,
        sortKey: const OrdinalSortKey(-1),
        label: context.l10n.mapComplexAreaSemantics(pin.name),
        onTap: onTap,
        excludeSemantics: true,
        child: Material(
          color: fill,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            side: BorderSide(
              color: selected ? colors.complexAccent : colors.onComplexAccent,
              width: AppSizes.borderThick,
            ),
          ),
          shadowColor: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: Container(
              constraints: const BoxConstraints(
                minHeight: AppSizes.minTouchTarget - AppSpacing.xs,
              ),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              decoration: const BoxDecoration(boxShadow: AppShadows.cardShadow),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.account_balance_outlined,
                    size: AppSizes.iconSm,
                    color: onFill,
                  ),
                  const SizedBox(width: AppSpacing.xxs),
                  Flexible(
                    child: Text(
                      pin.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      // Harita etiketi sabit boyutludur; tam ad ekran
                      // okuyucu etiketinde ve önizleme kartındadır.
                      textScaler: TextScaler.noScaling,
                      style: context.textStyles.labelLarge.copyWith(
                        color: onFill,
                      ),
                    ),
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
