part of 'complex_members_cubit.dart';

enum ComplexMembersStatus { initial, loading, success, failure }

@freezed
abstract class ComplexMembersState with _$ComplexMembersState {
  const factory ComplexMembersState({
    String? complexId,
    @Default('tr') String languageCode,
    @Default(ComplexMembersStatus.initial) ComplexMembersStatus status,
    @Default(<MonumentSummary>[]) List<MonumentSummary> items,
    @Default(0) int total,
    String? nextCursor,
    @Default(false) bool isLoadingMore,

    /// Seçili türler; boş → tümü.
    @Default(<MonumentCategory>{}) Set<MonumentCategory> categories,

    /// Çip olarak sunulan türler (külliyede bulunanlar).
    @Default(<MonumentCategory>[]) List<MonumentCategory> availableCategories,

    /// İlk sayfa hatası ([status] failure) veya sonraki sayfa hatası.
    Failure? failure,
  }) = _ComplexMembersState;

  const ComplexMembersState._();

  bool get hasMore => nextCursor != null;
}
