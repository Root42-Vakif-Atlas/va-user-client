import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vakif_atlas/core/error/exceptions.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/network/session_events.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/features/auth/data/dtos/auth_dtos.dart';
import 'package:vakif_atlas/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:vakif_atlas/features/auth/data/sources/auth_local_data_source.dart';
import 'package:vakif_atlas/features/auth/data/sources/auth_remote_data_source.dart';
import 'package:vakif_atlas/features/auth/domain/entities/auth_session_event.dart';
import 'package:vakif_atlas/features/auth/domain/entities/auth_tokens.dart';
import 'package:vakif_atlas/features/auth/domain/entities/user_entity.dart';

class _MockRemote extends Mock implements AuthRemoteDataSource {}

class _MockTokenRemote extends Mock implements AuthTokenRemoteDataSource {}

class _MockLocal extends Mock implements AuthLocalDataSource {}

void main() {
  const userDto = UserDto(
    id: 'usr_1',
    displayName: 'Ayşe Yılmaz',
    email: 'ayse@example.org',
  );
  const user = UserEntity(
    id: 'usr_1',
    displayName: 'Ayşe Yılmaz',
    email: 'ayse@example.org',
  );
  final now = DateTime(2026, 10, 17, 12);

  late _MockRemote remote;
  late _MockTokenRemote tokenRemote;
  late _MockLocal local;
  late SessionEvents sessionEvents;
  late AuthRepositoryImpl repository;

  setUpAll(() => registerFallbackValue(userDto));

  setUp(() {
    remote = _MockRemote();
    tokenRemote = _MockTokenRemote();
    local = _MockLocal();
    sessionEvents = SessionEvents();
    repository = AuthRepositoryImpl(
      remote,
      tokenRemote,
      local,
      sessionEvents,
      clock: () => now,
    );
    when(
      () => local.saveSession(
        accessToken: any(named: 'accessToken'),
        refreshToken: any(named: 'refreshToken'),
        user: any(named: 'user'),
      ),
    ).thenAnswer((_) async {});
    when(local.clearSession).thenAnswer((_) async {});
  });

  tearDown(() async {
    await repository.dispose();
    await sessionEvents.dispose();
  });

  DioException httpError(int status) {
    final options = RequestOptions(path: 'auth/login');
    return DioException(
      requestOptions: options,
      type: DioExceptionType.badResponse,
      response: Response<Object?>(requestOptions: options, statusCode: status),
      error: ServerException(statusCode: status),
    );
  }

  group('login', () {
    test('başarılı girişte oturumu kaydeder ve SignedIn yayınlar', () async {
      when(
        () => remote.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) async => const AuthResponseDto(
          accessToken: 'a',
          refreshToken: 'r',
          expiresIn: 900,
          user: userDto,
        ),
      );
      final events = expectLater(
        repository.sessionEvents,
        emits(const SignedIn(user)),
      );

      final result = await repository.login(email: 'e', password: 'p');

      expect(result, const Right<Failure, UserEntity>(user));
      verify(
        () => local.saveSession(
          accessToken: 'a',
          refreshToken: 'r',
          user: userDto,
        ),
      ).called(1);
      await events;
    });

    test('401 InvalidCredentialsFailure olarak döner', () async {
      when(
        () => remote.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(httpError(401));

      final result = await repository.login(email: 'e', password: 'p');

      expect(
        result,
        const Left<Failure, UserEntity>(
          AuthFailure(AuthFailureReason.invalidCredentials),
        ),
      );
    });

    test('ağ hatası NetworkFailure olarak döner', () async {
      when(
        () => remote.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(const NetworkException(NetworkExceptionType.timeout));

      final result = await repository.login(email: 'e', password: 'p');

      expect(result, const Left<Failure, UserEntity>(NetworkFailure()));
    });
  });

  group('restoreSession', () {
    test('anahtar yoksa misafir (null) döner', () async {
      when(local.readAccessToken).thenAnswer((_) async => null);
      when(local.readRefreshToken).thenAnswer((_) async => null);

      expect(
        await repository.restoreSession(),
        const Right<Failure, UserEntity?>(null),
      );
    });

    test('önbellekteki kullanıcıyı ağa gitmeden döndürür', () async {
      when(local.readAccessToken).thenAnswer((_) async => 'a');
      when(local.readRefreshToken).thenAnswer((_) async => 'r');
      when(local.readCachedUser).thenAnswer((_) async => userDto);

      expect(
        await repository.restoreSession(),
        const Right<Failure, UserEntity?>(user),
      );
      verifyNever(remote.fetchCurrentUser);
    });

    test('önbellek yoksa profili sunucudan alır ve saklar', () async {
      when(local.readAccessToken).thenAnswer((_) async => 'a');
      when(local.readRefreshToken).thenAnswer((_) async => 'r');
      when(local.readCachedUser).thenAnswer((_) async => null);
      when(remote.fetchCurrentUser).thenAnswer((_) async => userDto);

      expect(
        await repository.restoreSession(),
        const Right<Failure, UserEntity?>(user),
      );
      verify(
        () => local.saveSession(
          accessToken: 'a',
          refreshToken: 'r',
          user: userDto,
        ),
      ).called(1);
    });
  });

  test('logout sunucu hatasında da yerel oturumu kapatır', () async {
    when(local.readRefreshToken).thenAnswer((_) async => 'r');
    when(() => remote.logout(refreshToken: any(named: 'refreshToken')))
        .thenThrow(httpError(503));
    final events = expectLater(
      repository.sessionEvents,
      emits(const SignedOut()),
    );

    final result = await repository.logout();

    expect(result, const Right<Failure, Unit>(unit));
    verify(local.clearSession).called(1);
    await events;
  });

  test('refreshToken yeni anahtarları kaydeder', () async {
    when(local.readRefreshToken).thenAnswer((_) async => 'r');
    when(() => tokenRemote.refresh(refreshToken: 'r')).thenAnswer(
      (_) async => const AuthResponseDto(
        accessToken: 'a2',
        refreshToken: 'r2',
        expiresIn: 900,
      ),
    );

    final result = await repository.refreshToken();

    expect(
      result,
      Right<Failure, AuthTokens>(
        AuthTokens(
          accessToken: 'a2',
          refreshToken: 'r2',
          expiresAt: now.add(const Duration(seconds: 900)),
        ),
      ),
    );
  });

  test('ağ katmanı oturum sonu bildirince oturum temizlenir', () async {
    when(local.readRefreshToken).thenAnswer((_) async => 'refresh');
    final events = expectLater(
      repository.sessionEvents,
      emits(const SessionExpired()),
    );

    sessionEvents.notifySessionExpired();

    await events;
    verify(local.clearSession).called(1);
  });

  test('oturum zaten kapalıyken oturum sonu bildirimi yok sayılır', () async {
    when(local.readRefreshToken).thenAnswer((_) async => null);
    when(local.readAccessToken).thenAnswer((_) async => null);
    final emitted = <AuthSessionEvent>[];
    final subscription = repository.sessionEvents.listen(emitted.add);

    sessionEvents.notifySessionExpired();
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    await subscription.cancel();

    expect(emitted, isEmpty);
    verifyNever(local.clearSession);
  });
}
