import 'package:vakif_atlas/core/utils/list_equality.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/complex.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/geo_point.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_classification.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_image.dart';

/// Eser detay sayfasının içeriği.
final class MonumentDetail {
  MonumentDetail({
    required this.id,
    required this.name,
    required this.category,
    required this.period,
    required this.city,
    required this.district,
    required this.address,
    required this.location,
    required this.shortDescription,
    required this.description,
    required this.history,
    required this.constructionDate,
    required this.founder,
    required List<MonumentImage> images,
    this.architect,
    this.isUnescoWorldHeritage = false,
    this.complex,
    this.memberCount,
    this.nickname,
    List<MonumentPart> parts = const [],
  }) : images = List.unmodifiable(images),
       parts = List.unmodifiable(parts);

  final String id;
  final String name;
  final MonumentCategory category;
  final HistoricalPeriod period;
  final String city;
  final String district;
  final String address;

  /// Konum; girilmemişse `null` (harita bölümü yerine bilgi notu).
  final GeoPoint? location;
  final String shortDescription;

  /// "Hakkında" bölümü.
  final String description;

  /// "Tarihçe" bölümü.
  final String history;

  /// Yapım tarihi metni (ör. `1550–1557`); kesin yıl bilinmeyen eserlerde
  /// dönem ifadesi içerebilir.
  final String constructionDate;

  /// Yaptıran (bani / vâkıf).
  final String founder;

  /// Bilinmiyorsa `null`.
  final String? architect;

  /// UNESCO Dünya Mirası Listesi'nde (bileşen olarak dahil) mi?
  final bool isUnescoWorldHeritage;

  /// Galeride gösterilen fotoğraflar; ilki kapak görselidir.
  final List<MonumentImage> images;

  /// Üyesi olduğu külliye; bağımsız eserde `null`.
  final ComplexRef? complex;

  /// Yalnızca külliye kayıtlarında dolu: üye yapı sayısı.
  final int? memberCount;

  /// Kayıt bir külliye mi? Külliyeler ayrı detay görünümünde açılır.
  /// Halk arasındaki adı (VGM verisi).
  final String? nickname;

  /// Bölümler (VGM verisi: ör. cami ve medrese kısımları), sırasıyla.
  final List<MonumentPart> parts;

  bool get isComplex => memberCount != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonumentDetail &&
          other.id == id &&
          other.name == name &&
          other.category == category &&
          other.period == period &&
          other.city == city &&
          other.district == district &&
          other.address == address &&
          other.location == location &&
          other.shortDescription == shortDescription &&
          other.description == description &&
          other.history == history &&
          other.constructionDate == constructionDate &&
          other.founder == founder &&
          other.architect == architect &&
          other.isUnescoWorldHeritage == isUnescoWorldHeritage &&
          other.complex == complex &&
          other.memberCount == memberCount &&
          other.nickname == nickname &&
          elementsEqual(other.parts, parts) &&
          elementsEqual(other.images, images);

  @override
  int get hashCode => Object.hash(
    id,
    name,
    category,
    period,
    city,
    district,
    address,
    location,
    shortDescription,
    description,
    history,
    constructionDate,
    founder,
    architect,
    isUnescoWorldHeritage,
    Object.hashAll(images),
    complex,
    memberCount,
    nickname,
    Object.hashAll(parts),
  );

  @override
  String toString() => 'MonumentDetail($id)';
}

/// Eser bölümü: isteğe bağlı başlık, metin ve bölüm görselleri.
final class MonumentPart {
  MonumentPart({
    required this.description,
    this.title,
    List<MonumentImage> images = const [],
  }) : images = List.unmodifiable(images);

  final String? title;
  final String description;
  final List<MonumentImage> images;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonumentPart &&
          other.title == title &&
          other.description == description &&
          elementsEqual(other.images, images);

  @override
  int get hashCode => Object.hash(title, description, Object.hashAll(images));
}
