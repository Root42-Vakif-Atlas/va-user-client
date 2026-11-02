import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/error_mapper.dart';
import 'package:vakif_atlas/core/events/user_activity_events.dart';
import 'package:vakif_atlas/core/network/session_events.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/route_planner/data/dtos/route_dtos.dart';
import 'package:vakif_atlas/features/route_planner/data/sources/route_remote_data_source.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/route_plan.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/travel_route.dart';
import 'package:vakif_atlas/features/route_planner/domain/repositories/route_repository.dart';

/// Değişiklik akışı uygulama ömrü boyunca açıktır (singleton).
@LazySingleton(as: RouteRepository)
class RouteRepositoryImpl implements RouteRepository {
  RouteRepositoryImpl(
    this._remote,
    this._activity,
    SessionEvents sessionEvents,
  ) {
    // Rotaların sahibi oturuma göre değişir (hesap ↔ kurulum).
    sessionEvents.onAccountChanged.listen(
      (_) => _changes.add(const RouteChange(RouteChangeType.scopeChanged, '')),
    );
  }

  final RouteRemoteDataSource _remote;

  /// Başarılı katkı oyunlaştırmaya duyurulur.
  final UserActivityEvents _activity;
  final StreamController<RouteChange> _changes =
      StreamController<RouteChange>.broadcast();

  @override
  Stream<RouteChange> get changes => _changes.stream;

  @override
  ResultFuture<List<RouteOverview>> getRoutes({required String languageCode}) =>
      _guard(() async {
        final routes = await _remote.fetchRoutes(languageCode: languageCode);
        return [for (final route in routes) route.toDomain()];
      });

  @override
  ResultFuture<TravelRoute> getRoute({
    required String id,
    required String languageCode,
  }) => _guard(() async {
    final route = await _remote.fetchRoute(id: id, languageCode: languageCode);
    return route.toDomain();
  });

  @override
  ResultFuture<TravelRoute> createRoute({
    required RoutePlan plan,
    required String languageCode,
  }) => _guard(() async {
    final route = await _remote.createRoute(
      plan: RoutePlanRequestDto.fromDomain(plan),
      languageCode: languageCode,
    );
    final entity = route.toDomain();
    _changes.add(RouteChange(RouteChangeType.created, entity.id));
    _activity.notifyContribution();
    return entity;
  });

  @override
  ResultFuture<TravelRoute> updateRoute({
    required String id,
    required RoutePlan plan,
    required String languageCode,
  }) => _guard(() async {
    final route = await _remote.updateRoute(
      id: id,
      plan: RoutePlanRequestDto.fromDomain(plan),
      languageCode: languageCode,
    );
    final entity = route.toDomain();
    _changes.add(RouteChange(RouteChangeType.updated, entity.id));
    return entity;
  });

  @override
  ResultFuture<Unit> deleteRoute({required String id}) => _guard(() async {
    await _remote.deleteRoute(id: id);
    _changes.add(RouteChange(RouteChangeType.deleted, id));
    return unit;
  });

  @override
  ResultFuture<RoutePreview> previewRoute({
    required List<String> monumentIds,
  }) => _guard(() async {
    final preview = await _remote.previewRoute(monumentIds: monumentIds);
    return preview.toDomain(monumentIds);
  });

  @override
  ResultFuture<TravelMatrix> getTravelMatrix({
    required List<String> monumentIds,
  }) => _guard(() async {
    final matrix = await _remote.fetchTravelMatrix(monumentIds: monumentIds);
    return matrix.toDomain(monumentIds.length);
  });

  static ResultFuture<T> _guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on Exception catch (error) {
      return Left(ErrorMapper.toFailure(error));
    }
  }
}
