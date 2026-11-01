import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/di/injection.dart';
import 'package:vakif_atlas/core/media/camera_capture_controller.dart';
import 'package:vakif_atlas/core/media/in_app_camera_launcher.dart';
import 'package:vakif_atlas/core/router/app_router.dart';
import 'package:vakif_atlas/shared/widgets/templates/camera_capture_page.dart';

/// Kamera ekranını kök Navigator'da tam ekran açar (kompozisyon kökü).
@LazySingleton(as: InAppCameraLauncher)
class NavigatorCameraLauncher implements InAppCameraLauncher {
  NavigatorCameraLauncher(this._router);

  final AppRouter _router;

  @override
  Future<Uint8List?> capture() async {
    final navigator = _router.navigatorKey.currentState;
    if (navigator == null) {
      return null;
    }
    return navigator.push<Uint8List>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) =>
            CameraCapturePage(controller: getIt<CameraCaptureController>()),
      ),
    );
  }
}
