import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/network/network_constants.dart';
import 'package:vakif_atlas/features/feedback/data/dtos/feedback_dtos.dart';

/// `POST feedback` (giriş gerekmez; oturum açıksa Bearer'ı `AuthInterceptor`
/// ekler). Hatalar `DioException` (içinde `AppException`) olarak fırlatılır.
abstract interface class FeedbackRemoteDataSource {
  Future<void> submit(FeedbackRequestDto request);
}

@LazySingleton(as: FeedbackRemoteDataSource)
class FeedbackRemoteDataSourceImpl implements FeedbackRemoteDataSource {
  FeedbackRemoteDataSourceImpl(@Named(DioNames.api) this._dio);

  final Dio _dio;

  @override
  Future<void> submit(FeedbackRequestDto request) async {
    await _dio.post<void>(FeedbackEndpoints.feedback, data: request.toJson());
  }
}

abstract final class FeedbackEndpoints {
  static const String feedback = 'feedback';
}
