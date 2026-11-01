import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/geo_point.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_classification.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/travel_route.dart';
import 'package:vakif_atlas/features/route_planner/domain/repositories/route_repository.dart';
import 'package:vakif_atlas/features/route_planner/domain/usecases/route_usecases.dart';
import 'package:vakif_atlas/features/route_planner/presentation/cubit/route_detail_cubit.dart';
import 'package:vakif_atlas/features/route_planner/presentation/cubit/route_list_cubit.dart';

class _MockRouteRepository extends Mock implements RouteRepository {}

const _summary = RouteSummary(
  distanceMeters: 1000,
  travel: Duration(minutes: 10),
  visit: Duration(hours: 1),
  breaks: Duration.zero,
);

RouteOverview _overview(String id) => RouteOverview(
  id: id,
  name: id,
  createdAt: DateTime.utc(2026, 10, 18),
  cities: const ['Edirne', 'Bursa'],
  stopCount: 2,
  summary: _summary,
);

TravelRoute _route(String id, {String name = 'Rota'}) => TravelRoute(
  id: id,
  name: name,
  createdAt: DateTime.utc(2026, 10, 18),
  updatedAt: DateTime.utc(2026, 10, 18),
  stops: [
    RouteStop(
      monumentId: 'selimiye-camii',
      name: 'Selimiye Camii',
      city: 'Edirne',
      district: 'Merkez',
      category: MonumentCategory.mosque,
      location: const GeoPoint(latitude: 41.67, longitude: 26.55),
      visit: const Duration(hours: 1),
    ),
  ],
  legs: const [],
  summary: _summary,
);

/// Olay döngüsünü boşaltır (akış dinleyicileri ve use case'ler).
Future<void> _settle() => Future<void>.delayed(Duration.zero);

void main() {
  late _MockRouteRepository repository;
  late StreamController<RouteChange> changes;

  setUp(() {
    repository = _MockRouteRepository();
    changes = StreamController<RouteChange>.broadcast();
    when(() => repository.changes).thenAnswer((_) => changes.stream);
  });

  tearDown(() => changes.close());

  group('RouteListCubit', () {
    RouteListCubit build() => RouteListCubit(
      GetRoutesUseCase(repository),
      WatchRouteChangesUseCase(repository),
    );

    test('yükler; değişiklik gelince aynı dilde yeniler', () async {
      var routes = [_overview('rt_1')];
      when(() => repository.getRoutes(languageCode: any(named: 'languageCode')))
          .thenAnswer((_) async => Right(routes));
      final cubit = build();

      await cubit.load('en');
      expect(cubit.state.status, RouteListStatus.success);
      expect(cubit.state.routes.map((r) => r.id), ['rt_1']);

      routes = [_overview('rt_2'), _overview('rt_1')];
      changes.add(const RouteChange(RouteChangeType.created, 'rt_2'));
      await _settle();
      await _settle();

      expect(cubit.state.routes.map((r) => r.id), ['rt_2', 'rt_1']);
      verify(() => repository.getRoutes(languageCode: 'en')).called(2);
      await cubit.close();
    });

    test('hata durumunu taşır; kapatılınca değişiklik dinlenmez', () async {
      when(() => repository.getRoutes(languageCode: any(named: 'languageCode')))
          .thenAnswer((_) async => const Left(NetworkFailure()));
      final cubit = build();

      await cubit.load('tr');
      expect(cubit.state.status, RouteListStatus.failure);
      expect(cubit.state.failure, const NetworkFailure());

      await cubit.close();
      changes.add(const RouteChange(RouteChangeType.deleted, 'rt_1'));
      await _settle();
      verify(
        () => repository.getRoutes(languageCode: any(named: 'languageCode')),
      ).called(1);
    });
  });

  group('RouteDetailCubit', () {
    RouteDetailCubit build() => RouteDetailCubit(
      GetRouteUseCase(repository),
      DeleteRouteUseCase(repository),
      WatchRouteChangesUseCase(repository),
    );

    void stubRoute(TravelRoute Function() route) => when(
      () => repository.getRoute(
        id: any(named: 'id'),
        languageCode: any(named: 'languageCode'),
      ),
    ).thenAnswer((_) async => Right(route()));

    test('yalnızca kendi rotası güncellenince yeniden yükler', () async {
      var name = 'İlk';
      stubRoute(() => _route('rt_1', name: name));
      final cubit = build();
      await cubit.load(id: 'rt_1', languageCode: 'tr');
      expect(cubit.state.route?.name, 'İlk');

      name = 'Yeni ad';
      changes
        ..add(const RouteChange(RouteChangeType.updated, 'rt_2'))
        ..add(const RouteChange(RouteChangeType.updated, 'rt_1'));
      await _settle();
      await _settle();

      expect(cubit.state.route?.name, 'Yeni ad');
      verify(() => repository.getRoute(id: 'rt_1', languageCode: 'tr'))
          .called(2);
      await cubit.close();
    });

    test('404 isNotFound olarak işaretlenir', () async {
      when(
        () => repository.getRoute(
          id: any(named: 'id'),
          languageCode: any(named: 'languageCode'),
        ),
      ).thenAnswer(
        (_) async => const Left(
          ServerFailure(kind: ServerFailureKind.notFound, statusCode: 404),
        ),
      );
      final cubit = build();

      await cubit.load(id: 'rt_yok', languageCode: 'tr');

      expect(cubit.state.isNotFound, isTrue);
      await cubit.close();
    });

    test('silme başarısızsa rota görünür kalır, hata taşınır', () async {
      stubRoute(() => _route('rt_1'));
      when(() => repository.deleteRoute(id: any(named: 'id')))
          .thenAnswer((_) async => const Left(NetworkFailure()));
      final cubit = build();
      await cubit.load(id: 'rt_1', languageCode: 'tr');

      await cubit.delete();

      expect(cubit.state.status, RouteDetailStatus.loaded);
      expect(cubit.state.route, isNotNull);
      expect(cubit.state.deleteFailure, const NetworkFailure());
      await cubit.close();
    });

    test('silme başarılıysa deleted', () async {
      stubRoute(() => _route('rt_1'));
      when(() => repository.deleteRoute(id: any(named: 'id')))
          .thenAnswer((_) async => const Right(unit));
      final cubit = build();
      await cubit.load(id: 'rt_1', languageCode: 'tr');

      await cubit.delete();

      expect(cubit.state.status, RouteDetailStatus.deleted);
      verify(() => repository.deleteRoute(id: 'rt_1')).called(1);
      await cubit.close();
    });
  });
}
