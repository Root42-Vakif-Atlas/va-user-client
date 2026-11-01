import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/features/saved_monuments/domain/repositories/saved_monuments_repository.dart';
import 'package:vakif_atlas/features/saved_monuments/domain/usecases/saved_monuments_usecases.dart';

/// Domain sınıfları DI anotasyonu taşımadığından kayıtları burada yapılır.
@module
abstract class SavedMonumentsModule {
  @lazySingleton
  GetSavedMonumentsUseCase getSavedMonumentsUseCase(
    SavedMonumentsRepository repository,
  ) => GetSavedMonumentsUseCase(repository);

  @lazySingleton
  SaveMonumentUseCase saveMonumentUseCase(
    SavedMonumentsRepository repository,
  ) => SaveMonumentUseCase(repository);

  @lazySingleton
  RemoveSavedMonumentUseCase removeSavedMonumentUseCase(
    SavedMonumentsRepository repository,
  ) => RemoveSavedMonumentUseCase(repository);

  @lazySingleton
  WatchSavedMonumentsUseCase watchSavedMonumentsUseCase(
    SavedMonumentsRepository repository,
  ) => WatchSavedMonumentsUseCase(repository);
}
