import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/exceptions.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/network/session_events.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/auth/data/auth_error_mapper.dart';
import 'package:vakif_atlas/features/auth/data/dtos/auth_dtos.dart';
import 'package:vakif_atlas/features/auth/data/sources/auth_local_data_source.dart';
import 'package:vakif_atlas/features/auth/data/sources/auth_remote_data_source.dart';
import 'package:vakif_atlas/features/auth/domain/entities/auth_session_event.dart';
import 'package:vakif_atlas/features/auth/domain/entities/auth_tokens.dart';
import 'package:vakif_atlas/features/auth/domain/entities/registration_data.dart';
import 'package:vakif_atlas/features/auth/domain/entities/user_entity.dart';
import 'package:vakif_atlas/features/auth/domain/entities/verification_challenge.dart';
import 'package:vakif_atlas/features/auth/domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(
    this._remote,
    this._tokenRemote,
    this._local,
    this._sessionEvents, {
    @ignoreParam DateTime Function()? clock,
  }) : _now = clock ?? DateTime.now {
    _expirySubscription = _sessionEvents.onSessionExpired.listen(
      (_) => _expireSession(),
    );
  }

  final AuthRemoteDataSource _remote;
  final AuthTokenRemoteDataSource _tokenRemote;
  final AuthLocalDataSource _local;
  final SessionEvents _sessionEvents;
  final DateTime Function() _now;
  final StreamController<AuthSessionEvent> _events =
      StreamController<AuthSessionEvent>.broadcast();
  late final StreamSubscription<void> _expirySubscription;

  @override
  Stream<AuthSessionEvent> get sessionEvents => _events.stream;

  @override
  ResultFuture<UserEntity?> restoreSession() async {
    try {
      final accessToken = await _local.readAccessToken();
      final refreshToken = await _local.readRefreshToken();
      if (accessToken == null || refreshToken == null) {
        return const Right(null);
      }
      final cachedUser = await _local.readCachedUser();
      if (cachedUser != null) {
        return Right(cachedUser.toDomain());
      }
      final user = await _remote.fetchCurrentUser();
      await _local.saveSession(
        accessToken: accessToken,
        refreshToken: refreshToken,
        user: user,
      );
      return Right(user.toDomain());
    } on Exception catch (error) {
      return Left(AuthErrorMapper.toFailure(error));
    }
  }

  @override
  ResultFuture<UserEntity> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _remote.login(email: email, password: password);
      return Right(await _startSession(response));
    } on Exception catch (error) {
      final failure = AuthErrorMapper.toFailure(error);
      // Kodsuz 401 de giriş uç noktasında hatalı kimlik bilgisidir.
      return Left(
        failure is UnauthorizedFailure
            ? const AuthFailure(AuthFailureReason.invalidCredentials)
            : failure,
      );
    }
  }

  @override
  ResultFuture<Unit> logout() async {
    try {
      final refreshToken = await _local.readRefreshToken();
      if (refreshToken != null) {
        await _remote.logout(refreshToken: refreshToken);
      }
    } on Exception {
      // Sunucuda iptal edilemese de yerel oturum her durumda kapatılır.
    }
    return _endSession(const SignedOut());
  }

  @override
  ResultFuture<AuthTokens> refreshToken() async {
    try {
      final refreshToken = await _local.readRefreshToken();
      if (refreshToken == null) {
        return const Left(UnauthorizedFailure());
      }
      final response = await _tokenRemote.refresh(refreshToken: refreshToken);
      await _local.saveSession(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      return Right(response.toTokens(_now()));
    } on Exception catch (error) {
      return Left(AuthErrorMapper.toFailure(error));
    }
  }

  @override
  ResultFuture<VerificationChallenge> register(RegistrationData data) {
    return _guard(() async {
      final challenge = await _remote.register(data);
      return challenge.toDomain(data.email);
    });
  }

  @override
  ResultFuture<UserEntity> verifyEmail({
    required String email,
    required String code,
    required String password,
  }) {
    return _guard(() async {
      final response = await _remote.verifyEmail(
        email: email,
        code: code,
        password: password,
      );
      return _startSession(response);
    });
  }

  @override
  ResultFuture<VerificationChallenge> resendVerificationCode(String email) {
    return _guard(() async {
      final challenge = await _remote.resendVerification(email: email);
      return challenge.toDomain(email);
    });
  }

  @override
  ResultFuture<VerificationChallenge> requestPasswordReset(String email) {
    return _guard(() async {
      final challenge = await _remote.requestPasswordReset(email: email);
      return challenge.toDomain(email);
    });
  }

  @override
  ResultFuture<Unit> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) {
    return _guard(() async {
      await _remote.resetPassword(
        email: email,
        code: code,
        newPassword: newPassword,
      );
      // Sunucu tüm oturumları iptal etti; cihazda kalmış anahtarlar silinir.
      await _local.clearSession();
      return unit;
    });
  }

  @override
  ResultFuture<Unit> changePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    return _guard(() async {
      final response = await _remote.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      // Eski anahtarlar sunucuda geçersiz; bu cihaz yeni çiftle devam eder.
      await _local.saveSession(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      return unit;
    });
  }

  @override
  ResultFuture<Unit> deleteAccount({required String password}) async {
    try {
      await _remote.deleteAccount(password: password);
    } on Exception catch (error) {
      return Left(AuthErrorMapper.toFailure(error));
    }
    String? userId;
    try {
      userId = (await _local.readCachedUser())?.id;
    } on CacheException {
      userId = null;
    }
    return _endSession(AccountDeleted(userId: userId));
  }

  Future<UserEntity> _startSession(AuthResponseDto response) async {
    final user = response.user;
    if (user == null) {
      throw const UnexpectedException('auth.response.missing_user');
    }
    await _local.saveSession(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
      user: user,
    );
    final entity = user.toDomain();
    _emit(SignedIn(entity));
    return entity;
  }

  Future<Result<Unit>> _endSession(AuthSessionEvent event) async {
    try {
      await _local.clearSession();
      return const Right(unit);
    } on CacheException {
      return const Left(CacheFailure());
    } finally {
      _emit(event);
    }
  }

  static ResultFuture<T> _guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on Exception catch (error) {
      return Left(AuthErrorMapper.toFailure(error));
    }
  }

  /// Anahtar yoksa (oturum zaten kapatılmış — ör. çıkış, yenileme sürerken
  /// yapıldı) ikinci bir "oturum sona erdi" olayı yayınlanmaz.
  Future<void> _expireSession() async {
    try {
      if (await _local.readRefreshToken() == null &&
          await _local.readAccessToken() == null) {
        return;
      }
      await _local.clearSession();
    } on CacheException {
      // Silinemeyen anahtarlar bir sonraki istekte yine 401 üretir.
    }
    _emit(const SessionExpired());
  }

  void _emit(AuthSessionEvent event) {
    if (!_events.isClosed) {
      _events.add(event);
    }
    if (event case AccountDeleted(:final userId?)) {
      _sessionEvents.notifyAccountDeleted(userId);
    }
    _sessionEvents.notifyAccountChanged(switch (event) {
      SignedIn(:final user) => user.id,
      SignedOut() || SessionExpired() || AccountDeleted() => null,
    });
  }

  /// Uygulama ömrü boyunca yaşayan singleton'dır; testlerde kaynakları
  /// serbest bırakmak için çağrılır.
  Future<void> dispose() async {
    await _expirySubscription.cancel();
    await _events.close();
  }
}
