import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/usecase/usecase.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/features/auth/domain/entities/user_entity.dart';
import 'package:vakif_atlas/features/auth/domain/repositories/auth_repository.dart';
import 'package:vakif_atlas/features/auth/domain/usecases/auth_usecases.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  const user = UserEntity(
    id: 'usr_1',
    displayName: 'Ayşe Yılmaz',
    email: 'ayse@example.org',
  );
  late _MockAuthRepository repository;

  setUp(() => repository = _MockAuthRepository());

  group('LoginUseCase', () {
    test('e-postayı boşluklardan arındırıp repository\'ye iletir', () async {
      when(
        () => repository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Right(user));

      final result = await LoginUseCase(repository)(
        const LoginParams(email: '  ayse@example.org ', password: 'Atlas2026!'),
      );

      expect(result, const Right<Failure, UserEntity>(user));
      verify(
        () =>
            repository.login(email: 'ayse@example.org', password: 'Atlas2026!'),
      ).called(1);
    });

    test('repository başarısızlığını değiştirmeden döndürür', () async {
      when(
        () => repository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) async =>
            const Left(AuthFailure(AuthFailureReason.invalidCredentials)),
      );

      final result = await LoginUseCase(repository)(
        const LoginParams(email: 'a@b.co', password: 'wrongpass'),
      );

      expect(
        result,
        const Left<Failure, UserEntity>(
          AuthFailure(AuthFailureReason.invalidCredentials),
        ),
      );
    });

    test('LoginParams şifreyi toString ile sızdırmaz', () {
      expect(
        const LoginParams(email: 'a@b.co', password: 'secret').toString(),
        isNot(contains('secret')),
      );
    });
  });

  test(
    'LogoutUseCase ve RestoreSessionUseCase repository\'ye delege eder',
    () async {
      when(repository.logout).thenAnswer((_) async => const Right(unit));
      when(repository.restoreSession)
          .thenAnswer((_) async => const Right(user));

      expect(
        await LogoutUseCase(repository)(const NoParams()),
        const Right<Failure, Unit>(unit),
      );
      expect(
        await RestoreSessionUseCase(repository)(const NoParams()),
        const Right<Failure, UserEntity?>(user),
      );
    },
  );
}
