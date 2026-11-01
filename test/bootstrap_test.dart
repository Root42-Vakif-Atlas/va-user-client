import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/bootstrap_sequence.dart';
import 'package:vakif_atlas/core/security/device_integrity.dart';

void main() {
  late List<String> calls;

  BootstrapSequence sequence({
    IntegrityVerdict verdict = IntegrityVerdict.trusted,
  }) {
    return BootstrapSequence(
      configureDependencies: () async => calls.add('configureDependencies'),
      installObservers: () => calls.add('installObservers'),
      runSecurityChecks: () async {
        calls.add('runSecurityChecks');
        return DeviceIntegrityReport(threats: const {}, verdict: verdict);
      },
      enablePrivacyProtection: () async => calls.add('enablePrivacyProtection'),
      initTelemetry: () async => calls.add('initTelemetry'),
      restoreSession: () => calls.add('restoreSession'),
    );
  }

  setUp(() => calls = []);

  test('TRD §12 başlatma sırasına uyar', () async {
    final verdict = await sequence().run();

    expect(verdict, IntegrityVerdict.trusted);
    expect(calls, [
      'configureDependencies',
      'installObservers',
      'runSecurityChecks',
      'enablePrivacyProtection',
      'initTelemetry',
      'restoreSession',
    ]);
  });

  test('engelleyici tehditte oturum geri yüklenmez', () async {
    final verdict = await sequence(verdict: IntegrityVerdict.block).run();

    expect(verdict, IntegrityVerdict.block);
    expect(calls, isNot(contains('restoreSession')));
  });

  test('uyarı kararında uygulama oturumla açılır', () async {
    final verdict = await sequence(verdict: IntegrityVerdict.warn).run();

    expect(verdict, IntegrityVerdict.warn);
    expect(calls.last, 'restoreSession');
  });
}
