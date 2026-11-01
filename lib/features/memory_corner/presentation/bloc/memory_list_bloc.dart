import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/usecase/usecase.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory_draft.dart';
import 'package:vakif_atlas/features/memory_corner/domain/repositories/memory_repository.dart';
import 'package:vakif_atlas/features/memory_corner/domain/usecases/memory_usecases.dart';

part 'memory_list_bloc.freezed.dart';
part 'memory_list_event.dart';
part 'memory_list_state.dart';

/// Bir eserin anıları (ekran bazlı, factory): eser detayındaki önizleme ve
/// tam liste aynı sınıfı farklı sayfa boyutuyla kullanır.
///
/// - İlk sayfa / yenileme `restartable()`; geç gelen eski yanıtlar nesil
///   sayacıyla yok sayılır.
/// - Sonraki sayfa `droppable()`: kaydırırken art arda gelen istekler tek
///   istek olarak işlenir.
/// - Başka ekranda paylaşılan, silinen veya bildirilen anılar depo değişiklik
///   akışıyla listeye yansır; önizleme eksilirse sonraki kayıtla doldurulur.
@injectable
class MemoryListBloc extends Bloc<MemoryListEvent, MemoryListState> {
  MemoryListBloc(
    this._getMemories,
    this._deleteMemory,
    this._reportMemory,
    WatchMemoryChangesUseCase watchChanges,
  ) : super(const MemoryListState()) {
    on<MemoryListStarted>(_onStarted, transformer: restartable());
    on<MemoryListRefreshed>(_onRefreshed, transformer: restartable());
    on<MemoryListRangeChanged>(_onRangeChanged, transformer: restartable());
    on<MemoryListNextPageRequested>(
      _onNextPageRequested,
      transformer: droppable(),
    );
    on<MemoryListRetryRequested>(_onRetryRequested, transformer: droppable());
    on<MemoryDeleteRequested>(_onDeleteRequested);
    on<MemoryReportRequested>(_onReportRequested);
    on<_MemoryChangeReceived>(_onChangeReceived, transformer: sequential());
    _changes = watchChanges(const NoParams())
        .listen((change) => add(MemoryListEvent.changeReceived(change)));
  }

  final GetMemoriesUseCase _getMemories;
  final DeleteMemoryUseCase _deleteMemory;
  final ReportMemoryUseCase _reportMemory;
  late final StreamSubscription<MemoryChange> _changes;

  int _generation = 0;

  Future<void> _onStarted(
    MemoryListStarted event,
    Emitter<MemoryListState> emit,
  ) => _loadFirstPage(
    emit,
    MemoryListState(monumentId: event.monumentId, pageSize: event.pageSize),
  );

  Future<void> _onRefreshed(
    MemoryListRefreshed event,
    Emitter<MemoryListState> emit,
  ) async {
    if (state.monumentId.isEmpty) {
      return;
    }
    await _loadFirstPage(emit, state);
  }

  Future<void> _onRangeChanged(
    MemoryListRangeChanged event,
    Emitter<MemoryListState> emit,
  ) async {
    if (state.monumentId.isEmpty ||
        (event.range == state.range &&
            state.status == MemoryListStatus.success)) {
      return;
    }
    await _loadFirstPage(
      emit,
      state.copyWith(range: event.range, items: const [], nextCursor: null),
    );
  }

  Future<void> _onRetryRequested(
    MemoryListRetryRequested event,
    Emitter<MemoryListState> emit,
  ) async {
    if (state.loadMoreFailure != null) {
      await _loadNextPage(emit);
    } else if (state.monumentId.isNotEmpty) {
      await _loadFirstPage(emit, state);
    }
  }

  Future<void> _onNextPageRequested(
    MemoryListNextPageRequested event,
    Emitter<MemoryListState> emit,
  ) async {
    if (!state.hasMore ||
        state.isLoadingMore ||
        state.loadMoreFailure != null ||
        state.status != MemoryListStatus.success) {
      return;
    }
    await _loadNextPage(emit);
  }

  Future<void> _loadFirstPage(
    Emitter<MemoryListState> emit,
    MemoryListState next,
  ) async {
    final generation = ++_generation;
    emit(
      next.copyWith(
        status: MemoryListStatus.loading,
        failure: null,
        loadMoreFailure: null,
        isLoadingMore: false,
      ),
    );
    final result = await _getMemories(
      GetMemoriesParams(
        monumentId: next.monumentId,
        limit: next.pageSize,
        range: next.range,
        includeYears: true,
      ),
    );
    if (generation != _generation) {
      return;
    }
    result.fold(
      (failure) => emit(
        state.copyWith(status: MemoryListStatus.failure, failure: failure),
      ),
      (page) => emit(
        state.copyWith(
          status: MemoryListStatus.success,
          items: page.items,
          total: page.total,
          nextCursor: page.nextCursor,
          years: page.years ?? state.years,
        ),
      ),
    );
  }

  Future<void> _loadNextPage(Emitter<MemoryListState> emit) async {
    final generation = _generation;
    emit(state.copyWith(isLoadingMore: true, loadMoreFailure: null));
    final result = await _getMemories(
      GetMemoriesParams(
        monumentId: state.monumentId,
        limit: state.pageSize,
        cursor: state.nextCursor,
        range: state.range,
      ),
    );
    if (generation != _generation) {
      return;
    }
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoadingMore: false, loadMoreFailure: failure)),
      (page) {
        final known = {for (final memory in state.items) memory.id};
        emit(
          state.copyWith(
            isLoadingMore: false,
            items: [
              ...state.items,
              for (final memory in page.items)
                if (!known.contains(memory.id)) memory,
            ],
            total: page.total,
            nextCursor: page.nextCursor,
          ),
        );
      },
    );
  }

  Future<void> _onDeleteRequested(
    MemoryDeleteRequested event,
    Emitter<MemoryListState> emit,
  ) async {
    final memory = event.memory;
    if (state.busyIds.contains(memory.id)) {
      return;
    }
    emit(state.copyWith(busyIds: {...state.busyIds, memory.id}));
    final result = await _deleteMemory(memory);
    final busy = {...state.busyIds}..remove(memory.id);
    result.fold(
      (failure) {
        // Anı zaten silinmiş: listeden kaldırmak yeterlidir.
        if (failure case ServerFailure(kind: ServerFailureKind.notFound)) {
          emit(_without(memory.id).copyWith(busyIds: busy));
          _notify(emit, const MemoryNotice(MemoryNoticeKind.deleted));
        } else {
          emit(state.copyWith(busyIds: busy));
          _notify(
            emit,
            MemoryNotice(MemoryNoticeKind.actionFailed, failure: failure),
          );
        }
      },
      (_) {
        emit(state.copyWith(busyIds: busy));
        _notify(emit, const MemoryNotice(MemoryNoticeKind.deleted));
      },
    );
  }

  Future<void> _onReportRequested(
    MemoryReportRequested event,
    Emitter<MemoryListState> emit,
  ) async {
    final memory = event.memory;
    if (state.busyIds.contains(memory.id)) {
      return;
    }
    emit(state.copyWith(busyIds: {...state.busyIds, memory.id}));
    final result = await _reportMemory(
      ReportMemoryParams(
        memory: memory,
        reason: event.reason,
        note: event.note,
      ),
    );
    final busy = {...state.busyIds}..remove(memory.id);
    emit(state.copyWith(busyIds: busy));
    result.fold(
      (failure) => _notify(
        emit,
        MemoryNotice(MemoryNoticeKind.actionFailed, failure: failure),
      ),
      (_) => _notify(emit, const MemoryNotice(MemoryNoticeKind.reported)),
    );
  }

  Future<void> _onChangeReceived(
    _MemoryChangeReceived event,
    Emitter<MemoryListState> emit,
  ) async {
    final change = event.change;
    if (change.monumentId != state.monumentId ||
        state.status != MemoryListStatus.success) {
      return;
    }
    switch (change) {
      case MemoryCreated(:final memory):
        // Yalnızca yayındaki anı (ADR 58): incelemedeki veya yayınlanmayan
        // anı Anı Köşesi'nde yazarına da görünmez, durumu profildeki
        // Anılarım'dan izlenir (sunucu listesi de yalnızca `approved` döner).
        if (memory.status != MemoryModerationStatus.approved ||
            state.items.any((item) => item.id == memory.id)) {
          return;
        }
        final years = _countYear(memory.memoryDate.year, 1);
        final range = state.range;
        if (range != null && !range.contains(memory.memoryDate)) {
          emit(state.copyWith(years: years));
          return;
        }
        // Zaman çizelgesindeki yerine (anı tarihine göre) yerleşir; daha
        // eski ve henüz yüklenmemiş sayfalara düşüyorsa yalnızca sayılır.
        final index = state.items.indexWhere(
          (item) => !item.memoryDate.isAfter(memory.memoryDate),
        );
        final items = [...state.items];
        if (index >= 0) {
          items.insert(index, memory);
        } else if (!state.hasMore) {
          items.add(memory);
        }
        emit(
          state.copyWith(items: items, total: state.total + 1, years: years),
        );
      case MemoryRemoved(:final memoryId):
        emit(_without(memoryId));
        // Önizleme eksik kaldıysa sonraki kayıtla tamamlanır.
        if (state.items.length < state.pageSize && state.hasMore) {
          await _loadNextPage(emit);
        }
    }
  }

  MemoryListState _without(String memoryId) {
    final removed = state.items.where((item) => item.id == memoryId);
    if (removed.isEmpty && !state.hasMore) {
      return state;
    }
    return state.copyWith(
      items: [
        for (final item in state.items)
          if (item.id != memoryId) item,
      ],
      total: state.total > 0 ? state.total - 1 : 0,
      years: removed.isEmpty
          ? state.years
          : _countYear(removed.first.memoryDate.year, -1),
    );
  }

  /// Yıl sayısını [delta] kadar değiştirir; sıfıra inen yıl kalkar.
  List<MemoryYearCount> _countYear(int year, int delta) {
    final counts = {for (final y in state.years) y.year: y.count};
    final next = (counts[year] ?? 0) + delta;
    if (next > 0) {
      counts[year] = next;
    } else {
      counts.remove(year);
    }
    return [
      for (final y in counts.keys.toList()..sort((a, b) => b - a))
        MemoryYearCount(year: y, count: counts[y]!),
    ];
  }

  void _notify(Emitter<MemoryListState> emit, MemoryNotice notice) =>
      emit(state.copyWith(notice: notice, noticeCount: state.noticeCount + 1));

  @override
  Future<void> close() async {
    await _changes.cancel();
    return super.close();
  }
}
