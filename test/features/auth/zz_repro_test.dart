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

  testWidgets('ZZ kayıt doğrudan', (tester) async {
    await pumpApp(tester);
    await go(tester, AppRoutes.register);
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
}
