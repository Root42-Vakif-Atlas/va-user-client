import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/app.dart';
import 'package:vakif_atlas/core/di/injection.dart';
import 'package:vakif_atlas/core/router/app_router.dart';
import 'package:vakif_atlas/core/router/routes.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/map_tile.dart';
import 'package:vakif_atlas/features/map_discovery/presentation/widgets/monument_markers.dart';
import 'package:vakif_atlas/shared/widgets/organisms/app_map.dart';
import 'package:vakif_atlas/shared/widgets/organisms/map_cluster_marker.dart';

import '../../helpers/catalog_test_utils.dart';
import '../../helpers/test_di.dart';

/// Gerçek uygulama, router ve Mock Catalog API ile harita → eser detayı
/// yolculukları ve derin bağlantılar.
void main() {
  tearDown(resetDependencies);

  /// Animasyonlar biter, kamera durma gecikmesi geçer, görünür karolar
  /// yüklenir.
  Future<void> settleMap(WidgetTester tester) async {
    for (var i = 0; i < 2; i++) {
      await tester.pumpAndSettle();
      await tester.pump(AppMap.cameraIdleDelay);
    }
    await tester.pumpAndSettle();
  }

  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize =
        const Size(390, 844) * tester.view.devicePixelRatio;
    addTearDown(tester.view.resetPhysicalSize);
    await TestDependencies.setUp(preferences: {'settings.language_code': 'tr'});
    getIt<AuthBloc>().add(const AuthEvent.started());
    await tester.pumpWidget(const VakifAtlasApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await settleMap(tester);
  }

  Future<void> go(WidgetTester tester, String location) async {
    getIt<AppRouter>().router.go(location);
    await tester.pumpAndSettle();
  }

  Uri currentUri() => getIt<AppRouter>().router.state.uri;

  Future<void> tapKey(WidgetTester tester, String key) async {
    final target = find.byKey(Key(key));
    await tester.ensureVisible(target);
    await tester.pumpAndSettle();
    await tester.tap(target);
    await settleMap(tester);
  }

  Finder previewText(String text) => find.descendant(
    of: find.byKey(const Key('monument_preview_card')),
    matching: find.text(text),
  );

  testWidgets('harita → pin → önizleme → detay → haritada göster', (
    tester,
  ) async {
    await pumpApp(tester);
    expect(currentUri().path, AppRoutes.mapDiscovery);
    // Genel ölçekte sunucu kümeleri karo karo gelir.
    expect(find.byType(MapClusterMarker), findsWidgets);

    // Trabzon'u içeren kümelere dokunuldukça (sınırına yakınlaşılır, yeni
    // seviyenin karoları istenir) Gülbahar Hatun Camii ayrı pin olur.
    final gulbahar = find.byKey(const Key('monument_pin_gulbahar-hatun-camii'));
    final trabzon = fixturePins()
        .firstWhere((p) => p.id == 'gulbahar-hatun-camii')
        .location!;
    for (var i = 0; i < 8 && gulbahar.evaluate().isEmpty; i++) {
      final cluster = tester
          .widget<MonumentClusterLayer>(find.byType(MonumentClusterLayer))
          .items
          .whereType<MapTileCluster>()
          .firstWhere(
            (c) =>
                trabzon.latitude >= c.bounds.south &&
                trabzon.latitude <= c.bounds.north &&
                trabzon.longitude >= c.bounds.west &&
                trabzon.longitude <= c.bounds.east,
          );
      await tapKey(tester, 'monument_cluster_${cluster.key}');
    }
    expect(gulbahar, findsOneWidget);

    await tapKey(tester, 'monument_pin_gulbahar-hatun-camii');
    expect(previewText('Gülbahar Hatun Camii'), findsOneWidget);

    await tapKey(tester, 'monument_preview_details_button');
    expect(currentUri().path, '/monument/gulbahar-hatun-camii');
    expect(find.byKey(const Key('monument_detail_name')), findsOneWidget);
    expect(find.text('Yavuz Sultan Selim'), findsWidgets);

    await tapKey(tester, 'monument_detail_show_on_map_button');
    expect(currentUri().path, AppRoutes.mapDiscovery);
    expect(
      currentUri().queryParameters[AppRoutes.monumentParameter],
      'gulbahar-hatun-camii',
    );
    expect(previewText('Gülbahar Hatun Camii'), findsOneWidget);
  });

  testWidgets('eser detayına derin bağlantı; geri dönüş haritaya', (
    tester,
  ) async {
    await pumpApp(tester);

    await go(tester, AppRoutes.monumentDetailPath('selimiye-camii'));
    expect(find.text('Selimiye Camii'), findsWidgets);
    expect(
      find.byKey(const Key('monument_detail_unesco_badge')),
      findsOneWidget,
    );

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(currentUri().path, AppRoutes.mapDiscovery);
    expect(find.byKey(const Key('map_discovery_map')), findsOneWidget);
  });

  testWidgets('bilinmeyen eser bağlantısı haritaya dönüş sunar', (
    tester,
  ) async {
    await pumpApp(tester);

    await go(tester, AppRoutes.monumentDetailPath('yok'));
    expect(find.byKey(const Key('monument_detail_not_found')), findsOneWidget);

    await tester.tap(find.text('Haritaya dön'));
    await tester.pumpAndSettle();
    expect(currentUri().path, AppRoutes.mapDiscovery);
  });

  testWidgets('/?monument=<id> haritayı eser seçili açar', (tester) async {
    await pumpApp(tester);

    await go(tester, AppRoutes.mapDiscoveryWithMonument('bursa-ulu-camii'));

    expect(previewText('Bursa Ulu Camii'), findsOneWidget);
  });

  testWidgets('dil değişince eserler yeni dilde yeniden yüklenir', (
    tester,
  ) async {
    await pumpApp(tester);
    await go(tester, AppRoutes.mapDiscoveryWithMonument('selimiye-camii'));
    expect(previewText('Selimiye Camii'), findsOneWidget);

    await tapKey(tester, 'map_account_button');
    await tapKey(tester, 'account_menu_settings');
    await tapKey(tester, 'settings_language__LanguageOption.english');
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(previewText('Selimiye Mosque'), findsOneWidget);
  });
}
