import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart' as handler;
import 'package:vakif_atlas/core/permissions/permission_service.dart';

/// `permission_handler` ile izinler.
///
/// | İzin | Android / iOS | Web | Masaüstü |
/// |:--|:--|:--|:--|
/// | Kamera | sistem izni | tarayıcı izni (uygulama içi kamera) | yok |
/// | Fotoğraflar | gerekmez (sistem seçicisi) | gerekmez | gerekmez |
/// | Mikrofon | sistem izni (+ iOS konuşma tanıma) | tarayıcı izni | yok |
///
/// Tam fotoğraf arşivi izni (iOS fotoğraf arşivi, Android
/// `READ_MEDIA_IMAGES`) bilinçli olarak istenmez: sistem seçicisi yalnızca
/// kullanıcının seçtiği fotoğrafları verir (KVKK veri minimizasyonu, Google
/// Play fotoğraf/video izinleri politikası).
@LazySingleton(as: PermissionService)
class PermissionHandlerService implements PermissionService {
  bool get _isMobile =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  bool get _isIos => !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  /// Bu platformda sistem izni gereken izinler; boşsa durum sabittir.
  List<handler.Permission> _systemPermissions(AppPermission permission) =>
      switch (permission) {
        AppPermission.camera when _isMobile || kIsWeb => [
          handler.Permission.camera,
        ],
        AppPermission.microphone when _isIos => [
          handler.Permission.microphone,
          handler.Permission.speech,
        ],
        AppPermission.microphone when _isMobile || kIsWeb => [
          handler.Permission.microphone,
        ],
        _ => const [],
      };

  PermissionAccess _fixedAccess(AppPermission permission) =>
      PermissionAccess.unsupported;

  @override
  Future<PermissionAccess> check(AppPermission permission) async {
    final system = _systemPermissions(permission);
    if (system.isEmpty) {
      return _fixedAccess(permission);
    }
    try {
      final statuses = [for (final p in system) await p.status];
      return _combine(statuses);
    } on Object {
      // Bazı tarayıcılar Permissions API'de kamera/mikrofon sorgusunu
      // desteklemez; istek yine yapılabilir.
      return kIsWeb ? PermissionAccess.denied : PermissionAccess.unsupported;
    }
  }

  @override
  Future<PermissionAccess> request(AppPermission permission) async {
    final system = _systemPermissions(permission);
    if (system.isEmpty) {
      return _fixedAccess(permission);
    }
    try {
      final statuses = await system.request();
      return _combine([for (final p in system) ?statuses[p]]);
    } on Object {
      return PermissionAccess.unsupported;
    }
  }

  @override
  bool get canOpenAppSettings => _isMobile;

  @override
  Future<bool> openAppSettings() async {
    if (!canOpenAppSettings) {
      return false;
    }
    try {
      return await handler.openAppSettings();
    } on Object {
      return false;
    }
  }

  static PermissionAccess _combine(List<handler.PermissionStatus> statuses) {
    if (statuses.isEmpty) {
      return PermissionAccess.unsupported;
    }
    final mapped = statuses.map(_map).toList();
    if (mapped.contains(PermissionAccess.deniedForever)) {
      return PermissionAccess.deniedForever;
    }
    if (mapped.every((access) => access == PermissionAccess.granted)) {
      return PermissionAccess.granted;
    }
    return PermissionAccess.denied;
  }

  static PermissionAccess _map(handler.PermissionStatus status) =>
      switch (status) {
        handler.PermissionStatus.granted ||
        handler.PermissionStatus.limited ||
        handler.PermissionStatus.provisional => PermissionAccess.granted,
        handler.PermissionStatus.denied => PermissionAccess.denied,
        handler.PermissionStatus.permanentlyDenied ||
        handler.PermissionStatus.restricted => PermissionAccess.deniedForever,
      };
}
