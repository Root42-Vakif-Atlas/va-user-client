import 'package:injectable/injectable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vakif_atlas/core/storage/cache_store.dart';
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
