import 'package:vakif_atlas/features/auth/domain/entities/verification_challenge.dart';

/// Doğrulama ekranına geçen bilgi: sunucunun bildirdiği kod bilgisi ve
/// formda girilen şifre.
///
/// Şifre doğrulamada hesabın şifresi olur (kodu giren e-postanın sahibidir;
/// adresi önceden kaydeden başkası hesabı ele geçiremez). Yalnızca bellekte
/// tutulur: gezinme durumuna (`RouterExtraCodec`) ve loglara yazılmaz.
final class PendingVerification {
  const PendingVerification({required this.challenge, this.password});

  final VerificationChallenge challenge;

  /// Yeniden kurulan (kodlanmış durumdan çözülen) gezinmede `null`.
  final String? password;

  @override
  String toString() => 'PendingVerification(***)';
}
