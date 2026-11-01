import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/theme/app_theme.dart';
import 'package:vakif_atlas/shared/widgets/organisms/map_complex_marker.dart';

void main() {
  Future<void> pump(
    WidgetTester tester, {
    required VoidCallback onTap,
    bool selected = false,
    ThemeData? theme,
  }) => tester.pumpWidget(
    MaterialApp(
      theme: theme ?? AppTheme.light(),
      home: Scaffold(
        body: Center(
          child: SizedBox.square(
            dimension: MapComplexMarker.extent(selected: selected),
            child: MapComplexMarker(
              memberCount: 11,
              selected: selected,
              semanticsLabel: 'Süleymaniye Külliyesi, külliye, 11 yapı',
              onTap: onTap,
            ),
          ),
        ),
      ),
    ),
  );

  testWidgets('adlandırılmış, seçilebilir buton; rozet sayıyı gösterir', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    var taps = 0;
    await pump(tester, onTap: () => taps++);

    expect(find.text('11'), findsOneWidget);
    expect(
      tester.getSemantics(find.byType(MapComplexMarker)),
      matchesSemantics(
        label: 'Süleymaniye Külliyesi, külliye, 11 yapı',
        isButton: true,
        hasTapAction: true,
        hasSelectedState: true,
      ),
    );
    await tester.tap(find.byType(MapComplexMarker));
    expect(taps, 1);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    semantics.dispose();
  });

  testWidgets('seçili halde büyür ve seçili olarak okunur', (tester) async {
    final semantics = tester.ensureSemantics();
    await pump(tester, onTap: () {}, selected: true, theme: AppTheme.dark());

    expect(
      tester.getSemantics(find.byType(MapComplexMarker)),
      matchesSemantics(
        label: 'Süleymaniye Külliyesi, külliye, 11 yapı',
        isButton: true,
        hasTapAction: true,
        hasSelectedState: true,
        isSelected: true,
      ),
    );
    expect(
      MapComplexMarker.extent(selected: true),
      greaterThan(MapComplexMarker.extent(selected: false)),
    );
    semantics.dispose();
  });
}
