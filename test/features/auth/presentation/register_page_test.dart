import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/a11y/haptic_feedback_service.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/app_theme.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/features/auth/domain/entities/legal_document.dart';
import 'package:vakif_atlas/features/auth/domain/entities/registration_data.dart';
import 'package:vakif_atlas/features/auth/domain/entities/verification_challenge.dart';
import 'package:vakif_atlas/features/auth/domain/usecases/auth_usecases.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/register_bloc.dart';
import 'package:vakif_atlas/features/auth/presentation/pending_verification.dart';
import 'package:vakif_atlas/features/auth/presentation/pages/register_page.dart';

class _MockRegister extends Mock implements RegisterUseCase {}

void main() {
  const email = 'zeynep@example.org';
  const password = 'kubbe altında bir gün';

  late _MockRegister register;
  late List<PendingVerification> registered;
  late List<LegalDocumentType> openedDocuments;

  setUpAll(
    () => registerFallbackValue(
      const RegistrationData(
        displayName: '',
        email: '',
        password: '',
        acceptedTerms: false,
        acknowledgedPrivacyNotice: false,
      ),
    ),
  );

  setUp(() {
    register = _MockRegister();
    registered = [];
    openedDocuments = [];
  });

  Future<void> pumpPage(
    WidgetTester tester, {
    double textScale = 1,
    Size size = const Size(390, 844),
  }) async {
    tester.view.physicalSize = size * tester.view.devicePixelRatio;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(
            value: A11yAnnouncer.withSender((_, _, _, _) async {}),
          ),
          RepositoryProvider.value(
            value: HapticFeedbackService.withDelay((_) async {}),
          ),
        ],
        child: BlocProvider(
          create: (_) => RegisterBloc(register),
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
            home: RegisterPage(
              onRegistered: (challenge) async {
                registered.add(challenge);
                return null;
              },
              onSignIn: () {},
              onOpenLegalDocument: openedDocuments.add,
            ),
          ),
        ),
      ),
    );
  }

  Finder scrollable() => find
      .descendant(
        of: find.byType(CustomScrollView),
        matching: find.byType(Scrollable),
      )
      .first;

  Future<void> tapKey(WidgetTester tester, String key) async {
    final target = find.byKey(Key(key));
    final position = tester.state<ScrollableState>(scrollable()).position;
    final viewport = tester.getRect(scrollable());
    final rect = tester.getRect(target);
    if (rect.bottom > viewport.bottom || rect.top < viewport.top) {
      position.jumpTo(
        (position.pixels + rect.center.dy - viewport.center.dy).clamp(
          0,
          position.maxScrollExtent,
        ),
      );
      await tester.pump();
    }
    await tester.tap(target);
    await tester.pump();
  }

  testWidgets('boş gönderimde tüm alan ve onay hataları gösterilir', (
    tester,
  ) async {
    await pumpPage(tester);

    await tapKey(tester, 'register_submit_button');

    expect(find.text('Adınızı ve soyadınızı girin.'), findsOneWidget);
    expect(find.text('E-posta adresinizi girin.'), findsOneWidget);
    expect(
      find.text("Devam etmek için Kullanım Koşulları'nı kabul etmelisiniz."),
      findsOneWidget,
    );
    verifyNever(() => register(any()));
  });

  testWidgets('şifre gücü ve yaygın şifre uyarısı gösterilir', (tester) async {
    await pumpPage(tester);

    await tester.enterText(
      find.byKey(const Key('register_password_field')),
      'Galatasaray1905!',
    );
    await tester.pump();
    expect(find.bySemanticsLabel('Şifre gücü: Zayıf'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('register_password_field')),
      'Kubbe-Minare 7 Kemer!',
    );
    await tester.pump();
    expect(find.bySemanticsLabel('Şifre gücü: Güçlü'), findsOneWidget);
  });

  testWidgets('geçerli form kayıt olur ve doğrulamaya geçer', (tester) async {
    const challenge = VerificationChallenge(
      email: email,
      resendAfter: Duration(seconds: 60),
    );
    when(() => register(any())).thenAnswer((_) async => const Right(challenge));
    await pumpPage(tester);

    await tester.enterText(
      find.byKey(const Key('register_name_field')),
      'Zeynep Karadağ',
    );
    await tester.enterText(
      find.byKey(const Key('register_email_field')),
      email,
    );
    await tester.enterText(
      find.byKey(const Key('register_password_field')),
      password,
    );
    await tester.enterText(
      find.byKey(const Key('register_password_confirm_field')),
      password,
    );
    await tapKey(tester, 'register_terms_checkbox');
    await tapKey(tester, 'register_privacy_checkbox');
    await tapKey(tester, 'register_submit_button');
    await tester.pumpAndSettle();

    expect(registered.single.challenge, challenge);
    // Şifre doğrulama ekranına bellekte taşınır (doğrulamada hesabın şifresi).
    expect(registered.single.password, password);
  });

  testWidgets('yasal metin bağlantıları ilgili belgeyi açar', (tester) async {
    await pumpPage(tester);

    await tapKey(tester, 'register_terms_read');
    await tapKey(tester, 'register_privacy_read');

    expect(openedDocuments, [
      LegalDocumentType.termsOfUse,
      LegalDocumentType.privacyNotice,
    ]);
  });

  testWidgets('%200 metin ölçeğinde dar ekranda taşma olmaz', (tester) async {
    await pumpPage(tester, textScale: 2, size: const Size(320, 640));
    await tapKey(tester, 'register_submit_button');
    expect(tester.takeException(), isNull);
  });

  testWidgets('erişilebilirlik kılavuzlarını karşılar', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpPage(tester);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    handle.dispose();
  });
}
