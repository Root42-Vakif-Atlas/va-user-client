import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/features/ai_assistant/data/dtos/guide_dtos.dart';
import 'package:vakif_atlas/features/ai_assistant/data/repositories/digital_guide_repository_impl.dart';
import 'package:vakif_atlas/features/ai_assistant/data/sources/digital_guide_remote_data_source.dart';
import 'package:vakif_atlas/features/ai_assistant/domain/entities/guide_message.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_classification.dart';

import '../../../helpers/network_test_utils.dart';
import '../../../support/mock_api/ai_assistant/assistant_mock_api.dart';

T _right<T>(Either<Failure, T> result) =>
    result.fold((failure) => fail('Beklenmeyen hata: $failure'), (v) => v);

Failure _left<T>(Either<Failure, T> result) =>
    result.fold((failure) => failure, (v) => fail('Hata bekleniyordu: $v'));

void main() {
  late DateTime now;
  late DigitalGuideRepositoryImpl repository;

  setUp(() {
    now = DateTime.utc(2026, 10, 19, 12);
    final api = AssistantMockApi.withClock(clock: () => now);
    repository = DigitalGuideRepositoryImpl(
      DigitalGuideRemoteDataSourceImpl(testDio(api.routes)),
    );
  });

  test('yanıt kaynak, eylem ve önerilerle domain nesnesine dönüşür', () async {
    final reply = _right(
      await repository.ask(
        question: "Süleymaniye Camii'ni kim yaptırdı?",
        languageCode: 'tr',
      ),
    );
    final message = reply.message;

    expect(reply.conversationId, startsWith('conv_'));
    expect(message.text, contains('Kanuni Sultan Süleyman'));
    expect(message.sources, const [
      GuideMonumentRef(
        id: 'suleymaniye-camii',
        name: 'Süleymaniye Camii',
        city: 'İstanbul',
      ),
    ]);
    expect(message.actions, const [
      GuideOpenMonument(
        GuideMonumentRef(id: 'suleymaniye-camii', name: 'Süleymaniye Camii'),
      ),
      GuideShowOnMap(
        GuideMonumentRef(id: 'suleymaniye-camii', name: 'Süleymaniye Camii'),
      ),
      GuideOpenMemories(
        GuideMonumentRef(id: 'suleymaniye-camii', name: 'Süleymaniye Camii'),
      ),
    ]);
    expect(message.suggestions, isNotEmpty);
    expect(message.createdAt, now);
  });

  test('sohbet kimliğiyle devam sorusu aynı eseri yanıtlar', () async {
    final first = _right(
      await repository.ask(question: 'Selimiye Camii', languageCode: 'tr'),
    );
    final followUp = _right(
      await repository.ask(
        question: 'Mimarı kim?',
        languageCode: 'tr',
        conversationId: first.conversationId,
      ),
    );

    expect(followUp.conversationId, first.conversationId);
    expect(followUp.message.text, contains('Mimar Sinan'));
  });

  test('silinen veya süresi dolan sohbet bağlamı taşımaz', () async {
    final first = _right(
      await repository.ask(question: 'Selimiye Camii', languageCode: 'tr'),
    );
    expect(
      (await repository.endConversation(first.conversationId)).isRight,
      isTrue,
    );

    final afterDelete = _right(
      await repository.ask(
        question: 'Mimarı kim?',
        languageCode: 'tr',
        conversationId: first.conversationId,
      ),
    );
    expect(afterDelete.conversationId, isNot(first.conversationId));
    expect(afterDelete.message.text, isNot(contains('Mimar Sinan')));

    final second = _right(
      await repository.ask(question: 'Selimiye Camii', languageCode: 'tr'),
    );
    now = now.add(
      AssistantMockApi.conversationTtl + const Duration(minutes: 1),
    );
    final expired = _right(
      await repository.ask(
        question: 'Mimarı kim?',
        languageCode: 'tr',
        conversationId: second.conversationId,
      ),
    );
    expect(expired.conversationId, isNot(second.conversationId));
  });

  test('arama eylemi filtreyi MonumentSearchQuery olarak taşır', () async {
    final reply = _right(
      await repository.ask(question: 'Osmanlı camileri', languageCode: 'tr'),
    );
    final search = reply.message.actions
        .whereType<GuideSearchMonuments>()
        .single;

    expect(search.query.filter.categories, {MonumentCategory.mosque});
    expect(search.query.filter.periods, {HistoricalPeriod.ottoman});
    expect(search.total, reply.message.sources.length);
  });

  test('acil durum uyarısı ve İngilizce içerik', () async {
    final reply = _right(
      await repository.ask(
        question: 'There is a fire at the Selimiye Mosque',
        languageCode: 'en',
      ),
    );

    expect(reply.message.notice, GuideNotice.emergency);
    expect(reply.message.text, contains('112'));
    expect(
      reply.message.actions.first,
      const GuideReportDamage(
        GuideMonumentRef(id: 'selimiye-camii', name: 'Selimiye Mosque'),
      ),
    );
  });

  test('boş veya çok uzun soruya sunucu 400 döner', () async {
    expect(
      _left(await repository.ask(question: '   ', languageCode: 'tr')),
      isA<ServerFailure>().having(
        (failure) => failure.kind,
        'kind',
        ServerFailureKind.invalidRequest,
      ),
    );
    expect(
      _left(
        await repository.ask(
          question: 'a' * (GuideRules.maxQuestionLength + 1),
          languageCode: 'tr',
        ),
      ),
      isA<ServerFailure>(),
    );
  });

  test('sohbet başına dakikalık sınır aşılınca 429', () async {
    String? conversationId;
    for (var i = 0; i < AssistantMockApi.maxQuestionsPerMinute; i++) {
      conversationId = _right(
        await repository.ask(
          question: 'Merhaba',
          languageCode: 'tr',
          conversationId: conversationId,
        ),
      ).conversationId;
    }

    expect(
      _left(
        await repository.ask(
          question: 'Merhaba',
          languageCode: 'tr',
          conversationId: conversationId,
        ),
      ),
      isA<TooManyRequestsFailure>(),
    );
  });

  group('GuideActionDto', () {
    test('bilinmeyen tür ve eksik alanlı eylemler atlanır', () {
      final message = GuideMessageDto.fromJson({
        'id': 'msg_1',
        'text': ' Yanıt ',
        'createdAt': '2026-10-19T12:00:00Z',
        'notice': 'unknown',
        'actions': [
          {'type': 'openUrl', 'url': 'https://example.com'},
          {'type': 'openMonument'},
          {'type': 'openSection', 'destination': 'adminPanel'},
          {'type': 'openSection', 'destination': 'settings'},
        ],
        'suggestions': ['  ', 'Mimarı kim?'],
      }).toDomain();

      expect(message.text, 'Yanıt');
      expect(message.notice, isNull);
      expect(message.actions, const [
        GuideOpenSection(GuideDestination.settings),
      ]);
      expect(message.suggestions, ['Mimarı kim?']);
    });
  });

  test('mesaj ve durum metni loglara yazılmaz', () {
    final message = GuideMessage(
      id: 'msg_1',
      text: 'Kişisel bilgi',
      createdAt: DateTime.utc(2026),
    );

    expect(message.toString(), isNot(contains('Kişisel')));
  });
}
