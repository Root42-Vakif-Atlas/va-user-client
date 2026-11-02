import 'package:vakif_atlas/features/catalog/domain/entities/geo_point.dart';

/// Toplam yolculuk maliyetini en aza indiren durak sırası (PRD: mesafe
/// optimizasyonlu kültür rotası).
///
/// Maliyet sunucunun karayolu süre matrisidir ([byCost], bizim OSRM);
/// matris alınamazsa kuş uçuşu mesafe ([call]). İlk durak kullanıcının
/// seçtiği başlangıç olarak sabit kalır; dönüş yoktur (açık yol). En çok 10
/// durak için Held-Karp dinamik programlamasıyla kesin en iyi sıra bulunur
/// (O(n²·2ⁿ), 10 durakta ~5 bin durum). Matris simetrik olmak zorunda
/// değildir (tek yönlü yollar).
class OptimizeStopOrderUseCase {
  const OptimizeStopOrderUseCase();

  /// Kuş uçuşu mesafeye göre. Yeni sıradaki eski indeksler; ör. `[0, 2, 1]`
  /// → ikinci ve üçüncü durak yer değiştirir.
  List<int> call(List<GeoPoint> points) =>
      byCost(points.length, (a, b) => points[a].distanceTo(points[b]));

  /// [count] durak için `cost(a, b)` = `a` → `b` maliyeti.
  List<int> byCost(int count, double Function(int from, int to) cost) {
    if (count <= 2) {
      return [for (var i = 0; i < count; i++) i];
    }

    // Başlangıç dışındaki duraklar maskede 0..others-1 bitleriyle tutulur.
    final others = count - 1;
    final full = (1 << others) - 1;
    double distance(int a, int b) => cost(a, b);

    final best = List.generate(
      1 << others,
      (_) => List<double>.filled(others, double.infinity),
    );
    final previous = List.generate(
      1 << others,
      (_) => List<int>.filled(others, -1),
    );
    for (var last = 0; last < others; last++) {
      best[1 << last][last] = distance(0, last + 1);
    }

    for (var mask = 1; mask <= full; mask++) {
      for (var last = 0; last < others; last++) {
        final current = best[mask][last];
        if ((mask & (1 << last)) == 0 || current == double.infinity) {
          continue;
        }
        for (var next = 0; next < others; next++) {
          if ((mask & (1 << next)) != 0) {
            continue;
          }
          final extended = mask | (1 << next);
          final candidate = current + distance(last + 1, next + 1);
          if (candidate < best[extended][next]) {
            best[extended][next] = candidate;
            previous[extended][next] = last;
          }
        }
      }
    }

    var end = 0;
    for (var last = 1; last < others; last++) {
      if (best[full][last] < best[full][end]) {
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
  static double pathLength(List<GeoPoint> points) =>
      pathCost(points.length, (a, b) => points[a].distanceTo(points[b]));

  /// [order] sırasıyla toplam maliyet; `cost` eski indekslerle çağrılır.
  static double pathCost(
    int count,
    double Function(int from, int to) cost, [
    List<int>? order,
  ]) {
    final sequence = order ?? [for (var i = 0; i < count; i++) i];
    var total = 0.0;
    for (var i = 1; i < sequence.length; i++) {
      total += cost(sequence[i - 1], sequence[i]);
    }
    return total;
  }
}
