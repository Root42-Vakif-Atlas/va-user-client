import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/map_tile.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';
import 'package:vakif_atlas/features/catalog/presentation/catalog_presentation.dart';
import 'package:vakif_atlas/shared/widgets/organisms/map_cluster_marker.dart';
import 'package:vakif_atlas/shared/widgets/organisms/map_complex_marker.dart';
import 'package:vakif_atlas/shared/widgets/organisms/map_pin.dart';

/// Sunucu kümeleri ve tekil eser pinleri (FlutterMap katmanı).
///
/// Öğeler görünür karolardan gelir (`MonumentTilesCubit`). Seçili eser,
/// karolarda bir kümenin içinde olsa da ayrıca ve en üstte gösterilir.
/// Ekran okuyucu öğeleri sunucu sırasıyla okur.
///
/// Külliye uzak/orta zum'da [MapComplexMarker] (mavi daire + yapı sayısı)
/// olarak çizilir; yakın zum'da yerleşim alanı ayrı katmandadır
/// (`ComplexFootprintLayer`) ve üyelerin pinleri külliye konturu taşır.
class MonumentClusterLayer extends StatelessWidget {
  const MonumentClusterLayer({
    required this.items,
    required this.selected,
    required this.onPinSelected,
    required this.onClusterSelected,
    this.expandedComplexIds = const {},
    super.key,
  });

  /// Yakın zum'da alanıyla çizilen külliyeler: seçili olsalar da işaretçi
  /// çizilmez (seçim alan etiketinde gösterilir).
  final Set<String> expandedComplexIds;

  final List<MapTileItem> items;

  /// Seçili eser (önizleme detayından veya dokunulan pinden).
  final MonumentPin? selected;
  final ValueChanged<MonumentPin> onPinSelected;
  final ValueChanged<MapTileCluster> onClusterSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final selected = this.selected;
    final markers = <Marker>[];
    var order = 0;

    for (final item in items) {
      switch (item) {
        case MapTileMonument(:final pin) || MapTileComplex(:final pin):
          if (pin.id != selected?.id) {
            markers.add(_pinMarker(l10n, pin, order: order++));
          }
        case MapTileCluster():
          final extent = MapClusterMarker.extent(item.count);
          markers.add(
            Marker(
              key: ValueKey(item.key),
              point: item.location.toLatLng(),
              width: extent,
              height: extent,
              child: MapClusterMarker(
                key: Key('monument_cluster_${item.key}'),
                count: item.count,
                semanticsOrder: (order++).toDouble(),
                semanticsLabel: item.bounds.isPoint
                    ? l10n.mapClusterListSemantics(item.count)
                    : l10n.mapClusterSemantics(item.count),
                onTap: () => onClusterSelected(item),
              ),
            ),
          );
      }
    }
    // Konumu girilmemiş seçili eser (VGM verisi) haritada işaretçi olamaz.
    if (selected != null &&
        selected.hasLocation &&
        !expandedComplexIds.contains(selected.id)) {
      markers.add(_pinMarker(l10n, selected, order: order, isSelected: true));
    }
    return MarkerLayer(markers: markers);
  }

  Marker _pinMarker(
    AppLocalizations l10n,
    MonumentPin pin, {
    required int order,
    bool isSelected = false,
  }) {
    if (pin.memberCount case final memberCount?) {
      final extent = MapComplexMarker.extent(selected: isSelected);
      return Marker(
        key: ValueKey('complex_${pin.id}'),
        point: pin.location!.toLatLng(),
        width: extent,
        height: extent,
        child: MapComplexMarker(
          key: Key('monument_complex_${pin.id}'),
          memberCount: memberCount,
          selected: isSelected,
          semanticsOrder: order.toDouble(),
          semanticsLabel: l10n.mapComplexSemantics(
            pin.name,
            l10n.complexMemberCount(memberCount),
            pin.district,
            pin.city,
          ),
          onTap: () => onPinSelected(pin),
        ),
      );
    }
    final complex = pin.complex;
    final extent = MapPin.extent(selected: isSelected);
    return Marker(
      key: ValueKey('pin_${pin.id}'),
      point: pin.location!.toLatLng(),
      width: extent,
      height: extent,
      child: MapPin(
        key: Key('monument_pin_${pin.id}'),
        icon: pin.category.icon,
        selected: isSelected,
        memberOfComplex: complex != null,
        semanticsOrder: order.toDouble(),
        semanticsLabel: complex == null
            ? l10n.monumentPinSemantics(pin.name, pin.district, pin.city)
            : l10n.mapComplexMemberSemantics(pin.name, complex.name),
        onTap: () => onPinSelected(pin),
      ),
    );
  }
}
