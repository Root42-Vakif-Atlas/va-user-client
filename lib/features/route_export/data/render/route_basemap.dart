import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/map/map_tile_source.dart';
import 'package:vakif_atlas/core/observability/app_logger.dart';

/// Normalize Web Mercator penceresi: `x` batıdan doğuya, `y` kuzeyden
/// güneye 0…1 (karo koordinatlarıyla aynı yön).
@immutable
final class MercatorWindow {
  const MercatorWindow({
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
  });

  final double left;
  final double top;
  final double right;
  final double bottom;

  double get width => right - left;
  double get height => bottom - top;
}

/// Rota çiziminin altlığı: birleştirilmiş harita görüntüsü ve lisans atfı.
@immutable
final class RouteBasemap {
  const RouteBasemap({required this.image, required this.attribution});

  /// JPEG; çizim kutusunu tam olarak kaplar.
  final Uint8List image;

  /// Haritadaki gibi altlığın üzerinde sürekli görünür (ODbL).
  final String attribution;
}

/// Rota PDF'inin harita altlığını uygulama haritasının karo kaynağından
/// üretir ([MapTileSource]: aynı sunucu, aynı disk önbelleği).
///
/// Yakınlaştırma, karo pikseli başına yaklaşık 0,5 pt düşecek biçimde
/// seçilir: harita yazıları okunur kalır, baskı ~144 dpi olur. Karolardan
/// biri bile alınamazsa (çevrimdışı, sunucu hatası) `null` döner ve PDF
/// altlıksız vektör çizimle üretilir; yamalı harita gösterilmez. Karolar
/// [concurrency]'lik havuzla istenir (mobil ağda onlarca eşzamanlı TLS
/// bağlantısı süreyi aşıyordu), alınamayan karo bir kez yeniden denenir.
@lazySingleton
class RouteBasemapRenderer {
  RouteBasemapRenderer(this._tiles, {this._logger});

  final MapTileSource _tiles;
  final AppLogger? _logger;

  /// Aynı anda istenen en çok karo.
  static const int concurrency = 6;

  /// Görüntü pikselinin PDF noktasına oranı (hedef).
  static const double pixelsPerPoint = 2;

  /// Karo isteği üst sınırı (tile sunucusu kullanım politikası).
  static const int maxTiles = 48;

  static const int minZoom = 1;
  static const int maxZoom = 18;

  /// Tüm karolar için toplam bekleme.
  static const Duration timeout = Duration(seconds: 30);

  /// Altlık soluklaştırılır: rota çizgisi ve işaretler öne çıkar, gri tonda
  /// yazdırmada da ayrışır.
  static const double _wash = 0.25;

  static const int _jpegQuality = 85;

  /// [window]'u [widthPt] × [heightPt] kutusuna çizen yakınlaştırma.
  static int zoomFor(MercatorWindow window, double widthPt) {
    final worldPixels = pixelsPerPoint * widthPt / window.width;
    final zoom = (math.log(worldPixels / MapTileSource.tileSize) / math.ln2)
        .round();
    return zoom.clamp(minZoom, maxZoom);
  }

  Future<RouteBasemap?> render(
    MercatorWindow window, {
    required double widthPt,
    required double heightPt,
  }) async {
    final zoom = zoomFor(window, widthPt);
    final tiles = 1 << zoom;
    final tilePixels = _tiles.fetchedTilePixels;
    final worldPixels = tiles * tilePixels;
    final originX = window.left * worldPixels;
    final originY = window.top * worldPixels;
    final width = (window.width * worldPixels).ceil();
    final height = (window.height * worldPixels).ceil();
    final firstX = (originX / tilePixels).floor();
    final lastX = ((originX + width) / tilePixels).floor();
    final firstY = math.max(0, (originY / tilePixels).floor());
    final lastY = math.min(
      tiles - 1,
      ((originY + height) / tilePixels).floor(),
    );
    final count = (lastX - firstX + 1) * (lastY - firstY + 1);
    if (count > maxTiles || width <= 0 || height <= 0) {
      _logger?.warning(
        'Route basemap skipped: too many tiles',
        context: {'zoom': zoom, 'tiles': count},
      );
      return null;
    }

    final requests = [
      for (var y = firstY; y <= lastY; y++)
        for (var x = firstX; x <= lastX; x++)
          (
            dx: x * tilePixels - originX.round(),
            dy: y * tilePixels - originY.round(),
            x: x % tiles,
            y: y,
          ),
    ];
    final List<Uint8List?> images;
    try {
      images = await _fetchAll(zoom, requests).timeout(timeout);
    } on TimeoutException {
      _logger?.warning(
        'Route basemap skipped: tiles timed out',
        context: {'zoom': zoom, 'tiles': count},
      );
      return null;
    }
    final missing = images.where((bytes) => bytes == null).length;
    if (missing > 0) {
      _logger?.warning(
        'Route basemap skipped: tiles unavailable',
        context: {'zoom': zoom, 'tiles': count, 'missing': missing},
      );
      return null;
    }
    final composed = await compute(
      composeBasemap,
      BasemapLayout(
        width: width,
        height: height,
        tilePixels: tilePixels,
        tiles: [
          for (final (index, request) in requests.indexed)
            (dx: request.dx, dy: request.dy, bytes: images[index]!),
        ],
      ),
    );
    if (composed == null) {
      _logger?.warning('Route basemap skipped: tile could not be decoded');
      return null;
    }
    return RouteBasemap(image: composed, attribution: _tiles.attribution);
  }

  /// Karoları [concurrency]'lik havuzla, sırayı koruyarak getirir.
  Future<List<Uint8List?>> _fetchAll(
    int zoom,
    List<({int dx, int dy, int x, int y})> requests,
  ) async {
    final results = List<Uint8List?>.filled(requests.length, null);
    var next = 0;
    Future<void> worker() async {
      while (next < requests.length) {
        final index = next++;
        final request = requests[index];
        results[index] =
            await _tiles.fetchTile(zoom: zoom, x: request.x, y: request.y) ??
            await _tiles.fetchTile(zoom: zoom, x: request.x, y: request.y);
      }
    }

    await Future.wait([
      for (var i = 0; i < math.min(concurrency, requests.length); i++) worker(),
    ]);
    return results;
  }
}

/// [composeBasemap]'in girdisi (isolate'e aktarılır).
@immutable
final class BasemapLayout {
  const BasemapLayout({
    required this.width,
    required this.height,
    required this.tilePixels,
    required this.tiles,
  });

  final int width;
  final int height;
  final int tilePixels;

  /// Karonun görüntüdeki sol üst köşesi ve kodlanmış baytları.
  final List<({int dx, int dy, Uint8List bytes})> tiles;
}

/// Karoları tek görüntüde birleştirir, soluklaştırır ve JPEG'e kodlar.
/// Çözülemeyen karo varsa `null`.
@visibleForTesting
Uint8List? composeBasemap(BasemapLayout layout) {
  final canvas = img.Image(width: layout.width, height: layout.height);
  // Dünyanın dışına taşan şerit (kutuplar) boş kalmaz.
  img.fill(canvas, color: img.ColorRgb8(255, 255, 255));
  for (final tile in layout.tiles) {
    var decoded = img.decodeImage(tile.bytes);
    if (decoded == null) {
      return null;
    }
    if (decoded.width != layout.tilePixels) {
      decoded = img.copyResize(
        decoded,
        width: layout.tilePixels,
        height: layout.tilePixels,
      );
    }
    img.compositeImage(canvas, decoded, dstX: tile.dx, dstY: tile.dy);
  }
  for (final pixel in canvas) {
    pixel
      ..r = pixel.r + (255 - pixel.r) * RouteBasemapRenderer._wash
      ..g = pixel.g + (255 - pixel.g) * RouteBasemapRenderer._wash
      ..b = pixel.b + (255 - pixel.b) * RouteBasemapRenderer._wash;
  }
  return img.encodeJpg(canvas, quality: RouteBasemapRenderer._jpegQuality);
}
