import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_detail.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_summary.dart';
import 'package:vakif_atlas/features/catalog/domain/usecases/catalog_usecases.dart';

part 'monument_detail_cubit.freezed.dart';
part 'monument_detail_state.dart';

/// Eser detay ekranının durumu. Ekran bazlıdır (factory).
///
/// Eser bir külliyenin yapısıysa külliyenin diğer yapıları ([siblingLimit])
/// detaydan sonra ayrıca istenir; sayfa beklemez.
@injectable
class MonumentDetailCubit extends Cubit<MonumentDetailState> {
  MonumentDetailCubit(this._getMonumentDetail, this._getComplexMembers)
    : super(const MonumentDetailState.initial());

  final GetMonumentDetailUseCase _getMonumentDetail;
  final GetComplexMembersUseCase _getComplexMembers;

  /// Yatay şeritte gösterilen kardeş yapı sayısı (kendisi dahil istenir).
  static const int siblingLimit = 12;

  GetMonumentDetailParams? _lastParams;

  /// Her çağrı bir öncekini geçersiz kılar (ör. yükleme sürerken dil
  /// değişti); yalnızca en son isteğin sonucu yayınlanır.
  int _request = 0;

  Future<void> load({required String id, required String languageCode}) async {
    final params = GetMonumentDetailParams(id: id, languageCode: languageCode);
    _lastParams = params;
    final request = ++_request;
    emit(const MonumentDetailState.loading());
    final result = await _getMonumentDetail(params);
    if (isClosed || request != _request) {
      return;
    }
    emit(result.fold(MonumentDetailState.failure, MonumentDetailState.loaded));
    final complex = result.fold((_) => null, (monument) => monument.complex);
    if (complex == null) {
      return;
    }
    final members = await _getComplexMembers(
      GetComplexMembersParams(
        complexId: complex.id,
        languageCode: languageCode,
        limit: siblingLimit,
      ),
    );
    final current = state;
    if (isClosed || request != _request || current is! MonumentDetailLoaded) {
      return;
    }
    members.fold((_) {}, (page) {
      final siblings = [
        for (final member in page.items)
          if (member.id != current.monument.id) member,
      ];
      if (siblings.isNotEmpty) {
        emit(current.copyWith(siblings: siblings));
      }
    });
  }

  Future<void> retry() async {
    final params = _lastParams;
    if (params != null) {
      await load(id: params.id, languageCode: params.languageCode);
    }
  }
}
