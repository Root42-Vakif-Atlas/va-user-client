import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/features/route_export/data/render/route_pdf_renderer.dart';
import 'package:vakif_atlas/features/route_export/presentation/route_document_builder.dart';

import '../../../helpers/catalog_test_utils.dart';
import '../../../helpers/route_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() => initializeDateFormatting('tr'));

  Future<String> render(List<String> ids) async {
    final route = await createTestRoute('Vakıf Rotası', ids);
    final document = buildRouteDocument(
      route,
      lookupAppLocalizations(const Locale('tr')),
      now: DateTime(2026, 10, 18),
    );
    final bytes = await RoutePdfRenderer().render(document);
    return latin1.decode(bytes);
  }

  test('geçerli, yazı tipi gömülü ve meta verili A4 PDF üretir', () async {
    final pdf = await render(['selimiye-camii', 'bursa-ulu-camii']);

    expect(pdf, startsWith('%PDF-1.5'));
    expect(pdf.trimRight(), endsWith('%%EOF'));
    expect(pdf, contains('/FontFile2'));
    expect(pdf, contains('/Title'));
    // Yer imleri (ana hat) başlıklardan oluşturulur.
    expect(pdf, contains('/Outlines'));
    // Durak konumu bağlantısı.
    expect(pdf, contains('openstreetmap.org'));
  });

  test('en fazla duraklı rota birden çok sayfaya taşar', () async {
    final pdf = await render([
      for (final pin in fixturePins().take(10)) pin.id,
    ]);
    expect(RegExp(r'/Type\s*/Page\b').allMatches(pdf).length, greaterThan(1));
  });
}
