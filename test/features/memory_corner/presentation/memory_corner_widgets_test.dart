import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory_draft.dart';
import 'package:vakif_atlas/features/memory_corner/domain/usecases/memory_usecases.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/bloc/memory_list_bloc.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/memory_presentation.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/pages/memory_corner_page.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/widgets/monument_memories_section.dart';

import '../../../helpers/memory_test_utils.dart';
import '../../../helpers/pump_app.dart';

const String _demoUserId = 'usr_demo_001';

/// Dio isteği sıfır süreli zamanlayıcıyla başlar; sahte zamanda ilerletilir.
Future<void> _settleRequests(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 20));
  }
}

void main() {
  late List<String> announcements;
  late List<MemorySignInIntent> signIns;
  late int shares;
  late int opened;

  setUp(() {
    announcements = [];
    signIns = [];
    shares = 0;
    opened = 0;
  });

  Widget withBloc(MemoryTestEnvironment env, Widget child) {
    final cases = env.useCases;
    return RepositoryProvider<A11yAnnouncer>.value(
      value: A11yAnnouncer.withSender(
        (_, message, _, _) async => announcements.add(message),
      ),
      child: BlocProvider<MemoryListBloc>(
        create: (_) =>
            MemoryListBloc(cases.get, cases.delete, cases.report, cases.watch),
        child: child,
      ),
    );
  }

  Future<void> createMemory(
    WidgetTester tester,
    MemoryTestEnvironment env, {
    required String text,
    String monumentId = 'selimiye-camii',
    DateTime? visitedOn,
  }) => tester.runAsync(() async {
    await env.signIn();
    await env.useCases.create(
      CreateMemoryParams(
        draft: MemoryDraft(
          monumentId: monumentId,
          text: text,
          visitedOn: visitedOn,
        ),
      ),
    );
  });

  group('Eser detayındaki Anı Köşesi girişi', () {
    Future<void> pumpEntry(
      WidgetTester tester,
      MemoryTestEnvironment env, {
      String monumentId = 'selimiye-camii',
      double textScale = 1,
    }) async {
      await tester.pumpApp(
        withBloc(
          env,
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: MonumentMemoriesSection(
              monumentId: monumentId,
              viewerId: null,
              onOpen: () => opened++,
            ),
          ),
        ),
        textScale: textScale,
      );
      await _settleRequests(tester);
    }

    testWidgets('toplam ve en son anının alıntısı; dokununca açılır', (
      tester,
    ) async {
      await pumpEntry(tester, MemoryTestEnvironment());

      expect(find.text('Anı Köşesi'), findsOneWidget);
      expect(find.text('4 anı'), findsOneWidget);
      expect(find.textContaining('Mehmet K. · Ekim 2026'), findsOneWidget);
      expect(find.byKey(const Key('memory_entry_excerpt')), findsOneWidget);
      // Detay sayfasında anı kartı listelenmez.
      expect(
        find.byKey(const Key('memory_card_mem_seed_selimiye_1')),
        findsNothing,
      );

      await tester.tap(find.byKey(const Key('memory_entry_card')));
      expect(opened, 1);
    });

    testWidgets('kart tek bir buton olarak okunur', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpEntry(tester, MemoryTestEnvironment());

      expect(
        tester.getSemantics(find.byKey(const Key('memory_entry_card'))),
        isSemantics(
          label: 'Anı Köşesi, 4 anı. Son anı: Mehmet K., Ekim 2026',
          isButton: true,
          hasTapAction: true,
        ),
      );
      handle.dispose();
    });

    testWidgets('anısı olmayan eserde boş durum', (tester) async {
      await pumpEntry(
        tester,
        MemoryTestEnvironment(),
        monumentId: 'sultanhani-kervansarayi',
      );

      expect(find.text('Henüz anı paylaşılmamış'), findsOneWidget);
      expect(find.byKey(const Key('memory_entry_excerpt')), findsNothing);
    });

    testWidgets('%200 metin ölçeği ve erişilebilirlik yönergeleri', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpEntry(tester, MemoryTestEnvironment(), textScale: 2);

      expect(tester.takeException(), isNull);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      handle.dispose();
    });
  });

  group('Zaman çizelgesi (MemoryCornerPage)', () {
    Future<void> pumpTimeline(
      WidgetTester tester,
      MemoryTestEnvironment env, {
      String monumentId = 'selimiye-camii',
      String? viewerId,
      double textScale = 1,
    }) async {
      await tester.pumpApp(
        withBloc(
          env,
          MemoryCornerPage(
            monumentId: monumentId,
            monumentName: 'Selimiye Camii',
            viewerId: viewerId,
            onShare: () => shares++,
            onSignIn: signIns.add,
          ),
        ),
        textScale: textScale,
        surfaceSize: const Size(400, 1600),
      );
      await _settleRequests(tester);
    }

    testWidgets('anılar anı tarihine göre aylara gruplanır', (tester) async {
      await pumpTimeline(tester, MemoryTestEnvironment());

      expect(find.text('Selimiye Camii'), findsOneWidget);
      final october = tester.getTopLeft(
        find.byKey(const Key('memory_month_2026_10')),
      );
      final september = tester.getTopLeft(
        find.byKey(const Key('memory_month_2026_9')),
      );
      final firstCard = tester.getTopLeft(
        find.byKey(const Key('memory_card_mem_seed_selimiye_1')),
      );
      expect(october.dy, lessThan(firstCard.dy));
      expect(firstCard.dy, lessThan(september.dy));
      // Başlıklar ekran okuyucu başlık gezinmesine dahildir.
      expect(
        tester.getSemantics(find.byKey(const Key('memory_month_2026_10'))),
        isSemantics(label: 'Ekim 2026', isHeader: true),
      );
    });

    testWidgets('yıl çipiyle filtrelenir, sonuç duyurulur; aralık boşsa '
        'temizlenebilir', (tester) async {
      final env = MemoryTestEnvironment();
      await createMemory(
        tester,
        env,
        text: 'Lise gezisinde gelmiştik.',
        visitedOn: DateTime(2019, 5, 3),
      );
      await pumpTimeline(tester, env);

      expect(find.text('Tümü (5)'), findsOneWidget);
      expect(find.text('2026 (4)'), findsOneWidget);
      expect(find.text('2019 (1)'), findsOneWidget);

      await tester.tap(find.byKey(const Key('memory_filter_year_2019')));
      await _settleRequests(tester);

      expect(find.text('Lise gezisinde gelmiştik.'), findsOneWidget);
      expect(
        find.byKey(const Key('memory_card_mem_seed_selimiye_1')),
        findsNothing,
      );
      expect(find.byKey(const Key('memory_month_2019_5')), findsOneWidget);
      expect(announcements, contains('1 anı gösteriliyor'));
      // Yıl sayıları filtreden bağımsız kalır.
      expect(find.text('2026 (4)'), findsOneWidget);

      await tester.tap(find.byKey(const Key('memory_filter_all')));
      await _settleRequests(tester);
      expect(
        find.byKey(const Key('memory_card_mem_seed_selimiye_1')),
        findsOneWidget,
      );
    });

    testWidgets('özel tarih aralığı penceresi açılır; seçili aralık çip '
        'olarak gösterilir ve kaldırılır', (tester) async {
      await pumpTimeline(tester, MemoryTestEnvironment());

      await tester.tap(find.byKey(const Key('memory_filter_range')));
      await tester.pumpAndSettle();
      expect(find.byType(DateRangePickerDialog), findsOneWidget);
      expect(find.text('Anı tarihi aralığı seçin'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Pencerede yapılacak seçimin sonucu (takvim etkileşimi Flutter'ındır).
      tester
          .element(find.byType(MemoryCornerPage))
          .read<MemoryListBloc>()
          .add(
            MemoryListEvent.rangeChanged(
              MemoryDateRange(
                from: DateTime(2026, 9),
                to: DateTime(2026, 9, 30),
              ),
            ),
          );
      await _settleRequests(tester);

      expect(
        find.byKey(const Key('memory_card_mem_seed_selimiye_2')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('memory_card_mem_seed_selimiye_1')),
        findsNothing,
      );
      expect(find.byType(InputChip), findsOneWidget);

      await tester.tap(
        find.descendant(
          of: find.byType(InputChip),
          matching: find.byIcon(Icons.clear),
        ),
      );
      await _settleRequests(tester);
      expect(find.byType(InputChip), findsNothing);
      expect(
        find.byKey(const Key('memory_card_mem_seed_selimiye_1')),
        findsOneWidget,
      );
    });

    testWidgets('filtrede anı yoksa boş durum ve "Filtreyi temizle"', (
      tester,
    ) async {
      await pumpTimeline(tester, MemoryTestEnvironment());
      tester
          .element(find.byType(MemoryCornerPage))
          .read<MemoryListBloc>()
          .add(MemoryListEvent.rangeChanged(MemoryDateRange.year(2001)));
      await _settleRequests(tester);

      expect(
        find.byKey(const Key('memory_corner_filtered_empty')),
        findsOneWidget,
      );
      expect(find.text('Bu dönemde anı yok'), findsOneWidget);
      // Filtre çubuğu boş sonuçta da görünür kalır.
      expect(find.byKey(const Key('memory_time_filter')), findsOneWidget);

      await tester.tap(find.byKey(const Key('memory_filter_clear')));
      await _settleRequests(tester);
      expect(
        find.byKey(const Key('memory_card_mem_seed_selimiye_1')),
        findsOneWidget,
      );
    });

    testWidgets('kaydırdıkça sonraki sayfa yüklenir', (tester) async {
      final env = MemoryTestEnvironment(initialState: syntheticMemoryState(45));
      await pumpTimeline(tester, env);

      expect(find.text('Tümü (45)'), findsOneWidget);
      for (var i = 0; i < 60; i++) {
        await tester.drag(
          find.byKey(const Key('memory_corner_list')),
          const Offset(0, -800),
        );
        await _settleRequests(tester);
        if (find
            .byKey(const Key('memory_card_mem_test_044'))
            .evaluate()
            .isNotEmpty) {
          break;
        }
      }
      expect(find.byKey(const Key('memory_card_mem_test_044')), findsOneWidget);
    });

    testWidgets('kendi anısını onayla siler; sonuç duyurulur', (tester) async {
      final env = MemoryTestEnvironment();
      await createMemory(
        tester,
        env,
        text: 'Benim anım',
        visitedOn: DateTime(2026, 10, 15),
      );
      await pumpTimeline(tester, env, viewerId: _demoUserId);

      expect(find.text('Siz'), findsOneWidget);
      final menu = find.byWidgetPredicate(
        (widget) =>
            widget is PopupMenuButton &&
            (widget.key! as ValueKey<String>).value.startsWith('memory_menu_'),
      );
      await tester.tap(menu.first);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('memory_action_report')), findsNothing);
      await tester.tap(find.byKey(const Key('memory_action_delete')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('memory_delete_confirm')));
      await _settleRequests(tester);

      expect(find.text('Benim anım'), findsNothing);
      expect(announcements, contains('Anınız silindi'));
      expect(find.text('Tümü (4)'), findsOneWidget);
    });

    testWidgets('başkasının anısı neden seçilerek bildirilir', (tester) async {
      final env = MemoryTestEnvironment();
      await tester.runAsync(env.signIn);
      await pumpTimeline(tester, env, viewerId: _demoUserId);

      await tester.tap(
        find.byKey(const Key('memory_menu_mem_seed_selimiye_1')),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('memory_action_delete')), findsNothing);
      await tester.tap(find.byKey(const Key('memory_action_report')));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byKey(const Key('memory_report_submit')));
      await tester.tap(find.byKey(const Key('memory_report_submit')));
      await tester.pump();
      expect(
        find.byKey(const Key('memory_report_reason_error')),
        findsOneWidget,
      );
      await tester.ensureVisible(
        find.byKey(const Key('memory_report_reason_spam')),
      );
      await tester.tap(find.byKey(const Key('memory_report_reason_spam')));
      await tester.pump();
      await tester.ensureVisible(find.byKey(const Key('memory_report_submit')));
      await tester.tap(find.byKey(const Key('memory_report_submit')));
      await tester.pumpAndSettle();
      await _settleRequests(tester);

      expect(
        find.byKey(const Key('memory_card_mem_seed_selimiye_1')),
        findsNothing,
      );
      expect(announcements, contains('Bildiriminiz alındı, teşekkür ederiz'));
    });

    testWidgets('misafir bildirmek veya paylaşmak isteyince giriş açıklanır', (
      tester,
    ) async {
      await pumpTimeline(tester, MemoryTestEnvironment());
      await tester.tap(
        find.byKey(const Key('memory_menu_mem_seed_selimiye_1')),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('memory_action_report')));
      await tester.pumpAndSettle();
      expect(
        find.text('Bir anıyı bildirmek için giriş yapın.'),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const Key('memory_sign_in_button')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('memory_corner_share_fab')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('memory_sign_in_button')));
      await tester.pumpAndSettle();
      expect(signIns, [MemorySignInIntent.report, MemorySignInIntent.share]);
      expect(shares, 0);
    });

    testWidgets('uzun metin daraltılır, ekran okuyucu tamamını okur', (
      tester,
    ) async {
      final env = MemoryTestEnvironment();
      // Kural sınırının (1000) altında ama 6 satırdan uzun.
      final long = List.filled(
        25,
        'Kubbe ve avlu çok etkileyiciydi.',
      ).join(' ');
      await createMemory(
        tester,
        env,
        text: long,
        monumentId: 'bursa-ulu-camii',
      );
      await pumpTimeline(tester, env, monumentId: 'bursa-ulu-camii');

      expect(find.bySemanticsLabel(long), findsOneWidget);
      final card = find.ancestor(
        of: find.text(long),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget.key is ValueKey<String> &&
              (widget.key! as ValueKey<String>).value.startsWith(
                'memory_text_',
              ),
        ),
      );
      final readMore = find.descendant(
        of: card,
        matching: find.text('Devamını oku'),
      );
      expect(readMore, findsOneWidget);
      await tester.tap(readMore);
      await tester.pumpAndSettle();
      expect(
        find.descendant(of: card, matching: find.text('Daha az göster')),
        findsOneWidget,
      );
    });

    testWidgets('anısı olmayan eserde boş durum', (tester) async {
      await pumpTimeline(
        tester,
        MemoryTestEnvironment(),
        monumentId: 'sultanhani-kervansarayi',
      );
      expect(find.byKey(const Key('memory_corner_empty')), findsOneWidget);
    });

    testWidgets('%200 metin ölçeği ve erişilebilirlik yönergeleri', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpTimeline(tester, MemoryTestEnvironment(), textScale: 2);

      expect(tester.takeException(), isNull);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      handle.dispose();
    });
  });
}
