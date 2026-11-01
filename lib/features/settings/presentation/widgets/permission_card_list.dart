import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/permissions/permission_service.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/settings/presentation/widgets/device_permission_card.dart';
import 'package:vakif_atlas/features/settings/presentation/widgets/location_permission_card.dart';

/// Tanıtımdaki ve ayarlardaki izin kartları: konum, kamera, mikrofon.
/// `LocationPermissionCubit` ve `DevicePermissionsCubit` üst ağaçtan
/// (router) sağlanır.
class PermissionCardList extends StatelessWidget {
  const PermissionCardList({super.key});

  @override
  Widget build(BuildContext context) {
    return const DevicePermissionsLifecycle(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LocationPermissionCard(),
          SizedBox(height: AppSpacing.sm),
          DevicePermissionCard(permission: AppPermission.camera),
          SizedBox(height: AppSpacing.sm),
          DevicePermissionCard(permission: AppPermission.microphone),
        ],
      ),
    );
  }
}
