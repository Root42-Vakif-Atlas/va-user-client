import 'package:vakif_atlas/core/usecase/usecase.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/onboarding/domain/repositories/onboarding_repository.dart';

/// İlk çizimde yönlendirme kararı verilebilmesi için senkrondur.
class IsOnboardingCompletedUseCase {
  const IsOnboardingCompletedUseCase(this._repository);

  final OnboardingRepository _repository;

  bool call() => _repository.isCompleted;
}

class CompleteOnboardingUseCase implements UseCase<Unit, NoParams> {
  const CompleteOnboardingUseCase(this._repository);

  final OnboardingRepository _repository;

  @override
  ResultFuture<Unit> call(NoParams params) => _repository.markCompleted();
}
