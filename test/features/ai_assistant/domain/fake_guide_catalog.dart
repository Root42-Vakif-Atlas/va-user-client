import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/turkish_text.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/geo_point.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/map_tile.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_classification.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_detail.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_summary.dart';
import 'package:vakif_atlas/features/catalog/domain/repositories/catalog_repository.dart';

/// Rehber testleri için bellek içi katalog: canlı kataloğun bir kesiti
/// (metinler VGM kayıtlarından kısaltılmıştır).
///
/// Arama Catalog API gibi davranır: metindeki tüm sözcükler (katlanmış,
/// sözcük başı) eser adında, ilçesinde veya ilinde geçmelidir. Dönem
/// bilgisi girilmemiştir (tüm eserler `other`), canlı katalogdaki gibi.
final class FakeGuideCatalog implements CatalogRepository {
  FakeGuideCatalog([List<FakeWork>? works]) : works = works ?? defaultWorks;

  final List<FakeWork> works;

  /// Sonraki isteklerin döneceği hata (ör. ağ yok).
  Failure? failure;

  final List<MonumentSearchQuery> searches = [];

  @override
  ResultFuture<MonumentSearchResults> searchMonuments({
    required MonumentSearchQuery query,
    required String languageCode,
    required int limit,
    String? cursor,
    GeoBounds? bounds,
  }) async {
    searches.add(query);
    if (failure case final Failure failure) {
      return Left(failure);
    }
    final words = _tokens(query.normalizedText);
    final matches = [
      for (final work in works)
        if (query.filter.matches(work.summary) &&
            words.every(
              (word) =>
                  _tokens('${work.name} ${work.district} ${work.city}')
                      .any((token) => token.startsWith(word)),
            ))
          work.summary,
    ];
    return Right(
      MonumentSearchResults(
        items: matches.take(limit).toList(),
        total: matches.length,
        facets: cursor == null ? _facets(matches) : MonumentFacets.empty,
      ),
    );
  }

  @override
  ResultFuture<MonumentDetail> getMonumentDetail({
    required String id,
    required String languageCode,
  }) async {
    if (failure case final Failure failure) {
      return Left(failure);
    }
    final work = works.where((w) => w.id == id).firstOrNull;
    return work == null
        ? const Left(ServerFailure(kind: ServerFailureKind.notFound))
        : Right(work.detail);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');

  static MonumentFacets _facets(List<MonumentSummary> items) {
    final categories = <MonumentCategory, int>{};
    final periods = <HistoricalPeriod, int>{};
    final cities = <int, int>{};
    final names = <int, String>{};
    for (final item in items) {
      categories.update(item.category, (n) => n + 1, ifAbsent: () => 1);
      periods.update(item.period, (n) => n + 1, ifAbsent: () => 1);
      cities.update(item.cityCode!, (n) => n + 1, ifAbsent: () => 1);
      names[item.cityCode!] = item.city;
    }
    return MonumentFacets(
      categories: categories,
      periods: periods,
      cities: cities,
      cityNames: names,
    );
  }

  static List<String> _tokens(String text) =>
      TurkishText.fold(text)
          .split(RegExp('[^a-z0-9]+'))
          .where((t) => t.isNotEmpty)
          .toList();

  static const GeoPoint _somewhere = GeoPoint(
    latitude: 40.18,
    longitude: 29.06,
  );

  static final List<FakeWork> defaultWorks = [
    FakeWork(
      id: 'bursa-ulu-camii',
      name: 'Bursa Ulu Camii',
      category: MonumentCategory.mosque,
      city: 'Bursa',
      cityCode: 16,
      district: 'Osmangazi',
      address: 'Ulucami, Osmangazi ilçesi, Atatürk Caddesi.\n\nUzun açıklama.',
      shortDescription: 'Ulucami, Osmangazi ilçesinde yer almaktadır.',
      description:
          'Ulucami, Osmangazi ilçesinde yer almaktadır.\n\n'
          'Osmanlı’nın Bursa’da inşa ettirdiği ilk büyük camidir ve altı '
          'yüzyıl boyunca şehrin en büyük camisi olarak kalmıştır. Üç yıl '
          'süren inşaat sürecinin ardından, caminin açılışı 1399 yılında '
          'gerçekleştirilmiştir. Kubbenin üstü, kuşların veya yabani '
          'hayvanların içeri girmesini engellemek için tellerle örtülmüştür. '
          'Sultan Yıldırım Bayezid tarafından yaptırılan bu eserin mimarı '
          'kesin olarak bilinmemekle birlikte, Ali Neccâr ya da Hacı İvaz '
          'Paşa tarafından inşa edildiği düşünülmektedir.',
      location: _somewhere,
    ),
    FakeWork(
      id: 'ulu-hudavendigar-camii',
      name: 'Ulu (Hudâvendigâr) Camii',
      category: MonumentCategory.mosque,
      city: 'Bursa',
      cityCode: 16,
      district: 'Karacabey',
      description:
          'H. 1118 / M. 1774 tarihinde camiye müezzin görevlendirmeleri '
          'yapılmıştır.',
      location: _somewhere,
    ),
    FakeWork(
      id: 'muradiye-camii',
      name: 'Muradiye Camii',
      category: MonumentCategory.mosque,
      city: 'Bursa',
      cityCode: 16,
      district: 'Osmangazi',
      description:
          'Cami, II. Murad tarafından H. 829 / M. 1426 yılında inşa '
          'ettirilmiştir.',
      location: _somewhere,
    ),
    FakeWork(
      id: 'muradiye-camii-orhangazi',
      name: 'Muradiye Camii',
      category: MonumentCategory.mosque,
      city: 'Bursa',
      cityCode: 16,
      district: 'Orhangazi',
      description:
          'Caminin I. Murad Hudâvendigâr döneminde bir vakıf eseri olarak '
          'inşa edilmiş olma ihtimali güçlüdür.',
      location: _somewhere,
    ),
    FakeWork(
      id: 'aksu-koyu-hamami',
      name: 'Aksu Köyü Hamamı',
      category: MonumentCategory.bath,
      city: 'Bursa',
      cityCode: 16,
      district: 'Kestel',
      description: 'Köy hamamıdır.',
      location: _somewhere,
    ),
    FakeWork(
      id: 'hz-mevlana-turbesi',
      name: 'Hz. Mevlâna Türbesi (Kubbe-i Hadra- Müze)',
      category: MonumentCategory.tomb,
      city: 'Konya',
      cityCode: 42,
      district: 'Karatay',
      description:
          'Mezar sandukasının ön yüzünde, 16. yüzyılda Mahmud Paşa '
          'tarafından yaptırılmış olan gümüş kafes yer almaktadır. '
          'Araştırmalara göre mezarının üzerine yaptırılan türbe, 1274 '
          'senesinin bahar aylarında Sultan Veled’in izniyle '
          'yaptırılmıştır. 2018 yılında Müze Müdürlüğü tarafından '
          'yaptırılan restorasyon çalışmalarında bir kitâbe bulunmuştur.',
      location: _somewhere,
    ),
    FakeWork(
      id: 'ulu-camii-doganhisar',
      name: 'Ulu Camii',
      category: MonumentCategory.mosque,
      city: 'Konya',
      cityCode: 42,
      district: 'Doğanhisar',
      description: 'H. 955 / M. 1548 tarihinde inşa edilmiştir.',
      location: _somewhere,
    ),
    FakeWork(
      id: 'ulu-carsi-camii',
      name: 'Ulu (Çarşı - Merkez) Camii',
      category: MonumentCategory.mosque,
      city: 'Konya',
      cityCode: 42,
      district: 'Çeltik',
      description: 'Yapının ilk inşâsı hakkında bilgi yoktur.',
      location: _somewhere,
    ),
    FakeWork(
      id: 'antakya-ulu-camii',
      name: 'Antakya Ulu Camii',
      category: MonumentCategory.mosque,
      city: 'Hatay',
      cityCode: 31,
      district: 'Antakya',
      description: 'Memlük döneminden kalmadır.',
      location: _somewhere,
    ),
    FakeWork(
      id: 'sekerhan',
      name: 'Şekerhan',
      category: MonumentCategory.inn,
      city: 'İstanbul',
      cityCode: 34,
      district: 'Fatih',
      address: 'Hobyar Mah. Hoca Kasım Köprüsü Sk. No:4 (Fatih/İstanbul)',
      shortDescription: 'Fatih’te dört katlı kâgir tarihî handır.',
      description:
          'Şekerhan, Eminönü’nün ticaret dokusu içinde dört katlı kâgir bir '
          'handır. Tescilli yapının kapalı alanı yaklaşık 2.639 '
          'metrekaredir.',
    ),
  ];
}

final class FakeWork {
  FakeWork({
    required this.id,
    required this.name,
    required this.category,
    required this.city,
    required this.cityCode,
    required this.district,
    required this.description,
    this.address = '',
    this.shortDescription = '',
    this.location,
  });

  final String id;
  final String name;
  final MonumentCategory category;
  final String city;
  final int cityCode;
  final String district;
  final String address;
  final String shortDescription;
  final String description;
  final GeoPoint? location;

  MonumentSummary get summary => MonumentSummary(
    id: id,
    name: name,
    category: category,
    period: HistoricalPeriod.other,
    city: city,
    cityCode: cityCode,
    district: district,
    address: address,
    location: location,
    shortDescription: shortDescription,
  );

  MonumentDetail get detail => MonumentDetail(
    id: id,
    name: name,
    category: category,
    period: HistoricalPeriod.other,
    city: city,
    district: district,
    address: address,
    location: location,
    shortDescription: shortDescription,
    description: description,
    history: '',
    constructionDate: '',
    founder: '',
    images: const [],
  );
}
