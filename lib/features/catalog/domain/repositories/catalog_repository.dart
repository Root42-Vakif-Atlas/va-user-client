import 'package:vakif_atlas/core/map/map_tiles.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/complex.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/map_tile.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_classification.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_detail.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';

/// VGM vakıf eserleri kataloğu (Catalog mikro servisi).
///
/// İçerik dili ([languageCode], ör. `tr`, `en`) açıkça verilir; böylece
/// arayüz dili değiştiği anda doğru dilde içerik istenir ve önbellek dile
/// göre ayrışır.
abstract interface class CatalogRepository {
  /// Sunucu tarafı, sayfalı eser araması. [cursor] `null` → ilk sayfa.
  ResultFuture<MonumentSearchResults> searchMonuments({
    required MonumentSearchQuery query,
    required String languageCode,
    required int limit,
    String? cursor,
    GeoBounds? bounds,
  });

  /// Bir harita karosunun sunucu kümeleri / tekil eserleri. Aynı karo +
  /// sorgu + sürüm + dil oturum boyunca bellekte tutulur.
  ResultFuture<List<MapTileItem>> getMapTile({
    required TileId tile,
    required MonumentSearchQuery query,
    required String version,
    required String languageCode,
  });

  /// Sorguya uyan eserlerin toplamı, sınırı ve katalog sürümü.
  ResultFuture<MapExtent> getMapExtent({
    required MonumentSearchQuery query,
    required String languageCode,
  });

  /// Kimlikleri verilen eserlerin hafif kayıtları, tek istekte
  /// (`view=location&ids=…`). Katalogdan kaldırılmış kimlikler yanıtta yer
  /// almaz. Tüm kataloğu indirmek için kullanılmaz; seçim aramayla yapılır.
  ResultFuture<List<MonumentPin>> getMonumentPins({
    required List<String> ids,
    required String languageCode,
  });

  /// Tek bir eserin detayı. Eser yoksa `ServerFailure(notFound)`.
  ResultFuture<MonumentDetail> getMonumentDetail({
    required String id,
    required String languageCode,
  });

  /// Külliye detayı: kendi kaydı, yerleşimi ve üyelerinin ilk sayfası
  /// (`GET catalog/complexes/{id}`). Kayıt yoksa veya külliye değilse
  /// `ServerFailure(notFound)`.
  ResultFuture<ComplexDetail> getComplexDetail({
    required String id,
    required String languageCode,
  });

  /// Külliye üyelerinin bir sayfası, külliyedeki sırayla
  /// (`GET catalog/complexes/{id}/monuments`). [categories] boş → tüm üyeler.
  ResultFuture<ComplexMemberResults> getComplexMembers({
    required String id,
    required String languageCode,
    required int limit,
    String? cursor,
    Set<MonumentCategory> categories = const {},
  });
}
