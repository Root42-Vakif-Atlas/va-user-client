import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/ai_assistant/domain/entities/guide_message.dart';

/// Dijital Rehber (Assistant mikro servisi). Yanıtlar sunucuda VGM
/// kataloğuna dayanılarak üretilir; misafir de soru sorabilir.
abstract interface class DigitalGuideRepository {
  /// [question] sorusunu sorar. [conversationId] önceki yanıttan gelir;
  /// `null` → yeni sohbet.
  ResultFuture<GuideReply> ask({
    required String question,
    required String languageCode,
    String? conversationId,
  });

  /// Sohbeti sunucuda siler (kullanıcı "Yeni sohbet" dediğinde).
  ResultFuture<void> endConversation(String conversationId);
}
