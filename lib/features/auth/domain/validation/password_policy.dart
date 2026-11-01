import 'package:vakif_atlas/features/auth/domain/validation/common_passwords.dart';

/// Yeni şifre için ihlal edilen kural.
enum PasswordPolicyViolation {
  empty,
  tooShort,
  tooLong,

  /// Yaygın/sızdırılmış şifre veya bunun basit bir varyasyonu.
  common,

  /// Kullanıcının adı, e-posta adresi veya uygulama adı.
  personalInfo,

  /// `aaaaaaaaaaaa`, `abcdefghijkl`, `121212121212` gibi tahmin edilebilir dizi.
  repetitive,
}

/// Arayüzde gösterilen tahmini şifre gücü.
enum PasswordStrength { weak, fair, good, strong }

/// Yeni şifre politikası (OWASP ASVS v4 §2.1, NIST SP 800-63B §5.1.1).
///
/// - En az [minLength], en fazla [maxLength] karakter.
/// - Karakter türü zorunluluğu (büyük harf, sembol vb.) **yoktur**; bunun
///   yerine yaygın, kişisel ve tekrarlı şifreler reddedilir.
/// - Boşluk ve Unicode karakterler (Türkçe harfler, emoji) serbesttir.
/// - Giriş ekranında uygulanmaz; yalnızca yeni şifre belirlenirken kullanılır.
abstract final class PasswordPolicy {
  static const int minLength = 12;
  static const int maxLength = 128;

  static const List<String> _appNames = ['vakif', 'vakıf', 'atlas'];
  static const int _minPersonalTokenLength = 4;
  static const int _minDistinctCharacters = 4;

  static final RegExp _edgeDigitsAndSymbols = RegExp(
    r'^[^a-zçğıöşü]+|[^a-zçğıöşü]+$',
  );
  static final RegExp _nameSeparator = RegExp(r"[\s'’.-]+");
  static final RegExp _digit = RegExp(r'\d');

  /// İlk ihlal edilen kural; şifre geçerliyse `null`.
  static PasswordPolicyViolation? validate(
    String password, {
    String? email,
    String? displayName,
  }) {
    if (password.isEmpty) {
      return PasswordPolicyViolation.empty;
    }
    final length = password.runes.length;
    if (length < minLength) {
      return PasswordPolicyViolation.tooShort;
    }
    if (length > maxLength) {
      return PasswordPolicyViolation.tooLong;
    }

    final lower = password.toLowerCase();
    if (_isRepetitive(lower)) {
      return PasswordPolicyViolation.repetitive;
    }
    if (_isCommon(lower)) {
      return PasswordPolicyViolation.common;
    }
    if (_containsPersonalInfo(lower, email: email, displayName: displayName)) {
      return PasswordPolicyViolation.personalInfo;
    }
    return null;
  }

  /// Kullanıcıya gösterilen güç tahmini. Politikayı karşılamayan şifre
  /// her zaman [PasswordStrength.weak] olur.
  static PasswordStrength strength(
    String password, {
    String? email,
    String? displayName,
  }) {
    if (validate(password, email: email, displayName: displayName) != null) {
      return PasswordStrength.weak;
    }
    final length = password.runes.length;
    final classes = _characterClasses(password);
    var score = 0;
    if (length >= 16) {
      score++;
    }
    if (classes >= 3) {
      score++;
    }
    if (length >= 20 || (classes == 4 && length >= 14)) {
      score++;
    }
    return switch (score) {
      0 => PasswordStrength.fair,
      1 || 2 => PasswordStrength.good,
      _ => PasswordStrength.strong,
    };
  }

  static bool _isCommon(String lower) {
    if (CommonPasswords.exact.contains(lower)) {
      return true;
    }
    final base = lower.replaceAll(_edgeDigitsAndSymbols, '');
    return CommonPasswords.baseWords.contains(base);
  }

  static bool _isRepetitive(String lower) {
    final runes = lower.runes.toList();
    if (runes.toSet().length < _minDistinctCharacters) {
      return true;
    }
    var ascending = true;
    var descending = true;
    for (var i = 1; i < runes.length; i++) {
      final delta = runes[i] - runes[i - 1];
      ascending = ascending && delta == 1;
      descending = descending && delta == -1;
    }
    return ascending || descending;
  }

  static bool _containsPersonalInfo(
    String lower, {
    String? email,
    String? displayName,
  }) {
    final tokens = <String>[
      ..._appNames,
      if (email != null) email.trim().toLowerCase().split('@').first,
      if (displayName != null)
        ...displayName.trim().toLowerCase().split(_nameSeparator),
    ];
    return tokens.any(
      (token) =>
          token.runes.length >= _minPersonalTokenLength &&
          lower.contains(token),
    );
  }

  static int _characterClasses(String password) {
    var lower = false;
    var upper = false;
    var digit = false;
    var other = false;
    for (final rune in password.runes) {
      final character = String.fromCharCode(rune);
      if (_digit.hasMatch(character)) {
        digit = true;
      } else if (character.toLowerCase() != character) {
        upper = true;
      } else if (character.toUpperCase() != character) {
        lower = true;
      } else {
        other = true;
      }
    }
    return [lower, upper, digit, other].where((present) => present).length;
  }
}
