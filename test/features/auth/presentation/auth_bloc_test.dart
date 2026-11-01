import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/usecase/usecase.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/features/auth/domain/entities/auth_session_event.dart';
import 'package:vakif_atlas/features/auth/domain/entities/user_entity.dart';
import 'package:vakif_atlas/features/auth/domain/usecases/auth_usecases.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/auth_bloc.dart';

class _MockRestore extends Mock implements RestoreSessionUseCase {}

class _MockLogout extends Mock implements LogoutUseCase {}

class _MockWatch extends Mock implements WatchAuthSessionUseCase {}

void main() {
  const user = UserEntity(
    id: 'usr_1',
    displayName: 'Ayşe Yılmaz',
    email: 'ayse@example.org',
  );

  late _MockRestore restore;
  late _MockLogout logout;
  late _MockWatch watch;
  late StreamController<AuthSessionEvent> sessionEvents;

  setUpAll(() => registerFallbackValue(const NoParams()));

  setUp(() {
    restore = _MockRestore();
    logout = _MockLogout();
    watch = _MockWatch();
    sessionEvents = StreamController<AuthSessionEvent>.broadcast();
    when(() => watch(any())).thenAnswer((_) => sessionEvents.stream);
    when(() => logout(any())).thenAnswer((_) async => const Right(unit));
  });

  tearDown(() => sessionEvents.close());

  AuthBloc build() => AuthBloc(restore, logout, watch);

  test('başlangıç durumu unknown', () {
    expect(build().state, const AuthState.unknown());
  });

  blocTest<AuthBloc, AuthState>(
    'kayıtlı oturum varsa authenticated (citizen) olur',
    setUp: () =>
        when(() => restore(any())).thenAnswer((_) async => const Right(user)),
    build: build,
    act: (bloc) => bloc.add(const AuthEvent.started()),
    expect: () => [const AuthState.authenticated(user)],
  );

  blocTest<AuthBloc, AuthState>(
    'kayıtlı oturum yoksa guest olur',
    setUp: () =>
        when(() => restore(any())).thenAnswer((_) async => const Right(null)),
    build: build,
    act: (bloc) => bloc.add(const AuthEvent.started()),
    expect: () => [const AuthState.guest()],
  );

  blocTest<AuthBloc, AuthState>(
    'oturum okunamazsa güvenli varsayılan olarak guest olur',
    setUp: () =>
        when(() => restore(any()))
            .thenAnswer((_) async => const Left(CacheFailure())),
    build: build,
    act: (bloc) => bloc.add(const AuthEvent.started()),
    expect: () => [const AuthState.guest()],
  );

  blocTest<AuthBloc, AuthState>(
    'repository giriş olayı authenticated durumuna geçirir',
    build: build,
    act: (_) => sessionEvents.add(const SignedIn(user)),
    expect: () => [const AuthState.authenticated(user)],
  );

  blocTest<AuthBloc, AuthState>(
    'çıkış isteği logout çağırır ve guest olur',
    build: build,
    seed: () => const AuthState.authenticated(user),
    act: (bloc) => bloc.add(const AuthEvent.logoutRequested()),
    expect: () => [const AuthState.guest()],
    verify: (_) => verify(() => logout(any())).called(1),
  );

  blocTest<AuthBloc, AuthState>(
    'oturum süresi dolarsa guest(sessionExpired: true) olur',
    build: build,
    seed: () => const AuthState.authenticated(user),
    act: (_) => sessionEvents.add(const SessionExpired()),
    expect: () => [const AuthState.guest(sessionExpired: true)],
  );

  blocTest<AuthBloc, AuthState>(
    'misafirken gelen oturum sonu olayı durumu değiştirmez',
    build: build,
    seed: () => const AuthState.guest(),
    act: (_) => sessionEvents.add(const SessionExpired()),
    expect: () => <AuthState>[],
  );
}
