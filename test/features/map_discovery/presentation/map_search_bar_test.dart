import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/features/map_discovery/presentation/widgets/map_search_bar.dart';

import '../../../helpers/pump_app.dart';

/// Arama çubuğu tek satırdır: sorgu ne kadar uzun olursa olsun yüksekliği
/// değişmez, metin "…" ile kısalır.
void main() {
  Future<double> barHeight(
    WidgetTester tester, {
    required String query,
    double textScale = 1,
  }) async {
    await tester.pumpApp(
      Align(
        alignment: Alignment.topCenter,
        child: MapSearchBar(
          query: query,
          activeFilterCount: 0,
          onOpenSearch: () {},
          onClearQuery: () {},
          onOpenFilters: () {},
        ),
      ),
      textScale: textScale,
      surfaceSize: const Size(320, 640),
    );
    expect(tester.takeException(), isNull);
    return tester.getSize(find.byKey(const Key('map_search_bar'))).height;
  }

  const long =
      'Süleymaniye Külliyesi Mimar Sinan Eminönü İstanbul Fatih Vakıf Eserleri';

  for (final scale in [1.0, 2.0]) {
    testWidgets('uzun sorgu çubuğu yükseltmez (metin ölçeği $scale)', (
      tester,
    ) async {
      final short = await barHeight(tester, query: '', textScale: scale);
      final withLong = await barHeight(tester, query: long, textScale: scale);
      expect(withLong, short);
    });
  }

  testWidgets('ipucu tam metindir ama tek satırdır ve "…" ile kısalır', (
    tester,
  ) async {
    await barHeight(tester, query: '');
    expect(find.text('Yer veya eser ara'), findsOneWidget);
    final text = tester.widget<Text>(find.text('Yer veya eser ara'));
    expect(text.maxLines, 1);
    expect(text.overflow, TextOverflow.ellipsis);
  });

  testWidgets('dar ekran + %200 metinde ipucu satır atlamaz, çubuk büyümez', (
    tester,
  ) async {
    final normal = await barHeight(tester, query: '', textScale: 1);
    final scaled = await barHeight(tester, query: '', textScale: 2);
    // Tek satır: yükseklik yalnızca tek satırın ölçekli boyu kadar artar.
    final lineHeight = tester.getSize(find.text('Yer veya eser ara')).height;
    expect(lineHeight, lessThan(60));
    expect(scaled, lessThanOrEqualTo(normal * 2));
  });

  testWidgets('ekran okuyucu etiketi tam ifadeyi korur', (tester) async {
    await barHeight(tester, query: '');
    expect(find.bySemanticsLabel('Yer veya eser ara'), findsOneWidget);
  });
}
