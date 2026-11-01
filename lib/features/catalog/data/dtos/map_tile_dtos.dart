import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vakif_atlas/features/catalog/data/dtos/monument_dtos.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/geo_point.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/map_tile.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_classification.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';

part 'map_tile_dtos.freezed.dart';
part 'map_tile_dtos.g.dart';

/// `[güney, batı, kuzey, doğu]` dizisi.
GeoBounds? boundsFromJson(List<double>? values) =>
    values == null || values.length != 4
    ? null
    : GeoBounds(
        south: values[0],
        west: values[1],
        north: values[2],
        east: values[3],
      );

/// `[[lat, lng], …]` çokgen köşeleri; bozuk köşeler atlanır.
List<List<double>> footprintFromJson(Object? json) => [
  if (json is List)
    for (final point in json)
      if (point is List && point.length == 2)
        [(point[0] as num).toDouble(), (point[1] as num).toDouble()],
];

List<GeoPoint> pointsFromJson(List<List<double>> points) => [
  for (final point in points)
    if (point.length == 2) GeoPoint(latitude: point[0], longitude: point[1]),
];

/// `GET catalog/map/tiles/{z}/{x}/{y}` öğesi; `type` alanıyla ayrışır.
/// Sunucunun ileride ekleyeceği bilinmeyen türler yok sayılır.
@Freezed(unionKey: 'type', fallbackUnion: 'unknown')
sealed class MapTileItemDto with _$MapTileItemDto {
  const factory MapTileItemDto.cluster({
    required String key,
    required int count,
    required double lat,
    required double lng,
    required List<double> bounds,
  }) = MapTileClusterDto;

  /// Tekil eser (`"type": "work"`).
  @FreezedUnionValue('work')
  const factory MapTileItemDto.monument({
    required String key,
    required String title,
    @JsonKey(unknownEnumValue: MonumentCategory.other)
    required MonumentCategory category,
    required CityRefDto city,
    required double lat,
    required double lng,
    String? slug,
    String? district,
    ComplexRefDto? complex,
  }) = MapTileMonumentDto;

  /// Külliye; `footprint` yalnızca yakın zum karolarında gelir.
  const factory MapTileItemDto.complex({
    required String key,
    required String name,
    required CityRefDto city,
    required double lat,
    required double lng,
    required int workCount,
    String? district,
    @JsonKey(fromJson: footprintFromJson)
    @Default(<List<double>>[])
    List<List<double>> footprint,
  }) = MapTileComplexDto;

  const factory MapTileItemDto.unknown() = MapTileUnknownDto;

  const MapTileItemDto._();

  factory MapTileItemDto.fromJson(Map<String, dynamic> json) =>
      _$MapTileItemDtoFromJson(json);

  /// `null` → bilinmeyen tür veya bozuk sınır.
  MapTileItem? toDomain() => switch (this) {
    MapTileClusterDto(:final key, :final count, :final lat, :final lng) =>
      switch (boundsFromJson((this as MapTileClusterDto).bounds)) {
        final bounds? => MapTileCluster(
          key: key,
          count: count,
          location: GeoPoint(latitude: lat, longitude: lng),
          bounds: bounds,
        ),
        null => null,
      },
    MapTileMonumentDto(
      :final key,
      :final title,
      :final category,
      :final city,
      :final district,
      :final lat,
      :final lng,
      :final complex,
    ) =>
      MapTileMonument(
        MonumentPin(
          id: key,
          name: title,
          category: category,
          city: city.name,
          district: district ?? '',
          location: GeoPoint(latitude: lat, longitude: lng),
          complex: complex?.toDomain(),
        ),
      ),
    MapTileComplexDto(
      :final key,
      :final name,
      :final city,
      :final district,
      :final lat,
      :final lng,
      :final workCount,
      :final footprint,
    ) =>
      MapTileComplex(
        MonumentPin(
          id: key,
          name: name,
          category: MonumentCategory.complex,
          city: city.name,
          district: district ?? '',
          location: GeoPoint(latitude: lat, longitude: lng),
          memberCount: workCount,
        ),
        footprint: pointsFromJson(footprint),
      ),
    MapTileUnknownDto() => null,
  };
}

@freezed
abstract class MapTileResponseDto with _$MapTileResponseDto {
  const factory MapTileResponseDto({required List<MapTileItemDto> items}) =
      _MapTileResponseDto;

  factory MapTileResponseDto.fromJson(Map<String, dynamic> json) =>
      _$MapTileResponseDtoFromJson(json);
}

/// `GET catalog/map/extent` yanıt gövdesi.
@freezed
abstract class MapExtentDto with _$MapExtentDto {
  const factory MapExtentDto({
    required int total,
    required String version,
    List<double>? bounds,
  }) = _MapExtentDto;

  const MapExtentDto._();

  factory MapExtentDto.fromJson(Map<String, dynamic> json) =>
      _$MapExtentDtoFromJson(json);

  MapExtent toDomain() =>
      MapExtent(total: total, version: version, bounds: boundsFromJson(bounds));
}
