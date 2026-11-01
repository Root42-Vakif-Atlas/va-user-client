// Kimlik doğrulama akışları gerçek cihazda, gerçek backend'e karşı:
// kayıt → e-posta (Mailpit) → doğrulama, geri gezinme, e-postayı düzeltme,
// kopya kayıt, doğrulanmamış girişte yeniden gönderim, şifre sıfırlama.
// Her adımda uygulamanın kök hata yakalayıcısına düşen hata olmadığı denetlenir.
//
// Önkoşul: backend çalışıyor (compose). Android cihazda `adb reverse` ile
// tcp:8080, tcp:8333, tcp:8025:
//   flutter test integration_test/auth_flows_test.dart --flavor dev \
//     --dart-define-from-file=config/dev.json
// Web (Chrome; chromedriver --port=4444 açık):
//   flutter drive -d chrome --driver=test_driver/integration_test.dart \
//     --target=integration_test/auth_flows_test.dart \
//     --dart-define-from-file=config/dev.json
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:vakif_atlas/app.dart';
import 'package:vakif_atlas/bootstrap_sequence.dart';
import 'package:vakif_atlas/core/config/app_config.dart';
import 'package:vakif_atlas/core/config/app_environment.dart';
import 'package:vakif_atlas/core/di/injection.dart';
import 'package:vakif_atlas/core/router/app_router.dart';
import 'package:vakif_atlas/core/router/routes.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vakif_atlas/features/onboarding/domain/repositories/onboarding_repository.dart';

const String _mailpit = 'http://localhost:8025';
const String _password = 'kubbe altında bir gün';
const String _newPassword = 'çini desenli avlu kapısı';

// Tarayıcıda da çalışır (web: Mailpit `MP_API_CORS`, yalnızca yerel yığın).
final Dio _mailpitClient = Dio();

Future<Object?> _getJson(String url) async =>
    (await _mailpitClient.get<Object?>(url)).data;

/// [email]'e gelen e-postalar (eskiden yeniye): konu + kod.
Future<List<(String, String?)>> _mails(String email) async {
  final search = await _getJson(
    '$_mailpit/api/v1/search?query=${Uri.encodeQueryComponent('to:"$email"')}',
  ) as Map<String, dynamic>;
  final result = <(String, String?)>[];
  for (final message in (search['messages'] as List<dynamic>).reversed) {
    final detail = await _getJson(
      '$_mailpit/api/v1/message/${message['ID']}',
    ) as Map<String, dynamic>;
    final code = RegExp(r'\b(\d{6})\b')
        .firstMatch(detail['Text'] as String)
        ?.group(1);
    result.add((detail['Subject'] as String, code));
  }
  return result;
}

Future<List<(String, String?)>> _waitMails(String email, int count) async {
  for (var i = 0; i < 40; i++) {
    final mails = await _mails(email);
    if (mails.length >= count) {
      return mails;
    }
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }
  return _mails(email);
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final errors = <String>[];
  var booted = false;
  FlutterExceptionHandler? appHandler;

  Future<void> wait(WidgetTester tester, [int ms = 1500]) async {
    final end = DateTime.now().add(Duration(milliseconds: ms));
    while (DateTime.now().isBefore(end)) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      await tester.pump();
    }
  }

  String path() => getIt<AppRouter>().router.state.uri.path;

  Future<void> waitFor(WidgetTester tester, Finder finder) async {
    for (var i = 0; i < 100; i++) {
      if (finder.evaluate().isNotEmpty) {
        return;
      }
      await wait(tester, 100);
    }
    fail('Bulunamadı: $finder (konum: ${path()})');
  }

  Future<void> tapKey(WidgetTester tester, String key) async {
    final target = find.byKey(Key(key));
    await waitFor(tester, target);
    await tester.ensureVisible(target);
    await tester.pump();
    await tester.tap(target);
    await wait(tester);
  }

  Future<void> enter(WidgetTester tester, String key, String text) async {
    final target = find.byKey(Key(key));
    await waitFor(tester, target);
    await tester.ensureVisible(target);
    await tester.enterText(target, text);
    await tester.pump();
  }

  Future<void> toBackgroundAndBack(WidgetTester tester) async {
    for (final state in [
      AppLifecycleState.inactive,
      AppLifecycleState.hidden,
      AppLifecycleState.paused,
    ]) {
      tester.binding.handleAppLifecycleStateChanged(state);
      await wait(tester, 200);
    }
    await wait(tester, 1500);
    for (final state in [
      AppLifecycleState.hidden,
      AppLifecycleState.inactive,
      AppLifecycleState.resumed,
    ]) {
      tester.binding.handleAppLifecycleStateChanged(state);
      await wait(tester, 200);
    }
    await wait(tester);
  }

  /// Sistem geri tuşu (Android).
  Future<void> systemBack(WidgetTester tester) async {
    await tester.binding.handlePopRoute();
    await wait(tester);
  }

  void expectNoErrors(String step) {
    expect(errors, isEmpty, reason: 'Adım: $step');
  }

  Future<void> dismissCelebration(WidgetTester tester) async {
    final close = find.byKey(const Key('gamification_celebration_close'));
    for (var i = 0; i < 10 && close.evaluate().isEmpty; i++) {
      await wait(tester, 300);
    }
    if (close.evaluate().isNotEmpty) {
      await tester.tap(close);
      await wait(tester);
    }
  }

  Future<void> start(WidgetTester tester) async {
    // Test çerçevesinin hata yakalayıcısı her testin sonunda geri yüklenir;
    // arada uygulamanınki (log + telemetri) çalışır ve hatalar toplanır.
    final testHandler = FlutterError.onError;
    addTearDown(() => FlutterError.onError = testHandler);
    if (!booted) {
      final config = AppConfig.resolve(AppEnvironment.dev);
      await BootstrapSequence.standard(config).run();
      appHandler = FlutterError.onError;
      booted = true;
      await getIt<OnboardingRepository>().markCompleted();
    }
    FlutterError.onError = (details) {
      errors.add(details.exceptionAsString());
      appHandler?.call(details);
    };
    if (find.byType(VakifAtlasApp).evaluate().isEmpty) {
      await tester.pumpWidget(const VakifAtlasApp());
    }
    errors.clear();
    await wait(tester, 2500);
    if (getIt<AuthBloc>().state is AuthAuthenticated) {
      getIt<AuthBloc>().add(const AuthEvent.logoutRequested());
      await wait(tester, 2000);
    }
    getIt<AppRouter>().router.go(AppRoutes.login);
    await wait(tester);
    expect(path(), AppRoutes.login);
  }

  Future<void> fillRegister(
    WidgetTester tester,
    String email, {
    String password = _password,
  }) async {
    await enter(tester, 'register_name_field', 'Zeynep Karadağ');
    await enter(tester, 'register_email_field', email);
    await enter(tester, 'register_password_field', password);
    await enter(tester, 'register_password_confirm_field', password);
  }

  Future<void> acceptConsents(WidgetTester tester) async {
    await tapKey(tester, 'register_terms_checkbox');
    await tapKey(tester, 'register_privacy_checkbox');
  }

  String uniqueEmail(String tag) =>
      'device-$tag-${DateTime.now().millisecondsSinceEpoch}@example.org';

  testWidgets('kayıt → geri gezinme → e-postayı düzelt → doğrula', (
    tester,
  ) async {
    await start(tester);
    final typo = uniqueEmail('typo').replaceFirst('example', 'exmaple');
    final email = uniqueEmail('reg');

    await tapKey(tester, 'login_create_account_button');
    expect(path(), AppRoutes.register);
    await fillRegister(tester, typo);
    await acceptConsents(tester);
    await tapKey(tester, 'register_submit_button');
    await wait(tester, 2500);
    expect(path(), AppRoutes.verifyEmail);
    expectNoErrors('kayıt gönderildi');

    // Sistem geri: kayıt formuna döner, bilgiler korunur.
    await systemBack(tester);
    expect(path(), AppRoutes.register);
    expectNoErrors('doğrulamadan sistem geri');
    await tapKey(tester, 'register_submit_button');
    await wait(tester, 2500);
    expect(path(), AppRoutes.verifyEmail);

    // AppBar geri.
    await tester.tap(find.byType(BackButton).last);
    await wait(tester);
    expect(path(), AppRoutes.register);
    expectNoErrors('doğrulamadan AppBar geri');
    await tapKey(tester, 'register_submit_button');
    await wait(tester, 2500);

    // "E-posta adresini değiştir".
    await tapKey(tester, 'verify_change_email_button');
    expect(path(), AppRoutes.register);
    await enter(tester, 'register_email_field', email);
    await tapKey(tester, 'register_submit_button');
    await wait(tester, 2500);
    expect(path(), AppRoutes.verifyEmail);
    expect(find.textContaining(email), findsOneWidget);
    expectNoErrors('e-posta düzeltildi');

    final mails = await _waitMails(email, 1);
    expect(mails, hasLength(1));
    expect((await _mails(typo)), hasLength(1));

    await enter(tester, 'verification_code_field', '000000');
    await tapKey(tester, 'verify_submit_button');
    await wait(tester, 2000);
    expect(find.byKey(const Key('verify_failure_message')), findsOneWidget);

    // Uygulamayı arka plana alıp döndürme (e-postaya bakma); geçişler
    // platformun sırasıyla.
    await toBackgroundAndBack(tester);
    expect(path(), AppRoutes.verifyEmail);
    expectNoErrors('arka plandan dönüş');

    await enter(tester, 'verification_code_field', mails.last.$2!);
    await tapKey(tester, 'verify_submit_button');
    await wait(tester, 3000);
    await dismissCelebration(tester);
    expect(getIt<AuthBloc>().state, isA<AuthAuthenticated>());
    expect(path(), AppRoutes.mapDiscovery);
    expectNoErrors('doğrulandı');

    // Doğrulamadan sonra açılan sayfadan geri (profil → harita).
    unawaited(getIt<AppRouter>().router.push(AppRoutes.profile));
    await wait(tester);
    await systemBack(tester);
    expect(path(), AppRoutes.mapDiscovery);
    expectNoErrors('profilden geri');
  });

  testWidgets('kopya kayıt aynı yanıtı verir; eski şifre geçerli kalır', (
    tester,
  ) async {
    await start(tester);
    final email = uniqueEmail('dup');
    await tapKey(tester, 'login_create_account_button');
    await fillRegister(tester, email);
    await acceptConsents(tester);
    await tapKey(tester, 'register_submit_button');
    await wait(tester, 2500);
    final mails = await _waitMails(email, 1);
    await enter(tester, 'verification_code_field', mails.last.$2!);
    await tapKey(tester, 'verify_submit_button');
    await wait(tester, 3000);
    await dismissCelebration(tester);
    expect(getIt<AuthBloc>().state, isA<AuthAuthenticated>());

    getIt<AuthBloc>().add(const AuthEvent.logoutRequested());
    await wait(tester, 2000);
    getIt<AppRouter>().router.go(AppRoutes.register);
    await wait(tester);
    await fillRegister(tester, email, password: _newPassword);
    await acceptConsents(tester);
    await tapKey(tester, 'register_submit_button');
    await wait(tester, 2500);
    // Hesabın varlığı açığa vurulmaz: yine doğrulama ekranı.
    expect(path(), AppRoutes.verifyEmail);
    expectNoErrors('kopya kayıt');

    getIt<AppRouter>().router.go(AppRoutes.login);
    await wait(tester);
    await enter(tester, 'login_email_field', email);
    await enter(tester, 'login_password_field', _newPassword);
    await tapKey(tester, 'login_submit_button');
    await wait(tester, 2500);
    expect(find.byKey(const Key('login_failure_message')), findsOneWidget);
    await enter(tester, 'login_password_field', _password);
    await tapKey(tester, 'login_submit_button');
    await wait(tester, 3000);
    await dismissCelebration(tester);
    expect(getIt<AuthBloc>().state, isA<AuthAuthenticated>());
    expect(path(), AppRoutes.mapDiscovery);
    expectNoErrors('kopya kayıttan sonra giriş');
  });

  testWidgets('doğrulanmamış giriş → bekleme → kodu tekrar gönder', (
    tester,
  ) async {
    await start(tester);
    final email = uniqueEmail('resend');
    await tapKey(tester, 'login_create_account_button');
    await fillRegister(tester, email);
    await acceptConsents(tester);
    await tapKey(tester, 'register_submit_button');
    await wait(tester, 2500);
    await _waitMails(email, 1);

    // Uygulamadan çıkıp daha sonra girişle devam eder.
    getIt<AppRouter>().router.go(AppRoutes.login);
    await wait(tester);
    await enter(tester, 'login_email_field', email);
    await enter(tester, 'login_password_field', _password);
    await tapKey(tester, 'login_submit_button');
    await wait(tester, 2500);
    expect(path(), AppRoutes.verifyEmail);
    final resend = find.descendant(
      of: find.byKey(const Key('resend_code_button')),
      matching: find.byType(TextButton),
    );
    expect(tester.widget<TextButton>(resend).onPressed, isNull);

    await wait(tester, 62000);
    expect(tester.widget<TextButton>(resend).onPressed, isNotNull);
    await tapKey(tester, 'resend_code_button');
    await wait(tester, 2000);
    final mails = await _waitMails(email, 2);
    expect(mails, hasLength(2));
    expect(find.byKey(const Key('verify_failure_message')), findsNothing);

    // Eski kod geçersiz, yenisi geçerli.
    await enter(tester, 'verification_code_field', mails.first.$2!);
    await tapKey(tester, 'verify_submit_button');
    await wait(tester, 2000);
    if (mails.first.$2 != mails.last.$2) {
      expect(find.byKey(const Key('verify_failure_message')), findsOneWidget);
    }
    await enter(tester, 'verification_code_field', mails.last.$2!);
    await tapKey(tester, 'verify_submit_button');
    await wait(tester, 3000);
    await dismissCelebration(tester);
    expect(getIt<AuthBloc>().state, isA<AuthAuthenticated>());
    expectNoErrors('yeniden gönderilen kodla doğrulandı');
  });

  testWidgets('şifremi unuttum → kod → yeni şifreyle giriş', (tester) async {
    await start(tester);
    final email = uniqueEmail('reset');
    await tapKey(tester, 'login_create_account_button');
    await fillRegister(tester, email);
    await acceptConsents(tester);
    await tapKey(tester, 'register_submit_button');
    await wait(tester, 2500);
    var mails = await _waitMails(email, 1);
    await enter(tester, 'verification_code_field', mails.last.$2!);
    await tapKey(tester, 'verify_submit_button');
    await wait(tester, 3000);
    await dismissCelebration(tester);
    getIt<AuthBloc>().add(const AuthEvent.logoutRequested());
    await wait(tester, 2000);

    getIt<AppRouter>().router.go(AppRoutes.login);
    await wait(tester);
    await tapKey(tester, 'login_forgot_password_button');
    await enter(tester, 'forgot_email_field', email);
    await tapKey(tester, 'forgot_submit_button');
    await wait(tester, 2500);
    expect(path(), AppRoutes.resetPassword);
    mails = await _waitMails(email, 2);
    expect(mails.last.$1, 'Vakıf Atlas şifre sıfırlama');

    await systemBack(tester);
    expectNoErrors('sıfırlama ekranından geri');
    getIt<AppRouter>().router.go(AppRoutes.login);
    await wait(tester);
    await tapKey(tester, 'login_forgot_password_button');
    await enter(tester, 'forgot_email_field', email);
    await tapKey(tester, 'forgot_submit_button');
    await wait(tester, 2500);
    // Bekleme süresinde tekrar istek: hata gösterilir, ekran açılmaz.
    expectNoErrors('bekleme içinde tekrar sıfırlama');

    if (path() != AppRoutes.resetPassword) {
      await wait(tester, 62000);
      await tapKey(tester, 'forgot_submit_button');
      await wait(tester, 2500);
      mails = await _waitMails(email, 3);
    }
    expect(path(), AppRoutes.resetPassword);
    await enter(tester, 'verification_code_field', mails.last.$2!);
    await enter(tester, 'reset_password_field', _newPassword);
    await enter(tester, 'reset_password_confirm_field', _newPassword);
    await tapKey(tester, 'reset_submit_button');
    await wait(tester, 2500);
    expect(path(), AppRoutes.login);
    expect(
      find.byKey(const Key('login_password_reset_notice')),
      findsOneWidget,
    );

    await enter(tester, 'login_email_field', email);
    await enter(tester, 'login_password_field', _newPassword);
    await tapKey(tester, 'login_submit_button');
    await wait(tester, 3000);
    await dismissCelebration(tester);
    expect(getIt<AuthBloc>().state, isA<AuthAuthenticated>());
    expectNoErrors('yeni şifreyle giriş');
  });
}
