part of 'map_discovery_bloc.dart';

enum MapDiscoveryStatus { initial, loading, success, failure }

enum SelectionStatus { none, loading, success, failure }

@freezed
abstract class MapDiscoveryState with _$MapDiscoveryState {
  const factory MapDiscoveryState({
    @Default(MapDiscoveryStatus.initial) MapDiscoveryStatus status,

    /// Uygulanan sorguya uyan eserlerin toplamı, sınırı ve katalog sürümü.
    MapExtent? extent,

    /// Haritaya uygulanmış arama sorgusu ve filtre.
    @Default(MonumentSearchQuery.empty) MonumentSearchQuery query,

    /// Sorgu kapsamı isteniyor.
    @Default(false) bool isRefining,

    /// Son daraltma isteğinin hatası (önceki daraltma korunur).
    Failure? refinementFailure,
    String? selectedId,

    /// Haritadaki pinden seçildiyse pin kaydı (önizleme gelmeden konum/ad).
    MonumentPin? selectedPin,

    /// Seçili eserin önizleme içeriği (eser detayından).
    MonumentDetail? selection,
    @Default(SelectionStatus.none) SelectionStatus selectionStatus,
    Failure? selectionFailure,

    /// Aynı konum kümesi listesi.
    @Default(SelectionStatus.none) SelectionStatus clusterStatus,
    @Default(<MonumentPin>[]) List<MonumentPin> clusterMonuments,
    Failure? failure,
  }) = _MapDiscoveryState;

  const MapDiscoveryState._();

  /// Seçili eserin konumu: detay geldiyse detaydan, yoksa pinden.
  GeoPoint? get selectedLocation =>
      selection?.location ?? selectedPin?.location;

  bool get isLoading => status == MapDiscoveryStatus.loading;

  /// Sorgu veya filtre etkinse `true`: harita tüm eserleri göstermiyor.
  bool get isRefined => !query.isEmpty;

  /// Haritadaki (uygulanan sorguya uyan) eser sayısı.
  int get total => extent?.total ?? 0;
}
