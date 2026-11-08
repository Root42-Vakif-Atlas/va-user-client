import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/ai_assistant/data/repositories/digital_guide_repository_impl.dart';
import 'package:vakif_atlas/features/ai_assistant/domain/catalog_guide/catalog_guide.dart';
import 'package:vakif_atlas/features/ai_assistant/domain/entities/guide_message.dart';
import 'package:vakif_atlas/features/ai_assistant/domain/repositories/digital_guide_repository.dart';

/// Dijital Rehber: eser soruları katalogdan, uygulama soruları Asistan
/// servisinden yanıtlanır.
///
/// Eser, il, yapı türü ve listeleme soruları [CatalogGuide] ile doğrudan
/// Catalog API'sinden yanıtlanır (rehberin yanıtı uygulamanın gösterdiği
/// katalogla her zaman aynıdır). Rota, hasar, acil durum, ayarlar, anılar
/// ve sohbet soruları Asistan servisine gider.
///
/// Sohbet kimliği istemcide üretilir; Asistan servisinin sohbet kimliği ve
/// son konuşulan eser (takip soruları için) bu kimlikle eşlenir.
@LazySingleton(as: DigitalGuideRepository)
class CatalogAwareDigitalGuideRepository implements DigitalGuideRepository {
  CatalogAwareDigitalGuideRepository(this._server, this._catalog);

  final DigitalGuideRepositoryImpl _server;
  final CatalogGuide _catalog;

  final Map<String, _Session> _sessions = {};
  var _sessionCount = 0;

  @override
  ResultFuture<GuideReply> ask({
    required String question,
    required String languageCode,
    String? conversationId,
  }) async {
    final id = conversationId ?? _newId();
    // Bilinmeyen kimlik (ör. Asistan servisinin verdiği) sunucu sohbetidir.
    final session = _sessions.putIfAbsent(
      id,
      () => _Session(serverId: conversationId),
    );

    final local = await _catalog.answer(
      question,
      languageCode: languageCode,
      focus: session.focus,
    );
    if (local != null) {
      return local.map((answer) {
        session.focus = answer.focus ?? session.focus;
        return GuideReply(conversationId: id, message: answer.message);
      });
    }

    final reply = await _server.ask(
      question: question,
      languageCode: languageCode,
      conversationId: session.serverId,
    );
    return reply.map((reply) {
      session.serverId = reply.conversationId;
      return GuideReply(conversationId: id, message: reply.message);
    });
  }

  @override
  ResultFuture<void> endConversation(String conversationId) async {
    final session = _sessions.remove(conversationId);
    final serverId = session == null ? conversationId : session.serverId;
    if (serverId == null) {
      return const Right<Failure, void>(null);
    }
    return _server.endConversation(serverId);
  }

  String _newId() =>
      'guide_${DateTime.now().microsecondsSinceEpoch}_${++_sessionCount}';
}

final class _Session {
  _Session({this.serverId});

  String? serverId;
  GuideMonumentRef? focus;
}
