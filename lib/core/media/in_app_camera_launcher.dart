import 'package:flutter/foundation.dart';

/// Uygulama içi kamera ekranını açar ve çekilen fotoğrafı döndürür; kullanıcı
/// vazgeçerse `null`. Ekran açmak gezinme gerektirdiğinden implementasyon
/// kompozisyon kökündedir (`core/router`).
abstract interface class InAppCameraLauncher {
  Future<Uint8List?> capture();
}
