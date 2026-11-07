import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/location/location_service.dart';
import 'package:vakif_atlas/core/notifications/local_notification_service.dart';
import 'package:vakif_atlas/core/observability/app_logger.dart';
import 'package:vakif_atlas/core/permissions/permission_service.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/geo_point.dart';
import 'package:vakif_atlas/features/nearby_alerts/domain/usecases/nearby_alert_usecases.dart';
import 'package:vakif_atlas/features/nearby_alerts/presentation/nearby_alert_notification.dart';

/// Yakındaki eser bildirimlerinin çalışma durumu.
enum NearbyAlertsStatus {
  /// Ayar kapalı.
  off,

  /// Konum izleniyor; yakın bir eserde bildirim gönderilir.
  active,

  /// Ayar açık ama bildirim izni yok (sistem ayarlarından kapatıldı).
  notificationsBlocked,

  /// Ayar açık ama konum izni / servisi yok.
  locationBlocked,

  /// Platformda yerel bildirim veya konum yok; ayar gösterilmez.
  unsupported,
}

/// Kullanıcı ayarı açtığında istenen izinlerin sonucu.
enum NearbyAlertsActivation {
  granted,
  notificationsDenied,
  locationDenied,
  unsupported,
}

/// Konum güncellemelerini izler ve yakındaki eser için yerel bildirim
/// gösterir.
///
/// Ayar `AppSettings.nearbyAlerts`'tedir; uygulama kökü ayara ve dile göre
/// [start] / [stop] çağırır. İzinler yalnızca kullanıcı ayarı açarken
/// istenir ([requestActivation]); [start] izin sormaz, yalnızca denetler.
@lazySingleton
class NearbyAlertsCubit extends Cubit<NearbyAlertsStatus> {
  NearbyAlertsCubit(
    this._location,
    this._notifications,
    this._findAlert,
    this._recordAlert,
    this._clearLog,
    this._logger,
  ) : super(NearbyAlertsStatus.off);

  final LocationService _location;
  final LocalNotificationService _notifications;
  final FindNearbyAlertUseCase _findAlert;
  final RecordNearbyAlertUseCase _recordAlert;
  final ClearNearbyAlertLogUseCase _clearLog;
  final AppLogger _logger;

  StreamSubscription<DevicePosition>? _updates;
  BackgroundTracking? _tracking;
  String _languageCode = 'tr';
  bool _includeImages = true;

  /// Değerlendirme sürerken gelen en son konum; değerlendirme bitince işlenir.
  DevicePosition? _pending;
  bool _evaluating = false;

  /// [start] çağrılarının sırası: eski bir çağrının izin sonucu yenisinin
  /// üstüne yazılmaz.
  int _generation = 0;

  bool get isSupported => _location.isSupported && _notifications.isSupported;

  /// Ayar açılırken bildirim, ardından konum izni istenir (bağlamsal izin).
  Future<NearbyAlertsActivation> requestActivation() async {
    if (!isSupported) {
      return NearbyAlertsActivation.unsupported;
    }
    final notifications = await _notifications.requestPermission();
    if (notifications != PermissionAccess.granted) {
      return notifications == PermissionAccess.unsupported
          ? NearbyAlertsActivation.unsupported
          : NearbyAlertsActivation.notificationsDenied;
    }
    final location = await _location.requestAccess();
    return location == LocationAccess.granted
        ? NearbyAlertsActivation.granted
        : NearbyAlertsActivation.locationDenied;
  }

  /// İzinler hâlâ veriliyse izlemeyi başlatır (veya dil / görsel tercihi
  /// değiştiyse günceller). İzin sormaz.
  Future<void> start({
    required String languageCode,
    required bool includeImages,
  }) async {
    final generation = ++_generation;
    _languageCode = languageCode;
    _includeImages = includeImages;
    if (!isSupported) {
      await _stopUpdates();
      _emit(NearbyAlertsStatus.unsupported);
      return;
    }
    final notifications = await _notifications.checkPermission();
    final location = await _location.checkAccess();
    if (generation != _generation || isClosed) {
      return;
    }
    if (notifications != PermissionAccess.granted) {
      await _stopUpdates();
      _emit(NearbyAlertsStatus.notificationsBlocked);
      return;
    }
    if (location != LocationAccess.granted) {
      await _stopUpdates();
      _emit(NearbyAlertsStatus.locationBlocked);
      return;
    }
    final tracking = NearbyAlertNotification.tracking(_l10n);
    if (_updates == null || tracking != _tracking) {
      await _stopUpdates();
      // Beklerken `stop` veya yeni bir `start` çağrıldıysa abone olunmaz.
      if (generation != _generation || isClosed) {
        return;
      }
      _tracking = tracking;
      _updates = _location
          .positionUpdates(background: tracking)
          .listen(
            _onPosition,
            // İzin geri alındı veya konum servisi kapandı.
            onDone: () {
              _updates = null;
              _tracking = null;
              if (!isClosed && state == NearbyAlertsStatus.active) {
                emit(NearbyAlertsStatus.locationBlocked);
              }
            },
          );
    }
    _emit(NearbyAlertsStatus.active);
  }

  /// İzlemeyi durdurur.
  Future<void> stop() async {
    _generation++;
    await _stopUpdates();
    _emit(NearbyAlertsStatus.off);
  }

  /// Bildirim geçmişini siler (kullanıcı özelliği kapattığında).
  Future<void> clearHistory() => _clearLog();

  /// [status] için ilgili sistem ayarlarını açar.
  Future<void> openSettings(NearbyAlertsStatus status) async {
    switch (status) {
      case NearbyAlertsStatus.notificationsBlocked:
        await _notifications.openSettings();
      case NearbyAlertsStatus.locationBlocked:
        final access = await _location.checkAccess();
        await _location.openSettings(
          access.settingsIssue ?? LocationIssue.permissionDenied,
        );
      case NearbyAlertsStatus.off ||
          NearbyAlertsStatus.active ||
          NearbyAlertsStatus.unsupported:
        break;
    }
  }

  /// Sistem ayarlarına gidilebilir mi (web ve masaüstünde hayır)?
  bool canOpenSettings(NearbyAlertsStatus status) => switch (status) {
    NearbyAlertsStatus.notificationsBlocked => true,
    NearbyAlertsStatus.locationBlocked => _location.canOpenSettings(
      LocationIssue.permissionDeniedForever,
    ),
    _ => false,
  };

  /// Bildirimler widget ağacı dışında (arka planda) üretilir; metinler
  /// uygulamanın etkin dilindendir.
  AppLocalizations get _l10n {
    final supported = AppLocalizations.supportedLocales.any(
      (locale) => locale.languageCode == _languageCode,
    );
    return lookupAppLocalizations(Locale(supported ? _languageCode : 'tr'));
  }

  void _onPosition(DevicePosition position) {
    if (_evaluating) {
      _pending = position;
      return;
    }
    unawaited(_evaluate(position));
  }

  Future<void> _evaluate(DevicePosition position) async {
    _evaluating = true;
    try {
      final now = DateTime.now();
      final check = await _findAlert(
        position: GeoPoint(
          latitude: position.latitude,
          longitude: position.longitude,
        ),
        accuracyMeters: position.accuracyMeters,
        languageCode: _languageCode,
        now: now,
      );
      // Yalnızca geliştirmede görünür (staging/prod seviyesi daha yüksek);
      // koordinat ve eser yazılmaz.
      _logger.debug(
        'nearby_alerts.check',
        context: {
          'accuracy_m': position.accuracyMeters.round(),
          'candidates': check.candidates,
          'result': check.skipped?.name ?? 'alert',
          if (check.alert case final alert?)
            'distance_m': alert.distanceMeters.round(),
        },
      );
      final alert = check.alert;
      if (alert == null || isClosed || state != NearbyAlertsStatus.active) {
        return;
      }
      // Önce kaydedilir: gösterim (görsel indirme) sürerken gelen konum
      // aynı eseri ikinci kez bildirmez.
      await _recordAlert(alert, now);
      await _notifications.show(
        NearbyAlertNotification.build(
          alert,
          _l10n,
          includeImage: _includeImages,
        ),
      );
    } finally {
      _evaluating = false;
      final next = _pending;
      _pending = null;
      if (next != null && _updates != null && !isClosed) {
        unawaited(_evaluate(next));
      }
    }
  }

  Future<void> _stopUpdates() async {
    final cancelled = _updates?.cancel();
    _updates = null;
    _tracking = null;
    _pending = null;
    await cancelled;
  }

  void _emit(NearbyAlertsStatus status) {
    if (!isClosed) {
      emit(status);
    }
  }

  @override
  Future<void> close() async {
    await _stopUpdates();
    return super.close();
  }
}
