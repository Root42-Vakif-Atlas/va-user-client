import 'package:vakif_atlas/features/catalog/domain/entities/geo_point.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_summary.dart';
import 'package:vakif_atlas/features/nearby_alerts/domain/entities/nearby_alert.dart';
import 'package:vakif_atlas/features/nearby_alerts/domain/entities/nearby_alert_log.dart';

/// Ne zaman ve hangi eser için bildirim gönderileceği.
///
/// Bildirim yalnızca değerli ve zamanında olduğunda gönderilir:
/// - Eser [triggerRadiusMeters] içinde olmalı (yürüyerek "yanından
///   geçiyorum" mesafesi) ve konum yeterince doğru olmalı.
/// - Aynı eser [monumentCooldown] içinde tekrar bildirilmez; bir külliyenin
///   bir yapısı bildirildiyse diğer yapıları da (külliyede her binada
///   bildirim yağmaz).
/// - İki bildirim arasında en az [minInterval] olur ve
///   [maxAlertsPerDay] aşılmaz (yoğun tarihi merkezlerde bildirim yorgunluğu).
/// - Birden çok aday varsa en yakını seçilir.
final class NearbyAlertPolicy {
  const NearbyAlertPolicy({
    this.triggerRadiusMeters = 250,
    this.maxAccuracyMeters = 250,
    this.monumentCooldown = const Duration(hours: 24),
    this.minInterval = const Duration(minutes: 5),
    this.maxAlertsPerDay = 10,
  });

  /// Yürüyerek ~3 dakika: eser görüş alanındayken veya bir sokak ötedeyken
  /// haber verilir (kullanıcı yönünü değiştirip gidebilir).
  final double triggerRadiusMeters;

  /// Bu değerden kötü doğruluktaki konumlar yok sayılır (yanlış uyarı).
  ///
  /// Telefonda GPS 5 – 30 m verir; masaüstü (macOS) ve kapalı alanda konum
  /// Wi-Fi'den gelir ve 65 – 250 m olur. Eşik 100 m olsaydı masaüstünde hiç
  /// bildirim gelmezdi. Tahmini mesafe yine [triggerRadiusMeters] içinde
  /// olmalıdır; düşük doğrulukta bildirim kesin mesafe göstermez.
  final double maxAccuracyMeters;
  final Duration monumentCooldown;
  final Duration minInterval;
  final int maxAlertsPerDay;

  static const Duration _day = Duration(hours: 24);

  /// Kayıtların tutulacağı en uzun süre.
  Duration get retention => monumentCooldown > _day ? monumentCooldown : _day;

  /// Aday aramaya (ağ isteğine) değer mi? Konum doğruluğu ve sıklık
  /// sınırları eserlerden bağımsızdır.
  bool mayAlert({
    required double accuracyMeters,
    required NearbyAlertLog log,
    required DateTime now,
  }) {
    if (!accuracyMeters.isFinite || accuracyMeters > maxAccuracyMeters) {
      return false;
    }
    final last = log.lastAlertAt;
    if (last != null && now.difference(last) < minInterval) {
      return false;
    }
    return log.alertsSince(now.subtract(_day)) < maxAlertsPerDay;
  }

  /// Bildirilecek en yakın eser; yoksa `null`.
  NearbyAlert? select({
    required GeoPoint position,
    required double accuracyMeters,
    required Iterable<MonumentSummary> candidates,
    required NearbyAlertLog log,
    required DateTime now,
  }) {
    if (!mayAlert(accuracyMeters: accuracyMeters, log: log, now: now)) {
      return null;
    }
    final cooldownStart = now.subtract(monumentCooldown);
    NearbyAlert? nearest;
    for (final monument in candidates) {
      final location = monument.location;
      if (location == null ||
          !location.isValid ||
          monument.isComplex ||
          log.covers(monument, cooldownStart)) {
        continue;
      }
      final distance = position.distanceTo(location);
      if (distance <= triggerRadiusMeters &&
          (nearest == null || distance < nearest.distanceMeters)) {
        nearest = NearbyAlert(
          monument: monument,
          distanceMeters: distance,
          accuracyMeters: accuracyMeters,
        );
      }
    }
    return nearest;
  }
}
