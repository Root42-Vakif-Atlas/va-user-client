import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/storage/cache_store.dart';
import 'package:vakif_atlas/core/storage/local_db_service.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/features/catalog/data/dtos/monument_dtos.dart';
import 'package:vakif_atlas/features/catalog/data/dtos/monument_search_dtos.dart';
import 'package:vakif_atlas/features/catalog/data/repositories/catalog_repository_impl.dart';
import 'package:vakif_atlas/features/catalog/data/sources/catalog_local_data_source.dart';
import 'package:vakif_atlas/features/catalog/data/sources/catalog_remote_data_source.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_classification.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_detail.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';

import '../../../helpers/network_test_utils.dart';
import '../../../support/mock_api/catalog/catalog_mock_api.dart';

class _MockRemote extends Mock implements CatalogRemoteDataSource {}

class _MockLocal extends Mock implements CatalogLocalDataSource {}

const _pin = MonumentPinDto(
  key: 'm1',
  title: 'Eser',
  category: MonumentCategory.mosque,
  city: CityRefDto(code: 34, name: 'İl'),
  district: 'İlçe',
  location: GeoPointDto(latitude: 41, longitude: 29),
);

MonumentPinPageDto _page(List<MonumentPinDto> items, {String? next}) =>
    MonumentPinPageDto(items: items, total: items.length, nextCursor: next);

void main() {
  group('CatalogRepositoryImpl (sahte kaynaklarla)', () {
    late _MockRemote remote;
    late _MockLocal local;
    late CatalogRepositoryImpl repository;

    setUp(() {
      remote = _MockRemote();
      local = _MockLocal();
      repository = CatalogRepositoryImpl(remote, local);
    });

    Future<Object?> pins(List<String> ids, {String language = 'tr'}) async {
      final result = await repository.getMonumentPins(
        ids: ids,
        languageCode: language,
      );
      return result.fold((failure) => failure, (pins) => pins);
    }

    test('kimlik yoksa ağa gidilmez', () async {
      expect(await pins(const []), isEmpty);
      verifyZeroInteractions(remote);
    });

    test('durak eserleri tek istekte kimlikle çözülür; önbellek '
        'kullanılmaz', () async {
      when(
        () => remote.fetchMonumentPins(
          ids: any(named: 'ids'),
          languageCode: 'en',
        ),
      ).thenAnswer((_) async => _page([_pin]));

      final result = await pins(const ['m1', 'm9'], language: 'en');

      expect([for (final pin in result! as List<MonumentPin>) pin.id], ['m1']);
      verify(
        () => remote.fetchMonumentPins(ids: ['m1', 'm9'], languageCode: 'en'),
      ).called(1);
      verifyZeroInteractions(local);
    });

    test('ağ hatası NetworkFailure olarak döner', () async {
      when(
        () => remote.fetchMonumentPins(
          ids: any(named: 'ids'),
          languageCode: any(named: 'languageCode'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      expect(await pins(const ['m1']), const NetworkFailure());
    });
  });

  group('CatalogRepositoryImpl (Mock API + gerçek önbellek)', () {
    late Directory directory;
    late LocalDbService database;
    late DateTime now;
    late CatalogRepositoryImpl repository;
    late int requests;

    setUp(() async {
      directory = await Directory.systemTemp.createTemp('vakif_atlas_catalog');
      database = LocalDbService.withInitializer(
        () async => Hive.init(directory.path),
      );
      now = DateTime(2026, 10, 17, 12);
      requests = 0;
      final dio = testDio(CatalogMockApi().routes)
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              requests++;
              handler.next(options);
            },
          ),
        );
      repository = CatalogRepositoryImpl(
        CatalogRemoteDataSourceImpl(dio),
        CatalogLocalDataSourceImpl(CacheStore.withClock(database, () => now)),
      );
    });

    tearDown(() async {
      await database.close();
      await directory.delete(recursive: true);
    });

    test(
      'kimlikle yalnızca istenen eserler döner; bilinmeyen atlanır',
      () async {
        final result = await repository.getMonumentPins(
          ids: const ['selimiye-camii', 'yok', 'kizlaragasi-hani'],
          languageCode: 'tr',
        );

        expect(
          {for (final pin in result.getOrNull()!) pin.id},
          {'selimiye-camii', 'kizlaragasi-hani'},
        );
        expect(requests, 1);
      },
    );

    test('detay önbellekten okunduğunda içerik aynıdır', () async {
      final first = await repository.getMonumentDetail(
        id: 'selimiye-camii',
        languageCode: 'tr',
      );
      final second = await repository.getMonumentDetail(
        id: 'selimiye-camii',
        languageCode: 'tr',
      );

      expect(requests, 1);
      expect(second, first);
      expect(second.getOrNull()!.images, hasLength(5));
    });

    test('bilinmeyen eser ServerFailure(notFound) döner', () async {
      final result = await repository.getMonumentDetail(
        id: 'yok',
        languageCode: 'tr',
      );

      expect(
        result,
        const Left<Failure, MonumentDetail>(
          ServerFailure(kind: ServerFailureKind.notFound, statusCode: 404),
        ),
      );
    });

    test('bozuk önbellek kaydı silinir ve API yeniden çağrılır', () async {
      await CacheStore.withClock(database, () => now).put(
        'catalog.monument.v2.tr.selimiye-camii',
        {'unexpected': true},
        ttl: CatalogLocalDataSourceImpl.ttl,
      );

      final result = await repository.getMonumentDetail(
        id: 'selimiye-camii',
        languageCode: 'tr',
      );

      expect(result.getOrNull()!.id, 'selimiye-camii');
      expect(requests, 1);
    });
  });
}
