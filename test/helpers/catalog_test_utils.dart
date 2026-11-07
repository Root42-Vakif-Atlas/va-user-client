import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:vakif_atlas/core/map/map_tiles.dart';
import 'package:vakif_atlas/features/catalog/data/dtos/map_tile_dtos.dart';
import 'package:vakif_atlas/features/catalog/data/dtos/monument_dtos.dart';
import 'package:vakif_atlas/features/catalog/data/repositories/catalog_repository_impl.dart';
import 'package:vakif_atlas/features/catalog/data/sources/catalog_local_data_source.dart';
import 'package:vakif_atlas/features/catalog/data/sources/catalog_remote_data_source.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_detail.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_summary.dart';
import 'package:vakif_atlas/features/catalog/domain/usecases/catalog_usecases.dart';

import '../support/mock_api/catalog/catalog_fixtures.dart';
import '../support/mock_api/catalog/catalog_mock_api.dart';
import 'network_test_utils.dart';

Map<String, dynamic> _json(Map<String, Object?> value) =>
    jsonDecode(jsonEncode(value)) as Map<String, dynamic>;

/// İllerin 10 temsilcisi (külliye yapıları hariç; Süleymaniye Camii bağımsız
/// eser gibi görünür): tek sayfalık katalog gerektiren arayüz testleri için.
final List<MockMonument> provinceMonuments = CatalogFixtures.monuments
    .take(10)
    .toList(growable: false);

/// Mock katalogdaki eserlerin özetleri (sunucuyla aynı JSON yolundan).
///
/// Külliye sunucuda eser değildir; fikstür sırasını korumak için kaydı
/// külliye detayından özet olarak kurulur ([MonumentSummary.memberCount]).
List<MonumentSummary> fixtureMonuments({String languageCode = 'tr'}) {
  final api = CatalogMockApi();
  return [
    for (final monument in CatalogFixtures.monuments)
      if (monument.isComplex)
        _complexSummary(
          ComplexDetailDto.fromJson(
            _json(api.complexDetailJson(monument, languageCode)),
          ),
          monument.shortDescription.resolve(languageCode),
        )
      else
        MonumentSummaryDto.fromJson(
          _json(api.wireSummaryJson(monument, languageCode)),
        ).toDomain(),
  ];
}

MonumentSummary _complexSummary(
  ComplexDetailDto complex,
  String shortDescription,
) {
  final detail = complex.toMonumentDetail();
  return MonumentSummary(
    id: detail.id,
    name: detail.name,
    category: detail.category,
    period: detail.period,
    city: detail.city,
    cityCode: complex.city.code,
    district: detail.district,
    address: detail.address,
    location: detail.location,
    shortDescription: shortDescription,
    thumbnailUrl: detail.images.firstOrNull?.thumbnailUrl,
    memberCount: complex.workCount,
  );
}

/// Mock katalogdaki eserlerin hafif konum kayıtları (fixture sırasıyla).
List<MonumentPin> fixturePins({String languageCode = 'tr'}) => [
  for (final monument in fixtureMonuments(languageCode: languageCode))
    MonumentPin.fromSummary(monument),
];

/// Mock katalogdaki [id] kimlikli eserin detayı.
MonumentDetail fixtureDetail(String id, {String languageCode = 'tr'}) {
  final monument = CatalogFixtures.monuments.firstWhere((m) => m.id == id);
  final api = CatalogMockApi();
  return monument.isComplex
      ? ComplexDetailDto.fromJson(
          _json(api.complexDetailJson(monument, languageCode)),
        ).toMonumentDetail()
      : MonumentDetailDto.fromJson(
          _json(api.wireDetailJson(monument, languageCode)),
        ).toDomain();
}

/// Bellek içi katalog önbelleği.
///
/// Widget testlerinin sahte zaman bölgesinde Hive'ın dosya G/Ç'si
/// tamamlanmadığından tam DI grafiğinde bunun yerine kullanılır.
class InMemoryCatalogLocalDataSource implements CatalogLocalDataSource {
  final Map<String, MonumentDetailDto> details = {};

  @override
  Future<MonumentDetailDto?> readMonumentDetail(
    String id,
    String languageCode,
  ) async => details['$languageCode/$id'];

  @override
  Future<void> saveMonumentDetail(
    String languageCode,
    MonumentDetailDto monument,
  ) async => details['$languageCode/${monument.key}'] = monument;

  /// `sürüm/dil/z/x/y` → ham karo yanıtı.
  final Map<String, Map<String, dynamic>> tiles = {};
  final Map<String, MapExtentDto> extents = {};

  @override
  Future<Map<String, dynamic>?> readMapTile({
    required String version,
    required String languageCode,
    required TileId tile,
  }) async => tiles['$version/$languageCode/$tile'];

  @override
  Future<void> saveMapTile({
    required String version,
    required String languageCode,
    required TileId tile,
    required Map<String, dynamic> json,
  }) async => tiles['$version/$languageCode/$tile'] = json;

  @override
  Future<MapExtentDto?> readMapExtent(String languageCode) async =>
      extents[languageCode];

  @override
  Future<void> saveMapExtent(String languageCode, MapExtentDto extent) async =>
      extents[languageCode] = extent;

  @override
  Future<void> pruneMapTiles({required String keepVersion}) async =>
      tiles.removeWhere((key, _) => !key.startsWith('$keepVersion/'));
}

/// Sayfalama testleri için [count] eserlik yapay veri seti (yalnızca test):
/// mock fixture'lar kimlik ve ad sonekiyle çoğaltılır. Adlar sıfır dolgulu
/// numara taşır, böylece alfabetik sıra numara sırasıdır.
List<MockMonument> syntheticMonuments(int count) {
  final base = provinceMonuments;
  return [
    for (var i = 0; i < count; i++)
      () {
        final source = base[i % base.length];
        final number = i.toString().padLeft(3, '0');
        return MockMonument(
          id: 'test-$number',
          name: MockText.same('Test Eseri $number'),
          category: source.category,
          period: source.period,
          city: source.city,
          district: source.district,
          address: source.address,
          latitude: source.latitude,
          longitude: source.longitude,
          shortDescription: source.shortDescription,
          description: source.description,
          history: source.history,
          constructionDate: source.constructionDate,
          founder: source.founder,
          images: source.images,
        );
      }(),
  ];
}

/// Mock Catalog API'ye süreç içinde (gecikmesiz HTTP katmanı) bağlı use
/// case'ler: DTO ayrıştırma, hata eşleme ve sunucu davranışı uçtan uca
/// çalışır.
///
/// [onRequest] her HTTP isteğinde çağrılır (önbellek testleri).
CatalogUseCases catalogUseCases([
  CatalogMockApi? api,
  void Function()? onRequest,
]) {
  final dio = testDio((api ?? CatalogMockApi()).routes);
  if (onRequest != null) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          onRequest();
          handler.next(options);
        },
      ),
    );
  }
  final repository = CatalogRepositoryImpl(
    CatalogRemoteDataSourceImpl(dio),
    InMemoryCatalogLocalDataSource(),
  );
  return (
    search: SearchMonumentsUseCase(repository),
    pins: GetMonumentPinsUseCase(repository),
    detail: GetMonumentDetailUseCase(repository),
    tile: GetMapTileUseCase(repository),
    extent: GetMapExtentUseCase(repository),
    complexDetail: GetComplexDetailUseCase(repository),
    complexMembers: GetComplexMembersUseCase(repository),
  );
}

/// Mock sunucuya bağlı gerçek katalog use case'leri.
typedef CatalogUseCases = ({
  SearchMonumentsUseCase search,
  GetMonumentPinsUseCase pins,
  GetMonumentDetailUseCase detail,
  GetMapTileUseCase tile,
  GetMapExtentUseCase extent,
  GetComplexDetailUseCase complexDetail,
  GetComplexMembersUseCase complexMembers,
});
