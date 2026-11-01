/// Uygulamanın kullanım anında istediği cihaz izinleri.
///
/// Konum izni `LocationService`'tedir (konum servisleri de denetlenir).
/// Fotoğraf seçimi izin gerektirmez (sistem fotoğraf seçicisi yalnızca
/// seçilen fotoğrafları verir); bu yüzden listede yoktur.
enum AppPermission {
  /// Anı Köşesi ve Sivil Koruma'da fotoğraf çekmek.
  camera,

  /// Dijital Rehber'e sesli soru (iOS'ta konuşma tanıma izniyle birlikte).
  microphone,
}

/// Bir iznin anlık durumu (izin kartları ve kullanım anı ön kontrolü).
enum PermissionAccess {
  granted,

  /// Henüz sorulmadı veya bu sefer reddedildi; sistem penceresi açılabilir.
  denied,

  /// Kalıcı olarak reddedildi veya kısıtlandı → uygulama ayarları.
  deniedForever,

  /// Özellik bu platformda yok veya durum okunamadı.
  unsupported;

  /// Özellik kullanılabilir mi.
  bool get isUsable => this == granted;
}

/// Kamera ve mikrofon izinleri.
///
/// İzin yalnızca kullanıcının açık bir eylemiyle istenir: ilgili özelliğe
/// dokunması veya tanıtımdaki/ayarlardaki izin kartı (bağlamsal izin, OWASP
/// MASVS-PRIVACY). Hiçbir ekran açılışta kendiliğinden izin istemez.
/// Implementasyonlar istisna fırlatmaz.
abstract interface class PermissionService {
  /// İzin istemeden mevcut durumu okur.
  Future<PermissionAccess> check(AppPermission permission);

  /// Gerekirse sistem izin penceresini açar.
  Future<PermissionAccess> request(AppPermission permission);

  /// Uygulamanın sistem ayarları açılabiliyor mu (web'de hayır).
  bool get canOpenAppSettings;

  /// Uygulamanın sistem ayarlarını açar (kalıcı reddi geri almak için).
  Future<bool> openAppSettings();
}
