import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/app.dart';
import 'package:vakif_atlas/core/di/injection.dart';
import 'package:vakif_atlas/core/router/app_router.dart';
import 'package:vakif_atlas/core/router/routes.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/auth_bloc.dart';

import '../../helpers/test_di.dart';
import '../../support/mock_api/auth/auth_mock_api.dart';
import '../../support/mock_api/mock_mailbox.dart';

/// Gerçek uygulama + Mock API ile kullanıcı arayüzü üzerinden uçtan uca
/// hesap akışları.
void main() {
  late List<MockEmail> inbox;

  tearDown(resetDependencies);

  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize =
        const Size(390, 1600) * tester.view.devicePixelRatio;
    addTearDown(tester.view.resetPhysicalSize);
    await TestDependencies.setUp(preferences: {'settings.language_code': 'tr'});
    inbox = [];
    getIt<MockMailbox>().emails.listen(inbox.add);
    getIt<AuthBloc>().add(const AuthEvent.started());
    await tester.pumpWidget(const VakifAtlasApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
  }

  Future<void> go(WidgetTester tester, String location) async {
    getIt<AppRouter>().router.go(location);
    await tester.pumpAndSettle();
  }

  String currentPath() => getIt<AppRouter>().router.state.uri.path;

  Future<void> tapKey(WidgetTester tester, String key) async {
    final target = find.byKey(Key(key));
    await tester.ensureVisible(target);
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  Future<void> enter(WidgetTester tester, String key, String text) =>
      tester.enterText(find.byKey(Key(key)), text);

  testWidgets('girişten hesap oluştur → e-posta doğrula → oturum açık', (
    tester,
  ) async {
    await pumpApp(tester);
    await go(tester, AppRoutes.login);

    await tapKey(tester, 'login_create_account_button');
    expect(currentPath(), AppRoutes.register);

    await enter(tester, 'register_name_field', 'Zeynep Karadağ');
    await enter(tester, 'register_email_field', 'zeynep@example.org');
    await enter(tester, 'register_password_field', 'kubbe altında bir gün');
    await enter(
      tester,
      'register_password_confirm_field',
      'kubbe altında bir gün',
    );
    await tapKey(tester, 'register_terms_checkbox');
    await tapKey(tester, 'register_privacy_checkbox');
    await tapKey(tester, 'register_submit_button');

    expect(currentPath(), AppRoutes.verifyEmail);
    final code = inbox.last.code!;

    await enter(tester, 'verification_code_field', code);
    await tapKey(tester, 'verify_submit_button');

    expect(getIt<AuthBloc>().state, isA<AuthAuthenticated>());
    expect(currentPath(), AppRoutes.mapDiscovery);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('hesap menüsünden giriş → kayıt → doğrulama → haritaya dönülür', (
    tester,
  ) async {
    // Giriş, kayıt ve doğrulama haritanın üstünde `push` ile açılır;
    // GoRouter'ın yenileme yönlendirmesi alttaki haritayı değerlendirdiği
    // için doğrulama sonrası ekran yerinde kalıyordu.
    await pumpApp(tester);
    expect(currentPath(), AppRoutes.mapDiscovery);

    await tapKey(tester, 'map_account_button');
    await tapKey(tester, 'account_menu_sign_in');
    expect(currentPath(), AppRoutes.login);
    await tapKey(tester, 'login_create_account_button');

    await enter(tester, 'register_name_field', 'Zeynep Karadağ');
    await enter(tester, 'register_email_field', 'zeynep@example.org');
    await enter(tester, 'register_password_field', 'kubbe altında bir gün');
    await enter(
      tester,
      'register_password_confirm_field',
      'kubbe altında bir gün',
    );
    await tapKey(tester, 'register_terms_checkbox');
    await tapKey(tester, 'register_privacy_checkbox');
    await tapKey(tester, 'register_submit_button');
    expect(currentPath(), AppRoutes.verifyEmail);

    await enter(tester, 'verification_code_field', inbox.last.code!);
    await tapKey(tester, 'verify_submit_button');

    expect(getIt<AuthBloc>().state, isA<AuthAuthenticated>());
    expect(currentPath(), AppRoutes.mapDiscovery);
    expect(find.byKey(const Key('verify_submit_button')), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('doğrulama ekranında yönlendirme yenilenince ekran çökmez', (
    tester,
  ) async {
    await pumpApp(tester);
    await go(tester, AppRoutes.register);

    await enter(tester, 'register_name_field', 'Zeynep Karadağ');
    await enter(tester, 'register_email_field', 'zeynep@example.org');
    await enter(tester, 'register_password_field', 'kubbe altında bir gün');
    await enter(
      tester,
      'register_password_confirm_field',
      'kubbe altında bir gün',
    );
    await tapKey(tester, 'register_terms_checkbox');
    await tapKey(tester, 'register_privacy_checkbox');
    await tapKey(tester, 'register_submit_button');
    expect(currentPath(), AppRoutes.verifyEmail);

    // GoRouter yenilemede raporlanan (kodlanmış) konumu yeniden ayrıştırır;
    // `extra` kodlayıcısı olmadan doğrulama bilgisi düşüp sayfa
    // "Null check operator" ile çöküyordu.
    getIt<AppRouter>().router.refresh();
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(currentPath(), AppRoutes.verifyEmail);
    expect(find.textContaining('zeynep@example.org'), findsOneWidget);

    await enter(tester, 'verification_code_field', inbox.last.code!);
    await tapKey(tester, 'verify_submit_button');

    expect(getIt<AuthBloc>().state, isA<AuthAuthenticated>());
    expect(currentPath(), AppRoutes.mapDiscovery);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('doğrulama kodu bekleme süresinden sonra tekrar gönderilir', (
    tester,
  ) async {
    var now = DateTime(2026, 10, 21, 12);
    tester.view.physicalSize =
        const Size(390, 1600) * tester.view.devicePixelRatio;
    addTearDown(tester.view.resetPhysicalSize);
    await TestDependencies.setUp(
      preferences: {'settings.language_code': 'tr'},
      authClock: () => now,
    );
    inbox = [];
    getIt<MockMailbox>().emails.listen(inbox.add);
    getIt<AuthBloc>().add(const AuthEvent.started());
    await tester.pumpWidget(const VakifAtlasApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    await go(tester, AppRoutes.register);

    await enter(tester, 'register_name_field', 'Zeynep Karadağ');
    await enter(tester, 'register_email_field', 'zeynep@example.org');
    await enter(tester, 'register_password_field', 'kubbe altında bir gün');
    await enter(
      tester,
      'register_password_confirm_field',
      'kubbe altında bir gün',
    );
    await tapKey(tester, 'register_terms_checkbox');
    await tapKey(tester, 'register_privacy_checkbox');
    await tapKey(tester, 'register_submit_button');
    expect(currentPath(), AppRoutes.verifyEmail);
    expect(inbox, hasLength(1));

    now = now.add(const Duration(seconds: 61));
    await tester.pump(const Duration(seconds: 61));
    await tester.pumpAndSettle();
    await tapKey(tester, 'resend_code_button');

    expect(tester.takeException(), isNull);
    expect(inbox, hasLength(2));
    expect(inbox.last.to, 'zeynep@example.org');

    await enter(tester, 'verification_code_field', inbox.last.code!);
    await tapKey(tester, 'verify_submit_button');
    expect(getIt<AuthBloc>().state, isA<AuthAuthenticated>());

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets(
    'doğrulanmamış hesapla giriş: tekrar gönder sunucunun bekleme süresiyle '
    'başlar',
    (tester) async {
      var now = DateTime(2026, 10, 21, 12);
      tester.view.physicalSize =
          const Size(390, 1600) * tester.view.devicePixelRatio;
      addTearDown(tester.view.resetPhysicalSize);
      await TestDependencies.setUp(
        preferences: {'settings.language_code': 'tr'},
        authClock: () => now,
      );
      inbox = [];
      getIt<MockMailbox>().emails.listen(inbox.add);
      getIt<AuthBloc>().add(const AuthEvent.started());
      await tester.pumpWidget(const VakifAtlasApp());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      // Kayıt olup doğrulamadan çıkan kullanıcı daha sonra giriş yapar.
      await go(tester, AppRoutes.register);
      await enter(tester, 'register_name_field', 'Zeynep Karadağ');
      await enter(tester, 'register_email_field', 'zeynep@example.org');
      await enter(tester, 'register_password_field', 'kubbe altında bir gün');
      await enter(
        tester,
        'register_password_confirm_field',
        'kubbe altında bir gün',
      );
      await tapKey(tester, 'register_terms_checkbox');
      await tapKey(tester, 'register_privacy_checkbox');
      await tapKey(tester, 'register_submit_button');
      expect(inbox, hasLength(1));

      now = now.add(const Duration(minutes: 5));
      await go(tester, AppRoutes.login);
      await enter(tester, 'login_email_field', 'zeynep@example.org');
      await enter(tester, 'login_password_field', 'kubbe altında bir gün');
      await tapKey(tester, 'login_submit_button');
      expect(currentPath(), AppRoutes.verifyEmail);
      // Giriş yeni kod gönderdi ve sunucuda bekleme başladı: buton hemen
      // etkin olsaydı basınca 429 dönüp "gönderilmedi" gibi görünüyordu.
      expect(inbox, hasLength(2));
      final resend = find.descendant(
        of: find.byKey(const Key('resend_code_button')),
        matching: find.byType(TextButton),
      );
      expect(tester.widget<TextButton>(resend).onPressed, isNull);

      now = now.add(const Duration(seconds: 61));
      await tester.pump(const Duration(seconds: 61));
      await tester.pumpAndSettle();
      await tapKey(tester, 'resend_code_button');
      expect(inbox, hasLength(3));

      await enter(tester, 'verification_code_field', inbox.last.code!);
      await tapKey(tester, 'verify_submit_button');
      expect(getIt<AuthBloc>().state, isA<AuthAuthenticated>());

      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('doğrulama ekranından yanlış e-posta düzeltilir; form korunur', (
    tester,
  ) async {
    const password = 'kubbe altında bir gün';
    await pumpApp(tester);
    await go(tester, AppRoutes.login);
    await tapKey(tester, 'login_create_account_button');

    await enter(tester, 'register_name_field', 'Zeynep Karadağ');
    await enter(tester, 'register_email_field', 'zeynep@exmaple.org');
    await enter(tester, 'register_password_field', password);
    await enter(tester, 'register_password_confirm_field', password);
    await tapKey(tester, 'register_terms_checkbox');
    await tapKey(tester, 'register_privacy_checkbox');
    await tapKey(tester, 'register_submit_button');
    expect(currentPath(), AppRoutes.verifyEmail);
    expect(find.textContaining('zeynep@exmaple.org'), findsOneWidget);

    await tapKey(tester, 'verify_change_email_button');

    // Kayıt formuna dönülür; girilen bilgiler durur, odak e-posta alanında.
    expect(currentPath(), AppRoutes.register);
    final emailField = find.descendant(
      of: find.byKey(const Key('register_email_field')),
      matching: find.byType(EditableText),
    );
    expect(
      tester.widget<EditableText>(emailField).controller.text,
      'zeynep@exmaple.org',
    );
    expect(tester.widget<EditableText>(emailField).focusNode.hasFocus, isTrue);

    await enter(tester, 'register_email_field', 'zeynep@example.org');
    await tapKey(tester, 'register_submit_button');
    expect(currentPath(), AppRoutes.verifyEmail);
    expect(find.textContaining('zeynep@example.org'), findsOneWidget);
    expect(inbox.last.to, 'zeynep@example.org');

    await enter(tester, 'verification_code_field', inbox.last.code!);
    await tapKey(tester, 'verify_submit_button');

    expect(getIt<AuthBloc>().state, isA<AuthAuthenticated>());
    expect(currentPath(), AppRoutes.mapDiscovery);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('şifremi unuttum → kodla sıfırla → yeni şifreyle giriş', (
    tester,
  ) async {
    const newPassword = 'çini desenli avlu kapısı';
    await pumpApp(tester);
    await go(tester, AppRoutes.login);

    await tapKey(tester, 'login_forgot_password_button');
    await enter(tester, 'forgot_email_field', AuthMockApi.demoEmail);
    await tapKey(tester, 'forgot_submit_button');
    expect(currentPath(), AppRoutes.resetPassword);

    await enter(tester, 'verification_code_field', inbox.last.code!);
    await enter(tester, 'reset_password_field', newPassword);
    await enter(tester, 'reset_password_confirm_field', newPassword);
    await tapKey(tester, 'reset_submit_button');

    expect(currentPath(), AppRoutes.login);
    expect(
      find.byKey(const Key('login_password_reset_notice')),
      findsOneWidget,
    );

    await enter(tester, 'login_email_field', AuthMockApi.demoEmail);
    await enter(tester, 'login_password_field', newPassword);
    await tapKey(tester, 'login_submit_button');

    expect(getIt<AuthBloc>().state, isA<AuthAuthenticated>());
    expect(currentPath(), AppRoutes.mapDiscovery);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('profil → hesabı sil → misafir olarak ana sayfa', (tester) async {
    await pumpApp(tester);
    await go(tester, AppRoutes.login);
    await enter(tester, 'login_email_field', AuthMockApi.demoEmail);
    await enter(tester, 'login_password_field', AuthMockApi.demoPassword);
    await tapKey(tester, 'login_submit_button');

    await go(tester, AppRoutes.profile);
    await tapKey(tester, 'profile_delete_account_tile');
    expect(currentPath(), AppRoutes.deleteAccount);

    await enter(
      tester,
      'delete_account_password_field',
      AuthMockApi.demoPassword,
    );
    await tapKey(tester, 'delete_account_confirm_checkbox');
    await tapKey(tester, 'delete_account_submit_button');

    expect(getIt<AuthBloc>().state, isA<AuthGuest>());
    expect(currentPath(), AppRoutes.mapDiscovery);

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
