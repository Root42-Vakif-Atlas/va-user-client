import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:vakif_atlas/core/config/map_tile_config.dart';
import 'package:vakif_atlas/core/map/tile_http_client.dart';
import 'package:vakif_atlas/core/observability/app_logger.dart';

/// Tek bir karonun görüntüsünü getirir; ulaşılamazsa `null`.
typedef MapTileFetcher = Future<Uint8List?> Function(String url);

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
    MapTileFetcher? tileFetcher,
    this._logger,
  }) : _providerFactory = providerFactory ?? _networkProvider {
    _tileFetcher = tileFetcher ?? _fetchCachedTile;
  }

  /// Disk önbelleği üst sınırı; tile'lar sunucunun HTTP önbellek
  /// başlıklarına göre tazelenir.
  static const int maxCacheBytes = 200 * 1000 * 1000;

  /// Karonun kenarı (mantıksal piksel); retina karolar bunun iki katıdır.
  static const int tileSize = 256;

  final MapTileConfig _config;
  final TileProvider Function() _providerFactory;
  late final MapTileFetcher _tileFetcher;
  final AppLogger? _logger;

  /// Önbellek okuması takılırsa (açılamayan disk önbelleği) ağa geçilir.
  static const Duration _cacheReadTimeout = Duration(seconds: 2);

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

  /// Sunucu `{r}` (@2x) yer tutucusunu destekliyorsa yüksek yoğunluklu
  /// ekranlarda gerçek retina tile istenir. Desteklemiyorsa (OSM) harita yine
  /// keskin çizilir, ancak bir üst yakınlaştırma seviyesinin tile'ları
  /// istenir (görünür alan başına yaklaşık 4× tile); bu yüzden prod'da `{r}`
  /// destekleyen kurum tile sunucusu önerilir (ADR 17).
  bool supportsRetina(Brightness brightness) =>
      urlTemplateFor(brightness).contains('{r}');

  /// Her `TileLayer` kendi sağlayıcısını kapatır (`dispose`); bu yüzden her
  /// harita örneği yeni bir sağlayıcı alır. Disk önbelleği paylaşılır.
  TileProvider createTileProvider() => _providerFactory();

  /// Harita dışında (rota PDF'inin altlığı) kullanılan açık altlık karosu;
  /// sunucu destekliyorsa retina (`{r}` → `@2x`, kenar 2 × [tileSize]).
  /// Önce haritanın disk önbelleğine bakılır. Ulaşılamazsa `null`.
  Future<Uint8List?> fetchTile({
    required int zoom,
    required int x,
    required int y,
  }) => _tileFetcher(
    _config.lightUrlTemplate
        .replaceAll('{z}', '$zoom')
        .replaceAll('{x}', '$x')
        .replaceAll('{y}', '$y')
        .replaceAll('{r}', '@2x'),
  );

  /// [fetchTile]'ın döndürdüğü karonun piksel kenarı.
  int get fetchedTilePixels =>
      supportsRetina(Brightness.light) ? 2 * tileSize : tileSize;

  /// Zaman aşımı + yeniden deneme ([TileHttpClient]); başarısız karolar
  /// `AppMap`'te ayrıca yeniden yüklenir.
  ///
  /// `abortObsoleteRequests: false`: hızlı kaydırmada iptal edilen karonun
  /// saydam (boş) görüntüsü görüntü önbelleğine girip geri dönüldüğünde gri
  /// kalabiliyordu. İstek tamamlanır ve disk önbelleğini doldurur; geri
  /// kaydırınca karo ağa gitmeden gelir.
  static TileProvider _networkProvider() => NetworkTileProvider(
    httpClient: TileHttpClient(),
    cachingProvider: _cache,
    abortObsoleteRequests: false,
  );

  static MapCachingProvider get _cache =>
      BuiltInMapCachingProvider.getOrCreateInstance(
        maxCacheSize: maxCacheBytes,
      );

  late final Dio _tileDio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      responseType: ResponseType.bytes,
      // Tarayıcı `User-Agent`'ı değiştirmeye izin vermez (flutter_map gibi).
      headers: kIsWeb
          ? null
          : {'User-Agent': 'flutter_map ($userAgentPackageName)'},
    ),
  );

  /// Haritanın disk önbelleği (flutter_map) → ağ; ağdan geleni önbelleğe
  /// yazar. Tile sunucusu API değildir: kimlik bilgisi ve API başlıkları
  /// gönderilmez.
  Future<Uint8List?> _fetchCachedTile(String url) async {
    final cache = _cache;
    if (cache.isSupported) {
      try {
        final cached = await cache.getTile(url).timeout(_cacheReadTimeout);
        if (cached != null && !cached.metadata.isStale) {
          return cached.bytes;
        }
      } on Exception {
        // Bozuk veya yanıt vermeyen önbellek: ağdan alınır.
      }
    }
    try {
      final response = await _tileDio.get<List<int>>(url);
      final data = response.data;
      if (data == null || data.isEmpty) {
        return null;
      }
      final bytes = Uint8List.fromList(data);
      final headers = {
        for (final MapEntry(:key, :value) in response.headers.map.entries)
          key: value.join(','),
      };
      // `fromHttpHeaders` `max-age` ile birlikte `date` başlığını şart koşar.
      // Yazım beklenmez: önbellek en iyi çabadır, karoyu geciktirmez.
      if (cache.isSupported && headers.containsKey('date')) {
        unawaited(
          Future(
            () => cache.putTile(
              url: url,
              metadata: CachedMapTileMetadata.fromHttpHeaders(headers),
              bytes: bytes,
            ),
          ).catchError((Object _) {}),
        );
      }
      return bytes;
    } on DioException catch (error) {
      // Adres rotanın bölgesini gösterir; loglanmaz.
      _logger?.warning(
        'Map tile request failed',
        context: {
          'type': error.type.name,
          'status': error.response?.statusCode,
        },
      );
      return null;
    }
  }
}
