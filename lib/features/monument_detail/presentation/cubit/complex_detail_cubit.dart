import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/complex.dart';
import 'package:vakif_atlas/features/catalog/domain/usecases/catalog_usecases.dart';

part 'complex_detail_cubit.freezed.dart';
part 'complex_detail_state.dart';

/// Külliye detay ekranının durumu (ekran bazlı, factory). Külliyenin kaydı,
/// yerleşimi ve üyelerinin ilk sayfası tek istekte gelir.
@injectable
class ComplexDetailCubit extends Cubit<ComplexDetailState> {
  ComplexDetailCubit(this._getComplexDetail)
    : super(const ComplexDetailState.initial());

  final GetComplexDetailUseCase _getComplexDetail;

  GetMonumentDetailParams? _lastParams;

  /// Yalnızca en son isteğin sonucu yayınlanır (ör. yüklenirken dil değişti).
  int _request = 0;

  Future<void> load({required String id, required String languageCode}) async {
    final params = GetMonumentDetailParams(id: id, languageCode: languageCode);
    _lastParams = params;
    final request = ++_request;
    emit(const ComplexDetailState.loading());
    final result = await _getComplexDetail(params);
    if (isClosed || request != _request) {
      return;
    }
    emit(result.fold(ComplexDetailState.failure, ComplexDetailState.loaded));
  }

  Future<void> retry() async {
    final params = _lastParams;
    if (params != null) {
      await load(id: params.id, languageCode: params.languageCode);
    }
  }
}
