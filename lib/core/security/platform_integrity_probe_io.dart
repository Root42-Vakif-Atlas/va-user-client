import 'dart:io';

import 'package:jailbreak_root_detection/jailbreak_root_detection.dart';
import 'package:vakif_atlas/core/security/device_integrity.dart';

/// Android/iOS için cihaz üzerinde çalışan bütünlük kontrolü.
///
/// RootBeer + DetectFrida (Android) ve IOSSecuritySuite (iOS) kullanılır;
/// hiçbir veri üçüncü taraf sunuculara gönderilmez (KVKK).
/// Android'de uygulama imzası, verildiyse beklenen sertifika özetiyle
/// karşılaştırılır (yeniden paketleme tespiti). Masaüstü platformlarda
/// kontrol yapılmaz.
IntegrityProbe createPlatformIntegrityProbe({
  required String installedSigningSha256,
  String? expectedSigningSha256,
}) {
  if (!Platform.isAndroid && !Platform.isIOS) {
    return const _NoThreatProbe();
  }
  return _MobileIntegrityProbe(
    installedSigningSha256: installedSigningSha256,
    expectedSigningSha256: expectedSigningSha256,
  );
}

final class _NoThreatProbe implements IntegrityProbe {
  const _NoThreatProbe();

  @override
  Future<Set<IntegrityThreat>> detect() async => const {};
}

final class _MobileIntegrityProbe implements IntegrityProbe {
  const _MobileIntegrityProbe({
    required this.installedSigningSha256,
    required this.expectedSigningSha256,
  });

  final String installedSigningSha256;
  final String? expectedSigningSha256;

  @override
  Future<Set<IntegrityThreat>> detect() async {
    final issues = await JailbreakRootDetection.instance.checkForIssues;
    final threats = {for (final issue in issues) ?_threatFor(issue)};
    if (Platform.isAndroid && _isSignatureMismatch()) {
      threats.add(IntegrityThreat.tampered);
    }
    return threats;
  }

  bool _isSignatureMismatch() {
    final expected = expectedSigningSha256;
    if (expected == null || expected.isEmpty) {
      return false;
    }
    String normalize(String value) =>
        value.replaceAll(':', '').trim().toUpperCase();
    return normalize(installedSigningSha256) != normalize(expected);
  }

  static IntegrityThreat? _threatFor(JailbreakIssue issue) {
    return switch (issue) {
      JailbreakIssue.jailbreak ||
      JailbreakIssue.cydiaFound => IntegrityThreat.rootOrJailbreak,
      JailbreakIssue.notRealDevice => IntegrityThreat.emulator,
      JailbreakIssue.debugged => IntegrityThreat.debuggerAttached,
      JailbreakIssue.reverseEngineered ||
      JailbreakIssue.fridaFound => IntegrityThreat.hookingFramework,
      JailbreakIssue.tampered => IntegrityThreat.tampered,
      JailbreakIssue.devMode => IntegrityThreat.developerMode,
      JailbreakIssue.proxied => IntegrityThreat.proxy,
      JailbreakIssue.onExternalStorage || JailbreakIssue.unknown => null,
    };
  }
}
