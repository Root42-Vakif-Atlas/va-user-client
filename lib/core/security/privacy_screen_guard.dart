import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

/// Uygulama arka plana alındığında içeriği gizler (TRD §10.A).
///
/// Görev yöneticisi küçük görüntüsünde hassas veri görünmemesi için
/// `inactive` / `hidden` / `paused` durumlarında [isObscured] `true` olur ve
/// `PrivacyScreenOverlay` uygulamayı marka örtüsüyle kapatır. Android 13+'da
/// ek olarak native tarafta küçük görüntü alınması kapatılır
/// (`MainActivity.setRecentsScreenshotEnabled`).
///
/// Masaüstü ve web'de pencere odağını kaybetmek sık yaşandığından koruma
/// yalnızca mobil platformlarda etkinleşir.
@lazySingleton
class PrivacyScreenGuard {
  PrivacyScreenGuard() : this.forPlatform(defaultTargetPlatform, isWeb: kIsWeb);

  PrivacyScreenGuard.forPlatform(TargetPlatform platform, {required bool isWeb})
    : _supported =
          !isWeb &&
          (platform == TargetPlatform.android ||
              platform == TargetPlatform.iOS);

  final bool _supported;
  final ValueNotifier<bool> _obscured = ValueNotifier<bool>(false);
  AppLifecycleListener? _listener;

  ValueListenable<bool> get isObscured => _obscured;

  Future<void> enableProtection() async {
    if (!_supported || _listener != null) {
      return;
    }
    _listener = AppLifecycleListener(onStateChange: handleLifecycleState);
  }

  @visibleForTesting
  void handleLifecycleState(AppLifecycleState state) {
    _obscured.value = switch (state) {
      AppLifecycleState.inactive ||
      AppLifecycleState.hidden ||
      AppLifecycleState.paused => true,
      AppLifecycleState.resumed || AppLifecycleState.detached => false,
    };
  }

  @disposeMethod
  void dispose() {
    _listener?.dispose();
    _obscured.dispose();
  }
}
