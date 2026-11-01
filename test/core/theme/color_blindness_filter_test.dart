import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/theme/color_blindness_filter.dart';
import 'package:vakif_atlas/core/theme/color_blindness_profile.dart';

typedef _Rgb = List<double>;

_Rgb _apply3x3(List<double> m, _Rgb c) => [
  for (var row = 0; row < 3; row++)
    m[row * 3] * c[0] + m[row * 3 + 1] * c[1] + m[row * 3 + 2] * c[2],
];

_Rgb _clamp(_Rgb c) => [for (final v in c) v.clamp(0.0, 1.0)];

double _distance(_Rgb a, _Rgb b) => math.sqrt(
  [for (var i = 0; i < 3; i++) math.pow(a[i] - b[i], 2)]
      .reduce((x, y) => x + y),
);

void main() {
  group('DaltonizationMatrix', () {
    test('none profili birim matristir', () {
      expect(
        DaltonizationMatrix.forProfile(ColorBlindnessProfile.none),
        <double>[1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0],
      );
    });

    test('ColorFilter.matrix için 20 elemanlı ve alfa korunur', () {
      for (final profile in ColorBlindnessProfile.values) {
        final matrix = DaltonizationMatrix.forProfile(profile);
        expect(matrix, hasLength(20));
        expect(matrix.sublist(15), <double>[0, 0, 0, 1, 0]);
      }
    });

    // Karıştırılan renk çiftleri, telafi sonrasında renk körü algısında
    // birbirinden daha uzak görünmelidir.
    final confusedPairs = <ColorBlindnessProfile, List<(_Rgb, _Rgb)>>{
      ColorBlindnessProfile.protanopia: [
        ([1, 0, 0], [0, 0.6, 0]),
        ([0.8, 0.2, 0.2], [0.4, 0.5, 0.2]),
      ],
      ColorBlindnessProfile.deuteranopia: [
        ([1, 0, 0], [0, 0.6, 0]),
        ([0.8, 0.2, 0.2], [0.4, 0.5, 0.2]),
      ],
      ColorBlindnessProfile.tritanopia: [
        ([0, 0, 1], [0, 0.5, 0.5]),
        ([0.2, 0.4, 0.9], [0.2, 0.6, 0.5]),
      ],
    };

    for (final MapEntry(key: profile, value: pairs) in confusedPairs.entries) {
      test('$profile telafisi karışan renkleri ayrıştırır', () {
        final simulation = DaltonizationMatrix.simulation[profile]!;
        final correction = DaltonizationMatrix.correction3x3(profile);

        for (final (a, b) in pairs) {
          final before = _distance(
            _apply3x3(simulation, a),
            _apply3x3(simulation, b),
          );
          final after = _distance(
            _apply3x3(simulation, _clamp(_apply3x3(correction, a))),
            _apply3x3(simulation, _clamp(_apply3x3(correction, b))),
          );
          expect(after, greaterThan(before));
        }
      });
    }
  });

  group('AccessibilityColorFilter', () {
    testWidgets('none profilinde ağaca ColorFiltered eklenmez', (tester) async {
      await tester.pumpWidget(
        const AccessibilityColorFilter(
          profile: ColorBlindnessProfile.none,
          child: SizedBox.shrink(),
        ),
      );
      expect(find.byType(ColorFiltered), findsNothing);
    });

    testWidgets('aktif profilde kök ColorFiltered ile sarılır', (tester) async {
      await tester.pumpWidget(
        const AccessibilityColorFilter(
          profile: ColorBlindnessProfile.deuteranopia,
          child: SizedBox.shrink(),
        ),
      );
      expect(find.byType(ColorFiltered), findsOneWidget);
    });

    testWidgets('profil açılıp kapanınca alt ağaç yeniden kurulmaz', (
      tester,
    ) async {
      // Uygulamadaki gibi doğrudan alt öğe anahtarsızdır.
      Future<void> pump(ColorBlindnessProfile profile) => tester.pumpWidget(
        AccessibilityColorFilter(profile: profile, child: const _Probe()),
      );
      _ProbeState probe() => tester.state<_ProbeState>(find.byType(_Probe));

      await pump(ColorBlindnessProfile.none);
      final state = probe();
      await pump(ColorBlindnessProfile.protanopia);
      await pump(ColorBlindnessProfile.tritanopia);
      await pump(ColorBlindnessProfile.none);

      expect(probe(), same(state));
      expect(state.initCount, 1);
    });

    // Matris yalnızca hesaplanmakla kalmamalı, çizilen piksele uygulanmalı.
    testWidgets('çizilen pikseller telafi matrisine göre değişir', (
      tester,
    ) async {
      final boundary = GlobalKey();
      for (final profile in ColorBlindnessProfile.values) {
        await tester.pumpWidget(
          Center(
            child: RepaintBoundary(
              key: boundary,
              child: AccessibilityColorFilter(
                profile: profile,
                child: const SizedBox.square(
                  dimension: 8,
                  child: ColoredBox(color: Color(0xFFB03024)),
                ),
              ),
            ),
          ),
        );
        final pixel = await tester.runAsync(() async {
          final render =
              boundary.currentContext!.findRenderObject()!
                  as RenderRepaintBoundary;
          final image = await render.toImage();
          final data = await image.toByteData();
          return [for (var i = 0; i < 3; i++) data!.getUint8(i) / 255];
        });
        final expected = _clamp(
          _apply3x3(DaltonizationMatrix.correction3x3(profile), [
            0xB0 / 255,
            0x30 / 255,
            0x24 / 255,
          ]),
        );
        for (var i = 0; i < 3; i++) {
          expect(pixel![i], closeTo(expected[i], 2 / 255), reason: '$profile');
        }
      }
    });
  });
}

class _Probe extends StatefulWidget {
  const _Probe();

  @override
  State<_Probe> createState() => _ProbeState();
}

class _ProbeState extends State<_Probe> {
  int initCount = 0;

  @override
  void initState() {
    super.initState();
    initCount++;
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
