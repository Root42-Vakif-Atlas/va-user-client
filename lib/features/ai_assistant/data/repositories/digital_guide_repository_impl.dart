import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/error_mapper.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/ai_assistant/data/dtos/guide_dtos.dart';
import 'package:vakif_atlas/features/ai_assistant/data/sources/digital_guide_remote_data_source.dart';
import 'package:vakif_atlas/features/ai_assistant/domain/entities/guide_message.dart';
import 'package:vakif_atlas/features/ai_assistant/domain/repositories/digital_guide_repository.dart';

/// Sohbet geçmişi cihazda saklanmaz; bağlam sunucudaki sohbettedir.
@LazySingleton(as: DigitalGuideRepository)
class DigitalGuideRepositoryImpl implements DigitalGuideRepository {
  DigitalGuideRepositoryImpl(this._remote);

  final DigitalGuideRemoteDataSource _remote;

  @override
  ResultFuture<GuideReply> ask({
    required String question,
    required String languageCode,
    String? conversationId,
  }) => _guard(() async {
    final reply = await _remote.ask(
      AskGuideRequestDto(message: question, conversationId: conversationId),
      languageCode: languageCode,
    );
    return reply.toDomain();
  });

  @override
  ResultFuture<void> endConversation(String conversationId) =>
      _guard(() => _remote.deleteConversation(conversationId));

  static ResultFuture<T> _guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on Exception catch (error) {
      return Left(ErrorMapper.toFailure(error));
    }
  }
}
