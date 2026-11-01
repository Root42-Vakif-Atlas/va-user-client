import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/a11y/haptic_feedback_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<String?> pulses;
  late List<Duration> gaps;
  late HapticFeedbackService service;

  setUp(() {
    pulses = [];
    gaps = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          if (call.method == 'HapticFeedback.vibrate') {
            pulses.add(call.arguments as String?);
          }
          return null;
        });
    service = HapticFeedbackService.withDelay((duration) async {
      gaps.add(duration);
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });

  test('success: hafif → orta yükselen desen', () async {
    await service.success();
    expect(pulses, [
      'HapticFeedbackType.lightImpact',
      'HapticFeedbackType.mediumImpact',
    ]);
    expect(gaps, [HapticFeedbackService.patternGap]);
  });

  test('warning: iki orta darbe', () async {
    await service.warning();
    expect(pulses, [
      'HapticFeedbackType.mediumImpact',
      'HapticFeedbackType.mediumImpact',
    ]);
  });

  test('error: üç güçlü darbe, diğer desenlerden ayırt edilebilir', () async {
    await service.error();
    expect(pulses, List.filled(3, 'HapticFeedbackType.heavyImpact'));
    expect(gaps, hasLength(2));
  });

  test('selection: tek seçim tıkı', () async {
    await service.selection();
    expect(pulses, ['HapticFeedbackType.selectionClick']);
  });

  test('kullanıcı titreşimi kapattıysa hiçbir desen çalınmaz', () async {
    service.enabled = false;
    await service.success();
    await service.error();
    await service.selection();
    await service.mapPinTap();
    expect(pulses, isEmpty);
    expect(gaps, isEmpty);
  });

  test('mapPinTap: tek güçlü darbe', () async {
    await service.mapPinTap();
    expect(pulses, ['HapticFeedbackType.heavyImpact']);
    expect(gaps, isEmpty);
  });
}
