import 'dart:async';

import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/notifications/local_notification_service.dart';
import 'package:vakif_atlas/core/observability/app_logger.dart';
import 'package:vakif_atlas/core/permissions/permission_service.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/geo_point.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_summary.dart';
import 'package:vakif_atlas/features/nearby_alerts/domain/entities/nearby_alert_log.dart';
import 'package:vakif_atlas/features/nearby_alerts/domain/entities/nearby_alert_policy.dart';
import 'package:vakif_atlas/features/nearby_alerts/domain/repositories/nearby_alerts_repositories.dart';
import 'package:vakif_atlas/features/nearby_alerts/domain/usecases/nearby_alert_usecases.dart';
import 'package:vakif_atlas/features/nearby_alerts/presentation/cubit/nearby_alerts_cubit.dart';

import 'location_test_utils.dart';
import 'test_config.dart';

/// Platform kanalı gerektirmeyen yerel bildirim servisi; gösterilen
/// bildirimler [shown] listesine yazılır.
class FakeLocalNotificationService implements LocalNotificationService {
  FakeLocalNotificationService({
    this.isSupported = true,
    this.access = PermissionAccess.denied,
    this.accessAfterRequest = PermissionAccess.granted,
    this.launchPayload,
  });

  @override
  final bool isSupported;

  /// [checkPermission] sonucu; [requestPermission] `denied` iken
  /// [accessAfterRequest] değerine geçer.
  PermissionAccess access;
  PermissionAccess accessAfterRequest;
  String? launchPayload;

  final List<AppNotification> shown = [];
  int requestCalls = 0;
  int settingsOpened = 0;
  final StreamController<String> tapController =
      StreamController<String>.broadcast();

  Future<void> dispose() => tapController.close();

  @override
  Future<void> initialize() async {}

  @override
  Future<PermissionAccess> checkPermission() async => access;

  @override
  Future<PermissionAccess> requestPermission() async {
    requestCalls++;
    if (access == PermissionAccess.denied) {
      access = accessAfterRequest;
    }
    return access;
  }

  @override
  Future<bool> openSettings() async {
    settingsOpened++;
    return true;
  }

  @override
  Future<void> show(AppNotification notification) async {
    shown.add(notification);
  }

  @override
  Stream<String> get taps => tapController.stream;

  @override
  Future<String?> takeLaunchPayload() async {
    final payload = launchPayload;
    launchPayload = null;
    return payload;
  }
}

/// Sabit eser listesi döndüren (veya başarısız olan) çevre sorgusu.
class FakeNearbyMonumentsRepository implements NearbyMonumentsRepository {
  FakeNearbyMonumentsRepository([this.monuments = const []]);

  List<MonumentSummary> monuments;
  Failure? failure;
  final List<GeoPoint> queries = [];

  @override
  ResultFuture<List<MonumentSummary>> monumentsAround(
    GeoPoint point, {
    required double radiusMeters,
    required String languageCode,
  }) async {
    queries.add(point);
    final error = failure;
    return error == null ? Right(monuments) : Left(error);
  }
}

class InMemoryNearbyAlertLogRepository implements NearbyAlertLogRepository {
  NearbyAlertLog log = NearbyAlertLog.empty;
  int clears = 0;

  @override
  NearbyAlertLog load() => log;

  @override
  Future<void> save(NearbyAlertLog log) async => this.log = log;

  @override
  Future<void> clear() async {
    clears++;
    log = NearbyAlertLog.empty;
  }
}

/// Fake servislerle kurulmuş [NearbyAlertsCubit].
NearbyAlertsCubit testNearbyAlertsCubit({
  FakeLocationService? location,
  FakeLocalNotificationService? notifications,
  FakeNearbyMonumentsRepository? monuments,
  InMemoryNearbyAlertLogRepository? log,
  NearbyAlertPolicy policy = const NearbyAlertPolicy(),
}) {
  final alertLog = log ?? InMemoryNearbyAlertLogRepository();
  return NearbyAlertsCubit(
    location ?? FakeLocationService(),
    notifications ?? FakeLocalNotificationService(),
    FindNearbyAlertUseCase(
      monuments ?? FakeNearbyMonumentsRepository(),
      alertLog,
      policy,
    ),
    RecordNearbyAlertUseCase(alertLog, policy),
    ClearNearbyAlertLogUseCase(alertLog),
    AppLogger(testAppConfig()),
  );
}
