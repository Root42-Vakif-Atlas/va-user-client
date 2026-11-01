import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/di/injection.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/usecase/usecase.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/features/auth/data/sources/auth_remote_data_source.dart';
import 'package:vakif_atlas/features/auth/domain/entities/auth_session_event.dart';
import 'package:vakif_atlas/features/auth/domain/entities/legal_document.dart';
import 'package:vakif_atlas/features/auth/domain/entities/registration_data.dart';
import 'package:vakif_atlas/features/auth/domain/entities/user_entity.dart';
import 'package:vakif_atlas/features/auth/domain/repositories/auth_repository.dart';
import 'package:vakif_atlas/features/auth/domain/usecases/auth_usecases.dart';

import '../../../helpers/test_di.dart';
import '../../../support/mock_api/mock_mailbox.dart';

/// Gerçek DI grafiği (repository → Dio → interceptor'lar → Mock API) ile
/// hesabın tüm yaşam döngüsü.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const email = 'zeynep@example.org';
  const password = 'kubbe altında bir gün';
  const newPassword = 'çini desenli avlu kapısı';

  late TestDependencies dependencies;
  late List<MockEmail> inbox;
  late List<AuthSessionEvent> events;

  setUp(() async {
    dependencies = await TestDependencies.setUp();
    inbox = [];
    events = [];
    getIt<MockMailbox>().emails.listen(inbox.add);
    getIt<AuthRepository>().sessionEvents.listen(events.add);
  });

  tearDown(resetDependencies);

  Future<String> lastCode() async {
    await Future<void>.delayed(Duration.zero);
    return inbox.last.code!;
  }

  Future<UserEntity> registerAndVerify() async {
    final challenge = await getIt<RegisterUseCase>()(
      const RegistrationData(
        displayName: '  Zeynep   Karadağ ',
        email: ' Zeynep@Example.org ',
        password: password,
        acceptedTerms: true,
        acknowledgedPrivacyNotice: true,
      ),
    );
    expect(challenge.getOrNull()?.email, email);
    expect(challenge.getOrNull()?.resendAfter, const Duration(seconds: 60));

    final verified = await getIt<VerifyEmailUseCase>()(
      VerifyEmailParams(
        email: email,
        code: await lastCode(),
        password: password,
      ),
    );
    return verified.getOrNull()!;
  }

  test('kayıt → doğrulama oturum açar ve ad normalize edilir', () async {
    final user = await registerAndVerify();

    expect(user.displayName, 'Zeynep Karadağ');
    await Future<void>.delayed(Duration.zero);
    expect(events.last, SignedIn(user));
    expect(dependencies.secureStorage.values, contains('auth.refresh_token'));
  });

  test('doğrulanmamış hesapla giriş emailNotVerified döner', () async {
    await getIt<RegisterUseCase>()(
      const RegistrationData(
        displayName: 'Zeynep Karadağ',
        email: email,
        password: password,
        acceptedTerms: true,
        acknowledgedPrivacyNotice: true,
      ),
    );

    final login = await getIt<LoginUseCase>()(
      const LoginParams(email: email, password: password),
    );

    expect(
      login,
      const Left<Failure, UserEntity>(
        AuthFailure(
          AuthFailureReason.emailNotVerified,
          retryAfter: Duration(seconds: 60),
        ),
      ),
    );
  });

  test('şifre değişimi bu cihazda oturumu korur', () async {
    await registerAndVerify();

    final changed = await getIt<ChangePasswordUseCase>()(
      const ChangePasswordParams(
        currentPassword: password,
        newPassword: newPassword,
      ),
    );

    expect(changed, const Right<Failure, Unit>(unit));
    final me = await getIt<AuthRemoteDataSource>().fetchCurrentUser();
    expect(me.email, email);
  });

  test('hatalı mevcut şifre invalidCurrentPassword döner', () async {
    await registerAndVerify();

    final changed = await getIt<ChangePasswordUseCase>()(
      const ChangePasswordParams(
        currentPassword: 'yanlış şifre',
        newPassword: newPassword,
      ),
    );

    expect(
      changed,
      const Left<Failure, Unit>(
        AuthFailure(AuthFailureReason.invalidCurrentPassword),
      ),
    );
  });

  test('şifre sıfırlama → eski şifre geçersiz, yeni şifreyle giriş', () async {
    await registerAndVerify();
    await getIt<LogoutUseCase>()(const NoParams());

    final challenge = await getIt<RequestPasswordResetUseCase>()(email);
    expect(challenge.isRight, isTrue);
    final reset = await getIt<ResetPasswordUseCase>()(
      ResetPasswordParams(
        email: email,
        code: await lastCode(),
        newPassword: newPassword,
      ),
    );
    expect(reset, const Right<Failure, Unit>(unit));

    final oldLogin = await getIt<LoginUseCase>()(
      const LoginParams(email: email, password: password),
    );
    expect(oldLogin.isLeft, isTrue);
    final newLogin = await getIt<LoginUseCase>()(
      const LoginParams(email: email, password: newPassword),
    );
    expect(newLogin.isRight, isTrue);
  });

  test(
    'yeniden gönderim bekleme süresi TooManyRequestsFailure döner',
    () async {
      await getIt<RequestPasswordResetUseCase>()(email);

      final again = await getIt<RequestPasswordResetUseCase>()(email);

      expect(
        again,
        const Left<Failure, Object>(
          TooManyRequestsFailure(retryAfter: Duration(seconds: 60)),
        ),
      );
    },
  );

  test('hesap silme oturumu kapatır ve AccountDeleted yayınlar', () async {
    await registerAndVerify();

    final deleted = await getIt<DeleteAccountUseCase>()(password);

    expect(deleted, const Right<Failure, Unit>(unit));
    await Future<void>.delayed(Duration.zero);
    expect(
      events.last,
      isA<AccountDeleted>().having((e) => e.userId, 'userId', isNotEmpty),
    );
    expect(
      dependencies.secureStorage.values.containsKey('auth.refresh_token'),
      isFalse,
    );
  });

  test('yasal metin dile göre alınır', () async {
    final document = await getIt<GetLegalDocumentUseCase>()(
      const LegalDocumentParams(
        type: LegalDocumentType.privacyNotice,
        languageCode: 'en',
      ),
    );

    expect(document.getOrNull()?.title, contains('Privacy'));
    expect(document.getOrNull()?.version, isNotEmpty);
  });
}
