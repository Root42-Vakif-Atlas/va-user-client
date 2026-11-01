import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/exceptions.dart';
import 'package:vakif_atlas/core/network/network_constants.dart';
import 'package:vakif_atlas/core/storage/installation_id_service.dart';
import 'package:vakif_atlas/features/route_export/data/dtos/route_export_dtos.dart';

/// Sunucudaki PDF arşivi (media servisi).
///
/// Rotalar gibi: oturum açıksa arşiv hesaba aittir (Bearer), misafirde
/// kuruluma (`X-Installation-Id`, her API isteğinde); girişte kurulumun
/// misafir dışa aktarımları hesaba taşınır.
///
/// Yükleme üç adımdır: kayıt + ön imzalı adres → nesne deposuna `PUT`
/// (kimlik bilgisi taşımayan istemciyle) → `complete`. Hatalar
/// `DioException` (içinde `AppException`) veya bozuk gövdede
/// `CheckedFromJsonException` olarak fırlatılır.
abstract interface class RouteExportRemoteDataSource {
  Future<RouteExportRecordDto> upload(
    RouteExportUploadRequestDto request,
    Uint8List bytes,
  );

  Future<RouteExportPageDto> fetchExports({required int limit, String? cursor});

  Future<Uint8List> download(String id);

  /// Tarayıcıda açılan, uzun ömürlü (7 gün) ön imzalı adres.
  Future<RouteExportDownloadDto> createShareLink(String id);

  Future<void> delete(String id);
}

@LazySingleton(as: RouteExportRemoteDataSource)
class RouteExportRemoteDataSourceImpl implements RouteExportRemoteDataSource {
  RouteExportRemoteDataSourceImpl(
    @Named(DioNames.api) this._dio,
    @Named(DioNames.storage) this._storage,
    this._installation,
  );

  final Dio _dio;
  final Dio _storage;
  final InstallationIdService _installation;

  @override
  Future<RouteExportRecordDto> upload(
    RouteExportUploadRequestDto request,
    Uint8List bytes,
  ) async {
    final ticket = RouteExportUploadTicketDto.fromJson(
      _body(
        await _dio.post<Map<String, dynamic>>(
          RouteExportEndpoints.exports,
          data: request.toJson(),
          options: await _options(),
        ),
      ),
    );
    try {
      await _storage.put<void>(
        ticket.uploadUrl,
        data: bytes,
        options: Options(
          contentType: RouteExportEndpoints.pdfContentType,
          headers: ticket.uploadHeaders,
          responseType: ResponseType.plain,
        ),
      );
      final response = await _dio.post<Map<String, dynamic>>(
        RouteExportEndpoints.complete(ticket.id),
        options: await _options(),
      );
      return RouteExportRecordDto.fromJson(_body(response));
    } on DioException {
      // Tamamlanmayan kayıt sunucuda bekleyen bilet olarak kalmasın (sahip
      // başına bekleyen sınırı dolmasın); temizlik en iyi çabadır.
      await _discard(ticket.id);
      rethrow;
    }
  }

  @override
  Future<RouteExportPageDto> fetchExports({
    required int limit,
    String? cursor,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      RouteExportEndpoints.exports,
      queryParameters: {'limit': limit, 'cursor': ?cursor},
      options: await _options(),
    );
    return RouteExportPageDto.fromJson(_body(response));
  }

  @override
  Future<Uint8List> download(String id) async {
    final link = RouteExportDownloadDto.fromJson(
      _body(
        await _dio.get<Map<String, dynamic>>(
          RouteExportEndpoints.download(id),
          options: await _options(),
        ),
      ),
    );
    final response = await _storage.get<List<int>>(
      link.url,
      options: Options(responseType: ResponseType.bytes),
    );
    final data = response.data;
    if (data == null || data.isEmpty) {
      throw const UnexpectedException('empty_body');
    }
    return Uint8List.fromList(data);
  }

  @override
  Future<RouteExportDownloadDto> createShareLink(String id) async =>
      RouteExportDownloadDto.fromJson(
        _body(
          await _dio.post<Map<String, dynamic>>(
            RouteExportEndpoints.shareLink(id),
            options: await _options(),
          ),
        ),
      );

  Future<void> _discard(String id) async {
    try {
      await delete(id);
    } on DioException {
      // Sunucu bekleyen kaydı süre dolunca kendisi temizler.
    }
  }

  @override
  Future<void> delete(String id) async {
    await _dio.delete<void>(
      RouteExportEndpoints.export(id),
      options: await _options(),
    );
  }

  /// Bearer'ı `AuthInterceptor` ekler (oturum yoksa eklenmez). Nesne
  /// deposu istekleri (`_storage`) kurulum kimliği taşımaz.
  Future<Options> _options() async => Options(
    headers: {
      NetworkConstants.installationIdHeader: await _installation.resolve(),
    },
  );

  static Map<String, dynamic> _body(Response<Map<String, dynamic>> response) =>
      response.data ?? (throw const UnexpectedException('empty_body'));
}

abstract final class RouteExportEndpoints {
  static const String exports = 'route-exports';
  static const String pdfContentType = 'application/pdf';

  static String export(String id) => '$exports/${Uri.encodeComponent(id)}';

  static String complete(String id) => '${export(id)}/complete';

  static String download(String id) => '${export(id)}/download';

  static String shareLink(String id) => '${export(id)}/share-link';
}
