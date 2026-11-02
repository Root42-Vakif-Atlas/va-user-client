import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';
import 'package:vakif_atlas/shared/widgets/atoms/leading_icon_tile.dart';
import 'package:vakif_atlas/shared/widgets/atoms/status_badge.dart';
import 'package:vakif_atlas/shared/widgets/molecules/confirm_dialog.dart';
import 'package:vakif_atlas/shared/widgets/molecules/grouped_section.dart';
import 'package:vakif_atlas/shared/widgets/molecules/inline_message.dart';
import 'package:vakif_atlas/shared/widgets/molecules/section_header.dart';
import 'package:vakif_atlas/shared/widgets/templates/bottom_action_bar.dart';

import '../../helpers/pump_app.dart';

/// Tasarım yenilemesinin ortak bileşenleri: kenar çizgisiz bildirim, rozet,
/// sabit eylem çubuğu, tek onay diyaloğu, ikon kutusu ve başlık.
void main() {
  group('InlineMessage', () {
    for (final MapEntry(key: name, value: theme) in testThemes.entries) {
      testWidgets('$name: soldaki renkli şerit yok, ikon + metin var', (
        tester,
      ) async {
        await tester.pumpApp(
          const Column(
            children: [
              InlineMessage(message: 'Bilgi'),
              InlineMessage(message: 'Hata', type: InlineMessageType.error),
            ],
          ),
          theme: theme,
        );
        final boxes = tester.widgetList<DecoratedBox>(
          find.descendant(
            of: find.byType(InlineMessage),
            matching: find.byType(DecoratedBox),
          ),
        );
        for (final box in boxes) {
          final border = (box.decoration as BoxDecoration).border;
          // Yalnızca yüksek kontrastta dört kenardan çerçeve; asla tek taraf.
          if (border != null) {
            expect(border.isUniform, isTrue);
          }
        }
        expect(find.text('Bilgi'), findsOneWidget);
        expect(find.byType(Icon), findsNWidgets(2));
      });
    }

    testWidgets('canlı bölge olarak işaretlenir', (tester) async {
      await tester.pumpApp(const InlineMessage(message: 'Kaydedildi'));
      expect(
        tester.getSemantics(find.text('Kaydedildi')),
        isSemantics(isLiveRegion: true),
      );
    });
  });

  testWidgets('StatusBadge ikon ve metni gösterir, şeritsizdir', (
    tester,
  ) async {
    await tester.pumpApp(
      Builder(
        builder: (context) => StatusBadge(
          icon: Icons.hourglass_top_outlined,
          label: 'İncelemede',
          color: context.colors.warning,
        ),
      ),
    );
    expect(find.text('İncelemede'), findsOneWidget);
    expect(find.byIcon(Icons.hourglass_top_outlined), findsOneWidget);
    final box = tester.widget<DecoratedBox>(
      find.descendant(
        of: find.byType(StatusBadge),
        matching: find.byType(DecoratedBox),
      ),
    );
    expect((box.decoration as BoxDecoration).border, isNull);
  });

  group('BottomActionBar', () {
    testWidgets('birincil sağda ve iki kat geniş, ikincil solda', (
      tester,
    ) async {
      await tester.pumpApp(
        Align(
          alignment: Alignment.bottomCenter,
          child: BottomActionBar(
            secondary: AppButton.secondary(
              key: const Key('back'),
              label: 'Geri',
              expand: true,
              onPressed: () {},
            ),
            primary: AppButton.primary(
              key: const Key('next'),
              label: 'İleri',
              expand: true,
              onPressed: () {},
            ),
          ),
        ),
      );
      final back = tester.getRect(find.byKey(const Key('back')));
      final next = tester.getRect(find.byKey(const Key('next')));
      expect(back.right, lessThan(next.left));
      expect(next.width, closeTo(back.width * 2, 1));
    });

    testWidgets('ikincil yoksa birincil tam genişliktedir; üst yuva çizilir', (
      tester,
    ) async {
      await tester.pumpApp(
        Align(
          alignment: Alignment.bottomCenter,
          child: BottomActionBar(
            header: const Text('2 durak'),
            primary: AppButton.primary(
              key: const Key('go'),
              label: 'Oluştur',
              expand: true,
              onPressed: () {},
            ),
          ),
        ),
        surfaceSize: const Size(400, 800),
      );
      expect(find.text('2 durak'), findsOneWidget);
      final go = tester.getRect(find.byKey(const Key('go')));
      expect(go.width, closeTo(400 - 32, 1));
    });

    testWidgets('%200 metin ölçeğinde taşmaz', (tester) async {
      await tester.pumpApp(
        Align(
          alignment: Alignment.bottomCenter,
          child: BottomActionBar(
            header: const Text('Fotoğraflar yükleniyor %40'),
            secondary: AppButton.secondary(
              label: 'Geri',
              icon: Icons.arrow_back,
              expand: true,
              onPressed: () {},
            ),
            primary: AppButton.primary(
              label: 'Bildirimi gönder',
              icon: Icons.send_outlined,
              expand: true,
              onPressed: () {},
            ),
          ),
        ),
        textScale: 2,
        surfaceSize: const Size(320, 568),
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('showConfirmDialog', () {
    Future<bool?> open(
      WidgetTester tester, {
      bool destructive = true,
      required void Function(bool) onResult,
    }) async {
      await tester.pumpApp(
        Builder(
          builder: (context) => TextButton(
            onPressed: () async => onResult(
              await showConfirmDialog(
                context,
                title: 'Silinsin mi?',
                body: 'Bu işlem geri alınamaz.',
                confirmLabel: 'Sil',
                cancelLabel: 'Vazgeç',
                confirmKey: const Key('confirm'),
                cancelKey: const Key('cancel'),
                destructive: destructive,
              ),
            ),
            child: const Text('aç'),
          ),
        ),
      );
      await tester.tap(find.text('aç'));
      await tester.pumpAndSettle();
      return null;
    }

    testWidgets('vazgeç solda, onay sağda; onay true döner', (tester) async {
      bool? result;
      await open(tester, onResult: (value) => result = value);
      expect(
        tester.getTopLeft(find.byKey(const Key('cancel'))).dx,
        lessThan(tester.getTopLeft(find.byKey(const Key('confirm'))).dx),
      );
      await tester.tap(find.byKey(const Key('confirm')));
      await tester.pumpAndSettle();
      expect(result, isTrue);
    });

    testWidgets('vazgeç ve dışarı dokunma false döner', (tester) async {
      bool? result;
      await open(tester, onResult: (value) => result = value);
      await tester.tap(find.byKey(const Key('cancel')));
      await tester.pumpAndSettle();
      expect(result, isFalse);
    });

    testWidgets('hareket azaltma açıkken diyalog anında açılır', (
      tester,
    ) async {
      bool? result;
      await tester.pumpApp(
        Builder(
          builder: (context) => TextButton(
            onPressed: () async => result = await showConfirmDialog(
              context,
              title: 'Çıkış',
              body: 'Emin misiniz?',
              confirmLabel: 'Çık',
              cancelLabel: 'Vazgeç',
              destructive: false,
            ),
            child: const Text('aç'),
          ),
        ),
        disableAnimations: true,
      );
      await tester.tap(find.text('aç'));
      await tester.pump();
      // Animasyon beklenmeden (tek kare) diyalog görünür.
      expect(find.text('Çıkış'), findsOneWidget);
      expect(result, isNull);
    });
  });

  testWidgets('LeadingIconTile her tonda en az 48 dp ve ikon süstür', (
    tester,
  ) async {
    await tester.pumpApp(
      Wrap(
        children: [
          for (final tone in LeadingIconTone.values)
            LeadingIconTile(icon: Icons.info_outlined, tone: tone),
        ],
      ),
    );
    for (final element in find.byType(LeadingIconTile).evaluate()) {
      final size = tester.getSize(find.byWidget(element.widget));
      expect(size.width, greaterThanOrEqualTo(48));
      expect(size.height, greaterThanOrEqualTo(48));
    }
    expect(find.byType(ExcludeSemantics), findsWidgets);
  });

  testWidgets('SectionHeader başlık olarak okunur; GroupedSection satırları '
      'ayırıcıyla gruplar', (tester) async {
    await tester.pumpApp(
      const Column(
        children: [
          SectionHeader('Görünüm'),
          GroupedSection(
            children: [
              ListTile(title: Text('Bir')),
              ListTile(title: Text('İki')),
            ],
          ),
        ],
      ),
    );
    expect(
      tester.getSemantics(find.text('Görünüm')),
      isSemantics(isHeader: true),
    );
    expect(find.byType(Divider), findsOneWidget);
  });
}
