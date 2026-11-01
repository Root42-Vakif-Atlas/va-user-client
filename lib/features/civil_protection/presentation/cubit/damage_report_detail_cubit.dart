import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/features/civil_protection/domain/entities/damage_report.dart';
import 'package:vakif_atlas/features/civil_protection/domain/usecases/damage_report_usecases.dart';

part 'damage_report_detail_cubit.freezed.dart';

@freezed
sealed class DamageReportDetailState with _$DamageReportDetailState {
  const factory DamageReportDetailState.loading() = DamageReportDetailLoading;

  const factory DamageReportDetailState.loaded(DamageReport report) =
      DamageReportDetailLoaded;

  const factory DamageReportDetailState.failure(Failure failure) =
      DamageReportDetailFailure;

  const DamageReportDetailState._();

  /// Rapor yok veya kullanıcıya ait değil (404).
  bool get isNotFound => switch (this) {
    DamageReportDetailFailure(
      failure: ServerFailure(kind: ServerFailureKind.notFound),
    ) =>
      true,
    _ => false,
  };
}

/// Bir raporun ayrıntısı ve durum geçmişi (ekran bazlı).
@injectable
class DamageReportDetailCubit extends Cubit<DamageReportDetailState> {
  DamageReportDetailCubit(this._getReport)
    : super(const DamageReportDetailState.loading());

  final GetDamageReportUseCase _getReport;
  GetDamageReportParams? _last;
  int _request = 0;

  Future<void> load({required String id, required String languageCode}) async {
    final params = GetDamageReportParams(id: id, languageCode: languageCode);
    _last = params;
    final request = ++_request;
    // Dil değişiminde mevcut rapor gösterilmeye devam eder.
    if (state is! DamageReportDetailLoaded) {
      emit(const DamageReportDetailState.loading());
    }
    final result = await _getReport(params);
    if (isClosed || request != _request) {
      return;
    }
    emit(
      result.fold(
        DamageReportDetailState.failure,
        DamageReportDetailState.loaded,
      ),
    );
  }

  Future<void> retry() async {
    final params = _last;
    if (params != null) {
      emit(const DamageReportDetailState.loading());
      await load(id: params.id, languageCode: params.languageCode);
    }
  }
}
