import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/security/privacy_screen_guard.dart';
import 'package:vakif_atlas/core/theme/launch_colors.dart';
import 'package:vakif_atlas/shared/widgets/atoms/brand_emblem.dart';
import 'package:vakif_atlas/shared/widgets/organisms/privacy_screen_overlay.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('PrivacyScreenGuard', () {
    late PrivacyScreenGuard guard;

    setUp(
      () => guard = PrivacyScreenGuard.forPlatform(
        TargetPlatform.android,
        isWeb: false,
      ),
    );

    tearDown(() => guard.dispose());

    test('arka plan durumlarında içerik gizlenir, dönüşte gösterilir', () {
      for (final state in [
        AppLifecycleState.inactive,
        AppLifecycleState.hidden,
        AppLifecycleState.paused,
      ]) {
        guard.handleLifecycleState(state);
        expect(guard.isObscured.value, isTrue, reason: state.name);
      }

      guard.handleLifecycleState(AppLifecycleState.resumed);
      expect(guard.isObscured.value, isFalse);
    });

    testWidgets('mobilde yaşam döngüsü olaylarını dinler', (tester) async {
      await guard.enableProtection();

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      expect(guard.isObscured.value, isTrue);

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      expect(guard.isObscured.value, isFalse);
    });

    testWidgets('masaüstünde koruma etkinleşmez (odak kaybı sık yaşanır)', (
      tester,
    ) async {
      final desktop = PrivacyScreenGuard.forPlatform(
        TargetPlatform.macOS,
        isWeb: false,
      );
      addTearDown(desktop.dispose);
      await desktop.enableProtection();

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);

      expect(desktop.isObscured.value, isFalse);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    });
  });

  testWidgets('PrivacyScreenOverlay gizlendiğinde marka örtüsü gösterir', (
    tester,
  ) async {
    final obscured = ValueNotifier<bool>(false);
    addTearDown(obscured.dispose);
    await tester.pumpApp(
      PrivacyScreenOverlay(
        isObscured: obscured,
        child: const Text('Hassas içerik'),
      ),
    );
    expect(find.byKey(const Key('privacy_screen_cover')), findsNothing);

    obscured.value = true;
    await tester.pump();

    expect(find.byKey(const Key('privacy_screen_cover')), findsOneWidget);
    expect(find.bySemanticsLabel('Uygulama içeriği gizlendi'), findsOneWidget);
    // Açılış ekranıyla aynı sade örtü: marka zemini + yalnızca amblem.
    final cover = find.byKey(const Key('privacy_screen_cover'));
    expect(tester.widget<ColoredBox>(cover).color, LaunchColors.background);
    expect(
      find.descendant(of: cover, matching: find.byType(BrandEmblem)),
      findsOneWidget,
    );
    expect(
      find.descendant(of: cover, matching: find.byType(Text)),
      findsNothing,
    );
  });
}
