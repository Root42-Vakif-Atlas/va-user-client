/// Kullanıcıya e-postayla tek kullanımlık kod gönderildiğinde dönen bilgi.
///
/// Sunucu, hesabın var olup olmadığını açığa vurmamak için kayıt ve şifre
/// sıfırlama isteklerinde her durumda aynı yanıtı verir.
final class VerificationChallenge {
  const VerificationChallenge({
    required this.email,
    required this.resendAfter,
    this.codeLength = defaultCodeLength,
  });

  static const int defaultCodeLength = 6;

  final String email;

  /// Yeni kod istenebilmesi için beklenmesi gereken süre.
  final Duration resendAfter;

  final int codeLength;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VerificationChallenge &&
          other.email == email &&
          other.resendAfter == resendAfter &&
          other.codeLength == codeLength;

  @override
  int get hashCode => Object.hash(email, resendAfter, codeLength);

  @override
  String toString() =>
      'VerificationChallenge(resendAfter: $resendAfter, '
      'codeLength: $codeLength)';
}
