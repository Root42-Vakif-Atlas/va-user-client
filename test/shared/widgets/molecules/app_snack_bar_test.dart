import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/shared/widgets/molecules/app_snack_bar.dart';

void main() {
  Future<void> show(
    WidgetTester tester, {
    required bool accessibleNavigation,
    bool withAction = true,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(accessibleNavigation: accessibleNavigation),
          child: child!,
        ),
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => AppSnackBar.show(
                context,
                message: 'Kaydedildi',
                action: withAction
                    ? SnackBarAction(label: 'Geri al', onPressed: () {})
                    : null,
              ),
              child: const Text('göster'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('göster'));
    await tester.pumpAndSettle();
    expect(find.text('Kaydedildi'), findsOneWidget);
  }

  testWidgets('eylemli bildirim süre dolunca kapanır', (tester) async {
    await show(tester, accessibleNavigation: false);

    await tester.pump(AppSnackBar.actionDuration);
    await tester.pumpAndSettle();

    expect(find.text('Kaydedildi'), findsNothing);
  });

  testWidgets('eylemsiz bildirim kısa sürede kapanır', (tester) async {
    await show(tester, accessibleNavigation: false, withAction: false);

    await tester.pump(AppSnackBar.shortDuration);
    await tester.pumpAndSettle();

    expect(find.text('Kaydedildi'), findsNothing);
  });

  testWidgets('ekran okuyucu açıkken eylemli bildirim kapat butonuyla kalır', (
    tester,
  ) async {
    await show(tester, accessibleNavigation: true);

    await tester.pump(AppSnackBar.actionDuration * 2);
    await tester.pumpAndSettle();
    expect(find.text('Kaydedildi'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(find.text('Kaydedildi'), findsNothing);
  });
}
