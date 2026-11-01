import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/route_export/domain/entities/route_export.dart';
import 'package:vakif_atlas/features/route_export/domain/usecases/route_export_usecases.dart';

part 'route_exports_cubit.freezed.dart';

enum RouteExportsStatus { loading, ready, failure }

@freezed
abstract class RouteExportsState with _$RouteExportsState {
  const factory RouteExportsState({
    @Default(RouteExportsStatus.loading) RouteExportsStatus status,
    @Default(<RouteExport>[]) List<RouteExport> items,
    Failure? failure,

    /// Açılan veya silinen kaydın işlem hatası (liste korunur).
    Failure? actionFailure,

    /// Her silme başarısında artar (duyuru).
    @Default(0) int deletions,
  }) = _RouteExportsState;
}

/// "Dışa aktarımlarım" (ekran bazlı, factory). Yalnızca [start] ile verilen
/// sahibin (oturum açık kullanıcı; misafirde `null` → kurulum) kayıtlarını
/// gösterir; arşiv başka ekrandan değişince kendini yeniler.
@injectable
class RouteExportsCubit extends Cubit<RouteExportsState> {
  RouteExportsCubit(
    this._getExports,
    this._open,
    this._shareLink,
    this._delete,
    this._watch,
  ) : super(const RouteExportsState());

  final GetRouteExportsUseCase _getExports;
  final OpenRouteExportUseCase _open;
  final CreateRouteExportShareLinkUseCase _shareLink;
  final DeleteRouteExportUseCase _delete;
  final WatchRouteExportChangesUseCase _watch;

  /// [start] çağrılana kadar `false`; misafirin sahibi `null`dır.
  bool _started = false;
  String? _ownerId;
  StreamSubscription<String?>? _changes;

  /// Eski sahibin veya eski isteğin yanıtı yenisinin üzerine yazmaz.
  int _request = 0;

  Future<void> start(String? ownerId) async {
    if (!_started || _ownerId != ownerId) {
      _started = true;
      _ownerId = ownerId;
      final previous = _changes;
      _changes = _watch().where((owner) => owner == ownerId).listen((_) {
        unawaited(_reload());
      });
      await previous?.cancel();
      if (isClosed) {
        return;
      }
    }
    emit(state.copyWith(status: RouteExportsStatus.loading, failure: null));
    await _reload();
  }

  Future<void> _reload() async {
    if (!_started) {
      return;
    }
    final ownerId = _ownerId;
    final request = ++_request;
    final result = await _getExports(ownerId);
    if (isClosed || request != _request || ownerId != _ownerId) {
      return;
    }
    emit(
      result.fold(
        (failure) => state.copyWith(
          status: RouteExportsStatus.failure,
          failure: failure,
        ),
        (items) => state.copyWith(
          status: RouteExportsStatus.ready,
          items: items,
          failure: null,
        ),
      ),
    );
  }

  /// Dosyayı okur; okunamazsa `null` ve [RouteExportsState.actionFailure].
  Future<RouteExportFile?> open(String exportId) async {
    if (!_started) {
      return null;
    }
    final result = await _open(
      RouteExportRef(ownerId: _ownerId, exportId: exportId),
    );
    if (isClosed) {
      return null;
    }
    return result.fold((failure) {
      emit(state.copyWith(actionFailure: failure));
      return null;
    }, (file) => file);
  }

  /// Paylaşılabilir bağlantı; sonucu (hata dahil) çağıran bildirir.
  Future<Result<RouteExportLink>> shareLink(String exportId) async {
    if (!_started) {
      return const Left(UnexpectedFailure());
    }
    return _shareLink(RouteExportRef(ownerId: _ownerId, exportId: exportId));
  }

  Future<void> delete(String exportId) async {
    if (!_started) {
      return;
    }
    final result = await _delete(
      RouteExportRef(ownerId: _ownerId, exportId: exportId),
    );
    if (isClosed) {
      return;
    }
    result.fold(
      (failure) => emit(state.copyWith(actionFailure: failure)),
      (_) => emit(
        state.copyWith(
          items: [
            for (final item in state.items)
              if (item.id != exportId) item,
          ],
          deletions: state.deletions + 1,
          actionFailure: null,
        ),
      ),
    );
  }

  @override
  Future<void> close() async {
    await _changes?.cancel();
    return super.close();
  }
}
