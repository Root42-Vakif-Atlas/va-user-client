import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/map_tile.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_classification.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_detail.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_filter.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';
import 'package:vakif_atlas/features/catalog/domain/usecases/catalog_usecases.dart';
import 'package:vakif_atlas/features/map_discovery/presentation/bloc/map_discovery_bloc.dart';

import '../../../helpers/catalog_test_utils.dart';
import '../../../support/mock_api/catalog/catalog_mock_api.dart';

class _MockGetExtent extends Mock implements GetMapExtentUseCase {}

class _MockGetDetail extends Mock implements GetMonumentDetailUseCase {}

void main() {
  final catalog = catalogUseCases();
  final pins = {for (final pin in fixturePins()) pin.id: pin};

  setUpAll(() {
    registerFallbackValue(const GetMapExtentParams(languageCode: 'tr'));
    registerFallbackValue(
      const GetMonumentDetailParams(id: 'id', languageCode: 'tr'),
    );
  });

  MapDiscoveryBloc build({
    GetMapExtentUseCase? extent,
    GetMonumentDetailUseCase? detail,
  }) => MapDiscoveryBloc(
    extent ?? catalog.extent,
    detail ?? catalog.detail,
    catalog.search,
  );

  const settle = Duration(milliseconds: 50);
  const loaded = MapDiscoveryState(
    status: MapDiscoveryStatus.success,
    extent: MapExtent(total: 10, version: CatalogMockApi.catalogVersion),
  );

  group('kapsam', () {
    blocTest<MapDiscoveryBloc, MapDiscoveryState>(
      'yükleme toplamı, sınırı ve katalog sürümünü getirir',
      build: build,
      act: (bloc) =>
          bloc.add(const MapDiscoveryEvent.loadRequested(languageCode: 'tr')),
      wait: settle,
      verify: (bloc) {
        expect(bloc.state.status, MapDiscoveryStatus.success);
        // 10 il temsilcisi + Süleymaniye Külliyesi ve 10 yapısı.
        expect(bloc.state.total, 21);
        expect(bloc.state.extent!.version, CatalogMockApi.catalogVersion);
        expect(bloc.state.extent!.bounds, isNotNull);
      },
    );

    blocTest<MapDiscoveryBloc, MapDiscoveryState>(
      'hata Failure ile yayınlanır, önceki kapsam korunur',
      build: () {
        final failing = _MockGetExtent();
        when(() => failing(any()))
            .thenAnswer((_) async => const Left(NetworkFailure()));
        return build(extent: failing);
      },
      seed: () => loaded,
      act: (bloc) =>
          bloc.add(const MapDiscoveryEvent.loadRequested(languageCode: 'tr')),
      expect: () => [
        loaded.copyWith(status: MapDiscoveryStatus.loading),
        loaded.copyWith(
          status: MapDiscoveryStatus.failure,
          failure: const NetworkFailure(),
        ),
      ],
    );

    test('restartable(): art arda yüklemelerde yalnızca sonuncusu '
        'uygulanır', () async {
      final pending = <String, Completer<Result<MapExtent>>>{};
      final extent = _MockGetExtent();
      when(() => extent(any())).thenAnswer((invocation) {
        final params =
            invocation.positionalArguments.single as GetMapExtentParams;
        return (pending[params.languageCode] = Completer()).future;
      });
      final bloc = build(extent: extent);
      bloc
        ..add(const MapDiscoveryEvent.loadRequested(languageCode: 'tr'))
        ..add(const MapDiscoveryEvent.loadRequested(languageCode: 'en'));
      await pumpEventQueue();
      pending['en']!.complete(const Right(MapExtent(total: 2, version: 'en')));
      pending['tr']!.complete(const Right(MapExtent(total: 1, version: 'tr')));
      await pumpEventQueue();

      expect(bloc.state.extent!.version, 'en');
      await bloc.close();
    });
  });

  group('seçim ve önizleme', () {
    blocTest<MapDiscoveryBloc, MapDiscoveryState>(
      'pinden seçimde konum hemen, önizleme detaydan gelir',
      build: build,
      seed: () => loaded,
      act: (bloc) => bloc.add(
        MapDiscoveryEvent.monumentSelected(
          'selimiye-camii',
          pin: pins['selimiye-camii'],
        ),
      ),
      wait: settle,
      expect: () => [
        isA<MapDiscoveryState>()
            .having((s) => s.selectedLocation, 'konum', isNotNull)
            .having(
              (s) => s.selectionStatus,
              'status',
              SelectionStatus.loading,
            ),
        isA<MapDiscoveryState>()
            .having((s) => s.selectionStatus, 'status', SelectionStatus.success)
            .having((s) => s.selection?.architect, 'detay', 'Mimar Sinan'),
      ],
    );

    blocTest<MapDiscoveryBloc, MapDiscoveryState>(
      'aramadan / derin bağlantıdan seçimde konum detaydan gelir',
      build: build,
      act: (bloc) =>
          bloc.add(const MapDiscoveryEvent.monumentSelected('bursa-ulu-camii')),
      wait: settle,
      verify: (bloc) {
        expect(bloc.state.selectedPin, isNull);
        expect(bloc.state.selectedLocation, isNotNull);
        expect(bloc.state.selection?.name, 'Bursa Ulu Camii');
      },
    );

    blocTest<MapDiscoveryBloc, MapDiscoveryState>(
      'bulunamayan eser seçimi kaldırılır ve nedeni yayınlanır',
      build: build,
      seed: () => loaded,
      act: (bloc) => bloc.add(const MapDiscoveryEvent.monumentSelected('yok')),
      wait: settle,
      verify: (bloc) {
        expect(bloc.state.selectedId, isNull);
        expect(
          bloc.state.selectionFailure,
          isA<ServerFailure>().having(
            (f) => f.kind,
            'kind',
            ServerFailureKind.notFound,
          ),
        );
      },
    );

    blocTest<MapDiscoveryBloc, MapDiscoveryState>(
      'önizleme hatası yayınlanır; tekrar dene yeniden ister',
      build: () {
        final detail = _MockGetDetail();
        var calls = 0;
        when(() => detail(any())).thenAnswer((_) async {
          calls++;
          return calls == 1
              ? const Left(NetworkFailure())
              : Right(fixtureDetail('bursa-ulu-camii'));
        });
        return build(detail: detail);
      },
      seed: () => loaded,
      act: (bloc) async {
        bloc.add(const MapDiscoveryEvent.monumentSelected('bursa-ulu-camii'));
        await pumpEventQueue();
        expect(bloc.state.selectionStatus, SelectionStatus.failure);
        bloc.add(const MapDiscoveryEvent.selectionRetryRequested());
      },
      verify: (bloc) {
        expect(bloc.state.selectionStatus, SelectionStatus.success);
        expect(bloc.state.selection?.name, 'Bursa Ulu Camii');
      },
    );

    blocTest<MapDiscoveryBloc, MapDiscoveryState>(
      'geç gelen eski önizleme yeni seçimin üzerine yazmaz',
      build: () {
        final detail = _MockGetDetail();
        final slow = Completer<Result<MonumentDetail>>();
        when(() => detail(any())).thenAnswer((invocation) {
          final params =
              invocation.positionalArguments.single as GetMonumentDetailParams;
          return params.id == 'selimiye-camii'
              ? slow.future
              : Future.value(Right(fixtureDetail(params.id)));
        });
        addTearDown(
          () => slow.complete(Right(fixtureDetail('selimiye-camii'))),
        );
        return build(detail: detail);
      },
      seed: () => loaded,
      act: (bloc) async {
        bloc.add(const MapDiscoveryEvent.monumentSelected('selimiye-camii'));
        await pumpEventQueue();
        bloc.add(const MapDiscoveryEvent.monumentSelected('bursa-ulu-camii'));
      },
      wait: settle,
      verify: (bloc) {
        expect(bloc.state.selectedId, 'bursa-ulu-camii');
        expect(bloc.state.selection?.id, 'bursa-ulu-camii');
      },
    );

    blocTest<MapDiscoveryBloc, MapDiscoveryState>(
      'seçim kaldırılabilir',
      build: build,
      seed: () => loaded.copyWith(
        selectedId: 'bursa-ulu-camii',
        selectedPin: pins['bursa-ulu-camii'],
      ),
      act: (bloc) => bloc.add(const MapDiscoveryEvent.selectionCleared()),
      expect: () => [loaded],
    );
  });

  group('haritaya uygulanan arama', () {
    blocTest<MapDiscoveryBloc, MapDiscoveryState>(
      'sorgu kapsamı sunucudan gelir (toplam ve sınır)',
      build: build,
      seed: () => loaded,
      act: (bloc) => bloc.add(
        const MapDiscoveryEvent.refinementApplied(
          MonumentSearchQuery(
            filter: MonumentFilter(
              categories: {MonumentCategory.mosque, MonumentCategory.other},
              periods: {HistoricalPeriod.seljuk},
            ),
          ),
        ),
      ),
      wait: settle,
      expect: () => [
        isA<MapDiscoveryState>().having((s) => s.isRefining, 'refining', true),
        isA<MapDiscoveryState>()
            .having((s) => s.isRefined, 'refined', true)
            .having((s) => s.total, 'total', 2)
            .having((s) => s.extent?.bounds, 'bounds', isNotNull),
      ],
    );

    blocTest<MapDiscoveryBloc, MapDiscoveryState>(
      'temizle tüm eserlere döner',
      build: build,
      seed: () => loaded.copyWith(
        query: const MonumentSearchQuery(text: 'han'),
        extent: const MapExtent(total: 1, version: 'v'),
      ),
      act: (bloc) => bloc.add(const MapDiscoveryEvent.refinementsCleared()),
      wait: settle,
      verify: (bloc) {
        expect(bloc.state.isRefined, isFalse);
        expect(bloc.state.total, 21);
      },
    );

    blocTest<MapDiscoveryBloc, MapDiscoveryState>(
      'kapsam isteği başarısızsa önceki görünüm korunur ve hata yayınlanır',
      build: () {
        final failing = _MockGetExtent();
        when(() => failing(any()))
            .thenAnswer((_) async => const Left(NetworkFailure()));
        return build(extent: failing);
      },
      seed: () => loaded,
      act: (bloc) => bloc.add(
        const MapDiscoveryEvent.refinementApplied(
          MonumentSearchQuery(text: 'ulu'),
        ),
      ),
      skip: 1,
      expect: () => [
        loaded.copyWith(refinementFailure: const NetworkFailure()),
      ],
    );
  });

  blocTest<MapDiscoveryBloc, MapDiscoveryState>(
    'aynı konum kümesinin eserleri alan (bbox) sorgusuyla listelenir',
    build: build,
    seed: () => loaded,
    act: (bloc) => bloc.add(
      const MapDiscoveryEvent.clusterOpened(
        GeoBounds(south: 37.8, west: 32.4, north: 37.9, east: 32.6),
      ),
    ),
    wait: settle,
    verify: (bloc) {
      expect(bloc.state.clusterStatus, SelectionStatus.success);
      expect(bloc.state.clusterMonuments.map((p) => p.id), [
        'sahip-ata-kulliyesi',
      ]);
    },
  );
}
