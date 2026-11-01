import 'package:vakif_atlas/core/utils/turkish_text.dart';

/// Mock Catalog API'nin arama motoru (gerçek sunucunun davranış örneği).
///
/// Eser özet JSON'ları üzerinde çalışır:
/// - Türkçe harf/aksan duyarsız eşleşme; sorgudaki her kelime adda, ilçede,
///   ilde veya adreste geçmelidir.
/// - Alaka sırası: ad başı › ad kelimesi başı › ad içi › konum › adres; eşit
///   skorda sunucunun alfabetik sırası korunur. Sorgu boşsa alfabetik sıra.
/// - Filtre grupları "ve", grup içi seçimler "veya".
/// - Facet sayıları her grup için diğer grupların seçimleriyle hesaplanır
///   (disjunctive faceting).
abstract final class MockMonumentSearch {
  /// Bir aramada önerilen en fazla yer.
  static const int maxPlaces = 5;

  static List<Map<String, Object?>> search(
    List<Map<String, Object?>> items,
    MockSearchCriteria criteria,
  ) {
    final terms = _terms(criteria.text);
    final filtered = [
      for (final item in items)
        if (criteria.matchesFilters(item)) item,
    ];
    if (terms.isEmpty) {
      return filtered;
    }
    final scored = <(Map<String, Object?>, int, int)>[];
    for (var index = 0; index < filtered.length; index++) {
      final score = _score(filtered[index], terms);
      if (score != null) {
        scored.add((filtered[index], score, index));
      }
    }
    // `List.sort` kararlı değildir; eşit skorda özgün sıra korunur.
    scored.sort(
      (a, b) => a.$2 != b.$2 ? b.$2.compareTo(a.$2) : a.$3.compareTo(b.$3),
    );
    return [for (final (item, _, _) in scored) item];
  }

  /// Sorguya uyan il ve ilçeler (önce iller); sayı, filtreye uyan ve o
  /// bölgedeki eser sayısıdır.
  static List<Map<String, Object?>> places(
    List<Map<String, Object?>> items,
    MockSearchCriteria criteria,
  ) {
    final terms = _terms(criteria.text);
    if (terms.isEmpty) {
      return const [];
    }
    final cities = <String, List<Map<String, Object?>>>{};
    final districts = <(String, String), List<Map<String, Object?>>>{};
    for (final item in items) {
      if (!criteria.matchesFilters(item)) {
        continue;
      }
      final cityName = item['city']! as String;
      final districtName = item['district']! as String;
      final city = TurkishText.fold(cityName);
      final district = TurkishText.fold(districtName);
      if (terms.every(city.contains)) {
        cities.putIfAbsent(cityName, () => []).add(item);
      }
      if (terms.every((t) => district.contains(t) || city.contains(t)) &&
          terms.any(district.contains)) {
        districts.putIfAbsent((cityName, districtName), () => []).add(item);
      }
    }
    final cityNames = cities.keys.toList()..sort(TurkishText.compare);
    final districtKeys = districts.keys.toList()
      ..sort((a, b) {
        final byCity = TurkishText.compare(a.$1, b.$1);
        return byCity != 0 ? byCity : TurkishText.compare(a.$2, b.$2);
      });
    Map<String, Object?> cityRef(List<Map<String, Object?>> items) => {
      'code': items.first['cityCode'],
      'name': items.first['city'],
    };
    return [
      for (final city in cityNames)
        {
          'city': cityRef(cities[city]!),
          'count': cities[city]!.length,
          'bounds': boundsOf(cities[city]!),
        },
      for (final key in districtKeys)
        {
          'city': cityRef(districts[key]!),
          'district': key.$2,
          'count': districts[key]!.length,
          'bounds': boundsOf(districts[key]!),
        },
    ].take(maxPlaces).toList(growable: false);
  }

  /// Özet JSON'larının `[güney, batı, kuzey, doğu]` sınırı; boşsa `null`.
  static List<double>? boundsOf(Iterable<Map<String, Object?>> items) {
    double? south, west, north, east;
    for (final item in items) {
      final (lat, lng) = locationOf(item);
      south = south == null || lat < south ? lat : south;
      north = north == null || lat > north ? lat : north;
      west = west == null || lng < west ? lng : west;
      east = east == null || lng > east ? lng : east;
    }
    return south == null ? null : [south, west!, north!, east!];
  }

  static (double, double) locationOf(Map<String, Object?> item) {
    final location = item['location']! as Map<String, Object?>;
    return (
      (location['latitude']! as num).toDouble(),
      (location['longitude']! as num).toDouble(),
    );
  }

  /// Metin sorgusuna uyan eserler üzerinde disjunctive facet sayıları.
  static Map<String, Object?> facets(
    List<Map<String, Object?>> items,
    MockSearchCriteria criteria,
  ) {
    final textMatches = search(items, criteria.withoutFilters());
    Map<String, int> count(String field, MockSearchCriteria others) {
      final counts = <String, int>{};
      for (final item in textMatches) {
        if (others.matchesFilters(item)) {
          counts.update(
            item[field]! as String,
            (n) => n + 1,
            ifAbsent: () => 1,
          );
        }
      }
      return counts;
    }

    final cities = count('city', criteria.withoutCities());
    final codes = {
      for (final item in textMatches) item['city']! as String: item['cityCode'],
    };
    final sortedCities = cities.keys.toList()..sort(TurkishText.compare);
    return {
      'category': count('category', criteria.withoutCategories()),
      'period': count('period', criteria.withoutPeriods()),
      'city': [
        for (final city in sortedCities)
          {'code': codes[city], 'name': city, 'count': cities[city]},
      ],
    };
  }

  static List<String> _terms(String query) =>
      TurkishText.fold(query)
          .split(RegExp(r'\s+'))
          .where((term) => term.isNotEmpty)
          .toList(growable: false);

  static const int _namePrefix = 4;
  static const int _nameWordPrefix = 3;
  static const int _nameContains = 2;
  static const int _location = 1;
  static const int _address = 0;

  /// Kelimelerin en zayıf eşleşmesi kaydın skorudur; bir kelime hiçbir
  /// alanda yoksa kayıt elenir (`null`).
  static int? _score(Map<String, Object?> item, List<String> terms) {
    final name = TurkishText.fold(item['name']! as String);
    final nameWords = name.split(RegExp(r'[\s\-]+'));
    final location = TurkishText.fold('${item['district']} ${item['city']}');
    final address = TurkishText.fold(item['address']! as String);
    int? weakest;
    for (final term in terms) {
      final int score;
      if (name.startsWith(term)) {
        score = _namePrefix;
      } else if (nameWords.any((word) => word.startsWith(term))) {
        score = _nameWordPrefix;
      } else if (name.contains(term)) {
        score = _nameContains;
      } else if (location.contains(term)) {
        score = _location;
      } else if (address.contains(term)) {
        score = _address;
      } else {
        return null;
      }
      weakest = weakest == null || score < weakest ? score : weakest;
    }
    return weakest;
  }
}

/// Sorgu parametrelerinden çözülmüş arama ölçütleri.
final class MockSearchCriteria {
  const MockSearchCriteria({
    this.text = '',
    this.categories = const {},
    this.periods = const {},
    this.cities = const {},
    this.ids = const {},
    this.bbox,
  });

  /// `q`, `category`, `period`, `city` (plaka kodu), `keys` (virgülle
  /// ayrılmış) parametreleri.
  factory MockSearchCriteria.fromQuery(Map<String, String> query) {
    Set<String> list(String key) => {
      for (final value in (query[key] ?? '').split(','))
        if (value.trim().isNotEmpty) value.trim(),
    };
    final box = (query['bbox'] ?? '')
        .split(',')
        .map((v) => double.tryParse(v.trim()))
        .toList();
    return MockSearchCriteria(
      text: query['q'] ?? '',
      categories: list('category'),
      periods: list('period'),
      cities: list('city'),
      ids: list('keys'),
      bbox: box.length == 4 && box.every((v) => v != null)
          ? (box[0]!, box[1]!, box[2]!, box[3]!)
          : null,
    );
  }

  /// `(güney, batı, kuzey, doğu)`; `null` → alan filtresi yok.
  final (double, double, double, double)? bbox;

  final String text;
  final Set<String> categories;
  final Set<String> periods;

  /// İl plaka kodları.
  final Set<String> cities;

  /// `keys`: yalnızca bu anahtarlar (rota durakları).
  final Set<String> ids;

  bool matchesFilters(Map<String, Object?> item) =>
      (categories.isEmpty || categories.contains(item['category'])) &&
      (periods.isEmpty || periods.contains(item['period'])) &&
      (cities.isEmpty || cities.contains('${item['cityCode']}')) &&
      (ids.isEmpty || ids.contains(item['id'])) &&
      _inBox(item);

  bool _inBox(Map<String, Object?> item) {
    final box = bbox;
    if (box == null) {
      return true;
    }
    final (lat, lng) = MockMonumentSearch.locationOf(item);
    return lat >= box.$1 && lat <= box.$3 && lng >= box.$2 && lng <= box.$4;
  }

  MockSearchCriteria withoutFilters() =>
      MockSearchCriteria(text: text, ids: ids, bbox: bbox);

  MockSearchCriteria withoutCategories() => MockSearchCriteria(
    text: text,
    periods: periods,
    cities: cities,
    ids: ids,
    bbox: bbox,
  );

  MockSearchCriteria withoutPeriods() => MockSearchCriteria(
    text: text,
    categories: categories,
    cities: cities,
    ids: ids,
    bbox: bbox,
  );

  MockSearchCriteria withoutCities() => MockSearchCriteria(
    text: text,
    categories: categories,
    periods: periods,
    ids: ids,
    bbox: bbox,
  );
}
