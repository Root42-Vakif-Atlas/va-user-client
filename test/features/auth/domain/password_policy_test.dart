import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/features/auth/domain/validation/credentials_validator.dart';
import 'package:vakif_atlas/features/auth/domain/validation/password_policy.dart';

void main() {
  group('PasswordPolicy.validate', () {
    test('uzunluk sınırları', () {
      expect(PasswordPolicy.validate(''), PasswordPolicyViolation.empty);
      expect(
        PasswordPolicy.validate('Kısa-şifre1'),
        PasswordPolicyViolation.tooShort,
      );
      expect(
        PasswordPolicy.validate('a${'bcdefghij' * 15}'),
        PasswordPolicyViolation.tooLong,
      );
    });

    test('karakter türü zorunluluğu yoktur (NIST 800-63B)', () {
      expect(PasswordPolicy.validate('mavi deniz kıyısında yürüyüş'), isNull);
      expect(PasswordPolicy.validate('kubbeminaresütun'), isNull);
    });

    test('yaygın şifreler ve varyasyonları reddedilir', () {
      for (final password in [
        'password1234',
        'Qwerty123456',
        'Galatasaray1905!',
        '!!Fenerbahçe1907',
        'şifre20262026',
      ]) {
        expect(
          PasswordPolicy.validate(password),
          PasswordPolicyViolation.common,
          reason: password,
        );
      }
    });

    test('tekrarlı ve ardışık diziler reddedilir', () {
      for (final password in [
        'aaaaaaaaaaaa',
        '121212121212',
        'abcdefghijklm',
        'zyxwvutsrqpo',
      ]) {
        expect(
          PasswordPolicy.validate(password),
          PasswordPolicyViolation.repetitive,
          reason: password,
        );
      }
    });

    test('ad, e-posta ve uygulama adını içeren şifre reddedilir', () {
      expect(
        PasswordPolicy.validate(
          'zeynepkaradag-gezi',
          email: 'zeynep.k@example.org',
          displayName: 'Zeynep Karadağ',
        ),
        PasswordPolicyViolation.personalInfo,
      );
      expect(
        PasswordPolicy.validate('ben.vakifatlas.seviyorum'),
        PasswordPolicyViolation.personalInfo,
      );
      expect(
        PasswordPolicy.validate(
          'kubbe altında bir gün',
          email: 'zeynep@example.org',
        ),
        isNull,
      );
    });
  });

  group('PasswordPolicy.strength', () {
    test('politikayı karşılamayan şifre zayıftır', () {
      expect(PasswordPolicy.strength('password1234'), PasswordStrength.weak);
    });

    test('uzunluk ve çeşitlilik gücü artırır', () {
      expect(PasswordPolicy.strength('kubbeminaret'), PasswordStrength.fair);
      expect(
        PasswordPolicy.strength('kubbeminaretkemer'),
        PasswordStrength.good,
      );
      expect(
        PasswordPolicy.strength('Kubbe-Minare 7 Kemer!'),
        PasswordStrength.strong,
      );
    });
  });

  group('CredentialsValidator', () {
    test('e-posta', () {
      expect(
        CredentialsValidator.validateEmail('  '),
        EmailValidationError.empty,
      );
      expect(
        CredentialsValidator.validateEmail('ayse@'),
        EmailValidationError.invalid,
      );
      expect(CredentialsValidator.validateEmail(' Ayse@VGM.gov.tr '), isNull);
      expect(
        CredentialsValidator.normalizeEmail(' Ayse@VGM.gov.tr '),
        'ayse@vgm.gov.tr',
      );
    });

    test('giriş şifresinde politika uygulanmaz', () {
      expect(
        CredentialsValidator.validateLoginPassword(''),
        PasswordValidationError.empty,
      );
      expect(CredentialsValidator.validateLoginPassword('kisa'), isNull);
    });

    test('ad soyad: Türkçe harfler, kesme işareti ve tire geçerlidir', () {
      for (final name in [
        'Ayşe Yılmaz',
        "Gül O'Neil",
        'Ali Rıza Öztürk-Şahin',
        '  Çağrı   Işık  ',
      ]) {
        expect(
          CredentialsValidator.validateDisplayName(name),
          isNull,
          reason: name,
        );
      }
      expect(
        CredentialsValidator.validateDisplayName(''),
        DisplayNameValidationError.empty,
      );
      expect(
        CredentialsValidator.validateDisplayName('A'),
        DisplayNameValidationError.tooShort,
      );
      expect(
        CredentialsValidator.validateDisplayName('Ayşe <script>'),
        DisplayNameValidationError.invalid,
      );
      expect(
        CredentialsValidator.normalizeDisplayName('  Çağrı   Işık  '),
        'Çağrı Işık',
      );
    });

    test('şifre tekrarı', () {
      expect(
        CredentialsValidator.validateConfirmation('a', ''),
        ConfirmPasswordError.empty,
      );
      expect(
        CredentialsValidator.validateConfirmation('abc', 'abd'),
        ConfirmPasswordError.mismatch,
      );
      expect(CredentialsValidator.validateConfirmation('abc', 'abc'), isNull);
    });

    test('doğrulama kodu: 6 hane, boşluklar temizlenir', () {
      expect(
        CredentialsValidator.validateVerificationCode(''),
        VerificationCodeError.empty,
      );
      expect(
        CredentialsValidator.validateVerificationCode('12a456'),
        VerificationCodeError.invalid,
      );
      expect(
        CredentialsValidator.validateVerificationCode('12345'),
        VerificationCodeError.invalid,
      );
      expect(CredentialsValidator.validateVerificationCode('123 456'), isNull);
    });
  });
}
