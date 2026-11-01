import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/features/gamification/domain/repositories/gamification_repository.dart';
import 'package:vakif_atlas/features/gamification/domain/usecases/gamification_usecases.dart';

/// Domain sınıfları DI anotasyonu taşımadığından kayıtları burada yapılır.
@module
abstract class GamificationModule {
  @lazySingleton
  GetGamificationProfileUseCase getGamificationProfileUseCase(
    GamificationRepository repository,
  ) => GetGamificationProfileUseCase(repository);

  @lazySingleton
  AcknowledgeUnlocksUseCase acknowledgeUnlocksUseCase(
    GamificationRepository repository,
  ) => AcknowledgeUnlocksUseCase(repository);
}
