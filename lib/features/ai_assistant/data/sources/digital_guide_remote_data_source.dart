import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/exceptions.dart';
import 'package:vakif_atlas/core/network/network_constants.dart';
import 'package:vakif_atlas/features/ai_assistant/data/dtos/guide_dtos.dart';

/// Assistant mikro servisinin uç noktaları. Oturum açıksa Bearer anahtarı
/// eklenir (`AuthInterceptor`) ancak zorunlu değildir; yanıt
/// `Accept-Language` dilinde üretilir.
abstract interface class DigitalGuideRemoteDataSource {
  Future<GuideReplyDto> ask(
    AskGuideRequestDto request, {
    required String languageCode,
  });

  Future<void> deleteConversation(String conversationId);
}

@LazySingleton(as: DigitalGuideRemoteDataSource)
class DigitalGuideRemoteDataSourceImpl implements DigitalGuideRemoteDataSource {
  DigitalGuideRemoteDataSourceImpl(@Named(DioNames.api) this._dio);

  final Dio _dio;

  @override
  Future<GuideReplyDto> ask(
    AskGuideRequestDto request, {
    required String languageCode,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      DigitalGuideEndpoints.messages,
      data: request.toJson(),
      options: Options(
        headers: {NetworkConstants.acceptLanguageHeader: languageCode},
      ),
    );
    return GuideReplyDto.fromJson(
      response.data ?? (throw const UnexpectedException('empty_body')),
    );
  }

  @override
  Future<void> deleteConversation(String conversationId) async {
    await _dio.delete<void>(DigitalGuideEndpoints.conversation(conversationId));
  }
}

abstract final class DigitalGuideEndpoints {
  static const String messages = 'assistant/messages';
  static const String conversations = 'assistant/conversations';

  static String conversation(String id) =>
      '$conversations/${Uri.encodeComponent(id)}';
}
