part of 'memory_list_bloc.dart';

enum MemoryListStatus { initial, loading, success, failure }

enum MemoryNoticeKind { deleted, reported, actionFailed }

/// Kullanıcının başlattığı işlemin sonucu (SnackBar + ekran okuyucu).
@immutable
final class MemoryNotice {
  const MemoryNotice(this.kind, {this.failure});

  final MemoryNoticeKind kind;
  final Failure? failure;
}

@freezed
abstract class MemoryListState with _$MemoryListState {
  const factory MemoryListState({
    @Default('') String monumentId,
    @Default(MemoryRules.pageSize) int pageSize,
    @Default(MemoryListStatus.initial) MemoryListStatus status,

    /// Anı tarihi filtresi; `null` → tüm zamanlar.
    MemoryDateRange? range,

    /// Yıllara göre sayılar (filtreden bağımsız), en yeni yıl önce.
    @Default(<MemoryYearCount>[]) List<MemoryYearCount> years,
    @Default(<Memory>[]) List<Memory> items,
    @Default(0) int total,
    String? nextCursor,
    Failure? failure,
    @Default(false) bool isLoadingMore,
    Failure? loadMoreFailure,

    /// Silme / bildirme isteği süren anılar.
    @Default(<String>{}) Set<String> busyIds,
    MemoryNotice? notice,

    /// Her yeni bildirimde artar (aynı bildirimin tekrarı da dinlenir).
    @Default(0) int noticeCount,
  }) = _MemoryListState;

  const MemoryListState._();

  bool get hasMore => nextCursor != null;

  bool get isEmpty => status == MemoryListStatus.success && items.isEmpty;

  /// Filtresiz toplam (yıl sayılarının toplamı).
  int get allTimeTotal =>
      range == null ? total : years.fold(0, (sum, year) => sum + year.count);
}
