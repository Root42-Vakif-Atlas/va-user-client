import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/shared/widgets/atoms/accessible_touch_target.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_badge.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/atoms/diamond_divider.dart';

import '../../../helpers/pump_app.dart';

void main() {
  group('AccessibleTouchTarget', () {
    testWidgets('küçük öğenin dokunma alanını 48×48 dp\'ye genişletir', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpApp(
        Center(
          child: AccessibleTouchTarget(
            onTap: () => taps++,
            semanticsLabel: 'Konumumu göster',
            child: const SizedBox.square(dimension: 16),
          ),
        ),
      );

      final finder = find.byType(AccessibleTouchTarget);
      expect(tester.getSize(finder), const Size(48, 48));

      // Görsel alanın dışında ama dokunma hedefinin içinde bir nokta.
      await tester.tapAt(tester.getTopLeft(finder) + const Offset(2, 2));
      expect(taps, 1);
      expect(find.bySemanticsLabel('Konumumu göster'), findsOneWidget);
    });

    testWidgets('daha büyük öğeleri küçültmez', (tester) async {
      await tester.pumpApp(
        const Center(
          child: AccessibleTouchTarget(child: SizedBox(width: 120, height: 60)),
        ),
      );
      expect(
        tester.getSize(find.byType(AccessibleTouchTarget)),
        const Size(120, 60),
      );
    });
  });

  group('AppIcon', () {
    testWidgets('anlamlı ikon semantik etiket taşır', (tester) async {
      await tester.pumpApp(
        const AppIcon(Icons.map_outlined, semanticsLabel: 'Harita'),
      );
      expect(find.bySemanticsLabel('Harita'), findsOneWidget);
    });

    testWidgets('dekoratif ikon ekran okuyucudan gizlenir', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpApp(const AppIcon.decorative(Icons.map_outlined));
      expect(
        find.descendant(
          of: find.byType(AppIcon),
          matching: find.byType(ExcludeSemantics),
        ),
        findsWidgets,
      );
      handle.dispose();
    });
  });

  group('AppText', () {
    testWidgets('başlık olarak işaretlenebilir', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpApp(
        const AppText(
          'Eser Detayı',
          role: AppTextRole.headlineLarge,
          isHeading: true,
        ),
      );
      expect(
        tester.getSemantics(find.text('Eser Detayı')),
        matchesSemantics(label: 'Eser Detayı', isHeader: true),
      );
      handle.dispose();
    });
  });

  group('AppBadge', () {
    testWidgets('üst sınırı aşan sayı kısaltılır, semantik etiket okunur', (
      tester,
    ) async {
      await tester.pumpApp(
        const Center(
          child: AppBadge.count(
            count: 120,
            semanticsLabel: '120 yeni bildirim',
          ),
        ),
      );
      expect(find.text('99+'), findsOneWidget);
      expect(find.bySemanticsLabel('120 yeni bildirim'), findsOneWidget);
    });

    testWidgets('metin etiketiyle çizilir', (tester) async {
      await tester.pumpApp(
        const Center(
          child: AppBadge(label: 'Sv. 3', semanticsLabel: 'Seviye 3'),
        ),
      );
      expect(find.text('Sv. 3'), findsOneWidget);
    });
  });

  group('DiamondDivider', () {
    testWidgets('dekoratif olarak ekran okuyucudan gizlenir', (tester) async {
      await tester.pumpApp(const DiamondDivider());
      expect(
        find.descendant(
          of: find.byType(DiamondDivider),
          matching: find.byType(ExcludeSemantics),
        ),
        findsOneWidget,
      );
    });
  });
}
