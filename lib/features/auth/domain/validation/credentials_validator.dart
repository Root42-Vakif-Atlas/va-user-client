enum EmailValidationError { empty, invalid }

/// Giriş ekranı şifre kontrolü. Politika kuralları burada uygulanmaz:
/// eski hesapların girişini engellememek ve politikayı açığa vurmamak için.
enum PasswordValidationError { empty }

enum ConfirmPasswordError { empty, mismatch }

enum DisplayNameValidationError { empty, tooShort, tooLong, invalid }

enum VerificationCodeError { empty, invalid }

/// Kimlik doğrulama formlarının alan kuralları.
abstract final class CredentialsValidator {
  static const int maxEmailLength = 254;
  static const int minDisplayNameLength = 2;
  static const int maxDisplayNameLength = 80;
  static const int verificationCodeLength = 6;

  static final RegExp _email = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)*\.[A-Za-z]{2,}$',
  );
  static final RegExp _displayName = RegExp(
    r"^[\p{L}\p{M}]+(?:[ '’.-][\p{L}\p{M}]+)*\.?$",
    unicode: true,
  );
  static final RegExp _whitespace = RegExp(r'\s+');
  static final RegExp _digits = RegExp(r'^\d+$');

  /// Karşılaştırma ve depolama için kanonik e-posta biçimi.
  static String normalizeEmail(String value) => value.trim().toLowerCase();

  /// Baştaki/sondaki ve tekrarlı boşlukları temizler.
  static String normalizeDisplayName(String value) =>
      value.trim().replaceAll(_whitespace, ' ');

  /// Kopyala-yapıştırda gelen boşlukları temizler.
  static String normalizeVerificationCode(String value) =>
      value.replaceAll(_whitespace, '');

  static EmailValidationError? validateEmail(String value) {
    final email = value.trim();
    if (email.isEmpty) {
      return EmailValidationError.empty;
    }
    return email.length <= maxEmailLength && _email.hasMatch(email)
        ? null
        : EmailValidationError.invalid;
  }

  static PasswordValidationError? validateLoginPassword(String value) =>
      value.isEmpty ? PasswordValidationError.empty : null;

  static ConfirmPasswordError? validateConfirmation(
    String password,
    String confirmation,
  ) {
    if (confirmation.isEmpty) {
      return ConfirmPasswordError.empty;
    }
    return confirmation == password ? null : ConfirmPasswordError.mismatch;
  }

  static DisplayNameValidationError? validateDisplayName(String value) {
    final name = normalizeDisplayName(value);
    if (name.isEmpty) {
      return DisplayNameValidationError.empty;
    }
    final length = name.runes.length;
    if (length < minDisplayNameLength) {
      return DisplayNameValidationError.tooShort;
    }
    if (length > maxDisplayNameLength) {
      return DisplayNameValidationError.tooLong;
    }
    return _displayName.hasMatch(name)
        ? null
        : DisplayNameValidationError.invalid;
  }

  static VerificationCodeError? validateVerificationCode(String value) {
    final code = normalizeVerificationCode(value);
    if (code.isEmpty) {
      return VerificationCodeError.empty;
    }
    return code.length == verificationCodeLength && _digits.hasMatch(code)
        ? null
        : VerificationCodeError.invalid;
  }
}
