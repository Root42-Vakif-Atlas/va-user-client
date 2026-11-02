import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/permissions/permission_service.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/features/settings/presentation/cubit/device_permissions_cubit.dart';
import 'package:vakif_atlas/features/settings/presentation/widgets/permission_card_layout.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';

/// Kamera, fotoğraf veya mikrofon izninin amacı, durumu ve tek dokunuşla
/// çözümü. `DevicePermissionsCubit` üst ağaçtan sağlanır; durum
/// [DevicePermissionsLifecycle] ile okunur.
class DevicePermissionCard extends StatelessWidget {
  const DevicePermissionCard({required this.permission, super.key});

  final AppPermission permission;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final cubit = context.read<DevicePermissionsCubit>();
    final state = context.watch<DevicePermissionsCubit>().state;
    final access = state.access[permission];
    final name = permission.name;

    final (
      IconData icon,
      String title,
      String purpose,
      String allow,
    ) = switch (permission) {
      AppPermission.camera => (
        Icons.photo_camera_outlined,
        l10n.permissionCameraTitle,
        l10n.permissionCameraPurpose,
        l10n.permissionCameraAllow,
      ),
      AppPermission.microphone => (
        Icons.mic_none,
        l10n.permissionMicrophoneTitle,
        l10n.permissionMicrophonePurpose,
        l10n.permissionMicrophoneAllow,
      ),
    };

    final (
      IconData statusIcon,
      Color statusColor,
      String statusText,
    ) = switch (access) {
      null => (
        Icons.hourglass_empty,
        colors.onSurfaceVariant,
        l10n.permissionStatusChecking,
      ),
      PermissionAccess.granted => (
        Icons.check_circle_outlined,
        colors.success,
        l10n.permissionStatusGranted,
      ),
      PermissionAccess.denied => (
        Icons.radio_button_unchecked,
        colors.onSurfaceVariant,
        l10n.permissionStatusNotGranted,
      ),
      PermissionAccess.deniedForever => (
        Icons.block,
        colors.warning,
        // Web'de uygulama ayarları açılamaz; tarayıcıdan nasıl verileceği
        // anlatılır.
        state.canOpenSettings
            ? l10n.permissionStatusBlocked
            : l10n.permissionStatusBlockedBrowser,
      ),
      PermissionAccess.unsupported => (
        Icons.do_not_disturb_on_outlined,
        colors.onSurfaceVariant,
        l10n.permissionStatusUnsupported,
      ),
    };

    final isBusy = state.busy == permission;
    final Widget? action = switch (access) {
      PermissionAccess.denied => AppButton.primary(
        key: Key('${name}_permission_request_button'),
        label: allow,
        icon: icon,
        isLoading: isBusy,
        expand: true,
        onPressed: () => unawaited(cubit.resolve(permission)),
      ),
      PermissionAccess.deniedForever when state.canOpenSettings =>
        AppButton.secondary(
          key: Key('${name}_permission_settings_button'),
          label: l10n.permissionOpenAppSettings,
          icon: Icons.open_in_new,
          isLoading: isBusy,
          expand: true,
          onPressed: () => unawaited(cubit.resolve(permission)),
        ),
      PermissionAccess.granted when state.canOpenSettings => AppButton.ghost(
        key: Key('${name}_permission_manage_button'),
        label: l10n.permissionManageInSettings,
        icon: Icons.open_in_new,
        expand: true,
        onPressed: () => unawaited(cubit.manageInSettings()),
      ),
      _ => null,
    };

    return PermissionCardLayout(
      key: Key('${name}_permission_card'),
      icon: icon,
      title: title,
      purpose: purpose,
      statusIcon: statusIcon,
      statusColor: statusColor,
      statusText: statusText,
      statusKey: Key('${name}_permission_status'),
      action: action,
    );
  }
}

/// İzin kartlarını içeren ekranın durumunu açılışta ve uygulamaya her
/// dönüşte (kullanıcı sistem ayarlarında izni değiştirmiş olabilir) okur.
class DevicePermissionsLifecycle extends StatefulWidget {
  const DevicePermissionsLifecycle({required this.child, super.key});

  final Widget child;

  @override
  State<DevicePermissionsLifecycle> createState() =>
      _DevicePermissionsLifecycleState();
}

class _DevicePermissionsLifecycleState
    extends State<DevicePermissionsLifecycle> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<DevicePermissionsCubit>();
    unawaited(cubit.refresh());
    _lifecycle = AppLifecycleListener(
      onResume: () => unawaited(cubit.refresh()),
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
