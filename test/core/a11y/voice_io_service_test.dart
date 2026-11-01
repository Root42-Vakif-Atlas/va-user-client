import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vakif_atlas/core/a11y/voice_io_service.dart';

class _MockFlutterTts extends Mock implements FlutterTts {}

void main() {
  late _MockFlutterTts tts;
  late VoiceIoService service;

  setUpAll(() {
    registerFallbackValue(() {});
    registerFallbackValue((dynamic _) {});
    registerFallbackValue(IosTextToSpeechAudioCategory.playback);
    registerFallbackValue(IosTextToSpeechAudioMode.defaultMode);
  });

  setUp(() {
    tts = _MockFlutterTts();
    when(() => tts.setLanguage(any())).thenAnswer((_) async => 1);
    when(() => tts.speak(any())).thenAnswer((_) async => 1);
    when(tts.stop).thenAnswer((_) async => 1);
    when(() => tts.setIosAudioCategory(any(), any(), any()))
        .thenAnswer((_) async => 1);
    when(() => tts.setSharedInstance(any())).thenAnswer((_) async => 1);
    service = VoiceIoService(tts);
  });

  tearDown(() => service.dispose());

  test('dil kodunu TTS yerel ayarına çevirir', () async {
    await service.setLanguage('tr');
    await service.setLanguage('en');

    verify(() => tts.setLanguage('tr-TR')).called(1);
    verify(() => tts.setLanguage('en-US')).called(1);
  });

  test('speak dili ayarlar ve metni okur; konuşmuyorken durdurmaz', () async {
    await service.speak('Süleymaniye Camii', languageCode: 'tr');

    verifyInOrder([
      () => tts.setLanguage('tr-TR'),
      () => tts.speak('Süleymaniye Camii'),
    ]);
    verifyNever(tts.stop);
  });

  test('konuşurken yeni metin önceki seslendirmeyi durdurur', () async {
    await service.speak('Bir');
    final start =
        verify(() => tts.setStartHandler(captureAny())).captured.single
            as void Function();
    start();

    await service.speak('İki');

    verifyInOrder([() => tts.stop(), () => tts.speak('İki')]);
  });

  test('cihazda dilin sesi yoksa okumaz ve hata yayınlar', () async {
    when(() => tts.setLanguage(any())).thenAnswer((_) async => 0);
    final statuses = <TtsStatus>[];
    final subscription = service.status.listen(statuses.add);

    await service.speak('Merhaba', languageCode: 'tr');
    await Future<void>.delayed(Duration.zero);
    await subscription.cancel();

    verifyNever(() => tts.speak(any()));
    expect(statuses, [TtsStatus.error]);
  });

  test('iOS: her seslendirmeden önce playback ses oturumu açılır', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    try {
      await service.speak('Merhaba');
      await service.speak('Tekrar');
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }

    verify(
      () => tts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        any(),
        IosTextToSpeechAudioMode.spokenAudio,
      ),
    ).called(2);
    verify(() => tts.setSharedInstance(true)).called(2);
  });

  test('iOS dışında ses oturumu ayarlanmaz', () async {
    await service.speak('Merhaba');

    verifyNever(() => tts.setIosAudioCategory(any(), any(), any()));
    verifyNever(() => tts.setSharedInstance(any()));
  });

  test('boş metin seslendirilmez', () async {
    await service.speak('  ');
    verifyNever(() => tts.speak(any()));
  });

  test('motor olayları durum akışına yansır', () async {
    await service.speak('Merhaba');
    final start =
        verify(() => tts.setStartHandler(captureAny())).captured.single
            as void Function();
    final complete =
        verify(() => tts.setCompletionHandler(captureAny())).captured.single
            as void Function();

    final statuses = <TtsStatus>[];
    final subscription = service.status.listen(statuses.add);
    start();
    complete();
    await Future<void>.delayed(Duration.zero);
    await subscription.cancel();

    expect(statuses, [TtsStatus.speaking, TtsStatus.idle]);
  });

  test('platform hatası durum akışına error olarak yansır', () async {
    when(() => tts.speak(any())).thenThrow(MissingPluginException());

    final statuses = <TtsStatus>[];
    final subscription = service.status.listen(statuses.add);
    await service.speak('Merhaba');
    await Future<void>.delayed(Duration.zero);
    await subscription.cancel();

    expect(statuses, contains(TtsStatus.error));
  });
}
