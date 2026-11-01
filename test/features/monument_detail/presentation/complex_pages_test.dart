import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/a11y/haptic_feedback_service.dart';
import 'package:vakif_atlas/core/a11y/voice_io_service.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/map/map_tile_source.dart';
import 'package:vakif_atlas/core/theme/app_theme.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_classification.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/cubit/complex_detail_cubit.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/cubit/complex_members_cubit.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/cubit/monument_detail_cubit.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/pages/complex_detail_page.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/pages/complex_members_page.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/pages/monument_detail_page.dart';

import '../../../helpers/catalog_test_utils.dart';
import '../../../helpers/map_test_utils.dart';

class _MockFlutterTts extends Mock implements FlutterTts {}

const String _suleymaniye = 'suleymaniye-kulliyesi';

void main() {
  late CatalogUseCases catalog;
  late List<String> opened;
  late List<String> openedComplexes;
  late List<String> announcements;

  setUp(() {
    catalog = catalogUseCases();
    opened = [];
    openedComplexes = [];
    announcements = [];
  });

  group('ComplexDetailCubit', () {
    blocTest<ComplexDetailCubit, ComplexDetailState>(
      'yükleme → loading, loaded (11 yapı)',
      build: () => ComplexDetailCubit(catalog.complexDetail),
      act: (cubit) => cubit.load(id: _suleymaniye, languageCode: 'tr'),
      expect: () => [
        const ComplexDetailState.loading(),
        isA<ComplexDetailLoaded>().having(
          (s) => s.complex.memberCount,
          'memberCount',
          11,
        ),
      ],
    );

    blocTest<ComplexDetailCubit, ComplexDetailState>(
      'külliye olmayan kayıt → bulunamadı',
      build: () => ComplexDetailCubit(catalog.complexDetail),
      act: (cubit) => cubit.load(id: 'selimiye-camii', languageCode: 'tr'),
      verify: (cubit) => expect(cubit.state.isNotFound, isTrue),
    );
  });

  group('ComplexMembersCubit', () {
    blocTest<ComplexMembersCubit, ComplexMembersState>(
      'türler çip olur; tür seçimi listeyi sunucuda süzer',
      build: () => ComplexMembersCubit(catalog.complexMembers),
      act: (cubit) async {
        await cubit.load(complexId: _suleymaniye, languageCode: 'tr');
        await cubit.toggleCategory(MonumentCategory.tomb);
      },
      verify: (cubit) {
        final state = cubit.state;
        expect(state.availableCategories, [
          MonumentCategory.mosque,
          MonumentCategory.madrasa,
          MonumentCategory.bath,
          MonumentCategory.tomb,
          MonumentCategory.hospital,
          MonumentCategory.imaret,
          MonumentCategory.other,
        ]);
        expect(state.categories, {MonumentCategory.tomb});
        expect(state.items.map((m) => m.id), [
          'kanuni-sultan-suleyman-turbesi',
          'hurrem-sultan-turbesi',
          'mimar-sinan-turbesi',
        ]);
        expect(state.hasMore, isFalse);
      },
    );
  });

  group('MonumentDetailCubit', () {
    blocTest<MonumentDetailCubit, MonumentDetailState>(
      'külliye yapısında diğer yapılar sonradan eklenir (kendisi hariç)',
      build: () => MonumentDetailCubit(catalog.detail, catalog.complexMembers),
      act: (cubit) =>
          cubit.load(id: 'hurrem-sultan-turbesi', languageCode: 'tr'),
      expect: () => [
        const MonumentDetailState.loading(),
        isA<MonumentDetailLoaded>().having(
          (s) => s.siblings,
          'siblings',
          isEmpty,
        ),
        isA<MonumentDetailLoaded>().having(
          (s) => [for (final m in s.siblings) m.id],
          'siblings',
          allOf(hasLength(10), isNot(contains('hurrem-sultan-turbesi'))),
        ),
      ],
    );

    blocTest<MonumentDetailCubit, MonumentDetailState>(
      'bağımsız eserde ek istek yapılmaz',
      build: () => MonumentDetailCubit(catalog.detail, catalog.complexMembers),
      act: (cubit) => cubit.load(id: 'selimiye-camii', languageCode: 'tr'),
      expect: () => [
        const MonumentDetailState.loading(),
        isA<MonumentDetailLoaded>(),
      ],
    );
  });

  Widget harness(WidgetTester tester, Widget child, {double textScale = 1}) {
    tester.view.physicalSize =
        const Size(390, 844) * tester.view.devicePixelRatio;
    addTearDown(tester.view.resetPhysicalSize);
    final tts = _MockFlutterTts();
    when(() => tts.setLanguage(any())).thenAnswer((_) async => 1);
    when(tts.stop).thenAnswer((_) async => 1);
    final voice = VoiceIoService(tts);
    addTearDown(voice.dispose);
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: A11yAnnouncer.withSender(
            (_, message, _, _) async => announcements.add(message),
          ),
        ),
        RepositoryProvider.value(
          value: HapticFeedbackService.withDelay((_) async {}),
        ),
        RepositoryProvider.value(value: voice),
        RepositoryProvider<MapTileSource>.value(value: testMapTileSource()),
      ],
      child: MaterialApp(
        theme: AppTheme.dark(),
        locale: const Locale('tr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        ),
        home: child,
      ),
    );
  }

  Future<void> pumpComplex(WidgetTester tester, {double textScale = 1}) async {
    await tester.pumpWidget(
      harness(
        tester,
        BlocProvider(
          create: (_) => ComplexDetailCubit(catalog.complexDetail),
          child: ComplexDetailPage(
            complexId: _suleymaniye,
            onOpenMonument: opened.add,
            onSeeAllMembers: (_) {},
            onShowOnMap: () {},
            onBackToMap: () {},
          ),
        ),
        textScale: textScale,
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> scrollTo(WidgetTester tester, Finder finder, Key scroll) async {
    await tester.scrollUntilVisible(
      finder,
      200,
      scrollable: find
          .descendant(of: find.byKey(scroll), matching: find.byType(Scrollable))
          .first,
    );
    await tester.pumpAndSettle();
  }

  group('ComplexDetailPage', () {
    testWidgets('külliyenin yapıları numaralı liste ve yerleşim planıyla '
        'gösterilir; yapıya dokununca eser detayı açılır', (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpComplex(tester);

      expect(find.text('Süleymaniye Külliyesi'), findsWidgets);
      expect(find.bySemanticsLabel('Yapılar: 11 yapı'), findsOneWidget);

      const scroll = Key('complex_detail_scroll');
      await scrollTo(
        tester,
        find.byKey(const Key('complex_member_suleymaniye-camii')),
        scroll,
      );
      expect(
        find.bySemanticsLabel('1. Süleymaniye Camii, Cami'),
        findsOneWidget,
      );
      await scrollTo(
        tester,
        find.byKey(const Key('complex_member_mimar-sinan-turbesi')),
        scroll,
      );
      expect(
        find.bySemanticsLabel('11. Mimar Sinan Türbesi, Türbe'),
        findsOneWidget,
      );
      // 11 yapı tek sayfadadır: "Tümünü gör" gerekmez.
      expect(
        find.byKey(const Key('complex_members_see_all_button')),
        findsNothing,
      );

      await tester.tap(
        find.byKey(const Key('complex_member_mimar-sinan-turbesi')),
      );
      expect(opened, ['mimar-sinan-turbesi']);

      await scrollTo(
        tester,
        find.byKey(const Key('complex_layout_map')),
        scroll,
      );
      expect(
        find.bySemanticsLabel(RegExp('^Süleymaniye Külliyesi yerleşim planı')),
        findsOneWidget,
      );
      semantics.dispose();
    });

    testWidgets('%200 metin ölçeğinde taşmaz', (tester) async {
      await pumpComplex(tester, textScale: 2);
      await scrollTo(
        tester,
        find.byKey(const Key('complex_member_suleymaniye-hamami')),
        const Key('complex_detail_scroll'),
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('ComplexMembersPage', () {
    testWidgets('tür çipiyle süzülür ve sonuç duyurulur', (tester) async {
      await tester.pumpWidget(
        harness(
          tester,
          BlocProvider(
            create: (_) => ComplexMembersCubit(catalog.complexMembers),
            child: ComplexMembersPage(
              complexId: _suleymaniye,
              complexName: 'Süleymaniye Külliyesi',
              onOpenMonument: opened.add,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Süleymaniye Külliyesi yapıları'), findsOneWidget);
      expect(announcements, contains('11 yapı'));

      await tester.tap(find.byKey(const Key('complex_members_chip_tomb')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('complex_member_hurrem-sultan-turbesi')),
        findsOne,
      );
      expect(
        find.byKey(const Key('complex_member_suleymaniye-camii')),
        findsNothing,
      );
      expect(find.text('Tüm yapılar gösterildi (3)'), findsOneWidget);
      expect(announcements, contains('3 yapı'));
    });
  });

  group('MonumentDetailPage (külliye yapısı)', () {
    Future<void> pumpMonument(
      WidgetTester tester,
      String id, {
      bool settle = true,
    }) async {
      await tester.pumpWidget(
        harness(
          tester,
          BlocProvider(
            create: (_) =>
                MonumentDetailCubit(catalog.detail, catalog.complexMembers),
            child: MonumentDetailPage(
              monumentId: id,
              onShowOnMap: () {},
              onBackToMap: () {},
              onOpenComplex: openedComplexes.add,
              onOpenMonument: opened.add,
            ),
          ),
        ),
      );
      if (settle) {
        await tester.pumpAndSettle();
      } else {
        for (var i = 0; i < 10; i++) {
          await tester.pump(const Duration(milliseconds: 50));
        }
      }
    }

    testWidgets('bağlı olduğu külliyeye geçiş kartı ve diğer yapılar', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await pumpMonument(tester, 'hurrem-sultan-turbesi');

      expect(
        find.bySemanticsLabel('Süleymaniye Külliyesi yapılarından biri'),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const Key('monument_complex_card')));
      expect(openedComplexes, [_suleymaniye]);

      await scrollTo(
        tester,
        find.byKey(const Key('complex_sibling_suleymaniye-hamami')),
        const Key('monument_detail_scroll'),
      );
      expect(
        find.byKey(const Key('complex_sibling_hurrem-sultan-turbesi')),
        findsNothing,
      );
      await tester.tap(
        find.byKey(const Key('complex_sibling_suleymaniye-hamami')),
      );
      expect(opened, ['suleymaniye-hamami']);
      semantics.dispose();
    });

    testWidgets('külliye kimliğiyle açılınca külliye görünümüne geçilir', (
      tester,
    ) async {
      // Yönlendirici sayfayı değiştirir; o ana kadar eser görünümü çizilmez.
      await pumpMonument(tester, _suleymaniye, settle: false);

      expect(openedComplexes, [_suleymaniye]);
      expect(find.byKey(const Key('monument_detail_name')), findsNothing);
      expect(find.byKey(const Key('monument_detail_loading')), findsOneWidget);
    });
  });
}
