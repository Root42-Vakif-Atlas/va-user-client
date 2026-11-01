part of 'memory_list_bloc.dart';

@freezed
sealed class MemoryListEvent with _$MemoryListEvent {
  /// [pageSize]: eser detayındaki önizlemede `MemoryRules.previewSize`, tam
  /// listede `MemoryRules.pageSize`.
  const factory MemoryListEvent.started({
    required String monumentId,
    required int pageSize,
  }) = MemoryListStarted;

  /// Aşağı çekerek yenileme veya oturum değişimi; mevcut liste yeni sonuç
  /// gelene kadar gösterilir.
  const factory MemoryListEvent.refreshed() = MemoryListRefreshed;

  /// Zaman çizelgesi filtresi; `null` → tüm zamanlar.
  const factory MemoryListEvent.rangeChanged(MemoryDateRange? range) =
      MemoryListRangeChanged;

  const factory MemoryListEvent.nextPageRequested() =
      MemoryListNextPageRequested;

  const factory MemoryListEvent.retryRequested() = MemoryListRetryRequested;

  const factory MemoryListEvent.deleteRequested(Memory memory) =
      MemoryDeleteRequested;

  const factory MemoryListEvent.reportRequested({
    required Memory memory,
    required MemoryReportReason reason,
    @Default('') String note,
  }) = MemoryReportRequested;

  /// Depodan gelen değişiklik (başka bir ekranda paylaşma / silme).
  const factory MemoryListEvent.changeReceived(MemoryChange change) =
      _MemoryChangeReceived;
}
