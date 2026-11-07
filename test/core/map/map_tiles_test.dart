import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/map/map_tiles.dart';

void main() {
  group('MapTiles', () {
    test('izdüşüm ve ters izdüşüm tutarlıdır', () {
      final (x, y) = MapTiles.project(41.0086, 28.9802);
      final (lat, lng) = MapTiles.unproject(x, y);
      expect(lat, closeTo(41.0086, 1e-9));
      expect(lng, closeTo(28.9802, 1e-9));
    });

    test('İstanbul z=6 karosu 6/37/24', () {
      final tiles = MapTiles.tilesCovering(
        south: 41.0,
        west: 28.97,
        north: 41.01,
        east: 28.98,
        zoom: 6,
      );
      expect(tiles, {const TileId(6, 37, 23)});
    });

    test('Türkiye z=6 seviyesinde birkaç karoyla kaplanır; seviye '
        'sınırlanır', () {
      final tiles = MapTiles.tilesCovering(
        south: 35.8,
        west: 25.6,
        north: 42.2,
        east: 44.9,
        zoom: 6,
      );
      expect(tiles.length, inInclusiveRange(4, 12));
      expect(MapTiles.zoomLevel(2.3), MapTiles.minZoom);
      expect(MapTiles.zoomLevel(22), MapTiles.maxZoom);
      expect(MapTiles.zoomLevel(7.9), 7);
    });

    test('kümeleme seviyelerinde bir seviye büyük karo istenir; tekil eser '
        've külliye seviyeleri değişmez', () {
      expect(MapTiles.requestLevel(4), MapTiles.minZoom);
      expect(MapTiles.requestLevel(5.5), 4);
      expect(MapTiles.requestLevel(14.9), 13);
      // Tekil eserler (15) ve külliye açılımı (17) aynı seviyede gelir.
      expect(MapTiles.requestLevel(15), MapTiles.singlesZoom);
      expect(MapTiles.requestLevel(16.5), 16);
      expect(MapTiles.requestLevel(17), MapTiles.complexExpandZoom);
      expect(MapTiles.requestLevel(18), MapTiles.maxZoom);
    });

    test('büyük karo görünür alan başına istek sayısını düşürür', () {
      // İstanbul tarihi yarımada, telefon görünür alanı (~zoom 13.5).
      Set<TileId> at(int zoom) => MapTiles.tilesCovering(
        south: 40.995,
        west: 28.955,
        north: 41.03,
        east: 28.99,
        zoom: zoom,
      );
      expect(
        at(MapTiles.requestLevel(13.5)).length,
        lessThan(at(MapTiles.zoomLevel(13.5)).length),
      );
    });

    test('declutter ekranda 48 dp içindeki öğeleri birleştirir, sayıyı '
        'korur', () {
      // (enlem, boylam, sayı)
      final items = [
        (41.00, 29.00, 3),
        (41.01, 29.01, 2), // ilkine çok yakın
        (38.00, 35.00, 1), // uzak
      ];
      final result = MapTiles.declutter(
        items,
        zoom: 6,
        position: (item) => (item.$1, item.$2),
        merge: (group) => (
          group.first.$1,
          group.first.$2,
          group.fold(0, (sum, item) => sum + item.$3),
        ),
      );
      expect(result, hasLength(2));
      expect(result.fold(0, (sum, item) => sum + item.$3), 6);
      expect(result.first.$3, 5);
    });

    test('yakın ölçekte birbirinden uzak öğeler birleşmez', () {
      final items = [(41.00, 29.00), (41.01, 29.01)];
      final result = MapTiles.declutter(
        items,
        zoom: 16,
        position: (item) => item,
        merge: (group) => group.first,
      );
      expect(result, hasLength(2));
    });
  });
}
