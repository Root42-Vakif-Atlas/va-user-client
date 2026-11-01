import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/usecase/usecase.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/ai_assistant/domain/entities/guide_message.dart';
import 'package:vakif_atlas/features/ai_assistant/domain/repositories/digital_guide_repository.dart';

final class AskGuideParams {
  const AskGuideParams({
    required this.question,
    required this.languageCode,
    this.conversationId,
  });

  final String question;
  final String languageCode;
  final String? conversationId;

  @override
  bool operator ==(Object other) =>
      other is AskGuideParams &&
      other.question == question &&
      other.languageCode == languageCode &&
      other.conversationId == conversationId;

  @override
  int get hashCode =>
      Object.hash(AskGuideParams, question, languageCode, conversationId);

  /// Soru kullanıcı içeriğidir; loglara yazılmaz.
  @override
  String toString() => 'AskGuideParams(${question.length} chars)';
}

/// Rehbere soru sorar. Geçersiz soru sunucuya gönderilmez.
class AskGuideUseCase implements UseCase<GuideReply, AskGuideParams> {
  const AskGuideUseCase(this._repository);

  final DigitalGuideRepository _repository;

  @override
  ResultFuture<GuideReply> call(AskGuideParams params) async {
    if (GuideRules.validate(params.question) != null) {
      return const Left(ServerFailure(kind: ServerFailureKind.invalidRequest));
    }
    return _repository.ask(
      question: params.question.trim(),
      languageCode: params.languageCode,
      conversationId: params.conversationId,
    );
  }
}

/// Sohbeti sunucuda siler.
class EndGuideConversationUseCase implements UseCase<void, String> {
  const EndGuideConversationUseCase(this._repository);

  final DigitalGuideRepository _repository;

  @override
  ResultFuture<void> call(String conversationId) =>
      _repository.endConversation(conversationId);
}
