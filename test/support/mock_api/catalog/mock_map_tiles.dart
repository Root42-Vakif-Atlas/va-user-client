import 'package:vakif_atlas/core/map/map_tiles.dart';

import 'mock_monument_search.dart';

/// Mock sunucunun karo kümelemesi — gerçek backend'in SQL sorgusunun
/// (bkz. `docs/api-contracts.md` → Harita karoları) birebir karşılığı.
///
/// Her eşleşen eserin bir harita temsilcisi vardır: külliye üyesinde
/// külliye (`map_key = COALESCE(complex_id, id)`, konum külliyenin konumu),
/// diğerlerinde kendisi.
///
/// `z < 17` ([MapTiles.complexExpandZoom]):
///
/// ```sql
/// SELECT FLOOR(map_mx * @n) cx, FLOOR(map_my * @n) cy,
///        COUNT(DISTINCT map_key), AVG(map_lat), AVG(map_lng),
///        MIN(map_lat), MIN(map_lng), MAX(map_lat), MAX(map_lng),
///        MIN(map_key)
/// FROM monuments WHERE map_mx ∈ karo AND map_my ∈ karo AND <filtreler>
/// GROUP BY cx, cy            -- @n = 2^z × 4
/// ```
///
/// Tek anahtarlı hücre (veya `z ≥ 15`'te her anahtar) tekil öğedir: külliye
/// → `complex`, diğerleri → `monument`. Filtre yalnızca bir üyeyle eşleşse
/// de külliye öğesi döner (üye külliyesinin içindedir).
///
/// `z ≥ 17`: külliye dışındaki eşleşmeler kendi konumlarıyla tekil
/// `monument` (üyede `complex` referansı); kendisi veya bir üyesi eşleşen
/// külliyeler kendi konumlarıyla `complex` + `footprint` olarak döner.
abstract final class MockMapTiles {
  static List<Map<String, Object?>> tile(
    List<Map<String, Object?>> matches,
    TileId tile, {
    required MockMapIndex index,
  }) {
    if (tile.z >= MapTiles.complexExpandZoom) {
      return _expanded(matches, tile, index);
    }
    final count = 1 << tile.z;
    final cells = count * MapTiles.cellsPerSide;
    final groups = <(int, int), List<String>>{};
    for (final item in matches) {
      final key = index.mapKeyOf(item);
      final (lat, lng) = index.locationOf(key);
      final (mx, my) = MapTiles.project(lat, lng);
      if ((mx * count).floor() != tile.x || (my * count).floor() != tile.y) {
        continue;
      }
      groups
          .putIfAbsent(((mx * cells).floor(), (my * cells).floor()), () => [])
          .add(key);
    }

    final singles = tile.z >= MapTiles.singlesZoom;
    return [
      for (final MapEntry(key: (cx, cy), value: keys) in groups.entries)
        if (singles || keys.toSet().length == 1)
          for (final key in {...keys}) index.itemOf(key)
        else
          _cluster(tile, cx, cy, keys, index),
    ];
  }

  static List<Map<String, Object?>> _expanded(
    List<Map<String, Object?>> matches,
    TileId tile,
    MockMapIndex index,
  ) {
    final count = 1 << tile.z;
    bool inTile(String id) {
      final (lat, lng) = index.locationOf(id);
      final (mx, my) = MapTiles.project(lat, lng);
      return (mx * count).floor() == tile.x && (my * count).floor() == tile.y;
    }

    final complexes = <String>{};
    final items = <Map<String, Object?>>[];
    for (final item in matches) {
      final id = item['id']! as String;
      final key = index.mapKeyOf(item);
      if (key != id || index.isComplex(id)) {
        complexes.add(key);
      }
      if (!index.isComplex(id) && inTile(id)) {
        items.add(index.itemOf(id));
      }
    }
    return [
      for (final key in complexes)
        if (inTile(key)) index.itemOf(key, withFootprint: true),
      ...items,
    ];
  }

  /// Sorguya uyan eserlerin toplamı ve sınırı.
  static Map<String, Object?> extent(
    List<Map<String, Object?>> matches,
    String version,
  ) => {
    'total': matches.length,
    'bounds': MockMonumentSearch.boundsOf(matches),
    'version': version,
  };

  static Map<String, Object?> _cluster(
    TileId tile,
    int cx,
    int cy,
    List<String> keys,
    MockMapIndex index,
  ) {
    var sumLat = 0.0;
    var sumLng = 0.0;
    var south = double.infinity;
    var west = double.infinity;
    var north = -double.infinity;
    var east = -double.infinity;
    for (final key in keys) {
      final (lat, lng) = index.locationOf(key);
      sumLat += lat;
      sumLng += lng;
      if (lat < south) south = lat;
      if (lat > north) north = lat;
      if (lng < west) west = lng;
      if (lng > east) east = lng;
    }
    return {
      'type': 'cluster',
      'key': '$tile/$cx/$cy',
      'count': keys.toSet().length,
      'lat': sumLat / keys.length,
      'lng': sumLng / keys.length,
      'bounds': [south, west, north, east],
    };
  }
}

/// Karo hesaplaması için katalog dizini (mock API kurar).
abstract interface class MockMapIndex {
  /// Harita temsilcisi: üyede külliye, diğerlerinde kendisi.
  String mapKeyOf(Map<String, Object?> summary);

  bool isComplex(String id);

  (double, double) locationOf(String id);

  /// Karo öğesi JSON'u (`monument` veya `complex`).
  Map<String, Object?> itemOf(String id, {bool withFootprint = false});
}
