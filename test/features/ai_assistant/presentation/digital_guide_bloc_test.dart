import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/ai_assistant/domain/entities/guide_message.dart';
import 'package:vakif_atlas/features/ai_assistant/domain/repositories/digital_guide_repository.dart';
import 'package:vakif_atlas/features/ai_assistant/domain/usecases/digital_guide_usecases.dart';
import 'package:vakif_atlas/features/ai_assistant/presentation/bloc/digital_guide_bloc.dart';

/// Yanıtları testin tamamladığı repository.
final class _ControlledGuideRepository implements DigitalGuideRepository {
  final List<(String, String?)> questions = [];
  final List<String> ended = [];
  final List<Completer<Either<Failure, GuideReply>>> pending = [];

  @override
  ResultFuture<GuideReply> ask({
    required String question,
    required String languageCode,
    String? conversationId,
  }) {
    questions.add((question, conversationId));
    final completer = Completer<Either<Failure, GuideReply>>();
    pending.add(completer);
    return completer.future;
  }

  @override
  ResultFuture<void> endConversation(String conversationId) async {
    ended.add(conversationId);
    return const Right(null);
  }

  void reply(String text, {String conversationId = 'conv_1'}) => pending
      .removeAt(0)
      .complete(
        Right(
          GuideReply(
            conversationId: conversationId,
            message: GuideMessage(
              id: 'msg_${questions.length}',
              text: text,
              createdAt: DateTime.utc(2026, 10, 19),
            ),
          ),
        ),
      );

  void fail(Failure failure) => pending.removeAt(0).complete(Left(failure));
}

Future<void> _flush() => Future<void>.delayed(Duration.zero);

void main() {
  late _ControlledGuideRepository repository;
  late DigitalGuideBloc bloc;

  setUp(() {
    repository = _ControlledGuideRepository();
    bloc = DigitalGuideBloc(
      AskGuideUseCase(repository),
      EndGuideConversationUseCase(repository),
    );
  });

  tearDown(() => bloc.close());

  void ask(String question) => bloc.add(
    DigitalGuideEvent.questionSubmitted(question: question, languageCode: 'tr'),
  );

  test('soru ve yanıt sırayla eklenir, sohbet kimliği sonraki soruda '
      'gönderilir', () async {
    ask('  Selimiye Camii  ');
    await _flush();

    expect(bloc.state.isSending, isTrue);
    expect(bloc.state.entries.single, isA<GuideQuestionEntry>());
    expect(
      (bloc.state.entries.single as GuideQuestionEntry).text,
      'Selimiye Camii',
    );

    repository.reply('Selimiye Camii (Merkez, Edirne)');
    await _flush();
    expect(bloc.state.isSending, isFalse);
    expect(bloc.state.latestAnswer?.text, 'Selimiye Camii (Merkez, Edirne)');

    ask('Mimarı kim?');
    await _flush();
    expect(repository.questions.last, ('Mimarı kim?', 'conv_1'));
  });

  test('yanıt beklenirken yeni soru ve boş soru yok sayılır', () async {
    ask('');
    ask('Birinci');
    await _flush();
    ask('İkinci');
    await _flush();

    expect(repository.questions, [('Birinci', null)]);
    expect(bloc.state.entries, hasLength(1));
  });

  test('hata soruyu korur, tekrar dene aynı soruyu yeniden gönderir', () async {
    ask('Selimiye Camii');
    await _flush();
    repository.fail(const NetworkFailure());
    await _flush();

    expect(bloc.state.failure, const NetworkFailure());
    expect(bloc.state.failedQuestion, 'Selimiye Camii');
    expect(bloc.state.entries, hasLength(1));

    bloc.add(const DigitalGuideEvent.retryRequested(languageCode: 'tr'));
    await _flush();
    expect(bloc.state.failure, isNull);
    expect(repository.questions, hasLength(2));
    expect(repository.questions.last.$1, 'Selimiye Camii');

    repository.reply('Yanıt');
    await _flush();
    expect(bloc.state.entries, hasLength(2));
  });

  test('yeni sohbet geçmişi temizler, sunucudaki sohbeti siler ve '
      'bekleyen yanıtı yok sayar', () async {
    ask('Selimiye Camii');
    await _flush();
    repository.reply('Yanıt');
    await _flush();

    ask('Mimarı kim?');
    await _flush();
    bloc.add(const DigitalGuideEvent.conversationReset());
    await _flush();
    expect(repository.ended, ['conv_1']);
    expect(bloc.state.isEmpty, isTrue);
    expect(bloc.state.isSending, isFalse);

    repository.reply('Eski yanıt');
    await _flush();
    expect(bloc.state.isEmpty, isTrue);
    expect(bloc.state.conversationId, isNull);
  });

  test('durum metni soruları loglara yazmaz', () async {
    ask('Kişisel bilgi');
    await _flush();

    expect(bloc.state.toString(), isNot(contains('Kişisel')));
  });
}
