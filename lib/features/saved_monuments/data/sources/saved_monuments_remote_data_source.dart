import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/exceptions.dart';
import 'package:vakif_atlas/core/network/network_constants.dart';
import 'package:vakif_atlas/core/storage/installation_id_service.dart';
import 'package:vakif_atlas/features/saved_monuments/data/dtos/saved_monument_dtos.dart';

/// Sunucudaki kaydedilen eserler (`saved-monuments`).
///
/// Rotalar gibi: oturum açıksa küme hesaba aittir (Bearer), misafirde
/// kuruluma (`X-Installation-Id`, her istekte); girişte kurulumun misafir
/// kümesi hesabınkiyle birleştirilir. Hatalar `DioException` (içinde
/// `AppException`) veya bozuk gövdede `CheckedFromJsonException` olarak
/// fırlatılır.
abstract interface class SavedMonumentsRemoteDataSource {
  /// En son kaydedilen önce.
  Future<List<SavedMonumentDto>> fetch();

  /// Kümeyi tümüyle değiştirir; sunucunun sakladığı listeyi döner.
  Future<List<SavedMonumentDto>> replace(List<SavedMonumentDto> items);
}

@LazySingleton(as: SavedMonumentsRemoteDataSource)
class SavedMonumentsRemoteDataSourceImpl
    implements SavedMonumentsRemoteDataSource {
  SavedMonumentsRemoteDataSourceImpl(
    @Named(DioNames.api) this._dio,
    this._installation,
  );

  final Dio _dio;
  final InstallationIdService _installation;

  @override
  Future<List<SavedMonumentDto>> fetch() async {
    final response = await _dio.get<Map<String, dynamic>>(
      SavedMonumentEndpoints.savedMonuments,
      options: await _options(),
    );
    return SavedMonumentListDto.fromJson(_body(response)).items;
  }

  @override
  Future<List<SavedMonumentDto>> replace(List<SavedMonumentDto> items) async {
    final response = await _dio.put<Map<String, dynamic>>(
      SavedMonumentEndpoints.savedMonuments,
      data: SavedMonumentListDto(items: items).toJson(),
      options: await _options(),
    );
    return SavedMonumentListDto.fromJson(_body(response)).items;
  }

  /// Bearer'ı `AuthInterceptor` ekler (oturum yoksa eklenmez).
  Future<Options> _options() async => Options(
    headers: {
      NetworkConstants.installationIdHeader: await _installation.resolve(),
    },
  );

  static Map<String, dynamic> _body(Response<Map<String, dynamic>> response) =>
      response.data ?? (throw const UnexpectedException('empty_body'));
}

abstract final class SavedMonumentEndpoints {
  static const String savedMonuments = 'saved-monuments';
}
