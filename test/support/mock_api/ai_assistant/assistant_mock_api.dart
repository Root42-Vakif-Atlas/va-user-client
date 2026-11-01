import 'dart:math';

import 'package:vakif_atlas/features/ai_assistant/data/sources/digital_guide_remote_data_source.dart';
import 'package:vakif_atlas/features/ai_assistant/domain/entities/guide_message.dart';

import '../catalog/catalog_fixtures.dart';
import '../mock_api.dart';
import 'mock_guide_engine.dart';

/// Assistant mikro servisinin mock implementasyonu
/// (`docs/api-contracts.md` → Dijital Rehber).
///
/// - Oturum gerekmez; yanıt `Accept-Language` dilinde (`tr` / `en`) üretilir.
/// - Yanıtları [MockGuideEngine] kurallarla ve mock katalog üzerinde arama
///   yaparak üretir (gerçek serviste RAG).
/// - Sohbet bağlamı (son konuşulan eser) sunucuda [conversationTtl] boyunca
///   tutulur; bilinmeyen veya süresi dolmuş kimlikle yeni sohbet açılır.
/// - Boş veya [GuideRules.maxQuestionLength]'ten uzun soru →
///   `400 {"code": "invalid_request"}`; sohbet başına dakikada
///   [maxQuestionsPerMinute] sorudan fazlası → `429`.
class AssistantMockApi implements MockApi {
  AssistantMockApi() : this.withClock(clock: DateTime.now);

  AssistantMockApi.withClock({
    required DateTime Function() clock,
    List<MockMonument> monuments = CatalogFixtures.monuments,
    Random? random,
  }) : _now = clock,
       _engine = MockGuideEngine(monuments),
       _random = random ?? Random.secure();

  final DateTime Function() _now;
  final MockGuideEngine _engine;
  final Random _random;

  static const Duration conversationTtl = Duration(minutes: 30);
  static const int maxQuestionsPerMinute = 20;
  static const int maxConversations = 100;

  static const Set<String> _supportedLanguages = {'tr', 'en'};

  final Map<String, _Conversation> _conversations = {};

  @override
  List<MockRoute> get routes => [
    MockRoute('POST', DigitalGuideEndpoints.messages, _ask),
    MockRoute(
      'DELETE',
      '${DigitalGuideEndpoints.conversations}/:id',
      _deleteConversation,
    ),
  ];

  MockResponse _ask(MockRequest request) {
    final message = request.field('message');
    final requestedId = request.field('conversationId');
    if (message is! String ||
        GuideRules.validate(message) != null ||
        (requestedId != null && requestedId is! String)) {
      return MockResponse.error(400, 'invalid_request');
    }
    final now = _now().toUtc();
    _expire(now);
    var id = requestedId as String?;
    var conversation = _conversations[id];
    if (conversation == null) {
      id = 'conv_${_randomHex(12)}';
      conversation = _conversations[id] = _Conversation();
    }
    final minuteAgo = now.subtract(const Duration(minutes: 1));
    conversation.questions.removeWhere((at) => at.isBefore(minuteAgo));
    if (conversation.questions.length >= maxQuestionsPerMinute) {
      return const MockResponse(
        429,
        body: {'code': 'too_many_requests', 'retryAfter': 60},
      );
    }
    conversation
      ..questions.add(now)
      ..updatedAt = now;

    final language = _language(request);
    final answer = _engine.answer(
      message.trim(),
      language: language,
      contextMonumentId: conversation.monumentId,
    );
    if (answer.focusMonumentId case final String focus) {
      conversation.monumentId = focus;
    }
    return MockResponse.ok({
      'conversationId': id,
      'message': {
        'id': 'msg_${_randomHex(12)}',
        'text': answer.text,
        'createdAt': now.toIso8601String(),
        'notice': answer.notice,
        'sources': [
          for (final monument in answer.sources)
            {
              'monumentId': monument.id,
              'name': monument.name.resolve(language),
              'city': monument.city,
            },
        ],
        'actions': answer.actions,
        'suggestions': answer.suggestions,
      },
    });
  }

  MockResponse _deleteConversation(MockRequest request) {
    _conversations.remove(request.pathParameters['id']);
    return const MockResponse.noContent();
  }

  /// Süresi dolan sohbetler ve sınırı aşan en eski sohbetler silinir.
  void _expire(DateTime now) {
    _conversations.removeWhere(
      (_, conversation) =>
          now.difference(conversation.updatedAt) > conversationTtl,
    );
    while (_conversations.length >= maxConversations) {
      final oldest = _conversations.entries.reduce(
        (a, b) => a.value.updatedAt.isBefore(b.value.updatedAt) ? a : b,
      );
      _conversations.remove(oldest.key);
    }
  }

  static String _language(MockRequest request) {
    final header = request.headers['accept-language'] ?? '';
    final primary = header.split(',').first.split('-').first.trim();
    return _supportedLanguages.contains(primary) ? primary : 'tr';
  }

  String _randomHex(int length) => List.generate(
    length,
    (_) => _random.nextInt(16).toRadixString(16),
  ).join();
}

final class _Conversation {
  DateTime updatedAt = DateTime.utc(1970);

  /// Son yanıtta odaklanılan eser (devam soruları için).
  String? monumentId;

  /// Son bir dakikadaki soruların zamanları (hız sınırı).
  final List<DateTime> questions = [];
}
