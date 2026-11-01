import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:vakif_atlas/app.dart';
import 'package:vakif_atlas/bootstrap_sequence.dart';
import 'package:vakif_atlas/core/config/app_config.dart';
import 'package:vakif_atlas/core/config/app_environment.dart';
import 'package:vakif_atlas/core/security/device_integrity.dart';

/// Tüm entrypoint'lerin (`main_dev`, `main_staging`, `main_prod`) ortak
/// başlatma fonksiyonu (TRD §12).
///
/// Yakalanamayan asenkron hatalar `runZonedGuarded`, framework hataları
/// `FlutterError.onError` üzerinden aynı işleyiciye (log + telemetri)
/// yönlendirilir. Açılış dizisi başarısız olursa (geçersiz konfigürasyon,
/// DI, güvenlik denetimi) hata raporlanır ve [StartupFailedApp] gösterilir.
Future<void> bootstrap(AppEnvironment environment) async {
  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      final IntegrityVerdict verdict;
      try {
        final config = AppConfig.resolve(environment);
        verdict = await BootstrapSequence.standard(config).run();
      } on Object catch (error, stackTrace) {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: error,
            stack: stackTrace,
            library: 'bootstrap',
          ),
        );
        runApp(const StartupFailedApp());
        return;
      }
      runApp(
        verdict == IntegrityVerdict.block
            ? const SecurityBlockedApp()
            : const VakifAtlasApp(),
      );
    },
    (error, stackTrace) => FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'bootstrap',
      ),
    ),
  );
}
