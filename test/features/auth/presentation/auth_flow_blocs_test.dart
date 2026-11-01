import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/features/auth/domain/entities/legal_document.dart';
import 'package:vakif_atlas/features/auth/domain/entities/registration_data.dart';
import 'package:vakif_atlas/features/auth/domain/entities/user_entity.dart';
import 'package:vakif_atlas/features/auth/domain/entities/verification_challenge.dart';
import 'package:vakif_atlas/features/auth/domain/usecases/auth_usecases.dart';
import 'package:vakif_atlas/features/auth/domain/validation/password_policy.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/account_blocs.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/form_status.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/register_bloc.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/verification_bloc.dart';
import 'package:vakif_atlas/features/auth/presentation/cubit/resend_cooldown_cubit.dart';
import 'package:vakif_atlas/features/auth/presentation/pending_verification.dart';

class _MockRegister extends Mock implements RegisterUseCase {}

class _MockVerify extends Mock implements VerifyEmailUseCase {}

class _MockResend extends Mock implements ResendVerificationCodeUseCase {}

class _MockRequestReset extends Mock implements RequestPasswordResetUseCase {}

class _MockReset extends Mock implements ResetPasswordUseCase {}

class _MockChange extends Mock implements ChangePasswordUseCase {}

class _MockDelete extends Mock implements DeleteAccountUseCase {}

class _MockLegal extends Mock implements GetLegalDocumentUseCase {}

void main() {
  const email = 'zeynep@example.org';
  const password = 'kubbe altında bir gün';
  const user = UserEntity(
    id: 'usr_1',
    displayName: 'Zeynep Karadağ',
    email: email,
  );
  const challenge = VerificationChallenge(
    email: email,
    resendAfter: Duration(seconds: 60),
  );

  setUpAll(() {
    registerFallbackValue(
      const RegistrationData(
        displayName: '',
        email: '',
        password: '',
        acceptedTerms: false,
        acknowledgedPrivacyNotice: false,
      ),
    );
    registerFallbackValue(
      const VerifyEmailParams(email: '', code: '', password: ''),
    );
    registerFallbackValue(
      const ResetPasswordParams(email: '', code: '', newPassword: ''),
    );
    registerFallbackValue(
      const ChangePasswordParams(currentPassword: '', newPassword: ''),
    );
    registerFallbackValue(
      const LegalDocumentParams(
        type: LegalDocumentType.termsOfUse,
        languageCode: 'tr',
      ),
    );
  });

  group('RegisterBloc', () {
    late _MockRegister register;

    setUp(() => register = _MockRegister());

    RegisterBloc fill(RegisterBloc bloc) => bloc
      ..add(const RegisterEvent.displayNameChanged('Zeynep Karadağ'))
      ..add(const RegisterEvent.emailChanged(email))
      ..add(const RegisterEvent.passwordChanged(password))
      ..add(const RegisterEvent.confirmationChanged(password))
      ..add(const RegisterEvent.termsChanged(accepted: true))
      ..add(const RegisterEvent.privacyNoticeChanged(acknowledged: true));

    test('şifre politikası ad/e-posta bağlamıyla değerlendirilir', () {
      const state = RegisterState(
        displayName: 'Zeynep Karadağ',
        email: email,
        password: 'zeynepkaradag2026',
      );
      expect(state.passwordError, PasswordPolicyViolation.personalInfo);
      expect(state.strength, PasswordStrength.weak);
    });

    test('durum şifre ve kişisel veriyi toString ile sızdırmaz', () {
      const state = RegisterState(email: email, password: password);
      expect(state.toString(), isNot(contains(password)));
      expect(state.toString(), isNot(contains(email)));
    });

    blocTest<RegisterBloc, RegisterState>(
      'onaylar verilmeden gönderilemez',
      build: () => RegisterBloc(register),
      act: (bloc) => bloc
        ..add(const RegisterEvent.displayNameChanged('Zeynep Karadağ'))
        ..add(const RegisterEvent.emailChanged(email))
        ..add(const RegisterEvent.passwordChanged(password))
        ..add(const RegisterEvent.confirmationChanged(password))
        ..add(const RegisterEvent.submitted()),
      verify: (bloc) {
        expect(bloc.state.status, FormStatus.invalid);
        verifyNever(() => register(any()));
      },
    );

    blocTest<RegisterBloc, RegisterState>(
      'geçerli form kodu ister ve challenge taşır',
      setUp: () =>
          when(() => register(any()))
              .thenAnswer((_) async => const Right(challenge)),
      build: () => RegisterBloc(register),
      act: (bloc) => fill(bloc).add(const RegisterEvent.submitted()),
      verify: (bloc) {
        expect(bloc.state.status, FormStatus.success);
        expect(bloc.state.challenge, challenge);
        verify(
          () => register(
            const RegistrationData(
              displayName: 'Zeynep Karadağ',
              email: email,
              password: password,
              acceptedTerms: true,
              acknowledgedPrivacyNotice: true,
            ),
          ),
        ).called(1);
      },
    );

    blocTest<RegisterBloc, RegisterState>(
      'sunucu zayıf şifre derse hata taşır',
      setUp: () => when(() => register(any())).thenAnswer(
        (_) async => const Left(AuthFailure(AuthFailureReason.weakPassword)),
      ),
      build: () => RegisterBloc(register),
      act: (bloc) => fill(bloc).add(const RegisterEvent.submitted()),
      verify: (bloc) => expect(
        bloc.state.failure,
        const AuthFailure(AuthFailureReason.weakPassword),
      ),
    );
  });

  group('VerifyEmailBloc', () {
    late _MockVerify verifyEmail;
    late _MockResend resendCode;

    setUp(() {
      verifyEmail = _MockVerify();
      resendCode = _MockResend();
    });

    VerifyEmailBloc build() => VerifyEmailBloc(
      verifyEmail,
      resendCode,
      const PendingVerification(
        challenge: challenge,
        password: 'kubbe altında bir gün',
      ),
    );

    blocTest<VerifyEmailBloc, VerifyEmailState>(
      'eksik kod gönderilmez',
      build: build,
      act: (bloc) => bloc
        ..add(const VerifyEmailEvent.codeChanged('123'))
        ..add(const VerifyEmailEvent.submitted()),
      verify: (bloc) {
        expect(bloc.state.status, FormStatus.invalid);
        verifyNever(() => verifyEmail(any()));
      },
    );

    blocTest<VerifyEmailBloc, VerifyEmailState>(
      'doğru kod kullanıcıyı döndürür',
      setUp: () =>
          when(() => verifyEmail(any()))
              .thenAnswer((_) async => const Right(user)),
      build: build,
      act: (bloc) => bloc
        ..add(const VerifyEmailEvent.codeChanged('123456'))
        ..add(const VerifyEmailEvent.submitted()),
      verify: (bloc) {
        expect(bloc.state.status, FormStatus.success);
        expect(bloc.state.user, user);
        verify(
          () => verifyEmail(
            const VerifyEmailParams(
              email: email,
              code: '123456',
              password: 'kubbe altında bir gün',
            ),
          ),
        ).called(1);
      },
    );

    blocTest<VerifyEmailBloc, VerifyEmailState>(
      'yeniden gönderim yeni bekleme süresini taşır',
      setUp: () =>
          when(() => resendCode(email))
              .thenAnswer((_) async => const Right(challenge)),
      build: build,
      act: (bloc) => bloc.add(const VerifyEmailEvent.resendRequested()),
      verify: (bloc) {
        expect(bloc.state.resendStatus, ResendStatus.sent);
        expect(bloc.state.resendAttempts, 1);
        expect(bloc.state.cooldown, const Duration(seconds: 60));
      },
    );

    blocTest<VerifyEmailBloc, VerifyEmailState>(
      'hız sınırında sunucunun bekleme süresi uygulanır',
      setUp: () => when(() => resendCode(email)).thenAnswer(
        (_) async => const Left(
          TooManyRequestsFailure(retryAfter: Duration(seconds: 42)),
        ),
      ),
      build: build,
      act: (bloc) => bloc.add(const VerifyEmailEvent.resendRequested()),
      verify: (bloc) {
        expect(bloc.state.resendStatus, ResendStatus.failure);
        expect(bloc.state.cooldown, const Duration(seconds: 42));
      },
    );
  });

  group('ResetPasswordBloc', () {
    late _MockReset reset;
    late _MockRequestReset requestReset;

    setUp(() {
      reset = _MockReset();
      requestReset = _MockRequestReset();
    });

    blocTest<ResetPasswordBloc, ResetPasswordState>(
      'kod ve politikaya uygun şifre ile sıfırlar',
      setUp: () =>
          when(() => reset(any())).thenAnswer((_) async => const Right(unit)),
      build: () => ResetPasswordBloc(reset, requestReset, challenge),
      act: (bloc) => bloc
        ..add(const ResetPasswordEvent.codeChanged('654321'))
        ..add(const ResetPasswordEvent.passwordChanged(password))
        ..add(const ResetPasswordEvent.confirmationChanged(password))
        ..add(const ResetPasswordEvent.submitted()),
      verify: (bloc) {
        expect(bloc.state.status, FormStatus.success);
        verify(
          () => reset(
            const ResetPasswordParams(
              email: email,
              code: '654321',
              newPassword: password,
            ),
          ),
        ).called(1);
      },
    );

    blocTest<ResetPasswordBloc, ResetPasswordState>(
      'şifreler eşleşmezse gönderilmez',
      build: () => ResetPasswordBloc(reset, requestReset, challenge),
      act: (bloc) => bloc
        ..add(const ResetPasswordEvent.codeChanged('654321'))
        ..add(const ResetPasswordEvent.passwordChanged(password))
        ..add(const ResetPasswordEvent.confirmationChanged('farklı şifre!!'))
        ..add(const ResetPasswordEvent.submitted()),
      verify: (bloc) {
        expect(bloc.state.status, FormStatus.invalid);
        verifyNever(() => reset(any()));
      },
    );
  });

  group('ForgotPasswordBloc', () {
    late _MockRequestReset requestReset;

    setUp(() => requestReset = _MockRequestReset());

    blocTest<ForgotPasswordBloc, ForgotPasswordState>(
      'geçerli e-posta için kod ister',
      setUp: () =>
          when(() => requestReset(email))
              .thenAnswer((_) async => const Right(challenge)),
      build: () => ForgotPasswordBloc(requestReset),
      act: (bloc) => bloc
        ..add(const ForgotPasswordEvent.emailChanged(email))
        ..add(const ForgotPasswordEvent.submitted()),
      verify: (bloc) => expect(bloc.state.challenge, challenge),
    );
  });

  group('ChangePasswordBloc', () {
    late _MockChange change;

    setUp(() => change = _MockChange());

    blocTest<ChangePasswordBloc, ChangePasswordState>(
      'yeni şifre mevcut şifreyle aynı olamaz',
      build: () => ChangePasswordBloc(change, user),
      act: (bloc) => bloc
        ..add(const ChangePasswordEvent.currentPasswordChanged(password))
        ..add(const ChangePasswordEvent.newPasswordChanged(password))
        ..add(const ChangePasswordEvent.confirmationChanged(password))
        ..add(const ChangePasswordEvent.submitted()),
      verify: (bloc) {
        expect(bloc.state.isSameAsCurrent, isTrue);
        expect(bloc.state.status, FormStatus.invalid);
        verifyNever(() => change(any()));
      },
    );

    blocTest<ChangePasswordBloc, ChangePasswordState>(
      'yeni şifre kullanıcının adını içeremez',
      build: () => ChangePasswordBloc(change, user),
      act: (bloc) => bloc
        ..add(const ChangePasswordEvent.newPasswordChanged('karadag-zeynep-9')),
      verify: (bloc) => expect(
        bloc.state.newPasswordError,
        PasswordPolicyViolation.personalInfo,
      ),
    );

    blocTest<ChangePasswordBloc, ChangePasswordState>(
      'başarıda şifreler durumdan temizlenir',
      setUp: () =>
          when(() => change(any())).thenAnswer((_) async => const Right(unit)),
      build: () => ChangePasswordBloc(change, user),
      act: (bloc) => bloc
        ..add(const ChangePasswordEvent.currentPasswordChanged('eski şifre 1'))
        ..add(const ChangePasswordEvent.newPasswordChanged(password))
        ..add(const ChangePasswordEvent.confirmationChanged(password))
        ..add(const ChangePasswordEvent.submitted()),
      verify: (bloc) {
        expect(bloc.state.status, FormStatus.success);
        expect(bloc.state.currentPassword, isEmpty);
        expect(bloc.state.newPassword, isEmpty);
      },
    );
  });

  group('DeleteAccountBloc', () {
    late _MockDelete delete;

    setUp(() => delete = _MockDelete());

    blocTest<DeleteAccountBloc, DeleteAccountState>(
      'açık onay olmadan silinmez',
      build: () => DeleteAccountBloc(delete),
      act: (bloc) => bloc
        ..add(const DeleteAccountEvent.passwordChanged(password))
        ..add(const DeleteAccountEvent.submitted()),
      verify: (bloc) {
        expect(bloc.state.status, FormStatus.invalid);
        verifyNever(() => delete(any()));
      },
    );

    blocTest<DeleteAccountBloc, DeleteAccountState>(
      'şifre ve onayla silinir',
      setUp: () =>
          when(() => delete(password))
              .thenAnswer((_) async => const Right(unit)),
      build: () => DeleteAccountBloc(delete),
      act: (bloc) => bloc
        ..add(const DeleteAccountEvent.passwordChanged(password))
        ..add(const DeleteAccountEvent.confirmationChanged(confirmed: true))
        ..add(const DeleteAccountEvent.submitted()),
      verify: (bloc) => expect(bloc.state.status, FormStatus.success),
    );
  });

  group('LegalDocumentCubit', () {
    late _MockLegal legal;
    final document = LegalDocument(
      type: LegalDocumentType.privacyNotice,
      version: '1.0',
      title: 'Aydınlatma Metni',
      body: 'Metin',
      effectiveDate: DateTime(2026, 10, 17),
    );

    setUp(() => legal = _MockLegal());

    blocTest<LegalDocumentCubit, LegalDocumentState>(
      'metni yükler',
      setUp: () =>
          when(() => legal(any())).thenAnswer((_) async => Right(document)),
      build: () => LegalDocumentCubit(legal),
      act: (cubit) =>
          cubit.load(LegalDocumentType.privacyNotice, languageCode: 'tr'),
      expect: () => [
        const LegalDocumentState.loading(),
        LegalDocumentState.loaded(document),
      ],
    );
  });

  group('ResendCooldownCubit', () {
    test('kalan süreyi saniye saniye yayınlar', () async {
      final ticks = StreamController<int>();
      final cubit = ResendCooldownCubit.withTicker((_) => ticks.stream);

      cubit.start(const Duration(milliseconds: 2500));
      expect(cubit.state, 3);
      expect(cubit.isCoolingDown, isTrue);

      ticks
        ..add(2)
        ..add(0);
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state, 0);
      expect(cubit.isCoolingDown, isFalse);

      await ticks.close();
      await cubit.close();
    });

    test('yeniden başlatma önceki sayacı iptal eder, yenisini korur', () async {
      final controllers = <StreamController<int>>[];
      final cubit = ResendCooldownCubit.withTicker((_) {
        final controller = StreamController<int>();
        controllers.add(controller);
        return controller.stream;
      });

      cubit.start(const Duration(seconds: 60));
      cubit.start(const Duration(seconds: 30));
      await Future<void>.delayed(Duration.zero);

      expect(controllers.first.hasListener, isFalse);
      expect(controllers.last.hasListener, isTrue);

      await cubit.close();
      expect(controllers.last.hasListener, isFalse);
      for (final controller in controllers) {
        await controller.close();
      }
    });

    testWidgets('varsayılan sayaç gerçek süreyle geri sayar', (tester) async {
      final cubit = ResendCooldownCubit()..start(const Duration(seconds: 3));
      expect(cubit.state, 3);

      await tester.pump(const Duration(seconds: 1));
      expect(cubit.state, 2);

      await tester.pump(const Duration(seconds: 2));
      expect(cubit.state, 0);

      // Uygulamada olduğu gibi (BlocProvider) kapanış beklenmeden tetiklenir;
      // testWidgets'ın sahte zaman bölgesinde `await close()` tamamlanmaz.
      // Kapanışta sayacın iptali ayrı (gerçek zamanlı) testte doğrulanır.
      unawaited(cubit.close());
      await tester.pump();
    });
  });
}
