import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/usecase/usecase.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/features/saved_monuments/domain/entities/saved_monument.dart';
import 'package:vakif_atlas/features/saved_monuments/domain/usecases/saved_monuments_usecases.dart';

part 'saved_monuments_cubit.freezed.dart';

@freezed
abstract class SavedMonumentsState with _$SavedMonumentsState {
  const factory SavedMonumentsState({
    /// En son kaydedilen önce.
    @Default(<SavedMonument>[]) List<SavedMonument> items,
    @Default(false) bool isLoaded,
  }) = _SavedMonumentsState;

  const SavedMonumentsState._();

  int get count => items.length;

  bool contains(String monumentId) =>
      items.any((item) => item.monumentId == monumentId);

  SavedMonument? find(String monumentId) =>
      items.where((item) => item.monumentId == monumentId).firstOrNull;
}

/// Kaydet / kaldır isteğinin kullanıcıya bildirilecek sonucu.
enum SavedToggleOutcome { saved, removed, limitReached, failed }

/// Uygulama genelinde kaydedilen eserler (tek örnek): harita üst
/// çubuğundaki "Kaydedilenler" butonu, harita önizlemesi, eser detayı ve
/// kaydedilenler listesi aynı durumu paylaşır (ADR 24'teki taslak deseni).
@lazySingleton
class SavedMonumentsCubit extends Cubit<SavedMonumentsState> {
  SavedMonumentsCubit(
    GetSavedMonumentsUseCase get,
    SaveMonumentUseCase save,
    RemoveSavedMonumentUseCase remove,
    WatchSavedMonumentsUseCase watch,
  ) : this.withClock(get, save, remove, watch, DateTime.now);

  /// Testlerde kaydetme zamanını sabitlemek için.
  SavedMonumentsCubit.withClock(
    this._get,
    this._save,
    this._remove,
    WatchSavedMonumentsUseCase watch,
    this._clock,
  ) : super(const SavedMonumentsState()) {
    _changes = watch(const NoParams())
        .listen((items) => emit(state.copyWith(items: items, isLoaded: true)));
    unawaited(load());
  }

  final GetSavedMonumentsUseCase _get;
  final SaveMonumentUseCase _save;
  final RemoveSavedMonumentUseCase _remove;
  final DateTime Function() _clock;
  late final StreamSubscription<List<SavedMonument>> _changes;

  Future<void> load() async {
    final result = await _get(const NoParams());
    if (isClosed) {
      return;
    }
    // Okunamazsa liste boş kalır; kaydetme yine denenebilir.
    emit(
      state.copyWith(items: result.getOrNull() ?? state.items, isLoaded: true),
    );
  }

  /// Kayıtlıysa kaldırır, değilse kaydeder.
  Future<SavedToggleOutcome> toggle(String monumentId) async {
    if (state.contains(monumentId)) {
      final result = await _remove(monumentId);
      return result.fold((_) => SavedToggleOutcome.failed, (_) {
        _apply(
          state.items.where((item) => item.monumentId != monumentId).toList(),
        );
        return SavedToggleOutcome.removed;
      });
    }
    return _put(SavedMonument(monumentId: monumentId, savedAt: _clock()));
  }

  /// Kaldırmayı geri alır (kaydetme zamanı korunur, sıra değişmez).
  Future<SavedToggleOutcome> restore(SavedMonument monument) => _put(monument);

  Future<SavedToggleOutcome> _put(SavedMonument monument) async {
    final result = await _save(monument);
    switch (result) {
      case Left():
        return SavedToggleOutcome.failed;
      case Right(value: SaveMonumentOutcome.limitReached):
        return SavedToggleOutcome.limitReached;
      case Right():
        if (!state.contains(monument.monumentId)) {
          _apply(
            [...state.items, monument]
              ..sort((a, b) => b.savedAt.compareTo(a.savedAt)),
          );
        }
        return SavedToggleOutcome.saved;
    }
  }

  /// Değişiklik akışı da aynı listeyi getirir; arayüz beklemeden güncellenir.
  void _apply(List<SavedMonument> items) {
    if (!isClosed) {
      emit(state.copyWith(items: List.unmodifiable(items), isLoaded: true));
    }
  }

  @override
  Future<void> close() async {
    await _changes.cancel();
    return super.close();
  }
}
