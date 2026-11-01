import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vakif_atlas/features/catalog/data/dtos/map_tile_dtos.dart';
import 'package:vakif_atlas/features/catalog/data/dtos/monument_dtos.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_classification.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';

part 'monument_search_dtos.freezed.dart';
part 'monument_search_dtos.g.dart';

/// `GET catalog/works` (`view=summary`) yanıt gövdesi.
@freezed
abstract class MonumentSearchResponseDto with _$MonumentSearchResponseDto {
  const factory MonumentSearchResponseDto({
    required List<MonumentSummaryDto> items,
    required int total,
    String? nextCursor,
    @Default(<MonumentPlaceDto>[]) List<MonumentPlaceDto> places,
    MonumentFacetsDto? facets,
  }) = _MonumentSearchResponseDto;

  const MonumentSearchResponseDto._();

  factory MonumentSearchResponseDto.fromJson(Map<String, dynamic> json) =>
      _$MonumentSearchResponseDtoFromJson(json);

  MonumentSearchResults toDomain() => MonumentSearchResults(
    items: [for (final item in items) item.toDomain()],
    total: total,
    nextCursor: nextCursor,
    places: [for (final place in places) place.toDomain()],
    facets: facets?.toDomain() ?? MonumentFacets.empty,
  );
}

@freezed
abstract class MonumentPlaceDto with _$MonumentPlaceDto {
  const factory MonumentPlaceDto({
    required CityRefDto city,
    required int count,
    String? district,
    List<double>? bounds,
  }) = _MonumentPlaceDto;

  const MonumentPlaceDto._();

  factory MonumentPlaceDto.fromJson(Map<String, dynamic> json) =>
      _$MonumentPlaceDtoFromJson(json);

  MonumentPlace toDomain() => MonumentPlace(
    city: city.name,
    district: district,
    count: count,
    bounds: boundsFromJson(bounds),
  );
}

/// İl facet'i: `{"code": 16, "name": "Bursa", "count": 340}`.
@freezed
abstract class CityFacetDto with _$CityFacetDto {
  const factory CityFacetDto({
    required int code,
    required String name,
    required int count,
  }) = _CityFacetDto;

  factory CityFacetDto.fromJson(Map<String, dynamic> json) =>
      _$CityFacetDtoFromJson(json);
}

/// Filtre seçeneklerinin sayıları. Bilinmeyen tür/dönem değerleri `other`
/// altında toplanır.
@freezed
abstract class MonumentFacetsDto with _$MonumentFacetsDto {
  const factory MonumentFacetsDto({
    @Default(<String, int>{}) Map<String, int> category,
    @Default(<String, int>{}) Map<String, int> period,
    @Default(<CityFacetDto>[]) List<CityFacetDto> city,
  }) = _MonumentFacetsDto;

  const MonumentFacetsDto._();

  factory MonumentFacetsDto.fromJson(Map<String, dynamic> json) =>
      _$MonumentFacetsDtoFromJson(json);

  MonumentFacets toDomain() => MonumentFacets(
    categories: _byEnum(
      category,
      MonumentCategory.values,
      MonumentCategory.other,
    ),
    periods: _byEnum(period, HistoricalPeriod.values, HistoricalPeriod.other),
    cities: Map.unmodifiable({for (final c in city) c.code: c.count}),
    cityNames: Map.unmodifiable({for (final c in city) c.code: c.name}),
  );

  static Map<T, int> _byEnum<T extends Enum>(
    Map<String, int> raw,
    List<T> values,
    T fallback,
  ) {
    final result = <T, int>{};
    for (final MapEntry(:key, :value) in raw.entries) {
      final match = values.where((v) => v.name == key).firstOrNull ?? fallback;
      result.update(match, (count) => count + value, ifAbsent: () => value);
    }
    return Map.unmodifiable(result);
  }
}

/// `view=location` öğesi: harita ve rota planlayıcı için hafif kayıt.
@freezed
abstract class MonumentPinDto with _$MonumentPinDto {
  const factory MonumentPinDto({
    required String key,
    required String title,
    @JsonKey(unknownEnumValue: MonumentCategory.other)
    required MonumentCategory category,
    required CityRefDto city,
    String? slug,
    String? district,
    GeoPointDto? location,
    ComplexRefDto? complex,
  }) = _MonumentPinDto;

  const MonumentPinDto._();

  factory MonumentPinDto.fromJson(Map<String, dynamic> json) =>
      _$MonumentPinDtoFromJson(json);

  MonumentPin toDomain() => MonumentPin(
    id: key,
    name: title,
    category: category,
    city: city.name,
    district: district ?? '',
    location: location?.toDomain(),
    complex: complex?.toDomain(),
  );
}

/// `GET catalog/works?view=location` yanıt gövdesi (bir sayfa).
@freezed
abstract class MonumentPinPageDto with _$MonumentPinPageDto {
  const factory MonumentPinPageDto({
    required List<MonumentPinDto> items,
    @Default(0) int total,
    String? nextCursor,
  }) = _MonumentPinPageDto;

  factory MonumentPinPageDto.fromJson(Map<String, dynamic> json) =>
      _$MonumentPinPageDtoFromJson(json);
}
