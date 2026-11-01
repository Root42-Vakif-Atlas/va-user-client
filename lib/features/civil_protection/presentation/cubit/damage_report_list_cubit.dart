import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/usecase/usecase.dart';
import 'package:vakif_atlas/features/civil_protection/domain/entities/damage_report.dart';
import 'package:vakif_atlas/features/civil_protection/domain/usecases/damage_report_usecases.dart';

part 'damage_report_list_cubit.freezed.dart';

enum DamageReportListStatus { initial, loading, success, failure }

@freezed
abstract class DamageReportListState with _$DamageReportListState {
  const factory DamageReportListState({
    @Default(DamageReportListStatus.initial) DamageReportListStatus status,
    @Default('tr') String languageCode,
    @Default(<DamageReport>[]) List<DamageReport> items,
    @Default(0) int total,
    String? nextCursor,
    Failure? failure,
    @Default(false) bool isLoadingMore,
    Failure? loadMoreFailure,
  }) = _DamageReportListState;

  const DamageReportListState._();

  bool get hasMore => nextCursor != null;

  bool get isEmpty => status == DamageReportListStatus.success && items.isEmpty;
}

/// "Bildirimlerim": kullanıcının raporları, en yeni önce (ekran bazlı).
///
/// Yeni gönderilen rapor depo akışıyla başa eklenir; sayfalama sırasında
/// eski istek yanıtları nesil sayacıyla yok sayılır.
@injectable
class DamageReportListCubit extends Cubit<DamageReportListState> {
  DamageReportListCubit(this._getReports, WatchSubmittedReportsUseCase watch)
    : super(const DamageReportListState()) {
    _submitted = watch(const NoParams()).listen(_onSubmitted);
  }

  final GetDamageReportsUseCase _getReports;
  late final StreamSubscription<DamageReport> _submitted;
  int _generation = 0;

  Future<void> start(String languageCode) =>
      _loadFirst(state.copyWith(languageCode: languageCode));

  Future<void> refresh() => _loadFirst(state);

  Future<void> retry() =>
      state.loadMoreFailure != null ? loadMore() : _loadFirst(state);

  Future<void> loadMore() async {
    if (!state.hasMore ||
        state.isLoadingMore ||
        state.status != DamageReportListStatus.success) {
      return;
    }
    final generation = _generation;
    emit(state.copyWith(isLoadingMore: true, loadMoreFailure: null));
    final result = await _getReports(
      GetDamageReportsParams(
        languageCode: state.languageCode,
        cursor: state.nextCursor,
      ),
    );
    if (isClosed || generation != _generation) {
      return;
    }
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoadingMore: false, loadMoreFailure: failure)),
      (page) {
        final known = {for (final report in state.items) report.id};
        emit(
          state.copyWith(
            isLoadingMore: false,
            items: [
              ...state.items,
              for (final report in page.items)
                if (!known.contains(report.id)) report,
            ],
            total: page.total,
            nextCursor: page.nextCursor,
          ),
        );
      },
    );
  }

  Future<void> _loadFirst(DamageReportListState next) async {
    final generation = ++_generation;
    emit(
      next.copyWith(
        status: DamageReportListStatus.loading,
        failure: null,
        loadMoreFailure: null,
        isLoadingMore: false,
      ),
    );
    final result = await _getReports(
      GetDamageReportsParams(languageCode: next.languageCode),
    );
    if (isClosed || generation != _generation) {
      return;
    }
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: DamageReportListStatus.failure,
          failure: failure,
        ),
      ),
      (page) => emit(
        state.copyWith(
          status: DamageReportListStatus.success,
          items: page.items,
          total: page.total,
          nextCursor: page.nextCursor,
        ),
      ),
    );
  }

  void _onSubmitted(DamageReport report) {
    if (isClosed ||
        state.status != DamageReportListStatus.success ||
        state.items.any((item) => item.id == report.id)) {
      return;
    }
    emit(
      state.copyWith(items: [report, ...state.items], total: state.total + 1),
    );
  }

  @override
  Future<void> close() async {
    await _submitted.cancel();
    return super.close();
  }
}
