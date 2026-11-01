import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vakif_atlas/features/catalog/data/dtos/map_tile_dtos.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/complex.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/geo_point.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_classification.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_detail.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_image.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_summary.dart';

part 'monument_dtos.freezed.dart';
part 'monument_dtos.g.dart';

@freezed
abstract class GeoPointDto with _$GeoPointDto {
  const factory GeoPointDto({
    required double latitude,
    required double longitude,
  }) = _GeoPointDto;

  const GeoPointDto._();

  factory GeoPointDto.fromJson(Map<String, dynamic> json) =>
      _$GeoPointDtoFromJson(json);

  GeoPoint toDomain() => GeoPoint(latitude: latitude, longitude: longitude);
}

@freezed
abstract class MonumentImageDto with _$MonumentImageDto {
  const factory MonumentImageDto({
    required String url,
    required String thumbnailUrl,
    required String author,
    required String license,
    required String sourceName,
    String? altText,
    String? sourceUrl,
    String? title,
  }) = _MonumentImageDto;

  const MonumentImageDto._();

  factory MonumentImageDto.fromJson(Map<String, dynamic> json) =>
      _$MonumentImageDtoFromJson(json);

  MonumentImage toDomain() => MonumentImage(
    url: url,
    thumbnailUrl: thumbnailUrl,
    altText: altText ?? '',
    author: author,
    license: license,
    sourceName: sourceName,
    sourceUrl: _readable(sourceUrl),
    title: title,
  );

  static final RegExp _invalidPercentEscape = RegExp('%(?![0-9A-Fa-f]{2})');

  /// Künyede gösterilen kaynak adresi yüzde kodlamasından arındırılır
  /// (`K%C4%B1zlara%C4%9Fas%C4%B1` → `Kızlarağası`); adres tarayıcıya
  /// kopyalandığında aynı sayfayı açar. Çözülemeyen adres olduğu gibi kalır.
  static String? _readable(String? url) {
    if (url == null || _invalidPercentEscape.hasMatch(url)) {
      return url;
    }
    try {
      return Uri.decodeFull(url);
    } on FormatException {
      return url;
    }
  }
}

/// İl: `{"code": 16, "name": "Bursa"}` (plaka kodu; ad istek dilinde).
@freezed
abstract class CityRefDto with _$CityRefDto {
  const factory CityRefDto({required int code, required String name}) =
      _CityRefDto;

  factory CityRefDto.fromJson(Map<String, dynamic> json) =>
      _$CityRefDtoFromJson(json);
}

/// Eserin üyesi olduğu külliye: `{"key", "name"}` (ad istek dilinde).
@freezed
abstract class ComplexRefDto with _$ComplexRefDto {
  const factory ComplexRefDto({required String key, required String name}) =
      _ComplexRefDto;

  const ComplexRefDto._();

  factory ComplexRefDto.fromJson(Map<String, dynamic> json) =>
      _$ComplexRefDtoFromJson(json);

  ComplexRef toDomain() => ComplexRef(id: key, name: name);
}

/// `GET catalog/works` (`view=summary`) listesindeki öğe. Kimlik `key`
/// (Türkçe URL anahtarı); `slug` istek dilindeki adres parçasıdır.
///
/// Bilinmeyen `category` / `period` değerleri `other` olarak okunur; sunucu
/// yeni bir tür eklediğinde eski istemciler çalışmaya devam eder.
@freezed
abstract class MonumentSummaryDto with _$MonumentSummaryDto {
  const factory MonumentSummaryDto({
    required String key,
    required String title,
    @JsonKey(unknownEnumValue: MonumentCategory.other)
    required MonumentCategory category,
    @JsonKey(unknownEnumValue: HistoricalPeriod.other)
    required HistoricalPeriod period,
    required CityRefDto city,
    String? slug,
    String? nickname,
    String? district,
    String? address,
    // VGM verisinden gelen eserde konum girilene kadar `null`.
    GeoPointDto? location,
    String? shortDescription,
    String? thumbnailUrl,
    ComplexRefDto? complex,
  }) = _MonumentSummaryDto;

  const MonumentSummaryDto._();

  factory MonumentSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$MonumentSummaryDtoFromJson(json);

  MonumentSummary toDomain() => MonumentSummary(
    id: key,
    name: title,
    category: category,
    period: period,
    city: city.name,
    cityCode: city.code,
    district: district ?? '',
    address: address ?? '',
    location: location?.toDomain(),
    shortDescription: shortDescription ?? '',
    thumbnailUrl: thumbnailUrl,
    complex: complex?.toDomain(),
  );
}

/// `GET catalog/works/{key}` yanıt gövdesi.
///
/// Uzun metin bölümlerdedir (`parts`); ayrı bir açıklama alanı yoktur,
/// [MonumentDetail.description] bölüm metinlerinin birleşimidir.
@freezed
abstract class MonumentDetailDto with _$MonumentDetailDto {
  const factory MonumentDetailDto({
    required String key,
    required String title,
    @JsonKey(unknownEnumValue: MonumentCategory.other)
    required MonumentCategory category,
    @JsonKey(unknownEnumValue: HistoricalPeriod.other)
    required HistoricalPeriod period,
    required CityRefDto city,
    String? slug,
    String? nickname,
    String? district,
    String? address,
    // VGM verisinden gelen eserde konum girilene kadar `null`.
    GeoPointDto? location,
    String? shortDescriptionTitle,
    String? shortDescription,
    String? history,
    String? constructionDate,
    String? founder,
    String? architect,
    @Default(false) bool isUnescoWorldHeritage,
    @Default(<MonumentImageDto>[]) List<MonumentImageDto> images,
    @Default(<MonumentPartDto>[]) List<MonumentPartDto> parts,
    ComplexRefDto? complex,
  }) = _MonumentDetailDto;

  const MonumentDetailDto._();

  factory MonumentDetailDto.fromJson(Map<String, dynamic> json) =>
      _$MonumentDetailDtoFromJson(json);

  MonumentDetail toDomain() => MonumentDetail(
    id: key,
    name: title,
    category: category,
    period: period,
    city: city.name,
    district: district ?? '',
    address: address ?? '',
    location: location?.toDomain(),
    shortDescription: shortDescription ?? '',
    description: [
      for (final part in parts)
        if (part.description?.trim() case final text? when text.isNotEmpty)
          text,
    ].join('\n\n'),
    history: history ?? '',
    constructionDate: constructionDate ?? '',
    founder: founder ?? '',
    architect: architect,
    isUnescoWorldHeritage: isUnescoWorldHeritage,
    images: [for (final image in images) image.toDomain()],
    complex: complex?.toDomain(),
    nickname: nickname,
    parts: [for (final part in parts) part.toDomain()],
  );
}

/// Eser bölümü (VGM verisi): `{title?, description, images}`.
@freezed
abstract class MonumentPartDto with _$MonumentPartDto {
  const factory MonumentPartDto({
    String? description,
    String? title,
    @Default(<MonumentImageDto>[]) List<MonumentImageDto> images,
  }) = _MonumentPartDto;

  const MonumentPartDto._();

  factory MonumentPartDto.fromJson(Map<String, dynamic> json) =>
      _$MonumentPartDtoFromJson(json);

  MonumentPart toDomain() => MonumentPart(
    title: title,
    description: description ?? '',
    images: [for (final image in images) image.toDomain()],
  );
}

/// `GET catalog/complexes/{key}/works` yanıt gövdesi (bir sayfa) ve
/// külliye detayındaki gömülü `works` bloğu.
@freezed
abstract class ComplexMembersPageDto with _$ComplexMembersPageDto {
  const factory ComplexMembersPageDto({
    required List<MonumentSummaryDto> items,
    @Default(0) int total,
    String? nextCursor,
  }) = _ComplexMembersPageDto;

  const ComplexMembersPageDto._();

  factory ComplexMembersPageDto.fromJson(Map<String, dynamic> json) =>
      _$ComplexMembersPageDtoFromJson(json);

  ComplexMemberResults toDomain() => ComplexMemberResults(
    items: [for (final item in items) item.toDomain()],
    total: total,
    nextCursor: nextCursor,
  );
}

/// `GET catalog/complexes/{key}` yanıt gövdesi: külliyenin kendi kaydı
/// (ad, il, ilçe, adres, konum, görseller), `workCount`, `footprint`
/// (`[[lat, lng], …]`), `bounds` ve yapıların ilk sayfası (`works`).
///
/// Külliye ayrı bir katalog kaydıdır (eser değildir); açıklama, tarihçe ve
/// künye alanı taşımaz.
@freezed
abstract class ComplexDetailDto with _$ComplexDetailDto {
  const factory ComplexDetailDto({
    required String key,
    required String name,
    required CityRefDto city,
    required int workCount,
    required ComplexMembersPageDto works,
    String? district,
    String? address,
    GeoPointDto? location,
    @Default(<MonumentImageDto>[]) List<MonumentImageDto> images,
    @JsonKey(fromJson: footprintFromJson)
    @Default(<List<double>>[])
    List<List<double>> footprint,
    List<double>? bounds,
  }) = _ComplexDetailDto;

  const ComplexDetailDto._();

  factory ComplexDetailDto.fromJson(Map<String, dynamic> json) =>
      _$ComplexDetailDtoFromJson(json);

  /// Külliyenin kendi kaydı, eser detayı biçiminde (harita önizlemesi ve
  /// `/monument/:id` → külliye yönlendirmesi bunu kullanır).
  MonumentDetail toMonumentDetail() => MonumentDetail(
    id: key,
    name: name,
    category: MonumentCategory.complex,
    period: HistoricalPeriod.other,
    city: city.name,
    district: district ?? '',
    address: address ?? '',
    location: location?.toDomain(),
    shortDescription: '',
    description: '',
    history: '',
    constructionDate: '',
    founder: '',
    images: [for (final image in images) image.toDomain()],
    memberCount: workCount,
  );

  ComplexDetail toDomain() => ComplexDetail(
    monument: toMonumentDetail(),
    memberCount: workCount,
    footprint: pointsFromJson(footprint),
    bounds: boundsFromJson(bounds),
    members: works.toDomain(),
  );
}
