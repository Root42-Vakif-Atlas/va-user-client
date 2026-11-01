import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:vakif_atlas/features/onboarding/domain/usecases/onboarding_usecases.dart';
import 'package:vakif_atlas/features/onboarding/presentation/cubit/onboarding_cubit.dart';

/// Bellek içi tanıtım durumu.
class InMemoryOnboardingRepository implements OnboardingRepository {
  InMemoryOnboardingRepository({this.isCompleted = false});

  @override
  bool isCompleted;

  @override
  ResultFuture<Unit> markCompleted() async {
    isCompleted = true;
    return const Right(unit);
  }
}

OnboardingCubit onboardingCubit({bool completed = true}) {
  final repository = InMemoryOnboardingRepository(isCompleted: completed);
  return OnboardingCubit(
    IsOnboardingCompletedUseCase(repository),
    CompleteOnboardingUseCase(repository),
  );
}
