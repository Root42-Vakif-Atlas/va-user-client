import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vakif_atlas/core/error/exceptions.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/storage/preferences_service.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/features/onboarding/data/repositories/onboarding_repository_impl.dart';

class _MockPreferences extends Mock implements PreferencesService {}

Future<OnboardingRepositoryImpl> _repository([
  Map<String, Object> values = const {},
]) async {
  SharedPreferences.setMockInitialValues(values);
  return OnboardingRepositoryImpl(
    PreferencesService(await SharedPreferences.getInstance()),
  );
}

void main() {
  test('ilk kurulumda tanıtım tamamlanmamıştır', () async {
    expect((await _repository()).isCompleted, isFalse);
  });

  test('tamamlanan sürüm yeniden açılışta korunur', () async {
    final repository = await _repository();

    final result = await repository.markCompleted();

    expect(result, const Right<Failure, Unit>(unit));
    final reopened = OnboardingRepositoryImpl(
      PreferencesService(await SharedPreferences.getInstance()),
    );
    expect(reopened.isCompleted, isTrue);
  });

  test(
    'eski tanıtım sürümünü tamamlamış kullanıcıya yeniden gösterilir',
    () async {
      final repository = await _repository({
        'onboarding.completed_version':
            OnboardingRepositoryImpl.currentVersion - 1,
      });
      expect(repository.isCompleted, isFalse);
    },
  );

  test('yazma hatası CacheFailure olarak döner', () async {
    final preferences = _MockPreferences();
    when(() => preferences.setOnboardingVersion(any()))
        .thenThrow(const CacheException('preferences.write'));

    final result = await OnboardingRepositoryImpl(preferences).markCompleted();

    expect(result, const Left<Failure, Unit>(CacheFailure()));
  });
}
