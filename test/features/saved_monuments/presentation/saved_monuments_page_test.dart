import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/features/saved_monuments/domain/entities/saved_monument.dart';
import 'package:vakif_atlas/features/saved_monuments/presentation/cubit/saved_monuments_cubit.dart';
import 'package:vakif_atlas/features/saved_monuments/presentation/cubit/saved_monuments_list_cubit.dart';
import 'package:vakif_atlas/features/saved_monuments/presentation/pages/saved_monuments_page.dart';

import '../../../helpers/pump_app.dart';
import '../../../helpers/saved_monuments_test_utils.dart';

void main() {
  late List<String> opened;
  late List<String> shownOnMap;
  late int explores;

  setUp(() {
    explores = 0;
    opened = [];
    shownOnMap = [];
  });

  Future<SavedMonumentsCubit> pumpPage(
    WidgetTester tester,
    SavedMonumentsTestEnvironment env, {
    double textScale = 1,
  }) async {
    final saved = env.cubit();
    await tester.pumpApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<SavedMonumentsCubit>.value(value: saved),
          BlocProvider<SavedMonumentsListCubit>(create: (_) => env.listCubit()),
        ],
        child: SavedMonumentsPage(
          onOpenMonument: opened.add,
          onShowOnMap: shownOnMap.add,
          onExplore: () => explores++,
        ),
      ),
      textScale: textScale,
      surfaceSize: const Size(390, 844),
    );
    await tester.pumpAndSettle();
    addTearDown(() => unawaited(saved.close()));
    return saved;
  }

  Future<void> expectAccessible(WidgetTester tester) async {
    expect(tester.takeException(), isNull);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
  }

  SavedMonumentsTestEnvironment seeded() => SavedMonumentsTestEnvironment(
    initial: [
      SavedMonument(
        monumentId: 'selimiye-camii',
        savedAt: DateTime.utc(2026, 10, 18, 9),
      ),
      SavedMonument(
        monumentId: 'kizlaragasi-hani',
        savedAt: DateTime.utc(2026, 10, 19, 9),
      ),
      SavedMonument(
        monumentId: 'kaldirilmis-eser',
        savedAt: DateTime.utc(2026, 10, 1, 9),
      ),
    ],
  );

  testWidgets('boş liste nasıl kaydedileceğini anlatır', (tester) async {
    await pumpPage(tester, SavedMonumentsTestEnvironment());

    expect(find.byKey(const Key('saved_monuments_empty')), findsOneWidget);
    expect(find.text('Henüz kaydedilen eser yok'), findsOneWidget);
    await expectAccessible(tester);

    await tester.tap(find.text('Haritada keşfet'));
    expect(explores, 1);
  });

  testWidgets('kaydedilenler en yeni önce, bilgileriyle listelenir', (
    tester,
  ) async {
    await pumpPage(tester, seeded());

    expect(find.text('3 eser'), findsOneWidget);
    final first = tester.getTopLeft(find.text('Kızlarağası Hanı')).dy;
    final second = tester.getTopLeft(find.text('Selimiye Camii')).dy;
    expect(first, lessThan(second));
    expect(find.textContaining('Kaydedildi: 19 Eki 2026'), findsOneWidget);
    expect(find.text('Artık katalogda olmayan eser'), findsOneWidget);

    await tester.tap(find.text('Selimiye Camii'));
    expect(opened, ['selimiye-camii']);
    await tester.tap(
      find.byKey(const Key('saved_monument_map_selimiye-camii')),
    );
    expect(shownOnMap, ['selimiye-camii']);
    await expectAccessible(tester);
  });

  testWidgets('kaldırılan eser geri alınabilir', (tester) async {
    final saved = await pumpPage(tester, seeded());

    await tester.tap(
      find.byKey(const Key('saved_monument_remove_selimiye-camii')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Kaydedilenlerden çıkarıldı: Selimiye Camii'), findsOne);
    expect(saved.state.contains('selimiye-camii'), isFalse);
    expect(find.text('2 eser'), findsOneWidget);

    await tester.tap(find.text('Geri al'));
    await tester.pumpAndSettle();
    expect(saved.state.contains('selimiye-camii'), isTrue);
    expect(find.text('3 eser'), findsOneWidget);
  });

  testWidgets('katalogda olmayan kayıt kaldırılabilir', (tester) async {
    final saved = await pumpPage(tester, seeded());

    await tester.tap(
      find.byKey(const Key('saved_monument_remove_kaldirilmis-eser')),
    );
    await tester.pumpAndSettle();

    expect(saved.state.contains('kaldirilmis-eser'), isFalse);
    expect(find.text('Artık katalogda olmayan eser'), findsNothing);
  });

  testWidgets('%200 metin ölçeğinde taşmaz', (tester) async {
    await pumpPage(tester, seeded(), textScale: 2);
    await expectAccessible(tester);
  });
}
