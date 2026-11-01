import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory_draft.dart';
import 'package:vakif_atlas/features/memory_corner/domain/usecases/memory_usecases.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/cubit/my_memories_cubit.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/pages/my_memories_page.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/widgets/my_memories_section.dart';

import '../../../helpers/catalog_test_utils.dart';
import '../../../helpers/memory_test_utils.dart';
import '../../../helpers/pump_app.dart';

MyMemoriesCubit _cubit(MemoryTestEnvironment env) => MyMemoriesCubit(
  env.useCases.mine,
  env.useCases.delete,
  catalogUseCases().pins,
  env.useCases.watch,
);

Future<void> _until(bool Function() condition) async {
  for (var i = 0; i < 100 && !condition(); i++) {
    await Future<void>.delayed(const Duration(milliseconds: 5));
  }
  expect(condition(), isTrue);
}

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 8; i++) {
    await tester.pump(const Duration(milliseconds: 20));
  }
}

void main() {
  group('GET memories/mine', () {
    test('misafir 401 alır', () async {
      final env = MemoryTestEnvironment(initialState: ownMemoryState(2));

      final result = await env.useCases.mine(const GetMyMemoriesParams());

      expect(result.fold((f) => f, (_) => null), isA<UnauthorizedFailure>());
    });

    test('yalnızca kendi anıları, en son paylaşılan önce; bildirilerek '
        'gizlenen de görünür; imleçle sayfalanır', () async {
      final env = MemoryTestEnvironment(
        initialState: ownMemoryState(5, reportedOwnId: 'mem_own_004'),
      );
      await env.signIn();

      final first = (await env.useCases.mine(
        const GetMyMemoriesParams(limit: 2),
      )).getOrNull()!;
      expect(first.total, 5);
      expect(
        [for (final m in first.items) m.id],
        ['mem_own_004', 'mem_own_003'],
      );

      final rest = (await env.useCases.mine(
        GetMyMemoriesParams(limit: 10, cursor: first.nextCursor),
      )).getOrNull()!;
      expect(
        [for (final m in rest.items) m.id],
        ['mem_own_002', 'mem_own_001', 'mem_own_000'],
      );
      expect(rest.hasMore, isFalse);
    });

    test('geçersiz imleç 400', () async {
      final env = MemoryTestEnvironment(initialState: ownMemoryState(1));
      await env.signIn();
      final result = await env.useCases.mine(
        const GetMyMemoriesParams(cursor: 'bozuk'),
      );
      expect(result.isLeft, isTrue);
    });
  });

  group('MyMemoriesCubit', () {
    test('yükler, eser adlarını arayüz dilinde çözer, sonraki sayfayı '
        'ekler', () async {
      final env = MemoryTestEnvironment(initialState: ownMemoryState(5));
      await env.signIn();
      final cubit = _cubit(env);

      await cubit.load(languageCode: 'en', limit: 3);
      expect(cubit.state.status, MyMemoriesStatus.ready);
      expect(cubit.state.items, hasLength(3));
      expect(cubit.state.monumentNames['selimiye-camii'], 'Selimiye Mosque');

      await cubit.loadMore();
      expect(cubit.state.items, hasLength(5));
      expect(cubit.state.hasMore, isFalse);
      expect(cubit.state.toString(), isNot(contains('Benim')));
      await cubit.close();
    });

    test(
      'silinen anı düşer; başka ekranda paylaşılan anı listeyi yeniler',
      () async {
        final env = MemoryTestEnvironment(initialState: ownMemoryState(2));
        await env.signIn();
        final cubit = _cubit(env);
        await cubit.load(languageCode: 'tr');

        await cubit.delete(cubit.state.items.first);
        expect(cubit.state.total, 1);
        expect(cubit.state.notice?.kind.name, 'deleted');

        await env.useCases.create(
          const CreateMemoryParams(
            draft: MemoryDraft(
              monumentId: 'kizlaragasi-hani',
              text: 'Yeni anı',
            ),
          ),
        );
        await _until(() => cubit.state.total == 2);
        expect(cubit.state.items.first.text, 'Yeni anı');
        await _until(
          () =>
              cubit.state.monumentNames['kizlaragasi-hani'] ==
              'Kızlarağası Hanı',
        );
        await cubit.close();
      },
    );

    test('oturum yoksa hata durumu', () async {
      final env = MemoryTestEnvironment(initialState: ownMemoryState(1));
      final cubit = _cubit(env);
      await cubit.load(languageCode: 'tr');
      expect(cubit.state.status, MyMemoriesStatus.failure);
      await cubit.close();
    });
  });

  group('Arayüz', () {
    late List<String> announcements;
    late List<(String, String)> opened;
    late int openedAll;

    setUp(() {
      announcements = [];
      opened = [];
      openedAll = 0;
    });

    Future<void> pump(
      WidgetTester tester,
      MemoryTestEnvironment env,
      Widget child, {
      double textScale = 1,
    }) async {
      await tester.runAsync(env.signIn);
      final cubit = _cubit(env);
      addTearDown(() => unawaited(cubit.close()));
      await tester.pumpApp(
        RepositoryProvider<A11yAnnouncer>.value(
          value: A11yAnnouncer.withSender(
            (_, message, _, _) async => announcements.add(message),
          ),
          child: BlocProvider.value(value: cubit, child: child),
        ),
        textScale: textScale,
        surfaceSize: const Size(390, 1000),
      );
      await _settle(tester);
    }

    Future<void> expectAccessible(WidgetTester tester) async {
      expect(tester.takeException(), isNull);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
    }

    Widget section() => SingleChildScrollView(
      child: MyMemoriesProfileSection(
        onOpenAll: () => openedAll++,
        onOpenMonumentMemories: (id, name) => opened.add((id, name)),
      ),
    );

    testWidgets('profil önizlemesi en son 3 anıyı ve toplamı gösterir', (
      tester,
    ) async {
      await pump(
        tester,
        MemoryTestEnvironment(initialState: ownMemoryState(5)),
        section(),
      );

      expect(find.text('Anılarım'), findsOneWidget);
      expect(find.text('Benim anım 4'), findsOneWidget);
      expect(find.text('Benim anım 2'), findsOneWidget);
      expect(find.text('Benim anım 1'), findsNothing);
      expect(find.text('Tüm anılarım (5)'), findsOneWidget);

      await tester.tap(find.byKey(const Key('my_memory_mem_own_004')));
      // 4. anı: 4 % 3 = 1 → Süleymaniye Camii.
      expect(opened.single, ('suleymaniye-camii', 'Süleymaniye Camii'));
      await tester.tap(find.byKey(const Key('my_memories_view_all')));
      expect(openedAll, 1);
      await expectAccessible(tester);
    });

    testWidgets('profil önizlemesi: anı yoksa nasıl paylaşılacağını anlatır', (
      tester,
    ) async {
      await pump(
        tester,
        MemoryTestEnvironment(initialState: ownMemoryState(0)),
        section(),
      );

      expect(find.byKey(const Key('my_memories_empty')), findsOneWidget);
      expect(find.byKey(const Key('my_memories_view_all')), findsNothing);
    });

    testWidgets('Anılarım sayfası: eser başlığı, Anı Köşesi bağlantısı ve '
        'silme', (tester) async {
      await pump(
        tester,
        MemoryTestEnvironment(initialState: ownMemoryState(2)),
        MyMemoriesPage(
          onOpenMonumentMemories: (id, name) => opened.add((id, name)),
          onExplore: () {},
        ),
      );

      expect(find.text('2 anı'), findsOneWidget);
      expect(find.text('Süleymaniye Camii'), findsOneWidget);
      await tester.tap(find.byKey(const Key('my_memory_open_mem_own_001')));
      expect(opened.single, ('suleymaniye-camii', 'Süleymaniye Camii'));

      await tester.tap(find.byKey(const Key('memory_menu_mem_own_001')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('memory_action_delete')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('memory_delete_confirm')));
      await _settle(tester);

      expect(find.text('Benim anım 1'), findsNothing);
      expect(find.text('1 anı'), findsOneWidget);
      expect(announcements, contains('Anınız silindi'));
      await expectAccessible(tester);
    });

    testWidgets('YZ moderasyon durumu rozetle ve açıklamayla gösterilir', (
      tester,
    ) async {
      final env = MemoryTestEnvironment(
        initialState: ownMemoryState(
          3,
          statuses: {'mem_own_002': 'pending', 'mem_own_001': 'rejected'},
        ),
      );
      await pump(
        tester,
        env,
        MyMemoriesPage(onOpenMonumentMemories: (_, _) {}, onExplore: () {}),
      );

      expect(find.text('İncelemede'), findsOneWidget);
      expect(
        find.text(
          "İnceleniyor; onaylanınca Anı Köşesi'nde yayınlanır. O zamana kadar "
          'yalnızca burada görünür.',
        ),
        findsOneWidget,
      );
      // Anı Köşesi bağlantısı yalnızca yayındaki anıda.
      expect(find.byKey(const Key('my_memory_open_mem_own_002')), findsNothing);
      expect(find.byKey(const Key('my_memory_open_mem_own_001')), findsNothing);
      expect(
        find.byKey(const Key('my_memory_open_mem_own_000')),
        findsOneWidget,
      );
      expect(find.text('Yayınlanmadı'), findsOneWidget);
      expect(
        find.byKey(const Key('my_memory_status_mem_own_000')),
        findsNothing,
      );
      await expectAccessible(tester);
    });

    testWidgets('profil önizlemesi incelemedeki anıyı belirtir', (
      tester,
    ) async {
      await pump(
        tester,
        MemoryTestEnvironment(
          initialState: ownMemoryState(3, statuses: {'mem_own_002': 'pending'}),
        ),
        section(),
      );

      expect(find.text('İncelemede'), findsOneWidget);
      expect(
        find.bySemanticsLabel(RegExp(r'^İncelemede\. Bursa Ulu Camii')),
        findsOneWidget,
      );
      await expectAccessible(tester);
    });

    testWidgets('Anılarım sayfası %200 metinde taşmaz', (tester) async {
      await pump(
        tester,
        MemoryTestEnvironment(initialState: ownMemoryState(2)),
        MyMemoriesPage(onOpenMonumentMemories: (_, _) {}, onExplore: () {}),
        textScale: 2,
      );
      await expectAccessible(tester);
    });
  });
}
