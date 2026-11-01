import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:vakif_atlas/features/catalog/domain/usecases/catalog_usecases.dart';

/// Domain sınıfları DI anotasyonu taşımadığından kayıtları burada yapılır.
@module
abstract class CatalogModule {
  @lazySingleton
  SearchMonumentsUseCase searchMonumentsUseCase(CatalogRepository repository) =>
      SearchMonumentsUseCase(repository);

  @lazySingleton
  GetMonumentPinsUseCase getMonumentPinsUseCase(CatalogRepository repository) =>
      GetMonumentPinsUseCase(repository);

  @lazySingleton
  GetMapTileUseCase getMapTileUseCase(CatalogRepository repository) =>
      GetMapTileUseCase(repository);

  @lazySingleton
  GetMapExtentUseCase getMapExtentUseCase(CatalogRepository repository) =>
      GetMapExtentUseCase(repository);

  @lazySingleton
  GetMonumentDetailUseCase getMonumentDetailUseCase(
    CatalogRepository repository,
  ) => GetMonumentDetailUseCase(repository);

  @lazySingleton
  GetComplexDetailUseCase getComplexDetailUseCase(
    CatalogRepository repository,
  ) => GetComplexDetailUseCase(repository);

  @lazySingleton
  GetComplexMembersUseCase getComplexMembersUseCase(
    CatalogRepository repository,
  ) => GetComplexMembersUseCase(repository);
}
