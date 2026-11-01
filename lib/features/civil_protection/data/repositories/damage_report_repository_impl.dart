import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/error_mapper.dart';
import 'package:vakif_atlas/core/events/user_activity_events.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/civil_protection/data/dtos/damage_report_dtos.dart';
import 'package:vakif_atlas/features/civil_protection/data/sources/damage_report_remote_data_source.dart';
import 'package:vakif_atlas/features/civil_protection/domain/entities/damage_report.dart';
import 'package:vakif_atlas/features/civil_protection/domain/entities/damage_report_draft.dart';
import 'package:vakif_atlas/features/civil_protection/domain/repositories/damage_report_repository.dart';

/// Gönderim akışı uygulama ömrü boyunca açıktır (singleton).
@LazySingleton(as: DamageReportRepository)
class DamageReportRepositoryImpl implements DamageReportRepository {
  DamageReportRepositoryImpl(this._remote, this._activity);

  final DamageReportRemoteDataSource _remote;

  /// Başarılı katkı oyunlaştırmaya duyurulur.
  final UserActivityEvents _activity;
  final StreamController<DamageReport> _submitted =
      StreamController<DamageReport>.broadcast();

  @override
  Stream<DamageReport> get submitted => _submitted.stream;

  @override
  ResultFuture<DamageReportPage> getReports({
    required int limit,
    required String languageCode,
    String? cursor,
  }) => _guard(() async {
    final page = await _remote.fetchReports(
      limit: limit,
      languageCode: languageCode,
      cursor: cursor,
    );
    return page.toDomain();
  });

  @override
  ResultFuture<DamageReport> getReport({
    required String id,
    required String languageCode,
  }) => _guard(() async {
    final report = await _remote.fetchReport(
      id: id,
      languageCode: languageCode,
    );
    return report.toDomain();
  });

  /// Fotoğraflar sırayla yüklenir, ilerleme toplam bayta göre hesaplanır;
  /// rapor ancak tüm yüklemeler bitince gönderilir.
  @override
  ResultFuture<DamageReport> submitReport(
    DamageReportDraft draft, {
    required String languageCode,
    void Function(double progress)? onProgress,
  }) => _guard(() async {
    final totalBytes = draft.photos.fold(
      0,
      (sum, photo) => sum + photo.bytes.length,
    );
    var uploadedBytes = 0;
    void report(int bytes) {
      if (onProgress != null && totalBytes > 0) {
        onProgress((bytes / totalBytes).clamp(0, 1).toDouble());
      }
    }

    final attachments = <ReportPhotoAttachmentDto>[];
    for (final photo in draft.photos) {
      final ticket = await _remote.requestPhotoUpload(
        ReportPhotoUploadRequestDto(
          contentType: DamageReportEndpoints.photoContentType,
          byteSize: photo.bytes.length,
          width: photo.width,
          height: photo.height,
        ),
      );
      final offset = uploadedBytes;
      await _remote.uploadPhoto(
        ticket,
        photo.bytes,
        onSendProgress: (sent, _) => report(offset + sent),
      );
      uploadedBytes += photo.bytes.length;
      report(uploadedBytes);
      attachments.add(
        ReportPhotoAttachmentDto(
          uploadId: ticket.id,
          description: photo.description.isEmpty ? null : photo.description,
        ),
      );
    }

    final location = draft.location;
    final created = await _remote.submitReport(
      SubmitDamageReportRequestDto(
        monumentId: draft.monumentId!,
        category: draft.category!,
        urgency: draft.urgency!,
        description: draft.description,
        photos: attachments,
        location: location == null
            ? null
            : ReportLocationDto.fromDomain(location),
      ),
      languageCode: languageCode,
    );
    final entity = created.toDomain();
    _submitted.add(entity);
    _activity.notifyContribution();
    return entity;
  });

  static ResultFuture<T> _guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on Exception catch (error) {
      return Left(ErrorMapper.toFailure(error));
    }
  }
}
