import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:vakif_atlas/features/auth/domain/validation/credentials_validator.dart';
import 'package:vakif_atlas/features/auth/domain/validation/password_policy.dart';

import '../mock_api.dart';
import '../mock_mailbox.dart';
import 'mock_user_store.dart';

/// Kimlik doğrulama uç noktalarının durum tutan mock implementasyonu.
///
/// Sözleşme: `docs/api-contracts.md`. Gerçek bir sunucunun güvenlik
/// davranışlarını taklit eder:
/// - Şifreler kullanıcıya özgü tuzla PBKDF2-HMAC-SHA256 ile özetlenir.
/// - Tek kullanımlık kodlar özet olarak saklanır; süre ve deneme sınırı vardır.
/// - Kod gönderimi e-posta başına bekleme süresiyle sınırlandırılır.
/// - Art arda hatalı girişler hesabı geçici olarak kilitler.
/// - Kayıt ve şifre sıfırlama, hesabın varlığını açığa vurmaz.
/// - Şifre değişiminde anahtar sürümü artırılarak eski oturumlar düşürülür.
class AuthMockApi implements MockApi {
  AuthMockApi(MockUserStore store, MockMailbox mailbox)
    : this.withClock(store: store, mailbox: mailbox, clock: DateTime.now);

  AuthMockApi.withClock({
    required this._store,
    required this._mailbox,
    required DateTime Function() clock,
    Random? random,
  }) : _now = clock,
       _random = random ?? Random.secure();

  static const String demoEmail = 'vatandas@vakifatlas.dev';
  static const String demoPassword = 'Atlas2026!';
  static const String _demoUserId = 'usr_demo_001';
  static const String _demoDisplayName = 'Ayşe Yılmaz';

  static const Duration accessTokenLifetime = Duration(minutes: 15);
  static const Duration codeLifetime = Duration(minutes: 10);
  static const Duration resendCooldown = Duration(seconds: 60);
  static const Duration lockDuration = Duration(minutes: 15);
  static const int maxCodeAttempts = 5;
  static const int maxFailedLogins = 5;
  static const int codeLength = CredentialsValidator.verificationCodeLength;

  static const int _pbkdf2Iterations = 10000;
  static const String _accessPrefix = 'mock-access';
  static const String _refreshPrefix = 'mock-refresh';

  final MockUserStore _store;
  final MockMailbox _mailbox;
  final DateTime Function() _now;
  final Random _random;

  Map<String, MockUserRecord>? _users;
  final Map<String, _OneTimeCode> _verificationCodes = {};
  final Map<String, _OneTimeCode> _resetCodes = {};
  final Map<String, DateTime> _lastCodeRequest = {};
  final Set<String> _revokedRefreshTokens = {};
  final List<FutureOr<void> Function(String userId)> _deletionListeners = [];

  @override
  List<MockRoute> get routes => [
    MockRoute('POST', 'auth/register', _register),
    MockRoute('POST', 'auth/verify-email', _verifyEmail),
    MockRoute('POST', 'auth/resend-verification', _resendVerification),
    MockRoute('POST', 'auth/login', _login),
    MockRoute('POST', 'auth/refresh', _refresh),
    MockRoute('GET', 'auth/me', _me),
    MockRoute('POST', 'auth/logout', _logout),
    MockRoute('POST', 'auth/password/forgot', _forgotPassword),
    MockRoute('POST', 'auth/password/reset', _resetPassword),
    MockRoute('POST', 'auth/password/change', _changePassword),
    MockRoute('DELETE', 'auth/account', _deleteAccount),
  ];

  // ── Kayıt ve doğrulama ──────────────────────────────────────────────────

  Future<MockResponse> _register(MockRequest request) async {
    final displayName = _string(request, 'displayName');
    final email = _email(request);
    final password = _string(request, 'password');
    final consents = request.field('consents');
    if (displayName == null || email == null || password == null) {
      return MockResponse.error(400, 'invalid_request');
    }
    if (CredentialsValidator.validateDisplayName(displayName) != null ||
        CredentialsValidator.validateEmail(email) != null) {
      return MockResponse.error(400, 'invalid_request');
    }
    if (consents is! Map<String, dynamic> ||
        consents['acceptedTerms'] != true ||
        consents['acknowledgedPrivacyNotice'] != true) {
      return MockResponse.error(400, 'consent_required');
    }
    if (PasswordPolicy.validate(
          password,
          email: email,
          displayName: displayName,
        ) !=
        null) {
      return MockResponse.error(400, 'weak_password');
    }

    final users = await _loadUsers();
    final existing = users[email];
    if (existing == null) {
      final salt = _randomToken(16);
      users[email] = MockUserRecord(
        id: 'usr_${_randomToken(9)}',
        displayName: CredentialsValidator.normalizeDisplayName(displayName),
        email: email,
        passwordSalt: salt,
        passwordHash: _hashPassword(password, salt),
        emailVerified: false,
        tokenVersion: 0,
        createdAt: _now(),
        consentRecordedAt: _now(),
      );
      await _persist();
      _issueCode(_verificationCodes, MockEmailKind.verificationCode, email);
    } else if (_cooldownRemaining('verify', email) == null) {
      // Yanıt her durumda aynıdır; e-posta gönderimi bekleme süresine tabidir
      // (kayıtlı adrese bildirim spam'ini önler).
      if (existing.emailVerified) {
        _lastCodeRequest['verify:$email'] = _now();
        _mailbox.deliver(
          MockEmail(to: email, kind: MockEmailKind.accountAlreadyExists),
        );
      } else {
        // Yeni kodu tetikleyen son kaydın bilgileri geçerlidir; şifre ayrıca
        // doğrulamada kodu girenden alınır (ön ele geçirme koruması).
        final salt = _randomToken(16);
        existing
          ..displayName = CredentialsValidator.normalizeDisplayName(displayName)
          ..passwordSalt = salt
          ..passwordHash = _hashPassword(password, salt)
          ..consentRecordedAt = _now();
        await _persist();
        _issueCode(_verificationCodes, MockEmailKind.verificationCode, email);
      }
    }
    return _challengeAccepted();
  }

  Future<MockResponse> _verifyEmail(MockRequest request) async {
    final email = _email(request);
    final code = _string(request, 'code');
    final password = _string(request, 'password');
    if (email == null || code == null || password == null || password.isEmpty) {
      return MockResponse.error(400, 'invalid_request');
    }
    final user = (await _loadUsers())[email];
    if (user == null || user.emailVerified) {
      return MockResponse.error(400, 'code_expired');
    }
    final outcome = _checkCode(_verificationCodes, email, code);
    if (outcome != _CodeOutcome.valid) {
      return MockResponse.error(400, outcome.errorCode);
    }
    // Kod doğru ama şifre zayıfsa kod harcanmaz.
    if (PasswordPolicy.validate(
          password,
          email: email,
          displayName: user.displayName,
        ) !=
        null) {
      return MockResponse.error(400, 'weak_password');
    }
    _verificationCodes.remove(email);
    final salt = _randomToken(16);
    user
      ..passwordSalt = salt
      ..passwordHash = _hashPassword(password, salt)
      ..failedLoginAttempts = 0
      ..lockedUntil = null
      ..emailVerified = true;
    await _persist();
    return MockResponse.ok({..._issueTokens(user), 'user': _userJson(user)});
  }

  Future<MockResponse> _resendVerification(MockRequest request) async {
    final email = _email(request);
    if (email == null) {
      return MockResponse.error(400, 'invalid_request');
    }
    final cooldown = _cooldownRemaining('verify', email);
    if (cooldown != null) {
      return _rateLimited(cooldown);
    }
    _lastCodeRequest['verify:$email'] = _now();
    final user = (await _loadUsers())[email];
    if (user != null && !user.emailVerified) {
      _issueCode(_verificationCodes, MockEmailKind.verificationCode, email);
    }
    return _challengeAccepted();
  }

  // ── Oturum ──────────────────────────────────────────────────────────────

  Future<MockResponse> _login(MockRequest request) async {
    final email = _email(request);
    final password = _string(request, 'password');
    if (email == null || password == null) {
      return MockResponse.error(400, 'invalid_request');
    }
    final user = (await _loadUsers())[email];
    if (user == null) {
      // Zamanlama farkıyla hesap varlığı anlaşılmasın diye özet yine hesaplanır.
      _hashPassword(password, 'timing-parity');
      return MockResponse.error(401, 'invalid_credentials');
    }

    final lockedUntil = user.lockedUntil;
    if (lockedUntil != null && _now().isBefore(lockedUntil)) {
      return _rateLimited(lockedUntil.difference(_now()), status: 423);
    }

    if (!_verifyPassword(user, password)) {
      user.failedLoginAttempts++;
      if (user.failedLoginAttempts >= maxFailedLogins) {
        user
          ..failedLoginAttempts = 0
          ..lockedUntil = _now().add(lockDuration);
      }
      await _persist();
      return MockResponse.error(401, 'invalid_credentials');
    }

    user
      ..failedLoginAttempts = 0
      ..lockedUntil = null;
    await _persist();

    if (!user.emailVerified) {
      if (_cooldownRemaining('verify', email) == null) {
        _issueCode(_verificationCodes, MockEmailKind.verificationCode, email);
      }
      final resendAfter = _cooldownRemaining('verify', email) ?? Duration.zero;
      return MockResponse(
        403,
        body: {
          'code': 'email_not_verified',
          'retryAfter': max(1, (resendAfter.inMilliseconds / 1000).ceil()),
        },
      );
    }
    return MockResponse.ok({..._issueTokens(user), 'user': _userJson(user)});
  }

  Future<MockResponse> _refresh(MockRequest request) async {
    final refreshToken = _string(request, 'refreshToken');
    final user = await _userForToken(refreshToken, _refreshPrefix);
    if (refreshToken == null ||
        user == null ||
        _revokedRefreshTokens.contains(refreshToken)) {
      return MockResponse.error(401, 'invalid_refresh_token');
    }
    // Yenileme anahtarı tek kullanımlıktır (rotation).
    _revokedRefreshTokens.add(refreshToken);
    return MockResponse.ok(_issueTokens(user));
  }

  Future<MockResponse> _me(MockRequest request) async {
    final user = await _authenticatedUser(request);
    if (user == null) {
      return MockResponse.error(401, 'unauthorized');
    }
    return MockResponse.ok(_userJson(user));
  }

  Future<MockResponse> _logout(MockRequest request) async {
    final refreshToken = _string(request, 'refreshToken');
    if (refreshToken != null) {
      _revokedRefreshTokens.add(refreshToken);
    }
    return const MockResponse.noContent();
  }

  // ── Şifre ───────────────────────────────────────────────────────────────

  Future<MockResponse> _forgotPassword(MockRequest request) async {
    final email = _email(request);
    if (email == null || CredentialsValidator.validateEmail(email) != null) {
      return MockResponse.error(400, 'invalid_request');
    }
    final cooldown = _cooldownRemaining('reset', email);
    if (cooldown != null) {
      return _rateLimited(cooldown);
    }
    _lastCodeRequest['reset:$email'] = _now();
    final user = (await _loadUsers())[email];
    if (user != null && user.emailVerified) {
      _issueCode(_resetCodes, MockEmailKind.passwordResetCode, email);
    }
    return _challengeAccepted();
  }

  Future<MockResponse> _resetPassword(MockRequest request) async {
    final email = _email(request);
    final code = _string(request, 'code');
    final newPassword = _string(request, 'newPassword');
    if (email == null || code == null || newPassword == null) {
      return MockResponse.error(400, 'invalid_request');
    }
    final user = (await _loadUsers())[email];
    if (user == null) {
      return MockResponse.error(400, 'code_expired');
    }
    final outcome = _checkCode(_resetCodes, email, code);
    if (outcome != _CodeOutcome.valid) {
      return MockResponse.error(400, outcome.errorCode);
    }
    // Kod doğru ancak şifre zayıfsa kod harcanmaz; kullanıcı tekrar dener.
    if (PasswordPolicy.validate(
          newPassword,
          email: email,
          displayName: user.displayName,
        ) !=
        null) {
      return MockResponse.error(400, 'weak_password');
    }
    _resetCodes.remove(email);
    _setPassword(user, newPassword);
    user
      ..tokenVersion += 1
      ..failedLoginAttempts = 0
      ..lockedUntil = null;
    await _persist();
    return const MockResponse.noContent();
  }

  Future<MockResponse> _changePassword(MockRequest request) async {
    final user = await _authenticatedUser(request);
    if (user == null) {
      return MockResponse.error(401, 'unauthorized');
    }
    final currentPassword = _string(request, 'currentPassword');
    final newPassword = _string(request, 'newPassword');
    if (currentPassword == null || newPassword == null) {
      return MockResponse.error(400, 'invalid_request');
    }
    if (!_verifyPassword(user, currentPassword)) {
      return MockResponse.error(400, 'invalid_current_password');
    }
    if (newPassword == currentPassword ||
        PasswordPolicy.validate(
              newPassword,
              email: user.email,
              displayName: user.displayName,
            ) !=
            null) {
      return MockResponse.error(400, 'weak_password');
    }
    _setPassword(user, newPassword);
    user.tokenVersion += 1;
    await _persist();
    return MockResponse.ok(_issueTokens(user));
  }

  Future<MockResponse> _deleteAccount(MockRequest request) async {
    final user = await _authenticatedUser(request);
    if (user == null) {
      return MockResponse.error(401, 'unauthorized');
    }
    final password = _string(request, 'password');
    if (password == null || !_verifyPassword(user, password)) {
      return MockResponse.error(400, 'invalid_current_password');
    }
    (await _loadUsers()).remove(user.email);
    _verificationCodes.remove(user.email);
    _resetCodes.remove(user.email);
    await _persist();
    for (final listener in _deletionListeners) {
      await listener(user.id);
    }
    return const MockResponse.noContent();
  }

  // ── Diğer mock servisler ────────────────────────────────────────────────

  /// İstekteki geçerli Bearer anahtarının sahibi; gerçek serviste her mikro
  /// servis JWT'yi kendisi doğrular.
  Future<MockAccount?> accountFor(MockRequest request) async {
    final user = await _authenticatedUser(request);
    return user == null
        ? null
        : MockAccount(id: user.id, displayName: user.displayName);
  }

  /// Hesap silindiğinde kullanıcının diğer servislerdeki verisi de silinir
  /// (gerçek sistemde `AccountDeleted` olayı).
  void addAccountDeletionListener(
    FutureOr<void> Function(String userId) listener,
  ) => _deletionListeners.add(listener);

  // ── Yardımcılar ─────────────────────────────────────────────────────────

  Future<Map<String, MockUserRecord>> _loadUsers() async {
    final cached = _users;
    if (cached != null) {
      return cached;
    }
    final users = await _store.loadAll();
    if (!users.containsKey(demoEmail)) {
      final salt = _randomToken(16);
      users[demoEmail] = MockUserRecord(
        id: _demoUserId,
        displayName: _demoDisplayName,
        email: demoEmail,
        passwordSalt: salt,
        passwordHash: _hashPassword(demoPassword, salt),
        emailVerified: true,
        tokenVersion: 0,
        createdAt: _now(),
        consentRecordedAt: _now(),
      );
      await _store.saveAll(users);
    }
    return _users = users;
  }

  Future<void> _persist() async {
    final users = _users;
    if (users != null) {
      await _store.saveAll(users);
    }
  }

  MockResponse _challengeAccepted() => MockResponse(
    202,
    body: {'resendAfter': resendCooldown.inSeconds, 'codeLength': codeLength},
  );

  MockResponse _rateLimited(Duration retryAfter, {int status = 429}) {
    final seconds = max(1, (retryAfter.inMilliseconds / 1000).ceil());
    return MockResponse(
      status,
      body: {
        'code': status == 423 ? 'account_locked' : 'too_many_requests',
        'retryAfter': seconds,
      },
    );
  }

  Duration? _cooldownRemaining(String purpose, String email) {
    final last = _lastCodeRequest['$purpose:$email'];
    if (last == null) {
      return null;
    }
    final remaining = last.add(resendCooldown).difference(_now());
    return remaining > Duration.zero ? remaining : null;
  }

  void _issueCode(
    Map<String, _OneTimeCode> codes,
    MockEmailKind kind,
    String email,
  ) {
    final code = List.generate(codeLength, (_) => _random.nextInt(10)).join();
    codes[email] = _OneTimeCode(
      codeHash: _digest(code),
      expiresAt: _now().add(codeLifetime),
    );
    final purpose = kind == MockEmailKind.passwordResetCode
        ? 'reset'
        : 'verify';
    _lastCodeRequest['$purpose:$email'] = _now();
    _mailbox.deliver(MockEmail(to: email, kind: kind, code: code));
  }

  _CodeOutcome _checkCode(
    Map<String, _OneTimeCode> codes,
    String email,
    String code,
  ) {
    final stored = codes[email];
    if (stored == null || !_now().isBefore(stored.expiresAt)) {
      codes.remove(email);
      return _CodeOutcome.expired;
    }
    if (_constantTimeEquals(stored.codeHash, _digest(code))) {
      return _CodeOutcome.valid;
    }
    stored.attempts++;
    if (stored.attempts >= maxCodeAttempts) {
      codes.remove(email);
      return _CodeOutcome.expired;
    }
    return _CodeOutcome.invalid;
  }

  Map<String, Object> _issueTokens(MockUserRecord user) {
    final expiresAt = _now().add(accessTokenLifetime).millisecondsSinceEpoch;
    return {
      'accessToken':
          '$_accessPrefix.${user.id}.${user.tokenVersion}.$expiresAt',
      'refreshToken':
          '$_refreshPrefix.${user.id}.${user.tokenVersion}.${_randomToken(12)}',
      'expiresIn': accessTokenLifetime.inSeconds,
    };
  }

  Future<MockUserRecord?> _authenticatedUser(MockRequest request) async {
    final token = request.bearerToken;
    final user = await _userForToken(token, _accessPrefix);
    if (token == null || user == null) {
      return null;
    }
    final expiresAt = int.tryParse(token.split('.').last);
    if (expiresAt == null ||
        !_now().isBefore(DateTime.fromMillisecondsSinceEpoch(expiresAt))) {
      return null;
    }
    return user;
  }

  /// `<önek>.<kullanıcı>.<sürüm>.<…>` biçimindeki anahtarın sahibini döndürür;
  /// sürüm eskiyse (şifre değişmişse) `null`.
  Future<MockUserRecord?> _userForToken(String? token, String prefix) async {
    final parts = token?.split('.');
    if (parts == null || parts.length != 4 || parts.first != prefix) {
      return null;
    }
    final version = int.tryParse(parts[2]);
    for (final user in (await _loadUsers()).values) {
      if (user.id == parts[1]) {
        return user.tokenVersion == version ? user : null;
      }
    }
    return null;
  }

  Map<String, Object> _userJson(MockUserRecord user) => {
    'id': user.id,
    'displayName': user.displayName,
    'email': user.email,
  };

  void _setPassword(MockUserRecord user, String password) {
    final salt = _randomToken(16);
    user
      ..passwordSalt = salt
      ..passwordHash = _hashPassword(password, salt);
  }

  bool _verifyPassword(MockUserRecord user, String password) =>
      _constantTimeEquals(
        user.passwordHash,
        _hashPassword(password, user.passwordSalt),
      );

  static String? _string(MockRequest request, String key) {
    final value = request.field(key);
    return value is String ? value : null;
  }

  static String? _email(MockRequest request) {
    final value = _string(request, 'email');
    return value == null ? null : CredentialsValidator.normalizeEmail(value);
  }

  String _randomToken(int bytes) => base64Url
      .encode(List<int>.generate(bytes, (_) => _random.nextInt(256)))
      .replaceAll('=', '');

  static String _digest(String value) =>
      base64.encode(sha256.convert(utf8.encode(value)).bytes);

  /// PBKDF2-HMAC-SHA256 (RFC 8018), tek blok.
  static String _hashPassword(String password, String salt) {
    final hmac = Hmac(sha256, utf8.encode(password));
    var block = hmac.convert([...utf8.encode(salt), 0, 0, 0, 1]).bytes;
    final result = List<int>.of(block);
    for (var iteration = 1; iteration < _pbkdf2Iterations; iteration++) {
      block = hmac.convert(block).bytes;
      for (var i = 0; i < result.length; i++) {
        result[i] ^= block[i];
      }
    }
    return base64.encode(result);
  }

  /// Zamanlama saldırılarına karşı sabit süreli karşılaştırma.
  static bool _constantTimeEquals(String a, String b) {
    if (a.length != b.length) {
      return false;
    }
    var difference = 0;
    for (var i = 0; i < a.length; i++) {
      difference |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return difference == 0;
  }
}

/// Mock servisler arasında paylaşılan kimliği doğrulanmış hesap.
final class MockAccount {
  const MockAccount({required this.id, required this.displayName});

  final String id;
  final String displayName;
}

final class _OneTimeCode {
  _OneTimeCode({required this.codeHash, required this.expiresAt});

  final String codeHash;
  final DateTime expiresAt;
  int attempts = 0;
}

enum _CodeOutcome {
  valid,
  invalid,
  expired;

  String get errorCode => this == invalid ? 'invalid_code' : 'code_expired';
}
