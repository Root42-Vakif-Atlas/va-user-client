import 'dart:async';
import 'dart:io';

import 'package:alchemist/alchemist.dart';

/// Tüm testler için ortak konfigürasyon.
///
/// Golden testler iki türde üretilir:
/// - `goldens/ci/`: Platformdan bağımsız (metin bloklarla gizlenir); CI'da
///   karşılaştırılır.
/// - `goldens/macos/`: Gerçek fontlarla, geliştirici makinesinde görsel
///   inceleme için. CI ortamında (`CI=true`) üretilmez/karşılaştırılmaz.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final isRunningInCi = Platform.environment['CI'] == 'true';

  return AlchemistConfig.runWithConfig(
    config: AlchemistConfig(
      platformGoldensConfig: PlatformGoldensConfig(
        enabled: !isRunningInCi,
        platforms: {HostPlatform.macOS},
      ),
    ),
    run: testMain,
  );
}
