import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/a11y/haptic_feedback_service.dart';
import 'package:vakif_atlas/core/a11y/speech_input_service.dart';
import 'package:vakif_atlas/core/permissions/permission_service.dart';
import 'package:vakif_atlas/features/ai_assistant/data/repositories/digital_guide_repository_impl.dart';
import 'package:vakif_atlas/features/ai_assistant/data/sources/digital_guide_remote_data_source.dart';
import 'package:vakif_atlas/features/ai_assistant/domain/entities/guide_message.dart';
import 'package:vakif_atlas/features/ai_assistant/domain/usecases/digital_guide_usecases.dart';
import 'package:vakif_atlas/features/ai_assistant/presentation/bloc/digital_guide_bloc.dart';
import 'package:vakif_atlas/features/ai_assistant/presentation/cubit/guide_voice_cubit.dart';
import 'package:vakif_atlas/features/ai_assistant/presentation/pages/digital_guide_page.dart';

import '../../../helpers/network_test_utils.dart';
import '../../../helpers/permission_test_utils.dart';
import '../../../helpers/pump_app.dart';
import '../../../helpers/speech_test_utils.dart';
import '../../../support/mock_api/ai_assistant/assistant_mock_api.dart';
import '../../../support/mock_api/mock_api.dart';

Future<void> _settleRequests(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 20));
  }
}

void main() {
  late List<String> announcements;
  late List<GuideAction> actions;
  late FakeSpeechInputService speech;
  late FakePermissionService permissions;

  setUp(() {
    announcements = [];
    actions = [];
    speech = FakeSpeechInputService();
    permissions = FakePermissionService();
  });

  DigitalGuideBloc createBloc(List<MockRoute> routes) {
    final repository = DigitalGuideRepositoryImpl(
      DigitalGuideRemoteDataSourceImpl(testDio(routes)),
    );
    return DigitalGuideBloc(
      AskGuideUseCase(repository),
      EndGuideConversationUseCase(repository),
    );
  }

  Future<void> pumpGuide(
    WidgetTester tester, {
    List<MockRoute>? routes,
    double textScale = 1,
    Locale locale = const Locale('tr'),
  }) async {
    final api = AssistantMockApi.withClock(
      clock: () => DateTime.utc(2026, 10, 19, 12),
    );
    await tester.pumpApp(
      RepositoryProvider<A11yAnnouncer>.value(
        value: A11yAnnouncer.withSender(
          (_, message, _, _) async => announcements.add(message),
        ),
        child: RepositoryProvider<HapticFeedbackService>.value(
          value: HapticFeedbackService.withDelay((_) async {}),
          child: MultiBlocProvider(
            providers: [
              BlocProvider<DigitalGuideBloc>(
                create: (_) => createBloc(routes ?? api.routes),
              ),
              BlocProvider<GuideVoiceCubit>(
                create: (_) => GuideVoiceCubit(speech, permissions),
              ),
            ],
            child: DigitalGuidePage(onAction: actions.add),
          ),
        ),
      ),
      textScale: textScale,
      locale: locale,
      surfaceSize: const Size(400, 1400),
    );
  }

  Future<void> expectAccessible(WidgetTester tester) async {
    expect(tester.takeException(), isNull);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
  }

  testWidgets('karşılama örnek soruları ve gizlilik notunu gösterir', (
    tester,
  ) async {
    await pumpGuide(tester);

    expect(find.text('Size nasıl yardımcı olabilirim?'), findsOneWidget);
    expect(find.text("Süleymaniye Camii'ni kim yaptırdı?"), findsOneWidget);
    expect(
      find.textContaining('Kişisel bilgilerinizi paylaşmayın'),
      findsOneWidget,
    );
    expect(find.byKey(const Key('guide_new_conversation')), findsNothing);
    final send = tester.widget<IconButton>(find.byKey(const Key('guide_send')));
    expect(send.onPressed, isNull);
    await expectAccessible(tester);
  });

  testWidgets('örnek soru yanıtlanır, duyurulur ve eylem yönlendirir', (
    tester,
  ) async {
    await pumpGuide(tester);

    await tester.tap(find.byKey(const Key('guide_starter_0')));
    await tester.pump();
    expect(find.text('Rehber yanıt hazırlıyor…'), findsOneWidget);
    await _settleRequests(tester);

    expect(find.text("Süleymaniye Camii'ni kim yaptırdı?"), findsOneWidget);
    expect(find.textContaining('Kanuni Sultan Süleyman'), findsOneWidget);
    expect(
      find.text('Kaynak: VGM kataloğu — Süleymaniye Camii'),
      findsOneWidget,
    );
    expect(
      announcements.last,
      startsWith('Rehber: Süleymaniye Camii (Fatih, İstanbul)'),
    );
    await expectAccessible(tester);

    await tester.tap(find.text('Süleymaniye Camii sayfasını aç'));
    expect(actions.single, isA<GuideOpenMonument>());
    expect(
      (actions.single as GuideOpenMonument).monument.id,
      'suleymaniye-camii',
    );
  });

  testWidgets('yazılan soru gönderilir; devam önerisi bağlamı korur', (
    tester,
  ) async {
    await pumpGuide(tester);

    await tester.enterText(find.byKey(const Key('guide_input')), 'Selimiye');
    await tester.pump();
    await tester.tap(find.byKey(const Key('guide_send')));
    await _settleRequests(tester);
    expect(find.textContaining('Sultan II. Selim'), findsOneWidget);
    expect(
      tester
          .widget<TextField>(find.byKey(const Key('guide_input')))
          .controller!
          .text,
      isEmpty,
    );

    await tester.ensureVisible(find.widgetWithText(ActionChip, 'Mimarı kim?'));
    await tester.pump();
    await tester.tap(find.widgetWithText(ActionChip, 'Mimarı kim?'));
    await _settleRequests(tester);
    expect(
      find.textContaining(
        'Selimiye Camii (Merkez, Edirne)\nMimarı: Mimar Sinan',
      ),
      findsOneWidget,
    );
    // Öneriler yalnızca son yanıtın altındadır.
    expect(find.widgetWithText(ActionChip, 'Mimarı kim?'), findsNothing);
  });

  testWidgets('yeni sohbet geçmişi temizler ve duyurur', (tester) async {
    await pumpGuide(tester);
    await tester.tap(find.byKey(const Key('guide_starter_2')));
    await _settleRequests(tester);

    await tester.tap(find.byKey(const Key('guide_new_conversation')));
    await _settleRequests(tester);

    expect(find.byKey(const Key('guide_welcome')), findsOneWidget);
    expect(announcements.last, 'Yeni sohbet başlatıldı.');
  });

  testWidgets('acil durum yanıtında 112 uyarısı görünür', (tester) async {
    await pumpGuide(tester);

    await tester.enterText(
      find.byKey(const Key('guide_input')),
      'Selimiye Camii yanıyor',
    );
    await tester.testTextInput.receiveAction(TextInputAction.send);
    await _settleRequests(tester);

    expect(
      find.textContaining('112 Acil Çağrı Merkezi'),
      findsAtLeastNWidgets(1),
    );
    await tester.tap(find.text('Hasar bildir'));
    expect(actions.single, isA<GuideReportDamage>());
  });

  testWidgets('gönderim hatası duyurulur, tekrar dene yanıtı getirir', (
    tester,
  ) async {
    var calls = 0;
    final api = AssistantMockApi.withClock(
      clock: () => DateTime.utc(2026, 10, 19, 12),
    );
    await pumpGuide(
      tester,
      routes: [
        MockRoute('POST', 'assistant/messages', (request) {
          calls++;
          return calls == 1
              ? MockResponse.error(503, 'unavailable')
              : api.routes.first.handler(request);
        }),
      ],
    );

    await tester.tap(find.byKey(const Key('guide_starter_3')));
    await _settleRequests(tester);
    expect(find.byKey(const Key('guide_send_error')), findsOneWidget);
    expect(announcements.last, startsWith('Soru gönderilemedi.'));

    await tester.tap(find.byKey(const Key('guide_retry')));
    await _settleRequests(tester);
    expect(find.byKey(const Key('guide_send_error')), findsNothing);
    expect(find.textContaining('altı adımdır'), findsOneWidget);
    expect(find.text('Hasar nasıl bildiririm?'), findsOneWidget);
  });

  testWidgets('%200 metin ölçeğinde taşma olmaz', (tester) async {
    await pumpGuide(tester, textScale: 2);
    expect(tester.takeException(), isNull);

    // Büyük metinde örnekler kaydırılarak ulaşılır.
    await tester.scrollUntilVisible(
      find.byKey(const Key('guide_starter_0')),
      200,
      scrollable: find.descendant(
        of: find.byKey(const Key('guide_welcome')),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.tap(find.byKey(const Key('guide_starter_0')));
    await _settleRequests(tester);
    expect(tester.takeException(), isNull);
  });

  testWidgets('İngilizce arayüzde İngilizce yanıt', (tester) async {
    await pumpGuide(tester, locale: const Locale('en'));

    await tester.tap(find.byKey(const Key('guide_starter_0')));
    await _settleRequests(tester);

    expect(find.textContaining('Suleiman the Magnificent'), findsOneWidget);
    expect(find.text('Open Süleymaniye Mosque'), findsOneWidget);
  });

  group('sesli soru', () {
    Finder input() => find.byKey(const Key('guide_input'));

    String inputText(WidgetTester tester) =>
        tester.widget<TextField>(input()).controller!.text;

    testWidgets('mikrofon izni dokununca istenir; metin alana yazılır, '
        'otomatik gönderilmez', (tester) async {
      permissions.access[AppPermission.microphone] = PermissionAccess.denied;
      permissions.requestResults[AppPermission.microphone] =
          PermissionAccess.granted;
      await pumpGuide(tester);
      expect(permissions.requested, isEmpty);

      await tester.tap(find.byKey(const Key('guide_voice_start')));
      await tester.pump();
      expect(permissions.requested, [AppPermission.microphone]);
      expect(speech.languages, ['tr']);
      expect(find.byKey(const Key('guide_voice_listening')), findsOneWidget);
      expect(find.byKey(const Key('guide_voice_stop')), findsOneWidget);
      expect(
        announcements,
        contains('Dinleniyor… Sorunuzu söyleyin, bitince durdurun.'),
      );

      speech.hear('Selimiye');
      await tester.pump();
      expect(inputText(tester), 'Selimiye');
      // Dinlerken gönderilemez.
      final sendWhileListening = tester.widget<IconButton>(
        find.byKey(const Key('guide_send')),
      );
      expect(sendWhileListening.onPressed, isNull);

      speech.hear('Selimiye Camii nerede', isFinal: true);
      await tester.pump();
      await tester.pump();
      expect(inputText(tester), 'Selimiye Camii nerede');
      expect(find.byKey(const Key('guide_voice_listening')), findsNothing);
      expect(
        announcements,
        contains(
          "Söylediğiniz: Selimiye Camii nerede. Göndermek için Gönder'e "
          'dokunun.',
        ),
      );
      // Soru gönderilmedi; kullanıcı gözden geçirir.
      expect(find.byKey(const Key('guide_welcome')), findsOneWidget);
      final send = tester.widget<IconButton>(
        find.byKey(const Key('guide_send')),
      );
      expect(send.onPressed, isNotNull);
      await expectAccessible(tester);
    });

    testWidgets('yazılı metne eklenir; durdur sonucu bekler', (tester) async {
      await pumpGuide(tester);
      await tester.enterText(input(), 'Edirne');
      await tester.tap(find.byKey(const Key('guide_voice_start')));
      await tester.pump();

      speech.hear('camileri');
      await tester.pump();
      expect(inputText(tester), 'Edirne camileri');

      await tester.tap(find.byKey(const Key('guide_voice_stop')));
      await tester.pump();
      expect(speech.stops, 1);
      speech.end();
      await tester.pump();
      await tester.pump();
      expect(inputText(tester), 'Edirne camileri');
      expect(find.byKey(const Key('guide_voice_start')), findsOneWidget);
    });

    testWidgets('kalıcı retde ayarlara yönlendirir; dinleme başlamaz', (
      tester,
    ) async {
      permissions.access[AppPermission.microphone] =
          PermissionAccess.deniedForever;
      await pumpGuide(tester);

      await tester.tap(find.byKey(const Key('guide_voice_start')));
      await tester.pump();

      expect(speech.languages, isEmpty);
      expect(
        find.text('Mikrofon izni kapalı. Sistem ayarlarından açabilirsiniz.'),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const Key('guide_voice_settings')));
      await tester.pump();
      expect(permissions.settingsOpened, 1);
      await expectAccessible(tester);
    });

    testWidgets('konuşma anlaşılamazsa mesaj gösterilir ve duyurulur', (
      tester,
    ) async {
      await pumpGuide(tester);
      await tester.tap(find.byKey(const Key('guide_voice_start')));
      await tester.pump();

      speech.fail(SpeechInputIssue.noMatch);
      await tester.pump();
      await tester.pump();

      const message = 'Konuşmanız anlaşılamadı. Tekrar deneyin veya yazın.';
      expect(find.text(message), findsOneWidget);
      expect(announcements, contains(message));
      expect(find.byKey(const Key('guide_voice_start')), findsOneWidget);
    });

    testWidgets('tarayıcıda/cihazda tanıma yoksa buton gizlenir', (
      tester,
    ) async {
      await pumpGuide(tester);
      await tester.tap(find.byKey(const Key('guide_voice_start')));
      await tester.pump();
      speech.fail(SpeechInputIssue.unavailable);
      await tester.pump();
      await tester.pump();

      expect(find.byKey(const Key('guide_voice_start')), findsNothing);
      expect(
        find.text(
          'Bu cihazda veya tarayıcıda sesli soru kullanılamıyor. Sorunuzu '
          'yazabilirsiniz.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('desteklenmeyen platformda mikrofon butonu yoktur', (
      tester,
    ) async {
      speech = FakeSpeechInputService(isSupported: false);
      await pumpGuide(tester);
      expect(find.byKey(const Key('guide_voice_start')), findsNothing);
    });

    testWidgets('%200 metin ölçeğinde dinleme durumu taşmaz', (tester) async {
      await pumpGuide(tester, textScale: 2);
      await tester.tap(find.byKey(const Key('guide_voice_start')));
      await tester.pump();
      speech.hear('Süleymaniye');
      await tester.pump();
      expect(tester.takeException(), isNull);
      await expectAccessible(tester);
    });
  });
}
