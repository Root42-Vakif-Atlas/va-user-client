import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/config/app_config.dart';
import 'package:vakif_atlas/core/di/injection.dart' as di;
import 'package:vakif_atlas/core/observability/app_bloc_observer.dart';
import 'package:vakif_atlas/core/observability/app_logger.dart';
import 'package:vakif_atlas/core/observability/telemetry_service.dart';
import 'package:vakif_atlas/core/security/device_integrity.dart';
import 'package:vakif_atlas/core/security/device_integrity_service.dart';
import 'package:vakif_atlas/core/security/privacy_screen_guard.dart';
import 'package:vakif_atlas/core/storage/local_db_service.dart';
import 'package:vakif_atlas/core/theme/font_licenses.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vakif_atlas/features/route_export/data/route_export_account_cleanup.dart';

/// TRD §12 zorunlu başlatma sırası (`runApp` hariç).
///
/// 1. `WidgetsFlutterBinding.ensureInitialized()` — `bootstrap()` içinde
/// 2. [configureDependencies] — ortama uygun DI grafiği
/// 3. [installObservers] — `Bloc.observer` + global hata işleyicisi +
///    oturum olayı dinleyicileri (hesap silinince yerel veri temizliği) +
///    eski sürümlerin kullanılmayan yerel kutularının silinmesi
/// 4. [runSecurityChecks] — cihaz bütünlüğü
/// 5. [enablePrivacyProtection] — arka plan ekran gizliliği
/// 6. [initTelemetry] — hata ve performans izleme
///
/// Ardından kayıtlı oturum geri yüklenmeye başlar ([restoreSession]).
/// Adımlar fonksiyon olarak verildiğinden sıra testlerle doğrulanabilir.
class BootstrapSequence {
  const BootstrapSequence({
    required this.configureDependencies,
    required this.installObservers,
    required this.runSecurityChecks,
    required this.enablePrivacyProtection,
    required this.initTelemetry,
    required this.restoreSession,
  });

  /// Gerçek servislerle çalışan başlatma sırası.
  factory BootstrapSequence.standard(AppConfig config) {
    return BootstrapSequence(
      configureDependencies: () => di.configureDependencies(config),
      installObservers: () {
        Bloc.observer = di.getIt<AppBlocObserver>();
        FlutterError.onError = _globalErrorHandler(
          logger: di.getIt<AppLogger>(),
          telemetry: di.getIt<TelemetryService>(),
        );
        FontLicenses.register();
        di.getIt<RouteExportAccountCleanup>().start();
        unawaited(di.getIt<LocalDbService>().deleteLegacyBoxes());
      },
      runSecurityChecks: () =>
          di.getIt<DeviceIntegrityService>().initializeSecurityChecks(),
      enablePrivacyProtection: () =>
          di.getIt<PrivacyScreenGuard>().enableProtection(),
      initTelemetry: () =>
          di.getIt<TelemetryService>().init(config.environment),
      restoreSession: () => di.getIt<AuthBloc>().add(const AuthEvent.started()),
    );
  }

  final Future<void> Function() configureDependencies;
  final void Function() installObservers;
  final Future<DeviceIntegrityReport> Function() runSecurityChecks;
  final Future<void> Function() enablePrivacyProtection;
  final Future<void> Function() initTelemetry;
  final void Function() restoreSession;

  /// Sırayı çalıştırır ve cihaz bütünlüğü kararını döndürür.
  ///
  /// Engelleyici bir tehditte oturum geri yüklenmez.
  Future<IntegrityVerdict> run() async {
    await configureDependencies();
    installObservers();
    final integrity = await runSecurityChecks();
    await enablePrivacyProtection();
    await initTelemetry();
    if (integrity.verdict != IntegrityVerdict.block) {
      restoreSession();
    }
    return integrity.verdict;
  }

  static FlutterExceptionHandler _globalErrorHandler({
    required AppLogger logger,
    required TelemetryService telemetry,
  }) {
    return (details) {
      logger.error(
        details.exceptionAsString(),
        error: details.exception,
        stackTrace: details.stack,
      );
      telemetry.recordError(
        details.exception,
        details.stack,
        fatal: !details.silent,
        reason: details.library,
      );
      if (kDebugMode) {
        FlutterError.presentError(details);
      }
    };
  }
}
