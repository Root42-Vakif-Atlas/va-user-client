import 'package:injectable/injectable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vakif_atlas/core/storage/cache_store.dart';
import 'package:vakif_atlas/core/map/map_tiles.dart';
import 'package:vakif_atlas/features/catalog/data/dtos/map_tile_dtos.dart';
import 'package:vakif_atlas/features/catalog/data/dtos/monument_dtos.dart';

/// Katalog yanıtlarının süreli yerel önbelleği (TRD §10.B).
///
/// Anahtarlar içerik diline göre ayrışır. Bozuk veya eski şemadaki kayıt
/// okunduğunda silinir ve önbellek ıskası (`null`) olarak ele alınır.
/// `CacheStore` kaynaklı `CacheException` çağırana iletilir.
abstract interface class CatalogLocalDataSource {
  Future<MonumentDetailDto?> readMonumentDetail(String id, String languageCode);

  Future<void> saveMonumentDetail(
    String languageCode,
    MonumentDetailDto monument,
  );

  /// Varsayılan haritanın (arama / filtre yok) bir karosunun ham yanıtı.
  /// Karo içeriği katalog sürümüyle değişmezdir.
  Future<Map<String, dynamic>?> readMapTile({
    required String version,
    required String languageCode,
    required TileId tile,
  });

  Future<void> saveMapTile({
    required String version,
    required String languageCode,
    required TileId tile,
    required Map<String, dynamic> json,
  });

  /// Varsayılan haritanın son bilinen kapsamı ve katalog sürümü: ağ yokken
  /// harita yerel karolarla açılır.
  Future<MapExtentDto?> readMapExtent(String languageCode);

  Future<void> saveMapExtent(String languageCode, MapExtentDto extent);

  /// [keepVersion] dışındaki sürümlerin karolarını siler (yeni katalog
  /// sürümü yayımlandı; eski karolar artık okunmaz).
  Future<void> pruneMapTiles({required String keepVersion});
}

@LazySingleton(as: CatalogLocalDataSource)
class CatalogLocalDataSourceImpl implements CatalogLocalDataSource {
  CatalogLocalDataSourceImpl(this._cache);

  /// Katalog verisi VGM yönetim panelinden seyrek güncellenir; eser
  /// önizlemesi ve detayı bu süre boyunca ağa gitmeden açılır.
  static const Duration ttl = Duration(hours: 6);

  final CacheStore _cache;

  /// Şema sürümü: yanıt yeni alan aldığında (v2: külliye üyeliği; v3:
  /// `catalog/works` biçimi) eski kayıtlar okunmaz, süreleri dolunca silinir.
  static String _detailKey(String id, String languageCode) =>
      'catalog.monument.v3.$languageCode.$id';

  /// Karo içeriği sürüme bağlı ve değişmezdir; süre yalnızca uzun süre
  /// açılmayan uygulamada eski kayıtların bir gün silinmesi içindir.
  static const Duration mapTileTtl = Duration(days: 30);

  static const String _tilePrefix = 'catalog.tile.v1.';

  static String _tileKey(String version, String languageCode, TileId tile) =>
      '$_tilePrefix$version.$languageCode.$tile';

  static String _extentKey(String languageCode) =>
      'catalog.extent.v1.$languageCode';

  @override
  Future<MonumentDetailDto?> readMonumentDetail(
    String id,
    String languageCode,
  ) {
    return _read(_detailKey(id, languageCode), MonumentDetailDto.fromJson);
  }

  @override
  Future<void> saveMonumentDetail(
    String languageCode,
    MonumentDetailDto monument,
  ) {
    return _cache.put(
      _detailKey(monument.key, languageCode),
      monument.toJson(),
      ttl: ttl,
    );
  }

  @override
  Future<Map<String, dynamic>?> readMapTile({
    required String version,
    required String languageCode,
    required TileId tile,
  }) async {
    final key = _tileKey(version, languageCode, tile);
    final value = await _cache.get(key);
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value != null) {
      await _cache.remove(key);
    }
    return null;
  }

  @override
  Future<void> saveMapTile({
    required String version,
    required String languageCode,
    required TileId tile,
    required Map<String, dynamic> json,
  }) =>
      _cache.put(_tileKey(version, languageCode, tile), json, ttl: mapTileTtl);

  @override
  Future<MapExtentDto?> readMapExtent(String languageCode) =>
      _read(_extentKey(languageCode), MapExtentDto.fromJson);

  @override
  Future<void> saveMapExtent(String languageCode, MapExtentDto extent) =>
      _cache.put(_extentKey(languageCode), extent.toJson(), ttl: mapTileTtl);

  @override
  Future<void> pruneMapTiles({required String keepVersion}) {
    final keep = '$_tilePrefix$keepVersion.';
    return _cache.removeWhere(
      (key) => key.startsWith(_tilePrefix) && !key.startsWith(keep),
    );
  }

  Future<T?> _read<T>(
    String key,
    T Function(Map<String, dynamic> json) parse,
  ) async {
    final value = await _cache.get(key);
    if (value is! Map<String, dynamic>) {
      if (value != null) {
        await _cache.remove(key);
      }
      return null;
    }
    try {
      return parse(value);
    } on CheckedFromJsonException {
      await _cache.remove(key);
      return null;
    }
  }
}
