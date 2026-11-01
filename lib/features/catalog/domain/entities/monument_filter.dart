import 'package:vakif_atlas/features/catalog/domain/entities/monument_classification.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_summary.dart';

/// Eser listesine uygulanan filtre.
///
/// Aynı grup içindeki seçimler "veya", gruplar arası "ve" ile birleşir:
/// "Cami veya Han" ve "Osmanlı". Boş grup o ölçütü uygulamaz.
final class MonumentFilter {
  const MonumentFilter({
    this.categories = const {},
    this.periods = const {},
    this.cities = const {},
  });

  static const MonumentFilter none = MonumentFilter();

  final Set<MonumentCategory> categories;
  final Set<HistoricalPeriod> periods;

  /// İl plaka kodları (`city=16,34`); adlar facet'lerden gösterilir.
  final Set<int> cities;

  bool get isEmpty => categories.isEmpty && periods.isEmpty && cities.isEmpty;

  /// Seçili ölçüt sayısı (filtre butonundaki rozet).
  int get activeCount => categories.length + periods.length + cities.length;

  bool matches(MonumentSummary monument) =>
      (categories.isEmpty || categories.contains(monument.category)) &&
      (periods.isEmpty || periods.contains(monument.period)) &&
      (cities.isEmpty || cities.contains(monument.cityCode));

  MonumentFilter toggleCategory(MonumentCategory category) =>
      _copy(categories: _toggle(categories, category));

  MonumentFilter togglePeriod(HistoricalPeriod period) =>
      _copy(periods: _toggle(periods, period));

  MonumentFilter toggleCity(int city) => _copy(cities: _toggle(cities, city));

  /// Sonuçlarda artık bulunmayan illeri atar.
  MonumentFilter retainCities(Iterable<int> available) {
    final retained = cities.intersection(available.toSet());
    return retained.length == cities.length ? this : _copy(cities: retained);
  }

  MonumentFilter _copy({
    Set<MonumentCategory>? categories,
    Set<HistoricalPeriod>? periods,
    Set<int>? cities,
  }) => MonumentFilter(
    categories: Set.unmodifiable(categories ?? this.categories),
    periods: Set.unmodifiable(periods ?? this.periods),
    cities: Set.unmodifiable(cities ?? this.cities),
  );

  static Set<T> _toggle<T>(Set<T> values, T value) => values.contains(value)
      ? ({...values}..remove(value))
      : {...values, value};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonumentFilter &&
          _setEquals(other.categories, categories) &&
          _setEquals(other.periods, periods) &&
          _setEquals(other.cities, cities);

  @override
  int get hashCode => Object.hash(
    Object.hashAllUnordered(categories),
    Object.hashAllUnordered(periods),
    Object.hashAllUnordered(cities),
  );

  static bool _setEquals<T>(Set<T> a, Set<T> b) =>
      a.length == b.length && a.containsAll(b);

  @override
  String toString() =>
      'MonumentFilter(categories: $categories, periods: $periods, '
      'cities: ${cities.length})';
}
