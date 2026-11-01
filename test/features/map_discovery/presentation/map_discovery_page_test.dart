import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/a11y/haptic_feedback_service.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/location/location_service.dart';
import 'package:vakif_atlas/core/map/map_tile_source.dart';
import 'package:vakif_atlas/core/theme/app_theme.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/geo_point.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/map_tile.dart';
import 'package:vakif_atlas/features/catalog/domain/usecases/catalog_usecases.dart';
import 'package:vakif_atlas/features/catalog/presentation/bloc/monument_search_bloc.dart';
import 'package:vakif_atlas/features/map_discovery/presentation/bloc/map_discovery_bloc.dart';
import 'package:vakif_atlas/features/map_discovery/presentation/cubit/monument_tiles_cubit.dart';
import 'package:vakif_atlas/features/map_discovery/presentation/cubit/user_location_cubit.dart';
import 'package:vakif_atlas/features/map_discovery/presentation/pages/map_discovery_page.dart';
import 'package:vakif_atlas/features/map_discovery/presentation/pages/monument_search_page.dart';
import 'package:vakif_atlas/features/map_discovery/presentation/widgets/monument_markers.dart';
import 'package:vakif_atlas/features/saved_monuments/presentation/cubit/saved_monuments_cubit.dart';
import 'package:vakif_atlas/features/saved_monuments/presentation/widgets/saved_monument_feedback.dart';
import 'package:vakif_atlas/features/saved_monuments/presentation/widgets/saved_monuments_map_button.dart';
import 'package:vakif_atlas/shared/widgets/molecules/monument_save_button.dart';
import 'package:vakif_atlas/shared/widgets/organisms/app_map.dart';
import 'package:vakif_atlas/shared/widgets/organisms/map_cluster_marker.dart';
import 'package:vakif_atlas/shared/widgets/organisms/map_complex_marker.dart';
import 'package:vakif_atlas/core/map/map_tiles.dart';
import 'package:vakif_atlas/features/map_discovery/presentation/widgets/complex_footprint_layer.dart';
import 'package:vakif_atlas/shared/widgets/organisms/map_pin.dart';

import '../../../helpers/catalog_test_utils.dart';
import '../../../helpers/location_test_utils.dart';
import '../../../helpers/map_test_utils.dart';
import '../../../helpers/saved_monuments_test_utils.dart';
import '../../../support/mock_api/catalog/catalog_mock_api.dart';

class _MockGetExtent extends Mock implements GetMapExtentUseCase {}

void main() {
  late _MockGetExtent getExtent;
  late List<String> announcements;
  late List<String> openedMonuments;
  late List<String> openedComplexes;
  late FakeLocationService location;
  late CatalogUseCases catalog;

  setUpAll(() {
    registerFallbackValue(const GetMapExtentParams(languageCode: 'tr'));
  });

  setUp(() {
    getExtent = _MockGetExtent();
    announcements = [];
    openedMonuments = [];
    openedComplexes = [];
    location = FakeLocationService();
    // İllerin 10 temsilcisi (tek arama sayfası); külliye senaryoları tam
    // katalogla ayrı testlerdedir.
    catalog = catalogUseCases(CatalogMockApi.withMonuments(provinceMonuments));
    // Gerçek mock sunucu; çağrılar doğrulanabilsin diye sarılır.
    when(() => getExtent(any())).thenAnswer(
      (invocation) => catalog.extent(
        invocation.positionalArguments.single as GetMapExtentParams,
      ),
    );
  });

  /// Animasyonlar biter, kamera durma gecikmesi geçer ve görünür karolar
  /// yüklenir (kamera hareketi yeni karo isteği doğurabildiğinden iki tur).
  Future<void> settleMap(WidgetTester tester) async {
    for (var i = 0; i < 2; i++) {
      await tester.pumpAndSettle();
      await tester.pump(AppMap.cameraIdleDelay);
    }
    await tester.pumpAndSettle();
  }

  Future<void> pumpPage(
    WidgetTester tester, {
    String? focusMonumentId,
    Locale locale = const Locale('tr'),
    double textScale = 1,
    ThemeData? theme,
    Widget? savedButton,
    MapPreviewActionBuilder? previewActionBuilder,
    Size size = const Size(390, 844),
  }) async {
    tester.view.physicalSize = size * tester.view.devicePixelRatio;
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
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) =>
                  MapDiscoveryBloc(getExtent, catalog.detail, catalog.search),
            ),
            BlocProvider(create: (_) => MonumentTilesCubit(catalog.tile)),
            BlocProvider(create: (_) => UserLocationCubit(location)),
          ],
          child: MaterialApp(
            theme: theme ?? AppTheme.dark(),
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(textScale)),
              child: child!,
            ),
            home: Builder(
              builder: (context) => MapDiscoveryPage(
                focusMonumentId: focusMonumentId,
                savedButton: savedButton,
                previewActionBuilder: previewActionBuilder,
                onOpenMonument: openedMonuments.add,
                onOpenComplex: openedComplexes.add,
                onOpenSearch: (initial) =>
                    Navigator.of(context).push<MonumentSearchResult>(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) => MonumentSearchBloc(catalog.search),
                          child: MonumentSearchPage(initialQuery: initial),
                        ),
                      ),
                    ),
              ),
            ),
          ),
        ),
      ),
    );
    await settleMap(tester);
  }

  /// Eser pini veya (külliyede) külliye işaretçisi.
  Finder pin(String id) => find.byWidgetPredicate(
    (widget) =>
        widget.key == Key('monument_pin_$id') ||
        widget.key == Key('monument_complex_$id'),
  );

  /// [location] konumunu içeren sunucu kümelerine dokunarak, eser ayrı pin
  /// olarak görünene (veya [until] sağlanana) kadar yakınlaşır.
  Future<void> expandTowards(
    WidgetTester tester,
    GeoPoint location, {
    required bool Function() until,
  }) async {
    for (var i = 0; i < 10 && !until(); i++) {
      final items = tester
          .widget<MonumentClusterLayer>(find.byType(MonumentClusterLayer))
          .items;
      final cluster = items.whereType<MapTileCluster>().firstWhere(
        (c) =>
            location.latitude >= c.bounds.south - 1e-9 &&
            location.latitude <= c.bounds.north + 1e-9 &&
            location.longitude >= c.bounds.west - 1e-9 &&
            location.longitude <= c.bounds.east + 1e-9,
      );
      await tester.tap(find.byKey(Key('monument_cluster_${cluster.key}')));
      await settleMap(tester);
    }
  }

  Future<void> revealPin(WidgetTester tester, String id) async {
    final location = fixturePins().firstWhere((p) => p.id == id).location!;
    await expandTowards(
      tester,
      location,
      until: () => pin(id).evaluate().isNotEmpty,
    );
    expect(pin(id), findsOneWidget, reason: id);
  }

  Future<void> tapPin(WidgetTester tester, String id) async {
    await revealPin(tester, id);
    await tester.tap(pin(id));
    await tester.pumpAndSettle();
  }

  testWidgets('pinler ve kümeler ekran okuyucu etiketleriyle gösterilir; '
      'her eser tam bir kez temsil edilir', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpPage(tester);

    final clusters = tester
        .widgetList<MapClusterMarker>(find.byType(MapClusterMarker))
        .toList();
    // Sahip Ata ve Divriği külliyedir (mavi işaretçi; üyeleri kataloğa
    // eklenmemiş).
    final singles =
        find.byType(MapPin).evaluate().length +
        find.byType(MapComplexMarker).evaluate().length;
    expect(clusters, isNotEmpty, reason: 'genel ölçekte yakın eserler');
    expect(singles + clusters.fold<int>(0, (sum, c) => sum + c.count), 10);
    final first = clusters.first;
    expect(
      find.bySemanticsLabel(
        '${first.count} eserlik küme. Yakınlaştırmak için dokunun.',
      ),
      findsWidgets,
    );
    expect(
      find.bySemanticsLabel('Vakıf eserleri haritası, 10 eser'),
      findsOneWidget,
    );
    expect(announcements, contains('10 eser haritada gösteriliyor'));
    verify(() => getExtent(const GetMapExtentParams(languageCode: 'tr')))
        .called(1);
    semantics.dispose();
  });

  testWidgets('kümeye dokununca bölündüğü seviyeye yakınlaşılır ve '
      'duyurulur; eser etiketleri görünür', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpPage(tester);
    final layer = find.byType(MonumentClusterLayer);
    final zoomBefore = MapCamera.of(tester.element(layer)).zoom;
    final cluster = tester
        .widget<MonumentClusterLayer>(layer)
        .items
        .whereType<MapTileCluster>()
        .first;

    await tester.tap(find.byKey(Key('monument_cluster_${cluster.key}')));
    await settleMap(tester);

    expect(MapCamera.of(tester.element(layer)).zoom, greaterThan(zoomBefore));
    expect(
      announcements,
      contains('${cluster.count} eserlik bölgeye yakınlaştırıldı'),
    );
    await revealPin(tester, 'suleymaniye-camii');
    expect(
      find.bySemanticsLabel('Süleymaniye Camii, Fatih, İstanbul'),
      findsOneWidget,
    );
    semantics.dispose();
  });

  testWidgets('aynı konumdaki eserlerin kümesi liste açar; seçim önizler', (
    tester,
  ) async {
    // Yapay veri: her konumda iki eser (pin ve önizleme aynı sunucudan).
    catalog = catalogUseCases(
      CatalogMockApi.withMonuments(syntheticMonuments(20)),
    );
    await pumpPage(tester);

    // Trabzon'daki iki eser hiçbir seviyede ayrışmaz.
    final trabzon = fixturePins()[9].location!;
    expect(fixturePins()[9].id, 'gulbahar-hatun-camii');
    await expandTowards(
      tester,
      trabzon,
      until: () =>
          find.byKey(const Key('monument_cluster_list')).evaluate().isNotEmpty,
    );

    expect(find.text('Bu konumdaki eserler'), findsOneWidget);
    expect(find.byKey(const Key('monument_cluster_item_test-009')), findsOne);
    expect(find.byKey(const Key('monument_cluster_item_test-019')), findsOne);

    await tester.tap(find.byKey(const Key('monument_cluster_item_test-019')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('monument_cluster_list')), findsNothing);
    expect(
      find.descendant(
        of: find.byKey(const Key('monument_preview_card')),
        matching: find.text('Test Eseri 019'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('pine dokununca önizleme açılır ve detaya geçilir', (
    tester,
  ) async {
    await pumpPage(tester);
    expect(find.byKey(const Key('monument_preview_card')), findsNothing);

    await tapPin(tester, 'kizlaragasi-hani');

    final card = find.byKey(const Key('monument_preview_card'));
    expect(card, findsOneWidget);
    expect(
      find.descendant(of: card, matching: find.text('Kızlarağası Hanı')),
      findsOneWidget,
    );
    expect(find.text('Konak, İzmir'), findsOneWidget);
    expect(find.textContaining('871. Sokak'), findsOneWidget);
    expect(find.text('Han'), findsOneWidget);
    expect(find.text('Osmanlı'), findsOneWidget);
    expect(announcements, contains('Kızlarağası Hanı seçildi'));

    expect(
      tester.getSemantics(pin('kizlaragasi-hani')),
      isSemantics(
        isButton: true,
        isSelected: true,
        label: 'Kızlarağası Hanı, Konak, İzmir',
      ),
    );

    // Birincil aksiyon kaydırmadan görünür ve dokunulabilir.
    final details = find.byKey(const Key('monument_preview_details_button'));
    final screenHeight =
        tester.view.physicalSize.height / tester.view.devicePixelRatio;
    expect(tester.getRect(details).bottom, lessThanOrEqualTo(screenHeight));
    await tester.tap(details);
    expect(openedMonuments, ['kizlaragasi-hani']);

    await tester.tap(find.byKey(const Key('monument_preview_close_button')));
    await tester.pumpAndSettle();
    expect(card, findsNothing);
  });

  testWidgets('derin bağlantıdaki eser açılışta seçili gelir', (tester) async {
    await pumpPage(tester, focusMonumentId: 'gulbahar-hatun-camii');

    expect(
      find.descendant(
        of: find.byKey(const Key('monument_preview_card')),
        matching: find.text('Gülbahar Hatun Camii'),
      ),
      findsOneWidget,
    );
  });

  group('külliye', () {
    // Tam katalog: Süleymaniye Külliyesi ve yapıları.
    setUp(() => catalog = catalogUseCases());

    testWidgets('yapı seçilince külliyenin açıldığı zum: yerleşim alanı ve '
        'külliye konturlu, külliye adıyla okunan yapı pinleri', (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpPage(tester, focusMonumentId: 'hurrem-sultan-turbesi');

      final layer = find.byType(MonumentClusterLayer);
      expect(
        MapCamera.of(tester.element(layer)).zoom,
        MapTiles.complexExpandZoom,
      );
      final footprints = tester.widget<ComplexFootprintLayer>(
        find.byType(ComplexFootprintLayer),
      );
      expect(footprints.complexes.single.pin.id, 'suleymaniye-kulliyesi');
      expect(footprints.complexes.single.footprint.length, greaterThan(2));
      expect(
        find.bySemanticsLabel(
          'Süleymaniye Külliyesi yerleşim alanı. Külliyeyi seçmek için '
          'dokunun.',
        ),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel(
          'Süleymaniye Hamamı, Süleymaniye Külliyesi içinde',
        ),
        findsOneWidget,
      );
      final hamam = tester.widget<MapPin>(
        find.byKey(const Key('monument_pin_suleymaniye-hamami')),
      );
      expect(hamam.memberOfComplex, isTrue);
      // Önizlemede bağlı olduğu külliyeye geçiş.
      await tester.tap(
        find.byKey(const Key('monument_preview_complex_button')),
      );
      expect(openedComplexes, ['suleymaniye-kulliyesi']);

      // Birbirine çok yakın türbeler ekranda birleşir; kümeye dokunmak
      // yakınlaştırır (külliye kapanmaz). Seçili pin kümenin üstünde
      // çizildiğinden önce seçim kapatılır.
      await tester.tap(find.byKey(const Key('monument_preview_close_button')));
      await settleMap(tester);
      final cluster = tester
          .widget<MonumentClusterLayer>(layer)
          .items
          .whereType<MapTileCluster>()
          .first;
      await tester.tap(find.byKey(Key('monument_cluster_${cluster.key}')));
      await settleMap(tester);
      expect(
        MapCamera.of(tester.element(layer)).zoom,
        greaterThan(MapTiles.complexExpandZoom),
      );
      expect(find.byType(ComplexFootprintLayer), findsOneWidget);
      semantics.dispose();
    });

    testWidgets('külliye önizlemesi yapı sayısını gösterir; detay külliye '
        'görünümünde açılır', (tester) async {
      await pumpPage(tester, focusMonumentId: 'suleymaniye-kulliyesi');

      final card = find.byKey(const Key('monument_preview_card'));
      expect(
        find.descendant(of: card, matching: find.text('11 yapı')),
        findsOneWidget,
      );
      await tester.tap(
        find.byKey(const Key('monument_preview_details_button')),
      );
      expect(openedComplexes, ['suleymaniye-kulliyesi']);
      expect(openedMonuments, isEmpty);
    });
  });

  testWidgets('içerik arayüz dilinde istenir', (tester) async {
    await pumpPage(tester, locale: const Locale('en'));

    verify(() => getExtent(const GetMapExtentParams(languageCode: 'en')))
        .called(1);
    await tapPin(tester, 'gulbahar-hatun-camii');
    expect(find.text('Gülbahar Hatun Mosque'), findsWidgets);
    expect(find.text('View details'), findsOneWidget);
  });

  testWidgets('yükleme hatasında mesaj ve tekrar dene gösterilir', (
    tester,
  ) async {
    when(() => getExtent(any()))
        .thenAnswer((_) async => const Left(NetworkFailure()));
    await pumpPage(tester);

    expect(find.byKey(const Key('map_load_error_panel')), findsOneWidget);
    expect(find.text('Eserler yüklenemedi'), findsOneWidget);
    expect(announcements.last, contains('sunucusuna şu anda ulaşılamıyor'));

    when(() => getExtent(any())).thenAnswer(
      (invocation) => catalog.extent(
        invocation.positionalArguments.single as GetMapExtentParams,
      ),
    );
    await tester.tap(find.byKey(const Key('map_retry_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('map_load_error_panel')), findsNothing);
    expect(find.byType(MapClusterMarker), findsWidgets);
  });

  testWidgets('harita kontrolleri 56 dp ve etiketli', (tester) async {
    await pumpPage(tester);

    for (final key in [
      'map_zoom_in_button',
      'map_zoom_out_button',
      'map_show_all_button',
      'map_locate_button',
    ]) {
      final size = tester.getSize(find.byKey(Key(key)));
      expect(size.width, greaterThanOrEqualTo(56), reason: key);
      expect(size.height, greaterThanOrEqualTo(56), reason: key);
    }
    expect(find.byTooltip('Yakınlaştır'), findsOneWidget);
    expect(find.byTooltip('Uzaklaştır'), findsOneWidget);
    expect(find.byTooltip('Tüm eserleri göster'), findsOneWidget);
    expect(find.byTooltip('Konumumu göster'), findsOneWidget);
    expect(find.byTooltip('Filtreler'), findsOneWidget);
    expect(
      tester.getSize(find.byKey(const Key('map_search_bar'))).height,
      greaterThanOrEqualTo(48),
    );

    await tester.tap(find.byKey(const Key('map_zoom_in_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('map_show_all_button')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('OSM atfı konum butonunun altında, aynı sağ kenara yaslı; '
      'harita yüzeyi kendi adıyla okunur', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpPage(tester);

    final attribution = tester.getRect(
      find.byKey(const Key('map_attribution')),
    );
    final locate = tester.getRect(find.byKey(const Key('map_locate_button')));
    expect(attribution.right, moreOrLessEquals(locate.right, epsilon: 0.5));
    expect(attribution.top, greaterThan(locate.bottom));
    expect(
      find.bySemanticsLabel(RegExp('^Vakıf eserleri haritası')),
      findsOneWidget,
    );
    expect(find.bySemanticsLabel(RegExp('^Harita verileri: ')), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('dokunma hedefleri erişilebilirlik kılavuzlarına uyar', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pumpPage(tester);
    await tapPin(tester, 'sahip-ata-kulliyesi');

    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    semantics.dispose();
  });

  for (final (name, theme) in [
    ('koyu', AppTheme.dark()),
    ('açık yüksek kontrast', AppTheme.highContrastLight()),
  ]) {
    testWidgets('%200 metin ölçeğinde önizleme taşmaz ($name)', (tester) async {
      await pumpPage(tester, textScale: 2, theme: theme);
      await tapPin(tester, 'divrigi-ulu-camii-ve-darussifasi');

      expect(find.byKey(const Key('monument_preview_card')), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.tap(find.byKey(const Key('map_search_bar')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('monument_search_field')),
        'konya',
      );
      await tester.pump(MonumentSearchPage.debounce);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('monument_search_apply_to_map')), findsOne);
      expect(tester.takeException(), isNull);

      await tester.tap(find.byKey(const Key('search_filter_category')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('filter_sheet_apply')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('hareket azaltma açıkken kamera ve geçişler anlıktır', (
    tester,
  ) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await pumpPage(tester);
    await revealPin(tester, 'gulbahar-hatun-camii');

    await tester.tap(pin('gulbahar-hatun-camii'));
    await tester.pump(kDoubleTapTimeout);
    // Önizleme isteği (gecikmesiz mock) tamamlanır.
    await tester.pump();

    // Geçiş animasyonu beklenmeden önizleme tek karede görünür.
    expect(find.byKey(const Key('monument_preview_card')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  Future<void> openSearch(WidgetTester tester) async {
    await tester.tap(find.byKey(const Key('map_search_bar')));
    await tester.pumpAndSettle();
  }

  /// Yazar ve seyreltme süresinden sonra sonuçların gelmesini bekler.
  Future<void> typeQuery(WidgetTester tester, String query) async {
    await tester.enterText(
      find.byKey(const Key('monument_search_field')),
      query,
    );
    await tester.pump(MonumentSearchPage.debounce);
    await tester.pumpAndSettle();
  }

  Finder previewText(String text) => find.descendant(
    of: find.byKey(const Key('monument_preview_card')),
    matching: find.text(text),
  );

  Future<void> chooseFilter(
    WidgetTester tester,
    String group,
    String option,
  ) async {
    await tester.tap(find.byKey(Key('search_filter_$group')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('filter_option_$option')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('filter_sheet_apply')));
    await tester.pumpAndSettle();
  }

  group('arama', () {
    testWidgets('boş sorguda tüm eserler sunucudan listelenir', (tester) async {
      await pumpPage(tester);
      expect(find.bySemanticsLabel('Yer veya eser ara'), findsOneWidget);

      await openSearch(tester);
      expect(find.text('Tüm eserler'), findsOneWidget);
      expect(find.text('10 sonuç'), findsOneWidget);
      expect(announcements, contains('10 sonuç'));
      await tester.scrollUntilVisible(
        find.byKey(const Key('monument_search_end')),
        300,
        scrollable: find.descendant(
          of: find.byKey(const Key('monument_search_results')),
          matching: find.byType(Scrollable),
        ),
      );
      expect(find.text('Tüm sonuçlar gösterildi (10)'), findsOneWidget);
      // Sorgu yokken haritaya uygulanacak bir şey yok.
      expect(
        find.byKey(const Key('monument_search_apply_to_map')),
        findsNothing,
      );
    });

    testWidgets('Türkçe karakter duyarsız arar; esere dokununca seçilir ve '
        'detaya gidilir', (tester) async {
      await pumpPage(tester);
      await openSearch(tester);

      await typeQuery(tester, 'SULEYMAN');
      expect(find.text('Eserler'), findsOneWidget);
      expect(find.text('1 sonuç'), findsOneWidget);
      expect(announcements, contains('1 sonuç'));

      await tester.tap(
        find.byKey(const Key('monument_search_item_suleymaniye-camii')),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('monument_search_field')), findsNothing);
      expect(openedMonuments, ['suleymaniye-camii']);
      expect(previewText('Süleymaniye Camii'), findsOneWidget);
    });

    testWidgets('"haritada göster" eseri haritada seçer', (tester) async {
      await pumpPage(tester);
      await openSearch(tester);
      await typeQuery(tester, 'gülbahar');

      await tester.tap(
        find.byKey(
          const Key('monument_search_show_on_map_gulbahar-hatun-camii'),
        ),
      );
      await tester.pumpAndSettle();

      expect(openedMonuments, isEmpty);
      expect(previewText('Gülbahar Hatun Camii'), findsOneWidget);
    });

    testWidgets('il önerisi o bölgeye odaklanır ve duyurulur', (tester) async {
      await pumpPage(tester);
      await openSearch(tester);
      await typeQuery(tester, 'konya');

      expect(find.text('Yerler'), findsOneWidget);
      await tester.tap(find.byKey(const Key('monument_search_place_Konya_')));
      await settleMap(tester);

      expect(announcements, contains('Konya: 1 eser'));
      // Kamera bölgeye sığdırılır; eser ayrı pin olarak görünür.
      expect(pin('sahip-ata-kulliyesi'), findsOneWidget);
    });

    testWidgets('sonuç yoksa açıklama gösterilir', (tester) async {
      await pumpPage(tester);
      await openSearch(tester);
      await typeQuery(tester, 'xyzw');

      expect(find.byKey(const Key('monument_search_empty')), findsOneWidget);
      expect(find.text('Sonuç bulunamadı'), findsOneWidget);
      expect(announcements.last, 'Sonuç bulunamadı');
    });
  });

  group('aynı ekranda filtre', () {
    testWidgets('filtre isteği sunucuya gider; çipte özet ve sayılar', (
      tester,
    ) async {
      await pumpPage(tester);
      await openSearch(tester);

      await tester.tap(find.byKey(const Key('search_filter_category')));
      await tester.pumpAndSettle();
      // Sayılar sunucunun facet'leridir.
      expect(find.text('Cami (6)'), findsOneWidget);
      await tester.tap(
        find.byKey(const Key('filter_option_MonumentCategory.mosque')),
      );
      await tester.pump();
      await tester.tap(find.byKey(const Key('filter_sheet_apply')));
      await tester.pumpAndSettle();
      expect(find.text('6 sonuç'), findsOneWidget);
      expect(find.bySemanticsLabel('Yapı türü filtresi: Cami'), findsOneWidget);

      await chooseFilter(tester, 'period', 'HistoricalPeriod.seljuk');
      expect(find.text('1 sonuç'), findsOneWidget);
      expect(
        find.byKey(const Key('monument_search_item_diyarbakir-ulu-camii')),
        findsOneWidget,
      );

      await tester.ensureVisible(find.byKey(const Key('search_filter_clear')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('search_filter_clear')));
      await tester.pumpAndSettle();
      expect(find.text('10 sonuç'), findsOneWidget);
    });

    testWidgets('sonuçlar haritaya uygulanır: pinler, rozet ve bant', (
      tester,
    ) async {
      await pumpPage(tester);
      await openSearch(tester);
      await typeQuery(tester, 'camii');
      await chooseFilter(tester, 'period', 'HistoricalPeriod.seljuk');

      await tester.tap(find.byKey(const Key('monument_search_apply_to_map')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('monument_search_field')), findsNothing);
      // Daraltılmış küme tek eser: kümelenmeden pin olarak görünür.
      expect(pin('diyarbakir-ulu-camii'), findsOneWidget);
      expect(find.byType(MapClusterMarker), findsNothing);
      expect(find.text('camii'), findsOneWidget);
      expect(find.byTooltip('Filtreler, 1 etkin'), findsOneWidget);
      expect(find.text('1 eser gösteriliyor'), findsOneWidget);
      expect(announcements, contains('1 eser gösteriliyor'));

      // Haritadaki filtre butonu aynı arama ekranını mevcut sorguyla açar.
      await tester.tap(find.byKey(const Key('map_filter_button')));
      await tester.pumpAndSettle();
      expect(find.bySemanticsLabel('Dönem filtresi: Selçuklu'), findsOneWidget);
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('map_clear_refinements_button')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('map_results_banner')), findsNothing);
      expect(
        announcements.last,
        'Arama ve filtreler temizlendi, tüm eserler gösteriliyor',
      );
    });
  });

  group('sayfalama', () {
    testWidgets('kaydırdıkça sonraki sayfa yüklenir ve duyurulur', (
      tester,
    ) async {
      catalog = catalogUseCases(
        CatalogMockApi.withMonuments(syntheticMonuments(45)),
      );
      await pumpPage(tester);
      await tester.tap(find.byKey(const Key('map_search_bar')));
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(announcements, contains('45 sonuç'));

      expect(find.text('45 sonuç'), findsOneWidget);
      expect(find.byKey(const Key('monument_search_item_test-000')), findsOne);

      // Yükleme göstergesi dönerken pumpAndSettle beklemez; sabit adımlarla
      // kaydırılır.
      final results = find.byKey(const Key('monument_search_results'));
      final end = find.byKey(const Key('monument_search_end'));
      for (var i = 0; i < 12 && end.evaluate().isEmpty; i++) {
        await tester.drag(results, const Offset(0, -800));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(find.byKey(const Key('monument_search_item_test-044')), findsOne);
      expect(announcements, contains('20 sonuç daha yüklendi'));
      expect(announcements, contains('5 sonuç daha yüklendi'));
      expect(find.text('Tüm sonuçlar gösterildi (45)'), findsOneWidget);
    });
  });

  group('konum', () {
    testWidgets('izin reddinde neden ve ayarlar eylemi gösterilir', (
      tester,
    ) async {
      location.result = const LocationFailed(
        LocationIssue.permissionDeniedForever,
      );
      await pumpPage(tester);

      await tester.tap(find.byKey(const Key('map_locate_button')));
      await tester.pumpAndSettle();

      const message = 'Konum izni kapalı. Ayarlardan izin verebilirsiniz.';
      expect(find.text(message), findsOneWidget);
      expect(announcements, contains(message));
      await tester.tap(find.text('Ayarlar'));
      await tester.pumpAndSettle();
      expect(location.openedSettings, [LocationIssue.permissionDeniedForever]);
    });

    testWidgets('konum bulununca nokta çizilir, takip açılır; harita '
        'sürüklenince takip kapanır', (tester) async {
      final semantics = tester.ensureSemantics();
      location.result = const LocationFound(testIstanbulPosition);
      await pumpPage(tester);

      await tester.tap(find.byKey(const Key('map_locate_button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('map_user_location')), findsOneWidget);
      expect(find.bySemanticsLabel('Konumunuz'), findsOneWidget);
      expect(announcements, contains('Konumunuz gösteriliyor'));
      expect(location.hasListeners, isTrue);
      expect(
        tester.getSemantics(find.byKey(const Key('map_locate_button'))),
        isSemantics(isToggled: true, hasToggledState: true),
      );

      await tester.drag(
        find.byKey(const Key('map_discovery_map')),
        const Offset(-120, 0),
      );
      await tester.pumpAndSettle();
      expect(
        tester.getSemantics(find.byKey(const Key('map_locate_button'))),
        isSemantics(isToggled: false, hasToggledState: true),
      );

      // İkinci basış yeni izin istemeden son konuma döner.
      await tester.tap(find.byKey(const Key('map_locate_button')));
      await tester.pumpAndSettle();
      expect(location.currentPositionCalls, 1);
      semantics.dispose();
    });

    testWidgets('harita bölgesi dışındaki konum için bilgi verilir', (
      tester,
    ) async {
      location.result = const LocationFound(testOutsidePosition);
      await pumpPage(tester);

      await tester.tap(find.byKey(const Key('map_locate_button')));
      await tester.pumpAndSettle();

      expect(find.text('Konumunuz harita alanının dışında.'), findsOneWidget);
    });

    testWidgets('konum desteklenmeyen platformda buton gösterilmez', (
      tester,
    ) async {
      location = FakeLocationService(isSupported: false);
      await pumpPage(tester);

      expect(find.byKey(const Key('map_locate_button')), findsNothing);
      expect(find.byKey(const Key('map_zoom_in_button')), findsOneWidget);
    });
  });

  group('kaydedilenler', () {
    testWidgets('buton arama çubuğunun sağındadır; dar ekranda ve %200 '
        'metinde taşmaz', (tester) async {
      var opened = 0;
      await pumpPage(
        tester,
        textScale: 2,
        size: const Size(320, 640),
        savedButton: SavedMonumentsMapButton(
          count: 3,
          onPressed: () => opened++,
        ),
      );

      expect(tester.takeException(), isNull);
      final saved = find.byKey(const Key('map_saved_button'));
      final searchBar = find.byKey(const Key('map_search_bar'));
      expect(
        tester.getTopLeft(saved).dx,
        greaterThan(tester.getTopRight(searchBar).dx),
      );
      expect(find.bySemanticsLabel('Kaydedilenler, 3 eser'), findsOneWidget);
      await tester.tap(saved);
      expect(opened, 1);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    });

    testWidgets('önizleme kartında eser kaydedilir', (tester) async {
      final env = SavedMonumentsTestEnvironment();
      final cubit = env.cubit();
      await pumpPage(
        tester,
        previewActionBuilder: (context, monument) =>
            BlocSelector<SavedMonumentsCubit, SavedMonumentsState, bool>(
              bloc: cubit,
              selector: (state) => state.contains(monument.id),
              builder: (context, isSaved) => MonumentSaveButton(
                isSaved: isSaved,
                monumentName: monument.name,
                onPressed: () => toggleSavedMonument(
                  context,
                  cubit: cubit,
                  monumentId: monument.id,
                  monumentName: monument.name,
                ),
              ),
            ),
      );
      await tapPin(tester, 'kizlaragasi-hani');

      final save = find.descendant(
        of: find.byKey(const Key('monument_preview_card')),
        matching: find.byKey(const Key('monument_save_button')),
      );
      expect(save, findsOneWidget);
      expect(find.bySemanticsLabel('Kaydet: Kızlarağası Hanı'), findsOneWidget);

      await tester.tap(save);
      await tester.pumpAndSettle();

      expect(cubit.state.contains('kizlaragasi-hani'), isTrue);
      expect(find.text('Kaydedildi: Kızlarağası Hanı'), findsOneWidget);
      expect(
        tester.getSemantics(
          find.bySemanticsLabel('Kaydedilenlerden çıkar: Kızlarağası Hanı'),
        ),
        isSemantics(isButton: true, hasToggledState: true, isToggled: true),
      );
      unawaited(cubit.close());
    });
  });
}
