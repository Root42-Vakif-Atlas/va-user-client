import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/exceptions.dart';
import 'package:vakif_atlas/core/storage/preferences_service.dart';
import 'package:vakif_atlas/features/nearby_alerts/domain/entities/nearby_alert_log.dart';
import 'package:vakif_atlas/features/nearby_alerts/domain/repositories/nearby_alerts_repositories.dart';

/// Kayıt yalnızca cihazdadır (`SharedPreferences`); sunucuya gönderilmez.
@LazySingleton(as: NearbyAlertLogRepository)
class NearbyAlertLogRepositoryImpl implements NearbyAlertLogRepository {
  NearbyAlertLogRepositoryImpl(this._preferences);

  final PreferencesService _preferences;

  @override
  NearbyAlertLog load() => NearbyAlertLog({
    for (final MapEntry(:key, :value) in _preferences.nearbyAlertLog.entries)
      key: DateTime.fromMillisecondsSinceEpoch(value),
  });

  @override
  Future<void> save(NearbyAlertLog log) async {
    try {
      await _preferences.setNearbyAlertLog({
        for (final MapEntry(:key, :value) in log.entries.entries)
          key: value.millisecondsSinceEpoch,
      });
    } on CacheException {
      // Kaydedilemezse en kötü ihtimalle aynı eser yeniden bildirilir.
    }
  }

  @override
  Future<void> clear() => save(NearbyAlertLog.empty);
}
