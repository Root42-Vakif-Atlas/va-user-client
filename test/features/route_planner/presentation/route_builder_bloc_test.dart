import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';
import 'package:vakif_atlas/features/catalog/domain/usecases/catalog_usecases.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/route_plan.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/travel_route.dart';
import 'package:vakif_atlas/features/route_planner/domain/usecases/optimize_stop_order_usecase.dart';
import 'package:vakif_atlas/features/route_planner/domain/usecases/route_usecases.dart';
import 'package:vakif_atlas/features/route_planner/presentation/bloc/route_builder_bloc.dart';

import '../../../helpers/catalog_test_utils.dart';

class _MockGetMonuments extends Mock implements GetMonumentPinsUseCase {}

class _MockGetRoute extends Mock implements GetRouteUseCase {}

class _MockSaveRoute extends Mock implements SaveRouteUseCase {}

class _MockPreviewRoute extends Mock implements PreviewRouteUseCase {}

class _MockTravelMatrix extends Mock implements GetTravelMatrixUseCase {}

const _selimiye = 'selimiye-camii';
const _suleymaniye = 'suleymaniye-camii';
const _bursa = 'bursa-ulu-camii';
const _izmir = 'kizlaragasi-hani';

TravelRoute _savedRoute(RoutePlan plan, {String id = 'rt_1'}) {
  final monuments = {for (final m in fixturePins()) m.id: m};
  return TravelRoute(
    id: id,
    name: plan.name,
    createdAt: DateTime.utc(2026, 10, 18),
    updatedAt: DateTime.utc(2026, 10, 18),
    stops: [
      for (final stop in plan.stops)
        RouteStop(
          monumentId: stop.monumentId,
          name: monuments[stop.monumentId]!.name,
          city: monuments[stop.monumentId]!.city,
          district: monuments[stop.monumentId]!.district,
          category: monuments[stop.monumentId]!.category,
          location: monuments[stop.monumentId]!.location!,
          visit: stop.visit,
          breaks: stop.breaks,
        ),
    ],
    legs: const [],
    summary: const RouteSummary(
      distanceMeters: 0,
      travel: Duration.zero,
      visit: Duration.zero,
      breaks: Duration.zero,
    ),
  );
}

void main() {
  late _MockGetMonuments getMonuments;
  late _MockGetRoute getRoute;
  late _MockSaveRoute saveRoute;
  late _MockPreviewRoute previewRoute;
  late _MockTravelMatrix travelMatrix;
  late List<MonumentPin> catalog;

  setUpAll(() {
    registerFallbackValue(
      const GetMonumentPinsParams(ids: [], languageCode: 'tr'),
    );
    registerFallbackValue(const GetRouteParams(id: 'id', languageCode: 'tr'));
    registerFallbackValue(
      SaveRouteParams(
        plan: RoutePlan(name: 'x', stops: const []),
        languageCode: 'tr',
      ),
    );
  });

  setUp(() {
    getMonuments = _MockGetMonuments();
    getRoute = _MockGetRoute();
    saveRoute = _MockSaveRoute();
    previewRoute = _MockPreviewRoute();
    travelMatrix = _MockTravelMatrix();
    // Varsayılan: karayolu servisine ulaşılamaz (kuş uçuşu gösterilir).
    when(() => previewRoute(any()))
        .thenAnswer((_) async => const Left(NetworkFailure()));
    when(() => travelMatrix(any()))
        .thenAnswer((_) async => const Left(NetworkFailure()));
    catalog = fixturePins();
    // Sunucu yalnızca istenen kimlikleri döndürür.
    when(() => getMonuments(any())).thenAnswer((invocation) async {
      final params =
          invocation.positionalArguments.single as GetMonumentPinsParams;
      return Right([
        for (final pin in catalog)
          if (params.ids.contains(pin.id)) pin,
      ]);
    });
  });

  Map<String, MonumentPin> known(List<String> ids) => {
    for (final pin in catalog)
      if (ids.contains(pin.id)) pin.id: pin,
  };

  RouteBuilderBloc build() => RouteBuilderBloc(
    getMonuments,
    getRoute,
    saveRoute,
    const OptimizeStopOrderUseCase(),
    previewRoute,
    travelMatrix,
  );

  RoutePreview previewOf(List<String> ids) => RoutePreview(
    monumentIds: ids,
    legs: [
      for (var i = 1; i < ids.length; i++)
        RouteLeg(
          distanceMeters: 1000 * i,
          duration: Duration(minutes: 10 * i),
          geometry: const [],
        ),
    ],
    distanceMeters: 1000 * ids.length,
    travel: Duration(minutes: 10 * ids.length),
  );

  RouteBuilderState ready(List<String> ids) => RouteBuilderState(
    status: RouteBuilderStatus.ready,
    monuments: known(ids),
    languageCode: 'tr',
    stops: [for (final id in ids) RouteStopPlan(monumentId: id)],
  );

  group('yükleme', () {
    blocTest<RouteBuilderBloc, RouteBuilderState>(
      'boş taslakta katalog indirilmez; oluşturucu hemen hazırdır',
      build: build,
      act: (bloc) =>
          bloc.add(const RouteBuilderEvent.started(languageCode: 'tr')),
      expect: () => [
        const RouteBuilderState(languageCode: 'tr'),
        const RouteBuilderState(
          status: RouteBuilderStatus.ready,
          languageCode: 'tr',
        ),
      ],
      verify: (_) => verifyNever(() => getMonuments(any())),
    );

    blocTest<RouteBuilderBloc, RouteBuilderState>(
      'bilgisi olmayan duraklar (eser detayından eklenen) açılışta tek '
      'istekte çözülür',
      build: build,
      seed: () => RouteBuilderState(
        stops: [
          RouteStopPlan(monumentId: _selimiye),
          RouteStopPlan(monumentId: _bursa),
        ],
      ),
      act: (bloc) =>
          bloc.add(const RouteBuilderEvent.started(languageCode: 'tr')),
      verify: (bloc) {
        expect(bloc.state.status, RouteBuilderStatus.ready);
        expect(bloc.state.monument(_selimiye)?.city, 'Edirne');
        expect(bloc.state.unresolvedMonumentIds, isEmpty);
        expect(bloc.state.stopLocations, hasLength(2));
        verify(
          () => getMonuments(
            const GetMonumentPinsParams(
              ids: [_selimiye, _bursa],
              languageCode: 'tr',
            ),
          ),
        ).called(1);
      },
    );

    blocTest<RouteBuilderBloc, RouteBuilderState>(
      'dil değişince durak adları sessizce yeni dilde yenilenir',
      build: build,
      seed: () => ready([_selimiye, _bursa]),
      act: (bloc) =>
          bloc.add(const RouteBuilderEvent.started(languageCode: 'en')),
      expect: () => [
        isA<RouteBuilderState>()
            .having((s) => s.languageCode, 'languageCode', 'en')
            .having((s) => s.status, 'status', RouteBuilderStatus.ready),
      ],
      verify: (bloc) {
        expect(bloc.state.stops.map((s) => s.monumentId), [_selimiye, _bursa]);
        verify(
          () => getMonuments(
            const GetMonumentPinsParams(
              ids: [_selimiye, _bursa],
              languageCode: 'en',
            ),
          ),
        ).called(1);
      },
    );

    blocTest<RouteBuilderBloc, RouteBuilderState>(
      'çözülemeyen duraklar düzenlemeyi engeller; tekrar denemede çözülür',
      build: build,
      seed: () =>
          RouteBuilderState(stops: [RouteStopPlan(monumentId: _selimiye)]),
      act: (bloc) async {
        when(() => getMonuments(any()))
            .thenAnswer((_) async => const Left(NetworkFailure()));
        bloc.add(const RouteBuilderEvent.started(languageCode: 'tr'));
        await Future<void>.delayed(Duration.zero);
        expect(bloc.state.isBlockedByLoadFailure, isTrue);
        when(() => getMonuments(any())).thenAnswer(
          (_) async => Right([
            for (final pin in catalog)
              if (pin.id == _selimiye) pin,
          ]),
        );
        bloc.add(const RouteBuilderEvent.started(languageCode: 'tr'));
      },
      verify: (bloc) {
        expect(bloc.state.isBlockedByLoadFailure, isFalse);
        expect(bloc.state.loadFailure, isNull);
      },
    );

    blocTest<RouteBuilderBloc, RouteBuilderState>(
      'katalogdan kaldırılmış durak eseri tekrar istenmez',
      build: build,
      seed: () => RouteBuilderState(
        stops: [
          RouteStopPlan(monumentId: _selimiye),
          RouteStopPlan(monumentId: 'kaldirilan'),
        ],
      ),
      act: (bloc) async {
        bloc.add(const RouteBuilderEvent.started(languageCode: 'tr'));
        await Future<void>.delayed(Duration.zero);
        bloc.add(const RouteBuilderEvent.started(languageCode: 'tr'));
      },
      verify: (bloc) {
        expect(bloc.state.unavailableMonumentIds, {'kaldirilan'});
        expect(bloc.state.isBlockedByLoadFailure, isFalse);
        expect(bloc.state.stopLocations, isNull);
        verify(() => getMonuments(any())).called(1);
      },
    );

    blocTest<RouteBuilderBloc, RouteBuilderState>(
      'editRequested rotanın planını ve adını yükler',
      build: build,
      setUp: () {
        final plan = RoutePlan(
          name: 'Trakya',
          stops: [
            RouteStopPlan(
              monumentId: _selimiye,
              visit: const Duration(hours: 2),
            ),
            RouteStopPlan(
              monumentId: _suleymaniye,
              breaks: [RouteBreak.ofKind(RouteBreakKind.meal)],
            ),
          ],
        );
        when(() => getRoute(any()))
            .thenAnswer((_) async => Right(_savedRoute(plan, id: 'rt_9')));
      },
      act: (bloc) => bloc.add(
        const RouteBuilderEvent.editRequested(
          routeId: 'rt_9',
          languageCode: 'tr',
        ),
      ),
      verify: (bloc) {
        final state = bloc.state;
        expect(state.status, RouteBuilderStatus.ready);
        expect(state.isEditing, isTrue);
        expect(state.name, 'Trakya');
        expect(state.stops.first.visit, const Duration(hours: 2));
        expect(state.stops.last.breaks.single.kind, RouteBreakKind.meal);
        // Durak bilgisi rota yanıtından gelir; katalog istenmez.
        expect(state.monument(_suleymaniye)?.city, 'İstanbul');
        verifyNever(() => getMonuments(any()));
      },
    );

    blocTest<RouteBuilderBloc, RouteBuilderState>(
      'silinmiş rota düzenlenmek istenirse isRouteMissing',
      build: build,
      setUp: () => when(() => getRoute(any())).thenAnswer(
        (_) async => const Left(
          ServerFailure(kind: ServerFailureKind.notFound, statusCode: 404),
        ),
      ),
      act: (bloc) => bloc.add(
        const RouteBuilderEvent.editRequested(
          routeId: 'rt_yok',
          languageCode: 'tr',
        ),
      ),
      verify: (bloc) => expect(bloc.state.isRouteMissing, isTrue),
    );
  });

  group('durak düzenleme', () {
    blocTest<RouteBuilderBloc, RouteBuilderState>(
      'aramadan seçilen eserin bilgisi istek atmadan saklanır',
      build: build,
      seed: () => ready([]),
      act: (bloc) => bloc.add(
        RouteBuilderEvent.monumentToggled(
          _izmir,
          monument: catalog.firstWhere((pin) => pin.id == _izmir),
        ),
      ),
      verify: (bloc) {
        expect(bloc.state.monument(_izmir)?.city, 'İzmir');
        verifyNever(() => getMonuments(any()));
      },
    );

    blocTest<RouteBuilderBloc, RouteBuilderState>(
      'bilgisi verilmeden eklenen eser (dil biliniyorsa) hemen çözülür',
      build: build,
      seed: () => ready([]),
      act: (bloc) => bloc.add(const RouteBuilderEvent.monumentToggled(_bursa)),
      verify: (bloc) {
        expect(bloc.state.monument(_bursa)?.city, 'Bursa');
        verify(
          () => getMonuments(
            const GetMonumentPinsParams(ids: [_bursa], languageCode: 'tr'),
          ),
        ).called(1);
      },
    );

    blocTest<RouteBuilderBloc, RouteBuilderState>(
      'monumentToggled ekler, tekrar dokununca çıkarır',
      build: build,
      seed: () => ready([]),
      act: (bloc) => bloc
        ..add(const RouteBuilderEvent.monumentToggled(_selimiye))
        ..add(const RouteBuilderEvent.monumentToggled(_bursa))
        ..add(const RouteBuilderEvent.monumentToggled(_selimiye)),
      verify: (bloc) =>
          expect(bloc.state.stops.map((s) => s.monumentId), [_bursa]),
    );

    blocTest<RouteBuilderBloc, RouteBuilderState>(
      'sınır doluyken ekleme reddedilir ve bildirim sayacı artar',
      build: build,
      seed: () => ready([
        for (final monument in fixturePins().take(RoutePlanRules.maxStops))
          monument.id,
      ]),
      act: (bloc) => bloc.add(const RouteBuilderEvent.monumentToggled('yeni')),
      expect: () => [
        isA<RouteBuilderState>()
            .having((s) => s.stops.length, 'stops', RoutePlanRules.maxStops)
            .having((s) => s.limitNotices, 'limitNotices', 1),
      ],
    );

    blocTest<RouteBuilderBloc, RouteBuilderState>(
      'stopMoved sırayı değiştirir, sınır dışı hareket yok sayılır',
      build: build,
      seed: () => ready([_selimiye, _suleymaniye, _bursa]),
      act: (bloc) => bloc
        ..add(const RouteBuilderEvent.stopMoved(from: 2, to: 0))
        ..add(const RouteBuilderEvent.stopMoved(from: 0, to: 5)),
      verify: (bloc) => expect(bloc.state.stops.map((s) => s.monumentId), [
        _bursa,
        _selimiye,
        _suleymaniye,
      ]),
    );

    blocTest<RouteBuilderBloc, RouteBuilderState>(
      'ziyaret süresi 15 dk adımına yuvarlanır ve sınırlanır',
      build: build,
      seed: () => ready([_selimiye, _bursa]),
      act: (bloc) => bloc
        ..add(
          const RouteBuilderEvent.visitChanged(
            index: 0,
            visit: Duration(minutes: 52),
          ),
        )
        ..add(
          const RouteBuilderEvent.visitChanged(
            index: 1,
            visit: Duration(hours: 30),
          ),
        ),
      verify: (bloc) {
        expect(bloc.state.stops[0].visit, const Duration(minutes: 45));
        expect(bloc.state.stops[1].visit, RoutePlanRules.maxVisit);
      },
    );

    blocTest<RouteBuilderBloc, RouteBuilderState>(
      'mola eklenir, süresi değişir, en fazla 3 mola, kaldırılır',
      build: build,
      seed: () => ready([_selimiye, _bursa]),
      act: (bloc) => bloc
        ..add(
          const RouteBuilderEvent.breakAdded(
            stopIndex: 0,
            kind: RouteBreakKind.meal,
          ),
        )
        ..add(
          const RouteBuilderEvent.breakChanged(
            stopIndex: 0,
            breakIndex: 0,
            duration: Duration(hours: 1),
          ),
        )
        ..add(
          const RouteBuilderEvent.breakAdded(
            stopIndex: 0,
            kind: RouteBreakKind.shortBreak,
          ),
        )
        ..add(
          const RouteBuilderEvent.breakAdded(
            stopIndex: 0,
            kind: RouteBreakKind.rest,
          ),
        )
        ..add(
          const RouteBuilderEvent.breakAdded(
            stopIndex: 0,
            kind: RouteBreakKind.overnight,
          ),
        )
        ..add(
          const RouteBuilderEvent.breakRemoved(stopIndex: 0, breakIndex: 1),
        ),
      verify: (bloc) {
        final breaks = bloc.state.stops.first.breaks;
        expect(breaks.map((b) => b.kind), [
          RouteBreakKind.meal,
          RouteBreakKind.rest,
        ]);
        expect(breaks.first.duration, const Duration(hours: 1));
        expect(
          bloc.state.breakTotal,
          const Duration(hours: 1) + RouteBreakKind.rest.defaultDuration,
        );
      },
    );

    blocTest<RouteBuilderBloc, RouteBuilderState>(
      'matris alınamazsa optimizasyon kuş uçuşuyla ilk durağı sabit tutar',
      build: build,
      // Edirne → İzmir → İstanbul → Bursa: İstanbul araya girmeli.
      seed: () => ready([_selimiye, _izmir, _suleymaniye, _bursa]),
      act: (bloc) => bloc.add(const RouteBuilderEvent.orderOptimized()),
      verify: (bloc) {
        final state = bloc.state;
        expect(state.stops.map((s) => s.monumentId), [
          _selimiye,
          _suleymaniye,
          _bursa,
          _izmir,
        ]);
        final outcome = state.optimization!;
        expect(outcome.basis, RouteOptimizationBasis.straightLineMeters);
        expect(outcome.changed, isTrue);
        expect(outcome.after, lessThan(outcome.before));
        expect(outcome.sequence, 1);
        expect(state.isOptimizing, isFalse);
      },
    );

    blocTest<RouteBuilderBloc, RouteBuilderState>(
      'optimizasyon sunucunun karayolu süre matrisini kullanır',
      setUp: () {
        // Kuş uçuşunun sırası Edirne → İstanbul → Bursa → İzmir'dir;
        // karayolu süresi İzmir'i Bursa'dan önce koyar.
        const minutes = [
          [0, 300, 100, 200],
          [300, 0, 50, 400],
          [100, 50, 0, 600],
          [200, 400, 600, 0],
        ];
        when(() => travelMatrix(any())).thenAnswer(
          (_) async => Right(
            TravelMatrix(
              durations: [
                for (final row in minutes)
                  [for (final m in row) Duration(minutes: m)],
              ],
              distances: [
                for (final row in minutes) [for (final m in row) m * 1000],
              ],
            ),
          ),
        );
      },
      build: build,
      seed: () => ready([_selimiye, _izmir, _suleymaniye, _bursa]),
      act: (bloc) => bloc.add(const RouteBuilderEvent.orderOptimized()),
      verify: (bloc) {
        verify(() => travelMatrix([_selimiye, _izmir, _suleymaniye, _bursa]))
            .called(1);
        final state = bloc.state;
        // Açık yolların en kısası: Edirne → İstanbul → İzmir → Bursa.
        expect(state.stops.map((s) => s.monumentId), [
          _selimiye,
          _suleymaniye,
          _izmir,
          _bursa,
        ]);
        final outcome = state.optimization!;
        expect(outcome.basis, RouteOptimizationBasis.roadTravelSeconds);
        expect(outcome.before, (300 + 50 + 600) * 60);
        expect(outcome.after, (100 + 50 + 400) * 60);
      },
    );
  });

  group('karayolu ön hesabı', () {
    blocTest<RouteBuilderBloc, RouteBuilderState>(
      'durak dizisi değişince ön hesap istenir ve uygulanır',
      setUp: () => when(() => previewRoute(any())).thenAnswer(
        (invocation) async => Right(
          previewOf(invocation.positionalArguments.single as List<String>),
        ),
      ),
      build: build,
      seed: () => ready([_selimiye, _suleymaniye]),
      act: (bloc) => bloc.add(
        RouteBuilderEvent.monumentToggled(
          _bursa,
          monument: catalog.firstWhere((pin) => pin.id == _bursa),
        ),
      ),
      verify: (bloc) {
        verify(() => previewRoute([_selimiye, _suleymaniye, _bursa])).called(1);
        final preview = bloc.state.currentPreview!;
        expect(preview.monumentIds, [_selimiye, _suleymaniye, _bursa]);
        expect(preview.legs, hasLength(2));
      },
    );

    blocTest<RouteBuilderBloc, RouteBuilderState>(
      'ziyaret süresi değişimi ön hesabı yinelemez; sıra değişimi eskitir',
      setUp: () => when(() => previewRoute(any())).thenAnswer(
        (invocation) async => Right(
          previewOf(invocation.positionalArguments.single as List<String>),
        ),
      ),
      build: build,
      seed: () =>
          ready([_selimiye, _suleymaniye, _bursa])
              .copyWith(preview: previewOf([_selimiye, _suleymaniye, _bursa])),
      act: (bloc) => bloc
        ..add(
          const RouteBuilderEvent.visitChanged(
            index: 0,
            visit: Duration(hours: 2),
          ),
        )
        ..add(const RouteBuilderEvent.stopMoved(from: 2, to: 1)),
      verify: (bloc) {
        verify(() => previewRoute([_selimiye, _bursa, _suleymaniye])).called(1);
        verifyNoMoreInteractions(previewRoute);
        expect(bloc.state.currentPreview?.monumentIds, [
          _selimiye,
          _bursa,
          _suleymaniye,
        ]);
      },
    );

    blocTest<RouteBuilderBloc, RouteBuilderState>(
      'ön hesap alınamazsa hata gösterilmez; kuş uçuşu kalır',
      build: build,
      seed: () => ready([_selimiye]),
      act: (bloc) => bloc.add(
        RouteBuilderEvent.monumentToggled(
          _bursa,
          monument: catalog.firstWhere((pin) => pin.id == _bursa),
        ),
      ),
      verify: (bloc) {
        expect(bloc.state.currentPreview, isNull);
        expect(bloc.state.loadFailure, isNull);
        expect(bloc.state.straightLineMeters, greaterThan(0));
      },
    );
  });

  group('gönderim', () {
    blocTest<RouteBuilderBloc, RouteBuilderState>(
      'geçersiz plan gönderilmez; doğrulama gösterilir',
      build: build,
      seed: () => ready([_selimiye]),
      act: (bloc) => bloc.add(
        const RouteBuilderEvent.submitted(
          languageCode: 'tr',
          fallbackName: 'Edirne Rotası',
        ),
      ),
      expect: () => [
        isA<RouteBuilderState>()
            .having((s) => s.showValidation, 'showValidation', isTrue)
            .having((s) => s.invalidSubmissions, 'invalidSubmissions', 1)
            .having(
              (s) => s.validationError('Edirne Rotası'),
              'error',
              RoutePlanError.tooFewStops,
            ),
      ],
      verify: (_) => verifyNever(() => saveRoute(any())),
    );

    blocTest<RouteBuilderBloc, RouteBuilderState>(
      'ad boşsa önerilen adla kaydedilir; çift dokunuş tek istek',
      build: build,
      setUp: () => when(() => saveRoute(any())).thenAnswer((invocation) async {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        final params = invocation.positionalArguments.single as SaveRouteParams;
        return Right(_savedRoute(params.plan));
      }),
      seed: () => ready([_selimiye, _bursa]),
      act: (bloc) async {
        const submit = RouteBuilderEvent.submitted(
          languageCode: 'tr',
          fallbackName: 'Edirne – Bursa Rotası',
        );
        bloc
          ..add(submit)
          ..add(submit);
        await Future<void>.delayed(const Duration(milliseconds: 30));
      },
      expect: () => [
        isA<RouteBuilderState>().having(
          (s) => s.status,
          'status',
          RouteBuilderStatus.submitting,
        ),
        isA<RouteBuilderState>()
            .having((s) => s.status, 'status', RouteBuilderStatus.saved)
            .having(
              (s) => s.savedRoute?.name,
              'savedRoute.name',
              'Edirne – Bursa Rotası',
            ),
      ],
      verify: (_) {
        final params =
            verify(() => saveRoute(captureAny())).captured.single
                as SaveRouteParams;
        expect(params.routeId, isNull);
        expect(params.plan.stops.length, 2);
      },
    );

    blocTest<RouteBuilderBloc, RouteBuilderState>(
      'düzenlemede rota kimliğiyle kaydedilir',
      build: build,
      setUp: () => when(() => saveRoute(any())).thenAnswer((invocation) async {
        final params = invocation.positionalArguments.single as SaveRouteParams;
        return Right(_savedRoute(params.plan, id: params.routeId!));
      }),
      seed: () =>
          ready([_selimiye, _bursa])
              .copyWith(routeId: 'rt_7', name: '  Kendi adım  '),
      act: (bloc) => bloc.add(
        const RouteBuilderEvent.submitted(
          languageCode: 'tr',
          fallbackName: 'yedek',
        ),
      ),
      verify: (_) {
        final params =
            verify(() => saveRoute(captureAny())).captured.single
                as SaveRouteParams;
        expect(params.routeId, 'rt_7');
        expect(params.plan.name, 'Kendi adım');
      },
    );

    blocTest<RouteBuilderBloc, RouteBuilderState>(
      'kaydetme hatası durumu hazır bırakır; düzenleme hatayı temizler',
      build: build,
      setUp: () =>
          when(() => saveRoute(any()))
              .thenAnswer((_) async => const Left(NetworkFailure())),
      seed: () => ready([_selimiye, _bursa]),
      act: (bloc) async {
        bloc.add(
          const RouteBuilderEvent.submitted(
            languageCode: 'tr',
            fallbackName: 'Rota',
          ),
        );
        await Future<void>.delayed(Duration.zero);
        bloc.add(const RouteBuilderEvent.monumentToggled(_suleymaniye));
      },
      verify: (bloc) {
        expect(bloc.state.status, RouteBuilderStatus.ready);
        expect(bloc.state.saveFailure, isNull);
        expect(bloc.state.stops.length, 3);
      },
    );

    blocTest<RouteBuilderBloc, RouteBuilderState>(
      'reset taslağı temizler, dili korur',
      build: build,
      seed: () => ready([_selimiye, _bursa]).copyWith(name: 'Taslak'),
      act: (bloc) => bloc.add(const RouteBuilderEvent.reset()),
      expect: () => [
        const RouteBuilderState(
          status: RouteBuilderStatus.ready,
          languageCode: 'tr',
        ),
      ],
    );
  });
}
