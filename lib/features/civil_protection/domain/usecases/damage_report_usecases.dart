import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/usecase/usecase.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/civil_protection/domain/entities/damage_report.dart';
import 'package:vakif_atlas/features/civil_protection/domain/entities/damage_report_draft.dart';
import 'package:vakif_atlas/features/civil_protection/domain/repositories/damage_report_repository.dart';

final class GetDamageReportsParams {
  const GetDamageReportsParams({
    required this.languageCode,
    this.limit = DamageReportRules.pageSize,
    this.cursor,
  });

  final String languageCode;
  final int limit;
  final String? cursor;

  @override
  bool operator ==(Object other) =>
      other is GetDamageReportsParams &&
      other.languageCode == languageCode &&
      other.limit == limit &&
      other.cursor == cursor;

  @override
  int get hashCode =>
      Object.hash(GetDamageReportsParams, languageCode, limit, cursor);
}

/// Kullanıcının raporları, en yeni önce.
class GetDamageReportsUseCase
    implements UseCase<DamageReportPage, GetDamageReportsParams> {
  const GetDamageReportsUseCase(this._repository);

  final DamageReportRepository _repository;

  @override
  ResultFuture<DamageReportPage> call(GetDamageReportsParams params) =>
      _repository.getReports(
        limit: params.limit,
        languageCode: params.languageCode,
        cursor: params.cursor,
      );
}

final class GetDamageReportParams {
  const GetDamageReportParams({required this.id, required this.languageCode});

  final String id;
  final String languageCode;

  @override
  bool operator ==(Object other) =>
      other is GetDamageReportParams &&
      other.id == id &&
      other.languageCode == languageCode;

  @override
  int get hashCode => Object.hash(GetDamageReportParams, id, languageCode);
}

class GetDamageReportUseCase
    implements UseCase<DamageReport, GetDamageReportParams> {
  const GetDamageReportUseCase(this._repository);

  final DamageReportRepository _repository;

  @override
  ResultFuture<DamageReport> call(GetDamageReportParams params) =>
      _repository.getReport(id: params.id, languageCode: params.languageCode);
}

final class SubmitDamageReportParams {
  const SubmitDamageReportParams({
    required this.draft,
    required this.languageCode,
    this.onProgress,
  });

  final DamageReportDraft draft;
  final String languageCode;
  final void Function(double progress)? onProgress;
}

/// Raporu gönderir. Kurallara uymayan rapor sunucuya gönderilmez.
class SubmitDamageReportUseCase
    implements UseCase<DamageReport, SubmitDamageReportParams> {
  const SubmitDamageReportUseCase(this._repository);

  final DamageReportRepository _repository;

  @override
  ResultFuture<DamageReport> call(SubmitDamageReportParams params) async {
    final draft = params.draft;
    if (DamageReportRules.validate(draft) != null) {
      return const Left(
        ServerFailure(kind: ServerFailureKind.invalidRequest, statusCode: 400),
      );
    }
    return _repository.submitReport(
      DamageReportDraft(
        monumentId: draft.monumentId,
        category: draft.category,
        urgency: draft.urgency,
        description: draft.description.trim(),
        photos: [
          for (final photo in draft.photos)
            photo.withDescription(photo.description.trim()),
        ],
        location: draft.location,
      ),
      languageCode: params.languageCode,
      onProgress: params.onProgress,
    );
  }
}

class WatchSubmittedReportsUseCase
    implements StreamUseCase<DamageReport, NoParams> {
  const WatchSubmittedReportsUseCase(this._repository);

  final DamageReportRepository _repository;

  @override
  Stream<DamageReport> call(NoParams params) => _repository.submitted;
}
