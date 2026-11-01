part of 'digital_guide_bloc.dart';

@freezed
sealed class DigitalGuideEvent with _$DigitalGuideEvent {
  /// Yazılan soru veya dokunulan öneri. [languageCode] yanıtın dilidir.
  const factory DigitalGuideEvent.questionSubmitted({
    required String question,
    required String languageCode,
  }) = GuideQuestionSubmitted;

  const factory DigitalGuideEvent.retryRequested({
    required String languageCode,
  }) = GuideRetryRequested;

  const factory DigitalGuideEvent.conversationReset() = GuideConversationReset;
}
