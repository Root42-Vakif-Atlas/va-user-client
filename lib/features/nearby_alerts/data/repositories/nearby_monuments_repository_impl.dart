import 'dart:math' as math;

import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/geo_point.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/map_tile.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_summary.dart';
import 'package:vakif_atlas/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:vakif_atlas/features/nearby_alerts/domain/repositories/nearby_alerts_repositories.dart';

/// Katalog aramasının sınır kutusu (`bbox`) ile ızgara hücresi sorgusu.
///
/// Konum [cellDegrees]'lik sabit bir ızgaraya oturtulur (~550 m × ~420 m,
/// Türkiye enlemlerinde); sunucu yalnızca hücreyi (+ yarıçap payı) görür,
/// kesin konumu görmez. Hücrenin herhangi bir noktasından yarıçap içindeki
/// tüm eserler pay sayesinde aynı yanıtta bulunur. Hücreler [cacheTtl]
/// boyunca bellekte tutulur; yürürken her ~500 m'de bir istek yapılır.
@LazySingleton(as: NearbyMonumentsRepository)
class NearbyMonumentsRepositoryImpl implements NearbyMonumentsRepository {
  NearbyMonumentsRepositoryImpl(this._catalog) : _clock = DateTime.now;

  NearbyMonumentsRepositoryImpl.withClock(this._catalog, this._clock);

  final CatalogRepository _catalog;
  final DateTime Function() _clock;

  static const double cellDegrees = 0.005;
  static const int pageSize = 50;

  /// Çok yoğun tarihi merkezlerde bile hücre başına en çok
  /// `pageSize × maxPages` eser.
  static const int maxPages = 4;
  static const Duration cacheTtl = Duration(hours: 1);
  static const int cacheCapacity = 24;

  /// Başarısız hücre bu süre boyunca yeniden istenmez (çevrimdışı yürürken
  /// her konumda istek yapılmaz).
  static const Duration failureBackoff = Duration(minutes: 1);

  static const double _metersPerDegreeLatitude = 111320;

  /// En son kullanılan sona taşınır (LRU).
  final Map<String, _Cell> _cells = {};

  @override
  ResultFuture<List<MonumentSummary>> monumentsAround(
    GeoPoint point, {
    required double radiusMeters,
    required String languageCode,
  }) async {
    final row = (point.latitude / cellDegrees).floor();
    final column = (point.longitude / cellDegrees).floor();
    final key = '$languageCode|${radiusMeters.round()}|$row|$column';
    final now = _clock();

    final cached = _cells.remove(key);
    if (cached != null) {
      _cells[key] = cached;
      final age = now.difference(cached.at);
      switch (cached.result) {
        case Right(:final value) when age < cacheTtl:
          return Right(value);
        case Left(:final value) when age < failureBackoff:
          return Left(value);
        case _:
          _cells.remove(key);
      }
    }

    final result = await _fetch(
      _bounds(row, column, radiusMeters),
      languageCode,
    );
    _cells[key] = _Cell(result, now);
    if (_cells.length > cacheCapacity) {
      _cells.remove(_cells.keys.first);
    }
    return result;
  }

  static GeoBounds _bounds(int row, int column, double radiusMeters) {
    final south = row * cellDegrees;
    final west = column * cellDegrees;
    final north = south + cellDegrees;
    final east = west + cellDegrees;
    final latitudeMargin = radiusMeters / _metersPerDegreeLatitude;
    // Boylam derecesi kutuplara doğru kısalır; hücrenin kutba yakın kenarı
    // ölçüt alınır.
    final edgeLatitude = math.max(south.abs(), north.abs()).clamp(0, 89);
    final longitudeMargin =
        radiusMeters /
        (_metersPerDegreeLatitude * math.cos(edgeLatitude * math.pi / 180));
    return GeoBounds(
      south: (south - latitudeMargin).clamp(-90, 90),
      west: (west - longitudeMargin).clamp(-180, 180),
      north: (north + latitudeMargin).clamp(-90, 90),
      east: (east + longitudeMargin).clamp(-180, 180),
    );
  }

  Future<Either<Failure, List<MonumentSummary>>> _fetch(
    GeoBounds bounds,
    String languageCode,
  ) async {
    final monuments = <MonumentSummary>[];
    String? cursor;
    for (var page = 0; page < maxPages; page++) {
      final result = await _catalog.searchMonuments(
        query: MonumentSearchQuery.empty,
        languageCode: languageCode,
        limit: pageSize,
        cursor: cursor,
        bounds: bounds,
      );
      switch (result) {
        case Left(:final value):
          return Left(value);
        case Right(:final value):
          monuments.addAll(value.items);
          cursor = value.nextCursor;
      }
      if (cursor == null) {
        break;
      }
    }
    return Right(List.unmodifiable(monuments));
  }
}

final class _Cell {
  const _Cell(this.result, this.at);

  final Either<Failure, List<MonumentSummary>> result;
  final DateTime at;
}
