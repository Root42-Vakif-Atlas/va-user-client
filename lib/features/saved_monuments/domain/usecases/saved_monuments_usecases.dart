import 'package:vakif_atlas/core/usecase/usecase.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/saved_monuments/domain/entities/saved_monument.dart';
import 'package:vakif_atlas/features/saved_monuments/domain/repositories/saved_monuments_repository.dart';

class GetSavedMonumentsUseCase
    implements UseCase<List<SavedMonument>, NoParams> {
  const GetSavedMonumentsUseCase(this._repository);

  final SavedMonumentsRepository _repository;

  @override
  ResultFuture<List<SavedMonument>> call(NoParams params) =>
      _repository.getSaved();
}

/// Eseri kaydeder; kayıtlıysa dokunmaz, sınır doluysa eklemez.
class SaveMonumentUseCase
    implements UseCase<SaveMonumentOutcome, SavedMonument> {
  const SaveMonumentUseCase(this._repository);

  final SavedMonumentsRepository _repository;

  @override
  ResultFuture<SaveMonumentOutcome> call(SavedMonument params) =>
      _repository.save(params);
}

class RemoveSavedMonumentUseCase implements UseCase<Unit, String> {
  const RemoveSavedMonumentUseCase(this._repository);

  final SavedMonumentsRepository _repository;

  @override
  ResultFuture<Unit> call(String monumentId) => _repository.remove(monumentId);
}

class WatchSavedMonumentsUseCase
    implements StreamUseCase<List<SavedMonument>, NoParams> {
  const WatchSavedMonumentsUseCase(this._repository);

  final SavedMonumentsRepository _repository;

  @override
  Stream<List<SavedMonument>> call(NoParams params) => _repository.changes;
}
