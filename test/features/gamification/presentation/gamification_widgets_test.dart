import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/a11y/haptic_feedback_service.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/app_theme.dart';
import 'package:vakif_atlas/features/gamification/presentation/cubit/gamification_cubit.dart';
import 'package:vakif_atlas/features/gamification/presentation/pages/achievements_page.dart';
import 'package:vakif_atlas/features/gamification/presentation/widgets/gamification_celebrations.dart';
import 'package:vakif_atlas/features/gamification/presentation/widgets/gamification_profile_section.dart';

import '../../../helpers/gamification_test_utils.dart';
import '../../../helpers/pump_app.dart';
import '../../../support/mock_api/gamification/mock_activity_ledger.dart';

void main() {
  late List<String> announcements;

  setUp(() => announcements = []);

  /// Demo hesabıyla İstanbul + Edirne rotası (90 XP) ve bir Bursa anısı
  /// (+50) → 140 XP, 2. seviye; üç rozet.
  Future<GamificationCubit> startedCubit(
    WidgetTester tester, {
    String languageCode = 'tr',
    bool acknowledged = true,
  }) async {
    final env = GamificationTestEnvironment();
    late GamificationCubit cubit;
    await tester.runAsync(() async {
      await env.signIn();
      await env.record(MockActivityKind.routeCreated, [
        'suleymaniye-camii',
        'selimiye-camii',
      ], at: DateTime.utc(2026, 10, 18, 9));
      await env.record(MockActivityKind.memoryShared, [
        'bursa-ulu-camii',
      ], at: DateTime.utc(2026, 10, 19, 9));
      if (acknowledged) {
        await env.ledger.markSeen(gamificationDemoUserId, [
          'first_route',
          'first_memory',
          'city_explorer',
          'level:2',
        ]);
      }
      cubit = env.cubit();
      await cubit.start(languageCode: languageCode);
    });
    addTearDown(() => unawaited(cubit.close()));
    return cubit;
  }

  Future<void> expectAccessible(WidgetTester tester) async {
    expect(tester.takeException(), isNull);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
  }

  testWidgets('profil bölümü seviye, XP ve son rozetleri gösterir', (
    tester,
  ) async {
    final cubit = await startedCubit(tester);
    var opened = 0;
    await tester.pumpApp(
      BlocProvider.value(
        value: cubit,
        child: SingleChildScrollView(
          child: GamificationProfileSection(onOpenAchievements: () => opened++),
        ),
      ),
      surfaceSize: const Size(390, 1200),
    );

    expect(find.text('Seviye 2 · Gezgin'), findsOneWidget);
    expect(find.text('140 / 250 XP'), findsOneWidget);
    expect(find.text('Sonraki seviyeye 110 XP kaldı.'), findsOneWidget);
    expect(
      tester.getSemantics(find.byKey(const Key('gamification_xp_bar'))),
      isSemantics(label: 'Seviye ilerlemesi', value: '140 / 250 XP'),
    );
    expect(find.text('İlk Anı'), findsOneWidget);
    await tester.tap(find.byKey(const Key('gamification_all_badges')));
    expect(opened, 1);
    expect(find.text('Tüm rozetler (3/8)'), findsOneWidget);
    await expectAccessible(tester);
  });

  testWidgets('rozetler sayfası kazanılanları ve kilitlileri ilerlemeyle '
      'listeler; %200 metinde taşmaz', (tester) async {
    final cubit = await startedCubit(tester);
    await tester.pumpApp(
      BlocProvider.value(value: cubit, child: const AchievementsPage()),
      textScale: 2,
      surfaceSize: const Size(390, 844),
    );

    expect(find.text('8 rozetten 3 tanesini kazandınız.'), findsOneWidget);
    expect(find.text('Kazanılanlar'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const Key('achievement_route_master')),
      300,
    );
    expect(find.text('Kazanılacaklar'), findsOneWidget);
    expect(find.text('Kilitli · 1/5'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const Key('achievements_how_to')),
      300,
    );
    expect(find.text('Nasıl XP kazanılır?'), findsOneWidget);
    await expectAccessible(tester);
  });

  testWidgets('yeni kazanımlar kutlanır, duyurulur ve görüldü işaretlenir', (
    tester,
  ) async {
    final navigatorKey = GlobalKey<NavigatorState>();
    var openedBadges = 0;
    late GamificationCubit cubit;
    final env = GamificationTestEnvironment();
    await tester.runAsync(() async {
      await env.signIn();
      cubit = env.cubit();
    });
    addTearDown(() => unawaited(cubit.close()));

    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(
            value: A11yAnnouncer.withSender(
              (_, message, _, _) async => announcements.add(message),
            ),
          ),
          RepositoryProvider.value(
            value: HapticFeedbackService.withDelay((_) async {}),
          ),
        ],
        child: BlocProvider.value(
          value: cubit,
          child: MaterialApp(
            navigatorKey: navigatorKey,
            theme: AppTheme.light(),
            locale: const Locale('tr'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => GamificationCelebrations(
              navigatorKey: navigatorKey,
              onOpenAchievements: () => openedBadges++,
              child: child!,
            ),
            home: const Scaffold(body: SizedBox.shrink()),
          ),
        ),
      ),
    );

    await tester.runAsync(() async {
      await cubit.start(languageCode: 'tr');
      await env.createRoute(['suleymaniye-camii', 'selimiye-camii']);
      await env.record(MockActivityKind.memoryShared, [
        'bursa-ulu-camii',
      ], at: DateTime.utc(2026, 10, 19, 10));
      await cubit.refresh();
    });
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('gamification_celebration')), findsOneWidget);
    expect(find.text('Yeni seviye: 2 · Gezgin'), findsOneWidget);
    expect(find.text('Yeni rozet: İlk Rota'), findsOneWidget);
    expect(announcements.single, startsWith('Tebrikler!. Yeni seviye: 2'));

    await tester.tap(find.byKey(const Key('gamification_celebration_badges')));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('gamification_celebration')), findsNothing);
    expect(openedBadges, 1);
    expect(cubit.state.pendingUnlocks, isEmpty);
    final seen = await tester.runAsync(
      () => env.ledger.entryFor(gamificationDemoUserId),
    );
    expect(seen!.seen, containsAll(['first_route', 'level:2']));
  });
}
