import 'package:vakif_atlas/features/catalog/domain/entities/complex.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/geo_point.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_classification.dart';

/// Harita ve listelerde gösterilen eser özeti.
final class MonumentSummary {
  const MonumentSummary({
    required this.id,
    required this.name,
    required this.category,
    required this.period,
    required this.city,
    required this.district,
    required this.address,
    required this.location,
    required this.shortDescription,
    this.thumbnailUrl,
    this.complex,
    this.memberCount,
    this.cityCode,
  });

  final String id;
  final String name;
  final MonumentCategory category;
  final HistoricalPeriod period;

  /// İl.
  final String city;

  /// İl plaka kodu (filtre: `city=16`).
  final int? cityCode;

  /// İlçe.
  final String district;

  /// Açık adres.
  final String address;

  /// Konum; VGM verisinden gelen eserde konum girilene kadar `null` —
  /// eser listede ve detayda görünür, haritada ve rotada yer almaz.
  final GeoPoint? location;
  final String shortDescription;
  final String? thumbnailUrl;

  /// Üyesi olduğu külliye; bağımsız eserde `null`.
  final ComplexRef? complex;

  /// Yalnızca külliye kayıtlarında dolu: üye yapı sayısı.
  final int? memberCount;

  /// Kayıt bir külliye mi (ayrı detay görünümü, haritada külliye işaretçisi)?
  bool get isComplex => memberCount != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonumentSummary &&
          other.id == id &&
          other.name == name &&
          other.category == category &&
          other.period == period &&
          other.city == city &&
          other.cityCode == cityCode &&
          other.district == district &&
          other.address == address &&
          other.location == location &&
          other.shortDescription == shortDescription &&
          other.thumbnailUrl == thumbnailUrl &&
          other.complex == complex &&
          other.memberCount == memberCount;

  @override
  int get hashCode => Object.hash(
    id,
    name,
    category,
    period,
    city,
    cityCode,
    district,
    address,
    location,
    shortDescription,
    thumbnailUrl,
    complex,
    memberCount,
  );

  @override
  String toString() => 'MonumentSummary($id)';
}
