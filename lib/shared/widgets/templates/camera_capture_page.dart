import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/media/camera_capture_controller.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_colors.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_progress_indicator.dart';
import 'package:vakif_atlas/shared/widgets/molecules/app_snack_bar.dart';
import 'package:vakif_atlas/shared/widgets/templates/status_message_view.dart';

enum _CameraPhase { opening, ready, capturing, failed }

/// Uygulama içi kamera ekranı (web): canlı önizleme + deklanşör; çekilen
/// fotoğrafın baytlarıyla kapanır, vazgeçilirse `null`.
///
/// Kamera açılırken tarayıcı izin penceresini gösterir; durum değişiklikleri
/// ekran okuyucuya duyurulur. İzin yoksa nasıl verileceği, kamera yoksa
/// galeriden seçme anlatılır. `A11yAnnouncer` üst ağaçtan sağlanır.
class CameraCapturePage extends StatefulWidget {
  const CameraCapturePage({required this.controller, super.key});

  final CameraCaptureController controller;

  @override
  State<CameraCapturePage> createState() => _CameraCapturePageState();
}

class _CameraCapturePageState extends State<CameraCapturePage> {
  _CameraPhase _phase = _CameraPhase.opening;
  CameraCaptureIssue? _issue;

  CameraCaptureController get _camera => widget.controller;

  @override
  void initState() {
    super.initState();
    unawaited(_open(_camera.open));
  }

  @override
  void dispose() {
    unawaited(_camera.dispose());
    super.dispose();
  }

  Future<void> _open(Future<CameraCaptureIssue?> Function() start) async {
    setState(() => _phase = _CameraPhase.opening);
    final issue = await start();
    if (!mounted) {
      return;
    }
    setState(() {
      _issue = issue;
      _phase = issue == null ? _CameraPhase.ready : _CameraPhase.failed;
    });
    final l10n = context.l10n;
    _announce(switch (issue) {
      null => l10n.cameraCaptureReady,
      CameraCaptureIssue.permissionDenied => l10n.cameraCaptureDeniedTitle,
      CameraCaptureIssue.noCamera => l10n.cameraCaptureNoCameraTitle,
      CameraCaptureIssue.failed => l10n.cameraCaptureFailedTitle,
    }, assertive: issue != null);
  }

  Future<void> _capture() async {
    if (_phase != _CameraPhase.ready) {
      return;
    }
    setState(() => _phase = _CameraPhase.capturing);
    final bytes = await _camera.takePicture();
    if (!mounted) {
      return;
    }
    if (bytes != null) {
      Navigator.of(context).pop<Uint8List>(bytes);
      return;
    }
    setState(() => _phase = _CameraPhase.ready);
    final message = context.l10n.cameraCaptureShotFailed;
    AppSnackBar.show(context, message: message);
    _announce(message, assertive: true);
  }

  void _announce(String message, {bool assertive = false}) => unawaited(
    context.read<A11yAnnouncer>().announce(message, assertive: assertive),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.cameraCaptureTitle),
        leading: IconButton(
          key: const Key('camera_capture_close'),
          tooltip: l10n.commonClose,
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: switch (_phase) {
          _CameraPhase.opening => _Opening(message: l10n.cameraCaptureOpening),
          _CameraPhase.failed => _failure(l10n),
          _CameraPhase.ready || _CameraPhase.capturing => _Viewfinder(
            preview: _camera.buildPreview(),
            isCapturing: _phase == _CameraPhase.capturing,
            canSwitch: _camera.canSwitch,
            onCapture: () => unawaited(_capture()),
            onSwitch: () => unawaited(_open(_camera.switchCamera)),
          ),
        },
      ),
    );
  }

  Widget _failure(AppLocalizations l10n) {
    final (
      IconData icon,
      String title,
      String body,
      bool canRetry,
    ) = switch (_issue) {
      CameraCaptureIssue.permissionDenied => (
        Icons.no_photography_outlined,
        l10n.cameraCaptureDeniedTitle,
        l10n.cameraCaptureDeniedBody,
        true,
      ),
      CameraCaptureIssue.noCamera => (
        Icons.videocam_off_outlined,
        l10n.cameraCaptureNoCameraTitle,
        l10n.cameraCaptureNoCameraBody,
        false,
      ),
      CameraCaptureIssue.failed || null => (
        Icons.error_outlined,
        l10n.cameraCaptureFailedTitle,
        l10n.cameraCaptureFailedBody,
        true,
      ),
    };
    return StatusMessageView(
      key: const Key('camera_capture_issue'),
      icon: icon,
      title: title,
      message: body,
      actionLabel: canRetry ? l10n.commonRetry : l10n.commonClose,
      onAction: canRetry
          ? () => unawaited(_open(_camera.open))
          : () => Navigator.of(context).pop(),
    );
  }
}

class _Opening extends StatelessWidget {
  const _Opening({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const Key('camera_capture_opening'),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.photo_camera_outlined, size: AppSizes.iconXl),
            const SizedBox(height: AppSpacing.md),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _Viewfinder extends StatelessWidget {
  const _Viewfinder({
    required this.preview,
    required this.isCapturing,
    required this.canSwitch,
    required this.onCapture,
    required this.onSwitch,
  });

  final Widget preview;
  final bool isCapturing;
  final bool canSwitch;
  final VoidCallback onCapture;
  final VoidCallback onSwitch;

  static const double _shutterSize = 72;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Column(
      children: [
        Expanded(
          child: ColoredBox(
            color: AppColors.cameraBackdrop,
            child: Center(
              child: ExcludeSemantics(child: ClipRect(child: preview)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              const Expanded(child: SizedBox.shrink()),
              Semantics(
                button: true,
                enabled: !isCapturing,
                label: isCapturing
                    ? l10n.cameraCaptureCapturing
                    : l10n.cameraCaptureShutter,
                excludeSemantics: true,
                onTap: isCapturing ? null : onCapture,
                child: SizedBox.square(
                  dimension: _shutterSize,
                  child: FilledButton(
                    key: const Key('camera_capture_shutter'),
                    style: FilledButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: isCapturing ? null : onCapture,
                    child: isCapturing
                        ? AppProgressIndicator(
                            size: AppSizes.iconMd,
                            strokeWidth: 4,
                            color: colors.onPrimary,
                          )
                        : const Icon(Icons.photo_camera, size: AppSizes.iconLg),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: canSwitch
                      ? IconButton(
                          key: const Key('camera_capture_switch'),
                          tooltip: l10n.cameraCaptureSwitch,
                          onPressed: isCapturing ? null : onSwitch,
                          icon: const Icon(Icons.cameraswitch_outlined),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
