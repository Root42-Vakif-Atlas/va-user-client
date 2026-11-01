import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/usecase/usecase.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/travel_route.dart';
import 'package:vakif_atlas/features/route_planner/domain/usecases/route_usecases.dart';

part 'route_detail_cubit.freezed.dart';

enum RouteDetailStatus { loading, loaded, failure, deleting, deleted }

@freezed
abstract class RouteDetailState with _$RouteDetailState {
  const factory RouteDetailState({
    @Default(RouteDetailStatus.loading) RouteDetailStatus status,
    TravelRoute? route,
    Failure? failure,

    /// Silme başarısız olduysa nedeni (rota görünmeye devam eder).
    Failure? deleteFailure,
  }) = _RouteDetailState;

  const RouteDetailState._();

  bool get isNotFound =>
      status == RouteDetailStatus.failure &&
      switch (failure) {
        ServerFailure(kind: ServerFailureKind.notFound) => true,
        _ => false,
      };
}

/// Rota detayı. Rota düzenlendiğinde kendini yeniler. Ekran bazlıdır.
@injectable
class RouteDetailCubit extends Cubit<RouteDetailState> {
  RouteDetailCubit(
    this._getRoute,
    this._deleteRoute,
    WatchRouteChangesUseCase watchChanges,
  ) : super(const RouteDetailState()) {
    _changes = watchChanges(const NoParams()).listen(_onChange);
  }

  final GetRouteUseCase _getRoute;
  final DeleteRouteUseCase _deleteRoute;
  late final StreamSubscription<RouteChange> _changes;
  GetRouteParams? _params;

  /// Her çağrı bir öncekini geçersiz kılar (ör. dil değişimi).
  int _request = 0;

  Future<void> load({required String id, required String languageCode}) async {
    final params = GetRouteParams(id: id, languageCode: languageCode);
    _params = params;
    final request = ++_request;
    if (state.route == null) {
      emit(state.copyWith(status: RouteDetailStatus.loading, failure: null));
    }
    final result = await _getRoute(params);
    if (isClosed || request != _request) {
      return;
    }
    emit(
      result.fold(
        (failure) => state.copyWith(
          status: RouteDetailStatus.failure,
          failure: failure,
          route: null,
        ),
        (route) => state.copyWith(
          status: RouteDetailStatus.loaded,
          route: route,
          failure: null,
        ),
      ),
    );
  }

  Future<void> retry() async {
    final params = _params;
    if (params != null) {
      emit(state.copyWith(status: RouteDetailStatus.loading, failure: null));
      await load(id: params.id, languageCode: params.languageCode);
    }
  }

  Future<void> delete() async {
    final route = state.route;
    if (route == null || state.status == RouteDetailStatus.deleting) {
      return;
    }
    emit(
      state.copyWith(status: RouteDetailStatus.deleting, deleteFailure: null),
    );
    final result = await _deleteRoute(route.id);
    if (isClosed) {
      return;
    }
    emit(
      result.fold(
        (failure) => state.copyWith(
          status: RouteDetailStatus.loaded,
          deleteFailure: failure,
        ),
        (_) => state.copyWith(status: RouteDetailStatus.deleted),
      ),
    );
  }

  void _onChange(RouteChange change) {
    final params = _params;
    final affected =
        change.type == RouteChangeType.scopeChanged ||
        (change.type == RouteChangeType.updated &&
            change.routeId == params?.id);
    if (affected &&
        params != null &&
        state.status != RouteDetailStatus.deleted) {
      unawaited(load(id: params.id, languageCode: params.languageCode));
    }
  }

  @override
  Future<void> close() async {
    await _changes.cancel();
    return super.close();
  }
}
