import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/shared/widgets/atoms/diamond_divider.dart';
import 'package:vakif_atlas/shared/widgets/templates/status_message_view.dart';

import '../../../helpers/pump_app.dart';

void main() {
  Color badgeColor(WidgetTester tester) {
    final box = tester.widget<Container>(
      find.descendant(
        of: find.byType(StatusMessageContent),
        matching: find.byType(Container),
      ),
    );
    return (box.decoration! as BoxDecoration).color!;
  }

  testWidgets('boş durum: ikon dairesi, başlık, açıklama ve eylem; ayırıcı '
      'yok', (tester) async {
    var taps = 0;
    await tester.pumpApp(
      Scaffold(
        body: StatusMessageView(
          icon: Icons.bookmark_border,
          title: 'Henüz kaydedilen eser yok',
          message: 'Eserleri buraya kaydedin.',
          actionLabel: 'Haritada keşfet',
          onAction: () => taps++,
        ),
      ),
    );

    expect(find.byType(DiamondDivider), findsNothing);
    final context = tester.element(find.byType(StatusMessageContent));
    expect(badgeColor(tester), context.colors.secondaryContainer);
    expect(
      tester.getSemantics(find.text('Henüz kaydedilen eser yok')),
      isSemantics(label: 'Henüz kaydedilen eser yok', isHeader: true),
    );
    await tester.tap(find.text('Haritada keşfet'));
    expect(taps, 1);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
  });

  testWidgets('hata tonu nötrden ayrışır', (tester) async {
    await tester.pumpApp(
      const Scaffold(
        body: StatusMessageView(
          tone: StatusMessageTone.error,
          icon: Icons.cloud_off_outlined,
          title: 'Yüklenemedi',
          message: 'Sunucuya ulaşılamıyor.',
        ),
      ),
    );
    final context = tester.element(find.byType(StatusMessageContent));
    expect(badgeColor(tester), isNot(context.colors.secondaryContainer));
  });

  testWidgets('%200 metin ölçeğinde küçük ekranda taşmaz', (tester) async {
    await tester.pumpApp(
      const Scaffold(
        body: StatusMessageView(
          icon: Icons.route_outlined,
          title: 'Henüz rotanız yok',
          message:
              'Eserleri seçip sıralayın; ziyaret süresi ve molalarla ilk kültür '
              'rotanızı oluşturun.',
          actionLabel: 'Yeni rota',
          onAction: _noop,
        ),
      ),
      textScale: 2,
      surfaceSize: const Size(320, 568),
    );
    expect(tester.takeException(), isNull);
  });
}

void _noop() {}
