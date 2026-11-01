/// Yeni hesap oluşturma bilgileri.
final class RegistrationData {
  const RegistrationData({
    required this.displayName,
    required this.email,
    required this.password,
    required this.acceptedTerms,
    required this.acknowledgedPrivacyNotice,
  });

  final String displayName;
  final String email;
  final String password;

  /// Kullanım Koşulları kabul edildi.
  final bool acceptedTerms;

  /// KVKK Aydınlatma Metni okundu.
  final bool acknowledgedPrivacyNotice;

  RegistrationData copyWith({String? displayName, String? email}) {
    return RegistrationData(
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      password: password,
      acceptedTerms: acceptedTerms,
      acknowledgedPrivacyNotice: acknowledgedPrivacyNotice,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegistrationData &&
          other.displayName == displayName &&
          other.email == email &&
          other.password == password &&
          other.acceptedTerms == acceptedTerms &&
          other.acknowledgedPrivacyNotice == acknowledgedPrivacyNotice;

  @override
  int get hashCode => Object.hash(
    displayName,
    email,
    password,
    acceptedTerms,
    acknowledgedPrivacyNotice,
  );

  /// Kişisel veriler ve şifre asla yazdırılmaz.
  @override
  String toString() => 'RegistrationData(***)';
}
