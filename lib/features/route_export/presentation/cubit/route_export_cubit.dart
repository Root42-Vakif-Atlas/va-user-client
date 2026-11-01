import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/route_export/domain/entities/route_document.dart';
import 'package:vakif_atlas/features/route_export/domain/entities/route_export.dart';
import 'package:vakif_atlas/features/route_export/domain/usecases/route_export_usecases.dart';

part 'route_export_cubit.freezed.dart';

enum RouteExportStatus { idle, exporting, ready, failure }

@freezed
abstract class RouteExportState with _$RouteExportState {
  const factory RouteExportState({
    @Default(RouteExportStatus.idle) RouteExportStatus status,

    /// Son üretilen PDF.
    RouteExportFile? file,
    Failure? failure,
  }) = _RouteExportState;

  const RouteExportState._();

  bool get isExporting => status == RouteExportStatus.exporting;
}

/// Rota detayındaki "PDF olarak dışa aktar" (ekran bazlı, factory).
///
/// Üretim sürerken yeni istek yok sayılır (çift dokunuş tek dosya).
@injectable
class RouteExportCubit extends Cubit<RouteExportState> {
  RouteExportCubit(this._createExport, this._shareLink)
    : super(const RouteExportState());

  final CreateRouteExportUseCase _createExport;
  final CreateRouteExportShareLinkUseCase _shareLink;
  String? _ownerId;

  /// PDF sahibinin ([ownerId]; misafirde `null` → kurulum) arşivine de
  /// kaydedilir.
  Future<void> export(RouteDocument document, {String? ownerId}) async {
    if (state.isExporting) {
      return;
    }
    _ownerId = ownerId;
    emit(state.copyWith(status: RouteExportStatus.exporting, failure: null));
    final result = await _createExport(
      CreateRouteExportParams(document: document, ownerId: ownerId),
    );
    if (isClosed) {
      return;
    }
    emit(
      result.fold(
        (failure) =>
            state.copyWith(status: RouteExportStatus.failure, failure: failure),
        (file) => state.copyWith(status: RouteExportStatus.ready, file: file),
      ),
    );
  }

  /// Son üretilen ve arşive kaydedilen PDF'in paylaşılabilir bağlantısı.
  Future<Result<RouteExportLink>> shareLink() async {
    final saved = state.file?.saved;
    if (saved == null) {
      return const Left(UnexpectedFailure());
    }
    return _shareLink(RouteExportRef(ownerId: _ownerId, exportId: saved.id));
  }
}
