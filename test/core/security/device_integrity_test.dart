import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vakif_atlas/core/config/app_environment.dart';
import 'package:vakif_atlas/core/observability/app_logger.dart';
import 'package:vakif_atlas/core/observability/telemetry_service.dart';
import 'package:vakif_atlas/core/security/device_integrity.dart';
import 'package:vakif_atlas/core/security/device_integrity_service.dart';

import '../../helpers/test_config.dart';

class _MockTelemetry extends Mock implements TelemetryService {}

class _FakeProbe implements IntegrityProbe {
  _FakeProbe(this.result);

  final Future<Set<IntegrityThreat>> Function() result;

  @override
  Future<Set<IntegrityThreat>> detect() => result();
}

void main() {
  group('DeviceIntegrityPolicy', () {
    test('dev ve staging ortamında hiçbir tehdit engellemez', () {
      for (final environment in [AppEnvironment.dev, AppEnvironment.staging]) {
        expect(
          DeviceIntegrityPolicy.evaluate(
            IntegrityThreat.values.toSet(),
            environment,
          ),
          IntegrityVerdict.trusted,
        );
      }
    });

    test('prod: kurcalama, kanca ve debugger engellenir', () {
      for (final threat in [
        IntegrityThreat.tampered,
        IntegrityThreat.hookingFramework,
        IntegrityThreat.debuggerAttached,
      ]) {
        expect(
          DeviceIntegrityPolicy.evaluate({threat}, AppEnvironment.prod),
          IntegrityVerdict.block,
          reason: threat.name,
        );
      }
    });

    test('prod: root/jailbreak uyarı verir', () {
      expect(
        DeviceIntegrityPolicy.evaluate({
          IntegrityThreat.rootOrJailbreak,
        }, AppEnvironment.prod),
        IntegrityVerdict.warn,
      );
    });

    test('prod: emülatör, geliştirici modu ve proxy yalnızca izlenir', () {
      expect(
        DeviceIntegrityPolicy.evaluate({
          IntegrityThreat.emulator,
          IntegrityThreat.developerMode,
          IntegrityThreat.proxy,
        }, AppEnvironment.prod),
        IntegrityVerdict.trusted,
      );
    });
  });

  group('DeviceIntegrityService', () {
    late _MockTelemetry telemetry;
    final logger = AppLogger.withLogger(Logger(level: Level.off));

    setUp(() {
      telemetry = _MockTelemetry();
      when(
        () => telemetry.recordError(
          any<Object>(),
          any(),
          reason: any(named: 'reason'),
        ),
      ).thenAnswer((_) async {});
    });

    DeviceIntegrityService service(
      Future<Set<IntegrityThreat>> Function() detect, {
      AppEnvironment environment = AppEnvironment.prod,
    }) {
      return DeviceIntegrityService.withProbe(
        probe: _FakeProbe(detect),
        config: testAppConfig(environment: environment),
        logger: logger,
        telemetry: telemetry,
      );
    }

    test('kontrol öncesi rapor temizdir', () {
      final integrity = service(() async => const {});
      expect(integrity.report, DeviceIntegrityReport.unchecked);
      expect(integrity.requestHeaderValue, isNull);
    });

    test('root tespitinde uyarı verir ve istekler işaretlenir', () async {
      final integrity = service(() async => {IntegrityThreat.rootOrJailbreak});

      final report = await integrity.initializeSecurityChecks();

      expect(report.verdict, IntegrityVerdict.warn);
      expect(
        integrity.requestHeaderValue,
        DeviceIntegrityService.compromisedHeaderValue,
      );
      verify(() => telemetry.addBreadcrumb(any())).called(1);
    });

    test('dev ortamında root yalnızca işaretlenir, engellenmez', () async {
      final integrity = service(
        () async => {IntegrityThreat.rootOrJailbreak},
        environment: AppEnvironment.dev,
      );

      final report = await integrity.initializeSecurityChecks();

      expect(report.verdict, IntegrityVerdict.trusted);
      expect(
        integrity.requestHeaderValue,
        DeviceIntegrityService.compromisedHeaderValue,
      );
    });

    test('kontrol yapılamazsa güvenilir kabul edilir ve raporlanır', () async {
      final integrity = service(
        () async => throw MissingPluginException('jailbreak_root_detection'),
      );

      final report = await integrity.initializeSecurityChecks();

      expect(report.verdict, IntegrityVerdict.trusted);
      verify(
        () => telemetry.recordError(
          any<Object>(),
          any(),
          reason: 'device_integrity.check_failed',
        ),
      ).called(1);
    });
  });
}
