import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/features/route_export/domain/repositories/route_export_repository.dart';
import 'package:vakif_atlas/features/route_export/domain/usecases/route_export_usecases.dart';

/// Domain sınıfları DI anotasyonu taşımadığından kayıtları burada yapılır.
@module
abstract class RouteExportModule {
  @lazySingleton
  CreateRouteExportUseCase createRouteExportUseCase(
    RouteExportRepository repository,
  ) => CreateRouteExportUseCase(repository);

  @lazySingleton
  GetRouteExportsUseCase getRouteExportsUseCase(
    RouteExportRepository repository,
  ) => GetRouteExportsUseCase(repository);

  @lazySingleton
  OpenRouteExportUseCase openRouteExportUseCase(
    RouteExportRepository repository,
  ) => OpenRouteExportUseCase(repository);

  @lazySingleton
  CreateRouteExportShareLinkUseCase createRouteExportShareLinkUseCase(
    RouteExportRepository repository,
  ) => CreateRouteExportShareLinkUseCase(repository);

  @lazySingleton
  DeleteRouteExportUseCase deleteRouteExportUseCase(
    RouteExportRepository repository,
  ) => DeleteRouteExportUseCase(repository);

  @lazySingleton
  WatchRouteExportChangesUseCase watchRouteExportChangesUseCase(
    RouteExportRepository repository,
  ) => WatchRouteExportChangesUseCase(repository);
}
