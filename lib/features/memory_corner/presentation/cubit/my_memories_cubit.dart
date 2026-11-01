import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/usecase/usecase.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/features/catalog/domain/usecases/catalog_usecases.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory_draft.dart';
import 'package:vakif_atlas/features/memory_corner/domain/repositories/memory_repository.dart';
import 'package:vakif_atlas/features/memory_corner/domain/usecases/memory_usecases.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/bloc/memory_list_bloc.dart';

part 'my_memories_cubit.freezed.dart';

enum MyMemoriesStatus { loading, ready, failure }

@freezed
abstract class MyMemoriesState with _$MyMemoriesState {
  const factory MyMemoriesState({
    @Default(MyMemoriesStatus.loading) MyMemoriesStatus status,

    /// En son paylaşılan önce.
    @Default(<Memory>[]) List<Memory> items,
    @Default(0) int total,
    String? nextCursor,
    Failure? failure,
    @Default(false) bool isLoadingMore,
    Failure? loadMoreFailure,

    /// Eser kimliği → arayüz dilindeki adı (katalogdan çözülür).
    @Default(<String, String>{}) Map<String, String> monumentNames,

    /// Silme isteği süren anılar.
    @Default(<String>{}) Set<String> busyIds,
    MemoryNotice? notice,

    /// Her yeni bildirimde artar.
    @Default(0) int noticeCount,
  }) = _MyMemoriesState;

  const MyMemoriesState._();

  bool get hasMore => nextCursor != null;

  bool get isEmpty => status == MyMemoriesStatus.ready && items.isEmpty;

  /// Anı metinleri kişisel veridir; loglara yazılmaz.
  @override
  String toString() =>
      'MyMemoriesState($status, items: ${items.length}, total: $total)';
}

/// Profildeki "Anılarım" (ekran bazlı, factory): profil önizlemesi küçük,
/// tam liste normal sayfa boyutuyla kullanır.
///
/// - Eser adları katalogdan arayüz dilinde tek istekte çözülür
///   (`view=location&ids=…`); çözülemezse genel etiket gösterilir.
/// - Başka ekranda paylaşılan anı listeyi yeniler, silinen anı listeden
///   düşer (`MemoryRepository.changes`).
@injectable
class MyMemoriesCubit extends Cubit<MyMemoriesState> {
  MyMemoriesCubit(
    this._getMine,
    this._delete,
    this._pins,
    WatchMemoryChangesUseCase watchChanges,
  ) : super(const MyMemoriesState()) {
    _changes = watchChanges(const NoParams()).listen(_onChange);
  }

  final GetMyMemoriesUseCase _getMine;
  final DeleteMemoryUseCase _delete;
  final GetMonumentPinsUseCase _pins;
  late final StreamSubscription<MemoryChange> _changes;

  String? _languageCode;
  int _limit = MemoryRules.pageSize;

  /// Yeniden yüklemede geç gelen eski sonuç yok sayılır.
  int _generation = 0;

  Future<void> load({
    required String languageCode,
    int limit = MemoryRules.pageSize,
  }) async {
    if (languageCode != _languageCode) {
      _languageCode = languageCode;
      emit(state.copyWith(monumentNames: const {}));
    }
    _limit = limit;
    if (state.items.isEmpty) {
      emit(state.copyWith(status: MyMemoriesStatus.loading, failure: null));
    }
    await _reload();
  }

  Future<void> loadMore() async {
    final cursor = state.nextCursor;
    if (cursor == null ||
        state.isLoadingMore ||
        state.status != MyMemoriesStatus.ready) {
      return;
    }
    final generation = _generation;
    emit(state.copyWith(isLoadingMore: true, loadMoreFailure: null));
    final result = await _getMine(
      GetMyMemoriesParams(limit: _limit, cursor: cursor),
    );
    if (isClosed || generation != _generation) {
      return;
    }
    switch (result) {
      case Left(value: final failure):
        emit(state.copyWith(isLoadingMore: false, loadMoreFailure: failure));
      case Right(value: final page):
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
        await _resolveNames(page.items);
    }
  }

  Future<void> delete(Memory memory) async {
    if (state.busyIds.contains(memory.id)) {
      return;
    }
    emit(state.copyWith(busyIds: {...state.busyIds, memory.id}));
    final result = await _delete(memory);
    if (isClosed) {
      return;
    }
    final busy = {...state.busyIds}..remove(memory.id);
    switch (result) {
      // Anı zaten silinmiş: listeden kaldırmak yeterlidir.
      case Right() ||
          Left(value: ServerFailure(kind: ServerFailureKind.notFound)):
        emit(_without(memory.id).copyWith(busyIds: busy));
        _notify(const MemoryNotice(MemoryNoticeKind.deleted));
      case Left(value: final failure):
        emit(state.copyWith(busyIds: busy));
        _notify(MemoryNotice(MemoryNoticeKind.actionFailed, failure: failure));
    }
  }

  Future<void> _reload() async {
    final generation = ++_generation;
    final result = await _getMine(GetMyMemoriesParams(limit: _limit));
    if (isClosed || generation != _generation) {
      return;
    }
    switch (result) {
      case Left(value: final failure):
        // Elde liste varsa korunur; yalnızca ilk yüklemede hata gösterilir.
        if (state.items.isEmpty) {
          emit(
            state.copyWith(status: MyMemoriesStatus.failure, failure: failure),
          );
        }
      case Right(value: final page):
        emit(
          state.copyWith(
            status: MyMemoriesStatus.ready,
            items: page.items,
            total: page.total,
            nextCursor: page.nextCursor,
            failure: null,
            loadMoreFailure: null,
          ),
        );
        await _resolveNames(page.items);
    }
  }

  Future<void> _resolveNames(List<Memory> memories) async {
    final languageCode = _languageCode;
    if (languageCode == null) {
      return;
    }
    final missing = {
      for (final memory in memories)
        if (!state.monumentNames.containsKey(memory.monumentId))
          memory.monumentId,
    }.toList();
    if (missing.isEmpty) {
      return;
    }
    final result = await _pins(
      GetMonumentPinsParams(ids: missing, languageCode: languageCode),
    );
    if (isClosed || languageCode != _languageCode) {
      return;
    }
    if (result case Right(value: final pins)) {
      emit(
        state.copyWith(
          monumentNames: {
            ...state.monumentNames,
            for (final pin in pins) pin.id: pin.name,
          },
        ),
      );
    }
  }

  void _onChange(MemoryChange change) {
    if (isClosed || _languageCode == null) {
      return;
    }
    switch (change) {
      case MemoryCreated():
        unawaited(_reload());
      case MemoryRemoved(:final memoryId):
        // Bildirilen başkasının anısı bu listede yoktur.
        if (state.items.any((memory) => memory.id == memoryId)) {
          emit(_without(memoryId));
        }
    }
  }

  MyMemoriesState _without(String memoryId) {
    final remaining = [
      for (final memory in state.items)
        if (memory.id != memoryId) memory,
    ];
    final removed = state.items.length - remaining.length;
    return state.copyWith(
      items: remaining,
      total: (state.total - removed).clamp(0, state.total),
    );
  }

  void _notify(MemoryNotice notice) =>
      emit(state.copyWith(notice: notice, noticeCount: state.noticeCount + 1));

  @override
  Future<void> close() async {
    await _changes.cancel();
    return super.close();
  }
}
