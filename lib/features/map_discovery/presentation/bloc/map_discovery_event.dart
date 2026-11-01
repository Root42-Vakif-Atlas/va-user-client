part of 'map_discovery_bloc.dart';

@freezed
sealed class MapDiscoveryEvent with _$MapDiscoveryEvent {
  /// İlk yükleme, tekrar deneme ve dil değişimi.
  const factory MapDiscoveryEvent.loadRequested({
    required String languageCode,
  }) = MapDiscoveryLoadRequested;

  /// Pin, küme listesi, arama veya derin bağlantıdan eser seçimi. Haritadaki
  /// pinden geliyorsa [pin] verilir (konum ve ad hemen bilinir); önizleme
  /// eser detayından ayrıca istenir.
  const factory MapDiscoveryEvent.monumentSelected(
    String id, {
    MonumentPin? pin,
  }) = MapDiscoveryMonumentSelected;

  const factory MapDiscoveryEvent.selectionCleared() =
      MapDiscoverySelectionCleared;

  /// Önizleme yüklenemediyse yeniden ister.
  const factory MapDiscoveryEvent.selectionRetryRequested() =
      MapDiscoverySelectionRetryRequested;

  /// Arama ekranındaki sorgu + filtre haritaya uygulanır (karolar ve kapsam
  /// bu sorguyla istenir). Boş sorgu daraltmayı kaldırır.
  const factory MapDiscoveryEvent.refinementApplied(MonumentSearchQuery query) =
      MapDiscoveryRefinementApplied;

  /// Sorgu ve filtrelerin tamamını kaldırır.
  const factory MapDiscoveryEvent.refinementsCleared() =
      MapDiscoveryRefinementsCleared;

  /// Yakınlaştırmayla ayrışmayan (aynı konumdaki) kümenin eserleri istenir.
  const factory MapDiscoveryEvent.clusterOpened(GeoBounds bounds) =
      MapDiscoveryClusterOpened;
}
