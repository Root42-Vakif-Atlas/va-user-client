import 'dart:convert';

import 'package:vakif_atlas/features/auth/domain/entities/verification_challenge.dart';
import 'package:vakif_atlas/features/auth/presentation/pending_verification.dart';

/// GoRouter `extra` kodlayıcısı.
///
/// GoRouter, raporladığı konumu (`restoreRouteInformation`) kodlanmış olarak
/// saklar ve yenilemede (`refreshListenable`), web geçmişinde ve geri
/// yüklemede bu kodlanmış hâli yeniden ayrıştırır. Kodlayıcı olmadan JSON'a
/// çevrilemeyen `extra` `null`'a düşer; `push` ile açılmış sayfalarda rota
/// düzeyindeki `redirect` de yeniden çalışmadığından doğrulama/sıfırlama
/// ekranı `extra` olmadan kurulup çöküyordu.
///
/// Yalnızca yeniden kurulumda zorunlu olan değerler kodlanır; diğerleri
/// (arama sorgusu/sonucu) eskisi gibi düşer ve sayfalar varsayılana döner.
/// Değer URL'ye değil yalnızca gezinme durumuna yazılır (ADR 14); doğrulama
/// ekranının şifresi hiç yazılmaz (yalnızca bellekte).
class RouterExtraCodec extends Codec<Object?, Object?> {
  const RouterExtraCodec();

  @override
  Converter<Object?, Object?> get encoder => const _Encoder();

  @override
  Converter<Object?, Object?> get decoder => const _Decoder();
}

const String _typeKey = 'type';
const String _verificationChallenge = 'verificationChallenge';
const String _pendingVerification = 'pendingVerification';
const String _string = 'string';

class _Encoder extends Converter<Object?, Object?> {
  const _Encoder();

  @override
  Object? convert(Object? input) => switch (input) {
    VerificationChallenge() => {
      _typeKey: _verificationChallenge,
      ..._challenge(input),
    },
    // Şifre kodlanmaz.
    PendingVerification(:final challenge) => {
      _typeKey: _pendingVerification,
      ..._challenge(challenge),
    },
    String() => {_typeKey: _string, 'value': input},
    _ => null,
  };

  static Map<String, Object> _challenge(VerificationChallenge challenge) => {
    'email': challenge.email,
    'resendAfterMs': challenge.resendAfter.inMilliseconds,
    'codeLength': challenge.codeLength,
  };
}

class _Decoder extends Converter<Object?, Object?> {
  const _Decoder();

  @override
  Object? convert(Object? input) {
    if (input is! Map) {
      return null;
    }
    return switch (input[_typeKey]) {
      _verificationChallenge => _challenge(input),
      _pendingVerification => PendingVerification(challenge: _challenge(input)),
      _string => input['value'] as String,
      _ => null,
    };
  }

  static VerificationChallenge _challenge(Map<Object?, Object?> input) =>
      VerificationChallenge(
        email: input['email']! as String,
        resendAfter: Duration(milliseconds: input['resendAfterMs']! as int),
        codeLength: input['codeLength']! as int,
      );
}
