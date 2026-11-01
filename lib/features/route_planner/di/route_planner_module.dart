import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/features/catalog/domain/usecases/catalog_usecases.dart';
import 'package:vakif_atlas/features/route_planner/domain/repositories/route_repository.dart';
import 'package:vakif_atlas/features/route_planner/domain/usecases/optimize_stop_order_usecase.dart';
import 'package:vakif_atlas/features/route_planner/domain/usecases/route_usecases.dart';
import 'package:vakif_atlas/features/route_planner/presentation/bloc/route_builder_bloc.dart';

/// Domain sınıfları DI anotasyonu taşımadığından kayıtları burada yapılır.
@module
abstract class RoutePlannerModule {
  @lazySingleton
  GetRoutesUseCase getRoutesUseCase(RouteRepository repository) =>
      GetRoutesUseCase(repository);

  @lazySingleton
  GetRouteUseCase getRouteUseCase(RouteRepository repository) =>
      GetRouteUseCase(repository);

  @lazySingleton
  SaveRouteUseCase saveRouteUseCase(RouteRepository repository) =>
      SaveRouteUseCase(repository);

  @lazySingleton
  DeleteRouteUseCase deleteRouteUseCase(RouteRepository repository) =>
      DeleteRouteUseCase(repository);

  @lazySingleton
  WatchRouteChangesUseCase watchRouteChangesUseCase(
    RouteRepository repository,
  ) => WatchRouteChangesUseCase(repository);

  @lazySingleton
  OptimizeStopOrderUseCase get optimizeStopOrderUseCase =>
      const OptimizeStopOrderUseCase();

  /// Uygulama boyunca korunan yeni rota taslağı (eser detayındaki
  /// "Rotaya ekle" ve sekme değişimleri taslağı kaybettirmez).
  @Named(RouteBuilderBloc.draftInstance)
  @lazySingleton
  RouteBuilderBloc routeDraft(
    GetMonumentPinsUseCase getMonuments,
    GetRouteUseCase getRoute,
    SaveRouteUseCase saveRoute,
    OptimizeStopOrderUseCase optimize,
  ) => RouteBuilderBloc(getMonuments, getRoute, saveRoute, optimize);
}
