import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/error/error_mapper.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_summary.dart';
import 'package:vakif_atlas/features/catalog/data/sources/catalog_remote_data_source.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';

import '../../../helpers/network_test_utils.dart';
import '../../../support/mock_api/catalog/catalog_fixtures.dart';
import '../../../support/mock_api/catalog/catalog_mock_api.dart';

/// Mock Catalog API'nin sözleşmesi ve demo veri setinin bütünlüğü.
///
/// İstekler gerçek `CatalogRemoteDataSourceImpl` üzerinden HTTP katmanına
/// gider; DTO ayrıştırma da uçtan uca doğrulanır.
void main() {
  late CatalogRemoteDataSource remote;

  setUp(() {
    remote = CatalogRemoteDataSourceImpl(testDio(CatalogMockApi().routes));
  });

  /// Liste görünümünün ilk sayfası (10 eser tek sayfaya sığar).
  Future<List<MonumentSummary>> fetchAll(String languageCode) async {
    final page = await remote.searchMonuments(
      query: MonumentSearchQuery.empty,
      languageCode: languageCode,
      limit: 50,
    );
    expect(page.nextCursor, isNull);
    return page.toDomain().items;
  }

  group('GET catalog/monuments', () {
    test('10 ilin temsilcisi ve Süleymaniye Külliyesi yapıları: 20 eser döner '
        '(külliye eser değildir; yapısı olmayanlar 10 farklı ilden)', () async {
      final monuments = await fetchAll('tr');

      expect(monuments, hasLength(20));
      expect({for (final m in monuments) m.id}, hasLength(20));
      final topLevel = [
        for (final m in monuments)
          if (m.complex == null) m,
      ];
      expect(topLevel, hasLength(9));
      expect({for (final m in monuments) m.city}, hasLength(10));
      expect([
        for (final m in monuments)
          if (m.complex?.id == 'suleymaniye-kulliyesi') m.id,
      ], hasLength(11));
    });

    test('her eserin adı, açıklaması, il, ilçe ve adresi dolu', () async {
      final monuments = await fetchAll('tr');

      for (final monument in monuments) {
        expect(monument.name, isNotEmpty, reason: monument.id);
        expect(monument.shortDescription, isNotEmpty, reason: monument.id);
        expect(monument.city, isNotEmpty, reason: monument.id);
        expect(monument.district, isNotEmpty, reason: monument.id);
        expect(monument.address, contains(monument.city), reason: monument.id);
        expect(monument.thumbnailUrl, startsWith('https://'));
      }
    });

    test('koordinatlar Türkiye sınırları içinde ve geçerli', () async {
      final monuments = await fetchAll('tr');

      for (final monument in monuments) {
        final location = monument.location!;
        expect(location.isValid, isTrue, reason: monument.id);
        expect(location.latitude, inInclusiveRange(35.8, 42.2));
        expect(location.longitude, inInclusiveRange(25.6, 44.9));
      }
    });

    test('liste Türk alfabesi sırasındadır', () async {
      final monuments = await fetchAll('tr');

      expect(
        [for (final m in monuments) m.name],
        [
          'Bursa Ulu Camii',
          'Divriği Ulu Camii ve Darüşşifası',
          'Diyarbakır Ulu Camii',
          'Evvel ve Sani Medreseleri',
          'Gülbahar Hatun Camii',
          'Hacı Bayram-ı Veli Camii',
          'Hürrem Sultan Türbesi',
          'Kanuni Sultan Süleyman Türbesi',
          'Kızlarağası Hanı',
          'Mimar Sinan Türbesi',
          'Sahip Ata Külliyesi',
          'Salis ve Rabi Medreseleri',
          'Selimiye Camii',
          'Sultanhanı Kervansarayı',
          'Süleymaniye Camii',
          'Süleymaniye Darülkurrası',
          'Süleymaniye Darüşşifası',
          'Süleymaniye Hamamı',
          'Süleymaniye İmareti (Darüzziyafe)',
          'Süleymaniye Sıbyan Mektebi',
        ],
      );
    });

    test('içerik Accept-Language başlığına göre yerelleşir', () async {
      final turkish = await fetchAll('tr');
      final english = await fetchAll('en');

      MonumentSummary byId(List<MonumentSummary> list) =>
          list.firstWhere((m) => m.id == 'suleymaniye-camii');

      expect(byId(turkish).name, 'Süleymaniye Camii');
      expect(byId(english).name, 'Süleymaniye Mosque');
      expect(byId(english).city, 'İstanbul');
    });

    test('desteklenmeyen dilde Türkçe içerik döner', () async {
      final monuments = await fetchAll('de');

      expect(monuments.map((m) => m.name), contains('Selimiye Camii'));
    });
  });

  group('GET catalog/monuments/{id}', () {
    test('her eserin detayında lisanslı fotoğraf bulunur (bağımsız eser ve '
        'külliyede 3–5, külliye yapısında 1–5)', () async {
      for (final fixture in CatalogFixtures.monuments.where(
        (m) => !m.isComplex,
      )) {
        final detail = (await remote.fetchMonumentDetail(
          id: fixture.id,
          languageCode: 'tr',
        )).toDomain();

        expect(
          detail.images.length,
          inInclusiveRange(fixture.complexId == null ? 3 : 1, 5),
          reason: detail.id,
        );
        for (final image in detail.images) {
          expect(image.url, startsWith('https://'));
          expect(image.thumbnailUrl, startsWith('https://'));
          expect(image.altText, isNotEmpty);
          expect(image.author, isNotEmpty);
          expect(image.license, matches(RegExp(r'^(CC BY(-SA)? \d\.\d|CC0)$')));
          expect(image.sourceName, 'Wikimedia Commons');
          expect(image.sourceUrl, startsWith('https://commons.wikimedia.org/'));
        }
      }
    });

    test('detay alanları doludur ve İngilizce içerik sunulur', () async {
      final detail = (await remote.fetchMonumentDetail(
        id: 'divrigi-ulu-camii-ve-darussifasi',
        languageCode: 'en',
      )).toDomain();

      expect(detail.name, 'Divriği Great Mosque and Hospital');
      expect(detail.description, isNotEmpty);
      expect(detail.history, contains('1985'));
      expect(detail.constructionDate, '1228–1229');
      expect(detail.architect, 'Hürrem Shah');
      expect(detail.isUnescoWorldHeritage, isTrue);
      expect(detail.images.first.altText, isNot(contains('Darüşşifa')));
    });

    test('mimarı bilinmeyen eserde architect null döner', () async {
      final detail = (await remote.fetchMonumentDetail(
        id: 'kizlaragasi-hani',
        languageCode: 'tr',
      )).toDomain();

      expect(detail.architect, isNull);
      expect(detail.founder, 'Hacı Beşir Ağa');
    });

    test('bilinmeyen kimlik 404 → ServerFailure(notFound)', () async {
      Object? error;
      try {
        await remote.fetchMonumentDetail(id: 'yok', languageCode: 'tr');
      } on DioException catch (caught) {
        error = caught;
      }

      expect(
        ErrorMapper.toFailure(error!),
        const ServerFailure(kind: ServerFailureKind.notFound, statusCode: 404),
      );
    });
  });
}
