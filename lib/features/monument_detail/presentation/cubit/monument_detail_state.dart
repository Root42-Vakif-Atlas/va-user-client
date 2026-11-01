part of 'monument_detail_cubit.dart';

@freezed
sealed class MonumentDetailState with _$MonumentDetailState {
  const factory MonumentDetailState.initial() = MonumentDetailInitial;

  const factory MonumentDetailState.loading() = MonumentDetailLoading;

  /// [siblings]: eser bir külliyenin yapısıysa diğer yapılar (kendisi
  /// hariç); ayrıca ve sonradan yüklenir, hata sessizce yok sayılır.
  const factory MonumentDetailState.loaded(
    MonumentDetail monument, {
    @Default(<MonumentSummary>[]) List<MonumentSummary> siblings,
  }) = MonumentDetailLoaded;

  const factory MonumentDetailState.failure(Failure failure) =
      MonumentDetailFailure;

  const MonumentDetailState._();

  /// Eser katalogda yok (404) — tekrar denemek anlamsızdır.
  bool get isNotFound => switch (this) {
    MonumentDetailFailure(
      failure: ServerFailure(kind: ServerFailureKind.notFound),
    ) =>
      true,
    _ => false,
  };
}
