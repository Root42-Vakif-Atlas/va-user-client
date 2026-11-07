import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/exceptions.dart';
import 'package:vakif_atlas/core/map/map_tiles.dart';
import 'package:vakif_atlas/core/network/network_constants.dart';
import 'package:vakif_atlas/features/catalog/data/dtos/map_tile_dtos.dart';
import 'package:vakif_atlas/features/catalog/data/dtos/monument_dtos.dart';
import 'package:vakif_atlas/features/catalog/data/dtos/monument_search_dtos.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/map_tile.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_classification.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';

/// Catalog mikro servisinin uç noktaları (ana API istemcisi üzerinden).
///
/// Hatalar `DioException` (içinde `AppException`) veya bozuk gövdede
/// `CheckedFromJsonException` olarak fırlatılır.
abstract interface class CatalogRemoteDataSource {
  Future<MonumentDetailDto> fetchMonumentDetail({
    required String id,
    required String languageCode,
  });

  /// Liste görünümü (`view=summary`); [includeExtras] → facet ve yer
  /// önerileri (yalnızca ilk sayfada istenir).
  Future<MonumentSearchResponseDto> searchMonuments({
    required MonumentSearchQuery query,
    required String languageCode,
    required int limit,
    String? cursor,
    bool includeExtras = false,
    GeoBounds? bounds,
  });

  Future<List<MapTileItemDto>> fetchMapTile({
    required TileId tile,
    required MonumentSearchQuery query,
    required String version,
    required String languageCode,
  });

  /// [fetchMapTile]'ın ham yanıt gövdesi (`{"items": [...]}`): yerel
  /// önbelleğe sunucu biçiminde yazılır, okunurken aynı DTO ayrıştırmasından
  /// geçer.
  Future<Map<String, dynamic>> fetchMapTileJson({
    required TileId tile,
    required MonumentSearchQuery query,
    required String version,
    required String languageCode,
  });

  Future<MapExtentDto> fetchMapExtent({
    required MonumentSearchQuery query,
    required String languageCode,
  });

  /// Kimlikleri verilen eserlerin hafif konum görünümü (`view=location`);
  /// en çok [CatalogQueryParameters.maxIds] kimlik.
  Future<MonumentPinPageDto> fetchMonumentPins({
    required List<String> ids,
    required String languageCode,
  });

  /// Külliye detayı + yapıların ilk sayfası (`GET catalog/complexes/{key}`).
  Future<ComplexDetailDto> fetchComplexDetail({
    required String id,
    required String languageCode,
  });

  /// Külliye yapılarının bir sayfası (`GET catalog/complexes/{key}/works`).
  Future<ComplexMembersPageDto> fetchComplexMembers({
    required String id,
    required String languageCode,
    required int limit,
    String? cursor,
    Set<MonumentCategory> categories = const {},
  });
}

@LazySingleton(as: CatalogRemoteDataSource)
class CatalogRemoteDataSourceImpl implements CatalogRemoteDataSource {
  CatalogRemoteDataSourceImpl(@Named(DioNames.api) this._dio);

  final Dio _dio;

  @override
  Future<MonumentDetailDto> fetchMonumentDetail({
    required String id,
    required String languageCode,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      CatalogEndpoints.monument(id),
      options: _options(languageCode),
    );
    return MonumentDetailDto.fromJson(_body(response));
  }

  @override
  Future<MonumentSearchResponseDto> searchMonuments({
    required MonumentSearchQuery query,
    required String languageCode,
    required int limit,
    String? cursor,
    bool includeExtras = false,
    GeoBounds? bounds,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      CatalogEndpoints.monuments,
      queryParameters: {
        ...CatalogQueryParameters.of(query),
        if (bounds != null)
          CatalogQueryParameters.bbox: CatalogQueryParameters.formatBounds(
            bounds,
          ),
        CatalogQueryParameters.view: CatalogQueryParameters.viewSummary,
        CatalogQueryParameters.limit: limit,
        CatalogQueryParameters.cursor: ?cursor,
        if (includeExtras)
          CatalogQueryParameters.include: CatalogQueryParameters.includeExtras,
      },
      options: _options(languageCode),
    );
    return MonumentSearchResponseDto.fromJson(_body(response));
  }

  @override
  Future<MonumentPinPageDto> fetchMonumentPins({
    required List<String> ids,
    required String languageCode,
  }) async {
    final unique = (ids.toSet().toList()..sort()).take(
      CatalogQueryParameters.maxIds,
    );
    final response = await _dio.get<Map<String, dynamic>>(
      CatalogEndpoints.monuments,
      queryParameters: {
        CatalogQueryParameters.keys: unique.join(','),
        CatalogQueryParameters.view: CatalogQueryParameters.viewLocation,
        CatalogQueryParameters.limit: unique.length,
      },
      options: _options(languageCode),
    );
    return MonumentPinPageDto.fromJson(_body(response));
  }

  @override
  Future<List<MapTileItemDto>> fetchMapTile({
    required TileId tile,
    required MonumentSearchQuery query,
    required String version,
    required String languageCode,
  }) async {
    final json = await fetchMapTileJson(
      tile: tile,
      query: query,
      version: version,
      languageCode: languageCode,
    );
    return MapTileResponseDto.fromJson(json).items;
  }

  @override
  Future<Map<String, dynamic>> fetchMapTileJson({
    required TileId tile,
    required MonumentSearchQuery query,
    required String version,
    required String languageCode,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      CatalogEndpoints.mapTile(tile),
      queryParameters: {
        ...CatalogQueryParameters.of(query),
        CatalogQueryParameters.version: version,
      },
      options: _options(languageCode),
    );
    return _body(response);
  }

  @override
  Future<MapExtentDto> fetchMapExtent({
    required MonumentSearchQuery query,
    required String languageCode,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      CatalogEndpoints.mapExtent,
      queryParameters: CatalogQueryParameters.of(query),
      options: _options(languageCode),
    );
    return MapExtentDto.fromJson(_body(response));
  }

  @override
  Future<ComplexDetailDto> fetchComplexDetail({
    required String id,
    required String languageCode,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      CatalogEndpoints.complex(id),
      options: _options(languageCode),
    );
    return ComplexDetailDto.fromJson(_body(response));
  }

  @override
  Future<ComplexMembersPageDto> fetchComplexMembers({
    required String id,
    required String languageCode,
    required int limit,
    String? cursor,
    Set<MonumentCategory> categories = const {},
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      CatalogEndpoints.complexMonuments(id),
      queryParameters: {
        if (categories.isNotEmpty)
          CatalogQueryParameters.category:
              (categories.map((c) => c.name).toList()..sort()).join(','),
        CatalogQueryParameters.limit: limit,
        CatalogQueryParameters.cursor: ?cursor,
      },
      options: _options(languageCode),
    );
    return ComplexMembersPageDto.fromJson(_body(response));
  }

  /// Katalog herkese açıktır (`guest`): Bearer anahtarı gönderilmez, böylece
  /// yanıtlar paylaşımlı önbelleklerde (CDN) de tutulabilir. İçerik dili
  /// arayüz dilinden açıkça verilir.
  static Options _options(String languageCode) => Options(
    extra: {RequestExtras.skipAuth: true},
    headers: {NetworkConstants.acceptLanguageHeader: languageCode},
  );

  static Map<String, dynamic> _body(Response<Map<String, dynamic>> response) =>
      response.data ?? (throw const UnexpectedException('empty_body'));
}

/// Katalog tek bir koleksiyon kaynağıdır: liste, arama, filtre ve harita
/// konumları `GET catalog/works` üzerinde sorgu parametreleriyle, detay
/// `GET catalog/works/{key}` ile alınır (sunucuda eser = "work"; kimlik
/// eserin `key`'idir). Külliyeler ayrı kayıtlardır: `catalog/complexes/**`
/// (detay + yapı alt koleksiyonu `…/works`).
abstract final class CatalogEndpoints {
  static const String monuments = 'catalog/works';
  static const String complexes = 'catalog/complexes';

  /// Harita: sunucu kümeli XYZ karoları ve sorgu kapsamı.
  static const String mapTiles = 'catalog/map/tiles';
  static const String mapExtent = 'catalog/map/extent';

  static String mapTile(TileId tile) =>
      '$mapTiles/${tile.z}/${tile.x}/${tile.y}';

  static String monument(String id) => '$monuments/${Uri.encodeComponent(id)}';

  static String complex(String id) => '$complexes/${Uri.encodeComponent(id)}';

  static String complexMonuments(String id) => '${complex(id)}/works';
}

/// `GET catalog/works` sorgu parametreleri.
///
/// Çoklu seçimler virgülle ayrılır (`category=mosque,inn`); boş ölçüt
/// gönderilmez. Değerler sıralanır: aynı sorgu aynı URL'i üretir (CDN
/// önbelleği).
abstract final class CatalogQueryParameters {
  static const String text = 'q';
  static const String category = 'category';
  static const String period = 'period';
  static const String city = 'city';
  static const String cursor = 'cursor';
  static const String limit = 'limit';

  /// Temsil: `summary` (liste satırı, varsayılan) veya `location` (harita).
  static const String view = 'view';
  static const String viewSummary = 'summary';
  static const String viewLocation = 'location';

  /// İlk sayfaya eklenecek ek bloklar (virgülle): `facets`, `places`.
  static const String include = 'include';
  static const String includeExtras = 'facets,places';

  /// Yalnızca bu anahtarlardaki eserler (virgülle; rota durakları).
  static const String keys = 'keys';
  static const int maxIds = 50;

  /// `güney,batı,kuzey,doğu` alan filtresi.
  static const String bbox = 'bbox';

  /// Katalog sürümü (karo önbellek anahtarı).
  static const String version = 'v';

  static String formatBounds(GeoBounds bounds) =>
      '${bounds.south},${bounds.west},${bounds.north},${bounds.east}';

  static Map<String, Object> of(MonumentSearchQuery query) {
    final filter = query.filter;
    String joined(Iterable<String> values) =>
        (values.toList()..sort()).join(',');
    return {
      if (query.normalizedText.isNotEmpty) text: query.normalizedText,
      if (filter.categories.isNotEmpty)
        category: joined(filter.categories.map((c) => c.name)),
      if (filter.periods.isNotEmpty)
        period: joined(filter.periods.map((p) => p.name)),
      if (filter.cities.isNotEmpty)
        city: joined(filter.cities.map((code) => '$code')),
    };
  }
}
