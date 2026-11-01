import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/map/map_tiles.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/map_tile.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_classification.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_filter.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';
import 'package:vakif_atlas/features/catalog/domain/usecases/catalog_usecases.dart';

import '../../../helpers/catalog_test_utils.dart';
import '../../../support/mock_api/catalog/catalog_mock_api.dart';

/// `GET catalog/map/tiles/{z}/{x}/{y}` ve `GET catalog/map/extent`
/// sözleşmesi (gerçek veri kaynağı + repository + mock sunucu).
void main() {
  final catalog = catalogUseCases();
  const version = CatalogMockApi.catalogVersion;

  /// Türkiye'yi kaplayan karolar.
  Set<TileId> turkey(int zoom) => MapTiles.tilesCovering(
    south: 35.8,
    west: 25.6,
    north: 42.2,
    east: 44.9,
    zoom: zoom,
  );

  Future<List<MapTileItem>> tile(
    TileId id, {
    MonumentSearchQuery query = MonumentSearchQuery.empty,
  }) async {
    final result = await catalog.tile(
      GetMapTileParams(
        tile: id,
        query: query,
        version: version,
        languageCode: 'tr',
      ),
    );
    return result.fold((f) => fail('$f'), (items) => items);
  }

  int countOf(MapTileItem item) => switch (item) {
    MapTileCluster(:final count) => count,
    MapTileMonument() || MapTileComplex() => 1,
  };

  test('her seviyede Türkiye karoları toplandığında her eser tam bir kez '
      'sayılır', () async {
    for (var zoom = MapTiles.minZoom; zoom <= 9; zoom++) {
      var total = 0;
      for (final id in turkey(zoom)) {
        total += (await tile(id)).fold<int>(0, (s, i) => s + countOf(i));
      }
      expect(total, 10, reason: 'z=$zoom');
    }
  });

  test('genel ölçekte kümeler, sokak ölçeğinde tekil eserler döner', () async {
    final overview = [for (final id in turkey(5)) ...await tile(id)];
    expect(overview.whereType<MapTileCluster>(), isNotEmpty);
    final cluster = overview.whereType<MapTileCluster>().first;
    expect(cluster.bounds.south, lessThanOrEqualTo(cluster.location.latitude));
    expect(
      cluster.bounds.north,
      greaterThanOrEqualTo(cluster.location.latitude),
    );

    // Süleymaniye'nin z=15 karosu: yapılar külliyenin işaretçisinde.
    final (mx, my) = MapTiles.project(41.0161, 28.9637);
    final street = await tile(
      TileId(15, (mx * (1 << 15)).floor(), (my * (1 << 15)).floor()),
    );
    final complex = street.single as MapTileComplex;
    expect(complex.pin.name, 'Süleymaniye Külliyesi');
    expect(complex.pin.memberCount, 11);
    expect(complex.footprint, isEmpty);
  });

  test('yakın zum: külliye alanı ve külliye referanslı yapı pinleri', () async {
    final (mx, my) = MapTiles.project(41.0161, 28.9637);
    const z = MapTiles.complexExpandZoom;
    final x = (mx * (1 << z)).floor();
    final y = (my * (1 << z)).floor();
    final items = [
      for (var dx = -1; dx <= 1; dx++)
        for (var dy = -1; dy <= 1; dy++)
          ...await tile(TileId(z, x + dx, y + dy)),
    ];
    final complex = items.whereType<MapTileComplex>().single;
    expect(complex.footprint.length, greaterThanOrEqualTo(3));
    final members = items.whereType<MapTileMonument>().toList();
    expect(members, hasLength(11));
    expect(members.map((m) => m.pin.complex?.id).toSet(), {
      'suleymaniye-kulliyesi',
    });
  });

  test(
    'yalnızca bir yapı eşleşse de uzakta külliye işaretçisi döner',
    () async {
      const query = MonumentSearchQuery(
        filter: MonumentFilter(categories: {MonumentCategory.tomb}),
      );
      final items = [
        for (final id in turkey(6)) ...await tile(id, query: query),
      ];
      expect((items.single as MapTileComplex).pin.id, 'suleymaniye-kulliyesi');
    },
  );

  test('filtreler karo sorgusuna uygulanır', () async {
    const query = MonumentSearchQuery(
      filter: MonumentFilter(categories: {MonumentCategory.inn}),
    );
    final items = [for (final id in turkey(6)) ...await tile(id, query: query)];
    expect(items.single, isA<MapTileMonument>());
    expect((items.single as MapTileMonument).pin.id, 'kizlaragasi-hani');
  });

  test('geçersiz karo 400 → ServerFailure', () async {
    final result = await catalog.tile(
      const GetMapTileParams(
        tile: TileId(3, 0, 0),
        version: version,
        languageCode: 'tr',
      ),
    );
    expect(
      result.fold((f) => f, (_) => null),
      isA<ServerFailure>().having((f) => f.statusCode, 'status', 400),
    );
  });

  test('kapsam: toplam, sınır ve katalog sürümü', () async {
    final all = (await catalog.extent(
      const GetMapExtentParams(languageCode: 'tr'),
    )).fold((f) => fail('$f'), (e) => e);
    expect(all.total, 21);
    expect(all.version, version);
    expect(all.bounds!.south, lessThan(all.bounds!.north));

    final none = (await catalog.extent(
      const GetMapExtentParams(
        languageCode: 'tr',
        query: MonumentSearchQuery(text: 'xyzw'),
      ),
    )).fold((f) => fail('$f'), (e) => e);
    expect(none.total, 0);
    expect(none.bounds, isNull);
  });

  test('liste bbox ile alana daraltılır; yer önerileri sınır taşır', () async {
    final page = (await catalog.search(
      const SearchMonumentsParams(
        query: MonumentSearchQuery(text: 'konya'),
        languageCode: 'tr',
        bounds: GeoBounds(south: 37.8, west: 32.4, north: 37.9, east: 32.6),
      ),
    )).fold((f) => fail('$f'), (p) => p);
    expect(page.items.single.id, 'sahip-ata-kulliyesi');
    expect(page.places.single.bounds!.isPoint, isTrue);

    final outside = (await catalog.search(
      const SearchMonumentsParams(
        query: MonumentSearchQuery.empty,
        languageCode: 'tr',
        bounds: GeoBounds(south: 0, west: 0, north: 1, east: 1),
      ),
    )).fold((f) => fail('$f'), (p) => p);
    expect(outside.total, 0);
  });

  test('aynı karo ikinci kez ağa gitmez (bellek içi LRU)', () async {
    var requests = 0;
    final counted = catalogUseCases(null, () => requests++);
    const params = GetMapTileParams(
      tile: TileId(6, 37, 24),
      version: version,
      languageCode: 'tr',
    );
    await counted.tile(params);
    await counted.tile(params);
    expect(requests, 1);

    await counted.tile(
      const GetMapTileParams(
        tile: TileId(6, 37, 24),
        version: 'yeni-surum',
        languageCode: 'tr',
      ),
    );
    expect(requests, 2, reason: 'sürüm önbellek anahtarındadır');
  });
}
