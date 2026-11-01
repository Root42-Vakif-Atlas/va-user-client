import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:vakif_atlas/core/a11y/voice_io_service.dart';

/// Dinlemenin neden sonuçsuz kaldığı.
enum SpeechInputIssue {
  /// Cihazda/tarayıcıda konuşma tanıma yok veya başlatılamadı.
  unavailable,

  /// Konuşma algılanmadı veya anlaşılamadı.
  noMatch,

  /// Mikrofon izni dinleme sırasında reddedildi.
  permissionDenied,

  /// Ağ veya servis hatası.
  failed,
}

/// Dinleme oturumundaki olay.
sealed class SpeechInputEvent {
  const SpeechInputEvent();
}

/// Tanınan metin; [isFinal] değilse konuşma sürüyor.
final class SpeechHeard extends SpeechInputEvent {
  const SpeechHeard(this.text, {required this.isFinal});

  final String text;
  final bool isFinal;

  /// Kullanıcının sözleri kişisel veridir; loglara yazılmaz.
  @override
  String toString() => 'SpeechHeard(final: $isFinal)';
}

final class SpeechInputFailed extends SpeechInputEvent {
  const SpeechInputFailed(this.issue);

  final SpeechInputIssue issue;

  @override
  String toString() => 'SpeechInputFailed($issue)';
}

/// Sesten metne (STT): Dijital Rehber'e sesli soru.
///
/// Mikrofon izni çağırandan önce `PermissionService` ile alınır. Dinleme
/// başlamadan seslendirme (TTS) durdurulur. Tanınan metin yalnızca olay
/// akışıyla döner; servis metni saklamaz veya loglamaz. Implementasyonlar
/// istisna fırlatmaz.
abstract interface class SpeechInputService {
  /// `false` → platformda konuşma tanıma yoktur; mikrofon butonu gösterilmez.
  bool get isSupported;

  /// Yeni bir dinleme oturumu başlatır (öncekini iptal eder). Akış oturum
  /// bitince kapanır: son metin, hata veya [stop]/[cancel].
  Stream<SpeechInputEvent> listen({required String languageCode});

  /// Dinlemeyi bitirir; o ana kadar söylenen metin son sonuç olarak gelir.
  Future<void> stop();

  /// Dinlemeyi sonuçsuz bırakır.
  Future<void> cancel();
}

/// `speech_to_text` ile konuşma tanıma: Android `SpeechRecognizer`, iOS
/// `SFSpeechRecognizer`, web'de Web Speech API (Chrome, Edge, Safari;
/// Firefox'ta yok → [SpeechInputIssue.unavailable]). Masaüstünde
/// kullanılmaz.
@LazySingleton(as: SpeechInputService)
class SpeechToTextInputService implements SpeechInputService {
  SpeechToTextInputService(this._speech, this._voice);

  final SpeechToText _speech;
  final VoiceIoService _voice;

  /// Sorular kısa: en çok 30 sn dinlenir, 3 sn sessizlikte biter.
  static const Duration _listenFor = Duration(seconds: 30);
  static const Duration _pauseFor = Duration(seconds: 3);

  StreamController<SpeechInputEvent>? _session;
  bool _initialized = false;

  @override
  bool get isSupported =>
      kIsWeb ||
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  @override
  Stream<SpeechInputEvent> listen({required String languageCode}) {
    _endSession();
    final session = StreamController<SpeechInputEvent>();
    _session = session;
    unawaited(_start(session, languageCode));
    return session.stream;
  }

  @override
  Future<void> stop() => _guard(_speech.stop);

  @override
  Future<void> cancel() async {
    _endSession();
    await _guard(_speech.cancel);
  }

  Future<void> _start(
    StreamController<SpeechInputEvent> session,
    String languageCode,
  ) async {
    await _voice.stop();
    if (!isSupported || !await _initialize()) {
      _fail(session, SpeechInputIssue.unavailable);
      return;
    }
    if (session.isClosed) {
      return;
    }
    try {
      await _speech.listen(
        onResult: (result) => _onResult(session, result),
        listenOptions: SpeechListenOptions(
          localeId: _localeId(languageCode),
          listenFor: _listenFor,
          pauseFor: _pauseFor,
          cancelOnError: true,
          listenMode: ListenMode.search,
        ),
      );
    } on Object {
      _fail(session, SpeechInputIssue.failed);
    }
  }

  /// Başarısız başlatma yeniden denenebilir (ör. izin sonradan verildi).
  Future<bool> _initialize() async {
    if (_initialized) {
      return true;
    }
    try {
      _initialized = await _speech.initialize(
        onError: _onError,
        onStatus: _onStatus,
      );
    } on Object {
      _initialized = false;
    }
    return _initialized;
  }

  void _onResult(
    StreamController<SpeechInputEvent> session,
    SpeechRecognitionResult result,
  ) {
    if (session.isClosed) {
      return;
    }
    session.add(
      SpeechHeard(result.recognizedWords, isFinal: result.finalResult),
    );
    if (result.finalResult) {
      unawaited(session.close());
    }
  }

  void _onError(SpeechRecognitionError error) {
    final session = _session;
    if (session == null || session.isClosed) {
      return;
    }
    _fail(session, switch (error.errorMsg) {
      'error_no_match' || 'error_speech_timeout' => SpeechInputIssue.noMatch,
      'error_permission' ||
      'error_insufficient_permissions' ||
      'not-allowed' => SpeechInputIssue.permissionDenied,
      'error_language_not_supported' ||
      'error_language_unavailable' ||
      'service-not-allowed' => SpeechInputIssue.unavailable,
      _ => SpeechInputIssue.failed,
    });
  }

  /// Son sonuç gelmeden dinleme biterse (sessizlik, durdurma) oturum
  /// kapanır.
  void _onStatus(String status) {
    if (status != SpeechToText.doneStatus) {
      return;
    }
    final session = _session;
    if (session != null && !session.isClosed) {
      unawaited(session.close());
    }
  }

  void _fail(
    StreamController<SpeechInputEvent> session,
    SpeechInputIssue issue,
  ) {
    if (session.isClosed) {
      return;
    }
    session.add(SpeechInputFailed(issue));
    unawaited(session.close());
  }

  void _endSession() {
    final session = _session;
    _session = null;
    if (session != null && !session.isClosed) {
      unawaited(session.close());
    }
  }

  /// Web Speech API BCP 47 (`tr-TR`), yerel motorlar `tr_TR` bekler.
  static String _localeId(String languageCode) {
    final region = switch (languageCode) {
      'tr' => 'TR',
      _ => 'US',
    };
    final language = languageCode == 'tr' ? 'tr' : 'en';
    return kIsWeb ? '$language-$region' : '${language}_$region';
  }

  Future<void> _guard(Future<void> Function() action) async {
    try {
      await action();
    } on Object {
      // Dinleme zaten bitmiş olabilir.
    }
  }
}
