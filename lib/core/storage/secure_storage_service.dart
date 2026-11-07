import 'package:flutter/services.dart';
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

  /// Kayıt okunamazsa:
  /// - Geçici durumda (cihaz kilitli, ilk kilit açılışından önce)
  ///   [CacheException] fırlatılır; kayıt korunur.
  /// - Kalıcı durumda kayıt silinir ve yokmuş gibi `null` döner. Örnek:
  ///   macOS'ta kayıt başka imzalı bir derlemeye aittir (`-128`; takımsız
  ///   imzada her derleme farklıdır), Android'de anahtar deposu anahtarı
  ///   geçersizdir, web'de şifreleme anahtarı silinmiştir. Silinmezse
  ///   kayıt hiçbir zaman okunamaz: oturum gerektiren her istek "yerel veri
  ///   okunamadı" hatasıyla düşer ve macOS her istekte izin sorar. Silinince
  ///   kullanıcı oturumsuz devam eder; yeniden girişte yeni kayıt yazılır.
  Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } on Exception catch (error) {
      if (_isTransient(error)) {
        throw const CacheException('secure_storage.read');
      }
      try {
        await _storage.delete(key: key);
      } on Exception {
        // Silinemese de okunamayan değer kullanılmaz.
      }
      return null;
    }
  }

  /// `errSecInteractionNotAllowed`: cihaz kilitliyken anahtar zinciri
  /// okunamaz (iOS / macOS); kilit açılınca yeniden okunabilir.
  static const int interactionNotAllowed = -25308;

  static bool _isTransient(Exception error) =>
      error is PlatformException &&
      (error.details == interactionNotAllowed ||
          (error.message?.contains('$interactionNotAllowed') ?? false));

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
