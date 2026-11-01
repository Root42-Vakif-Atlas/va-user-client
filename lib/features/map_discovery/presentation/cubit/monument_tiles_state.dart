part of 'monument_tiles_cubit.dart';

@freezed
abstract class MonumentTilesState with _$MonumentTilesState {
  const factory MonumentTilesState({
    /// Görünür alanın kümeleri ve tekil eserleri.
    @Default(<MapTileItem>[]) List<MapTileItem> items,

    /// Yakın zum'da ([MapTiles.complexExpandZoom]) açılan külliyelerin
    /// yerleşim alanları; [items]'tan ayrıdır, birleştirmeye girmez.
    @Default(<MapTileComplex>[]) List<MapTileComplex> complexes,
    @Default(false) bool isLoading,

    /// Son istek hatası; [items] son başarılı görünümdür.
    Failure? failure,

    /// Katalog sürümü; `null` → henüz bilinmiyor, istek yapılmaz.
    String? version,
    @Default('tr') String languageCode,
    @Default(MonumentSearchQuery.empty) MonumentSearchQuery query,
  }) = _MonumentTilesState;
}
