import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/usecase/usecase.dart';
import 'package:vakif_atlas/core/map/map_tiles.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/list_equality.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/complex.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/map_tile.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_classification.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_detail.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';
import 'package:vakif_atlas/features/catalog/domain/repositories/catalog_repository.dart';

final class GetMonumentDetailParams {
  const GetMonumentDetailParams({required this.id, required this.languageCode});

  final String id;
  final String languageCode;

  @override
  bool operator ==(Object other) =>
      other is GetMonumentDetailParams &&
      other.id == id &&
      other.languageCode == languageCode;

  @override
  int get hashCode => Object.hash(GetMonumentDetailParams, id, languageCode);
}

/// Eser detayını getirir. Boş veya geçersiz kimlik sunucuya gönderilmez.
class GetMonumentDetailUseCase
    implements UseCase<MonumentDetail, GetMonumentDetailParams> {
  const GetMonumentDetailUseCase(this._repository);

  final CatalogRepository _repository;

  @override
  ResultFuture<MonumentDetail> call(GetMonumentDetailParams params) async {
    final id = params.id.trim();
    if (id.isEmpty) {
      return const Left(
        ServerFailure(kind: ServerFailureKind.notFound, statusCode: 404),
      );
    }
    return _repository.getMonumentDetail(
      id: id,
      languageCode: params.languageCode,
    );
  }
}

final class SearchMonumentsParams {
  const SearchMonumentsParams({
    required this.query,
    required this.languageCode,
    this.cursor,
    this.limit = defaultPageSize,
    this.bounds,
  });

  /// Liste sayfası boyutu: telefonda ~2 ekran; kaydırma sonuna gelmeden
  /// sonraki sayfa istenir.
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;

  final MonumentSearchQuery query;
  final String languageCode;
  final String? cursor;
  final int limit;

  /// Yalnızca bu alandaki eserler (ör. aynı konumdaki küme listesi).
  final GeoBounds? bounds;

  @override
  bool operator ==(Object other) =>
      other is SearchMonumentsParams &&
      other.query == query &&
      other.languageCode == languageCode &&
      other.cursor == cursor &&
      other.limit == limit &&
      other.bounds == bounds;

  @override
  int get hashCode => Object.hash(
    SearchMonumentsParams,
    query,
    languageCode,
    cursor,
    limit,
    bounds,
  );
}

/// Sayfalı eser araması (sunucu tarafı, filtreler sorgu parametresidir).
///
/// Sayfa boyutu 1–[SearchMonumentsParams.maxPageSize] aralığına sıkıştırılır;
/// geçersiz konumlu kayıtlar listede kalır (liste haritaya bağlı değildir).
class SearchMonumentsUseCase
    implements UseCase<MonumentSearchResults, SearchMonumentsParams> {
  const SearchMonumentsUseCase(this._repository);

  final CatalogRepository _repository;

  @override
  ResultFuture<MonumentSearchResults> call(SearchMonumentsParams params) =>
      _repository.searchMonuments(
        query: params.query,
        languageCode: params.languageCode,
        cursor: params.cursor,
        limit: params.limit.clamp(1, SearchMonumentsParams.maxPageSize),
        bounds: params.bounds,
      );
}

final class GetMonumentPinsParams {
  const GetMonumentPinsParams({required this.ids, required this.languageCode});

  /// Rota duraklarının üst sınırının çok üstünde; tek istekte çözülür.
  static const int maxIds = 50;

  final List<String> ids;
  final String languageCode;

  @override
  bool operator ==(Object other) =>
      other is GetMonumentPinsParams &&
      elementsEqual(other.ids, ids) &&
      other.languageCode == languageCode;

  @override
  int get hashCode =>
      Object.hash(GetMonumentPinsParams, Object.hashAll(ids), languageCode);
}

/// Kimlikleri verilen eserlerin hafif kayıtları (rota durakları: ad, il,
/// konum). Boş, tekrarlı kimlikler ayıklanır; kimlik yoksa istek yapılmaz.
///
/// Konumu geçersiz (sonsuz / aralık dışı) kayıtlar elenir. Rota için eser
/// seçimi tüm kataloğu indirerek değil sunucu aramasıyla yapılır.
class GetMonumentPinsUseCase
    implements UseCase<List<MonumentPin>, GetMonumentPinsParams> {
  const GetMonumentPinsUseCase(this._repository);

  final CatalogRepository _repository;

  @override
  ResultFuture<List<MonumentPin>> call(GetMonumentPinsParams params) async {
    final ids = <String>{
      for (final id in params.ids)
        if (id.trim().isNotEmpty) id.trim(),
    }.take(GetMonumentPinsParams.maxIds).toList();
    if (ids.isEmpty) {
      return const Right([]);
    }
    final result = await _repository.getMonumentPins(
      ids: ids,
      languageCode: params.languageCode,
    );
    return result.map(
      // Konumsuz kayıt (VGM verisi) korunur: kaydedilenler ve anılar adını
      // gösterir; harita ve rota [MonumentPin.hasLocation]'a bakar.
      (pins) => List.unmodifiable(
        pins.where((pin) => pin.location == null || pin.location!.isValid),
      ),
    );
  }
}

final class GetMapTileParams {
  const GetMapTileParams({
    required this.tile,
    required this.version,
    required this.languageCode,
    this.query = MonumentSearchQuery.empty,
  });

  final TileId tile;
  final MonumentSearchQuery query;
  final String version;
  final String languageCode;

  @override
  bool operator ==(Object other) =>
      other is GetMapTileParams &&
      other.tile == tile &&
      other.query == query &&
      other.version == version &&
      other.languageCode == languageCode;

  @override
  int get hashCode =>
      Object.hash(GetMapTileParams, tile, query, version, languageCode);
}

/// Harita karosunun kümeleri ve tekil eserleri (sunucu kümelemesi).
/// Geçersiz konumlu tekil eserler elenir.
class GetMapTileUseCase
    implements UseCase<List<MapTileItem>, GetMapTileParams> {
  const GetMapTileUseCase(this._repository);

  final CatalogRepository _repository;

  @override
  ResultFuture<List<MapTileItem>> call(GetMapTileParams params) async {
    final result = await _repository.getMapTile(
      tile: params.tile,
      query: params.query,
      version: params.version,
      languageCode: params.languageCode,
    );
    return result.map(
      (items) => List.unmodifiable(items.where((i) => i.location.isValid)),
    );
  }
}

final class GetMapExtentParams {
  const GetMapExtentParams({
    required this.languageCode,
    this.query = MonumentSearchQuery.empty,
  });

  final MonumentSearchQuery query;
  final String languageCode;

  @override
  bool operator ==(Object other) =>
      other is GetMapExtentParams &&
      other.query == query &&
      other.languageCode == languageCode;

  @override
  int get hashCode => Object.hash(GetMapExtentParams, query, languageCode);
}

/// Sorguya uyan eser sayısı, kapsadığı alan ve katalog sürümü.
class GetMapExtentUseCase implements UseCase<MapExtent, GetMapExtentParams> {
  const GetMapExtentUseCase(this._repository);

  final CatalogRepository _repository;

  @override
  ResultFuture<MapExtent> call(GetMapExtentParams params) => _repository
      .getMapExtent(query: params.query, languageCode: params.languageCode);
}

/// Külliye detayını getirir. Boş kimlik sunucuya gönderilmez.
class GetComplexDetailUseCase
    implements UseCase<ComplexDetail, GetMonumentDetailParams> {
  const GetComplexDetailUseCase(this._repository);

  final CatalogRepository _repository;

  @override
  ResultFuture<ComplexDetail> call(GetMonumentDetailParams params) async {
    final id = params.id.trim();
    if (id.isEmpty) {
      return const Left(
        ServerFailure(kind: ServerFailureKind.notFound, statusCode: 404),
      );
    }
    return _repository.getComplexDetail(
      id: id,
      languageCode: params.languageCode,
    );
  }
}

final class GetComplexMembersParams {
  const GetComplexMembersParams({
    required this.complexId,
    required this.languageCode,
    this.cursor,
    this.limit = SearchMonumentsParams.defaultPageSize,
    this.categories = const {},
  });

  final String complexId;
  final String languageCode;
  final String? cursor;
  final int limit;

  /// Boş → tüm üyeler.
  final Set<MonumentCategory> categories;

  @override
  bool operator ==(Object other) =>
      other is GetComplexMembersParams &&
      other.complexId == complexId &&
      other.languageCode == languageCode &&
      other.cursor == cursor &&
      other.limit == limit &&
      other.categories.length == categories.length &&
      other.categories.containsAll(categories);

  @override
  int get hashCode => Object.hash(
    GetComplexMembersParams,
    complexId,
    languageCode,
    cursor,
    limit,
    Object.hashAllUnordered(categories),
  );
}

/// Külliye üyelerinin sayfası. Sayfa boyutu
/// 1–[SearchMonumentsParams.maxPageSize] aralığına sıkıştırılır; boş kimlik
/// sunucuya gönderilmez.
class GetComplexMembersUseCase
    implements UseCase<ComplexMemberResults, GetComplexMembersParams> {
  const GetComplexMembersUseCase(this._repository);

  final CatalogRepository _repository;

  @override
  ResultFuture<ComplexMemberResults> call(
    GetComplexMembersParams params,
  ) async {
    final id = params.complexId.trim();
    if (id.isEmpty) {
      return const Left(
        ServerFailure(kind: ServerFailureKind.notFound, statusCode: 404),
      );
    }
    return _repository.getComplexMembers(
      id: id,
      languageCode: params.languageCode,
      cursor: params.cursor,
      limit: params.limit.clamp(1, SearchMonumentsParams.maxPageSize),
      categories: params.categories,
    );
  }
}
