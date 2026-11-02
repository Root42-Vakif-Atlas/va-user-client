import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/geo_point.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';
import 'package:vakif_atlas/features/catalog/domain/usecases/catalog_usecases.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/route_plan.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/travel_route.dart';
import 'package:vakif_atlas/features/route_planner/domain/usecases/optimize_stop_order_usecase.dart';
import 'package:vakif_atlas/features/route_planner/domain/usecases/route_usecases.dart';

part 'route_builder_bloc.freezed.dart';
part 'route_builder_event.dart';
part 'route_builder_state.dart';

/// Rota oluşturucu / düzenleyici.
///
/// Yeni rota taslağı uygulama boyunca tek bir örnekte ([draftInstance])
/// tutulur; böylece eser detayından "Rotaya ekle" ile eklenenler ve sekme
/// değişimleri taslağı kaybettirmez. Düzenleme ekranı kendi örneğini alır.
/// Gönderim `droppable()`: çift dokunma ikinci istek oluşturmaz.
///
/// Durak dizisi her değiştiğinde karayolu ön hesabı (bizim OSRM,
/// `routes/preview`) istenir (`restartable()`: yalnızca son dizinin yanıtı
/// uygulanır); "Sırayı optimize et" sunucunun karayolu süre matrisini
/// kullanır. İkisi de alınamazsa kuş uçuşuna düşülür.
@injectable
class RouteBuilderBloc extends Bloc<RouteBuilderEvent, RouteBuilderState> {
  RouteBuilderBloc(
    this._getMonuments,
    this._getRoute,
    this._saveRoute,
    this._optimize,
    this._preview,
    this._travelMatrix,
  ) : super(const RouteBuilderState()) {
    on<RouteBuilderStarted>(_onStarted, transformer: restartable());
    on<RouteBuilderEditRequested>(_onEditRequested, transformer: restartable());
    on<RouteBuilderMonumentToggled>(_onMonumentToggled);
    on<RouteBuilderMonumentsResolveRequested>(
      (event, emit) => _resolveMonuments(emit),
      transformer: restartable(),
    );
    on<RouteBuilderStopMoved>(_onStopMoved);
    on<RouteBuilderStopRemoved>(_onStopRemoved);
    on<RouteBuilderVisitChanged>(_onVisitChanged);
    on<RouteBuilderBreakAdded>(_onBreakAdded);
    on<RouteBuilderBreakChanged>(_onBreakChanged);
    on<RouteBuilderBreakRemoved>(_onBreakRemoved);
    on<RouteBuilderNameChanged>(_onNameChanged);
    on<RouteBuilderOrderOptimized>(_onOrderOptimized, transformer: droppable());
    on<RouteBuilderPreviewRequested>(
      _onPreviewRequested,
      transformer: restartable(),
    );
    on<RouteBuilderSubmitted>(_onSubmitted, transformer: droppable());
    on<RouteBuilderReset>(_onReset);
  }

  /// Uygulama genelindeki yeni rota taslağının DI adı.
  static const String draftInstance = 'routeDraft';

  final GetMonumentPinsUseCase _getMonuments;
  final GetRouteUseCase _getRoute;
  final SaveRouteUseCase _saveRoute;
  final OptimizeStopOrderUseCase _optimize;
  final PreviewRouteUseCase _preview;
  final GetTravelMatrixUseCase _travelMatrix;

  @override
  void onChange(Change<RouteBuilderState> change) {
    super.onChange(change);
    if (!listEquals(
      change.currentState.monumentIds,
      change.nextState.monumentIds,
    )) {
      add(const RouteBuilderEvent.previewRequested());
    }
  }

  Future<void> _onStarted(
    RouteBuilderStarted event,
    Emitter<RouteBuilderState> emit,
  ) async {
    final languageChanged = state.languageCode != event.languageCode;
    emit(state.copyWith(languageCode: event.languageCode));
    // Dil değişince adlar yeni dilde yenilenir; aksi halde yalnızca eksikler.
    await _resolveMonuments(emit, refreshAll: languageChanged);
  }

  /// Durak eserlerinin bilgisini tek istekte çözer. İlk açılışta bilgisi
  /// eksik durak varsa yükleme gösterilir; dil yenilemesi sessizdir.
  Future<void> _resolveMonuments(
    Emitter<RouteBuilderState> emit, {
    bool refreshAll = false,
  }) async {
    final languageCode = state.languageCode;
    if (languageCode == null) {
      return;
    }
    final ids = refreshAll
        ? [for (final stop in state.stops) stop.monumentId]
        : state.unresolvedMonumentIds;
    if (ids.isEmpty) {
      emit(
        state.copyWith(
          status: state.status == RouteBuilderStatus.loading
              ? RouteBuilderStatus.ready
              : state.status,
          loadFailure: null,
        ),
      );
      return;
    }
    if (state.unresolvedMonumentIds.isNotEmpty) {
      emit(
        state.copyWith(status: RouteBuilderStatus.loading, loadFailure: null),
      );
    }
    final result = await _getMonuments(
      GetMonumentPinsParams(ids: ids, languageCode: languageCode),
    );
    // Yanıt beklenirken dil değiştiyse bu sonuç uygulanmaz.
    if (state.languageCode != languageCode) {
      return;
    }
    emit(
      result.fold(
        (failure) => state.copyWith(
          status: state.status == RouteBuilderStatus.loading
              ? RouteBuilderStatus.ready
              : state.status,
          loadFailure: failure,
        ),
        (pins) {
          final found = {for (final pin in pins) pin.id: pin};
          return state.copyWith(
            status: state.status == RouteBuilderStatus.loading
                ? RouteBuilderStatus.ready
                : state.status,
            monuments: {...state.monuments, ...found},
            unavailableMonumentIds: {
              ...state.unavailableMonumentIds.difference(found.keys.toSet()),
              for (final id in ids)
                if (!found.containsKey(id)) id,
            },
            loadFailure: null,
          );
        },
      ),
    );
  }

  Future<void> _onEditRequested(
    RouteBuilderEditRequested event,
    Emitter<RouteBuilderState> emit,
  ) async {
    emit(
      state.copyWith(
        status: RouteBuilderStatus.loading,
        routeId: event.routeId,
        languageCode: event.languageCode,
        loadFailure: null,
      ),
    );
    final result = await _getRoute(
      GetRouteParams(id: event.routeId, languageCode: event.languageCode),
    );
    emit(
      result.fold(
        (failure) => state.copyWith(
          status: RouteBuilderStatus.ready,
          loadFailure: failure,
        ),
        (route) {
          final plan = route.toPlan();
          return state.copyWith(
            status: RouteBuilderStatus.ready,
            stops: plan.stops,
            name: plan.name,
            monuments: {
              for (final stop in route.stops)
                stop.monumentId: MonumentPin(
                  id: stop.monumentId,
                  name: stop.name,
                  category: stop.category,
                  city: stop.city,
                  district: stop.district,
                  location: stop.location,
                ),
            },
          );
        },
      ),
    );
  }

  void _onMonumentToggled(
    RouteBuilderMonumentToggled event,
    Emitter<RouteBuilderState> emit,
  ) {
    if (state.contains(event.monumentId)) {
      emit(
        _edited(
          stops: [
            for (final stop in state.stops)
              if (stop.monumentId != event.monumentId) stop,
          ],
        ),
      );
      return;
    }
    if (state.isFull) {
      emit(state.copyWith(limitNotices: state.limitNotices + 1));
      return;
    }
    final monument = event.monument;
    emit(
      _edited(
        stops: [
          ...state.stops,
          RouteStopPlan(monumentId: event.monumentId),
        ],
      ).copyWith(
        monuments: monument == null
            ? state.monuments
            : {...state.monuments, monument.id: monument},
      ),
    );
    if (monument == null && state.languageCode != null) {
      add(const RouteBuilderEvent.monumentsResolveRequested());
    }
  }

  void _onStopMoved(
    RouteBuilderStopMoved event,
    Emitter<RouteBuilderState> emit,
  ) {
    final stops = [...state.stops];
    if (event.from < 0 ||
        event.from >= stops.length ||
        event.to < 0 ||
        event.to >= stops.length ||
        event.from == event.to) {
      return;
    }
    stops.insert(event.to, stops.removeAt(event.from));
    emit(_edited(stops: stops));
  }

  void _onStopRemoved(
    RouteBuilderStopRemoved event,
    Emitter<RouteBuilderState> emit,
  ) {
    if (event.index < 0 || event.index >= state.stops.length) {
      return;
    }
    emit(_edited(stops: [...state.stops]..removeAt(event.index)));
  }

  void _onVisitChanged(
    RouteBuilderVisitChanged event,
    Emitter<RouteBuilderState> emit,
  ) {
    _updateStop(
      emit,
      event.index,
      (stop) => RouteStopPlan(
        monumentId: stop.monumentId,
        visit: RoutePlanRules.clampToStep(
          event.visit,
          RoutePlanRules.minVisit,
          RoutePlanRules.maxVisit,
        ),
        breaks: stop.breaks,
      ),
    );
  }

  void _onBreakAdded(
    RouteBuilderBreakAdded event,
    Emitter<RouteBuilderState> emit,
  ) {
    _updateStop(
      emit,
      event.stopIndex,
      (stop) => stop.breaks.length >= RoutePlanRules.maxBreaksPerStop
          ? stop
          : RouteStopPlan(
              monumentId: stop.monumentId,
              visit: stop.visit,
              breaks: [...stop.breaks, RouteBreak.ofKind(event.kind)],
            ),
    );
  }

  void _onBreakChanged(
    RouteBuilderBreakChanged event,
    Emitter<RouteBuilderState> emit,
  ) {
    _updateStop(emit, event.stopIndex, (stop) {
      if (event.breakIndex < 0 || event.breakIndex >= stop.breaks.length) {
        return stop;
      }
      final breaks = [...stop.breaks];
      breaks[event.breakIndex] = breaks[event.breakIndex].copyWith(
        duration: RoutePlanRules.clampToStep(
          event.duration,
          RoutePlanRules.minBreak,
          RoutePlanRules.maxBreak,
        ),
      );
      return RouteStopPlan(
        monumentId: stop.monumentId,
        visit: stop.visit,
        breaks: breaks,
      );
    });
  }

  void _onBreakRemoved(
    RouteBuilderBreakRemoved event,
    Emitter<RouteBuilderState> emit,
  ) {
    _updateStop(emit, event.stopIndex, (stop) {
      if (event.breakIndex < 0 || event.breakIndex >= stop.breaks.length) {
        return stop;
      }
      return RouteStopPlan(
        monumentId: stop.monumentId,
        visit: stop.visit,
        breaks: [...stop.breaks]..removeAt(event.breakIndex),
      );
    });
  }

  void _onNameChanged(
    RouteBuilderNameChanged event,
    Emitter<RouteBuilderState> emit,
  ) {
    emit(state.copyWith(name: event.name, saveFailure: null));
  }

  Future<void> _onPreviewRequested(
    RouteBuilderPreviewRequested event,
    Emitter<RouteBuilderState> emit,
  ) async {
    final ids = state.monumentIds;
    if (ids.length < RoutePlanRules.minStops) {
      emit(state.copyWith(preview: null));
      return;
    }
    if (state.currentPreview != null) {
      return;
    }
    final result = await _preview(ids);
    // Yanıt beklenirken dizi değiştiyse daha yeni istek sonucu uygular.
    if (emit.isDone || !listEquals(state.monumentIds, ids)) {
      return;
    }
    // Hata kullanıcıya yansımaz: kuş uçuşu gösterilmeye devam eder.
    result.fold((_) {}, (preview) => emit(state.copyWith(preview: preview)));
  }

  Future<void> _onOrderOptimized(
    RouteBuilderOrderOptimized event,
    Emitter<RouteBuilderState> emit,
  ) async {
    final points = state.stopLocations;
    final ids = state.monumentIds;
    if (points == null || points.length < 3) {
      return;
    }
    emit(state.copyWith(isOptimizing: true));
    final matrix = (await _travelMatrix(ids))
        .fold<TravelMatrix?>((_) => null, (matrix) => matrix);
    if (!listEquals(state.monumentIds, ids)) {
      emit(state.copyWith(isOptimizing: false));
      return;
    }
    final byRoad = matrix != null && matrix.size == ids.length;
    double cost(int from, int to) => byRoad
        ? matrix.durations[from][to].inSeconds.toDouble()
        : points[from].distanceTo(points[to]);
    final order = _optimize.byCost(ids.length, cost);
    emit(
      _edited(stops: [for (final index in order) state.stops[index]]).copyWith(
        isOptimizing: false,
        optimization: RouteOptimizationOutcome(
          basis: byRoad
              ? RouteOptimizationBasis.roadTravelSeconds
              : RouteOptimizationBasis.straightLineMeters,
          before: OptimizeStopOrderUseCase.pathCost(ids.length, cost),
          after: OptimizeStopOrderUseCase.pathCost(ids.length, cost, order),
          sequence: (state.optimization?.sequence ?? 0) + 1,
        ),
      ),
    );
  }

  Future<void> _onSubmitted(
    RouteBuilderSubmitted event,
    Emitter<RouteBuilderState> emit,
  ) async {
    final plan = state.planFor(event.fallbackName);
    if (RoutePlanRules.validate(plan) != null) {
      emit(
        state.copyWith(
          showValidation: true,
          invalidSubmissions: state.invalidSubmissions + 1,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        status: RouteBuilderStatus.submitting,
        showValidation: true,
        saveFailure: null,
      ),
    );
    final result = await _saveRoute(
      SaveRouteParams(
        plan: plan,
        languageCode: event.languageCode,
        routeId: state.routeId,
      ),
    );
    emit(
      result.fold(
        (failure) => state.copyWith(
          status: RouteBuilderStatus.ready,
          saveFailure: failure,
        ),
        (route) =>
            state.copyWith(status: RouteBuilderStatus.saved, savedRoute: route),
      ),
    );
  }

  void _onReset(RouteBuilderReset event, Emitter<RouteBuilderState> emit) {
    emit(
      RouteBuilderState(
        status: RouteBuilderStatus.ready,
        languageCode: state.languageCode,
      ),
    );
  }

  /// Duraklar değişti: kaydetme hatası ve önceki sonuç temizlenir.
  RouteBuilderState _edited({required List<RouteStopPlan> stops}) =>
      state.copyWith(
        stops: stops,
        saveFailure: null,
        status: state.status == RouteBuilderStatus.saved
            ? RouteBuilderStatus.ready
            : state.status,
      );

  void _updateStop(
    Emitter<RouteBuilderState> emit,
    int index,
    RouteStopPlan Function(RouteStopPlan stop) update,
  ) {
    if (index < 0 || index >= state.stops.length) {
      return;
    }
    final stops = [...state.stops];
    stops[index] = update(stops[index]);
    emit(_edited(stops: stops));
  }
}
