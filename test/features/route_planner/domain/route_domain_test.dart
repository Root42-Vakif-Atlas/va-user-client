import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/geo_point.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/route_plan.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/travel_route.dart';
import 'package:vakif_atlas/features/route_planner/domain/repositories/route_repository.dart';
import 'package:vakif_atlas/features/route_planner/domain/usecases/optimize_stop_order_usecase.dart';
import 'package:vakif_atlas/features/route_planner/domain/usecases/route_usecases.dart';

import '../../../helpers/catalog_test_utils.dart';

class _MockRouteRepository extends Mock implements RouteRepository {}

RoutePlan _plan({String name = 'Rota', List<RouteStopPlan>? stops}) =>
    RoutePlan(
      name: name,
      stops:
          stops ??
          [RouteStopPlan(monumentId: 'a'), RouteStopPlan(monumentId: 'b')],
    );

/// İlk durak sabitken tüm sıraları deneyerek en kısa yolu bulur.
double _bruteForceShortest(List<GeoPoint> points) {
  var best = double.infinity;
  void permute(List<int> prefix, List<int> rest) {
    if (rest.isEmpty) {
      best = min(
        best,
        OptimizeStopOrderUseCase.pathLength([
          for (final i in prefix) points[i],
        ]),
      );
      return;
    }
    for (final next in rest) {
      permute([...prefix, next], [...rest]..remove(next));
    }
  }

  permute([0], [for (var i = 1; i < points.length; i++) i]);
  return best;
}

void main() {
  group('GeoPoint.distanceTo', () {
    test('İstanbul–Ankara kuş uçuşu ≈ 350 km', () {
      final monuments = {for (final m in fixtureMonuments()) m.id: m};
      final distance = monuments['suleymaniye-camii']!.location!.distanceTo(
        monuments['haci-bayram-veli-camii']!.location!,
      );
      expect(distance / 1000, closeTo(350, 5));
    });
  });

  group('OptimizeStopOrderUseCase', () {
    const optimize = OptimizeStopOrderUseCase();

    test('rastgele nokta kümelerinde kaba kuvvet aramayla aynı uzunluk', () {
      final random = Random(42);
      for (var count = 3; count <= 8; count++) {
        for (var trial = 0; trial < 5; trial++) {
          final points = [
            for (var i = 0; i < count; i++)
              GeoPoint(
                latitude: 36 + random.nextDouble() * 6,
                longitude: 26 + random.nextDouble() * 18,
              ),
          ];
          final order = optimize(points);

          expect(order.first, 0, reason: 'başlangıç sabit kalır');
          expect(order.toSet(), {for (var i = 0; i < count; i++) i});
          expect(
            OptimizeStopOrderUseCase.pathLength([
              for (final i in order) points[i],
            ]),
            closeTo(_bruteForceShortest(points), 1e-6),
          );
        }
      }
    });

    test('10 eserde sıra en çok kuş uçuşu kadar kısalır', () {
      final points = [for (final m in fixtureMonuments()) m.location!];
      final order = optimize(points);

      final optimized = OptimizeStopOrderUseCase.pathLength([
        for (final i in order) points[i],
      ]);
      expect(optimized, lessThan(OptimizeStopOrderUseCase.pathLength(points)));
    });

    test('iki ve daha az durakta sıra değişmez', () {
      expect(optimize(const []), isEmpty);
      expect(
        optimize(const [
          GeoPoint(latitude: 41, longitude: 29),
          GeoPoint(latitude: 40, longitude: 32),
        ]),
        [0, 1],
      );
    });
  });

  group('RoutePlanRules', () {
    test('geçerli plan kabul edilir', () {
      expect(RoutePlanRules.validate(_plan()), isNull);
    });

    test('kurallar sırayla denetlenir', () {
      expect(
        RoutePlanRules.validate(_plan(name: '   ')),
        RoutePlanError.emptyName,
      );
      expect(
        RoutePlanRules.validate(_plan(name: 'x' * 61)),
        RoutePlanError.nameTooLong,
      );
      expect(
        RoutePlanRules.validate(_plan(stops: [RouteStopPlan(monumentId: 'a')])),
        RoutePlanError.tooFewStops,
      );
      expect(
        RoutePlanRules.validate(
          _plan(
            stops: [
              for (var i = 0; i < 11; i++) RouteStopPlan(monumentId: '$i'),
            ],
          ),
        ),
        RoutePlanError.tooManyStops,
      );
      expect(
        RoutePlanRules.validate(
          _plan(
            stops: [
              RouteStopPlan(monumentId: 'a'),
              RouteStopPlan(monumentId: 'a'),
            ],
          ),
        ),
        RoutePlanError.duplicateStop,
      );
      expect(
        RoutePlanRules.validate(
          _plan(
            stops: [
              RouteStopPlan(monumentId: 'a', visit: const Duration(minutes: 5)),
              RouteStopPlan(monumentId: 'b'),
            ],
          ),
        ),
        RoutePlanError.visitOutOfRange,
      );
      expect(
        RoutePlanRules.validate(
          _plan(
            stops: [
              RouteStopPlan(
                monumentId: 'a',
                breaks: [
                  for (var i = 0; i < 4; i++)
                    RouteBreak.ofKind(RouteBreakKind.shortBreak),
                ],
              ),
              RouteStopPlan(monumentId: 'b'),
            ],
          ),
        ),
        RoutePlanError.tooManyBreaks,
      );
      expect(
        RoutePlanRules.validate(
          _plan(
            stops: [
              RouteStopPlan(
                monumentId: 'a',
                breaks: const [
                  RouteBreak(
                    kind: RouteBreakKind.overnight,
                    duration: Duration(hours: 13),
                  ),
                ],
              ),
              RouteStopPlan(monumentId: 'b'),
            ],
          ),
        ),
        RoutePlanError.breakOutOfRange,
      );
    });

    test('süre ayarı 15 dakikalık adıma ve aralığa oturur', () {
      expect(
        RoutePlanRules.clampToStep(
          const Duration(minutes: 52),
          RoutePlanRules.minVisit,
          RoutePlanRules.maxVisit,
        ),
        const Duration(minutes: 45),
      );
      expect(
        RoutePlanRules.clampToStep(
          Duration.zero,
          RoutePlanRules.minVisit,
          RoutePlanRules.maxVisit,
        ),
        RoutePlanRules.minVisit,
      );
    });

    test('mola türlerinin varsayılan süreleri kural aralığındadır', () {
      for (final kind in RouteBreakKind.values) {
        expect(
          kind.defaultDuration.inMinutes,
          inInclusiveRange(
            RoutePlanRules.minBreak.inMinutes,
            RoutePlanRules.maxBreak.inMinutes,
          ),
        );
      }
    });
  });

  group('SaveRouteUseCase', () {
    late _MockRouteRepository repository;

    setUpAll(() => registerFallbackValue(_plan()));

    setUp(() => repository = _MockRouteRepository());

    test('kurala uymayan plan sunucuya gönderilmez', () async {
      final result = await SaveRouteUseCase(repository)(
        SaveRouteParams(
          plan: _plan(name: ''),
          languageCode: 'tr',
        ),
      );

      expect(
        result,
        const Left<Failure, TravelRoute>(
          ServerFailure(
            kind: ServerFailureKind.invalidRequest,
            statusCode: 400,
          ),
        ),
      );
      verifyZeroInteractions(repository);
    });

    test('kimlik verilirse günceller, verilmezse oluşturur', () async {
      when(
        () => repository.createRoute(
          plan: any(named: 'plan'),
          languageCode: 'tr',
        ),
      ).thenAnswer((_) async => const Left(NetworkFailure()));
      when(
        () => repository.updateRoute(
          id: 'rt_1',
          plan: any(named: 'plan'),
          languageCode: 'tr',
        ),
      ).thenAnswer((_) async => const Left(NetworkFailure()));
      final save = SaveRouteUseCase(repository);

      await save(SaveRouteParams(plan: _plan(), languageCode: 'tr'));
      await save(
        SaveRouteParams(plan: _plan(), languageCode: 'tr', routeId: 'rt_1'),
      );

      verify(() => repository.createRoute(plan: _plan(), languageCode: 'tr'))
          .called(1);
      verify(
        () => repository.updateRoute(
          id: 'rt_1',
          plan: _plan(),
          languageCode: 'tr',
        ),
      ).called(1);
    });
  });
}
