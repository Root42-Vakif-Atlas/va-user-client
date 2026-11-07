import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/geo_point.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/map_tile.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';
import 'package:vakif_atlas/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:vakif_atlas/features/nearby_alerts/data/repositories/nearby_monuments_repository_impl.dart';

import '../nearby_alerts_test_data.dart';

class _MockCatalog extends Mock implements CatalogRepository {}

void main() {
  late _MockCatalog catalog;
  late DateTime now;
  late NearbyMonumentsRepositoryImpl repository;
  final bounds = <GeoBounds>[];
  final cursors = <String?>[];

  setUpAll(() => registerFallbackValue(MonumentSearchQuery.empty));

  void respond(List<MonumentSearchResults> pages) {
    var index = 0;
    when(
      () => catalog.searchMonuments(
        query: any(named: 'query'),
        languageCode: any(named: 'languageCode'),
        limit: any(named: 'limit'),
        cursor: any(named: 'cursor'),
        bounds: any(named: 'bounds'),
      ),
    ).thenAnswer((invocation) async {
      bounds.add(invocation.namedArguments[#bounds] as GeoBounds);
      cursors.add(invocation.namedArguments[#cursor] as String?);
      return Right(pages[index++ % pages.length]);
    });
  }

  setUp(() {
    catalog = _MockCatalog();
    now = DateTime(2026, 11, 7, 14);
    repository = NearbyMonumentsRepositoryImpl.withClock(catalog, () => now);
    bounds.clear();
    cursors.clear();
    respond([
      MonumentSearchResults(items: [testMonument()], total: 1),
    ]);
  });

  Future<int> query(GeoPoint point) async {
    final result = await repository.monumentsAround(
      point,
      radiusMeters: 150,
      languageCode: 'tr',
    );
    return result.getOrNull()!.length;
  }

  test('kesin konum değil, ızgara hücresi + yarıçap payı sorgulanır', () async {
    await query(ulucami);

    final box = bounds.single;
    const cell = NearbyMonumentsRepositoryImpl.cellDegrees;
    final south = (ulucami.latitude / cell).floor() * cell;
    final west = (ulucami.longitude / cell).floor() * cell;
    // Kutunun kenarları konuma değil hücreye bağlıdır.
    expect(box.south, closeTo(south - 150 / 111320, 1e-9));
    expect(box.north, closeTo(south + cell + 150 / 111320, 1e-9));
    expect(box.west, lessThan(west));
    expect(box.east, greaterThan(west + cell));
    // Hücrenin herhangi bir noktasından 150 m ötesi kutudadır.
    final edge = northOf(
      GeoPoint(latitude: south + cell, longitude: west),
      149,
    );
    expect(edge.latitude, lessThan(box.north));
  });

  test('aynı hücre önbellekten, komşu hücre yeniden sorgulanır', () async {
    await query(ulucami);
    await query(northOf(ulucami, 20));
    expect(bounds, hasLength(1));

    await query(northOf(ulucami, 800));
    expect(bounds, hasLength(2));
  });

  test('önbellek süresi dolunca hücre yeniden sorgulanır', () async {
    await query(ulucami);
    now = now.add(NearbyMonumentsRepositoryImpl.cacheTtl);
    await query(ulucami);
    expect(bounds, hasLength(2));
  });

  test('yoğun hücrede sonraki sayfalar da alınır (üst sınırla)', () async {
    respond([
      MonumentSearchResults(
        items: [testMonument(id: 'a')],
        total: 500,
        nextCursor: 'next',
      ),
    ]);
    expect(await query(ulucami), NearbyMonumentsRepositoryImpl.maxPages);
    expect(cursors, [null, 'next', 'next', 'next']);
  });

  test('hata kısa süre önbelleğe alınır, sonra yeniden denenir', () async {
    var calls = 0;
    when(
      () => catalog.searchMonuments(
        query: any(named: 'query'),
        languageCode: any(named: 'languageCode'),
        limit: any(named: 'limit'),
        cursor: any(named: 'cursor'),
        bounds: any(named: 'bounds'),
      ),
    ).thenAnswer((_) async {
      calls++;
      return const Left(NetworkFailure());
    });

    final first = await repository.monumentsAround(
      ulucami,
      radiusMeters: 150,
      languageCode: 'tr',
    );
    expect(first.isLeft, isTrue);
    await repository.monumentsAround(
      ulucami,
      radiusMeters: 150,
      languageCode: 'tr',
    );
    expect(calls, 1);

    now = now.add(NearbyMonumentsRepositoryImpl.failureBackoff);
    await repository.monumentsAround(
      ulucami,
      radiusMeters: 150,
      languageCode: 'tr',
    );
    expect(calls, 2);
  });
}
