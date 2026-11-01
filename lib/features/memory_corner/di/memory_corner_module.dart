import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/features/memory_corner/domain/repositories/memory_repository.dart';
import 'package:vakif_atlas/features/memory_corner/domain/usecases/memory_usecases.dart';

/// Domain sınıfları DI anotasyonu taşımadığından kayıtları burada yapılır.
@module
abstract class MemoryCornerModule {
  @lazySingleton
  GetMemoriesUseCase getMemoriesUseCase(MemoryRepository repository) =>
      GetMemoriesUseCase(repository);

  @lazySingleton
  GetMyMemoriesUseCase getMyMemoriesUseCase(MemoryRepository repository) =>
      GetMyMemoriesUseCase(repository);

  @lazySingleton
  CreateMemoryUseCase createMemoryUseCase(MemoryRepository repository) =>
      CreateMemoryUseCase(repository);

  @lazySingleton
  DeleteMemoryUseCase deleteMemoryUseCase(MemoryRepository repository) =>
      DeleteMemoryUseCase(repository);

  @lazySingleton
  ReportMemoryUseCase reportMemoryUseCase(MemoryRepository repository) =>
      ReportMemoryUseCase(repository);

  @lazySingleton
  WatchMemoryChangesUseCase watchMemoryChangesUseCase(
    MemoryRepository repository,
  ) => WatchMemoryChangesUseCase(repository);
}
