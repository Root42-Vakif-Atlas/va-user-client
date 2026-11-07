import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/map/map_tiles.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/geo_point.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/map_tile.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_classification.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_filter.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';
import 'package:vakif_atlas/features/catalog/domain/usecases/catalog_usecases.dart';
import 'package:vakif_atlas/features/map_discovery/presentation/cubit/monument_tiles_cubit.dart';

import '../../../helpers/catalog_test_utils.dart';
import '../../../support/mock_api/catalog/catalog_mock_api.dart';

class _MockGetTile extends Mock implements GetMapTileUseCase {}

const _turkey = GeoBounds(south: 35.8, west: 25.6, north: 42.2, east: 44.9);

int _total(List<MapTileItem> items) => items.fold(
  0,
  (sum, item) =>
      sum +
      switch (item) {
        MapTileCluster(:final count) => count,
        MapTileMonument() || MapTileComplex() => 1,
      },
);

void main() {
  setUpAll(() {
    registerFallbackValue(
      const GetMapTileParams(
        tile: TileId(4, 0, 0),
        version: 'v',
        languageCode: 'tr',
      ),
    );
  });

  test(
    'sürüm bilinmeden istek yapılmaz; sonra görünür alan yüklenir',
    () async {
      final cubit = MonumentTilesCubit(catalogUseCases().tile);
      await cubit.viewportChanged(zoom: 5.5, bounds: _turkey);
      expect(cubit.state.items, isEmpty);

      await cubit.configure(
        version: CatalogMockApi.catalogVersion,
        languageCode: 'tr',
        query: MonumentSearchQuery.empty,
      );
      expect(_total(cubit.state.items), 10);
      expect(cubit.state.items.whereType<MapTileCluster>(), isNotEmpty);
      expect(cubit.state.isLoading, isFalse);
      await cubit.close();
    },
  );

  group('"Eserler yükleniyor" göstergesi', () {
    Future<MonumentTilesCubit> configured(_MockGetTile getTile) async {
      final cubit = MonumentTilesCubit(getTile);
      await cubit.configure(
        version: CatalogMockApi.catalogVersion,
        languageCode: 'tr',
        query: MonumentSearchQuery.empty,
      );
      return cubit;
    }

    test(
      'karolar hızlı gelirse (bellek / cihaz) gösterge hiç açılmaz',
      () async {
        final getTile = _MockGetTile();
        when(() => getTile(any())).thenAnswer((_) async => const Right([]));
        final cubit = await configured(getTile);
        final loading = <bool>[];
        final subscription = cubit.stream.listen(
          (state) => loading.add(state.isLoading),
        );

        for (var i = 0; i < 5; i++) {
          await cubit.viewportChanged(zoom: 6 + i * 0.1, bounds: _turkey);
        }
        await Future<void>.delayed(
          MonumentTilesCubit.loadingIndicatorDelay * 2,
        );

        expect(loading, isNot(contains(true)));
        await subscription.cancel();
        await cubit.close();
      },
    );

    test('ağ yanıtı gecikirse gösterge açılır, yanıtla kapanır', () async {
      final getTile = _MockGetTile();
      final response = Completer<Result<List<MapTileItem>>>();
      when(() => getTile(any())).thenAnswer((_) => response.future);
      final cubit = await configured(getTile);

      final load = cubit.viewportChanged(zoom: 6, bounds: _turkey);
      await Future<void>.delayed(MonumentTilesCubit.loadingIndicatorDelay ~/ 2);
      expect(cubit.state.isLoading, isFalse);
      await Future<void>.delayed(MonumentTilesCubit.loadingIndicatorDelay);
      expect(cubit.state.isLoading, isTrue);

      response.complete(const Right([]));
      await load;
      expect(cubit.state.isLoading, isFalse);
      await cubit.close();
    });
  });

  test('sorgu değişince karolar filtreyle yeniden istenir', () async {
    final cubit = MonumentTilesCubit(catalogUseCases().tile);
    await cubit.viewportChanged(zoom: 6, bounds: _turkey);
    await cubit.configure(
      version: CatalogMockApi.catalogVersion,
      languageCode: 'tr',
      query: const MonumentSearchQuery(
        filter: MonumentFilter(categories: {MonumentCategory.inn}),
      ),
    );
    final single = cubit.state.items.single as MapTileMonument;
    expect(single.pin.id, 'kizlaragasi-hani');
    await cubit.close();
  });

  test('karo sınırında çakışan öğeler birleştirilir; sayı korunur', () async {
    final getTile = _MockGetTile();
    when(() => getTile(any())).thenAnswer((invocation) async {
      final params = invocation.positionalArguments.single as GetMapTileParams;
      // Her karo aynı noktaya yakın bir küme döner.
      return Right([
        MapTileCluster(
          key: '${params.tile}',
          count: 2,
          location: const GeoPoint(latitude: 39, longitude: 35),
          bounds: const GeoBounds(south: 38, west: 34, north: 40, east: 36),
        ),
      ]);
    });
    final cubit = MonumentTilesCubit(getTile);
    await cubit.configure(
      version: 'v',
      languageCode: 'tr',
      query: MonumentSearchQuery.empty,
    );
    await cubit.viewportChanged(zoom: 6, bounds: _turkey);

    final requested = verify(() => getTile(captureAny())).captured.length;
    expect(cubit.state.items, hasLength(1));
    expect(_total(cubit.state.items), 2 * requested);
    await cubit.close();
  });

  test('geç gelen eski görünüm uygulanmaz; hata son öğeleri korur', () async {
    final getTile = _MockGetTile();
    final slow = Completer<Result<List<MapTileItem>>>();
    var call = 0;
    when(() => getTile(any())).thenAnswer((_) {
      call++;
      return call == 1 ? slow.future : Future.value(const Right([]));
    });
    final cubit = MonumentTilesCubit(getTile);
    await cubit.configure(
      version: 'v',
      languageCode: 'tr',
      query: MonumentSearchQuery.empty,
    );
    const point = GeoBounds(south: 41, west: 29, north: 41.001, east: 29.001);
    final first = cubit.viewportChanged(zoom: 10, bounds: point);
    await cubit.viewportChanged(zoom: 11, bounds: point);
    slow.complete(
      const Right([
        MapTileMonument(
          MonumentPin(
            id: 'eski',
            name: 'Eski',
            category: MonumentCategory.mosque,
            city: 'İl',
            district: 'İlçe',
            location: GeoPoint(latitude: 41, longitude: 29),
          ),
        ),
      ]),
    );
    await first;
    expect(cubit.state.items, isEmpty);

    when(() => getTile(any()))
        .thenAnswer((_) async => const Left(NetworkFailure()));
    await cubit.viewportChanged(zoom: 12, bounds: point);
    expect(cubit.state.failure, const NetworkFailure());
    expect(cubit.state.items, isEmpty);
    await cubit.close();
  });
}
