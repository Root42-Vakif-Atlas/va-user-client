import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/exceptions.dart';

/// Donanım destekli şifreli anahtar deposu (iOS Keychain / Android Keystore).
///
/// Erişim/yenileme anahtarları ve hassas kullanıcı tanımlayıcıları yalnızca
/// burada saklanır (TRD §10.A). Hatalar [CacheException] olarak fırlatılır.
@lazySingleton
class SecureStorageService {
  SecureStorageService(this._storage);

  final FlutterSecureStorage _storage;

  static const String _accessTokenKey = 'auth.access_token';
  static const String _refreshTokenKey = 'auth.refresh_token';

  /// Her istekte Keychain/Keystore'a gitmemek için bellek içi kopya.
  String? _cachedAccessToken;
  bool _accessTokenLoaded = false;

  Future<String?> getAccessToken() async {
    if (_accessTokenLoaded) {
      return _cachedAccessToken;
    }
    _cachedAccessToken = await read(_accessTokenKey);
    _accessTokenLoaded = true;
    return _cachedAccessToken;
  }

  Future<String?> getRefreshToken() => read(_refreshTokenKey);

  Future<void> saveAccessToken(String token) async {
    await write(_accessTokenKey, token);
    _cachedAccessToken = token;
    _accessTokenLoaded = true;
  }

  Future<void> saveRefreshToken(String token) => write(_refreshTokenKey, token);

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await saveAccessToken(accessToken);
    await saveRefreshToken(refreshToken);
  }

  Future<void> deleteTokens() async {
    await delete(_accessTokenKey);
    await delete(_refreshTokenKey);
    _cachedAccessToken = null;
    _accessTokenLoaded = true;
  }

  Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } on Exception {
      throw const CacheException('secure_storage.read');
    }
  }

  Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } on Exception {
      throw const CacheException('secure_storage.write');
    }
  }

  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
    } on Exception {
      throw const CacheException('secure_storage.delete');
    }
  }

  /// Oturum kapatma veya güvenlik ihlalinde tüm hassas verileri siler.
  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } on Exception {
      throw const CacheException('secure_storage.clear');
    } finally {
      _cachedAccessToken = null;
      _accessTokenLoaded = false;
    }
  }
}
