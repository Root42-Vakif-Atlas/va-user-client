import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

/// Kameranın açılamama nedeni.
enum CameraCaptureIssue {
  /// Kullanıcı veya tarayıcı kamera iznini vermedi.
  permissionDenied,

  /// Cihazda kullanılabilir kamera yok.
  noCamera,

  /// Kamera meşgul veya beklenmeyen hata.
  failed,
}

/// Uygulama içi kamera (web'de tarayıcının kamera API'si, `getUserMedia`).
///
/// Mobilde sistem kamera uygulaması (`image_picker`) kullanılır; bu denetleyici
/// yalnızca kameranın uygulama içinde açılması gereken web içindir. İstisna
/// fırlatmaz; sorun [open] / [switchCamera] sonucu olarak döner. Çekilen
/// fotoğraf saklanmaz, yalnızca çağırana bayt olarak verilir.
abstract interface class CameraCaptureController {
  /// Kamerayı başlatır (tarayıcı gerekirse izin penceresini açar). Arka
  /// kamera varsa o seçilir. `null` → kamera hazır.
  Future<CameraCaptureIssue?> open();

  /// Birden fazla kamera varsa (ön/arka) geçiş yapılabilir.
  bool get canSwitch;

  Future<CameraCaptureIssue?> switchCamera();

  /// Canlı önizleme; yalnızca [open] başarılıysa çağrılır.
  Widget buildPreview();

  /// Fotoğrafı çeker; başarısızsa `null`.
  Future<Uint8List?> takePicture();

  Future<void> dispose();
}

@Injectable(as: CameraCaptureController)
class PlatformCameraCaptureController implements CameraCaptureController {
  CameraPlatform get _platform => CameraPlatform.instance;

  List<CameraDescription> _cameras = const [];
  int _index = 0;
  int? _cameraId;

  @override
  bool get canSwitch => _cameras.length > 1;

  @override
  Future<CameraCaptureIssue?> open() async {
    try {
      _cameras = await _platform.availableCameras();
    } on CameraException catch (error) {
      return _issueFor(error.code);
    } on Object {
      return CameraCaptureIssue.failed;
    }
    if (_cameras.isEmpty) {
      return CameraCaptureIssue.noCamera;
    }
    final back = _cameras.indexWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
    );
    _index = back < 0 ? 0 : back;
    return _start();
  }

  @override
  Future<CameraCaptureIssue?> switchCamera() async {
    if (!canSwitch) {
      return null;
    }
    _index = (_index + 1) % _cameras.length;
    return _start();
  }

  Future<CameraCaptureIssue?> _start() async {
    await _release();
    try {
      final id = await _platform.createCameraWithSettings(
        _cameras[_index],
        const MediaSettings(resolutionPreset: ResolutionPreset.high),
      );
      _cameraId = id;
      await _platform.initializeCamera(id);
      return null;
    } on CameraException catch (error) {
      await _release();
      return _issueFor(error.code);
    } on Object {
      await _release();
      return CameraCaptureIssue.failed;
    }
  }

  @override
  Widget buildPreview() => _platform.buildPreview(_cameraId!);

  @override
  Future<Uint8List?> takePicture() async {
    final id = _cameraId;
    if (id == null) {
      return null;
    }
    try {
      final file = await _platform.takePicture(id);
      return await file.readAsBytes();
    } on Object {
      return null;
    }
  }

  @override
  Future<void> dispose() => _release();

  Future<void> _release() async {
    final id = _cameraId;
    _cameraId = null;
    if (id == null) {
      return;
    }
    try {
      await _platform.dispose(id);
    } on Object {
      // Kamera zaten kapanmış olabilir.
    }
  }

  /// Tarayıcı `DOMException` adları ve `camera_web` hata kodları.
  static CameraCaptureIssue _issueFor(String code) => switch (code) {
    'NotAllowedError' ||
    'PermissionDeniedError' ||
    'SecurityError' ||
    'CameraAccessDenied' ||
    'cameraSecurity' => CameraCaptureIssue.permissionDenied,
    'NotFoundError' ||
    'DevicesNotFoundError' ||
    'cameraNotFound' ||
    'cameraNotSupported' ||
    'OverconstrainedError' => CameraCaptureIssue.noCamera,
    _ => CameraCaptureIssue.failed,
  };
}
