import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/route_plan.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/travel_route.dart';

/// Bu cihazda oluşturulan kültür rotaları (Rota mikro servisi).
///
/// Rotalar hesaba değil, uygulama kurulumuna bağlıdır; giriş gerekmez.
/// Eser adları [languageCode] dilinde döner.
abstract interface class RouteRepository {
  /// Başarılı oluşturma, güncelleme ve silme işlemleri.
  Stream<RouteChange> get changes;

  ResultFuture<List<RouteOverview>> getRoutes({required String languageCode});

  ResultFuture<TravelRoute> getRoute({
    required String id,
    required String languageCode,
  });

  ResultFuture<TravelRoute> createRoute({
    required RoutePlan plan,
    required String languageCode,
  });

  ResultFuture<TravelRoute> updateRoute({
    required String id,
    required RoutePlan plan,
    required String languageCode,
  });

  ResultFuture<Unit> deleteRoute({required String id});
}
