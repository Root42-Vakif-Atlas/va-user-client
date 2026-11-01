import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/exceptions.dart';
import 'package:vakif_atlas/core/network/network_constants.dart';
import 'package:vakif_atlas/core/storage/installation_id_service.dart';
import 'package:vakif_atlas/features/route_planner/data/dtos/route_dtos.dart';

/// Rota mikro servisinin uç noktaları.
///
/// Sahiplik sunucudadır: oturum açıksa rotalar hesaba aittir (Bearer,
/// süresi dolmuşsa yenilenir), misafirde anonim kuruluma
/// (`X-Installation-Id`, her istekte). Girişte kurulumun misafir rotaları
/// hesaba taşınır. Hatalar `DioException`
/// (içinde `AppException`) veya bozuk gövdede `CheckedFromJsonException`
/// / `FormatException` olarak fırlatılır.
abstract interface class RouteRemoteDataSource {
  Future<List<RouteOverviewDto>> fetchRoutes({required String languageCode});

  Future<TravelRouteDto> fetchRoute({
    required String id,
    required String languageCode,
  });

  Future<TravelRouteDto> createRoute({
    required RoutePlanRequestDto plan,
    required String languageCode,
  });

  Future<TravelRouteDto> updateRoute({
    required String id,
    required RoutePlanRequestDto plan,
    required String languageCode,
  });

  Future<void> deleteRoute({required String id});
}

@LazySingleton(as: RouteRemoteDataSource)
class RouteRemoteDataSourceImpl implements RouteRemoteDataSource {
  RouteRemoteDataSourceImpl(@Named(DioNames.api) this._dio, this._installation);

  final Dio _dio;
  final InstallationIdService _installation;

  @override
  Future<List<RouteOverviewDto>> fetchRoutes({
    required String languageCode,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      RouteEndpoints.routes,
      options: await _options(languageCode),
    );
    return RouteListResponseDto.fromJson(_body(response)).items;
  }

  @override
  Future<TravelRouteDto> fetchRoute({
    required String id,
    required String languageCode,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      RouteEndpoints.route(id),
      options: await _options(languageCode),
    );
    return TravelRouteDto.fromJson(_body(response));
  }

  @override
  Future<TravelRouteDto> createRoute({
    required RoutePlanRequestDto plan,
    required String languageCode,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      RouteEndpoints.routes,
      data: plan.toJson(),
      options: await _options(languageCode),
    );
    return TravelRouteDto.fromJson(_body(response));
  }

  @override
  Future<TravelRouteDto> updateRoute({
    required String id,
    required RoutePlanRequestDto plan,
    required String languageCode,
  }) async {
    final response = await _dio.put<Map<String, dynamic>>(
      RouteEndpoints.route(id),
      data: plan.toJson(),
      options: await _options(languageCode),
    );
    return TravelRouteDto.fromJson(_body(response));
  }

  @override
  Future<void> deleteRoute({required String id}) async {
    await _dio.delete<void>(
      RouteEndpoints.route(id),
      options: await _options(null),
    );
  }

  /// Bearer'ı `AuthInterceptor` ekler (oturum yoksa eklenmez).
  Future<Options> _options(String? languageCode) async => Options(
    headers: {
      NetworkConstants.installationIdHeader: await _installation.resolve(),
      NetworkConstants.acceptLanguageHeader: ?languageCode,
    },
  );

  static Map<String, dynamic> _body(Response<Map<String, dynamic>> response) =>
      response.data ?? (throw const UnexpectedException('empty_body'));
}

abstract final class RouteEndpoints {
  static const String routes = 'routes';

  static String route(String id) => '$routes/${Uri.encodeComponent(id)}';
}
