import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/geo_point.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_summary.dart';
import 'package:vakif_atlas/features/nearby_alerts/domain/entities/nearby_alert_log.dart';

/// Bir noktanın çevresindeki eserler.
///
/// Kesin konum sunucuya gönderilmez: istek, noktayı içeren sabit bir ızgara
/// hücresi (+ [radiusMeters] payı) için yapılır ve hücre önbelleğe alınır.
/// Dönen liste [radiusMeters]'den uzaktaki eserleri de içerebilir.
abstract interface class NearbyMonumentsRepository {
  ResultFuture<List<MonumentSummary>> monumentsAround(
    GeoPoint point, {
    required double radiusMeters,
    required String languageCode,
  });
}

/// Gönderilen yakınlık bildirimlerinin cihazdaki kaydı. Kayıt bir
/// hızlandırıcıdır; okunamaması / yazılamaması bildirimi engellemez.
abstract interface class NearbyAlertLogRepository {
  NearbyAlertLog load();

  Future<void> save(NearbyAlertLog log);

  /// Özellik kapatılınca geçmiş silinir (hangi eserlerin yanından geçildiği
  /// kişisel veridir).
  Future<void> clear();
}
