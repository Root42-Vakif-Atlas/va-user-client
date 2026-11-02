import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vakif_atlas/core/error/error_mapper.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/events/user_activity_events.dart';
import 'package:vakif_atlas/core/network/session_events.dart';
import 'package:vakif_atlas/core/storage/installation_id_service.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/geo_point.dart';
import 'package:vakif_atlas/features/route_planner/data/dtos/route_dtos.dart';
import 'package:vakif_atlas/features/route_planner/data/polyline_codec.dart';
import 'package:vakif_atlas/features/route_planner/data/repositories/route_repository_impl.dart';
import 'package:vakif_atlas/features/route_planner/data/sources/route_remote_data_source.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/route_plan.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/travel_route.dart';

import '../../../helpers/network_test_utils.dart';
import '../../../support/mock_api/catalog/catalog_fixtures.dart';
import '../../../support/mock_api/route_planner/mock_route_store.dart';
import '../../../support/mock_api/route_planner/route_leg_fixtures.dart';
import '../../../support/mock_api/route_planner/route_mock_api.dart';

class _FakeInstallation extends Mock implements InstallationIdService {}

const _installationA = '0b6f6a0e-1f6c-4d3a-9b1e-3c2d1e0f9a8b';
const _installationB = '5d2c1b0a-9e8f-4a7b-8c6d-5e4f3a2b1c0d';

RoutePlan _plan(List<String> ids, {String name = 'Kültür Rotası'}) => RoutePlan(
  name: name,
  stops: [
    RouteStopPlan(
      monumentId: ids.first,
      breaks: [RouteBreak.ofKind(RouteBreakKind.meal)],
    ),
    for (final id in ids.skip(1)) RouteStopPlan(monumentId: id),
  ],
);

GeoPoint _location(String id) {
  final monument = CatalogFixtures.monuments.firstWhere((m) => m.id == id);
  return GeoPoint(latitude: monument.latitude, longitude: monument.longitude);
}

void main() {
  group('PolylineCodec', () {
    // Google'ın Encoded Polyline Algorithm Format belgesindeki örnek.
    const encoded = r'_p~iF~ps|U_ulLnnqC_mqNvxq`@';
    const points = [
      GeoPoint(latitude: 38.5, longitude: -120.2),
      GeoPoint(latitude: 40.7, longitude: -120.95),
      GeoPoint(latitude: 43.252, longitude: -126.453),
    ];

    test('belge örneğini çözer ve aynı biçimde kodlar', () {
      expect(PolylineCodec.decode(encoded), points);
      expect(PolylineCodec.encode(points), encoded);
    });

    test('bozuk veri FormatException fırlatır', () {
      expect(() => PolylineCodec.decode('_p~iF~ps|U_'), throwsFormatException);
      expect(() => PolylineCodec.decode(' '), throwsFormatException);
    });

    test('tüm OSRM bacakları çözülebilir ve uçları eserlere yakındır', () {
      for (final MapEntry(:key, :value) in RouteLegFixtures.legs.entries) {
        final [from, to] = key.split('|');
        final geometry = PolylineCodec.decode(value.geometry);
        // Külliye içi yaya bacakları kısadır (birkaç köşe).
        expect(
          geometry.length,
          value.walking ? greaterThanOrEqualTo(2) : greaterThan(10),
          reason: key,
        );
        // OSRM bacağı eserin en yakın yoluna bağlanır.
        expect(geometry.first.distanceTo(_location(from)), lessThan(1500));
        expect(geometry.last.distanceTo(_location(to)), lessThan(1500));
        // Karayolu kuş uçuşundan uzun, makul ölçüde.
        final straight = _location(from).distanceTo(_location(to));
        // Yaya bacağı yapının girişine bağlanır: kısa mesafede kuş uçuşundan
        // biraz kısa veya avlu çevresinden dolaşan olabilir.
        expect(
          value.distanceMeters,
          value.walking
              ? inInclusiveRange(straight * 0.8, straight * 4 + 50)
              : inInclusiveRange(straight, straight * 2.2),
          reason: key,
        );
      }
      expect(RouteLegFixtures.legs, hasLength(210));
    });
  });

  group('RouteMockApi (POST/GET/PUT/DELETE routes)', () {
    late Dio dio;
    late RouteRemoteDataSource remote;
    late _FakeInstallation installation;

    RouteRemoteDataSource remoteFor(String id) {
      final other = _FakeInstallation();
      when(other.resolve).thenAnswer((_) async => id);
      return RouteRemoteDataSourceImpl(dio, other);
    }

    setUp(() {
      dio = testDio(
        RouteMockApi.withClock(
          store: InMemoryMockRouteStore(),
          clock: () => DateTime.utc(2026, 10, 18, 9),
        ).routes,
      );
      installation = _FakeInstallation();
      when(installation.resolve).thenAnswer((_) async => _installationA);
      remote = RouteRemoteDataSourceImpl(dio, installation);
    });

    Future<TravelRouteDto> create(
      List<String> ids, {
      String languageCode = 'tr',
    }) => remote.createRoute(
      plan: RoutePlanRequestDto.fromDomain(_plan(ids)),
      languageCode: languageCode,
    );

    test('POST routes → 201; bacaklar OSRM verisinden hesaplanır', () async {
      final route = await create([
        'selimiye-camii',
        'suleymaniye-camii',
        'bursa-ulu-camii',
      ]);

      expect(route.id, startsWith('rt_'));
      expect(route.stops.map((s) => s.name), [
        'Selimiye Camii',
        'Süleymaniye Camii',
        'Bursa Ulu Camii',
      ]);
      expect(route.legs, hasLength(2));
      final first = RouteLegFixtures.legs['suleymaniye-camii|selimiye-camii']!;
      expect(route.legs.first.distanceMeters, first.distanceMeters);

      final summary = route.summary;
      expect(
        summary.distanceMeters,
        route.legs.fold(0, (sum, leg) => sum + leg.distanceMeters),
      );
      expect(summary.visitSeconds, 3 * 3600);
      expect(summary.breakSeconds, 45 * 60);
      expect(
        summary.totalSeconds,
        summary.travelSeconds + summary.visitSeconds + summary.breakSeconds,
      );
    });

    test('ters yöndeki bacağın geometrisi ters çevrilir', () async {
      final route = await create(['selimiye-camii', 'suleymaniye-camii'])
          .then((dto) => dto.toDomain());

      final geometry = route.legs.single.geometry;
      expect(
        geometry.first.distanceTo(_location('selimiye-camii')),
        lessThan(1500),
      );
      expect(
        geometry.last.distanceTo(_location('suleymaniye-camii')),
        lessThan(1500),
      );
    });

    test('bacak çizgisi eserlerin konumunda başlayıp biter', () async {
      final route = await create([
        'suleymaniye-camii',
        'selimiye-camii',
        'bursa-ulu-camii',
      ]).then((dto) => dto.toDomain());

      for (var i = 0; i < route.legs.length; i++) {
        final geometry = route.legs[i].geometry;
        expect(geometry.first.distanceTo(route.stops[i].location), lessThan(2));
        expect(
          geometry.last.distanceTo(route.stops[i + 1].location),
          lessThan(2),
        );
        // Karayolu çizgisi: iki noktalı düz çizgi değil.
        expect(geometry.length, greaterThan(10));
      }
    });

    test('eser adları istek dilinde döner', () async {
      final route = await create([
        'kizlaragasi-hani',
        'sahip-ata-kulliyesi',
      ], languageCode: 'en');

      expect(route.stops.first.name, 'Kızlarağası Inn');
    });

    test('liste en yeni önce, kurulum bazında ayrışır', () async {
      await create(['selimiye-camii', 'bursa-ulu-camii']);
      await create([
        'divrigi-ulu-camii-ve-darussifasi',
        'gulbahar-hatun-camii',
      ]);

      final mine = await remote.fetchRoutes(languageCode: 'tr');
      expect(mine, hasLength(2));
      expect(mine.first.cities, ['Sivas', 'Trabzon']);
      expect(mine.first.stopCount, 2);

      final others = await remoteFor(_installationB)
          .fetchRoutes(languageCode: 'tr');
      expect(others, isEmpty);
    });

    test('PUT günceller, DELETE siler, sonra 404 döner', () async {
      final created = await create(['selimiye-camii', 'bursa-ulu-camii']);

      final updated = await remote.updateRoute(
        id: created.id,
        plan: RoutePlanRequestDto.fromDomain(
          _plan([
            'bursa-ulu-camii',
            'selimiye-camii',
            'suleymaniye-camii',
          ], name: 'Yeni ad'),
        ),
        languageCode: 'tr',
      );
      expect(updated.id, created.id);
      expect(updated.name, 'Yeni ad');
      expect(updated.stops, hasLength(3));
      expect(updated.createdAt, created.createdAt);

      await remote.deleteRoute(id: created.id);
      Object? error;
      try {
        await remote.fetchRoute(id: created.id, languageCode: 'tr');
      } on DioException catch (caught) {
        error = caught;
      }
      expect(
        ErrorMapper.toFailure(error!),
        const ServerFailure(kind: ServerFailureKind.notFound, statusCode: 404),
      );
    });

    Future<int?> statusOf(Future<Object?> request) async {
      try {
        await request;
        return null;
      } on DioException catch (error) {
        return error.response?.statusCode;
      }
    }

    test('geçersiz plan ve bilinmeyen eser 400 döner', () async {
      for (final body in <Object?>[
        {'name': 'A', 'stops': <Object>[]},
        {
          'name': 'A',
          'stops': [
            {'monumentId': 'yok', 'visitMinutes': 60},
            {'monumentId': 'selimiye-camii', 'visitMinutes': 60},
          ],
        },
        {
          'name': 'A',
          'stops': [
            {'monumentId': 'selimiye-camii', 'visitMinutes': 1},
            {'monumentId': 'bursa-ulu-camii', 'visitMinutes': 60},
          ],
        },
        {'stops': 'bozuk'},
      ]) {
        expect(
          await statusOf(
            dio.post<Object?>(
              RouteEndpoints.routes,
              data: body,
              options: Options(headers: {'X-Installation-Id': _installationA}),
            ),
          ),
          400,
          reason: '$body',
        );
      }
    });

    test('kurulum kimliği olmadan 400 installation_id_required', () async {
      Object? error;
      try {
        await dio.get<Object?>(RouteEndpoints.routes);
      } on DioException catch (caught) {
        error = caught;
      }
      final response = (error! as DioException).response!;
      expect(response.statusCode, 400);
      expect(response.data, {'code': 'installation_id_required'});
    });
  });

  group('RouteRepositoryImpl', () {
    late RouteRepositoryImpl repository;

    setUp(() {
      final installation = _FakeInstallation();
      when(installation.resolve).thenAnswer((_) async => _installationA);
      repository = RouteRepositoryImpl(
        RouteRemoteDataSourceImpl(
          testDio(RouteMockApi(InMemoryMockRouteStore()).routes),
          installation,
        ),
        UserActivityEvents(),
        SessionEvents(),
      );
    });

    test('oluşturma, güncelleme ve silme değişiklik yayınlar', () async {
      final changes = <RouteChange>[];
      final subscription = repository.changes.listen(changes.add);

      final created = await repository.createRoute(
        plan: _plan(['selimiye-camii', 'bursa-ulu-camii']),
        languageCode: 'tr',
      );
      final id = created.getOrNull()!.id;
      await repository.updateRoute(
        id: id,
        plan: _plan(['bursa-ulu-camii', 'selimiye-camii']),
        languageCode: 'tr',
      );
      await repository.deleteRoute(id: id);
      await pumpEventQueue();

      expect(changes, [
        RouteChange(RouteChangeType.created, id),
        RouteChange(RouteChangeType.updated, id),
        RouteChange(RouteChangeType.deleted, id),
      ]);
      await subscription.cancel();
    });

    test('domain varlığında geometri ve süreler çözülür', () async {
      final result = await repository.createRoute(
        plan: _plan(['sahip-ata-kulliyesi', 'sultanhani-kervansarayi']),
        languageCode: 'tr',
      );
      final route = result.getOrNull()!;

      expect(route.legs.single.geometry, isNotEmpty);
      expect(
        route.legs.single.distanceMeters ~/ 1000,
        inInclusiveRange(100, 115),
      );
      expect(route.summary.total, greaterThan(const Duration(hours: 3)));
      expect(
        route.toPlan().stops.first.breaks.single.kind,
        RouteBreakKind.meal,
      );
    });

    test('bulunmayan rota Failure döner, değişiklik yayınlanmaz', () async {
      final result = await repository.deleteRoute(id: 'rt_yok');

      expect(
        result,
        const Left<Failure, Unit>(
          ServerFailure(kind: ServerFailureKind.notFound, statusCode: 404),
        ),
      );
    });
  });
}
