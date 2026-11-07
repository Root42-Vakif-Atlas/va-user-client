import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/location/location_service.dart';

/// `geolocator` ile konum. Linux'ta resmi implementasyon olmadığından
/// konum desteklenmez (ADR 2: platforma özel servisler NoOp'a düşer).
@LazySingleton(as: LocationService)
class GeolocatorLocationService implements LocationService {
  GeolocatorLocationService();

  /// Soğuk başlangıçta GPS kilidi için tanınan süre; aşılırsa son bilinen
  /// konum kullanılır.
  static const Duration fixTimeout = Duration(seconds: 15);

  /// Takipte bu mesafeden küçük hareketler bildirilmez (pil).
  static const int distanceFilterMeters = 10;

  @override
  bool get isSupported =>
      kIsWeb ||
      switch (defaultTargetPlatform) {
        TargetPlatform.android ||
        TargetPlatform.iOS ||
        TargetPlatform.macOS ||
        TargetPlatform.windows => true,
        TargetPlatform.linux || TargetPlatform.fuchsia => false,
      };

  @override
  Future<LocationAccess> checkAccess() => _access(request: false);

  @override
  Future<LocationAccess> requestAccess() => _access(request: true);

  Future<LocationAccess> _access({required bool request}) async {
    if (!isSupported) {
      return LocationAccess.unsupported;
    }
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return LocationAccess.serviceDisabled;
      }
      var permission = await Geolocator.checkPermission();
      if (request && permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      return switch (permission) {
        LocationPermission.denied => LocationAccess.denied,
        LocationPermission.deniedForever => LocationAccess.deniedForever,
        LocationPermission.whileInUse ||
        LocationPermission.always => LocationAccess.granted,
        LocationPermission.unableToDetermine => LocationAccess.unsupported,
      };
    } on Exception {
      return LocationAccess.unsupported;
    }
  }

  @override
  Future<LocationResult> currentPosition() async {
    if (!isSupported) {
      return const LocationFailed(LocationIssue.unavailable);
    }
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return const LocationFailed(LocationIssue.serviceDisabled);
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      switch (permission) {
        case LocationPermission.denied:
          return const LocationFailed(LocationIssue.permissionDenied);
        case LocationPermission.deniedForever:
          return const LocationFailed(LocationIssue.permissionDeniedForever);
        case LocationPermission.whileInUse ||
            LocationPermission.always ||
            LocationPermission.unableToDetermine:
          break;
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(timeLimit: fixTimeout),
      );
      return LocationFound(_toDevicePosition(position));
    } on LocationServiceDisabledException {
      return const LocationFailed(LocationIssue.serviceDisabled);
    } on PermissionDeniedException {
      return const LocationFailed(LocationIssue.permissionDenied);
    } on TimeoutException {
      return _lastKnown();
    } on Exception {
      return const LocationFailed(LocationIssue.unavailable);
    }
  }

  Future<LocationResult> _lastKnown() async {
    try {
      final position = kIsWeb ? null : await Geolocator.getLastKnownPosition();
      return position == null
          ? const LocationFailed(LocationIssue.unavailable)
          : LocationFound(_toDevicePosition(position));
    } on Exception {
      return const LocationFailed(LocationIssue.unavailable);
    }
  }

  /// Arka plan takibinde bu mesafeden küçük hareketler bildirilmez. Yürüyüş
  /// hızında ~20 saniyede bir konum: yakınlık uyarısı için yeterli, pil
  /// için ölçülü.
  static const int backgroundDistanceFilterMeters = 25;

  /// Android'de arka plan takibinin en sık konum aralığı.
  static const Duration backgroundInterval = Duration(seconds: 10);

  /// Android ön plan servisi bildiriminin tek renkli simgesi
  /// (`res/drawable/ic_stat_vakif_atlas.xml`; R8'den `res/raw/keep.xml`
  /// ile korunur).
  static const String notificationIconName = 'ic_stat_vakif_atlas';

  /// Eklenti tek bir konum akışı tutar ve sonraki çağrılarda ayarları yok
  /// sayıp aynı akışı döndürür. Bu yüzden tüm dinleyiciler tek kaynak
  /// aboneliğini paylaşır; bir dinleyici arka plan isterse kaynak arka plan
  /// ayarlarıyla yeniden başlatılır.
  final Map<StreamController<DevicePosition>, BackgroundTracking?> _listeners =
      {};
  StreamSubscription<Position>? _source;
  BackgroundTracking? _sourceTracking;

  @override
  Stream<DevicePosition> positionUpdates({BackgroundTracking? background}) {
    if (!isSupported) {
      return const Stream.empty();
    }
    late final StreamController<DevicePosition> controller;
    controller = StreamController<DevicePosition>(
      onListen: () {
        _listeners[controller] = background;
        _reconcileSource();
      },
      onCancel: () {
        _listeners.remove(controller);
        _reconcileSource();
      },
    );
    return controller.stream;
  }

  /// Sürekli takip ayarları olan platformlar. macOS'ta "arka plan" kavramı
  /// yoktur (pencere açık kaldıkça uygulama çalışır); takip ayarı yine de
  /// uygulanır (bkz. [_settings]).
  bool get _supportsBackground =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS);

  void _reconcileSource() {
    if (_listeners.isEmpty) {
      _stopSource();
      return;
    }
    final wanted = _supportsBackground
        ? _listeners.values.nonNulls.firstOrNull
        : null;
    if (_source != null && wanted == _sourceTracking) {
      return;
    }
    _stopSource();
    _sourceTracking = wanted;
    _source = Geolocator.getPositionStream(locationSettings: _settings(wanted))
        .listen(
          (position) {
            final devicePosition = _toDevicePosition(position);
            for (final listener in [..._listeners.keys]) {
              listener.add(devicePosition);
            }
          },
          // İzin geri alındı veya servis kapandı: dinleyicilerin akışı
          // kapanır (önceki davranış).
          onError: (Object _) => _closeAll(),
          onDone: _closeAll,
          cancelOnError: true,
        );
  }

  void _stopSource() {
    final cancelled = _source?.cancel();
    _source = null;
    _sourceTracking = null;
    if (cancelled != null) {
      unawaited(cancelled);
    }
  }

  void _closeAll() {
    final listeners = [..._listeners.keys];
    _listeners.clear();
    _source = null;
    _sourceTracking = null;
    for (final listener in listeners) {
      unawaited(listener.close());
    }
  }

  static LocationSettings _settings(BackgroundTracking? background) {
    if (background == null) {
      return const LocationSettings(distanceFilter: distanceFilterMeters);
    }
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: backgroundDistanceFilterMeters,
        intervalDuration: backgroundInterval,
        foregroundNotificationConfig: ForegroundNotificationConfig(
          notificationTitle: background.title,
          notificationText: background.text,
          notificationChannelName: background.channelName,
          notificationIcon: const AndroidResource(name: notificationIconName),
          setOngoing: true,
        ),
      ),
      // Duraklatma kapalı: iOS duraklatılan güncellemeleri arka planda
      // kendiliğinden sürdürmez (yürüyüşte mola sonrası uyarı kaçardı).
      TargetPlatform.iOS => AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: backgroundDistanceFilterMeters,
        pauseLocationUpdatesAutomatically: false,
        showBackgroundLocationIndicator: true,
        allowBackgroundLocationUpdates: true,
      ),
      // Masaüstü sabit durur ve konum Wi-Fi'den gelir: doğruluk zamanla
      // iyileşir ama konum pek değişmez. Mesafe filtresi bu iyileşmeleri
      // yuttuğundan kapalıdır (güç sorunu yok).
      TargetPlatform.macOS => AppleSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 0,
        pauseLocationUpdatesAutomatically: false,
        allowBackgroundLocationUpdates: false,
      ),
      _ => const LocationSettings(distanceFilter: distanceFilterMeters),
    };
  }

  @override
  bool canOpenSettings(LocationIssue issue) =>
      isSupported && !kIsWeb && issue != LocationIssue.unavailable;

  @override
  Future<bool> openSettings(LocationIssue issue) async {
    if (!canOpenSettings(issue)) {
      return false;
    }
    try {
      return switch (issue) {
        LocationIssue.serviceDisabled =>
          await Geolocator.openLocationSettings(),
        LocationIssue.permissionDenied ||
        LocationIssue.permissionDeniedForever =>
          await Geolocator.openAppSettings(),
        LocationIssue.unavailable => false,
      };
    } on Exception {
      return false;
    }
  }

  static DevicePosition _toDevicePosition(Position position) => DevicePosition(
    latitude: position.latitude,
    longitude: position.longitude,
    accuracyMeters: position.accuracy,
  );
}
