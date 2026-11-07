import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/map/map_tiles.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/geo_point.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/map_tile.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';
import 'package:vakif_atlas/features/catalog/domain/usecases/catalog_usecases.dart';

part 'monument_tiles_cubit.freezed.dart';
part 'monument_tiles_state.dart';

/// Haritanın görünür alanındaki sunucu kümeleri ve tekil eserler (ekran
/// bazlı, factory).
///
/// - Kamera durdukça ([viewportChanged]) görünür XYZ karoları paralel
///   istenir; aynı karo repository'nin bellek içi LRU'sundan gelir.
/// - Karo ve hücre sınırının iki yanına düşen, ekranda 48 dp'den yakın
///   öğeler birleştirilir (`MapTiles.declutter`).
/// - Külliye uzakta tek öğedir (birleşmede bir eser sayılır); yakın zum'da
///   ([MapTiles.complexExpandZoom]) yerleşim alanı `complexes`'e ayrılır,
///   üyeleri tekil pin olarak gelir.
/// - Geç gelen eski görünüm yanıtları nesil sayacıyla yok sayılır; hata
///   olursa son başarılı öğeler korunur.
/// - Katalog sürümü, sorgu (haritaya uygulanan arama) ve dil [configure]
///   ile verilir; sürüm bilinmeden istek yapılmaz.
@injectable
class MonumentTilesCubit extends Cubit<MonumentTilesState> {
  MonumentTilesCubit(this._getTile) : super(const MonumentTilesState());

  final GetMapTileUseCase _getTile;

  /// "Eserler yükleniyor" yalnızca yanıt bu süreden uzun sürerse gösterilir.
  /// Bellekten / cihazdan gelen karolar bundan önce biter: harita her
  /// kaydırmada gösterge yanıp sönmez ve ekran okuyucu (canlı bölge) her
  /// harekette "yükleniyor" demez.
  static const Duration loadingIndicatorDelay = Duration(milliseconds: 300);

  int _generation = 0;
  double? _zoom;
  GeoBounds? _bounds;

  /// Sorgu, dil veya katalog sürümü değişti: görünür alan yeniden istenir.
  Future<void> configure({
    required String version,
    required String languageCode,
    required MonumentSearchQuery query,
  }) async {
    if (version == state.version &&
        languageCode == state.languageCode &&
        query == state.query) {
      return;
    }
    emit(
      state.copyWith(
        version: version,
        languageCode: languageCode,
        query: query,
      ),
    );
    await _load();
  }

  /// Kamera durdu.
  Future<void> viewportChanged({
    required double zoom,
    required GeoBounds bounds,
  }) async {
    _zoom = zoom;
    _bounds = bounds;
    await _load();
  }

  /// Arka plan ön yüklemesinde aynı anda en çok bu kadar istek (ağ geçidinin
  /// hız sınırı: 20 istek/sn).
  static const int prefetchConcurrency = 4;

  Future<void> _load() async {
    final version = state.version;
    final zoom = _zoom;
    final bounds = _bounds;
    if (version == null || zoom == null || bounds == null) {
      return;
    }
    final generation = ++_generation;
    final level = MapTiles.requestLevel(zoom);
    Set<TileId> covering(int zoom, {int padding = 0}) => MapTiles.tilesCovering(
      south: bounds.south,
      west: bounds.west,
      north: bounds.north,
      east: bounds.east,
      zoom: zoom,
      padding: padding,
    );
    final tiles = covering(level);
    if (state.failure != null) {
      emit(state.copyWith(failure: null));
    }
    final indicator = Timer(loadingIndicatorDelay, () {
      if (!isClosed && generation == _generation && !state.isLoading) {
        emit(state.copyWith(isLoading: true));
      }
    });
    final List<Result<List<MapTileItem>>> results;
    try {
      results = await Future.wait([
        for (final tile in tiles) _fetch(tile, version),
      ]);
    } on Object {
      // Beklenmeyen hata (ör. ayrıştırma `TypeError`): gösterge takılı
      // kalmaz, son başarılı öğeler korunur.
      if (!isClosed && generation == _generation) {
        emit(
          state.copyWith(isLoading: false, failure: const UnexpectedFailure()),
        );
      }
      return;
    } finally {
      indicator.cancel();
    }
    if (isClosed || generation != _generation) {
      return;
    }
    final items = <MapTileItem>[];
    Failure? failure;
    for (final result in results) {
      result.fold((f) => failure ??= f, items.addAll);
    }
    if (failure != null) {
      emit(state.copyWith(isLoading: false, failure: failure));
      return;
    }
    // Yakın zum'da külliye bir alan + etikettir; üyeleriyle birleşmez.
    final expanded = level >= MapTiles.complexExpandZoom;
    final complexes = expanded
        ? items.whereType<MapTileComplex>().toList()
        : const <MapTileComplex>[];
    if (expanded) {
      items.removeWhere((item) => item is MapTileComplex);
    }
    emit(
      state.copyWith(
        isLoading: false,
        complexes: complexes,
        items: MapTiles.declutter(
          items,
          zoom: zoom,
          position: (item) => (item.location.latitude, item.location.longitude),
          merge: _merge,
        ),
      ),
    );
    // Görünür alan çizildikten sonra çevresi ve bir uzaklaşma seviyesi
    // arka planda önbelleğe alınır: küçük kaydırma ve uzaklaştırma ağ
    // beklemeden gelir. Gösterge ve durum değişmez.
    final outer = MapTiles.requestLevel(zoom - 1);
    unawaited(
      _prefetch(
        [
          ...covering(level, padding: 1).difference(tiles),
          if (outer != level) ...covering(outer),
        ],
        version: version,
        generation: generation,
      ),
    );
  }

  Future<Result<List<MapTileItem>>> _fetch(TileId tile, String version) =>
      _getTile(
        GetMapTileParams(
          tile: tile,
          query: state.query,
          version: version,
          languageCode: state.languageCode,
        ),
      );

  /// Sonuçlar repository önbelleğine girer; burada kullanılmaz. Kamera
  /// başka bir yere gidince (yeni nesil) kalan istekler başlatılmaz.
  Future<void> _prefetch(
    List<TileId> tiles, {
    required String version,
    required int generation,
  }) async {
    final queue = [...tiles];
    Future<void> worker() async {
      while (queue.isNotEmpty && !isClosed && generation == _generation) {
        final tile = queue.removeLast();
        try {
          await _fetch(tile, version);
        } on Object {
          // Ön yükleme en iyi çabadır; hata görünür yüklemede ele alınır.
        }
      }
    }

    await Future.wait([for (var i = 0; i < prefetchConcurrency; i++) worker()]);
  }

  /// Birleşen öğeler tek kümeye indirgenir: sayılar toplanır, merkez
  /// ağırlıklı ortalama, sınırlar birleşir.
  static MapTileItem _merge(List<MapTileItem> group) {
    var count = 0;
    var lat = 0.0;
    var lng = 0.0;
    GeoBounds? bounds;
    for (final item in group) {
      final (itemCount, itemBounds) = switch (item) {
        MapTileCluster(:final count, :final bounds) => (count, bounds),
        MapTileMonument(:final location) || MapTileComplex(:final location) => (
          1,
          GeoBounds(
            south: location.latitude,
            west: location.longitude,
            north: location.latitude,
            east: location.longitude,
          ),
        ),
      };
      count += itemCount;
      lat += item.location.latitude * itemCount;
      lng += item.location.longitude * itemCount;
      bounds = bounds?.union(itemBounds) ?? itemBounds;
    }
    final first = group.first;
    return MapTileCluster(
      key: switch (first) {
        MapTileCluster(:final key) => key,
        MapTileMonument(:final pin) ||
        MapTileComplex(:final pin) => 'merged_${pin.id}',
      },
      count: count,
      location: GeoPoint(latitude: lat / count, longitude: lng / count),
      bounds: bounds!,
    );
  }
}
