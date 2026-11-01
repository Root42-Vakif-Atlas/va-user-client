import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/permissions/permission_service.dart';

part 'device_permissions_cubit.freezed.dart';

@freezed
abstract class DevicePermissionsState with _$DevicePermissionsState {
  const factory DevicePermissionsState({
    /// Okunmamış izinler haritada yoktur.
    @Default(<AppPermission, PermissionAccess>{})
    Map<AppPermission, PermissionAccess> access,

    /// Sistem penceresi veya ayarlar açıkken ilgili izin.
    AppPermission? busy,

    /// Kalıcı ret sistem ayarlarından çözülebiliyorsa `true` (web'de hayır).
    @Default(false) bool canOpenSettings,
  }) = _DevicePermissionsState;
}

/// Tanıtımdaki ve ayarlardaki kamera, fotoğraf ve mikrofon kartlarının
/// durumu (ekran bazlı).
///
/// İzin yalnızca kullanıcı ilgili karttaki butona bastığında istenir. Kalıcı
/// retlerde uygulama ayarları açılır; uygulamaya dönülünce durum yeniden
/// okunur ([refresh]).
@injectable
class DevicePermissionsCubit extends Cubit<DevicePermissionsState> {
  DevicePermissionsCubit(this._permissions)
    : super(
        DevicePermissionsState(
          canOpenSettings: _permissions.canOpenAppSettings,
        ),
      );

  final PermissionService _permissions;

  Future<void> refresh() async {
    final access = {
      for (final permission in AppPermission.values)
        permission: await _permissions.check(permission),
    };
    if (!isClosed) {
      emit(state.copyWith(access: access));
    }
  }

  /// İzni ister veya kalıcı retti ise uygulama ayarlarını açar.
  Future<void> resolve(AppPermission permission) async {
    final current = state.access[permission];
    if (state.busy != null || current == null) {
      return;
    }
    emit(state.copyWith(busy: permission));
    if (current == PermissionAccess.deniedForever) {
      await _permissions.openAppSettings();
      if (!isClosed) {
        emit(state.copyWith(busy: null));
      }
      return;
    }
    final next = await _permissions.request(permission);
    if (!isClosed) {
      emit(
        state.copyWith(access: {...state.access, permission: next}, busy: null),
      );
    }
  }

  /// İzni geri almak için uygulama ayarlarını açar.
  Future<void> manageInSettings() => _permissions.openAppSettings();
}
