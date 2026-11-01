import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/a11y/haptic_feedback_service.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/app_theme.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/features/auth/domain/entities/user_entity.dart';
import 'package:vakif_atlas/features/auth/domain/usecases/auth_usecases.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/login_bloc.dart';
import 'package:vakif_atlas/features/auth/presentation/pending_verification.dart';
import 'package:vakif_atlas/features/auth/presentation/pages/login_page.dart';

class _MockLogin extends Mock implements LoginUseCase {}

void main() {
  const user = UserEntity(
    id: 'usr_1',
    displayName: 'Ayşe Yılmaz',
    email: 'ayse@example.org',
  );

  late _MockLogin login;
  late List<(String, bool)> announcements;
  late int guestTaps;
  late int forgotTaps;
  late int createTaps;
  late List<PendingVerification> verificationRequests;

  setUpAll(
    () => registerFallbackValue(const LoginParams(email: '', password: '')),
  );

  setUp(() {
    login = _MockLogin();
    announcements = [];
    guestTaps = 0;
    forgotTaps = 0;
    createTaps = 0;
    verificationRequests = [];
  });

  Future<void> pumpLogin(
    WidgetTester tester, {
    bool showNotice = false,
    bool showResetNotice = false,
    double textScale = 1,
    Size size = const Size(390, 844),
  }) async {
    tester.view.physicalSize = size * tester.view.devicePixelRatio;
    addTearDown(tester.view.resetPhysicalSize);
    final announcer = A11yAnnouncer.withSender((
      _,
      message,
      _,
      assertiveness,
    ) async {
      announcements.add((message, assertiveness.name == 'assertive'));
    });
    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: announcer),
          RepositoryProvider.value(
            value: HapticFeedbackService.withDelay((_) async {}),
          ),
        ],
        child: BlocProvider(
          create: (_) => LoginBloc(login),
          child: MaterialApp(
            theme: AppTheme.dark(),
            locale: const Locale('tr'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(textScale)),
              child: child!,
            ),
            home: LoginPage(
              showLoginRequiredNotice: showNotice,
              showPasswordResetNotice: showResetNotice,
              onContinueAsGuest: () => guestTaps++,
              onForgotPassword: () => forgotTaps++,
              onCreateAccount: () => createTaps++,
              onVerificationRequired: verificationRequests.add,
            ),
          ),
        ),
      ),
    );
  }

  Finder pageScrollable() => find
      .descendant(
        of: find.byType(CustomScrollView),
        matching: find.byType(Scrollable),
      )
      .first;

  /// Form tek bir sliver içinde olduğundan `scrollUntilVisible` yerine sayfa
  /// kaydırıcısı doğrudan hedef öğeyi gösterecek konuma taşınır.
  Future<void> scrollTo(WidgetTester tester, Finder target) async {
    final position = tester.state<ScrollableState>(pageScrollable()).position;
    final viewport = tester.getRect(pageScrollable());
    final rect = tester.getRect(target);
    if (rect.bottom > viewport.bottom) {
      position.jumpTo(
        (position.pixels + rect.bottom - viewport.bottom).clamp(
          0,
          position.maxScrollExtent,
        ),
      );
      await tester.pump();
    }
  }

  Future<void> tapSubmit(WidgetTester tester) async {
    final submit = find.byKey(const Key('login_submit_button'));
    await scrollTo(tester, submit);
    await tester.tap(submit);
    await tester.pump();
  }

  testWidgets('boş gönderimde alan hataları gösterilir ve duyurulur', (
    tester,
  ) async {
    await pumpLogin(tester);

    await tapSubmit(tester);

    expect(find.text('E-posta adresinizi girin.'), findsOneWidget);
    expect(find.text('Şifrenizi girin.'), findsOneWidget);
    expect(
      announcements,
      contains(('Formda düzeltilmesi gereken alanlar var.', true)),
    );
    verifyNever(() => login(any()));
  });

  testWidgets('geçerli bilgilerle giriş başarıyla duyurulur', (tester) async {
    when(() => login(any())).thenAnswer((_) async => const Right(user));
    await pumpLogin(tester);

    await tester.enterText(
      find.byKey(const Key('login_email_field')),
      'ayse@example.org',
    );
    await tester.enterText(
      find.byKey(const Key('login_password_field')),
      'Atlas2026!',
    );
    await tapSubmit(tester);
    await tester.pumpAndSettle();

    verify(
      () => login(
        const LoginParams(email: 'ayse@example.org', password: 'Atlas2026!'),
      ),
    ).called(1);
    expect(
      announcements,
      contains(('Giriş yapıldı. Hoş geldiniz, Ayşe Yılmaz.', false)),
    );
  });

  testWidgets('hatalı kimlik bilgisinde hata mesajı gösterilir', (
    tester,
  ) async {
    when(() => login(any())).thenAnswer(
      (_) async =>
          const Left(AuthFailure(AuthFailureReason.invalidCredentials)),
    );
    await pumpLogin(tester);

    await tester.enterText(
      find.byKey(const Key('login_email_field')),
      'ayse@example.org',
    );
    await tester.enterText(
      find.byKey(const Key('login_password_field')),
      'yanlis-sifre',
    );
    await tapSubmit(tester);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('login_failure_message')), findsOneWidget);
    expect(announcements.last.$2, isTrue);
  });

  testWidgets('misafir olarak devam et geri çağrıyı tetikler', (tester) async {
    await pumpLogin(tester);

    final guest = find.byKey(const Key('login_continue_as_guest_button'));
    await scrollTo(tester, guest);
    await tester.tap(guest);

    expect(guestTaps, 1);
  });

  testWidgets('korumalı rotadan gelindiyse bilgilendirme gösterilir', (
    tester,
  ) async {
    await pumpLogin(tester, showNotice: true);
    expect(
      find.text('Bu bölümü kullanmak için giriş yapmanız gerekiyor.'),
      findsOneWidget,
    );
  });

  testWidgets('%200 metin ölçeğinde dar ekranda taşma olmaz', (tester) async {
    await pumpLogin(
      tester,
      showNotice: true,
      textScale: 2,
      size: const Size(320, 640),
    );
    await tapSubmit(tester);
    expect(tester.takeException(), isNull);
    expect(find.text('Şifrenizi girin.', skipOffstage: false), findsOneWidget);
  });

  testWidgets('şifremi unuttum ve hesap oluştur geri çağrıları', (
    tester,
  ) async {
    await pumpLogin(tester);

    await tester.tap(find.byKey(const Key('login_forgot_password_button')));
    final create = find.byKey(const Key('login_create_account_button'));
    await scrollTo(tester, create);
    await tester.tap(create);

    expect(forgotTaps, 1);
    expect(createTaps, 1);
  });

  testWidgets('doğrulanmamış hesapta doğrulama ekranı istenir', (tester) async {
    when(() => login(any())).thenAnswer(
      (_) async => const Left(AuthFailure(AuthFailureReason.emailNotVerified)),
    );
    await pumpLogin(tester);

    await tester.enterText(
      find.byKey(const Key('login_email_field')),
      ' Ayse@Example.org ',
    );
    await tester.enterText(
      find.byKey(const Key('login_password_field')),
      'Atlas2026!',
    );
    await tapSubmit(tester);
    await tester.pumpAndSettle();

    expect(verificationRequests.single.challenge.email, 'ayse@example.org');
    // Şifre doğrulama ekranına bellekte taşınır (doğrulamada hesabın şifresi).
    expect(verificationRequests.single.password, 'Atlas2026!');
  });

  testWidgets('şifre sıfırlama sonrası bilgilendirme gösterilir', (
    tester,
  ) async {
    await pumpLogin(tester, showResetNotice: true);
    expect(
      find.byKey(const Key('login_password_reset_notice')),
      findsOneWidget,
    );
  });

  testWidgets('erişilebilirlik kılavuzlarını karşılar', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLogin(tester);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    handle.dispose();
  });
}
