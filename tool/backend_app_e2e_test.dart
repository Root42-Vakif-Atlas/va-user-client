// Uygulamanın kendisi (gerçek DI grafiği, interceptor zinciri ve ekranlar)
// çalışan backend'e karşı uçtan uca: kayıt (yanlış e-postayı düzeltme) →
// Mailpit'teki kodla doğrulama → rota oluştur / düzenle / PDF arşivi / sil →
// kaydedilen eserin sunucuya eşitlenmesi.
//
// Önkoşul: backend çalışıyor (`backend/deploy/compose`: API
// http://localhost:8080/v1/, Mailpit http://localhost:8025).
//   flutter test tool/backend_app_e2e_test.dart
//
// `test/` dışında olduğundan normal `flutter test` çalıştırmasına dahil değildir.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';
import 'package:vakif_atlas/app.dart';
import 'package:vakif_atlas/core/config/app_config.dart';
import 'package:vakif_atlas/core/config/app_environment.dart';
import 'package:vakif_atlas/core/di/injection.dart';
import 'package:vakif_atlas/core/network/http_transport.dart';
import 'package:vakif_atlas/core/network/network_constants.dart';
import 'package:vakif_atlas/core/router/app_router.dart';
import 'package:vakif_atlas/core/router/routes.dart';
import 'package:vakif_atlas/core/storage/installation_id_service.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vakif_atlas/features/route_export/data/sources/route_export_local_data_source.dart';
import 'package:vakif_atlas/features/route_export/domain/repositories/route_export_repository.dart';
import 'package:vakif_atlas/features/route_planner/data/sources/route_remote_data_source.dart';
import 'package:vakif_atlas/features/route_planner/presentation/bloc/route_builder_bloc.dart';
import 'package:vakif_atlas/features/saved_monuments/data/sources/saved_monuments_local_data_source.dart';
import 'package:vakif_atlas/features/saved_monuments/data/sources/saved_monuments_remote_data_source.dart';
import 'package:vakif_atlas/features/saved_monuments/presentation/cubit/saved_monuments_cubit.dart';

import '../test/helpers/route_export_test_utils.dart';
import '../test/helpers/saved_monuments_test_utils.dart';
import '../test/helpers/test_di.dart';

const String _api = String.fromEnvironment(
  'API',
  defaultValue: 'http://localhost:8080/v1/',
);
const String _mailpit = String.fromEnvironment(
  'MAILPIT',
  defaultValue: 'http://localhost:8025',
);

Future<Object?> _getJson(Uri uri, {Map<String, String> headers = const {}}) =>
    HttpClient()
        .getUrl(uri)
        .then((request) {
          headers.forEach(request.headers.set);
          return request.close();
        })
        .then((response) async {
          final body = await response.transform(utf8.decoder).join();
          return body.isEmpty ? null : jsonDecode(body);
        });

/// Mailpit'te [email]'e giden son kodu bekler.
Future<String> _mailCode(String email) async {
  for (var i = 0; i < 40; i++) {
    final search = await _getJson(
      Uri.parse('$_mailpit/api/v1/search?query=to:$email'),
    ) as Map<String, dynamic>;
    final messages = search['messages'] as List<dynamic>;
    if (messages.isNotEmpty) {
      final id = (messages.first as Map<String, dynamic>)['ID'];
      final message = await _getJson(
        Uri.parse('$_mailpit/api/v1/message/$id'),
      ) as Map<String, dynamic>;
      final match = RegExp(r'\b(\d{6})\b')
          .firstMatch(message['Text'] as String);
      if (match != null) {
        return match.group(1)!;
      }
    }
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }
  throw StateError('Mailpit: $email için kod gelmedi');
}

/// Katalogdan örnek eser anahtarları: ilk sayfa ve konumlu olanlar (rota
/// yalnızca konumlu eserlerle kurulur; VGM verisi konumsuz gelebilir).
Future<(List<String> all, List<String> located)> _sampleWorks() async {
  final page = await _getJson(
    Uri.parse('${_api}catalog/works?limit=50'),
  ) as Map<String, dynamic>;
  final items = (page['items'] as List<dynamic>).cast<Map<String, dynamic>>();
  return (
    [for (final item in items) item['key'] as String],
    [
      for (final item in items)
        if (item['location'] != null) item['key'] as String,
    ],
  );
}

/// Uygulamanın silinip yeniden kurulmasını taklit eder: yeni kurulum kimliği.
final class _FreshInstallation implements InstallationIdService {
  final String _id = const Uuid().v4();

  @override
  Future<String> resolve() async => _id;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  tearDown(resetDependencies);

  /// Gerçek ağ yanıtları sahte zaman dışında tamamlanır: kısa gerçek
  /// beklemeler ile çerçeve ilerletilir.
  Future<void> settle(WidgetTester tester, [int rounds = 15]) async {
    for (var i = 0; i < rounds; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)),
      );
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  String currentPath() => getIt<AppRouter>().router.state.uri.path;

  Future<void> tapKey(WidgetTester tester, String key) async {
    final target = find.byKey(Key(key));
    await tester.ensureVisible(target);
    await tester.tap(target);
    await settle(tester);
  }

  Future<void> enter(WidgetTester tester, String key, String text) async {
    await tester.enterText(find.byKey(Key(key)), text);
    await tester.pump();
  }

  Future<void> dismissCelebration(WidgetTester tester) async {
    final button = find.byKey(const Key('gamification_celebration_close'));
    if (button.evaluate().isNotEmpty) {
      await tester.tap(button);
      await settle(tester);
    }
  }

  testWidgets('uygulama backend ile uçtan uca eşitlenir', (tester) async {
    // flutter_test her testte HTTP'yi engeller; bu araç gerçek sunucuya bağlanır.
    HttpOverrides.global = null;
    tester.view.physicalSize =
        const Size(390, 1600) * tester.view.devicePixelRatio;
    addTearDown(tester.view.resetPhysicalSize);

    await TestDependencies.setUp(preferences: {'settings.language_code': 'tr'});
    final config = AppConfig.resolve(
      AppEnvironment.dev,
      overrides: const AppConfigOverrides(apiBaseUrl: _api),
    );
    getIt
      ..registerSingleton<AppConfig>(config)
      ..registerSingleton<HttpTransport>(PlatformHttpTransport(config))
      // Dosya sistemi eklentisi (path_provider → Hive, PDF dosyaları) test
      // ortamında yok; cihazdaki kopyalar bellekte tutulur.
      ..registerSingleton<RouteExportLocalDataSource>(
        InMemoryRouteExportLocalDataSource(),
      )
      ..registerSingleton<SavedMonumentsLocalDataSource>(
        InMemorySavedMonumentsLocalDataSource(),
      );
    final (works, located) = (await tester.runAsync(_sampleWorks))!;
    expect(works, isNotEmpty, reason: 'katalog boş');
    getIt<AuthBloc>().add(const AuthEvent.started());
    await tester.pumpWidget(const VakifAtlasApp());
    await settle(tester);

    // ── Kayıt: yanlış yazılan e-posta doğrulama ekranından düzeltilir ──
    final stamp = DateTime.now().millisecondsSinceEpoch;
    final typo = 'e2e$stamp@exmaple.org';
    final email = 'e2e$stamp@example.org';
    const password = 'kubbe altında bir gün';
    getIt<AppRouter>().router.go(AppRoutes.login);
    await settle(tester);
    await tapKey(tester, 'login_create_account_button');
    await enter(tester, 'register_name_field', 'Zeynep Karadağ');
    await enter(tester, 'register_email_field', typo);
    await enter(tester, 'register_password_field', password);
    await enter(tester, 'register_password_confirm_field', password);
    await tapKey(tester, 'register_terms_checkbox');
    await tapKey(tester, 'register_privacy_checkbox');
    await tapKey(tester, 'register_submit_button');
    await settle(tester, 20);
    expect(currentPath(), AppRoutes.verifyEmail);

    await tapKey(tester, 'verify_change_email_button');
    expect(currentPath(), AppRoutes.register);
    await enter(tester, 'register_email_field', email);
    await tapKey(tester, 'register_submit_button');
    await settle(tester, 20);
    expect(currentPath(), AppRoutes.verifyEmail);
    expect(find.textContaining(email), findsOneWidget);

    final code = (await tester.runAsync(() => _mailCode(email)))!;
    await enter(tester, 'verification_code_field', code);
    await tapKey(tester, 'verify_submit_button');
    await settle(tester, 20);
    expect(getIt<AuthBloc>().state, isA<AuthAuthenticated>());
    expect(currentPath(), AppRoutes.mapDiscovery);
    final userId = (getIt<AuthBloc>().state as AuthAuthenticated).user.id;

    // ── Harita: konumlu eserler karolardan işaretçi olarak çizilir ──
    Finder markers(String prefix) => find.byWidgetPredicate(
      (widget) =>
          widget.key is ValueKey<String> &&
          (widget.key! as ValueKey<String>).value.startsWith(prefix),
    );
    await settle(tester, 30);
    final drawn =
        markers('monument_cluster_').evaluate().length +
        markers('monument_pin_').evaluate().length +
        markers('monument_complex_').evaluate().length;
    if (located.isNotEmpty) {
      expect(drawn, greaterThan(0), reason: 'konumlu eser haritada görünür');
    }
    // ignore: avoid_print
    print('HARİTA işaretçi: $drawn');

    // ── Rota: oluştur → düzenle → PDF arşivi → sil ──
    // Konumlu en az iki eser yoksa (VGM verisi konumsuz) bölüm atlanır.
    if (located.length >= 2) {
      getIt<RouteBuilderBloc>(instanceName: RouteBuilderBloc.draftInstance)
        ..add(RouteBuilderEvent.monumentToggled(located[0]))
        ..add(RouteBuilderEvent.monumentToggled(located[1]));
      getIt<AppRouter>().router.go(AppRoutes.routePlanner);
      await settle(tester);
      unawaited(getIt<AppRouter>().router.push(AppRoutes.routeBuilder));
      await settle(tester, 20);
      await tapKey(tester, 'route_submit_button');
      await settle(tester, 20);
      await dismissCelebration(tester);
      expect(currentPath(), startsWith('${AppRoutes.routePlanner}/rt_'));

      // Yeniden kurulum (yeni kurulum kimliği) / başka cihaz: aynı hesapla
      // rota görünür — rotalar oturum açıkken hesaba aittir.
      final reinstalledRoutes = RouteRemoteDataSourceImpl(
        getIt<Dio>(instanceName: DioNames.api),
        _FreshInstallation(),
      ).fetchRoutes(languageCode: 'tr');
      await settle(tester, 10);
      expect(await reinstalledRoutes, hasLength(1));

      await tapKey(tester, 'route_edit_button');
      await settle(tester, 20);
      await tapKey(tester, 'route_submit_button');
      await settle(tester, 20);
      expect(currentPath(), startsWith('${AppRoutes.routePlanner}/rt_'));

      await tapKey(tester, 'route_export_button');
      await settle(tester, 40);
      expect(find.byKey(const Key('route_export_ready_sheet')), findsOneWidget);
      final exports = getIt<RouteExportRepository>().getExports(userId);
      await settle(tester, 10);
      expect(
        (await exports).getOrNull(),
        hasLength(1),
        reason: 'PDF sunucu arşivinde',
      );
      await tester.tapAt(const Offset(10, 10));
      await settle(tester);

      await tapKey(tester, 'route_delete_button');
      await tapKey(tester, 'route_delete_confirm_button');
      await settle(tester, 20);
      expect(currentPath(), AppRoutes.routePlanner);
      expect(find.byKey(const Key('route_list_empty')), findsOneWidget);
    } else {
      // ignore: avoid_print
      print('ATLANDI rota akışı: konumlu en az iki eser yok');
    }

    // ── Kaydedilen eser kuruluma bağlı olarak sunucuya eşitlenir ──
    // Sahte zaman bölgesinde başlatılır (depo kilidi o bölgenin mikro
    // görevleriyle ilerler); ağ yanıtları `settle` ile beklenir.
    unawaited(getIt<SavedMonumentsCubit>().toggle(works.first));
    await settle(tester, 20);
    // Sunucudaki hesap kümesi — başka bir kurulum kimliğiyle (yeniden
    // kurulum) sorulduğunda da gelir; cihaz kopyası değil.
    final server = SavedMonumentsRemoteDataSourceImpl(
      getIt<Dio>(instanceName: DioNames.api),
      _FreshInstallation(),
    ).fetch();
    await settle(tester, 10);
    expect([for (final item in await server) item.monumentId], [works.first]);

    await tester.pumpWidget(const SizedBox.shrink());
    await settle(tester);
    // Gerçek ağ akışlarının bıraktığı zamanlayıcılar (bildirim süreleri,
    // istek zaman aşımları) ağaç kapandıktan sonra boşaltılır.
    await tester.pump(const Duration(minutes: 30));
  });
}
