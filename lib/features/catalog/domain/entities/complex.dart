import 'package:vakif_atlas/core/utils/list_equality.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/geo_point.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/map_tile.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_detail.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_summary.dart';

/// Bir eserin üyesi olduğu külliye (ad, istek dilinde).
final class ComplexRef {
  const ComplexRef({required this.id, required this.name});

  final String id;
  final String name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ComplexRef && other.id == id && other.name == name;

  @override
  int get hashCode => Object.hash(id, name);

  @override
  String toString() => 'ComplexRef($id)';
}

/// Külliye üyelerinin bir sayfası
/// (`GET catalog/complexes/{id}/monuments`), külliyedeki sırayla.
final class ComplexMemberResults {
  ComplexMemberResults({
    required List<MonumentSummary> items,
    required this.total,
    this.nextCursor,
  }) : items = List.unmodifiable(items);

  final List<MonumentSummary> items;

  /// Sorguya (kategori) uyan toplam üye sayısı.
  final int total;

  /// Sonraki sayfanın opak imleci; `null` → son sayfa.
  final String? nextCursor;

  bool get hasMore => nextCursor != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ComplexMemberResults &&
          other.total == total &&
          other.nextCursor == nextCursor &&
          elementsEqual(other.items, items);

  @override
  int get hashCode => Object.hash(total, nextCursor, Object.hashAll(items));
}

/// Külliye detay sayfasının içeriği (`GET catalog/complexes/{id}`):
/// külliyenin kendi katalog kaydı, yerleşimi ve üyelerinin ilk sayfası.
final class ComplexDetail {
  ComplexDetail({
    required this.monument,
    required this.memberCount,
    required List<GeoPoint> footprint,
    required this.members,
    this.bounds,
  }) : footprint = List.unmodifiable(footprint);

  /// Külliyenin kendi kaydı (ad, açıklama, görseller…).
  final MonumentDetail monument;

  final int memberCount;

  /// Yerleşim alanı (dış bükey çokgen, saat yönünün tersine); üye yoksa boş.
  final List<GeoPoint> footprint;

  /// Külliye ve üyelerinin sınırı.
  final GeoBounds? bounds;

  /// Üyelerin ilk sayfası.
  final ComplexMemberResults members;

  String get id => monument.id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ComplexDetail &&
          other.monument == monument &&
          other.memberCount == memberCount &&
          other.bounds == bounds &&
          other.members == members &&
          elementsEqual(other.footprint, footprint);

  @override
  int get hashCode => Object.hash(
    monument,
    memberCount,
    bounds,
    members,
    Object.hashAll(footprint),
  );

  @override
  String toString() => 'ComplexDetail(${monument.id})';
}
