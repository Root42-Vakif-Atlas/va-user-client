import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/features/ai_assistant/domain/entities/guide_message.dart';
import 'package:vakif_atlas/features/ai_assistant/domain/usecases/digital_guide_usecases.dart';

part 'digital_guide_bloc.freezed.dart';
part 'digital_guide_event.dart';
part 'digital_guide_state.dart';

/// Dijital Rehber sohbeti (sekme bazlı; sekme değişse de sohbet korunur).
///
/// - Soru gönderilirken yeni soru kabul edilmez (`droppable()`).
/// - Gönderilemeyen soru sohbette kalır; "Tekrar dene" aynı soruyu yeniden
///   gönderir.
/// - "Yeni sohbet" geçmişi temizler ve sunucudaki sohbeti siler. Sohbet
///   cihaza yazılmaz.
@injectable
class DigitalGuideBloc extends Bloc<DigitalGuideEvent, DigitalGuideState> {
  DigitalGuideBloc(this._ask, this._end) : super(const DigitalGuideState()) {
    on<GuideQuestionSubmitted>(_onSubmitted, transformer: droppable());
    on<GuideRetryRequested>(_onRetry, transformer: droppable());
    on<GuideConversationReset>(_onReset);
  }

  final AskGuideUseCase _ask;
  final EndGuideConversationUseCase _end;

  int _localSequence = 0;

  Future<void> _onSubmitted(
    GuideQuestionSubmitted event,
    Emitter<DigitalGuideState> emit,
  ) async {
    final question = event.question.trim();
    if (state.isSending || GuideRules.validate(question) != null) {
      return;
    }
    emit(
      state.copyWith(
        entries: [
          ...state.entries,
          GuideQuestionEntry(id: 'local_${++_localSequence}', text: question),
        ],
        failure: null,
        failedQuestion: null,
      ),
    );
    await _send(question, event.languageCode, emit);
  }

  Future<void> _onRetry(
    GuideRetryRequested event,
    Emitter<DigitalGuideState> emit,
  ) async {
    final question = state.failedQuestion;
    if (question == null || state.isSending) {
      return;
    }
    await _send(question, event.languageCode, emit);
  }

  Future<void> _send(
    String question,
    String languageCode,
    Emitter<DigitalGuideState> emit,
  ) async {
    emit(state.copyWith(isSending: true, failure: null, failedQuestion: null));
    final generation = state.generation;
    final result = await _ask(
      AskGuideParams(
        question: question,
        languageCode: languageCode,
        conversationId: state.conversationId,
      ),
    );
    // Yanıt beklenirken "Yeni sohbet" dendiyse eski yanıt gösterilmez.
    if (generation != state.generation) {
      return;
    }
    result.fold(
      (failure) => emit(
        state.copyWith(
          isSending: false,
          failure: failure,
          failedQuestion: question,
        ),
      ),
      (reply) => emit(
        state.copyWith(
          isSending: false,
          conversationId: reply.conversationId,
          entries: [...state.entries, GuideAnswerEntry(reply.message)],
        ),
      ),
    );
  }

  void _onReset(GuideConversationReset event, Emitter<DigitalGuideState> emit) {
    final conversationId = state.conversationId;
    if (conversationId != null) {
      // Silme başarısız olsa da sohbet sunucuda süre dolunca silinir.
      unawaited(_end(conversationId));
    }
    emit(DigitalGuideState(generation: state.generation + 1));
  }
}
