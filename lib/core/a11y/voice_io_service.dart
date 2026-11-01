import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:injectable/injectable.dart';

/// Metinden sese (TTS) motorunun durumu.
enum TtsStatus { idle, speaking, error }

/// Eser detaylarını ve dijital rehber yanıtlarını seslendirir (TRD §7).
///
/// Sesten metne (STT) `SpeechInputService`'tedir; dinleme başlamadan bu
/// servisin seslendirmesi durdurulur.
///
/// iOS: varsayılan ses oturumu (`soloAmbient`) sessiz anahtarda susar ve
/// konuşma tanıma oturumu kayıt kategorisinde bırakır; bu yüzden her
/// seslendirmeden önce oturum `playback` / `spokenAudio` olarak etkinleştirilir.
@lazySingleton
class VoiceIoService {
  VoiceIoService(this._tts);

  final FlutterTts _tts;
  final StreamController<TtsStatus> _status =
      StreamController<TtsStatus>.broadcast();
  bool _handlersRegistered = false;
  bool _speaking = false;

  static const Map<String, String> _voiceLocales = {
    'tr': 'tr-TR',
    'en': 'en-US',
  };

  Stream<TtsStatus> get status => _status.stream;

  /// Seslendirme dilini uygulama diline göre ayarlar (WCAG 3.1.2).
  ///
  /// Cihazda o dilde ses yoksa `false` döner ve hata durumu yayınlanır.
  Future<bool> setLanguage(String languageCode) async {
    _registerHandlers();
    final voiceLocale = _voiceLocales[languageCode] ?? languageCode;
    var applied = false;
    await _guard(() async {
      applied = await _tts.setLanguage(voiceLocale) == 1;
    });
    return applied;
  }

  /// Önceki seslendirmeyi durdurur ve [text] metnini okur.
  Future<void> speak(String text, {String? languageCode}) async {
    if (text.trim().isEmpty) {
      return;
    }
    _registerHandlers();
    if (languageCode != null && !await setLanguage(languageCode)) {
      _emit(TtsStatus.error);
      return;
    }
    // iOS'ta konuşmuyorken `stop` gecikmeli bir iptal olayı üretip yeni
    // seslendirmenin durumunu `idle`'a çekiyordu.
    if (_speaking) {
      await _guard(_tts.stop);
    }
    await _prepareAudioSession();
    await _guard(() => _tts.speak(text));
  }

  Future<void> stop() async {
    await _guard(_tts.stop);
    _emit(TtsStatus.idle);
  }

  Future<void> _prepareAudioSession() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.iOS) {
      return;
    }
    await _guard(
      () => _tts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        const [
          IosTextToSpeechAudioCategoryOptions.duckOthers,
          IosTextToSpeechAudioCategoryOptions
              .interruptSpokenAudioAndMixWithOthers,
        ],
        IosTextToSpeechAudioMode.spokenAudio,
      ),
    );
    await _guard(() => _tts.setSharedInstance(true));
  }

  @disposeMethod
  Future<void> dispose() async {
    await _guard(_tts.stop);
    await _status.close();
  }

  void _registerHandlers() {
    if (_handlersRegistered) {
      return;
    }
    _handlersRegistered = true;
    _tts
      ..setStartHandler(() => _emit(TtsStatus.speaking))
      ..setCompletionHandler(() => _emit(TtsStatus.idle))
      ..setCancelHandler(() => _emit(TtsStatus.idle))
      ..setErrorHandler((_) => _emit(TtsStatus.error));
  }

  Future<void> _guard(Future<dynamic> Function() action) async {
    try {
      await action();
    } on Exception {
      _emit(TtsStatus.error);
    }
  }

  void _emit(TtsStatus status) {
    _speaking = status == TtsStatus.speaking;
    if (!_status.isClosed) {
      _status.add(status);
    }
  }
}
