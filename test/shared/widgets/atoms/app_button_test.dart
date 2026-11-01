import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';

import '../../../helpers/pump_app.dart';

void main() {
  const label = 'Rotaya ekle';

  final variants = <String, AppButton Function(VoidCallback?)>{
    'primary': (onPressed) => AppButton.primary(
      key: const Key('primary_button'),
      label: label,
      onPressed: onPressed,
    ),
    'secondary': (onPressed) =>
        AppButton.secondary(label: label, onPressed: onPressed),
    'ghost': (onPressed) => AppButton.ghost(label: label, onPressed: onPressed),
    'destructive': (onPressed) =>
        AppButton.destructive(label: label, onPressed: onPressed),
  };

  group('AppButton', () {
    for (final MapEntry(key: name, value: build) in variants.entries) {
      testWidgets('$name: çizilir, 48×48 dp ve dokunmayı iletir', (
        tester,
      ) async {
        var taps = 0;
        await tester.pumpApp(Center(child: build(() => taps++)));

        expect(find.text(label), findsOneWidget);
        final size = tester.getSize(find.byType(AppButton));
        expect(size.width, greaterThanOrEqualTo(48));
        expect(size.height, greaterThanOrEqualTo(48));

        await tester.tap(find.byType(AppButton));
        expect(taps, 1);
      });
    }

    testWidgets('ekran okuyucu etiketi görünür etiketle aynıdır', (
      tester,
    ) async {
      await tester.pumpApp(
        Center(
          child: AppButton.primary(label: label, onPressed: () {}),
        ),
      );
      expect(find.bySemanticsLabel(label), findsOneWidget);
    });

    testWidgets('yüklenirken devre dışıdır ve "işlem sürüyor" okunur', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpApp(
        Center(
          child: AppButton.primary(
            label: label,
            isLoading: true,
            onPressed: () => taps++,
          ),
        ),
      );

      expect(find.bySemanticsLabel('$label, işlem sürüyor'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.tap(find.byType(AppButton), warnIfMissed: false);
      expect(taps, 0);
    });

    testWidgets('hareket azaltma açıkken animasyonlu gösterge yerine '
        'statik ikon kullanılır', (tester) async {
      await tester.pumpApp(
        Center(
          child: AppButton.primary(
            label: label,
            isLoading: true,
            onPressed: () {},
          ),
        ),
        disableAnimations: true,
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byIcon(Icons.hourglass_top), findsOneWidget);
    });

    testWidgets('onPressed null ise devre dışıdır', (tester) async {
      await tester.pumpApp(
        const Center(child: AppButton.primary(label: label, onPressed: null)),
      );
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('%200 metin ölçeğinde dar ekranda taşma olmaz', (tester) async {
      await tester.pumpApp(
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final build in variants.values) build(() {}),
              AppButton.primary(
                label: 'Seçilen eserleri içeren kültür rotasını oluştur',
                icon: Icons.route,
                expand: true,
                onPressed: () {},
              ),
            ],
          ),
        ),
        textScale: 2,
        surfaceSize: const Size(320, 900),
      );
      expect(tester.takeException(), isNull);
    });

    for (final MapEntry(key: themeName, value: theme) in testThemes.entries) {
      testWidgets('$themeName: erişilebilirlik kılavuzlarını karşılar', (
        tester,
      ) async {
        final handle = tester.ensureSemantics();
        await tester.pumpApp(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [for (final build in variants.values) build(() {})],
          ),
          theme: theme,
        );

        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        await expectLater(tester, meetsGuideline(textContrastGuideline));
        handle.dispose();
      });
    }
  });
}
