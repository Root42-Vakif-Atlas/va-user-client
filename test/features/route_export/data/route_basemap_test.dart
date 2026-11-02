import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:vakif_atlas/core/config/map_tile_config.dart';
import 'package:vakif_atlas/core/map/map_tile_source.dart';
import 'package:vakif_atlas/features/route_export/data/render/route_basemap.dart';

import '../../../helpers/map_test_utils.dart';

void main() {
  Uint8List tile(int size, img.Color color) => Uint8List.fromList(
    img.encodePng(
      img.fill(
        img.Image(width: size, height: size),
        color: color,
      ),
    ),
  );

  // İstanbul – Edirne arası, A4 genişliğindeki çizim kutusu.
  const window = MercatorWindow(
    left: 0.570,
    top: 0.3780,
    right: 0.582,
    bottom: 0.3840,
  );
  const widthPt = 499.0;
  const heightPt = 249.5;

  test('yakınlaştırma karo pikselini ~0,5 pt\'ye düşürür', () {
    final zoom = RouteBasemapRenderer.zoomFor(window, widthPt);
    final pixelsAcross = window.width * MapTileSource.tileSize * (1 << zoom);
    final ratio = pixelsAcross / widthPt;

    expect(ratio, inInclusiveRange(1.41, 2.83));
  });

  test('pencereyi kaplayan karoları birleştirir, soluklaştırır', () async {
    final requested = <String>[];
    final basemap = await RouteBasemapRenderer(
      testMapTileSource(
        tileFetcher: (url) async {
          requested.add(url);
          return tile(MapTileSource.tileSize, img.ColorRgb8(0, 0, 0));
        },
      ),
    ).render(window, widthPt: widthPt, heightPt: heightPt);

    expect(basemap, isNotNull);
    expect(basemap!.attribution, testMapTileConfig.attribution);
    final image = img.decodeJpg(basemap.image)!;
    final zoom = RouteBasemapRenderer.zoomFor(window, widthPt);
    final world = MapTileSource.tileSize * (1 << zoom);
    expect(image.width, (window.width * world).ceil());
    expect(image.height, (window.height * world).ceil());
    // Siyah karo %25 beyazla karışır (JPEG kaybı payıyla).
    final pixel = image.getPixel(image.width ~/ 2, image.height ~/ 2);
    expect(pixel.r, closeTo(64, 6));
    expect(requested.toSet(), hasLength(requested.length));
  });

  test('retina destekleyen sunucudan @2x karo ister', () async {
    final requested = <String>[];
    final basemap = await RouteBasemapRenderer(
      testMapTileSource(
        config: const MapTileConfig(
          lightUrlTemplate: 'https://tiles.example.org/{z}/{x}/{y}{r}.png',
          attribution: '© Kurum',
        ),
        tileFetcher: (url) async {
          requested.add(url);
          return tile(2 * MapTileSource.tileSize, img.ColorRgb8(255, 0, 0));
        },
      ),
    ).render(window, widthPt: widthPt, heightPt: heightPt);

    expect(requested, everyElement(endsWith('@2x.png')));
    final image = img.decodeJpg(basemap!.image)!;
    final zoom = RouteBasemapRenderer.zoomFor(window, widthPt);
    expect(image.width, (window.width * 512 * (1 << zoom)).ceil());
  });

  test(
    'karoları sınırlı havuzla ister; alınamayanı bir kez yeniden dener',
    () async {
      var inFlight = 0;
      var peak = 0;
      final attempts = <String, int>{};
      final basemap = await RouteBasemapRenderer(
        testMapTileSource(
          tileFetcher: (url) async {
            inFlight++;
            peak = inFlight > peak ? inFlight : peak;
            await Future<void>.delayed(const Duration(milliseconds: 5));
            inFlight--;
            final attempt = attempts[url] = (attempts[url] ?? 0) + 1;
            // Her karonun ilk denemesi başarısız.
            return attempt == 1
                ? null
                : tile(MapTileSource.tileSize, img.ColorRgb8(0, 0, 0));
          },
        ),
      ).render(window, widthPt: widthPt, heightPt: heightPt);

      expect(basemap, isNotNull);
      expect(peak, lessThanOrEqualTo(RouteBasemapRenderer.concurrency));
      expect(attempts.values, everyElement(2));
    },
  );

  test('karo sayısı sınırı aşılırsa altlık üretilmez', () async {
    var calls = 0;
    final basemap =
        await RouteBasemapRenderer(
          testMapTileSource(
            tileFetcher: (url) async {
              calls++;
              return tile(MapTileSource.tileSize, img.ColorRgb8(0, 0, 0));
            },
          ),
        ).render(
          // Çok geniş kutu: düşük yakınlaştırmada bile sınırın üstünde karo.
          const MercatorWindow(left: 0.1, top: 0.3, right: 0.9, bottom: 0.7),
          widthPt: 20000,
          heightPt: 10000,
        );

    expect(basemap, isNull);
    expect(calls, 0);
  });
}
