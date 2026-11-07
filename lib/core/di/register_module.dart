import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:uuid/uuid.dart';

/// Üçüncü parti servislerin DI kayıtları.
@module
abstract class RegisterModule {
  /// Tercihler açılışta bir kez yüklenir, sonrasında senkron okunur.
  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

  @preResolve
  Future<PackageInfo> get packageInfo => PackageInfo.fromPlatform();

  /// iOS Keychain (yalnızca bu cihaz, ilk kilit açılışından sonra) ve
  /// Android Keystore destekli şifreli depolama.
  ///
  /// macOS'ta "data protection" anahtar zinciri kullanılmaz: o,
  /// `keychain-access-groups` yetkisi ve hazırlama profili (Apple ekibi)
  /// ister; yetkisiz imzalı derlemede her yazma `-34018` ile başarısız olur
  /// ve giriş "yerel veri okunamadı" hatası verir. Klasik anahtar zinciri
  /// sandbox'ta yetki gerektirmez; uygulama anahtar paylaşmadığından yeterlidir.
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
    mOptions: MacOsOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
      usesDataProtectionKeychain: false,
    ),
  );

  @lazySingleton
  Connectivity get connectivity => Connectivity();

  @lazySingleton
  FlutterTts get flutterTts => FlutterTts();

  @lazySingleton
  SpeechToText get speechToText => SpeechToText();

  @lazySingleton
  Uuid get uuid => const Uuid();
}
