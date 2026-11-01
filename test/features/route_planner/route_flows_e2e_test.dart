import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/app.dart';
import 'package:vakif_atlas/core/di/injection.dart';
import 'package:vakif_atlas/core/router/app_router.dart';
import 'package:vakif_atlas/core/router/routes.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vakif_atlas/features/catalog/presentation/widgets/monument_search_view.dart';

import '../../helpers/catalog_test_utils.dart';
import '../../helpers/test_di.dart';

/// Gerçek uygulama, router ve Mock `/routes` API ile rota oluşturma,
/// görüntüleme, düzenleme ve silme yolculukları.
void main() {
  late TestDependencies dependencies;

  tearDown(resetDependencies);

  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize =
        const Size(390, 844) * tester.view.devicePixelRatio;
    addTearDown(tester.view.resetPhysicalSize);
    dependencies = await TestDependencies.setUp(
      preferences: {'settings.language_code': 'tr'},
    );
    getIt<AuthBloc>().add(const AuthEvent.started());
    await tester.pumpWidget(const VakifAtlasApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
  }

  Uri currentUri() => getIt<AppRouter>().router.state.uri;

  Future<void> tapKey(WidgetTester tester, String key) async {
    final target = find.byKey(Key(key));
    await tester.ensureVisible(target);
    await tester.pumpAndSettle();
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  /// Eser seçici haritadaki aramayı kullanır: her eser adıyla aranıp
  /// sonuçtan seçilir.
  Future<void> pickMonuments(WidgetTester tester, List<String> ids) async {
    await tapKey(tester, 'route_add_monuments_button');
    final names = {for (final pin in fixturePins()) pin.id: pin.name};
    for (final id in ids) {
      await tester.enterText(
        find.byKey(const Key('monument_search_field')),
        names[id]!,
      );
      await tester.pump(MonumentSearchView.debounce);
      await tester.pumpAndSettle();
      await tapKey(tester, 'route_pick_$id');
    }
    await tapKey(tester, 'route_picker_done_button');
  }

  Future<void> openRoutesTab(WidgetTester tester) async {
    await tester.tap(find.byKey(const Key('nav_route_planner')));
    await tester.pumpAndSettle();
  }

  testWidgets('Rotalar → yeni rota → eser seç, mola ekle → oluştur → detay', (
    tester,
  ) async {
    await pumpApp(tester);
    await openRoutesTab(tester);
    expect(find.byKey(const Key('route_list_empty')), findsOneWidget);

    await tapKey(tester, 'route_new_button');
    expect(currentUri().path, AppRoutes.routeBuilder);
    expect(find.byKey(const Key('route_builder_empty_hint')), findsOneWidget);

    await pickMonuments(tester, [
      'suleymaniye-camii',
      'selimiye-camii',
      'bursa-ulu-camii',
    ]);
    expect(find.text('Duraklar (3/10)'), findsOneWidget);
    expect(find.textContaining('Selimiye Camii'), findsWidgets);
    expect(
      dependencies.announcements,
      contains('Selimiye Camii rotaya eklendi'),
    );

    // İlk durağın ziyaret süresi 1 sa → 1 sa 15 dk.
    await tapKey(tester, 'route_stop_visit_0');
    await tester.tap(
      find.descendant(
        of: find.byKey(const Key('route_stop_visit_0')),
        matching: find.byIcon(Icons.add_circle_outline),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byKey(const Key('route_stop_visit_0')),
        matching: find.text('1 sa 15 dk'),
      ),
      findsOneWidget,
    );

    // İkinci durağa yemek molası.
    await tapKey(tester, 'route_stop_add_break_1');
    await tapKey(tester, 'route_break_kind_meal');
    expect(find.byKey(const Key('route_stop_1_break_0')), findsOneWidget);

    await tapKey(tester, 'route_submit_button');

    expect(currentUri().path, startsWith('${AppRoutes.routePlanner}/rt_'));
    expect(find.byKey(const Key('route_map')), findsOneWidget);
    expect(find.text('İstanbul – Bursa Rotası'), findsWidgets);
    expect(find.byKey(const Key('route_summary_total')), findsOneWidget);
    expect(find.byKey(const Key('route_step_stop_2')), findsOneWidget);
    expect(find.text('Yemek molası · 45 dk'), findsOneWidget);
    expect(
      dependencies.announcements.any(
        (message) => message.startsWith('Rota oluşturuldu: 3 durak'),
      ),
      isTrue,
    );

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(currentUri().path, AppRoutes.routePlanner);
    expect(find.text('İstanbul – Bursa Rotası'), findsOneWidget);
    // Taslak oluşturulduktan sonra temizlenir.
    expect(find.byKey(const Key('route_draft_continue_button')), findsNothing);
  });

  testWidgets('tek eserle gönderim engellenir ve nedeni duyurulur', (
    tester,
  ) async {
    await pumpApp(tester);
    await openRoutesTab(tester);
    await tapKey(tester, 'route_new_button');
    await pickMonuments(tester, ['selimiye-camii']);

    await tapKey(tester, 'route_submit_button');

    expect(currentUri().path, AppRoutes.routeBuilder);
    expect(find.byKey(const Key('route_builder_error')), findsOneWidget);
    expect(
      dependencies.announcements,
      contains('Rota için en az 2 eser seçin.'),
    );
  });

  testWidgets('eser detayından "Rotaya ekle" taslağa ekler', (tester) async {
    await pumpApp(tester);

    getIt<AppRouter>().router.go(
      AppRoutes.monumentDetailPath('selimiye-camii'),
    );
    await tester.pumpAndSettle();
    await tapKey(tester, 'monument_route_button');
    expect(find.text('Rotadan çıkar'), findsOneWidget);
    expect(find.text('Rotaya eklendi · taslakta 1 eser'), findsOneWidget);

    await tester.tap(find.text('Rotaya git'));
    await tester.pumpAndSettle();

    expect(currentUri().path, AppRoutes.routeBuilder);
    expect(find.text('Duraklar (1/10)'), findsOneWidget);
    expect(find.byKey(const Key('route_stop_remove_0')), findsOneWidget);

    getIt<AppRouter>().router.go(AppRoutes.routePlanner);
    await tester.pumpAndSettle();
    expect(find.text('Taslak rotanızda 1 eser var'), findsOneWidget);
  });

  testWidgets('rota düzenlenir, sıra optimize edilir ve silinir', (
    tester,
  ) async {
    await pumpApp(tester);
    await openRoutesTab(tester);
    await tapKey(tester, 'route_new_button');
    // Edirne → Bursa → İstanbul: optimize edilince İstanbul araya girer.
    await pickMonuments(tester, [
      'selimiye-camii',
      'bursa-ulu-camii',
      'suleymaniye-camii',
    ]);
    await tapKey(tester, 'route_submit_button');
    final detailPath = currentUri().path;

    await tapKey(tester, 'route_edit_button');
    expect(currentUri().path, '$detailPath/edit');
    expect(find.text('Rotayı düzenle'), findsOneWidget);

    await tapKey(tester, 'route_optimize_button');
    expect(
      dependencies.announcements.any(
        (message) => message.startsWith('Sıra optimize edildi'),
      ),
      isTrue,
    );
    await tester.enterText(
      find.byKey(const Key('route_name_field')),
      'Üç Başkent',
    );
    await tester.pumpAndSettle();
    await tapKey(tester, 'route_submit_button');

    expect(currentUri().path, detailPath);
    expect(find.text('Üç Başkent'), findsWidgets);
    expect(find.text('Edirne → İstanbul → Bursa'), findsOneWidget);

    await tapKey(tester, 'route_delete_button');
    await tapKey(tester, 'route_delete_confirm_button');

    expect(currentUri().path, AppRoutes.routePlanner);
    expect(find.text('Rota silindi'), findsOneWidget);
    expect(find.byKey(const Key('route_list_empty')), findsOneWidget);
  });

  testWidgets('bilinmeyen rota bağlantısı listeye dönüş sunar', (tester) async {
    await pumpApp(tester);

    getIt<AppRouter>().router.go(AppRoutes.routeDetailPath('rt_yok'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('route_detail_not_found')), findsOneWidget);

    await tester.tap(find.text('Rotalarıma dön'));
    await tester.pumpAndSettle();
    expect(currentUri().path, AppRoutes.routePlanner);
  });
}
