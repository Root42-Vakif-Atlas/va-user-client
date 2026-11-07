import 'dart:async';

import 'package:vakif_atlas/core/location/location_service.dart';

/// Platform kanalı gerektirmeyen, senaryoya göre yanıt veren konum servisi.
class FakeLocationService implements LocationService {
  FakeLocationService({
    this.isSupported = true,
    this.result = const LocationFailed(LocationIssue.permissionDenied),
    this.settingsAvailable = true,
    this.access = LocationAccess.denied,
    this.accessAfterRequest = LocationAccess.granted,
  });

  @override
  final bool isSupported;

  /// [currentPosition] çağrılarının sonucu.
  LocationResult result;
  bool settingsAvailable;

  /// [checkAccess] sonucu; [requestAccess] `denied` iken
  /// [accessAfterRequest] değerine geçer (kullanıcının sistem penceresindeki
  /// yanıtı).
  LocationAccess access;
  LocationAccess accessAfterRequest;

  int currentPositionCalls = 0;
  int requestAccessCalls = 0;
  final List<LocationIssue> openedSettings = [];

  /// Konum akışına test içinden değer basmak için.
  final StreamController<DevicePosition> updates =
      StreamController<DevicePosition>.broadcast();

  bool get hasListeners => updates.hasListener;

  Future<void> dispose() => updates.close();

  @override
  Future<LocationAccess> checkAccess() async => access;

  @override
  Future<LocationAccess> requestAccess() async {
    requestAccessCalls++;
    if (access == LocationAccess.denied) {
      access = accessAfterRequest;
    }
    return access;
  }

  @override
  Future<LocationResult> currentPosition() async {
    currentPositionCalls++;
    return result;
  }

  /// Son [positionUpdates] çağrısında istenen arka plan takibi.
  BackgroundTracking? lastBackground;

  @override
  Stream<DevicePosition> positionUpdates({BackgroundTracking? background}) {
    lastBackground = background;
    return updates.stream;
  }

  @override
  bool canOpenSettings(LocationIssue issue) =>
      settingsAvailable && issue != LocationIssue.unavailable;

  @override
  Future<bool> openSettings(LocationIssue issue) async {
    openedSettings.add(issue);
    return true;
  }
}

/// İstanbul, Sultanahmet civarı.
const DevicePosition testIstanbulPosition = DevicePosition(
  latitude: 41.0086,
  longitude: 28.9802,
  accuracyMeters: 25,
);

/// Harita bölgesi dışında (Berlin).
const DevicePosition testOutsidePosition = DevicePosition(
  latitude: 52.52,
  longitude: 13.405,
  accuracyMeters: 30,
);
