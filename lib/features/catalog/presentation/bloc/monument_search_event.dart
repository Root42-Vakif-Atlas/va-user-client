part of 'monument_search_bloc.dart';

@freezed
sealed class MonumentSearchEvent with _$MonumentSearchEvent {
  /// Ekran açıldı veya arayüz dili değişti.
  const factory MonumentSearchEvent.started({
    required String languageCode,
    @Default(MonumentSearchQuery.empty) MonumentSearchQuery query,
  }) = MonumentSearchStarted;

  /// Metin (seyreltilmiş) veya filtre değişti.
  const factory MonumentSearchEvent.queryChanged(MonumentSearchQuery query) =
      MonumentSearchQueryChanged;

  /// Liste sonuna yaklaşıldı.
  const factory MonumentSearchEvent.nextPageRequested() =
      MonumentSearchNextPageRequested;

  /// Başarısız ilk veya sonraki sayfayı yeniden ister.
  const factory MonumentSearchEvent.retryRequested() =
      MonumentSearchRetryRequested;
}
