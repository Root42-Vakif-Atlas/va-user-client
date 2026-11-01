import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/exceptions.dart';
import 'package:vakif_atlas/core/network/network_constants.dart';
import 'package:vakif_atlas/features/memory_corner/data/dtos/memory_dtos.dart';

/// Memory mikro servisinin uç noktaları.
///
/// Liste herkese açıktır; oturum varsa Bearer anahtarı yine eklenir (sunucu
/// bildirilen anıları bildirene göstermez). Fotoğraflar ön imzalı adrese
/// ayrı, kimlik bilgisi taşımayan istemciyle yüklenir. Hatalar
/// `DioException` (içinde `AppException`) veya bozuk gövdede
/// `CheckedFromJsonException` / `FormatException` olarak fırlatılır.
abstract interface class MemoryRemoteDataSource {
  /// [from] / [to]: anı tarihi aralığı (`YYYY-MM-DD`, ikisi dahil).
  Future<MemoryPageDto> fetchMemories({
    required String monumentId,
    required int limit,
    String? cursor,
    String? from,
    String? to,
    bool includeFacets = false,
  });

  /// Kullanıcının kendi anıları, en son paylaşılan önce (tüm durumlar).
  Future<MemoryPageDto> fetchMyMemories({required int limit, String? cursor});

  Future<PhotoUploadTicketDto> requestPhotoUpload(
    PhotoUploadRequestDto request,
  );

  Future<void> uploadPhoto(
    PhotoUploadTicketDto ticket,
    Uint8List bytes, {
    void Function(int sent, int total)? onSendProgress,
  });

  Future<MemoryDto> createMemory(CreateMemoryRequestDto request);

  Future<void> deleteMemory(String id);

  Future<void> reportMemory(String id, MemoryReportRequestDto request);
}

@LazySingleton(as: MemoryRemoteDataSource)
class MemoryRemoteDataSourceImpl implements MemoryRemoteDataSource {
  MemoryRemoteDataSourceImpl(
    @Named(DioNames.api) this._dio,
    @Named(DioNames.storage) this._storage,
  );

  final Dio _dio;
  final Dio _storage;

  @override
  Future<MemoryPageDto> fetchMemories({
    required String monumentId,
    required int limit,
    String? cursor,
    String? from,
    String? to,
    bool includeFacets = false,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      MemoryEndpoints.memories,
      queryParameters: {
        'monumentId': monumentId,
        'limit': limit,
        'cursor': ?cursor,
        'from': ?from,
        'to': ?to,
        if (includeFacets) 'include': 'facets',
      },
    );
    return MemoryPageDto.fromJson(_body(response));
  }

  @override
  Future<MemoryPageDto> fetchMyMemories({
    required int limit,
    String? cursor,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      MemoryEndpoints.mine,
      queryParameters: {'limit': limit, 'cursor': ?cursor},
    );
    return MemoryPageDto.fromJson(_body(response));
  }

  @override
  Future<PhotoUploadTicketDto> requestPhotoUpload(
    PhotoUploadRequestDto request,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      MemoryEndpoints.photoUploads,
      data: request.toJson(),
    );
    return PhotoUploadTicketDto.fromJson(_body(response));
  }

  @override
  Future<void> uploadPhoto(
    PhotoUploadTicketDto ticket,
    Uint8List bytes, {
    void Function(int sent, int total)? onSendProgress,
  }) async {
    await _storage.put<void>(
      ticket.uploadUrl,
      data: bytes,
      onSendProgress: onSendProgress,
      options: Options(
        contentType: MemoryEndpoints.photoContentType,
        headers: ticket.uploadHeaders,
        responseType: ResponseType.plain,
      ),
    );
  }

  @override
  Future<MemoryDto> createMemory(CreateMemoryRequestDto request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      MemoryEndpoints.memories,
      data: request.toJson(),
    );
    return MemoryDto.fromJson(_body(response));
  }

  @override
  Future<void> deleteMemory(String id) async {
    await _dio.delete<void>(MemoryEndpoints.memory(id));
  }

  @override
  Future<void> reportMemory(String id, MemoryReportRequestDto request) async {
    await _dio.post<void>(MemoryEndpoints.reports(id), data: request.toJson());
  }

  static Map<String, dynamic> _body(Response<Map<String, dynamic>> response) =>
      response.data ?? (throw const UnexpectedException('empty_body'));
}

abstract final class MemoryEndpoints {
  static const String memories = 'memories';

  /// Oturum açık kullanıcının kendi anıları (Bearer zorunlu).
  static const String mine = 'memories/mine';
  static const String photoUploads = 'memories/photo-uploads';
  static const String photoContentType = 'image/jpeg';

  static String memory(String id) => '$memories/${Uri.encodeComponent(id)}';

  static String reports(String id) => '${memory(id)}/reports';
}
