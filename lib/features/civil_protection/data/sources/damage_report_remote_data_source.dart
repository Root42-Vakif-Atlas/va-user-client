import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/exceptions.dart';
import 'package:vakif_atlas/core/network/network_constants.dart';
import 'package:vakif_atlas/features/civil_protection/data/dtos/damage_report_dtos.dart';

/// Civil Protection mikro servisinin uç noktaları. Tüm istekler Bearer
/// anahtarıyla gider (`AuthInterceptor`); fotoğraflar ön imzalı adrese
/// kimlik bilgisi taşımayan istemciyle yüklenir. Eser adları
/// `Accept-Language` dilinde döner.
abstract interface class DamageReportRemoteDataSource {
  Future<DamageReportPageDto> fetchReports({
    required int limit,
    required String languageCode,
    String? cursor,
  });

  Future<DamageReportDto> fetchReport({
    required String id,
    required String languageCode,
  });

  Future<ReportPhotoUploadTicketDto> requestPhotoUpload(
    ReportPhotoUploadRequestDto request,
  );

  Future<void> uploadPhoto(
    ReportPhotoUploadTicketDto ticket,
    Uint8List bytes, {
    void Function(int sent, int total)? onSendProgress,
  });

  Future<DamageReportDto> submitReport(
    SubmitDamageReportRequestDto request, {
    required String languageCode,
  });
}

@LazySingleton(as: DamageReportRemoteDataSource)
class DamageReportRemoteDataSourceImpl implements DamageReportRemoteDataSource {
  DamageReportRemoteDataSourceImpl(
    @Named(DioNames.api) this._dio,
    @Named(DioNames.storage) this._storage,
  );

  final Dio _dio;
  final Dio _storage;

  @override
  Future<DamageReportPageDto> fetchReports({
    required int limit,
    required String languageCode,
    String? cursor,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      DamageReportEndpoints.reports,
      queryParameters: {'limit': limit, 'cursor': ?cursor},
      options: _language(languageCode),
    );
    return DamageReportPageDto.fromJson(_body(response));
  }

  @override
  Future<DamageReportDto> fetchReport({
    required String id,
    required String languageCode,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      DamageReportEndpoints.report(id),
      options: _language(languageCode),
    );
    return DamageReportDto.fromJson(_body(response));
  }

  @override
  Future<ReportPhotoUploadTicketDto> requestPhotoUpload(
    ReportPhotoUploadRequestDto request,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      DamageReportEndpoints.photoUploads,
      data: request.toJson(),
    );
    return ReportPhotoUploadTicketDto.fromJson(_body(response));
  }

  @override
  Future<void> uploadPhoto(
    ReportPhotoUploadTicketDto ticket,
    Uint8List bytes, {
    void Function(int sent, int total)? onSendProgress,
  }) async {
    await _storage.put<void>(
      ticket.uploadUrl,
      data: bytes,
      onSendProgress: onSendProgress,
      options: Options(
        contentType: DamageReportEndpoints.photoContentType,
        headers: ticket.uploadHeaders,
        responseType: ResponseType.plain,
      ),
    );
  }

  @override
  Future<DamageReportDto> submitReport(
    SubmitDamageReportRequestDto request, {
    required String languageCode,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      DamageReportEndpoints.reports,
      data: request.toJson(),
      options: _language(languageCode),
    );
    return DamageReportDto.fromJson(_body(response));
  }

  static Options _language(String languageCode) =>
      Options(headers: {NetworkConstants.acceptLanguageHeader: languageCode});

  static Map<String, dynamic> _body(Response<Map<String, dynamic>> response) =>
      response.data ?? (throw const UnexpectedException('empty_body'));
}

abstract final class DamageReportEndpoints {
  static const String reports = 'civil-protection/reports';
  static const String photoUploads = 'civil-protection/photo-uploads';
  static const String photoContentType = 'image/jpeg';

  static String report(String id) => '$reports/${Uri.encodeComponent(id)}';
}
