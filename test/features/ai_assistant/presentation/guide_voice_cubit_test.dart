import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/permissions/permission_service.dart';
import 'package:vakif_atlas/features/ai_assistant/presentation/cubit/guide_voice_cubit.dart';

import '../../../helpers/permission_test_utils.dart';
import '../../../helpers/speech_test_utils.dart';

void main() {
  Future<void> flush() => Future<void>.delayed(Duration.zero);

  test('izin verilmezse dinleme başlamaz; sonraki dokunuşta yeniden '
      'sorulur', () async {
    final speech = FakeSpeechInputService();
    final permissions = FakePermissionService(
      access: {AppPermission.microphone: PermissionAccess.denied},
    );
    final cubit = GuideVoiceCubit(speech, permissions);

    await cubit.toggle(languageCode: 'tr');
    expect(cubit.state.issue, GuideVoiceIssue.permissionDenied);
    expect(cubit.state.status, GuideVoiceStatus.idle);
    expect(speech.languages, isEmpty);

    permissions.requestResults[AppPermission.microphone] =
        PermissionAccess.granted;
    await cubit.toggle(languageCode: 'en');
    expect(permissions.requested, [
      AppPermission.microphone,
      AppPermission.microphone,
    ]);
    expect(cubit.state.isListening, isTrue);
    expect(cubit.state.issue, isNull);
    expect(speech.languages, ['en']);
    await cubit.close();
  });

  test('sessizlikle biten oturum "anlaşılamadı" olur', () async {
    final speech = FakeSpeechInputService();
    final cubit = GuideVoiceCubit(speech, FakePermissionService());
    await cubit.toggle(languageCode: 'tr');

    speech.end();
    await flush();

    expect(cubit.state.status, GuideVoiceStatus.idle);
    expect(cubit.state.issue, GuideVoiceIssue.noMatch);
    await cubit.close();
  });

  test('eski oturumun olayları yeni oturumu etkilemez', () async {
    final speech = FakeSpeechInputService();
    final cubit = GuideVoiceCubit(speech, FakePermissionService());
    await cubit.toggle(languageCode: 'tr');
    speech.hear('ilk', isFinal: true);
    await flush();
    expect(cubit.state.transcript, 'ilk');

    await cubit.toggle(languageCode: 'tr');
    expect(cubit.state.session, 2);
    expect(cubit.state.transcript, isEmpty);
    await cubit.close();
  });

  test('kapanınca süren dinleme iptal edilir', () async {
    final speech = FakeSpeechInputService();
    final cubit = GuideVoiceCubit(speech, FakePermissionService());
    await cubit.toggle(languageCode: 'tr');

    await cubit.close();

    expect(speech.cancels, 1);
  });

  test('durum metni loglara sızmaz', () async {
    final speech = FakeSpeechInputService();
    final cubit = GuideVoiceCubit(speech, FakePermissionService());
    await cubit.toggle(languageCode: 'tr');
    speech.hear('gizli soru');
    await flush();

    expect(cubit.state.toString(), isNot(contains('gizli')));
    await cubit.close();
  });
}
