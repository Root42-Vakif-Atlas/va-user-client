import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/usecase/usecase.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';
import 'package:vakif_atlas/features/catalog/domain/usecases/catalog_usecases.dart';
import 'package:vakif_atlas/features/saved_monuments/domain/entities/saved_monument.dart';
import 'package:vakif_atlas/features/saved_monuments/domain/usecases/saved_monuments_usecases.dart';

part 'saved_monuments_list_cubit.freezed.dart';

/// Listedeki satır: kayıt + katalogdaki güncel bilgisi.
@immutable
final class SavedMonumentEntry {
  const SavedMonumentEntry({required this.saved, this.pin});

  final SavedMonument saved;

  /// `null` → eser artık katalogda yok (yalnızca kaldırılabilir).
  final MonumentPin? pin;

  @override
  bool operator ==(Object other) =>
      other is SavedMonumentEntry && other.saved == saved && other.pin == pin;

  @override
  int get hashCode => Object.hash(saved, pin);
}

enum SavedMonumentsListStatus { loading, ready, failure }

@freezed
abstract class SavedMonumentsListState with _$SavedMonumentsListState {
  const factory SavedMonumentsListState({
    @Default(SavedMonumentsListStatus.loading) SavedMonumentsListStatus status,
    @Default(<SavedMonumentEntry>[]) List<SavedMonumentEntry> entries,
    Failure? failure,
  }) = _SavedMonumentsListState;
}

/// Kaydedilenler sayfası (ekran bazlı): kayıtlar katalogdan arayüz dilinde
/// 50'lik parçalarla çözülür (`view=location&ids=…`); kaydetme/kaldırma
/// akışıyla kendini yeniler. Dil değişince yeniden çözülür (ADR 19).
@injectable
class SavedMonumentsListCubit extends Cubit<SavedMonumentsListState> {
  SavedMonumentsListCubit(
    this._get,
    this._pins,
    WatchSavedMonumentsUseCase watch,
  ) : super(const SavedMonumentsListState()) {
    _changes = watch(const NoParams()).listen((saved) {
      if (_languageCode != null) {
        unawaited(_show(saved));
      }
    });
  }

  final GetSavedMonumentsUseCase _get;
  final GetMonumentPinsUseCase _pins;
  late final StreamSubscription<List<SavedMonument>> _changes;

  String? _languageCode;

  /// Çözülen eserler; `null` → katalogda yok.
  final Map<String, MonumentPin?> _resolved = {};

  /// Geç gelen eski çözüm sonucu yok sayılır.
  int _generation = 0;

  Future<void> load({required String languageCode}) async {
    if (languageCode != _languageCode) {
      _resolved.clear();
      _languageCode = languageCode;
    }
    emit(state.copyWith(status: SavedMonumentsListStatus.loading));
    final result = await _get(const NoParams());
    if (isClosed) {
      return;
    }
    switch (result) {
      case Left(value: final failure):
        emit(
          state.copyWith(
            status: SavedMonumentsListStatus.failure,
            failure: failure,
          ),
        );
      case Right(value: final saved):
        await _show(saved);
    }
  }

  Future<void> _show(List<SavedMonument> saved) async {
    final languageCode = _languageCode;
    if (languageCode == null) {
      return;
    }
    final generation = ++_generation;
    final missing = [
      for (final item in saved)
        if (!_resolved.containsKey(item.monumentId)) item.monumentId,
    ];
    for (var start = 0; start < missing.length; start += _chunk) {
      final ids = missing.skip(start).take(_chunk).toList();
      final result = await _pins(
        GetMonumentPinsParams(ids: ids, languageCode: languageCode),
      );
      if (isClosed || generation != _generation) {
        return;
      }
      switch (result) {
        case Left(value: final failure):
          emit(
            state.copyWith(
              status: SavedMonumentsListStatus.failure,
              failure: failure,
            ),
          );
          return;
        case Right(value: final pins):
          final byId = {for (final pin in pins) pin.id: pin};
          for (final id in ids) {
            _resolved[id] = byId[id];
          }
      }
    }
    emit(
      state.copyWith(
        status: SavedMonumentsListStatus.ready,
        failure: null,
        entries: List.unmodifiable([
          for (final item in saved)
            SavedMonumentEntry(saved: item, pin: _resolved[item.monumentId]),
        ]),
      ),
    );
  }

  static const int _chunk = GetMonumentPinsParams.maxIds;

  @override
  Future<void> close() async {
    await _changes.cancel();
    return super.close();
  }
}
