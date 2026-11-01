part of 'monument_search_bloc.dart';

enum MonumentSearchStatus { initial, loading, success, failure }

@freezed
abstract class MonumentSearchState with _$MonumentSearchState {
  const factory MonumentSearchState({
    @Default('tr') String languageCode,
    @Default(MonumentSearchQuery.empty) MonumentSearchQuery query,
    @Default(MonumentSearchStatus.initial) MonumentSearchStatus status,

    /// Şimdiye kadar yüklenen sayfaların eserleri.
    @Default(<MonumentSummary>[]) List<MonumentSummary> items,

    /// Sorguya uyan toplam eser sayısı (sunucu).
    @Default(0) int total,
    String? nextCursor,
    @Default(<MonumentPlace>[]) List<MonumentPlace> places,
    @Default(MonumentFacets.empty) MonumentFacets facets,
    @Default(false) bool isLoadingMore,

    /// Son yüklenen sayfadaki kayıt sayısı (ekran okuyucu duyurusu).
    @Default(0) int lastPageSize,

    /// İlk sayfa hatası.
    Failure? failure,

    /// Sonraki sayfa hatası; liste korunur, altta tekrar dene gösterilir.
    Failure? loadMoreFailure,
  }) = _MonumentSearchState;

  const MonumentSearchState._();

  bool get hasMore => nextCursor != null;

  bool get isLoading => status == MonumentSearchStatus.loading;
}
