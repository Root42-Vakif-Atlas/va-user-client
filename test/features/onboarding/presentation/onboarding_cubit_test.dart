import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/usecase/usecase.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/features/onboarding/domain/usecases/onboarding_usecases.dart';
import 'package:vakif_atlas/features/onboarding/presentation/cubit/onboarding_cubit.dart';

import '../../../helpers/onboarding_test_utils.dart';

class _MockComplete extends Mock implements CompleteOnboardingUseCase {}

void main() {
  setUpAll(() => registerFallbackValue(const NoParams()));

  test('başlangıç durumu kayıtlı değerdir', () {
    expect(onboardingCubit(completed: false).state, OnboardingStatus.pending);
    expect(onboardingCubit().state, OnboardingStatus.completed);
  });

  test('tamamlama durumu hemen günceller ve kaydeder', () async {
    final repository = InMemoryOnboardingRepository();
    final cubit = OnboardingCubit(
      IsOnboardingCompletedUseCase(repository),
      CompleteOnboardingUseCase(repository),
    );
    final states = <OnboardingStatus>[];
    final subscription = cubit.stream.listen(states.add);

    await cubit.complete();
    await cubit.complete();
    await Future<void>.delayed(Duration.zero);

    expect(states, [OnboardingStatus.completed]);
    expect(repository.isCompleted, isTrue);
    await subscription.cancel();
    await cubit.close();
  });

  test('kayıt başarısız olsa da oturum boyunca tamamlanmış sayılır', () async {
    final complete = _MockComplete();
    when(() => complete(any()))
        .thenAnswer((_) async => const Left(CacheFailure()));
    final cubit = OnboardingCubit(
      IsOnboardingCompletedUseCase(InMemoryOnboardingRepository()),
      complete,
    );

    await cubit.complete();

    expect(cubit.isCompleted, isTrue);
    await cubit.close();
  });
}
