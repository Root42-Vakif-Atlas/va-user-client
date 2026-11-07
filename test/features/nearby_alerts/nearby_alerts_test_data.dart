import 'package:vakif_atlas/features/catalog/domain/entities/complex.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/geo_point.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_classification.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_summary.dart';

/// Bursa Ulu Camii'nin konumu.
const GeoPoint ulucami = GeoPoint(latitude: 40.18393, longitude: 29.06191);

/// [origin]'den kuzeye [meters] metre.
GeoPoint northOf(GeoPoint origin, double meters) => GeoPoint(
  latitude: origin.latitude + meters / 111195,
  longitude: origin.longitude,
);

MonumentSummary testMonument({
  String id = 'bursa-ulu-camii',
  String name = 'Bursa Ulu Camii',
  GeoPoint? location = ulucami,
  String shortDescription =
      'Yıldırım Bayezid tarafından yaptırılan, yirmi kubbeli Osmanlı '
      'camisi.',
  String? thumbnailUrl = 'https://cdn.example/ulucami.jpg',
  ComplexRef? complex,
  int? memberCount,
}) => MonumentSummary(
  id: id,
  name: name,
  category: MonumentCategory.mosque,
  period: HistoricalPeriod.ottoman,
  city: 'Bursa',
  district: 'Osmangazi',
  address: 'Nalbantoğlu, Atatürk Cd.',
  location: location,
  shortDescription: shortDescription,
  thumbnailUrl: thumbnailUrl,
  complex: complex,
  memberCount: memberCount,
  cityCode: 16,
);
