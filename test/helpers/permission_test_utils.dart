import 'package:vakif_atlas/core/permissions/permission_service.dart';

/// Durumları elle ayarlanan sahte izin servisi.
///
/// [request] çağrıldığında [requestResults]'taki sonuç (yoksa mevcut durum)
/// döner ve kalıcı olur.
class FakePermissionService implements PermissionService {
  FakePermissionService({
    Map<AppPermission, PermissionAccess>? access,
    this.canOpenAppSettings = true,
  }) : access = {
         AppPermission.camera: PermissionAccess.granted,
         AppPermission.microphone: PermissionAccess.granted,
         ...?access,
       };

  final Map<AppPermission, PermissionAccess> access;
  final Map<AppPermission, PermissionAccess> requestResults = {};
  final List<AppPermission> requested = [];
  int settingsOpened = 0;

  @override
  final bool canOpenAppSettings;

  @override
  Future<PermissionAccess> check(AppPermission permission) async =>
      access[permission]!;

  @override
  Future<PermissionAccess> request(AppPermission permission) async {
    requested.add(permission);
    final result = requestResults[permission] ?? access[permission]!;
    access[permission] = result;
    return result;
  }

  @override
  Future<bool> openAppSettings() async {
    settingsOpened++;
    return canOpenAppSettings;
  }
}
