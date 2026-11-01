import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/features/catalog/data/dtos/monument_search_dtos.dart';
import 'package:vakif_atlas/features/catalog/data/sources/catalog_remote_data_source.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_classification.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_filter.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';
import 'package:vakif_atlas/features/catalog/domain/usecases/catalog_usecases.dart';

import '../../../helpers/catalog_test_utils.dart';
import '../../../helpers/network_test_utils.dart';
import '../../../support/mock_api/catalog/catalog_mock_api.dart';

/// `GET catalog/monuments` (arama, filtre, `view=location&ids=`)
/// sözleşmesi; istekler gerçek veri kaynağı ve repository üzerinden mock
/// sunucuya gider.
void main() {
  final useCases = catalogUseCases();

  Future<MonumentSearchResults> search(
    MonumentSearchQuery query, {
    String? cursor,
    int limit = 20,
    SearchMonumentsUseCase? useCase,
  }) async {
    final result = await (useCase ?? useCases.search)(
      SearchMonumentsParams(
        query: query,
        languageCode: 'tr',
        cursor: cursor,
        limit: limit,
      ),
    );
    return result.fold((f) => fail('beklenmeyen hata: $f'), (page) => page);
  }

  List<String> ids(MonumentSearchResults page) => [
    for (final item in page.items) item.id,
  ];

  group('arama', () {
    test('Türkçe harf/aksan duyarsız; tek sayfada imleç yok', () async {
      for (final text in ['suleyman', 'SÜLEYMANİYE']) {
        final page = await search(MonumentSearchQuery(text: text));
        // Ad başı eşleşmeleri önce, alfabetik; külliye yapıları ayrı
        // satırlardır (adresleri de "Süleymaniye Mahallesi"). Külliyenin
        // kendisi eser değildir, listede yoktur.
        expect(ids(page).first, 'suleymaniye-camii', reason: text);
        expect(ids(page), isNot(contains('suleymaniye-kulliyesi')));
        expect(page.total, 11);
        expect(page.nextCursor, isNull);
      }
    });

    test('alaka sırası: ad eşleşmesi adres eşleşmesinden önce', () async {
      final page = await search(const MonumentSearchQuery(text: 'ulu'));
      expect(ids(page), [
        'bursa-ulu-camii',
        'divrigi-ulu-camii-ve-darussifasi',
        'diyarbakir-ulu-camii',
        // Adreste "Ulus" geçer.
        'haci-bayram-veli-camii',
      ]);
    });

    test('boş sorgu tüm eserleri alfabetik listeler', () async {
      final page = await search(MonumentSearchQuery.empty);
      expect(page.total, 20);
      expect(page.items.first.name, 'Bursa Ulu Camii');
      expect(page.places, isEmpty);
    });

    test(
      'filtreler sorgu parametresidir; facet sayıları disjunctive',
      () async {
        final page = await search(
          const MonumentSearchQuery(
            filter: MonumentFilter(categories: {MonumentCategory.mosque}),
          ),
        );
        expect(page.total, 6);
        // Kendi grubunda diğer seçenekler de sayılır.
        expect(page.facets.categories[MonumentCategory.inn], 1);
        expect(page.facets.categories[MonumentCategory.mosque], 6);
        // Diğer gruplar seçili türle daraltılır.
        expect(page.facets.periods[HistoricalPeriod.seljuk], 1);
        expect(page.facets.periods[HistoricalPeriod.ottoman], 5);
        expect(page.facets.cities.containsKey(35), isFalse); // İzmir
        expect(page.facets.cityNames[34], 'İstanbul');
      },
    );

    test('il/ilçe önerileri sayılarıyla döner', () async {
      final page = await search(const MonumentSearchQuery(text: 'divrigi'));
      final place = page.places.single;
      expect(
        (place.city, place.district, place.count),
        ('Sivas', 'Divriği', 1),
      );
      // Haritada sığdırma için bölgenin sınırı.
      expect(place.bounds!.isPoint, isTrue);
    });
  });

  group('sayfalama', () {
    final large = catalogUseCases(
      CatalogMockApi.withMonuments(syntheticMonuments(45)),
    );

    test(
      'imleçle 20 + 20 + 5; tekrar yok; facet yalnızca ilk sayfada',
      () async {
        final first = await search(
          MonumentSearchQuery.empty,
          useCase: large.search,
        );
        expect(first.items, hasLength(20));
        expect(first.total, 45);
        expect(first.hasMore, isTrue);
        expect(first.facets.isEmpty, isFalse);

        final second = await search(
          MonumentSearchQuery.empty,
          cursor: first.nextCursor,
          useCase: large.search,
        );
        expect(second.items, hasLength(20));
        expect(second.facets.isEmpty, isTrue);

        final third = await search(
          MonumentSearchQuery.empty,
          cursor: second.nextCursor,
          useCase: large.search,
        );
        expect(third.items, hasLength(5));
        expect(third.nextCursor, isNull);

        final all = [...ids(first), ...ids(second), ...ids(third)];
        expect(all.toSet(), hasLength(45));
        expect(all.first, 'test-000');
        expect(all.last, 'test-044');
      },
    );

    test('sayfa boyutu 1–50 aralığına sıkıştırılır', () async {
      final page = await search(
        MonumentSearchQuery.empty,
        limit: 500,
        useCase: catalogUseCases(
          CatalogMockApi.withMonuments(syntheticMonuments(60)),
        ).search,
      );
      expect(page.items, hasLength(SearchMonumentsParams.maxPageSize));
    });

    test('geçersiz imleç 400 → ServerFailure', () async {
      final result = await large.search(
        const SearchMonumentsParams(
          query: MonumentSearchQuery.empty,
          languageCode: 'tr',
          cursor: 'bozuk',
        ),
      );
      expect(result, isA<Left<Failure, MonumentSearchResults>>());
      expect(
        result.fold((f) => f, (_) => null),
        isA<ServerFailure>().having((f) => f.statusCode, 'status', 400),
      );
    });
  });

  group('pinler', () {
    test(
      'kimlikle istenen eserlerin hafif kayıtları (ids, view=location)',
      () async {
        final result = await useCases.pins(
          const GetMonumentPinsParams(
            ids: ['kizlaragasi-hani', 'yok'],
            languageCode: 'en',
          ),
        );
        final pins = result.fold((f) => fail('$f'), (p) => p);
        expect(pins.map((p) => p.id), ['kizlaragasi-hani']);
        expect(pins.single.location!.isValid, isTrue);
      },
    );

    test("50'den fazla kimlik 400 döner", () async {
      final response = await testDio(CatalogMockApi().routes).get<Object?>(
        CatalogEndpoints.monuments,
        queryParameters: {
          'view': 'location',
          'keys': [for (var i = 0; i < 51; i++) 'm$i'].join(','),
        },
        options: Options(validateStatus: (_) => true),
      );
      expect(response.statusCode, 400);
    });
  });

  test('sorgu parametreleri sıralı ve boş ölçütsüz üretilir', () {
    expect(
      CatalogQueryParameters.of(
        const MonumentSearchQuery(
          text: '  ulu  ',
          filter: MonumentFilter(
            categories: {MonumentCategory.mosque, MonumentCategory.complex},
            cities: {58, 16},
          ),
        ),
      ),
      {'q': 'ulu', 'category': 'complex,mosque', 'city': '16,58'},
    );
    expect(CatalogQueryParameters.of(MonumentSearchQuery.empty), isEmpty);
  });

  test('bilinmeyen facet türü "other" altında toplanır', () {
    final facets = const MonumentFacetsDto(
      category: {'mosque': 2, 'library': 3, 'other': 1},
    ).toDomain();
    expect(facets.categories, {
      MonumentCategory.mosque: 2,
      MonumentCategory.other: 4,
    });
  });
}
