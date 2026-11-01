import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/network_test_utils.dart';
import '../../../support/mock_api/auth/auth_mock_api.dart';
import '../../../support/mock_api/auth/legal_mock_api.dart';
import '../../../support/mock_api/auth/mock_user_store.dart';
import '../../../support/mock_api/mock_api.dart';
import '../../../support/mock_api/mock_mailbox.dart';

/// Mock sunucunun güvenlik davranışlarını HTTP üzerinden doğrular.
void main() {
  const email = 'zeynep@example.org';
  const password = 'kubbe altında bir gün';
  const newPassword = 'çini desenli avlu kapısı';

  late DateTime now;
  late MockUserStore store;
  late MockMailbox mailbox;
  late List<MockEmail> inbox;
  late Dio dio;

  Dio buildDio() {
    final api = AuthMockApi.withClock(
      store: store,
      mailbox: mailbox,
      clock: () => now,
    );
    return Dio(BaseOptions(baseUrl: testBaseUrl, validateStatus: (_) => true))
      ..httpClientAdapter = MockApiAdapter(apis: [api, LegalMockApi()]);
  }

  setUp(() {
    now = DateTime(2026, 10, 17, 12);
    store = InMemoryMockUserStore();
    mailbox = MockMailbox();
    inbox = [];
    mailbox.emails.listen(inbox.add);
    dio = buildDio();
  });

  tearDown(() => mailbox.dispose());

  Future<Response<dynamic>> post(String path, Object body, {String? token}) {
    return dio.post<dynamic>(
      path,
      data: body,
      options: Options(
        headers: {if (token != null) 'Authorization': 'Bearer $token'},
      ),
    );
  }

  Future<String?> lastCode(MockEmailKind kind) async {
    await Future<void>.delayed(Duration.zero);
    return inbox.lastWhere((mail) => mail.kind == kind).code;
  }

  Map<String, dynamic> registration({String pass = password}) => {
    'displayName': 'Zeynep Karadağ',
    'email': email,
    'password': pass,
    'consents': {'acceptedTerms': true, 'acknowledgedPrivacyNotice': true},
  };

  Future<Map<String, dynamic>> registerAndVerify() async {
    await post('auth/register', registration());
    final code = await lastCode(MockEmailKind.verificationCode);
    final response = await post('auth/verify-email', {
      'email': email,
      'code': code,
      'password': password,
    });
    return response.data as Map<String, dynamic>;
  }

  group('kayıt ve doğrulama', () {
    test('kayıt kod gönderir; doğrulanmadan giriş yapılamaz', () async {
      final register = await post('auth/register', registration());
      expect(register.statusCode, 202);
      expect(register.data, {'resendAfter': 60, 'codeLength': 6});
      expect(await lastCode(MockEmailKind.verificationCode), hasLength(6));

      final login = await post('auth/login', {
        'email': email,
        'password': password,
      });
      expect(login.statusCode, 403);
      // Kayıtta gönderilen kodun bekleme süresi doğrulama ekranına taşınır.
      expect(login.data, {'code': 'email_not_verified', 'retryAfter': 60});
    });

    test('doğru kod hesabı doğrular ve oturum açar', () async {
      final session = await registerAndVerify();

      expect(session['accessToken'], isA<String>());
      expect((session['user'] as Map)['email'], email);

      final login = await post('auth/login', {
        'email': ' Zeynep@Example.org ',
        'password': password,
      });
      expect(login.statusCode, 200);
    });

    test(
      'kayıtlı adresle tekrar kayıt aynı yanıtı verir, kod gönderilmez',
      () async {
        await registerAndVerify();
        inbox.clear();
        now = now.add(const Duration(minutes: 2));

        final again = await post('auth/register', registration());

        expect(again.statusCode, 202);
        expect(again.data, {'resendAfter': 60, 'codeLength': 6});
        await Future<void>.delayed(Duration.zero);
        expect(inbox.single.kind, MockEmailKind.accountAlreadyExists);
        expect(inbox.single.code, isNull);
      },
    );

    test('zayıf şifre ve eksik onay reddedilir', () async {
      expect(
        (await post('auth/register', registration(pass: 'password1234'))).data,
        {'code': 'weak_password'},
      );
      final noConsent = registration()..['consents'] = {'acceptedTerms': true};
      expect((await post('auth/register', noConsent)).data, {
        'code': 'consent_required',
      });
    });

    test('doğrulanmamış adrese tekrar kayıt: son kayıt geçerli, '
        'başkası ele geçiremez', () async {
      // Adresi önce başkası kendi şifresiyle kaydeder.
      await post(
        'auth/register',
        registration(pass: 'kervansaray avlusunda gece'),
      );
      final firstCode = await lastCode(MockEmailKind.verificationCode);
      now = now.add(AuthMockApi.resendCooldown);
      await post('auth/register', {
        ...registration(),
        'displayName': 'Asıl Sahip',
      });
      final code = await lastCode(MockEmailKind.verificationCode);

      final stale = await post('auth/verify-email', {
        'email': email,
        'code': firstCode,
        'password': password,
      });
      expect(stale.data, {'code': 'invalid_code'});
      final weak = await post('auth/verify-email', {
        'email': email,
        'code': code,
        'password': '12345678',
      });
      expect(weak.data, {'code': 'weak_password'});
      final missing = await post('auth/verify-email', {
        'email': email,
        'code': code,
      });
      expect(missing.statusCode, 400);

      final verified = await post('auth/verify-email', {
        'email': email,
        'code': code,
        'password': password,
      });
      expect(verified.statusCode, 200);
      expect(
        (verified.data as Map<String, dynamic>)['user']['displayName'],
        'Asıl Sahip',
      );
      final attacker = await post('auth/login', {
        'email': email,
        'password': 'kervansaray avlusunda gece',
      });
      expect(attacker.data, {'code': 'invalid_credentials'});
      final owner = await post('auth/login', {
        'email': email,
        'password': password,
      });
      expect(owner.statusCode, 200);
    });

    test('5 hatalı denemeden sonra kod geçersizleşir', () async {
      await post('auth/register', registration());
      for (var attempt = 1; attempt < AuthMockApi.maxCodeAttempts; attempt++) {
        final wrong = await post('auth/verify-email', {
          'email': email,
          'code': '000000',
          'password': password,
        });
        expect(wrong.data, {'code': 'invalid_code'});
      }
      final last = await post('auth/verify-email', {
        'email': email,
        'code': '000000',
        'password': password,
      });
      expect(last.data, {'code': 'code_expired'});
    });

    test('kodun süresi 10 dakikada dolar', () async {
      await post('auth/register', registration());
      final code = await lastCode(MockEmailKind.verificationCode);
      now = now.add(AuthMockApi.codeLifetime);

      final response = await post('auth/verify-email', {
        'email': email,
        'code': code,
        'password': password,
      });
      expect(response.data, {'code': 'code_expired'});
    });

    test('yeniden gönderim bekleme süresine tabidir', () async {
      await post('auth/register', registration());

      final tooSoon = await post('auth/resend-verification', {'email': email});
      expect(tooSoon.statusCode, 429);
      expect((tooSoon.data as Map)['retryAfter'], 60);

      now = now.add(AuthMockApi.resendCooldown);
      final allowed = await post('auth/resend-verification', {'email': email});
      expect(allowed.statusCode, 202);
    });
  });

  group('giriş', () {
    test('bilinmeyen e-posta ve hatalı şifre aynı yanıtı verir', () async {
      await registerAndVerify();
      final unknown = await post('auth/login', {
        'email': 'yok@example.org',
        'password': password,
      });
      final wrong = await post('auth/login', {
        'email': email,
        'password': 'yanlış şifre burada',
      });
      expect(unknown.statusCode, wrong.statusCode);
      expect(unknown.data, wrong.data);
    });

    test('art arda 5 hatalı giriş hesabı 15 dakika kilitler', () async {
      await registerAndVerify();
      for (var i = 0; i < AuthMockApi.maxFailedLogins; i++) {
        await post('auth/login', {'email': email, 'password': 'yanlış'});
      }

      final locked = await post('auth/login', {
        'email': email,
        'password': password,
      });
      expect(locked.statusCode, 423);
      expect((locked.data as Map)['retryAfter'], 15 * 60);

      now = now.add(AuthMockApi.lockDuration);
      final unlocked = await post('auth/login', {
        'email': email,
        'password': password,
      });
      expect(unlocked.statusCode, 200);
    });
  });

  group('şifre sıfırlama', () {
    test(
      'kayıtlı olmayan adres için aynı yanıt döner, e-posta gitmez',
      () async {
        final response = await post('auth/password/forgot', {
          'email': 'yok@example.org',
        });
        expect(response.statusCode, 202);
        await Future<void>.delayed(Duration.zero);
        expect(inbox, isEmpty);
      },
    );

    test('zayıf yeni şifre kodu harcamaz; başarılı sıfırlama tüm oturumları '
        'kapatır', () async {
      final session = await registerAndVerify();
      await post('auth/password/forgot', {'email': email});
      final code = await lastCode(MockEmailKind.passwordResetCode);

      final weak = await post('auth/password/reset', {
        'email': email,
        'code': code,
        'newPassword': 'password1234',
      });
      expect(weak.data, {'code': 'weak_password'});

      final reset = await post('auth/password/reset', {
        'email': email,
        'code': code,
        'newPassword': newPassword,
      });
      expect(reset.statusCode, 204);

      final oldRefresh = await post('auth/refresh', {
        'refreshToken': session['refreshToken'],
      });
      expect(oldRefresh.statusCode, 401);
      expect(
        (await post('auth/login', {
          'email': email,
          'password': password,
        })).statusCode,
        401,
      );
      expect(
        (await post('auth/login', {
          'email': email,
          'password': newPassword,
        })).statusCode,
        200,
      );
    });
  });

  group('oturum açık kullanıcı', () {
    test(
      'şifre değişimi mevcut şifreyi doğrular ve yeni anahtar verir',
      () async {
        final session = await registerAndVerify();
        final token = session['accessToken'] as String;

        final wrong = await post('auth/password/change', {
          'currentPassword': 'yanlış',
          'newPassword': newPassword,
        }, token: token);
        expect(wrong.data, {'code': 'invalid_current_password'});

        final changed = await post('auth/password/change', {
          'currentPassword': password,
          'newPassword': newPassword,
        }, token: token);
        expect(changed.statusCode, 200);
        final fresh = changed.data as Map<String, dynamic>;

        final oldMe = await dio.get<dynamic>(
          'auth/me',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
        expect(oldMe.statusCode, 401);
        final newMe = await dio.get<dynamic>(
          'auth/me',
          options: Options(
            headers: {'Authorization': 'Bearer ${fresh['accessToken']}'},
          ),
        );
        expect(newMe.statusCode, 200);
      },
    );

    test('hesap silme şifreyle yeniden doğrulama ister', () async {
      final session = await registerAndVerify();
      final token = session['accessToken'] as String;

      final wrong = await dio.delete<dynamic>(
        'auth/account',
        data: {'password': 'yanlış'},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      expect(wrong.data, {'code': 'invalid_current_password'});

      final deleted = await dio.delete<dynamic>(
        'auth/account',
        data: {'password': password},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      expect(deleted.statusCode, 204);
      expect(
        (await post('auth/login', {
          'email': email,
          'password': password,
        })).statusCode,
        401,
      );
    });
  });

  test(
    'oluşturulan hesaplar depoda kalıcıdır, şifre düz metin tutulmaz',
    () async {
      await registerAndVerify();

      final users = await store.loadAll();
      expect(users[email]!.emailVerified, isTrue);
      expect(users[email]!.passwordHash, isNot(contains(password)));

      dio = buildDio();
      final login = await post('auth/login', {
        'email': email,
        'password': password,
      });
      expect(login.statusCode, 200);
    },
  );

  test('yasal metinler dil parametresine göre döner', () async {
    final tr = await dio.get<dynamic>('legal/documents/privacy-notice');
    final en = await dio.get<dynamic>(
      'legal/documents/terms-of-use',
      queryParameters: {'lang': 'en'},
    );
    final missing = await dio.get<dynamic>('legal/documents/unknown');

    expect((tr.data as Map)['title'], contains('Aydınlatma'));
    expect((en.data as Map)['title'], contains('Terms'));
    expect(missing.statusCode, 404);
  });
}
