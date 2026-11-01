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

  @override
  Stream<DevicePosition> positionUpdates() {
    if (!isSupported) {
      return const Stream.empty();
    }
    return Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            distanceFilter: distanceFilterMeters,
          ),
        )
        .map(_toDevicePosition)
        .transform(
          StreamTransformer.fromHandlers(
            handleError: (_, _, sink) => sink.close(),
          ),
        );
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
