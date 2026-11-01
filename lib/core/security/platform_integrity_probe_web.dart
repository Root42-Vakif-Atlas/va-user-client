import 'package:vakif_atlas/core/security/device_integrity.dart';

/// Web'de cihaz bütünlüğü kontrolü yapılamaz; tarayıcı korumalı alanı
/// (sandbox) içinde çalışılır.
IntegrityProbe createPlatformIntegrityProbe({
  required String installedSigningSha256,
  String? expectedSigningSha256,
}) {
  return const _NoThreatProbe();
}

final class _NoThreatProbe implements IntegrityProbe {
  const _NoThreatProbe();

  @override
  Future<Set<IntegrityThreat>> detect() async => const {};
}
