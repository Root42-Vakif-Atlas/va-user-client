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
