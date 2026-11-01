part of 'digital_guide_bloc.dart';

/// Sohbetteki bir satır: kullanıcının sorusu veya rehberin yanıtı.
sealed class GuideChatEntry {
  const GuideChatEntry();

  String get id;
}

final class GuideQuestionEntry extends GuideChatEntry {
  const GuideQuestionEntry({required this.id, required this.text});

  @override
  final String id;
  final String text;

  @override
  bool operator ==(Object other) =>
      other is GuideQuestionEntry && other.id == id && other.text == text;

  @override
  int get hashCode => Object.hash(id, text);

  @override
  String toString() => 'GuideQuestionEntry($id)';
}

final class GuideAnswerEntry extends GuideChatEntry {
  const GuideAnswerEntry(this.message);

  final GuideMessage message;

  @override
  String get id => message.id;

  @override
  bool operator ==(Object other) =>
      other is GuideAnswerEntry && other.message == message;

  @override
  int get hashCode => message.hashCode;

  @override
  String toString() => 'GuideAnswerEntry($id)';
}

@freezed
abstract class DigitalGuideState with _$DigitalGuideState {
  const factory DigitalGuideState({
    @Default(<GuideChatEntry>[]) List<GuideChatEntry> entries,
    @Default(false) bool isSending,
    String? conversationId,

    /// Son sorunun gönderim hatası; [failedQuestion] yeniden gönderilir.
    Failure? failure,
    String? failedQuestion,

    /// "Yeni sohbet" ile artar; eski sohbete gelen yanıt yok sayılır.
    @Default(0) int generation,
  }) = _DigitalGuideState;

  const DigitalGuideState._();

  bool get isEmpty => entries.isEmpty;

  /// En son yanıt (devam önerileri yalnızca onun altında gösterilir).
  GuideMessage? get latestAnswer => switch (entries.lastOrNull) {
    GuideAnswerEntry(:final message) => message,
    _ => null,
  };

  /// Sorular ve yanıtlar kullanıcı içeriğidir; loglara yazılmaz (ADR 14).
  @override
  String toString() =>
      'DigitalGuideState(entries: ${entries.length}, sending: $isSending, '
      'failure: $failure)';
}
