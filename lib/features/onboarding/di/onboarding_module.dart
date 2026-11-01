import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:vakif_atlas/features/onboarding/domain/usecases/onboarding_usecases.dart';

/// Domain sınıfları DI anotasyonu taşımadığından kayıtları burada yapılır.
@module
abstract class OnboardingModule {
  @lazySingleton
  IsOnboardingCompletedUseCase isOnboardingCompletedUseCase(
    OnboardingRepository repository,
  ) => IsOnboardingCompletedUseCase(repository);

  @lazySingleton
  CompleteOnboardingUseCase completeOnboardingUseCase(
    OnboardingRepository repository,
  ) => CompleteOnboardingUseCase(repository);
}
