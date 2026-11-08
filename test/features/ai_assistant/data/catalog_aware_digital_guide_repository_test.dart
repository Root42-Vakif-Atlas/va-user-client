import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/features/ai_assistant/data/repositories/catalog_aware_digital_guide_repository.dart';
import 'package:vakif_atlas/features/ai_assistant/data/repositories/digital_guide_repository_impl.dart';
import 'package:vakif_atlas/features/ai_assistant/data/sources/digital_guide_remote_data_source.dart';
import 'package:vakif_atlas/features/ai_assistant/domain/catalog_guide/catalog_guide.dart';
import 'package:vakif_atlas/features/ai_assistant/domain/entities/guide_message.dart';

import '../../../helpers/network_test_utils.dart';
import '../../../support/mock_api/ai_assistant/assistant_mock_api.dart';
import '../../../support/mock_api/mock_api.dart';
import '../domain/fake_guide_catalog.dart';

void main() {
  late List<MockRequest> serverRequests;
  late CatalogAwareDigitalGuideRepository repository;

  setUp(() {
    serverRequests = [];
    final api = AssistantMockApi.withClock(
      clock: () => DateTime.utc(2026, 11, 8, 12),
    );
    final routes = [
      for (final route in api.routes)
        MockRoute(route.method, route.pattern, (request) {
          serverRequests.add(request);
          return route.handler(request);
        }),
    ];
    repository = CatalogAwareDigitalGuideRepository(
      DigitalGuideRepositoryImpl(
        DigitalGuideRemoteDataSourceImpl(testDio(routes)),
      ),
      CatalogGuide.withClock(
        FakeGuideCatalog(),
        () => DateTime.utc(2026, 11, 8, 12),
      ),
    );
  });

  Future<GuideReply> ask(String question, {String? conversationId}) async {
    final result = await repository.ask(
      question: question,
      languageCode: 'tr',
      conversationId: conversationId,
    );
    return switch (result) {
      Right(:final value) => value,
      Left(:final value) => fail('Beklenmeyen hata: $value'),
    };
  }

  test('eser sorusu katalogdan yanıtlanır; sunucuya gitmez', () async {
    final reply = await ask('Bursa Ulu Camii ne zaman yapıldı?');

    expect(reply.message.text, startsWith('Bursa Ulu Camii'));
    expect(reply.conversationId, startsWith('guide_'));
    expect(serverRequests, isEmpty);
  });

  test('takip sorusu aynı sohbette konuşulan esere yanıtlanır', () async {
    final first = await ask('Bursa Ulu Camii ne zaman yapıldı?');

    final reply = await ask(
      'Kim yaptırdı?',
      conversationId: first.conversationId,
    );

    expect(reply.conversationId, first.conversationId);
    expect(reply.message.text, contains('Sultan Yıldırım Bayezid'));
  });

  test('uygulama sorusu sunucuya gider; sohbet kimliği korunur ve '
      'sunucu sohbeti sürdürülür', () async {
    final first = await ask('Bursa camileri');

    final route = await ask(
      'Rota nasıl planlarım?',
      conversationId: first.conversationId,
    );
    final damage = await ask(
      'Hasar nasıl bildiririm?',
      conversationId: first.conversationId,
    );

    expect(route.conversationId, first.conversationId);
    expect(damage.conversationId, first.conversationId);
    expect(serverRequests, hasLength(2));
    expect(serverRequests.first.field('conversationId'), isNull);
    final serverId = serverRequests.last.field('conversationId');
    expect(serverId, isA<String>());
    expect(serverId, isNot(first.conversationId));
  });

  test('yeni sohbet: yalnızca sunucu sohbeti varsa sunucuda silinir', () async {
    final local = await ask('Bursa camileri');
    expect(
      await repository.endConversation(local.conversationId),
      const Right<Failure, void>(null),
    );
    expect(serverRequests, isEmpty);

    final server = await ask('Rota nasıl planlarım?');
    await repository.endConversation(server.conversationId);

    expect(serverRequests.last.method, 'DELETE');
    expect(
      serverRequests.last.pathParameters['id'],
      isNot(server.conversationId),
    );
  });
}
