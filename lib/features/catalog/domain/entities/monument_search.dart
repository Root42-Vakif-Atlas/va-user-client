import 'package:vakif_atlas/features/catalog/domain/entities/complex.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/geo_point.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/map_tile.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_classification.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_filter.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_summary.dart';

/// Arama metni + filtre. Boş sorgu tüm eserleri (alfabetik) listeler.
final class MonumentSearchQuery {
  const MonumentSearchQuery({
    this.text = '',
    this.filter = MonumentFilter.none,
  });

  static const MonumentSearchQuery empty = MonumentSearchQuery();

  /// Sunucuya gönderilen en uzun arama metni.
  static const int maxTextLength = 100;

  final String text;
  final MonumentFilter filter;

  /// Sunucuya gönderilecek biçim: kırpılmış, en çok [maxTextLength] karakter.
  String get normalizedText {
    final trimmed = text.trim();
    return trimmed.length <= maxTextLength
        ? trimmed
        : trimmed.substring(0, maxTextLength);
  }

  bool get isEmpty => normalizedText.isEmpty && filter.isEmpty;

  MonumentSearchQuery withText(String text) =>
      MonumentSearchQuery(text: text, filter: filter);

  MonumentSearchQuery withFilter(MonumentFilter filter) =>
      MonumentSearchQuery(text: text, filter: filter);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonumentSearchQuery &&
          other.normalizedText == normalizedText &&
          other.filter == filter;

  @override
  int get hashCode => Object.hash(normalizedText, filter);

  @override
  String toString() =>
      'MonumentSearchQuery(text: ${normalizedText.length} chars, $filter)';
}

/// Arama sonucunda önerilen yer: il veya ilçe ve oradaki eşleşen eser sayısı.
final class MonumentPlace {
  const MonumentPlace({
    required this.city,
    this.district,
    this.count = 0,
    this.bounds,
  });

  final String city;

  /// `null` → tüm il.
  final String? district;
  final int count;

  /// Bölgedeki eşleşen eserlerin sınırı (haritada sığdırma).
  final GeoBounds? bounds;

  bool contains(MonumentPin pin) =>
      pin.city == city && (district == null || pin.district == district);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonumentPlace &&
          other.city == city &&
          other.district == district &&
          other.count == count &&
          other.bounds == bounds;

  @override
  int get hashCode => Object.hash(city, district, count, bounds);

  @override
  String toString() => 'MonumentPlace($city, $district, $count)';
}

/// Filtre seçeneklerinin sonuç sayıları (faceted search).
///
/// Her grubun sayıları, diğer grupların seçimleri uygulanarak hesaplanır
/// (disjunctive faceting): "Cami" seçiliyken "Han" seçeneği, seçilirse
/// eklenecek sonuç sayısını gösterir.
final class MonumentFacets {
  const MonumentFacets({
    this.categories = const {},
    this.periods = const {},
    this.cities = const {},
    this.cityNames = const {},
  });

  static const MonumentFacets empty = MonumentFacets();

  final Map<MonumentCategory, int> categories;
  final Map<HistoricalPeriod, int> periods;

  /// İl plaka kodu → sayı; sunucunun dile duyarlı alfabetik sırasıyla.
  final Map<int, int> cities;

  /// İl plaka kodu → ad (içerik dilinde).
  final Map<int, String> cityNames;

  bool get isEmpty => categories.isEmpty && periods.isEmpty && cities.isEmpty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonumentFacets &&
          _mapEquals(other.categories, categories) &&
          _mapEquals(other.periods, periods) &&
          _mapEquals(other.cities, cities) &&
          _mapEquals(other.cityNames, cityNames);

  @override
  int get hashCode => Object.hash(
    Object.hashAllUnordered(categories.entries.map((e) => (e.key, e.value))),
    Object.hashAllUnordered(periods.entries.map((e) => (e.key, e.value))),
    Object.hashAllUnordered(cities.entries.map((e) => (e.key, e.value))),
  );

  static bool _mapEquals<K, V>(Map<K, V> a, Map<K, V> b) =>
      a.length == b.length &&
      a.entries.every((entry) => b[entry.key] == entry.value);
}

/// Sayfalı arama sonucunun bir sayfası.
final class MonumentSearchResults {
  const MonumentSearchResults({
    required this.items,
    required this.total,
    this.nextCursor,
    this.places = const [],
    this.facets = MonumentFacets.empty,
  });

  final List<MonumentSummary> items;

  /// Sorguya uyan toplam eser sayısı.
  final int total;

  /// Sonraki sayfanın opak imleci; `null` → son sayfa.
  final String? nextCursor;

  /// Yalnızca ilk sayfada ve metin sorgusunda dolu.
  final List<MonumentPlace> places;

  /// Yalnızca ilk sayfada dolu.
  final MonumentFacets facets;

  bool get hasMore => nextCursor != null;
}

/// Rota planlayıcı için hafif eser kaydı
/// (`GET catalog/monuments?view=location&ids=…`).
///
/// Ad, il ve ilçe pinin ekran okuyucu etiketi ve rota durak satırı içindir;
/// açıklama ve görseller seçimde ayrıca istenir.
final class MonumentPin {
  const MonumentPin({
    required this.id,
    required this.name,
    required this.category,
    required this.city,
    required this.district,
    required this.location,
    this.complex,
    this.memberCount,
  });

  /// Arama sonucundan seçilen eserin rota için gereken alanları.
  MonumentPin.fromSummary(MonumentSummary summary)
    : this(
        id: summary.id,
        name: summary.name,
        category: summary.category,
        city: summary.city,
        district: summary.district,
        location: summary.location,
        complex: summary.complex,
        memberCount: summary.memberCount,
      );

  final String id;
  final String name;
  final MonumentCategory category;
  final String city;
  final String district;

  /// Konumu girilmemiş eserde `null`: haritada gösterilmez, rotaya eklenemez.
  final GeoPoint? location;

  bool get hasLocation => location?.isValid ?? false;

  /// Üyesi olduğu külliye; bağımsız eserde `null`.
  final ComplexRef? complex;

  /// Yalnızca külliye kayıtlarında dolu: üye yapı sayısı.
  final int? memberCount;

  bool get isComplex => memberCount != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonumentPin &&
          other.id == id &&
          other.name == name &&
          other.category == category &&
          other.city == city &&
          other.district == district &&
          other.location == location &&
          other.complex == complex &&
          other.memberCount == memberCount;

  @override
  int get hashCode => Object.hash(
    id,
    name,
    category,
    city,
    district,
    location,
    complex,
    memberCount,
  );

  @override
  String toString() => 'MonumentPin($id)';
}
