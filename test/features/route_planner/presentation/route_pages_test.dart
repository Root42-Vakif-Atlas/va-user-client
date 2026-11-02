import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/a11y/haptic_feedback_service.dart';
import 'package:vakif_atlas/core/events/user_activity_events.dart';
import 'package:vakif_atlas/core/network/session_events.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/map/map_tile_source.dart';
import 'package:vakif_atlas/core/sharing/document_share_service.dart';
import 'package:vakif_atlas/core/storage/installation_id_service.dart';
import 'package:vakif_atlas/core/theme/app_theme.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/features/catalog/domain/usecases/catalog_usecases.dart';
import 'package:vakif_atlas/features/catalog/presentation/bloc/monument_search_bloc.dart';
import 'package:vakif_atlas/features/catalog/presentation/widgets/monument_search_view.dart';
import 'package:vakif_atlas/features/catalog/presentation/widgets/search_filter_bar.dart';
import 'package:vakif_atlas/features/route_export/domain/usecases/route_export_usecases.dart';
import 'package:vakif_atlas/features/route_export/presentation/cubit/route_export_cubit.dart';
import 'package:vakif_atlas/features/route_export/presentation/pages/route_export_preview_page.dart';
import 'package:vakif_atlas/features/route_export/presentation/widgets/route_export_button.dart';
import 'package:vakif_atlas/features/route_planner/data/repositories/route_repository_impl.dart';
import 'package:vakif_atlas/features/route_planner/data/sources/route_remote_data_source.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/route_plan.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/travel_route.dart';
import 'package:vakif_atlas/features/route_planner/domain/usecases/optimize_stop_order_usecase.dart';
import 'package:vakif_atlas/features/route_planner/domain/usecases/route_usecases.dart';
import 'package:vakif_atlas/features/route_planner/presentation/bloc/route_builder_bloc.dart';
import 'package:vakif_atlas/features/route_planner/presentation/cubit/route_detail_cubit.dart';
import 'package:vakif_atlas/features/route_planner/presentation/cubit/route_list_cubit.dart';
import 'package:vakif_atlas/features/route_planner/presentation/pages/route_builder_page.dart';
import 'package:vakif_atlas/features/route_planner/presentation/pages/route_detail_page.dart';
import 'package:vakif_atlas/features/route_planner/presentation/pages/route_list_page.dart';
import 'package:vakif_atlas/features/route_planner/presentation/pages/route_monument_picker_page.dart';

import '../../../helpers/catalog_test_utils.dart';
import '../../../helpers/map_test_utils.dart';
import '../../../helpers/network_test_utils.dart';
import '../../../helpers/route_export_test_utils.dart';
import '../../../support/mock_api/route_planner/mock_route_store.dart';
import '../../../support/mock_api/route_planner/route_mock_api.dart';

class _FakeInstallation extends Mock implements InstallationIdService {}

class _MockGetMonuments extends Mock implements GetMonumentPinsUseCase {}

const _selimiye = 'selimiye-camii';
const _suleymaniye = 'suleymaniye-camii';
const _bursa = 'bursa-ulu-camii';

RoutePlan _plan(String name, List<String> ids) => RoutePlan(
  name: name,
  stops: [
    RouteStopPlan(
      monumentId: ids.first,
      breaks: [RouteBreak.ofKind(RouteBreakKind.meal)],
    ),
    for (final id in ids.skip(1)) RouteStopPlan(monumentId: id),
  ],
);

final _themes = <String, ThemeData>{
  'koyu': AppTheme.dark(),
  'açık': AppTheme.light(),
  'koyu yüksek kontrast': AppTheme.highContrastDark(),
};

void main() {
  late RouteRepositoryImpl repository;
  late _MockGetMonuments getMonuments;
  late List<String> announcements;
  late FakeDocumentShareService shareService;

  setUpAll(() {
    registerFallbackValue(
      const GetMonumentPinsParams(ids: [], languageCode: 'tr'),
    );
  });

  setUp(() {
    final installation = _FakeInstallation();
    when(installation.resolve)
        .thenAnswer((_) async => '0b6f6a0e-1f6c-4d3a-9b1e-3c2d1e0f9a8b');
    repository = RouteRepositoryImpl(
      RouteRemoteDataSourceImpl(
        testDio(RouteMockApi(InMemoryMockRouteStore()).routes),
        installation,
      ),
      UserActivityEvents(),
      SessionEvents(),
    );
    getMonuments = _MockGetMonuments();
    when(() => getMonuments(any())).thenAnswer((invocation) async {
      final params =
          invocation.positionalArguments.single as GetMonumentPinsParams;
      return Right([
        for (final pin in fixturePins())
          if (params.ids.contains(pin.id)) pin,
      ]);
    });
    announcements = [];
    shareService = FakeDocumentShareService();
  });

  Future<TravelRoute> create(String name, List<String> ids) async {
    final result = await repository.createRoute(
      plan: _plan(name, ids),
      languageCode: 'tr',
    );
    return result.fold((failure) => throw StateError('$failure'), (r) => r);
  }

  Future<void> pumpPage(
    WidgetTester tester,
    Widget page, {
    double textScale = 1,
    ThemeData? theme,
  }) async {
    tester.view.physicalSize =
        const Size(390, 844) * tester.view.devicePixelRatio;
    addTearDown(tester.view.resetPhysicalSize);
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
          RepositoryProvider<MapTileSource>.value(value: testMapTileSource()),
          RepositoryProvider<DocumentShareService>.value(value: shareService),
        ],
        child: MaterialApp(
          theme: theme ?? AppTheme.dark(),
          locale: const Locale('tr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(textScale)),
            child: child!,
          ),
          home: page,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('RouteListPage', () {
    late List<String> opened;
    late int draftOpened;

    Widget listPage({int draftStopCount = 0}) => BlocProvider(
      create: (_) => RouteListCubit(
        GetRoutesUseCase(repository),
        WatchRouteChangesUseCase(repository),
      ),
      child: RouteListPage(
        draftStopCount: draftStopCount,
        onOpenRoute: opened.add,
        onOpenDraft: () => draftOpened++,
      ),
    );

    setUp(() {
      opened = [];
      draftOpened = 0;
    });

    testWidgets('boş liste yeni rota çağrısı sunar', (tester) async {
      await pumpPage(tester, listPage());

      expect(find.byKey(const Key('route_list_empty')), findsOneWidget);
      await tester.tap(find.text('Yeni rota').last);
      expect(draftOpened, 1);
    });

    testWidgets('rotalar en yeni üstte, kart semantiği özet taşır', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      final first = await tester.runAsync(
        () => create('Trakya', [_selimiye, _suleymaniye]),
      );
      final second = await tester.runAsync(
        () => create('Marmara', [_suleymaniye, _bursa]),
      );
      await pumpPage(tester, listPage());

      final secondTop = tester.getTopLeft(
        find.byKey(Key('route_card_${second!.id}')),
      );
      final firstTop = tester.getTopLeft(
        find.byKey(Key('route_card_${first!.id}')),
      );
      expect(secondTop.dy, lessThan(firstTop.dy));
      expect(
        find.bySemanticsLabel(
          RegExp(
            r'^Marmara\. 2 durak: İstanbul, Bursa\. Toplam .*Oluşturulma: \d+ \S+ 2026',
          ),
        ),
        findsOneWidget,
      );

      await tester.tap(find.byKey(Key('route_card_${first.id}')));
      expect(opened, [first.id]);
      semantics.dispose();
    });

    testWidgets('taslak şeridi eser sayısını gösterir ve taslağı açar', (
      tester,
    ) async {
      await pumpPage(tester, listPage(draftStopCount: 2));

      expect(find.text('Taslak rotanızda 2 eser var'), findsOneWidget);
      await tester.tap(find.byKey(const Key('route_draft_continue_button')));
      expect(draftOpened, 1);
    });

    testWidgets('başka ekranda oluşturulan rota listeye kendiliğinden düşer', (
      tester,
    ) async {
      await pumpPage(tester, listPage());
      expect(find.byKey(const Key('route_list_empty')), findsOneWidget);

      await tester.runAsync(() => create('Yeni', [_selimiye, _bursa]));
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pumpAndSettle();

      expect(find.text('Yeni'), findsOneWidget);
    });

    for (final MapEntry(key: name, value: theme) in _themes.entries) {
      testWidgets('%200 metin ölçeğinde taşma olmaz ($name)', (tester) async {
        await tester.runAsync(
          () => create('Osmanlı Başkentleri Rotası', [
            _selimiye,
            _suleymaniye,
            _bursa,
          ]),
        );
        await pumpPage(
          tester,
          listPage(draftStopCount: 3),
          textScale: 2,
          theme: theme,
        );

        expect(tester.takeException(), isNull);
      });
    }
  });

  group('RouteDetailPage', () {
    late int deleted;
    late int edits;

    late FakeRoutePdfRenderer renderer;
    late InMemoryRouteExportLocalDataSource exports;
    late int signInRequests;
    late int exportListRequests;

    Widget detailPage(String id, {String? ownerId}) => MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => RouteDetailCubit(
            GetRouteUseCase(repository),
            DeleteRouteUseCase(repository),
            WatchRouteChangesUseCase(repository),
          ),
        ),
        BlocProvider(
          create: (_) {
            final repository = testRouteExportRepository(
              renderer: renderer,
              local: exports,
              remote: FakeRouteExportRemoteDataSource()..session = ownerId,
            );
            return RouteExportCubit(
              CreateRouteExportUseCase(repository),
              CreateRouteExportShareLinkUseCase(repository),
            );
          },
        ),
      ],
      child: RouteDetailPage(
        routeId: id,
        onEdit: () => edits++,
        onDeleted: () => deleted++,
        onBackToList: () {},
        exportActionBuilder: (context, route, {required enabled}) =>
            RouteExportButton(
              route: route,
              enabled: enabled,
              ownerId: ownerId,
              onOpenExports: () => exportListRequests++,
              onSignInToKeepExports: () => signInRequests++,
              previewBuilder: fakePdfPreview,
            ),
      ),
    );

    setUp(() {
      deleted = 0;
      edits = 0;
      signInRequests = 0;
      exportListRequests = 0;
      renderer = FakeRoutePdfRenderer();
      exports = InMemoryRouteExportLocalDataSource();
    });

    Future<void> exportPdf(WidgetTester tester) async {
      await tester.tap(find.byKey(const Key('route_export_button')));
      await tester.pump();
      await tester.pumpAndSettle();
    }

    testWidgets('misafirin PDF\'i kurulumun arşivine kaydedilir; hesaba '
        'taşımak için giriş önerilir', (tester) async {
      final route = await tester.runAsync(
        () => create('Trakya', [_selimiye, _bursa]),
      );
      await pumpPage(tester, detailPage(route!.id));

      await exportPdf(tester);

      expect(find.byKey(const Key('route_export_ready_sheet')), findsOneWidget);
      final fileName = renderer.rendered.single.fileName;
      expect(
        fileName,
        matches(RegExp(r'^vakif-atlas-trakya-\d{4}-\d{2}-\d{2}\.pdf$')),
      );
      expect(announcements, contains('PDF hazır: $fileName'));
      expect(find.textContaining('hesabınıza taşınır'), findsOneWidget);
      expect(exports.records.values.single, hasLength(1));

      await tester.tap(find.byKey(const Key('route_export_share_button')));
      await tester.pump();
      expect(shareService.shared, [fileName]);

      await tester.tap(find.byKey(const Key('route_export_print_button')));
      await tester.pump();
      expect(shareService.printed, [fileName]);

      await tester.tap(find.byKey(const Key('route_export_sign_in_button')));
      await tester.pumpAndSettle();
      expect(signInRequests, 1);
    });

    testWidgets('hazır sayfasından bağlantı kopyalanır; misafirde de', (
      tester,
    ) async {
      final copied = captureClipboard(tester);
      final route = await tester.runAsync(
        () => create('Trakya', [_selimiye, _bursa]),
      );
      await pumpPage(tester, detailPage(route!.id));

      await exportPdf(tester);
      await tester.tap(find.byKey(const Key('route_export_copy_link_button')));
      await tester.pumpAndSettle();

      expect(copied, hasLength(1));
      expect(find.byKey(const Key('route_export_ready_sheet')), findsNothing);
      expect(find.textContaining('Bağlantı kopyalandı'), findsOneWidget);
    });

    testWidgets('hazır sayfasından Dışa aktarımlarım açılır', (tester) async {
      final route = await tester.runAsync(
        () => create('Trakya', [_selimiye, _bursa]),
      );
      await pumpPage(tester, detailPage(route!.id, ownerId: 'usr_1'));

      await exportPdf(tester);
      await tester.tap(
        find.byKey(const Key('route_export_open_exports_button')),
      );
      await tester.pumpAndSettle();

      expect(exportListRequests, 1);
      expect(find.byKey(const Key('route_export_ready_sheet')), findsNothing);
    });

    testWidgets('oturum açıkken PDF kullanıcının arşivine kaydedilir', (
      tester,
    ) async {
      final route = await tester.runAsync(
        () => create('Trakya', [_selimiye, _bursa]),
      );
      await pumpPage(tester, detailPage(route!.id, ownerId: 'usr_1'));

      await exportPdf(tester);

      expect(find.text("Dışa aktarımlarım'a kaydedildi."), findsOneWidget);
      expect(
        find.byKey(const Key('route_export_sign_in_button')),
        findsNothing,
      );
      final saved = exports.records.values.single.values.single;
      expect(saved.routeId, route.id);
      expect(saved.stopCount, 2);
      // Sahip kimliği depoda doğrudan kullanılmaz.
      expect(exports.records.keys.single, isNot(contains('usr_1')));

      await tester.tap(find.byKey(const Key('route_export_preview_button')));
      await tester.pumpAndSettle();
      expect(find.byType(RouteExportPreviewPage), findsOneWidget);
    });

    testWidgets('PDF oluşturulamazsa görsel ve sesli bildirilir', (
      tester,
    ) async {
      renderer.fail = true;
      final route = await tester.runAsync(
        () => create('Trakya', [_selimiye, _bursa]),
      );
      await pumpPage(tester, detailPage(route!.id));

      await exportPdf(tester);

      const message = 'PDF oluşturulamadı. Lütfen tekrar deneyin.';
      expect(find.text(message), findsOneWidget);
      expect(announcements, contains(message));
      expect(find.byKey(const Key('route_export_ready_sheet')), findsNothing);
    });

    testWidgets('dışa aktarma sayfası %200 metinde taşmaz', (tester) async {
      final route = await tester.runAsync(
        () => create('Trakya', [_selimiye, _bursa]),
      );
      await pumpPage(tester, detailPage(route!.id), textScale: 2);
      await exportPdf(tester);
      expect(tester.takeException(), isNull);
    });

    testWidgets('özet, harita ve adım adım plan gösterilir', (tester) async {
      final semantics = tester.ensureSemantics();
      final route = await tester.runAsync(
        () => create('Trakya', [_selimiye, _suleymaniye, _bursa]),
      );
      await pumpPage(tester, detailPage(route!.id));

      expect(find.byKey(const Key('route_map')), findsOneWidget);
      expect(find.text('Edirne → İstanbul → Bursa'), findsOneWidget);
      expect(find.byKey(const Key('route_summary_total')), findsOneWidget);
      expect(
        find.bySemanticsLabel(
          RegExp(
            r'^Durak 1 / 3: Selimiye Camii, .*Edirne\. Ziyaret süresi 1 saat\.$',
          ),
        ),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel('Mola: Yemek molası, 45 dakika'),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel(RegExp(r'^Sonraki durak Süleymaniye Camii: ')),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const Key('route_edit_button')));
      expect(edits, 1);
      semantics.dispose();
    });

    testWidgets('silme onay ister; vazgeçince silinmez, onayla silinir', (
      tester,
    ) async {
      final route = await tester.runAsync(
        () => create('Trakya', [_selimiye, _bursa]),
      );
      await pumpPage(tester, detailPage(route!.id));

      await tester.tap(find.byKey(const Key('route_delete_button')));
      await tester.pumpAndSettle();
      expect(
        find.text('"Trakya" kalıcı olarak silinecek. Bu işlem geri alınamaz.'),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const Key('route_delete_cancel_button')));
      await tester.pumpAndSettle();
      expect(deleted, 0);

      await tester.tap(find.byKey(const Key('route_delete_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('route_delete_confirm_button')));
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pumpAndSettle();

      expect(deleted, 1);
      expect(announcements, contains('Rota silindi'));
      final remaining = await tester.runAsync(
        () => repository.getRoutes(languageCode: 'tr'),
      );
      expect(remaining!.fold((_) => null, (routes) => routes), isEmpty);
    });

    testWidgets('bulunamayan rota için listeye dönüş sunulur', (tester) async {
      await pumpPage(tester, detailPage('rt_yok'));

      expect(find.byKey(const Key('route_detail_not_found')), findsOneWidget);
      expect(announcements, contains('Rota bulunamadı'));
    });

    testWidgets('dokunma hedefleri erişilebilirlik kılavuzlarına uyar', (
      tester,
    ) async {
      final route = await tester.runAsync(
        () => create('Trakya', [_selimiye, _bursa]),
      );
      await pumpPage(tester, detailPage(route!.id));

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    });

    for (final MapEntry(key: name, value: theme) in _themes.entries) {
      testWidgets('%200 metin ölçeğinde taşma olmaz ($name)', (tester) async {
        final route = await tester.runAsync(
          () =>
              create('Osmanlı Başkentleri', [_selimiye, _suleymaniye, _bursa]),
        );
        await pumpPage(
          tester,
          detailPage(route!.id),
          textScale: 2,
          theme: theme,
        );
        await tester.scrollUntilVisible(
          find.byKey(const Key('route_step_stop_2')),
          300,
          scrollable: find
              .descendant(
                of: find.byKey(const Key('route_detail_scroll')),
                matching: find.byType(Scrollable),
              )
              .first,
        );

        expect(tester.takeException(), isNull);
      });
    }
  });

  group('RouteBuilderPage', () {
    late RouteBuilderBloc bloc;
    late List<TravelRoute> saved;

    setUp(() => saved = []);

    Future<void> pumpBuilder(
      WidgetTester tester, {
      List<String> stops = const [],
      double textScale = 1,
      ThemeData? theme,
    }) async {
      // BLoC'u sağlayıcı oluşturur ve sayfa kaldırılınca kapatır (uygulamadaki
      // gibi); testin sahte zaman bölgesinde oluşturulması da gerekir.
      await pumpPage(
        tester,
        MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) {
                bloc = RouteBuilderBloc(
                  getMonuments,
                  GetRouteUseCase(repository),
                  SaveRouteUseCase(repository),
                  const OptimizeStopOrderUseCase(),
                  PreviewRouteUseCase(repository),
                  GetTravelMatrixUseCase(repository),
                );
                for (final id in stops) {
                  bloc.add(RouteBuilderEvent.monumentToggled(id));
                }
                return bloc;
              },
            ),
            BlocProvider(
              create: (_) => MonumentSearchBloc(catalogUseCases().search),
            ),
          ],
          child: RouteBuilderPage(onSaved: saved.add),
        ),
        textScale: textScale,
        theme: theme,
      );
    }

    testWidgets('yukarı/aşağı butonlarıyla sıralanır ve duyurulur', (
      tester,
    ) async {
      await pumpBuilder(tester, stops: [_selimiye, _suleymaniye, _bursa]);

      expect(
        tester
            .widget<IconButton>(find.byKey(const Key('route_stop_up_0')))
            .onPressed,
        isNull,
      );
      await tester.tap(find.byKey(const Key('route_stop_down_0')));
      await tester.pumpAndSettle();

      expect(bloc.state.stops.map((s) => s.monumentId), [
        _suleymaniye,
        _selimiye,
        _bursa,
      ]);
      expect(announcements, contains('Selimiye Camii 2. sıraya taşındı'));
    });

    testWidgets('karayolu ön hesabı özet, durak kartı ve haritada gösterilir', (
      tester,
    ) async {
      await pumpBuilder(tester, stops: [_selimiye, _bursa]);
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pumpAndSettle();

      expect(bloc.state.currentPreview, isNotNull);
      expect(find.textContaining('Sonraki durağa karayolu'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.byKey(const Key('route_builder_map')),
        300,
        scrollable: find
            .descendant(
              of: find.byKey(const Key('route_builder_list')),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      expect(find.byKey(const Key('route_builder_map')), findsOneWidget);
    });

    testWidgets('süre ayarlayıcı ekran okuyucuya ayarlanabilir sunulur', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await pumpBuilder(tester, stops: [_selimiye, _bursa]);

      final stepper = find.byKey(const Key('route_stop_visit_0'));
      expect(
        tester.getSemantics(
          find.descendant(of: stepper, matching: find.byType(Semantics)).first,
        ),
        matchesSemantics(
          label: 'Ziyaret süresi',
          value: '1 saat',
          increasedValue: '1 saat 15 dakika',
          decreasedValue: '45 dakika',
          hasIncreaseAction: true,
          hasDecreaseAction: true,
          children: [
            matchesSemantics(
              tooltip: 'Ziyaret süresi: azalt',
              isButton: true,
              hasEnabledState: true,
              isEnabled: true,
              isFocusable: true,
              hasTapAction: true,
              hasFocusAction: true,
            ),
            matchesSemantics(
              tooltip: 'Ziyaret süresi: artır',
              isButton: true,
              hasEnabledState: true,
              isEnabled: true,
              isFocusable: true,
              hasTapAction: true,
              hasFocusAction: true,
            ),
          ],
        ),
      );
      semantics.dispose();
    });

    testWidgets('oluştur POST /routes ile kaydeder ve geri çağırır', (
      tester,
    ) async {
      await pumpBuilder(tester, stops: [_selimiye, _bursa]);

      await tester.tap(find.byKey(const Key('route_submit_button')));
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pumpAndSettle();

      expect(saved.single.name, 'Edirne – Bursa Rotası');
      expect(saved.single.summary.distanceMeters, greaterThan(200000));
      // Yeni rota taslağı kayıttan sonra temizlenir.
      expect(bloc.state.stops, isEmpty);
    });

    testWidgets('dokunma hedefleri erişilebilirlik kılavuzlarına uyar', (
      tester,
    ) async {
      await pumpBuilder(tester, stops: [_selimiye, _bursa]);
      bloc.add(
        const RouteBuilderEvent.breakAdded(
          stopIndex: 0,
          kind: RouteBreakKind.meal,
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    });

    for (final MapEntry(key: name, value: theme) in _themes.entries) {
      testWidgets('%200 metin ölçeğinde taşma olmaz ($name)', (tester) async {
        await pumpBuilder(
          tester,
          stops: [_selimiye, _suleymaniye],
          textScale: 2,
          theme: theme,
        );
        bloc.add(
          const RouteBuilderEvent.breakAdded(
            stopIndex: 0,
            kind: RouteBreakKind.overnight,
          ),
        );
        await tester.pumpAndSettle();
        await tester.scrollUntilVisible(
          find.byKey(const Key('route_stop_remove_1')),
          300,
          scrollable: find
              .descendant(
                of: find.byKey(const Key('route_builder_list')),
                matching: find.byType(Scrollable),
              )
              .first,
        );

        expect(tester.takeException(), isNull);
      });
    }

    Future<void> openPicker(WidgetTester tester) async {
      await tester.tap(find.byKey(const Key('route_add_monuments_button')));
      await tester.pumpAndSettle();
      expect(find.byType(RouteMonumentPickerPage), findsOneWidget);
    }

    Future<void> search(WidgetTester tester, String text) async {
      await tester.enterText(
        find.byKey(const Key('monument_search_field')),
        text,
      );
      await tester.pump(MonumentSearchView.debounce);
      await tester.pumpAndSettle();
    }

    testWidgets('eser seçici haritadaki arama ve filtreleri kullanır; seçim '
        'taslağa eklenir', (tester) async {
      await pumpBuilder(tester);
      await openPicker(tester);
      expect(find.byType(SearchFilterBar), findsOneWidget);
      // Liste sunucudan sayfalı gelir; tüm katalog indirilmez.
      expect(find.text('20 sonuç'), findsOneWidget);
      verifyNever(() => getMonuments(any()));

      await search(tester, 'kizlaragasi');
      expect(find.byKey(const Key('route_pick_$_selimiye')), findsNothing);
      await tester.tap(find.byKey(const Key('route_pick_kizlaragasi-hani')));
      await tester.pump();

      expect(bloc.state.monument('kizlaragasi-hani')?.city, 'İzmir');
      expect(announcements, contains('Kızlarağası Hanı rotaya eklendi'));
      expect(find.text('Duraklar (1/10)'), findsOneWidget);
      expect(
        tester
            .widget<CheckboxListTile>(
              find.byKey(const Key('route_pick_kizlaragasi-hani')),
            )
            .value,
        isTrue,
      );

      await tester.tap(find.byKey(const Key('route_picker_done_button')));
      await tester.pumpAndSettle();
      expect(find.byType(RouteMonumentPickerPage), findsNothing);
      expect(find.text('Kızlarağası Hanı'), findsOneWidget);
      // Seçilen eserin bilgisi aramadan geldiği için ek istek yapılmaz.
      verifyNever(() => getMonuments(any()));
    });

    testWidgets('filtre çipiyle daraltılır; seçici yeniden açılınca son '
        'arama korunur', (tester) async {
      await pumpBuilder(tester);
      await openPicker(tester);

      await tester.tap(find.byKey(const Key('search_filter_city')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('filter_option_16')));
      await tester.tap(find.byKey(const Key('filter_sheet_apply')));
      await tester.pumpAndSettle();
      expect(find.text('1 sonuç'), findsOneWidget);

      await tester.tap(find.byKey(const Key('route_picker_done_button')));
      await tester.pumpAndSettle();
      await openPicker(tester);
      expect(find.text('1 sonuç'), findsOneWidget);
    });

    testWidgets('sınır doluyken seçilmemiş eserler devre dışı ve nedeni '
        'yazılır', (tester) async {
      final ids = [
        for (final pin in fixturePins().take(RoutePlanRules.maxStops)) pin.id,
      ];
      await pumpBuilder(tester, stops: ids.take(9).toList());
      await openPicker(tester);
      expect(find.byKey(const Key('route_picker_full_hint')), findsNothing);

      await search(tester, fixturePins()[9].name);
      await tester.tap(find.byKey(Key('route_pick_${ids[9]}')));
      await tester.pump();
      expect(find.byKey(const Key('route_picker_full_hint')), findsOneWidget);

      await search(tester, '');
      final other = tester
          .widgetList<CheckboxListTile>(find.byType(CheckboxListTile))
          .where((tile) => tile.value == false);
      expect(other.every((tile) => tile.onChanged == null), isTrue);
    });

    for (final MapEntry(key: name, value: theme) in _themes.entries) {
      testWidgets('eser seçici %200 metin ölçeğinde taşmaz ($name)', (
        tester,
      ) async {
        await pumpBuilder(tester, textScale: 2, theme: theme);
        await openPicker(tester);
        await tester.tap(find.byType(CheckboxListTile).first);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('eser seçici erişilebilirlik kılavuzlarına uyar', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await pumpBuilder(tester);
      await openPicker(tester);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      semantics.dispose();
    });
  });
}
