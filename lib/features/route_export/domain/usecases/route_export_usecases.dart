import 'package:vakif_atlas/core/usecase/usecase.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/route_export/domain/entities/route_document.dart';
import 'package:vakif_atlas/features/route_export/domain/entities/route_export.dart';
import 'package:vakif_atlas/features/route_export/domain/repositories/route_export_repository.dart';

final class CreateRouteExportParams {
  const CreateRouteExportParams({required this.document, this.ownerId});

  final RouteDocument document;

  /// Oturum açık kullanıcı; misafirde `null` (kurulumun arşivi).
  final String? ownerId;

  @override
  bool operator ==(Object other) =>
      other is CreateRouteExportParams &&
      other.document == document &&
      other.ownerId == ownerId;

  @override
  int get hashCode => Object.hash(document, ownerId);
}

class CreateRouteExportUseCase
    implements UseCase<RouteExportFile, CreateRouteExportParams> {
  const CreateRouteExportUseCase(this._repository);

  final RouteExportRepository _repository;

  @override
  ResultFuture<RouteExportFile> call(CreateRouteExportParams params) =>
      _repository.createExport(
        document: params.document,
        ownerId: params.ownerId,
      );
}

class GetRouteExportsUseCase implements UseCase<List<RouteExport>, String?> {
  const GetRouteExportsUseCase(this._repository);

  final RouteExportRepository _repository;

  @override
  ResultFuture<List<RouteExport>> call(String? ownerId) =>
      _repository.getExports(ownerId);
}

final class RouteExportRef {
  const RouteExportRef({required this.ownerId, required this.exportId});

  /// Misafirde `null`.
  final String? ownerId;
  final String exportId;

  @override
  bool operator ==(Object other) =>
      other is RouteExportRef &&
      other.ownerId == ownerId &&
      other.exportId == exportId;

  @override
  int get hashCode => Object.hash(ownerId, exportId);
}

class OpenRouteExportUseCase
    implements UseCase<RouteExportFile, RouteExportRef> {
  const OpenRouteExportUseCase(this._repository);

  final RouteExportRepository _repository;

  @override
  ResultFuture<RouteExportFile> call(RouteExportRef ref) =>
      _repository.openExport(ownerId: ref.ownerId, exportId: ref.exportId);
}

class CreateRouteExportShareLinkUseCase
    implements UseCase<RouteExportLink, RouteExportRef> {
  const CreateRouteExportShareLinkUseCase(this._repository);

  final RouteExportRepository _repository;

  @override
  ResultFuture<RouteExportLink> call(RouteExportRef ref) =>
      _repository.createShareLink(ownerId: ref.ownerId, exportId: ref.exportId);
}

class DeleteRouteExportUseCase implements UseCase<Unit, RouteExportRef> {
  const DeleteRouteExportUseCase(this._repository);

  final RouteExportRepository _repository;

  @override
  ResultFuture<Unit> call(RouteExportRef ref) =>
      _repository.deleteExport(ownerId: ref.ownerId, exportId: ref.exportId);
}

class WatchRouteExportChangesUseCase {
  const WatchRouteExportChangesUseCase(this._repository);

  final RouteExportRepository _repository;

  Stream<String?> call() => _repository.changes;
}
