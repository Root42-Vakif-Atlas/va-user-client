import 'dart:math' as math;

/// Web Mercator XYZ karo kimliği (OSM / Google şeması, 256 px karo).
///
/// `z` seviyesinde dünya 2ᶻ × 2ᶻ karoya bölünür; `x` batıdan doğuya, `y`
/// kuzeyden güneye artar.
final class TileId {
  const TileId(this.z, this.x, this.y);

  final int z;
  final int x;
  final int y;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TileId && other.z == z && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(z, x, y);

  @override
  String toString() => '$z/$x/$y';
}

/// Karo matematiği (saf Dart; sunucunun karo sorgusuyla aynı formüller).
abstract final class MapTiles {
  /// Karo isteklerinin en düşük ve en yüksek seviyesi.
  static const int minZoom = 4;
  static const int maxZoom = 18;

  /// Bu seviyeden itibaren sunucu gruplama yapmaz; tekil eserler döner.
  static const int singlesZoom = 15;

  /// Bu seviyeden itibaren külliyeler açılır: tek işaretçi yerine yerleşim
  /// alanı (çokgen) ve üye yapıların pinleri döner. Daha uzakta üyeler
  /// külliyenin işaretçisinde toplanır (bir külliye = bir öğe).
  static const int complexExpandZoom = 17;

  /// Kenar başına hücre sayısı (karo 4×4 hücreye bölünür, hücre ≈ 64 px).
  static const int cellsPerSide = 4;

  /// Mantıksal piksel cinsinden karo kenarı.
  static const double tileSize = 256;

  /// WGS 84 → birim kare Web Mercator (0–1). Sunucudaki `mx`, `my`.
  static (double, double) project(double latitude, double longitude) {
    final sin = math.sin(
      latitude.clamp(-85.05112878, 85.05112878) * math.pi / 180,
    );
    final y = 0.5 - math.log((1 + sin) / (1 - sin)) / (4 * math.pi);
    return ((longitude + 180) / 360, y.clamp(0.0, 1.0));
  }

  /// Birim Mercator → WGS 84 (enlem, boylam).
  static (double, double) unproject(double x, double y) {
    final n = math.pi - 2 * math.pi * y;
    final latitude =
        180 / math.pi * math.atan(0.5 * (math.exp(n) - math.exp(-n)));
    return (latitude, x * 360 - 180);
  }

  /// Kamera yakınlaştırmasından karo seviyesi (aşağı yuvarlanır, sınırlı).
  static int zoomLevel(double zoom) => zoom.floor().clamp(minZoom, maxZoom);

  /// Eser karolarının istendiği seviye.
  ///
  /// Kümeleme seviyelerinde ([singlesZoom] altı) bir seviye düşük, yani
  /// ekranda iki kat büyük karo istenir: her karo 4× alan kaplar, görünür
  /// alan başına istek ~9'dan ~2–4'e iner ve küçük kaydırmalar karo
  /// sınırını nadiren geçer. Sunucunun 4×4 hücreli kümeleri ekranda ~128 dp
  /// olur; yakın kümeler yine `declutter` ile birleşir.
  ///
  /// [singlesZoom] ve üstünde değişmez: tekil eserler ve külliye açılımı
  /// ([complexExpandZoom]) aynı seviyelerde gelir.
  static int requestLevel(double zoom) {
    final level = zoomLevel(zoom);
    return level < singlesZoom ? math.max(minZoom, level - 1) : level;
  }

  /// Coğrafi alanı kaplayan karolar; [padding] karo kadar kenar payı
  /// eklenir (kaydırırken kenarda boşluk kalmaz).
  static Set<TileId> tilesCovering({
    required double south,
    required double west,
    required double north,
    required double east,
    required int zoom,
    int padding = 0,
  }) {
    final count = 1 << zoom;
    final (minX, minY) = project(north, west);
    final (maxX, maxY) = project(south, east);
    int clampTile(int value) => value.clamp(0, count - 1);
    final x0 = clampTile((minX * count).floor() - padding);
    final x1 = clampTile((maxX * count).floor() + padding);
    final y0 = clampTile((minY * count).floor() - padding);
    final y1 = clampTile((maxY * count).floor() + padding);
    return {
      for (var x = x0; x <= x1; x++)
        for (var y = y0; y <= y1; y++) TileId(zoom, x, y),
    };
  }

  /// Birbirine ekranda [radius] mantıksal pikselden yakın öğeleri
  /// birleştirir (karo ve hücre sınırlarının iki yanına düşen kümeler).
  ///
  /// Izgara komşuluğuyla açgözlü birleştirme; ~O(n). Sıra korunur: bir
  /// grubun temsilcisi ilk öğedir, [merge] grubu tek öğeye indirger.
  static List<T> declutter<T>(
    List<T> items, {
    required double zoom,
    required (double, double) Function(T item) position,
    required T Function(List<T> group) merge,
    double radius = 48,
  }) {
    if (items.length < 2) {
      return items;
    }
    final scale = tileSize * math.pow(2, zoom);
    final cell = radius / scale;
    final projected = [
      for (final item in items)
        () {
          final (lat, lng) = position(item);
          return project(lat, lng);
        }(),
    ];
    final grid = <(int, int), List<int>>{};
    for (var i = 0; i < projected.length; i++) {
      final (x, y) = projected[i];
      grid.putIfAbsent((x ~/ cell, y ~/ cell), () => []).add(i);
    }
    final used = List<bool>.filled(items.length, false);
    final result = <T>[];
    final radiusSquared = cell * cell;
    for (var i = 0; i < items.length; i++) {
      if (used[i]) {
        continue;
      }
      used[i] = true;
      final (x, y) = projected[i];
      final group = <int>[i];
      for (var dx = -1; dx <= 1; dx++) {
        for (var dy = -1; dy <= 1; dy++) {
          for (final j
              in grid[(x ~/ cell + dx, y ~/ cell + dy)] ?? const <int>[]) {
            if (used[j]) {
              continue;
            }
            final (px, py) = projected[j];
            if ((px - x) * (px - x) + (py - y) * (py - y) < radiusSquared) {
              used[j] = true;
              group.add(j);
            }
          }
        }
      }
      result.add(
        group.length == 1 ? items[i] : merge([for (final g in group) items[g]]),
      );
    }
    return result;
  }
}
