import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:vakif_atlas/core/config/map_tile_config.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/map/map_tile_filters.dart';
import 'package:vakif_atlas/core/map/map_tile_source.dart';
import 'package:vakif_atlas/core/theme/app_theme.dart';
import 'package:vakif_atlas/shared/widgets/organisms/a11y_map_controls.dart';
import 'package:vakif_atlas/shared/widgets/organisms/app_map.dart';
import 'package:vakif_atlas/shared/widgets/organisms/map_pin.dart';

import '../../../helpers/map_test_utils.dart';
import '../../../helpers/pump_app.dart';

void main() {
  group('MapTileSource', () {
    final source = MapTileSource(
      config: MapTileConfig.openStreetMap,
      userAgentPackageName: 'pkg',
      providerFactory: BlankTileProvider.new,
    );

    test('koyu stil yoksa açık altlık koyu filtreyle kullanılır', () {
      expect(
        source.urlTemplateFor(Brightness.dark),
        source.urlTemplateFor(Brightness.light),
      );
      expect(source.usesDarkFilter(Brightness.dark), isTrue);
      expect(source.usesDarkFilter(Brightness.light), isFalse);
      expect(source.supportsRetina(Brightness.light), isFalse);
      expect(source.attribution, contains('OpenStreetMap'));
    });

    test('koyu stil verilirse filtre uygulanmaz, {r} retina açar', () {
      final styled = MapTileSource(
        config: const MapTileConfig(
          lightUrlTemplate:
              'https://tiles.example.org/light/{z}/{x}/{y}{r}.png',
          darkUrlTemplate: 'https://tiles.example.org/dark/{z}/{x}/{y}{r}.png',
          attribution: '© OpenStreetMap contributors',
        ),
        userAgentPackageName: 'pkg',
        providerFactory: BlankTileProvider.new,
      );

      expect(styled.urlTemplateFor(Brightness.dark), contains('/dark/'));
      expect(styled.usesDarkFilter(Brightness.dark), isFalse);
      expect(styled.supportsRetina(Brightness.dark), isTrue);
    });

    test(
      'duotone matrisi açık zemini gölge, koyu yazıyı vurgu rengine eşler',
      () {
        const shadow = Color(0xFF081F1D);
        const highlight = Color(0xFFEBE0D0);
        final m = duotoneTileMatrix(shadow: shadow, highlight: highlight);

        double channel(int row, double value) =>
            (m[row * 5] + m[row * 5 + 1] + m[row * 5 + 2]) * value +
            m[row * 5 + 4];

        // Beyaz zemin (255) → gölge, siyah yazı (0) → vurgu.
        expect(channel(0, 255), closeTo(shadow.r * 255, 0.001));
        expect(channel(1, 255), closeTo(shadow.g * 255, 0.001));
        expect(channel(2, 0), closeTo(highlight.b * 255, 0.001));
        expect(m.sublist(15), [0, 0, 0, 1, 0]);
      },
    );

    test('her harita kendi tile sağlayıcısını alır', () {
      expect(
        identical(source.createTileProvider(), source.createTileProvider()),
        isFalse,
      );
    });
  });

  group('AppMap', () {
    Future<List<String>> pumpMap(
      WidgetTester tester, {
      required ThemeData theme,
      String? semanticsLabel = 'Harita',
      MapTileConfig config = testMapTileConfig,
    }) async {
      final urls = <String>[];
      await tester.pumpWidget(
        RepositoryProvider<MapTileSource>.value(
          value: testMapTileSource(requestedUrls: urls, config: config),
          child: MaterialApp(
            theme: theme,
            locale: const Locale('tr'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: AppMap(
              semanticsLabel: semanticsLabel,
              markers: const [
                Marker(
                  point: LatLng(41.016, 28.964),
                  width: 48,
                  height: 48,
                  child: MapPin(
                    key: Key('pin'),
                    icon: Icons.mosque_outlined,
                    semanticsLabel: 'Süleymaniye Camii',
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      return urls;
    }

    for (final (name, theme, filtered) in [
      ('açık', AppTheme.light(), false),
      ('açık yüksek kontrast', AppTheme.highContrastLight(), false),
      ('koyu', AppTheme.dark(), true),
      ('koyu yüksek kontrast', AppTheme.highContrastDark(), true),
    ]) {
      testWidgets(
        '$name temada altlık ${filtered ? 'koyu filtreyle' : 'olduğu gibi'} çizilir',
        (tester) async {
          final urls = await pumpMap(
            tester,
            theme: theme,
            config: MapTileConfig.openStreetMap,
          );

          expect(urls, isNotEmpty);
          expect(
            urls.every(
              (url) => url.startsWith('https://tile.openstreetmap.org/'),
            ),
            isTrue,
          );
          // OSM `{r}` desteklemez; retina benzetimiyle ek yük oluşturulmaz.
          expect(urls.any((url) => url.contains('@2x')), isFalse);
          expect(
            find.ancestor(
              of: find.byType(TileLayer),
              matching: find.byType(ColorFiltered),
            ),
            filtered ? findsOneWidget : findsNothing,
          );
        },
      );
    }

    testWidgets('tema değişince altlık katmanı korunur ve yeniden çizilir', (
      tester,
    ) async {
      final urls = <String>[];
      final source = testMapTileSource(requestedUrls: urls);
      Widget app(ThemeData theme) => RepositoryProvider<MapTileSource>.value(
        value: source,
        child: MaterialApp(
          theme: theme,
          locale: const Locale('tr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const AppMap(semanticsLabel: 'Harita'),
        ),
      );

      await tester.pumpWidget(app(AppTheme.light()));
      await tester.pumpAndSettle();
      final state = tester.state(find.byType(TileLayer));

      await tester.pumpWidget(app(AppTheme.dark()));
      await tester.pumpAndSettle();

      expect(tester.state(find.byType(TileLayer)), same(state));
      expect(find.byType(ColorFiltered), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('lisans atfı görünür ve ekran okuyucuya okunur', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await pumpMap(tester, theme: AppTheme.dark());

      expect(
        find.text(MapTileConfig.openStreetMap.attribution),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel(
          'Harita verileri: ${MapTileConfig.openStreetMap.attribution}',
        ),
        findsOneWidget,
      );
      expect(find.bySemanticsLabel('Harita'), findsOneWidget);
      semantics.dispose();
    });

    testWidgets('etiketsiz harita ekran okuyucudan gizlenir', (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpMap(tester, theme: AppTheme.dark(), semanticsLabel: null);

      expect(find.bySemanticsLabel('Süleymaniye Camii'), findsNothing);
      semantics.dispose();
    });
  });

  group('MapPin', () {
    testWidgets('buton, etiket ve seçili durumu ekran okuyucuya bildirir', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      var taps = 0;
      await tester.pumpApp(
        Center(
          child: MapPin(
            key: const Key('pin'),
            icon: Icons.mosque_outlined,
            semanticsLabel: 'Selimiye Camii, Merkez, Edirne',
            selected: true,
            onTap: () => taps++,
          ),
        ),
      );

      expect(
        tester.getSemantics(find.byKey(const Key('pin'))),
        isSemantics(
          label: 'Selimiye Camii, Merkez, Edirne',
          isButton: true,
          isSelected: true,
          hasTapAction: true,
        ),
      );
      final size = tester.getSize(find.byKey(const Key('pin')));
      expect(size.width, MapPin.extent(selected: true));

      await tester.tap(find.byKey(const Key('pin')));
      expect(taps, 1);
      semantics.dispose();
    });

    testWidgets('seçili olmayan pin en az 48×48 dp dokunma alanına sahip', (
      tester,
    ) async {
      await tester.pumpApp(
        const Center(
          child: MapPin(
            key: Key('pin'),
            icon: Icons.mosque_outlined,
            semanticsLabel: 'Eser',
          ),
        ),
      );

      final size = tester.getSize(find.byKey(const Key('pin')));
      expect(size.width, greaterThanOrEqualTo(48));
      expect(size.height, greaterThanOrEqualTo(48));
    });
  });

  testWidgets('A11yMapControls %200 metin ölçeğinde taşmaz ve çalışır', (
    tester,
  ) async {
    final calls = <String>[];
    await tester.pumpApp(
      A11yMapControls(
        onZoomIn: () => calls.add('in'),
        onZoomOut: () => calls.add('out'),
        onShowAll: () => calls.add('all'),
      ),
      textScale: 2,
    );

    await tester.tap(find.byTooltip('Yakınlaştır'));
    await tester.tap(find.byTooltip('Uzaklaştır'));
    await tester.tap(find.byTooltip('Tüm eserleri göster'));

    expect(calls, ['in', 'out', 'all']);
    expect(tester.takeException(), isNull);
  });
}
