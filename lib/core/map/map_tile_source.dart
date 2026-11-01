import 'dart:ui' show Brightness;

import 'package:flutter_map/flutter_map.dart';
import 'package:vakif_atlas/core/config/map_tile_config.dart';

/// Harita altlığının kaynağı: tema parlaklığına göre URL seçimi, lisans atfı
/// ve harita başına tile sağlayıcısı.
///
/// Altlık Flutter içinde çizildiğinden kökteki renk körlüğü filtresi
/// haritaya da uygulanır (ADR 4).
class MapTileSource {
  MapTileSource({
    required this._config,
    required this.userAgentPackageName,
    TileProvider Function()? providerFactory,
  }) : _providerFactory = providerFactory ?? _networkProvider;

  /// Disk önbelleği üst sınırı; tile'lar sunucunun HTTP önbellek
  /// başlıklarına göre tazelenir.
  static const int maxCacheBytes = 200 * 1000 * 1000;

  final MapTileConfig _config;
  final TileProvider Function() _providerFactory;

  /// Tile isteklerinin `User-Agent` başlığında uygulamayı tanımlar
  /// (OSM tabanlı sunucuların kullanım politikası).
  final String userAgentPackageName;

  String get attribution => _config.attribution;

  String urlTemplateFor(Brightness brightness) => switch (brightness) {
    Brightness.light => _config.lightUrlTemplate,
    Brightness.dark => _config.darkUrlTemplate ?? _config.lightUrlTemplate,
  };

  /// Sağlayıcı koyu stil sunmuyorsa koyu temalarda açık altlık tema
  /// renkleriyle koyulaştırılır (`duotoneTileFilter`).
  bool usesDarkFilter(Brightness brightness) =>
      brightness == Brightness.dark && _config.darkUrlTemplate == null;

  /// `{r}` yer tutucusu destekleyen sunuculardan yüksek yoğunluklu tile
  /// istenir. Desteklemeyenlerde retina benzetimi yapılmaz; bu, ek
  /// yakınlaştırma seviyesi isteğiyle tile sunucusunun yükünü artırırdı.
  bool supportsRetina(Brightness brightness) =>
      urlTemplateFor(brightness).contains('{r}');

  /// Her `TileLayer` kendi sağlayıcısını kapatır (`dispose`); bu yüzden her
  /// harita örneği yeni bir sağlayıcı alır. Disk önbelleği paylaşılır.
  TileProvider createTileProvider() => _providerFactory();

  static TileProvider _networkProvider() => NetworkTileProvider(
    cachingProvider: BuiltInMapCachingProvider.getOrCreateInstance(
      maxCacheSize: maxCacheBytes,
    ),
  );
}
