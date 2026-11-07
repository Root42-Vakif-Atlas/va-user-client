import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/features/nearby_alerts/domain/entities/nearby_alert_policy.dart';
import 'package:vakif_atlas/features/nearby_alerts/domain/repositories/nearby_alerts_repositories.dart';
import 'package:vakif_atlas/features/nearby_alerts/domain/usecases/nearby_alert_usecases.dart';

/// Domain sınıfları DI anotasyonu taşımadığından kayıtları burada yapılır.
@module
abstract class NearbyAlertsModule {
  @lazySingleton
  NearbyAlertPolicy get nearbyAlertPolicy => const NearbyAlertPolicy();

  @lazySingleton
  FindNearbyAlertUseCase findNearbyAlertUseCase(
    NearbyMonumentsRepository monuments,
    NearbyAlertLogRepository log,
    NearbyAlertPolicy policy,
  ) => FindNearbyAlertUseCase(monuments, log, policy);

  @lazySingleton
  RecordNearbyAlertUseCase recordNearbyAlertUseCase(
    NearbyAlertLogRepository log,
    NearbyAlertPolicy policy,
  ) => RecordNearbyAlertUseCase(log, policy);

  @lazySingleton
  ClearNearbyAlertLogUseCase clearNearbyAlertLogUseCase(
    NearbyAlertLogRepository log,
  ) => ClearNearbyAlertLogUseCase(log);
}
