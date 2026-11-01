import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/exceptions.dart';
import 'package:vakif_atlas/core/storage/secure_storage_service.dart';
import 'package:vakif_atlas/features/auth/data/dtos/auth_dtos.dart';

/// Oturum bilgilerinin şifreli yerel deposu.
///
/// Anahtarlar ve kullanıcı profili (e-posta PII içerdiğinden) yalnızca
/// `SecureStorageService` içinde tutulur.
abstract interface class AuthLocalDataSource {
  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    UserDto? user,
  });

  /// Oturum her açıldığında / kapandığında artar. Yenileme başlarken okunur;
  /// yenileme sürerken oturum değiştiyse yeni anahtarlar yazılmaz.
  int get sessionEpoch;

  /// Yenilenen anahtarları yalnızca [epoch] hâlâ geçerliyse yazar; çıkış
  /// veya yeni giriş araya girdiyse `false` döner.
  Future<bool> saveRefreshedTokens({
    required String accessToken,
    required String refreshToken,
    required int epoch,
  });

  Future<String?> readRefreshToken();

  Future<String?> readAccessToken();

  Future<UserDto?> readCachedUser();

  Future<void> clearSession();
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl(this._storage);

  final SecureStorageService _storage;

  static const String _userKey = 'auth.session_user';

  int _epoch = 0;

  @override
  int get sessionEpoch => _epoch;

  @override
  Future<bool> saveRefreshedTokens({
    required String accessToken,
    required String refreshToken,
    required int epoch,
  }) async {
    if (epoch != _epoch) {
      return false;
    }
    await _storage.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
    return true;
  }

  @override
  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    UserDto? user,
  }) async {
    _epoch++;
    await _storage.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
    if (user != null) {
      await _storage.write(_userKey, jsonEncode(user.toJson()));
    }
  }

  @override
  Future<String?> readAccessToken() => _storage.getAccessToken();

  @override
  Future<String?> readRefreshToken() => _storage.getRefreshToken();

  @override
  Future<UserDto?> readCachedUser() async {
    final raw = await _storage.read(_userKey);
    if (raw == null) {
      return null;
    }
    try {
      return UserDto.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on Exception {
      await _storage.delete(_userKey);
      throw const CacheException('auth.cached_user.decode');
    }
  }

  @override
  Future<void> clearSession() async {
    _epoch++;
    await _storage.deleteTokens();
    await _storage.delete(_userKey);
  }
}
