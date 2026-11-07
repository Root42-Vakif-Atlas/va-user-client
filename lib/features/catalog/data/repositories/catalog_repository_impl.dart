import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/error_mapper.dart';
import 'package:vakif_atlas/core/error/exceptions.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/map/map_tiles.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vakif_atlas/features/catalog/data/dtos/map_tile_dtos.dart';
import 'package:vakif_atlas/features/catalog/data/sources/catalog_local_data_source.dart';
import 'package:vakif_atlas/features/catalog/data/sources/catalog_remote_data_source.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/complex.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/map_tile.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_classification.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_detail.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';
import 'package:vakif_atlas/features/catalog/domain/repositories/catalog_repository.dart';

/// Önce süresi dolmamış yerel önbellek, yoksa Catalog API.
///
/// Önbellek bir hızlandırıcıdır: okunamaması veya yazılamaması isteği
/// başarısız kılmaz.
@LazySingleton(as: CatalogRepository)
class CatalogRepositoryImpl implements CatalogRepository {
  CatalogRepositoryImpl(this._remote, this._local);

  final CatalogRemoteDataSource _remote;
  final CatalogLocalDataSource _local;

  /// Külliyeler eser değildir (`catalog/works/{key}` → 404): kimlik bir
  /// külliyeninse kaydı `catalog/complexes/{key}`'den eser detayı biçiminde
  /// döner ([MonumentDetail.isComplex]); harita önizlemesi ve derin
  /// bağlantı külliye görünümüne bununla geçer.
  @override
  ResultFuture<MonumentDetail> getMonumentDetail({
    required String id,
    required String languageCode,
  }) async {
    final cached = await _readCache(
      () => _local.readMonumentDetail(id, languageCode),
    );
    if (cached != null) {
      return Right(cached.toDomain());
    }
    try {
      final monument = await _remote.fetchMonumentDetail(
        id: id,
        languageCode: languageCode,
      );
      final entity = monument.toDomain();
      await _writeCache(
        () => _local.saveMonumentDetail(languageCode, monument),
      );
      return Right(entity);
    } on Exception catch (error) {
      final failure = ErrorMapper.toFailure(error);
      if (failure case ServerFailure(kind: ServerFailureKind.notFound)) {
        return _complexAsMonument(id, languageCode, failure);
      }
      return Left(failure);
    }
  }

  ResultFuture<MonumentDetail> _complexAsMonument(
    String id,
    String languageCode,
    Failure notFound,
  ) async {
    try {
      final complex = await _remote.fetchComplexDetail(
        id: id,
        languageCode: languageCode,
      );
      return Right(complex.toMonumentDetail());
    } on Exception catch (error) {
      final failure = ErrorMapper.toFailure(error);
      return Left(
        failure is ServerFailure && failure.kind == ServerFailureKind.notFound
            ? notFound
            : failure,
      );
    }
  }

  /// Arama sonuçları önbelleğe alınmaz (sorgu kombinasyonu sınırsızdır;
  /// HTTP önbelleği CDN'de yapılır).
  @override
  ResultFuture<MonumentSearchResults> searchMonuments({
    required MonumentSearchQuery query,
    required String languageCode,
    required int limit,
    String? cursor,
    GeoBounds? bounds,
  }) async {
    try {
      final page = await _remote.searchMonuments(
        query: query,
        languageCode: languageCode,
        limit: limit,
        cursor: cursor,
        includeExtras: cursor == null,
        bounds: bounds,
      );
      return Right(page.toDomain());
    } on Exception catch (error) {
      return Left(ErrorMapper.toFailure(error));
    }
  }

  /// Oturum boyunca bellekte tutulan en fazla karo (~birkaç ekranlık gezinti).
  static const int tileCacheCapacity = 300;

  /// En son kullanılan sona taşınır (LRU).
  final Map<String, List<MapTileItem>> _tiles = <String, List<MapTileItem>>{};

  @override
  ResultFuture<List<MapTileItem>> getMapTile({
    required TileId tile,
    required MonumentSearchQuery query,
    required String version,
    required String languageCode,
  }) async {
    final key =
        '$languageCode|$version|$tile|${CatalogQueryParameters.of(query)}';
    final cached = _tiles.remove(key);
    if (cached != null) {
      _tiles[key] = cached;
      return Right(cached);
    }
    // Varsayılan harita (arama / filtre yok) karoları cihazda kalıcıdır:
    // içerik katalog sürümüyle değişmez, uygulama yeniden açıldığında ve
    // çevrimdışıyken ağa gitmeden çizilir. Arama sonuçlarının karoları
    // (sınırsız kombinasyon) yalnızca bellektedir.
    final persistent = query.isEmpty;
    if (persistent) {
      final stored = await _readCache(
        () => _local.readMapTile(
          version: version,
          languageCode: languageCode,
          tile: tile,
        ),
      );
      final entities = stored == null ? null : _parseTile(stored);
      if (entities != null) {
        _remember(key, entities);
        return Right(entities);
      }
    }
    try {
      final json = await _remote.fetchMapTileJson(
        tile: tile,
        query: query,
        version: version,
        languageCode: languageCode,
      );
      final entities = _parseTile(json);
      if (entities == null) {
        throw const UnexpectedException('catalog.tile.decode');
      }
      _remember(key, entities);
      if (persistent) {
        await _writeCache(
          () => _local.saveMapTile(
            version: version,
            languageCode: languageCode,
            tile: tile,
            json: json,
          ),
        );
      }
      return Right(entities);
    } on Exception catch (error) {
      return Left(ErrorMapper.toFailure(error));
    }
  }

  void _remember(String key, List<MapTileItem> entities) {
    _tiles[key] = entities;
    if (_tiles.length > tileCacheCapacity) {
      _tiles.remove(_tiles.keys.first);
    }
  }

  /// Bozuk / eski şemadaki yanıtta `null` (yerel kayıt ıska sayılır).
  static List<MapTileItem>? _parseTile(Map<String, dynamic> json) {
    try {
      return List<MapTileItem>.unmodifiable(
        MapTileResponseDto.fromJson(json).items
            .map((item) => item.toDomain())
            .nonNulls,
      );
    } on CheckedFromJsonException {
      return null;
    }
  }

  @override
  ResultFuture<MapExtent> getMapExtent({
    required MonumentSearchQuery query,
    required String languageCode,
  }) async {
    try {
      final extent = await _remote.fetchMapExtent(
        query: query,
        languageCode: languageCode,
      );
      if (query.isEmpty) {
        await _writeCache(() => _local.saveMapExtent(languageCode, extent));
        // Yeni katalog sürümü: eski sürümün karoları artık okunmaz.
        await _writeCache(
          () => _local.pruneMapTiles(keepVersion: extent.version),
        );
      }
      return Right(extent.toDomain());
    } on Exception catch (error) {
      final failure = ErrorMapper.toFailure(error);
      // Ağ yokken varsayılan harita son bilinen sürümle yerel karolardan
      // açılır; arama kapsamı ağ gerektirir.
      if (query.isEmpty && failure is NetworkFailure) {
        final stored = await _readCache(
          () => _local.readMapExtent(languageCode),
        );
        if (stored != null) {
          return Right(stored.toDomain());
        }
      }
      return Left(failure);
    }
  }

  @override
  ResultFuture<List<MonumentPin>> getMonumentPins({
    required List<String> ids,
    required String languageCode,
  }) async {
    if (ids.isEmpty) {
      return const Right([]);
    }
    try {
      final response = await _remote.fetchMonumentPins(
        ids: ids,
        languageCode: languageCode,
      );
      return Right([for (final pin in response.items) pin.toDomain()]);
    } on Exception catch (error) {
      return Left(ErrorMapper.toFailure(error));
    }
  }

  /// Külliye yanıtları kalıcı önbelleğe alınmaz (üye listesi sayfalıdır;
  /// HTTP önbelleği CDN'de yapılır).
  @override
  ResultFuture<ComplexDetail> getComplexDetail({
    required String id,
    required String languageCode,
  }) async {
    try {
      final complex = await _remote.fetchComplexDetail(
        id: id,
        languageCode: languageCode,
      );
      return Right(complex.toDomain());
    } on Exception catch (error) {
      return Left(ErrorMapper.toFailure(error));
    }
  }

  @override
  ResultFuture<ComplexMemberResults> getComplexMembers({
    required String id,
    required String languageCode,
    required int limit,
    String? cursor,
    Set<MonumentCategory> categories = const {},
  }) async {
    try {
      final page = await _remote.fetchComplexMembers(
        id: id,
        languageCode: languageCode,
        limit: limit,
        cursor: cursor,
        categories: categories,
      );
      return Right(page.toDomain());
    } on Exception catch (error) {
      return Left(ErrorMapper.toFailure(error));
    }
  }

  static Future<T?> _readCache<T>(Future<T?> Function() read) async {
    try {
      return await read();
    } on CacheException {
      return null;
    }
  }

  static Future<void> _writeCache(Future<void> Function() write) async {
    try {
      await write();
    } on CacheException {
      // Önbelleğe yazılamaması kullanıcıya hata olarak yansıtılmaz.
    }
  }
}
