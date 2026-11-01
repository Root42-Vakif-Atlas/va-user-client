import 'package:vakif_atlas/features/catalog/domain/entities/geo_point.dart';

/// Kuş uçuşu toplam mesafeyi en aza indiren durak sırası (PRD: mesafe
/// optimizasyonlu kültür rotası).
///
/// İlk durak kullanıcının seçtiği başlangıç olarak sabit kalır; dönüş
/// yoktur (açık yol). En çok 10 durak için Held-Karp dinamik programlamasıyla
/// kesin en iyi sıra bulunur (O(n²·2ⁿ), 10 durakta ~5 bin durum).
class OptimizeStopOrderUseCase {
  const OptimizeStopOrderUseCase();

  /// Yeni sıradaki eski indeksler; ör. `[0, 2, 1]` → ikinci ve üçüncü
  /// durak yer değiştirir.
  List<int> call(List<GeoPoint> points) {
    final count = points.length;
    if (count <= 2) {
      return [for (var i = 0; i < count; i++) i];
    }

    // Başlangıç dışındaki duraklar maskede 0..others-1 bitleriyle tutulur.
    final others = count - 1;
    final full = (1 << others) - 1;
    double distance(int a, int b) => points[a].distanceTo(points[b]);

    final cost = List.generate(
      1 << others,
      (_) => List<double>.filled(others, double.infinity),
    );
    final previous = List.generate(
      1 << others,
      (_) => List<int>.filled(others, -1),
    );
    for (var last = 0; last < others; last++) {
      cost[1 << last][last] = distance(0, last + 1);
    }

    for (var mask = 1; mask <= full; mask++) {
      for (var last = 0; last < others; last++) {
        final current = cost[mask][last];
        if ((mask & (1 << last)) == 0 || current == double.infinity) {
          continue;
        }
        for (var next = 0; next < others; next++) {
          if ((mask & (1 << next)) != 0) {
            continue;
          }
          final extended = mask | (1 << next);
          final candidate = current + distance(last + 1, next + 1);
          if (candidate < cost[extended][next]) {
            cost[extended][next] = candidate;
            previous[extended][next] = last;
          }
        }
      }
    }

    var end = 0;
    for (var last = 1; last < others; last++) {
      if (cost[full][last] < cost[full][end]) {
        end = last;
      }
    }

    final reversed = <int>[];
    var mask = full;
    var node = end;
    while (node != -1) {
      reversed.add(node + 1);
      final before = previous[mask][node];
      mask &= ~(1 << node);
      node = before;
    }
    return [0, ...reversed.reversed];
  }

  /// [points] sırasıyla kuş uçuşu toplam mesafe, metre.
  static double pathLength(List<GeoPoint> points) {
    var total = 0.0;
    for (var i = 1; i < points.length; i++) {
      total += points[i - 1].distanceTo(points[i]);
    }
    return total;
  }
}
