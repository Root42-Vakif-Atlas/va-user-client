import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/a11y/reduce_motion.dart';
import 'package:vakif_atlas/core/theme/tokens/app_durations.dart';

void main() {
  Future<Duration> resolve(WidgetTester tester, {required bool reduce}) async {
    late Duration duration;
    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(disableAnimations: reduce),
        child: Builder(
          builder: (context) {
            duration = context.motionDuration(AppDurations.normal);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    return duration;
  }

  testWidgets('hareket azaltma kapalıyken süre korunur', (tester) async {
    expect(await resolve(tester, reduce: false), AppDurations.normal);
  });

  testWidgets('hareket azaltma açıkken süre anlık olur', (tester) async {
    expect(await resolve(tester, reduce: true), AppDurations.instant);
  });
}
