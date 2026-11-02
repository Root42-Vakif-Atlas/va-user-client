import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/location/location_service.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/features/settings/presentation/cubit/location_permission_cubit.dart';
import 'package:vakif_atlas/features/settings/presentation/widgets/permission_card_layout.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';

/// Konum izninin amacı, durumu ve tek dokunuşla çözümü.
///
/// `LocationPermissionCubit` üst ağaçtan sağlanır.
class LocationPermissionCard extends StatefulWidget {
  const LocationPermissionCard({super.key});

  @override
  State<LocationPermissionCard> createState() => _LocationPermissionCardState();
}

class _LocationPermissionCardState extends State<LocationPermissionCard> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<LocationPermissionCubit>();
    unawaited(cubit.refresh());
    // Kullanıcı sistem ayarlarında izni değiştirip geri dönebilir.
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
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final cubit = context.read<LocationPermissionCubit>();
    final state = context.watch<LocationPermissionCubit>().state;
    final access = state.access;

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
      LocationAccess.granted => (
        Icons.check_circle_outlined,
        colors.success,
        l10n.permissionStatusGranted,
      ),
      LocationAccess.denied => (
        Icons.radio_button_unchecked,
        colors.onSurfaceVariant,
        l10n.permissionStatusNotGranted,
      ),
      LocationAccess.deniedForever => (
        Icons.block,
        colors.warning,
        l10n.permissionStatusBlocked,
      ),
      LocationAccess.serviceDisabled => (
        Icons.location_disabled,
        colors.warning,
        l10n.permissionStatusServiceDisabled,
      ),
      LocationAccess.unsupported => (
        Icons.do_not_disturb_on_outlined,
        colors.onSurfaceVariant,
        l10n.permissionStatusUnsupported,
      ),
    };

    final Widget? action = switch (access) {
      LocationAccess.denied => AppButton.primary(
        key: const Key('location_permission_request_button'),
        label: l10n.permissionLocationAllow,
        icon: Icons.my_location,
        isLoading: state.isBusy,
        expand: true,
        onPressed: cubit.resolve,
      ),
      LocationAccess.deniedForever || LocationAccess.serviceDisabled
          when state.canOpenSettings =>
        AppButton.secondary(
          key: const Key('location_permission_settings_button'),
          label: access == LocationAccess.serviceDisabled
              ? l10n.permissionOpenLocationSettings
              : l10n.permissionOpenAppSettings,
          icon: Icons.open_in_new,
          isLoading: state.isBusy,
          expand: true,
          onPressed: cubit.resolve,
        ),
      LocationAccess.granted when cubit.canManageInSettings => AppButton.ghost(
        key: const Key('location_permission_manage_button'),
        label: l10n.permissionManageInSettings,
        icon: Icons.open_in_new,
        expand: true,
        onPressed: cubit.manageInSettings,
      ),
      _ => null,
    };

    return PermissionCardLayout(
      icon: Icons.location_on_outlined,
      title: l10n.permissionLocationTitle,
      purpose: l10n.permissionLocationPurpose,
      statusIcon: statusIcon,
      statusColor: statusColor,
      statusText: statusText,
      statusKey: const Key('location_permission_status'),
      action: action,
    );
  }
}
