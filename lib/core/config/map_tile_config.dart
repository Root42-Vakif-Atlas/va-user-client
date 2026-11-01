import 'package:flutter/foundation.dart';

/// Harita altlığı (raster tile) kaynağı.
///
/// URL şablonları `{z}`, `{x}`, `{y}` ve isteğe bağlı olarak yüksek
/// yoğunluklu ekranlar için `{r}` (`@2x`) yer tutucularını içerir.
@immutable
final class MapTileConfig {
  const MapTileConfig({
    required this.lightUrlTemplate,
    required this.attribution,
    this.darkUrlTemplate,
  });

  /// dev / staging varsayılanı: OpenStreetMap standart altlığı.
  ///
  /// OSM tile kullanım politikası düşük hacimli geliştirme kullanımına,
  /// uygulamayı tanımlayan `User-Agent` ve görünür atıf koşuluyla izin verir;
  /// yoğun (yayındaki uygulama) kullanım yasaktır. Bu yüzden prod'da kurumun
  /// kendi tile sunucusu zorunludur (`MAP_TILE_*`). CARTO altlıkları artık
  /// API anahtarı gerektirdiğinden varsayılan olarak kullanılmaz; anahtar
  /// alındığında yalnızca `config/<env>.json` güncellenir.
  static const MapTileConfig openStreetMap = MapTileConfig(
    lightUrlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    attribution: '© OpenStreetMap contributors',
  );

  /// Açık ve açık-yüksek kontrast temalarda kullanılan altlık.
  final String lightUrlTemplate;

  /// Koyu temalar için ayrı stil. `null` → açık altlık, tema renklerinden
  /// üretilen koyu tonlu filtreyle gösterilir.
  final String? darkUrlTemplate;

  /// Haritada sürekli görünür olması lisans gereği zorunlu atıf metni
  /// (OpenStreetMap ODbL).
  final String attribution;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MapTileConfig &&
          other.lightUrlTemplate == lightUrlTemplate &&
          other.darkUrlTemplate == darkUrlTemplate &&
          other.attribution == attribution;

  @override
  int get hashCode =>
      Object.hash(lightUrlTemplate, darkUrlTemplate, attribution);
}
