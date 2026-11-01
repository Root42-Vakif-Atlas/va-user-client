import 'package:flutter/foundation.dart';

/// Cihazın konumu. Yalnızca cihazda kullanılır; sunucuya gönderilmez
/// (KVKK veri minimizasyonu).
@immutable
final class DevicePosition {
  const DevicePosition({
    required this.latitude,
    required this.longitude,
    required this.accuracyMeters,
  });

  final double latitude;
  final double longitude;

  /// Yatay doğruluk yarıçapı (metre, %68 güven).
  final double accuracyMeters;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DevicePosition &&
          other.latitude == latitude &&
          other.longitude == longitude &&
          other.accuracyMeters == accuracyMeters;

  @override
  int get hashCode => Object.hash(latitude, longitude, accuracyMeters);

  /// Konum kişisel veridir; loglara koordinat yazılmaz.
  @override
  String toString() => 'DevicePosition(±${accuracyMeters.round()} m)';
}

/// Konumun alınamama nedeni; kullanıcıya gösterilecek çözüm buna göre
/// seçilir.
enum LocationIssue {
  /// Cihazın konum servisleri kapalı → konum ayarları.
  serviceDisabled,

  /// Kullanıcı izni bu sefer reddetti; bir sonraki denemede yeniden sorulur.
  permissionDenied,

  /// İzin kalıcı olarak reddedildi → uygulama ayarları.
  permissionDeniedForever,

  /// Zaman aşımı, donanım hatası veya desteklenmeyen platform.
  unavailable,
}

/// Konum izninin ve servislerinin anlık durumu (izin ekranları ve ayarlar).
enum LocationAccess {
  /// Uygulama kullanılırken konuma erişilebilir.
  granted,

  /// Henüz sorulmadı veya bu sefer reddedildi; sistem penceresi açılabilir.
  denied,

  /// Kalıcı olarak reddedildi → uygulama ayarları.
  deniedForever,

  /// Cihazın konum servisleri kapalı → konum ayarları.
  serviceDisabled,

  /// Platformda konum yok veya durum okunamadı.
  unsupported;

  /// Sistem ayarlarından çözülecek sorun; çözüm gerekmiyorsa `null`.
  LocationIssue? get settingsIssue => switch (this) {
    deniedForever => LocationIssue.permissionDeniedForever,
    serviceDisabled => LocationIssue.serviceDisabled,
    granted || denied || unsupported => null,
  };
}

/// [LocationService.currentPosition] sonucu.
sealed class LocationResult {
  const LocationResult();
}

final class LocationFound extends LocationResult {
  const LocationFound(this.position);

  final DevicePosition position;
}

final class LocationFailed extends LocationResult {
  const LocationFailed(this.issue);

  final LocationIssue issue;
}

/// Cihaz konumu ve izin akışı.
///
/// İzin yalnızca kullanıcının açık bir eylemiyle istenir: konum butonu veya
/// tanıtımdaki/ayarlardaki "Konum iznini ver" (bağlamsal izin, OWASP
/// MASVS-PRIVACY). Implementasyonlar istisna fırlatmaz; hatalar
/// [LocationFailed] / [LocationAccess] olarak döner.
abstract interface class LocationService {
  /// `false` → platformda konum yoktur; konum butonu gösterilmez.
  bool get isSupported;

  /// İzin istemeden mevcut durumu okur.
  Future<LocationAccess> checkAccess();

  /// Gerekirse sistem izin penceresini açar; konum okumaz.
  Future<LocationAccess> requestAccess();

  /// Gerekirse izin ister ve tek bir konum okur.
  Future<LocationResult> currentPosition();

  /// İzin verildikten sonra konum değişimleri. Hata olursa akış sessizce
  /// kapanır.
  Stream<DevicePosition> positionUpdates();

  /// [issue] sistem ayarlarından çözülebiliyorsa `true` (web'de ayar
  /// sayfası açılamaz).
  bool canOpenSettings(LocationIssue issue);

  /// [issue] için ilgili sistem ayarlarını açar.
  Future<bool> openSettings(LocationIssue issue);
}
