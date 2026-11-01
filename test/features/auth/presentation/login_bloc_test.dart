import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/features/auth/domain/entities/user_entity.dart';
import 'package:vakif_atlas/features/auth/domain/usecases/auth_usecases.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/login_bloc.dart';

class _MockLogin extends Mock implements LoginUseCase {}

void main() {
  const user = UserEntity(
    id: 'usr_1',
    displayName: 'Ayşe Yılmaz',
    email: 'ayse@example.org',
  );
  const validEmail = 'ayse@example.org';
  const validPassword = 'Atlas2026!';

  late _MockLogin login;

  setUpAll(
    () => registerFallbackValue(const LoginParams(email: '', password: '')),
  );

  setUp(() => login = _MockLogin());

  LoginBloc build() => LoginBloc(login);

  blocTest<LoginBloc, LoginState>(
    'geçersiz form gönderilmez, hatalar gösterilir',
    build: build,
    act: (bloc) => bloc
      ..add(const LoginEvent.emailChanged('ayse@'))
      ..add(const LoginEvent.submitted()),
    skip: 1,
    expect: () => [
      const LoginState(
        email: 'ayse@',
        showValidationErrors: true,
        status: LoginStatus.invalid,
        invalidSubmissions: 1,
      ),
    ],
    verify: (_) => verifyNever(() => login(any())),
  );

  blocTest<LoginBloc, LoginState>(
    'geçerli form: submitting → success',
    setUp: () =>
        when(() => login(any())).thenAnswer((_) async => const Right(user)),
    build: build,
    seed: () => const LoginState(email: validEmail, password: validPassword),
    act: (bloc) => bloc.add(const LoginEvent.submitted()),
    expect: () => [
      const LoginState(
        email: validEmail,
        password: validPassword,
        showValidationErrors: true,
        status: LoginStatus.submitting,
      ),
      // Başarıda şifre durumdan temizlenir.
      const LoginState(
        email: validEmail,
        showValidationErrors: true,
        status: LoginStatus.success,
        user: user,
      ),
    ],
    verify: (_) => verify(
      () =>
          login(const LoginParams(email: validEmail, password: validPassword)),
    ).called(1),
  );

  blocTest<LoginBloc, LoginState>(
    'sunucu reddederse failure durumu hatayı taşır',
    setUp: () => when(() => login(any())).thenAnswer(
      (_) async =>
          const Left(AuthFailure(AuthFailureReason.invalidCredentials)),
    ),
    build: build,
    seed: () => const LoginState(email: validEmail, password: validPassword),
    act: (bloc) => bloc.add(const LoginEvent.submitted()),
    skip: 1,
    expect: () => [
      const LoginState(
        email: validEmail,
        password: validPassword,
        showValidationErrors: true,
        status: LoginStatus.failure,
        failure: AuthFailure(AuthFailureReason.invalidCredentials),
      ),
    ],
  );

  blocTest<LoginBloc, LoginState>(
    'doğrulanmamış hesap verificationRequired durumuna geçer',
    setUp: () => when(() => login(any())).thenAnswer(
      (_) async => const Left(AuthFailure(AuthFailureReason.emailNotVerified)),
    ),
    build: build,
    seed: () => const LoginState(email: validEmail, password: validPassword),
    act: (bloc) => bloc.add(const LoginEvent.submitted()),
    verify: (bloc) =>
        expect(bloc.state.status, LoginStatus.verificationRequired),
  );

  blocTest<LoginBloc, LoginState>(
    'droppable: art arda gönderimlerde yalnızca ilki işlenir',
    setUp: () => when(() => login(any())).thenAnswer((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 20));
      return const Right(user);
    }),
    build: build,
    seed: () => const LoginState(email: validEmail, password: validPassword),
    act: (bloc) => bloc
      ..add(const LoginEvent.submitted())
      ..add(const LoginEvent.submitted())
      ..add(const LoginEvent.submitted()),
    wait: const Duration(milliseconds: 50),
    verify: (_) => verify(() => login(any())).called(1),
  );
}
