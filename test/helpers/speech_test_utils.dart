import 'dart:async';

import 'package:vakif_atlas/core/a11y/speech_input_service.dart';

/// Oturumları testten yönetilen sahte konuşma tanıma servisi.
class FakeSpeechInputService implements SpeechInputService {
  FakeSpeechInputService({this.isSupported = true});

  @override
  final bool isSupported;

  final List<String> languages = [];
  int stops = 0;
  int cancels = 0;
  StreamController<SpeechInputEvent>? _session;

  bool get isListening => _session != null && !_session!.isClosed;

  @override
  Stream<SpeechInputEvent> listen({required String languageCode}) {
    languages.add(languageCode);
    _session = StreamController<SpeechInputEvent>();
    return _session!.stream;
  }

  /// Tanınan metni bildirir; [isFinal] ise oturum biter.
  void hear(String text, {bool isFinal = false}) {
    _session!.add(SpeechHeard(text, isFinal: isFinal));
    if (isFinal) {
      unawaited(_session!.close());
    }
  }

  void fail(SpeechInputIssue issue) {
    _session!.add(SpeechInputFailed(issue));
    unawaited(_session!.close());
  }

  /// Sonuçsuz biter (sessizlik).
  void end() => unawaited(_session!.close());

  @override
  Future<void> stop() async {
    stops++;
  }

  @override
  Future<void> cancel() async {
    cancels++;
    final session = _session;
    if (session != null && !session.isClosed) {
      await session.close();
    }
  }
}
