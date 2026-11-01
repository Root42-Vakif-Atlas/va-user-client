import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/features/catalog/data/dtos/map_tile_dtos.dart';
import 'package:vakif_atlas/features/catalog/data/dtos/monument_dtos.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/complex.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/map_tile.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_classification.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';
import 'package:vakif_atlas/features/catalog/domain/usecases/catalog_usecases.dart';

import '../../../helpers/catalog_test_utils.dart';

/// `GET catalog/complexes/{id}` ve `…/monuments` sözleşmesi; istekler gerçek
/// veri kaynağı ve repository üzerinden mock sunucuya gider.
void main() {
  final useCases = catalogUseCases();
  const suleymaniye = 'suleymaniye-kulliyesi';

  Future<ComplexDetail> detail(String id, {String language = 'tr'}) async =>
      (await useCases.complexDetail(
        GetMonumentDetailParams(id: id, languageCode: language),
      )).fold((f) => fail('$f'), (complex) => complex);

  Future<ComplexMemberResults> members({
    String? cursor,
    int limit = 20,
    Set<MonumentCategory> categories = const {},
  }) async => (await useCases.complexMembers(
    GetComplexMembersParams(
      complexId: suleymaniye,
      languageCode: 'tr',
      cursor: cursor,
      limit: limit,
      categories: categories,
    ),
  )).fold((f) => fail('$f'), (page) => page);

  group('külliye detayı', () {
    test('kayıt, yerleşim alanı ve üyelerin ilk sayfası tek yanıtta', () async {
      final complex = await detail(suleymaniye);

      expect(complex.monument.name, 'Süleymaniye Külliyesi');
      expect(complex.monument.isComplex, isTrue);
      expect(complex.memberCount, 11);
      expect(complex.footprint.length, greaterThanOrEqualTo(3));
      expect(complex.members.total, 11);
      expect(complex.members.hasMore, isFalse);
      // Küratörlü sıra: cami önce, Mimar Sinan Türbesi en son.
      expect(complex.members.items.first.id, 'suleymaniye-camii');
      expect(complex.members.items.last.id, 'mimar-sinan-turbesi');
      expect(complex.members.items.map((m) => m.complex?.name).toSet(), {
        'Süleymaniye Külliyesi',
      });
    });

    test('yerleşim alanı tüm yapıları kapsar (25 m tampon)', () async {
      final complex = await detail(suleymaniye);
      final bounds = complex.bounds!;
      final south = complex.footprint
          .map((p) => p.latitude)
          .reduce((a, b) => a < b ? a : b);
      final north = complex.footprint
          .map((p) => p.latitude)
          .reduce((a, b) => a > b ? a : b);
      expect(south, lessThan(bounds.south));
      expect(north, greaterThan(bounds.north));
      for (final member in complex.members.items) {
        expect(member.location!.latitude, inInclusiveRange(south, north));
      }
    });

    test('içerik dile göre; üyelik referansı da yerelleşir', () async {
      final complex = await detail(suleymaniye, language: 'en');
      expect(complex.monument.name, 'Süleymaniye Complex');
      expect(complex.members.items.first.complex?.name, 'Süleymaniye Complex');
    });

    test('bilinmeyen veya külliye olmayan kayıt 404', () async {
      // Divriği Ulu Camii ve Darüşşifası sunucuda tek eserdir.
      for (final id in [
        'yok',
        'selimiye-camii',
        'divrigi-ulu-camii-ve-darussifasi',
      ]) {
        final result = await useCases.complexDetail(
          GetMonumentDetailParams(id: id, languageCode: 'tr'),
        );
        expect(
          result.fold((f) => f, (_) => null),
          const ServerFailure(
            kind: ServerFailureKind.notFound,
            statusCode: 404,
          ),
          reason: id,
        );
      }
    });
  });

  group('külliye üyeleri', () {
    test('imleçle sayfalanır; tekrar veya atlama yok', () async {
      final seen = <String>[];
      String? cursor;
      do {
        final page = await members(cursor: cursor, limit: 4);
        seen.addAll(page.items.map((m) => m.id));
        cursor = page.nextCursor;
      } while (cursor != null);
      expect(seen, hasLength(11));
      expect(seen.toSet(), hasLength(11));
    });

    test('türe göre süzülür', () async {
      final tombs = await members(categories: {MonumentCategory.tomb});
      expect(tombs.items.map((m) => m.id), [
        'kanuni-sultan-suleyman-turbesi',
        'hurrem-sultan-turbesi',
        'mimar-sinan-turbesi',
      ]);
      expect(tombs.total, 3);
    });
  });

  group('üyelik alanları', () {
    test('eser detayında külliye referansı; külliyede yapı sayısı', () async {
      final member = (await useCases.detail(
        const GetMonumentDetailParams(
          id: 'hurrem-sultan-turbesi',
          languageCode: 'tr',
        ),
      )).fold((f) => fail('$f'), (m) => m);
      expect(member.complex?.id, suleymaniye);
      expect(member.isComplex, isFalse);

      final complex = (await useCases.detail(
        const GetMonumentDetailParams(id: suleymaniye, languageCode: 'tr'),
      )).fold((f) => fail('$f'), (m) => m);
      expect(complex.isComplex, isTrue);
      expect(complex.memberCount, 11);
    });

    test('arama özetleri ve konum kayıtları üyeliği taşır', () async {
      final page = (await useCases.search(
        const SearchMonumentsParams(
          query: MonumentSearchQuery(text: 'darussifa'),
          languageCode: 'tr',
        ),
      )).fold((f) => fail('$f'), (p) => p);
      final hospital = page.items.firstWhere(
        (m) => m.id == 'suleymaniye-darussifasi',
      );
      expect(hospital.complex?.name, 'Süleymaniye Külliyesi');
      expect(hospital.category, MonumentCategory.hospital);

      // Külliye eser değildir: `works?keys=` yalnızca yapıyı çözer.
      final pins = (await useCases.pins(
        const GetMonumentPinsParams(
          ids: [suleymaniye, 'suleymaniye-hamami'],
          languageCode: 'tr',
        ),
      )).fold((f) => fail('$f'), (p) => p);
      expect(pins.map((p) => p.id), ['suleymaniye-hamami']);
      expect(pins.single.complex?.id, suleymaniye);
    });
  });

  group('DTO', () {
    test('karo külliye öğesi alanıyla ayrışır; bozuk köşe atlanır', () {
      final item = MapTileItemDto.fromJson(const {
        'type': 'complex',
        'key': 'k',
        'name': 'Külliye',
        'city': {'code': 34, 'name': 'İstanbul'},
        'district': 'Fatih',
        'lat': 41.0,
        'lng': 29.0,
        'workCount': 3,
        'footprint': [
          [41.0, 29.0],
          [41.001, 29.0],
          [41.001],
          [41.0, 29.001],
        ],
      }).toDomain();
      final complex = item! as MapTileComplex;
      expect(complex.pin.isComplex, isTrue);
      expect(complex.pin.category, MonumentCategory.complex);
      expect(complex.pin.memberCount, 3);
      expect(complex.pin.city, 'İstanbul');
      expect(complex.footprint, hasLength(3));
    });

    test('karo eser öğesi külliye referansını taşır', () {
      final item = MapTileItemDto.fromJson(const {
        'type': 'work',
        'key': 'm',
        'slug': 'm',
        'title': 'Türbe',
        'category': 'tomb',
        'city': {'code': 34, 'name': 'İstanbul'},
        'district': 'Fatih',
        'lat': 41.0,
        'lng': 29.0,
        'complex': {'key': 'k', 'name': 'Külliye'},
      }).toDomain();
      final pin = (item! as MapTileMonument).pin;
      expect(pin.id, 'm');
      expect(pin.name, 'Türbe');
      expect(pin.complex?.id, 'k');
      expect(pin.complex?.name, 'Külliye');
      expect(pin.category, MonumentCategory.tomb);
    });

    test('eski istemci uyumu: bilinmeyen yeni tür other olarak okunur', () {
      final summary = MonumentSummaryDto.fromJson(const {
        'key': 'x',
        'slug': 'x',
        'title': 'X',
        'category': 'observatory',
        'period': 'ottoman',
        'city': {'code': 34, 'name': 'İstanbul'},
        'district': 'Fatih',
        'address': 'Adres',
        'location': {'latitude': 41.0, 'longitude': 29.0},
        'shortDescription': 'Kısa',
      }).toDomain();
      expect(summary.category, MonumentCategory.other);
      expect(summary.isComplex, isFalse);
      expect(summary.complex, isNull);
    });
  });
}
