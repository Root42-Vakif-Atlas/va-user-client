import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/exceptions.dart';
import 'package:vakif_atlas/core/network/network_constants.dart';
import 'package:vakif_atlas/features/gamification/data/dtos/gamification_dtos.dart';

/// Gamification mikro servisinin uç noktaları (Bearer zorunlu). Rozet ve
/// seviye adları `Accept-Language` dilinde gelir.
abstract interface class GamificationRemoteDataSource {
  Future<GamificationProfileDto> getProfile({required String languageCode});

  Future<void> acknowledge(List<String> ids);
}

@LazySingleton(as: GamificationRemoteDataSource)
class GamificationRemoteDataSourceImpl implements GamificationRemoteDataSource {
  GamificationRemoteDataSourceImpl(@Named(DioNames.api) this._dio);

  final Dio _dio;

  @override
  Future<GamificationProfileDto> getProfile({
    required String languageCode,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      GamificationEndpoints.me,
      options: Options(
        headers: {NetworkConstants.acceptLanguageHeader: languageCode},
      ),
    );
    return GamificationProfileDto.fromJson(
      response.data ?? (throw const UnexpectedException('empty_body')),
    );
  }

  @override
  Future<void> acknowledge(List<String> ids) async {
    await _dio.post<void>(
      GamificationEndpoints.acknowledgements,
      data: {'ids': ids},
    );
  }
}

abstract final class GamificationEndpoints {
  static const String me = 'gamification/me';
  static const String acknowledgements = 'gamification/me/acknowledgements';
}
