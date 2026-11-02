import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:intl/date_symbol_data_local.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/map/map_tile_source.dart';
import 'package:vakif_atlas/features/route_export/data/render/route_basemap.dart';
import 'package:vakif_atlas/features/route_export/data/render/route_pdf_renderer.dart';
import 'package:vakif_atlas/features/route_export/presentation/route_document_builder.dart';

import '../../../helpers/catalog_test_utils.dart';
import '../../../helpers/map_test_utils.dart';
import '../../../helpers/route_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() => initializeDateFormatting('tr'));

  /// Tek renkli karo (kodlanmış PNG).
  final tilePng = Uint8List.fromList(
    img.encodePng(
      img.fill(
        img.Image(
          width: MapTileSource.tileSize,
          height: MapTileSource.tileSize,
        ),
        color: img.ColorRgb8(200, 220, 240),
      ),
    ),
  );

  Future<String> render(
    List<String> ids, {
    RouteBasemapRenderer? basemap,
  }) async {
    final route = await createTestRoute('Vakıf Rotası', ids);
    final document = buildRouteDocument(
      route,
      lookupAppLocalizations(const Locale('tr')),
      now: DateTime(2026, 10, 18),
    );
    final bytes = await RoutePdfRenderer.withFonts(
      RoutePdfFonts.load,
      basemap: basemap,
    ).render(document);
    return latin1.decode(bytes);
  }

  bool hasImage(String pdf) => RegExp(r'/Subtype\s*/Image').hasMatch(pdf);

  test('geçerli, yazı tipi gömülü ve meta verili A4 PDF üretir', () async {
    final pdf = await render(['selimiye-camii', 'bursa-ulu-camii']);

    expect(pdf, startsWith('%PDF-1.5'));
    expect(pdf.trimRight(), endsWith('%%EOF'));
    expect(pdf, contains('/FontFile2'));
    expect(pdf, contains('/Title'));
    // Yer imleri (ana hat) başlıklardan oluşturulur.
    expect(pdf, contains('/Outlines'));
    // Durak konumu bağlantısı.
    expect(pdf, contains('openstreetmap.org'));
  });

  test('en fazla duraklı rota birden çok sayfaya taşar', () async {
    final pdf = await render([
      for (final pin in fixturePins().take(10)) pin.id,
    ]);
    expect(RegExp(r'/Type\s*/Page\b').allMatches(pdf).length, greaterThan(1));
  });

  group('harita altlığı', () {
    test('rota haritası karolardan üretilen görüntüyü içerir', () async {
      final requested = <String>[];
      final pdf = await render(
        ['selimiye-camii', 'suleymaniye-camii', 'bursa-ulu-camii'],
        basemap: RouteBasemapRenderer(
          testMapTileSource(
            tileFetcher: (url) async {
              requested.add(url);
              return tilePng;
            },
          ),
        ),
      );

      expect(hasImage(pdf), isTrue);
      expect(requested, isNotEmpty);
      expect(
        requested.length,
        lessThanOrEqualTo(RouteBasemapRenderer.maxTiles),
      );
      expect(
        requested,
        everyElement(
          matches(RegExp(r'^https://tiles\.example\.org/\d+/\d+/\d+\.png$')),
        ),
      );
    });

    test('karo alınamazsa (çevrimdışı) PDF altlıksız üretilir', () async {
      String? broken;
      final pdf = await render(
        ['selimiye-camii', 'bursa-ulu-camii'],
        basemap: RouteBasemapRenderer(
          testMapTileSource(
            // Bir karo (yeniden denemede de) alınamıyorsa yamalı harita
            // gösterilmez.
            tileFetcher: (url) async =>
                url == (broken ??= url) ? null : tilePng,
          ),
        ),
      );

      expect(pdf.trimRight(), endsWith('%%EOF'));
      expect(hasImage(pdf), isFalse);
    });
  });
}
