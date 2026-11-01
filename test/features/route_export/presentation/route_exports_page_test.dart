import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/a11y/haptic_feedback_service.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/sharing/document_share_service.dart';
import 'package:vakif_atlas/core/theme/app_theme.dart';
import 'package:vakif_atlas/features/route_export/data/repositories/route_export_repository_impl.dart';
import 'package:vakif_atlas/features/route_export/domain/entities/route_document.dart';
import 'package:vakif_atlas/features/route_export/domain/usecases/route_export_usecases.dart';
import 'package:vakif_atlas/features/route_export/presentation/cubit/route_exports_cubit.dart';
import 'package:vakif_atlas/features/route_export/presentation/pages/route_export_preview_page.dart';
import 'package:vakif_atlas/features/route_export/presentation/pages/route_exports_page.dart';

import '../../../helpers/route_export_test_utils.dart';

RouteDocument _document(String name) => RouteDocument(
  routeId: 'rt_$name',
  title: name,
  subtitle: 's',
  languageCode: 'tr',
  fileName: 'vakif-atlas-$name.pdf',
  facts: const [],
  stops: const [],
  path: const [],
  labels: const RouteDocumentLabels(
    brand: 'b',
    summaryHeading: 's',
    sketchHeading: 'k',
    sketchCaption: 'c',
    stopsHeading: 'd',
    mapLink: 'm',
    disclaimer: 'x',
    attribution: 'a',
    generatedOn: 'g',
    pageOf: 'p',
  ),
);

void main() {
  late RouteExportRepositoryImpl repository;
  late FakeRouteExportRemoteDataSource remote;
  late FakeDocumentShareService share;
  late List<String> announcements;
  late int routeListRequests;

  setUp(() {
    routeListRequests = 0;
    remote = FakeRouteExportRemoteDataSource()..session = 'usr_1';
    repository = testRouteExportRepository(
      renderer: FakeRoutePdfRenderer(),
      local: InMemoryRouteExportLocalDataSource(),
      remote: remote,
    );
    share = FakeDocumentShareService();
    announcements = [];
  });

  Future<void> pumpPage(
    WidgetTester tester, {
    String? ownerId = 'usr_1',
    double textScale = 1,
    ThemeData? theme,
  }) async {
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
          RepositoryProvider<DocumentShareService>.value(value: share),
        ],
        child: MaterialApp(
          theme: theme ?? AppTheme.light(),
          locale: const Locale('tr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(textScale)),
            child: child!,
          ),
          home: BlocProvider(
            create: (_) => RouteExportsCubit(
              GetRouteExportsUseCase(repository),
              OpenRouteExportUseCase(repository),
              CreateRouteExportShareLinkUseCase(repository),
              DeleteRouteExportUseCase(repository),
              WatchRouteExportChangesUseCase(repository),
            ),
            child: RouteExportsPage(
              ownerId: ownerId,
              onOpenRoutes: () => routeListRequests++,
              previewBuilder: fakePdfPreview,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<String> create(WidgetTester tester, String name) async {
    final result = await tester.runAsync(
      () =>
          repository.createExport(document: _document(name), ownerId: 'usr_1'),
    );
    return result!.getOrNull()!.saved!.id;
  }

  testWidgets('boş arşivde nasıl dışa aktarılacağı anlatılır; Rotalarım\'a '
      'gidilir', (tester) async {
    await pumpPage(tester);
    expect(find.byKey(const Key('route_exports_empty')), findsOneWidget);

    await tester.tap(find.text('Rotalarım'));
    expect(routeListRequests, 1);
  });

  testWidgets('kayıtlar en yenisi önce listelenir', (tester) async {
    await create(tester, 'Trakya');
    await create(tester, 'Ege');
    await pumpPage(tester);

    final titles = tester
        .widgetList<ListTile>(find.byType(ListTile))
        .map((tile) => (tile.title! as Text).data)
        .toList();
    expect(titles, ['Ege', 'Trakya']);
    expect(find.textContaining('0 durak · 1 KB'), findsNWidgets(2));
  });

  testWidgets('misafir kurulumun dışa aktarımlarını görür', (tester) async {
    await create(tester, 'Hesap');
    remote.session = null;
    final result = await tester.runAsync(
      () => repository.createExport(document: _document('Misafir')),
    );
    expect(result!.getOrNull()!.saved, isNotNull);
    await pumpPage(tester, ownerId: null);

    final titles = tester
        .widgetList<ListTile>(find.byType(ListTile))
        .map((tile) => (tile.title! as Text).data)
        .toList();
    expect(titles, ['Misafir']);
  });

  testWidgets('başka hesabın dışa aktarımları görünmez', (tester) async {
    await create(tester, 'Trakya');
    remote.session = 'usr_2';
    await pumpPage(tester, ownerId: 'usr_2');
    expect(find.byKey(const Key('route_exports_empty')), findsOneWidget);
  });

  testWidgets('dokununca önizleme açılır; menüden paylaşılır', (tester) async {
    final id = await create(tester, 'Trakya');
    await pumpPage(tester);

    await tester.tap(find.byKey(Key('route_export_$id')));
    await tester.pumpAndSettle();
    expect(find.byType(RouteExportPreviewPage), findsOneWidget);
    await tester.tap(find.byKey(const Key('route_export_preview_share')));
    await tester.pump();
    expect(share.shared, ['vakif-atlas-Trakya.pdf']);
    await tester.tap(find.byType(CloseButton));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key('route_export_menu_$id')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('route_export_action_print')));
    await tester.pumpAndSettle();
    expect(share.printed, ['vakif-atlas-Trakya.pdf']);
  });

  testWidgets('menüden bağlantı kopyalanır; geçerlilik ve erişim bildirilir', (
    tester,
  ) async {
    final copied = captureClipboard(tester);
    final id = await create(tester, 'Trakya');
    await pumpPage(tester);

    await tester.tap(find.byKey(Key('route_export_menu_$id')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('route_export_action_copy_link')));
    await tester.pumpAndSettle();

    expect(copied.single, contains('$id.pdf'));
    expect(find.textContaining('Bağlantı kopyalandı'), findsOneWidget);
    expect(
      announcements.last,
      allOf(contains('Bağlantıya sahip herkes'), contains('25 Ekim')),
    );
  });

  testWidgets('paylaşım açılamazsa bildirilir', (tester) async {
    share.result = false;
    final id = await create(tester, 'Trakya');
    await pumpPage(tester);

    await tester.tap(find.byKey(Key('route_export_menu_$id')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('route_export_action_share')));
    await tester.pumpAndSettle();

    expect(find.text('Paylaşım penceresi açılamadı.'), findsOneWidget);
    expect(announcements, contains('Paylaşım penceresi açılamadı.'));
  });

  testWidgets('silme onay ister; onayla silinir ve duyurulur', (tester) async {
    final id = await create(tester, 'Trakya');
    await pumpPage(tester);

    await tester.tap(find.byKey(Key('route_export_menu_$id')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('route_export_action_delete')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('route_export_delete_cancel')));
    await tester.pumpAndSettle();
    expect(find.byKey(Key('route_export_$id')), findsOneWidget);

    await tester.tap(find.byKey(Key('route_export_menu_$id')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('route_export_action_delete')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('route_export_delete_confirm')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('route_exports_empty')), findsOneWidget);
    expect(announcements, contains('Dışa aktarım silindi'));
  });

  for (final (name, theme) in [
    ('açık', AppTheme.light()),
    ('koyu yüksek kontrast', AppTheme.highContrastDark()),
  ]) {
    testWidgets('%200 metinde taşmaz ve kılavuzlara uyar ($name)', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await create(tester, 'Trakya ve Marmara Klasikleri');
      await pumpPage(tester, textScale: 2, theme: theme);

      expect(tester.takeException(), isNull);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      semantics.dispose();
    });
  }
}
