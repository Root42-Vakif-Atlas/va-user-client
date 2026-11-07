import 'package:vakif_atlas/features/catalog/domain/entities/geo_point.dart';
import 'package:vakif_atlas/features/nearby_alerts/domain/entities/nearby_alert.dart';
import 'package:vakif_atlas/features/nearby_alerts/domain/entities/nearby_alert_policy.dart';
import 'package:vakif_atlas/features/nearby_alerts/domain/repositories/nearby_alerts_repositories.dart';

/// Bildirim gönderilmeme nedeni (geliştirme tanısı).
enum NearbyAlertSkip {
  /// Konum doğruluğu [NearbyAlertPolicy.maxAccuracyMeters]'den kötü.
  inaccurate,

  /// En kısa aralık veya günlük üst sınır dolu.
  rateLimited,

  /// Çevredeki eserler alınamadı (ağ / sunucu); sonraki konumda denenir.
  catalogUnavailable,

  /// Yarıçap içinde (bekleme süresinde olmayan) eser yok.
  noneNearby,
}

/// Bir konum değerlendirmesinin sonucu: bildirilecek eser veya neden
/// bildirilmediği.
final class NearbyAlertCheck {
  const NearbyAlertCheck.alert(
    NearbyAlert this.alert, {
    required this.candidates,
  }) : skipped = null;

  const NearbyAlertCheck.skipped(
    NearbyAlertSkip this.skipped, {
    this.candidates = 0,
  }) : alert = null;

  final NearbyAlert? alert;
  final NearbyAlertSkip? skipped;

  /// Sorgulanan bölgedeki eser sayısı.
  final int candidates;
}

/// Konuma göre bildirilecek eseri bulur; bildirilecek eser yoksa nedenini
/// döner (eserler alınamadıysa bir sonraki konumda yeniden denenir).
class FindNearbyAlertUseCase {
  const FindNearbyAlertUseCase(this._monuments, this._log, this._policy);

  final NearbyMonumentsRepository _monuments;
  final NearbyAlertLogRepository _log;
  final NearbyAlertPolicy _policy;

  Future<NearbyAlertCheck> call({
    required GeoPoint position,
    required double accuracyMeters,
    required String languageCode,
    required DateTime now,
  }) async {
    final log = _log.load();
    if (!accuracyMeters.isFinite ||
        accuracyMeters > _policy.maxAccuracyMeters) {
      return const NearbyAlertCheck.skipped(NearbyAlertSkip.inaccurate);
    }
    // Sıklık sınırı doluysa ağ isteği yapılmaz.
    if (!_policy.mayAlert(accuracyMeters: accuracyMeters, log: log, now: now)) {
      return const NearbyAlertCheck.skipped(NearbyAlertSkip.rateLimited);
    }
    final result = await _monuments.monumentsAround(
      position,
      radiusMeters: _policy.triggerRadiusMeters,
      languageCode: languageCode,
    );
    return result.fold(
      (_) => const NearbyAlertCheck.skipped(NearbyAlertSkip.catalogUnavailable),
      (candidates) {
        final alert = _policy.select(
          position: position,
          accuracyMeters: accuracyMeters,
          candidates: candidates,
          log: log,
          now: now,
        );
        return alert == null
            ? NearbyAlertCheck.skipped(
                NearbyAlertSkip.noneNearby,
                candidates: candidates.length,
              )
            : NearbyAlertCheck.alert(alert, candidates: candidates.length);
      },
    );
  }
}

/// Gösterilen bildirimi kaydeder; süresi geçen kayıtlar atılır.
class RecordNearbyAlertUseCase {
  const RecordNearbyAlertUseCase(this._log, this._policy);

  final NearbyAlertLogRepository _log;
  final NearbyAlertPolicy _policy;

  Future<void> call(NearbyAlert alert, DateTime at) => _log.save(
    _log
        .load()
        .record(alert.monument, at)
        .prune(at.subtract(_policy.retention)),
  );
}

/// Bildirim geçmişini siler (özellik kapatılınca).
class ClearNearbyAlertLogUseCase {
  const ClearNearbyAlertLogUseCase(this._log);

  final NearbyAlertLogRepository _log;

  Future<void> call() => _log.clear();
}
