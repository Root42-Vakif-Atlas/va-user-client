import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/usecase/usecase.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/route_plan.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/travel_route.dart';
import 'package:vakif_atlas/features/route_planner/domain/repositories/route_repository.dart';

final class GetRoutesParams {
  const GetRoutesParams({required this.languageCode});

  final String languageCode;

  @override
  bool operator ==(Object other) =>
      other is GetRoutesParams && other.languageCode == languageCode;

  @override
  int get hashCode => Object.hash(GetRoutesParams, languageCode);
}

/// Bu cihazdaki rotalar, en yeni önce.
class GetRoutesUseCase
    implements UseCase<List<RouteOverview>, GetRoutesParams> {
  const GetRoutesUseCase(this._repository);

  final RouteRepository _repository;

  @override
  ResultFuture<List<RouteOverview>> call(GetRoutesParams params) =>
      _repository.getRoutes(languageCode: params.languageCode);
}

final class GetRouteParams {
  const GetRouteParams({required this.id, required this.languageCode});

  final String id;
  final String languageCode;

  @override
  bool operator ==(Object other) =>
      other is GetRouteParams &&
      other.id == id &&
      other.languageCode == languageCode;

  @override
  int get hashCode => Object.hash(GetRouteParams, id, languageCode);
}

class GetRouteUseCase implements UseCase<TravelRoute, GetRouteParams> {
  const GetRouteUseCase(this._repository);

  final RouteRepository _repository;

  @override
  ResultFuture<TravelRoute> call(GetRouteParams params) =>
      _repository.getRoute(id: params.id, languageCode: params.languageCode);
}

final class SaveRouteParams {
  const SaveRouteParams({
    required this.plan,
    required this.languageCode,
    this.routeId,
  });

  final RoutePlan plan;
  final String languageCode;

  /// Verilirse mevcut rota güncellenir, yoksa yeni rota oluşturulur.
  final String? routeId;

  @override
  bool operator ==(Object other) =>
      other is SaveRouteParams &&
      other.plan == plan &&
      other.languageCode == languageCode &&
      other.routeId == routeId;

  @override
  int get hashCode => Object.hash(SaveRouteParams, plan, languageCode, routeId);
}

/// Rotayı oluşturur (`POST routes`) veya günceller (`PUT routes/{id}`).
///
/// Kurallara uymayan plan sunucuya gönderilmez.
class SaveRouteUseCase implements UseCase<TravelRoute, SaveRouteParams> {
  const SaveRouteUseCase(this._repository);

  final RouteRepository _repository;

  @override
  ResultFuture<TravelRoute> call(SaveRouteParams params) async {
    if (RoutePlanRules.validate(params.plan) != null) {
      return const Left(
        ServerFailure(kind: ServerFailureKind.invalidRequest, statusCode: 400),
      );
    }
    final id = params.routeId;
    return id == null
        ? _repository.createRoute(
            plan: params.plan,
            languageCode: params.languageCode,
          )
        : _repository.updateRoute(
            id: id,
            plan: params.plan,
            languageCode: params.languageCode,
          );
  }
}

class DeleteRouteUseCase implements UseCase<Unit, String> {
  const DeleteRouteUseCase(this._repository);

  final RouteRepository _repository;

  /// [routeId] kimlikli rotayı siler.
  @override
  ResultFuture<Unit> call(String routeId) =>
      _repository.deleteRoute(id: routeId);
}

class WatchRouteChangesUseCase implements StreamUseCase<RouteChange, NoParams> {
  const WatchRouteChangesUseCase(this._repository);

  final RouteRepository _repository;

  @override
  Stream<RouteChange> call(NoParams params) => _repository.changes;
}
