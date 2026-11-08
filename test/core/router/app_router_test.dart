import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/complex.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/a11y/haptic_feedback_service.dart';
import 'package:vakif_atlas/core/di/injection.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/map/map_tile_source.dart';
import 'package:vakif_atlas/core/media/photo_attacher.dart';
import 'package:vakif_atlas/core/router/app_router.dart';
import 'package:vakif_atlas/core/theme/app_theme.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/features/ai_assistant/data/repositories/digital_guide_repository_impl.dart';
import 'package:vakif_atlas/features/ai_assistant/data/sources/digital_guide_remote_data_source.dart';
import 'package:vakif_atlas/features/ai_assistant/domain/usecases/digital_guide_usecases.dart';
import 'package:vakif_atlas/features/ai_assistant/presentation/bloc/digital_guide_bloc.dart';
import 'package:vakif_atlas/features/ai_assistant/presentation/cubit/guide_voice_cubit.dart';
import 'package:vakif_atlas/features/auth/domain/entities/user_entity.dart';
import 'package:vakif_atlas/features/auth/domain/usecases/auth_usecases.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/login_bloc.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';
import 'package:vakif_atlas/features/catalog/domain/usecases/catalog_usecases.dart';
import 'package:vakif_atlas/features/catalog/presentation/bloc/monument_search_bloc.dart';
import 'package:vakif_atlas/features/civil_protection/presentation/bloc/damage_report_wizard_bloc.dart';
import 'package:vakif_atlas/features/civil_protection/presentation/cubit/damage_report_detail_cubit.dart';
import 'package:vakif_atlas/features/civil_protection/presentation/cubit/damage_report_list_cubit.dart';
import 'package:vakif_atlas/features/map_discovery/presentation/bloc/map_discovery_bloc.dart';
import 'package:vakif_atlas/features/map_discovery/presentation/cubit/monument_tiles_cubit.dart';
import 'package:vakif_atlas/features/map_discovery/presentation/cubit/user_location_cubit.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/bloc/memory_composer_bloc.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/bloc/memory_list_bloc.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/cubit/my_memories_cubit.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/cubit/complex_detail_cubit.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/cubit/complex_members_cubit.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/cubit/monument_detail_cubit.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/pages/complex_members_page.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/pages/complex_detail_page.dart';
import 'package:vakif_atlas/features/nearby_alerts/presentation/cubit/nearby_alerts_cubit.dart';
import 'package:vakif_atlas/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:vakif_atlas/features/route_export/domain/usecases/route_export_usecases.dart';
import 'package:vakif_atlas/features/route_export/presentation/cubit/route_export_cubit.dart';
import 'package:vakif_atlas/features/route_export/presentation/cubit/route_exports_cubit.dart';
import 'package:vakif_atlas/features/route_planner/domain/repositories/route_repository.dart';
import 'package:vakif_atlas/features/route_planner/domain/usecases/optimize_stop_order_usecase.dart';
import 'package:vakif_atlas/features/route_planner/domain/usecases/route_usecases.dart';
import 'package:vakif_atlas/features/route_planner/presentation/bloc/route_builder_bloc.dart';
import 'package:vakif_atlas/features/route_planner/presentation/cubit/route_list_cubit.dart';
import 'package:vakif_atlas/features/saved_monuments/presentation/cubit/saved_monuments_list_cubit.dart';
import 'package:vakif_atlas/features/settings/domain/entities/app_settings.dart';
import 'package:vakif_atlas/features/settings/presentation/cubit/app_settings_cubit.dart';
import 'package:vakif_atlas/features/settings/presentation/cubit/app_settings_state.dart';
import 'package:vakif_atlas/features/settings/presentation/cubit/device_permissions_cubit.dart';
import 'package:vakif_atlas/features/settings/presentation/cubit/location_permission_cubit.dart';
import 'package:vakif_atlas/shared/widgets/templates/splash_view.dart';

import '../../helpers/catalog_test_utils.dart';
import '../../helpers/civil_protection_test_utils.dart';
import '../../helpers/gamification_test_utils.dart';
import '../../helpers/location_test_utils.dart';
import '../../helpers/map_test_utils.dart';
import '../../helpers/memory_test_utils.dart';
import '../../helpers/network_test_utils.dart';
import '../../helpers/notification_test_utils.dart';
import '../../helpers/onboarding_test_utils.dart';
import '../../helpers/permission_test_utils.dart';
import '../../helpers/route_export_test_utils.dart';
import '../../helpers/saved_monuments_test_utils.dart';
import '../../helpers/speech_test_utils.dart';
import '../../helpers/test_config.dart';
import '../../support/mock_api/ai_assistant/assistant_mock_api.dart';

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

class _MockSettingsCubit extends MockCubit<AppSettingsState>
    implements AppSettingsCubit {}

class _MockLogin extends Mock implements LoginUseCase {}

class _MockGetPins extends Mock implements GetMonumentPinsUseCase {}

class _MockGetMonumentDetail extends Mock implements GetMonumentDetailUseCase {}

class _MockGetComplexDetail extends Mock implements GetComplexDetailUseCase {
  @override
  ResultFuture<ComplexDetail> call(GetMonumentDetailParams params) async =>
      const Left(
        ServerFailure(kind: ServerFailureKind.notFound, statusCode: 404),
      );
}

class _MockGetComplexMembers extends Mock implements GetComplexMembersUseCase {}

class _MockRouteRepository extends Mock implements RouteRepository {}

void main() {
  const user = UserEntity(
    id: 'usr_1',
    displayName: 'Ayşe Yılmaz',
    email: 'ayse@example.org',
  );

  late _MockAuthBloc authBloc;
  late StreamController<AuthState> authStates;
  late AppRouter appRouter;
  late RouteBuilderBloc routeDraft;
  late SavedMonumentsTestEnvironment saved;
  late GamificationTestEnvironment gamification;
  late OnboardingCubit onboarding;

  setUpAll(() {
    registerFallbackValue(
      const GetMonumentPinsParams(ids: [], languageCode: 'tr'),
    );
    registerFallbackValue(
      const GetMonumentDetailParams(id: 'id', languageCode: 'tr'),
    );
  });

  setUp(() async {
    authBloc = _MockAuthBloc();
    authStates = StreamController<AuthState>.broadcast();
    getIt.registerFactory<LoginBloc>(() => LoginBloc(_MockLogin()));

    final getMonuments = _MockGetPins();
    when(() => getMonuments(any()))
        .thenAnswer((_) async => const Right(<MonumentPin>[]));
    getIt
      ..registerFactory<MapDiscoveryBloc>(() {
        final catalog = catalogUseCases();
        return MapDiscoveryBloc(catalog.extent, catalog.detail, catalog.search);
      })
      ..registerFactory<MonumentTilesCubit>(
        () => MonumentTilesCubit(catalogUseCases().tile),
      )
      ..registerFactory<MonumentSearchBloc>(
        () => MonumentSearchBloc(catalogUseCases().search),
      )
      ..registerFactory<UserLocationCubit>(
        () => UserLocationCubit(FakeLocationService()),
      )
      ..registerFactory<LocationPermissionCubit>(
        () => LocationPermissionCubit(FakeLocationService()),
      )
      ..registerFactory<DevicePermissionsCubit>(
        () => DevicePermissionsCubit(FakePermissionService()),
      )
      ..registerLazySingleton<NearbyAlertsCubit>(
        testNearbyAlertsCubit,
        dispose: (cubit) => cubit.close(),
      );
    final exports = testRouteExportRepository(
      renderer: FakeRoutePdfRenderer(),
      local: InMemoryRouteExportLocalDataSource(),
    );
    getIt
      ..registerFactory<RouteExportCubit>(
        () => RouteExportCubit(
          CreateRouteExportUseCase(exports),
          CreateRouteExportShareLinkUseCase(exports),
        ),
      )
      ..registerFactory<RouteExportsCubit>(
        () => RouteExportsCubit(
          GetRouteExportsUseCase(exports),
          OpenRouteExportUseCase(exports),
          CreateRouteExportShareLinkUseCase(exports),
          DeleteRouteExportUseCase(exports),
          WatchRouteExportChangesUseCase(exports),
        ),
      );
    final getMonumentDetail = _MockGetMonumentDetail();
    when(() => getMonumentDetail(any())).thenAnswer(
      (_) async => const Left(
        ServerFailure(kind: ServerFailureKind.notFound, statusCode: 404),
      ),
    );
    getIt
      ..registerFactory<MonumentDetailCubit>(
        () => MonumentDetailCubit(getMonumentDetail, _MockGetComplexMembers()),
      )
      // Sayfa içeriği ayrı sayfa testlerinde; burada yalnızca rota.
      ..registerFactory<ComplexDetailCubit>(
        () => ComplexDetailCubit(_MockGetComplexDetail()),
      )
      ..registerFactory<ComplexMembersCubit>(
        () => ComplexMembersCubit(catalogUseCases().complexMembers),
      );
    final civil = CivilProtectionTestEnvironment();
    getIt
      ..registerFactory<DamageReportListCubit>(civil.listCubit)
      ..registerFactory<DamageReportDetailCubit>(civil.detailCubit)
      ..registerFactory<DamageReportWizardBloc>(civil.wizardBloc);
    final memories = MemoryTestEnvironment().useCases;
    // "Anılarım": demo hesabıyla oturum açık, iki anısı olan ortam.
    final mine = MemoryTestEnvironment(initialState: ownMemoryState(2));
    await mine.signIn();
    getIt.registerFactory<MyMemoriesCubit>(
      () => MyMemoriesCubit(
        mine.useCases.mine,
        mine.useCases.delete,
        catalogUseCases().pins,
        mine.useCases.watch,
      ),
    );
    getIt
      ..registerFactory<MemoryListBloc>(
        () => MemoryListBloc(
          memories.get,
          memories.delete,
          memories.report,
          memories.watch,
        ),
      )
      ..registerFactory<MemoryComposerBloc>(
        () => MemoryComposerBloc(
          getMonumentDetail,
          memories.create,
          PhotoAttacher(
            FakePhotoPickerService(),
            const FakePhotoProcessor(),
            FakePermissionService(),
          ),
        ),
      );

    final guide = DigitalGuideRepositoryImpl(
      DigitalGuideRemoteDataSourceImpl(testDio(AssistantMockApi().routes)),
    );
    getIt.registerFactory<DigitalGuideBloc>(
      () => DigitalGuideBloc(
        AskGuideUseCase(guide),
        EndGuideConversationUseCase(guide),
      ),
    );
    getIt.registerFactory<GuideVoiceCubit>(
      () => GuideVoiceCubit(FakeSpeechInputService(), FakePermissionService()),
    );

    final routes = _MockRouteRepository();
    when(() => routes.changes).thenAnswer((_) => const Stream.empty());
    when(() => routes.getRoutes(languageCode: any(named: 'languageCode')))
        .thenAnswer((_) async => const Right([]));
    getIt.registerFactory<RouteListCubit>(
      () => RouteListCubit(
        GetRoutesUseCase(routes),
        WatchRouteChangesUseCase(routes),
      ),
    );
    saved = SavedMonumentsTestEnvironment();
    gamification = GamificationTestEnvironment();
    getIt.registerFactory<SavedMonumentsListCubit>(saved.listCubit);
    routeDraft = RouteBuilderBloc(
      getMonuments,
      GetRouteUseCase(routes),
      SaveRouteUseCase(routes),
      const OptimizeStopOrderUseCase(),
      PreviewRouteUseCase(routes),
      GetTravelMatrixUseCase(routes),
    );
  });

  tearDown(() async {
    appRouter.dispose();
    await routeDraft.close();
    await authStates.close();
    await onboarding.close();
    await resetDependencies();
  });

  /// Profil artık alt gezinme sekmesi değil; haritadaki hesap menüsünden açılır.
  Future<void> openProfileFromAccountMenu(WidgetTester tester) async {
    await tester.tap(find.byKey(const Key('map_account_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('account_menu_profile')));
    await tester.pumpAndSettle();
  }

  Future<void> pumpRouter(
    WidgetTester tester, {
    required AuthState initial,
    Size size = const Size(390, 844),
    bool onboardingCompleted = true,
    AppSettings? settings,
  }) async {
    tester.view.physicalSize = size * tester.view.devicePixelRatio;
    addTearDown(tester.view.resetPhysicalSize);
    whenListen(authBloc, authStates.stream, initialState: initial);

    final settingsCubit = _MockSettingsCubit();
    when(
      () => settingsCubit.state,
    ).thenReturn(AppSettingsState(settings: settings ?? AppSettings.defaults));

    onboarding = onboardingCubit(completed: onboardingCompleted);
    appRouter = AppRouter(
      authBloc,
      onboarding,
      testAppConfig(),
      HapticFeedbackService.withDelay((_) async {}),
      A11yAnnouncer.withSender((_, _, _, _) async {}),
      routeDraft,
      saved.cubit(),
      gamification.cubit(),
      PackageInfo(
        appName: 'Vakıf Atlas',
        packageName: 'tr.gov.vgm.vakif_atlas',
        version: '1.0.0',
        buildNumber: '42',
      ),
    );

    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(
            value: A11yAnnouncer.withSender((_, _, _, _) async {}),
          ),
          RepositoryProvider.value(
            value: HapticFeedbackService.withDelay((_) async {}),
          ),
          RepositoryProvider<MapTileSource>.value(value: testMapTileSource()),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>.value(value: authBloc),
            BlocProvider<AppSettingsCubit>.value(value: settingsCubit),
          ],
          child: MaterialApp.router(
            theme: AppTheme.dark(),
            locale: const Locale('tr'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: appRouter.router,
          ),
        ),
      ),
    );
    // Açılış ekranındaki yükleme göstergesi sürekli döndüğünden oturum
    // bilinmiyorken sabit süreli pump kullanılır.
    if (initial is AuthUnknown) {
      await tester.pump(const Duration(milliseconds: 500));
    } else {
      await tester.pumpAndSettle();
    }
  }

  Future<void> emitAuth(WidgetTester tester, AuthState state) async {
    authStates.add(state);
    await tester.pumpAndSettle();
  }

  GoRouter router() => appRouter.router;

  testWidgets('oturum bilinmiyorken açılış, ardından guest olarak harita', (
    tester,
  ) async {
    await pumpRouter(tester, initial: const AuthState.unknown());
    expect(find.byType(SplashView), findsOneWidget);

    await emitAuth(tester, const AuthState.guest());

    expect(find.byKey(const Key('map_search_bar')), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('alt gezinmenin 4. sekmesi Sivil Koruma; misafir tanıtımı '
      'görür ve giriş sonrası sekmeye döner', (tester) async {
    await pumpRouter(tester, initial: const AuthState.guest());

    expect(find.byKey(const Key('nav_profile')), findsNothing);
    await tester.tap(find.byKey(const Key('nav_civil_protection')));
    await tester.pumpAndSettle();
    expect(router().state.uri.path, '/civil-protection');
    expect(find.byKey(const Key('cp_guest_intro')), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byKey(const Key('cp_sign_in_button')),
      200,
      scrollable: find.descendant(
        of: find.byKey(const Key('cp_guest_intro')),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.tap(find.byKey(const Key('cp_sign_in_button')));
    await tester.pumpAndSettle();
    expect(router().state.uri.path, '/login');

    await emitAuth(tester, const AuthState.authenticated(user));
    expect(router().state.uri.path, '/civil-protection');
  });

  testWidgets('FAB\'lı sekmeler gezildikten sonra tam ekran sayfa açılırken '
      'hero çakışması olmaz', (tester) async {
    await pumpRouter(tester, initial: const AuthState.authenticated(user));

    await tester.tap(find.byKey(const Key('nav_route_planner')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('nav_civil_protection')));
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    await tester.tap(find.byKey(const Key('cp_new_report_fab')));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(router().state.uri.path, '/civil-protection/new');
  });

  testWidgets('misafir yeni bildirime giderse girişe yönlendirilir', (
    tester,
  ) async {
    await pumpRouter(tester, initial: const AuthState.guest());

    router().go('/civil-protection/new?monument=selimiye-camii');
    await tester.pumpAndSettle();

    expect(router().state.uri.path, '/login');
    expect(
      find.text('Bu bölümü kullanmak için giriş yapmanız gerekiyor.'),
      findsOneWidget,
    );
  });

  testWidgets('giriş sonrası hafızadaki derin bağlantıya dönülür', (
    tester,
  ) async {
    await pumpRouter(tester, initial: const AuthState.guest());

    router().go('/monument/42/memory-corner/new');
    await tester.pumpAndSettle();
    expect(router().state.uri.path, '/login');

    await emitAuth(tester, const AuthState.authenticated(user));

    expect(router().state.uri.path, '/monument/42/memory-corner/new');
    expect(find.text('Anı paylaş'), findsWidgets);
  });

  testWidgets('külliye detayı ve tüm yapıları misafire açıktır', (
    tester,
  ) async {
    await pumpRouter(tester, initial: const AuthState.guest());

    router().go('/complex/suleymaniye-kulliyesi');
    await tester.pumpAndSettle();
    expect(router().state.uri.path, '/complex/suleymaniye-kulliyesi');
    expect(find.byType(ComplexDetailPage), findsOneWidget);
    expect(find.byKey(const Key('complex_detail_not_found')), findsOneWidget);

    router().go('/complex/suleymaniye-kulliyesi/monuments');
    await tester.pumpAndSettle();
    expect(find.byType(ComplexMembersPage), findsOneWidget);
    expect(
      find.byKey(const Key('complex_member_suleymaniye-camii')),
      findsOneWidget,
    );
  });

  testWidgets('misafir bir eserin tüm anılarını giriş yapmadan okur', (
    tester,
  ) async {
    await pumpRouter(tester, initial: const AuthState.guest());

    router().go('/monument/selimiye-camii/memory-corner');
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    expect(router().state.uri.path, '/monument/selimiye-camii/memory-corner');
    expect(find.text('Anı Köşesi'), findsOneWidget);
    expect(
      find.byKey(const Key('memory_card_mem_seed_selimiye_1')),
      findsOneWidget,
    );
  });

  testWidgets('citizen profilden Dışa aktarımlarım\'a gider; oturum '
      'kapanınca liste misafir görünümüne geçer', (tester) async {
    await pumpRouter(tester, initial: const AuthState.authenticated(user));
    await openProfileFromAccountMenu(tester);

    await tester.tap(find.byKey(const Key('profile_exports_tile')));
    await tester.pumpAndSettle();
    expect(router().state.uri.path, '/exports');
    expect(find.byKey(const Key('route_exports_empty')), findsOneWidget);

    await emitAuth(tester, const AuthState.guest());
    expect(router().state.uri.path, '/exports');
  });

  testWidgets('misafir Dışa aktarımlarım\'ı Rotalarım\'dan açar', (
    tester,
  ) async {
    await pumpRouter(tester, initial: const AuthState.guest());

    router().go('/route-planner');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('route_exports_shortcut')));
    await tester.pumpAndSettle();
    expect(router().state.uri.path, '/exports');
  });

  testWidgets('citizen profilini görür ve ayarlara gider', (tester) async {
    await pumpRouter(tester, initial: const AuthState.authenticated(user));

    await openProfileFromAccountMenu(tester);
    expect(router().state.uri.path, '/profile');
    expect(find.text('Ayşe Yılmaz'), findsWidgets);
    // Tam ekran açılır; alt gezinme çubuğu görünmez, geri ile dönülür.
    expect(find.byType(NavigationBar), findsNothing);
    expect(find.byType(BackButton), findsOneWidget);

    await tester.tap(find.byKey(const Key('profile_settings_tile')));
    await tester.pumpAndSettle();
    expect(router().state.uri.path, '/settings');
  });

  testWidgets('citizen profilde anılarını görür; Anılarım ve Anı Köşesi '
      'açılır', (tester) async {
    await pumpRouter(tester, initial: const AuthState.authenticated(user));
    await openProfileFromAccountMenu(tester);

    final viewAll = find.byKey(const Key('my_memories_view_all'));
    await tester.scrollUntilVisible(viewAll, 200);
    await tester.pumpAndSettle();
    expect(find.text('Benim anım 1'), findsOneWidget);
    expect(find.text('Tüm anılarım (2)'), findsOneWidget);

    await tester.tap(viewAll);
    await tester.pumpAndSettle();
    expect(router().state.uri.path, '/profile/memories');
    expect(find.text('2 anı'), findsOneWidget);

    await tester.tap(find.byKey(const Key('my_memory_open_mem_own_000')));
    await tester.pumpAndSettle();
    expect(router().state.uri.path, '/monument/selimiye-camii/memory-corner');
  });

  testWidgets('oturum kapanınca korumalı rotadan çıkarılır', (tester) async {
    await pumpRouter(tester, initial: const AuthState.authenticated(user));
    router().go('/profile');
    await tester.pumpAndSettle();
    expect(router().state.uri.path, '/profile');

    await emitAuth(tester, const AuthState.guest(sessionExpired: true));

    expect(router().state.uri.path, '/login');
  });

  testWidgets('tanımsız adres "sayfa bulunamadı" gösterir', (tester) async {
    await pumpRouter(tester, initial: const AuthState.guest());

    router().go('/olmayan/sayfa');
    await tester.pumpAndSettle();

    expect(find.text('Sayfa bulunamadı'), findsWidgets);
    await tester.tap(find.text('Ana sayfaya dön'));
    await tester.pumpAndSettle();
    expect(router().state.uri.path, '/');
  });

  testWidgets('tablet genişliğinde NavigationRail kullanılır', (tester) async {
    await pumpRouter(
      tester,
      initial: const AuthState.guest(),
      size: const Size(900, 700),
    );

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('haritadaki hesap menüsü misafire giriş ve ayarlar sunar', (
    tester,
  ) async {
    await pumpRouter(tester, initial: const AuthState.guest());

    expect(find.bySemanticsLabel('Hesap menüsü, misafir'), findsOneWidget);
    await tester.tap(find.byKey(const Key('map_account_button')));
    await tester.pumpAndSettle();
    expect(find.text('Misafir'), findsOneWidget);
    expect(find.byKey(const Key('account_menu_profile')), findsNothing);

    await tester.tap(find.byKey(const Key('account_menu_settings')));
    await tester.pumpAndSettle();
    expect(router().state.uri.path, '/settings');
    expect(find.text('Ayarlar'), findsWidgets);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('map_account_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('account_menu_sign_in')));
    await tester.pumpAndSettle();
    expect(router().state.uri.path, '/login');
  });

  testWidgets('haritadaki Erişilebilirlik butonu paneli açar', (tester) async {
    await pumpRouter(tester, initial: const AuthState.guest());

    expect(find.byTooltip('Erişilebilirlik'), findsOneWidget);
    await tester.tap(find.byKey(const Key('map_accessibility_button')));
    await tester.pumpAndSettle();
    expect(router().state.uri.path, '/accessibility');
    expect(find.byKey(const Key('a11y_tile_contrast')), findsOneWidget);
  });

  testWidgets('Ayarlar\'da gizlenen Erişilebilirlik butonu haritada '
      'görünmez; hesap menüsünde de yoktur', (tester) async {
    await pumpRouter(
      tester,
      initial: const AuthState.guest(),
      settings: AppSettings.defaults.copyWith(showAccessibilityButton: false),
    );

    expect(find.byKey(const Key('map_accessibility_button')), findsNothing);
    await tester.tap(find.byKey(const Key('map_account_button')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('account_menu_settings')), findsOneWidget);
    expect(find.text('Erişilebilirlik'), findsNothing);
  });

  testWidgets('haritadaki Kaydedilenler butonu listeyi açar; geri haritaya '
      'döner', (tester) async {
    await pumpRouter(tester, initial: const AuthState.guest());

    expect(
      find.bySemanticsLabel('Kaydedilenler, kayıtlı eser yok'),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const Key('map_saved_button')));
    await tester.pumpAndSettle();
    expect(router().state.uri.path, '/saved');
    expect(find.byKey(const Key('saved_monuments_empty')), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(router().state.uri.path, '/');
  });

  testWidgets('arama çubuğu /search rotasını tam ekran açar; geri haritaya '
      'döner', (tester) async {
    await pumpRouter(tester, initial: const AuthState.guest());

    await tester.tap(find.byKey(const Key('map_search_bar')));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
    expect(router().state.uri.path, '/search');
    expect(find.text('20 sonuç'), findsOneWidget);
    // Alt gezinme çubuğunun üstünde açılır.
    expect(find.byType(NavigationBar), findsNothing);

    await tester.tap(find.byType(BackButton));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
    expect(router().state.uri.path, '/');
  });

  testWidgets('citizen hesap menüsünden profile geçer', (tester) async {
    await pumpRouter(tester, initial: const AuthState.authenticated(user));

    expect(find.text('AY'), findsOneWidget);
    expect(find.bySemanticsLabel('Hesap menüsü, Ayşe Yılmaz'), findsOneWidget);
    await tester.tap(find.byKey(const Key('map_account_button')));
    await tester.pumpAndSettle();
    expect(find.text('ayse@example.org'), findsOneWidget);

    await tester.tap(find.byKey(const Key('account_menu_profile')));
    await tester.pumpAndSettle();
    expect(router().state.uri.path, '/profile');
  });

  testWidgets('Rotalar sekmesi misafire rota listesini gösterir', (
    tester,
  ) async {
    await pumpRouter(tester, initial: const AuthState.guest());

    await tester.tap(find.byKey(const Key('nav_route_planner')));
    await tester.pumpAndSettle();

    expect(router().state.uri.path, '/route-planner');
    expect(find.text('Rotalarım'), findsOneWidget);
    expect(find.byKey(const Key('route_list_empty')), findsOneWidget);
    expect(find.byKey(const Key('route_new_button')), findsOneWidget);
  });

  testWidgets('Rehber sekmesi yanıtlar; eylem eser detayını açar, geri '
      'sohbete döner', (tester) async {
    await pumpRouter(tester, initial: const AuthState.guest());

    await tester.tap(find.byKey(const Key('nav_ai_assistant')));
    await tester.pumpAndSettle();
    expect(router().state.uri.path, '/ai-assistant');
    expect(find.byKey(const Key('guide_welcome')), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('guide_input')),
      "Süleymaniye Camii'ni kim yaptırdı?",
    );
    await tester.testTextInput.receiveAction(TextInputAction.send);
    await tester.pumpAndSettle();
    expect(find.textContaining('Kanuni Sultan Süleyman'), findsOneWidget);

    await tester.tap(find.text('Süleymaniye Camii sayfasını aç'));
    await tester.pumpAndSettle();
    expect(router().state.uri.path, '/monument/suleymaniye-camii');

    router().pop();
    await tester.pumpAndSettle();
    expect(router().state.uri.path, '/ai-assistant');
    // Sohbet korunur.
    expect(find.textContaining('Kanuni Sultan Süleyman'), findsOneWidget);
  });

  testWidgets('Rehberin bölüm eylemleri izinli rotaları açar', (tester) async {
    await pumpRouter(tester, initial: const AuthState.guest());
    await tester.tap(find.byKey(const Key('nav_ai_assistant')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('guide_input')),
      'Koyu tema var mı?',
    );
    await tester.pump();
    await tester.tap(find.byKey(const Key('guide_send')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ayarları aç'));
    await tester.pumpAndSettle();
    expect(router().state.uri.path, '/settings');

    router().pop();
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('guide_input')),
      'Hasar nasıl bildiririm?',
    );
    await tester.pump();
    await tester.tap(find.byKey(const Key('guide_send')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sivil Koruma').last);
    await tester.pumpAndSettle();
    expect(router().state.uri.path, '/civil-protection');
  });

  group('ilk açılış tanıtımı', () {
    Future<void> skipToAccountStep(WidgetTester tester) async {
      await tester.tap(find.byKey(const Key('onboarding_skip_button')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('onboarding_step_account')), findsOneWidget);
    }

    testWidgets('açılıştan sonra tanıtım gösterilir; misafir haritaya geçer', (
      tester,
    ) async {
      await pumpRouter(
        tester,
        initial: const AuthState.unknown(),
        onboardingCompleted: false,
      );
      expect(find.byType(SplashView), findsOneWidget);

      await emitAuth(tester, const AuthState.guest());
      expect(router().state.uri.path, '/onboarding');
      expect(find.byKey(const Key('onboarding_step_welcome')), findsOneWidget);
      // Tanıtım tamamlanmadan diğer rotalara geçilemez.
      router().go('/route-planner');
      await tester.pumpAndSettle();
      expect(
        router().state.uri.toString(),
        '/onboarding?from=%2Froute-planner',
      );

      await skipToAccountStep(tester);
      await tester.tap(find.byKey(const Key('onboarding_guest_button')));
      await tester.pumpAndSettle();

      // İlk istenen hedefe dönülür ve tanıtım bir daha gösterilmez.
      expect(router().state.uri.path, '/route-planner');
      expect(onboarding.isCompleted, isTrue);
      router().go('/');
      await tester.pumpAndSettle();
      expect(router().state.uri.path, '/');
    });

    testWidgets('tanıtım sırasında Erişilebilirlik açılır; geri tanıtıma '
        'döner', (tester) async {
      await pumpRouter(
        tester,
        initial: const AuthState.guest(),
        onboardingCompleted: false,
      );
      for (var i = 0; i < 2; i++) {
        await tester.tap(find.byKey(const Key('onboarding_next_button')));
        await tester.pumpAndSettle();
      }
      await tester.tap(
        find.byKey(const Key('onboarding_open_accessibility_button')),
      );
      await tester.pumpAndSettle();
      expect(router().state.uri.path, '/accessibility');
      expect(find.byKey(const Key('a11y_tile_readAloud')), findsOneWidget);

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(router().state.uri.path, '/onboarding');
      expect(
        find.byKey(const Key('onboarding_step_accessibility')),
        findsOneWidget,
      );
    });

    testWidgets('"Giriş yap" tanıtımı tamamlayıp giriş ekranını açar', (
      tester,
    ) async {
      await pumpRouter(
        tester,
        initial: const AuthState.guest(),
        onboardingCompleted: false,
      );
      await skipToAccountStep(tester);

      await tester.tap(find.byKey(const Key('onboarding_sign_in_button')));
      await tester.pumpAndSettle();

      expect(router().state.uri.toString(), '/login');
      expect(onboarding.isCompleted, isTrue);
    });

    testWidgets('ayarlardan yeniden açılan tanıtım bitince ayarlara döner', (
      tester,
    ) async {
      await pumpRouter(tester, initial: const AuthState.authenticated(user));
      unawaited(router().push('/settings'));
      await tester.pumpAndSettle();
      final replay = find.byKey(const Key('settings_replay_onboarding_tile'));
      await tester.scrollUntilVisible(replay, 300);
      await tester.ensureVisible(replay);
      await tester.pumpAndSettle();
      await tester.tap(replay);
      await tester.pumpAndSettle();
      expect(router().state.uri.path, '/onboarding');

      await skipToAccountStep(tester);
      expect(find.text('Hoş geldiniz, Ayşe Yılmaz'), findsOneWidget);
      expect(find.byKey(const Key('onboarding_sign_in_button')), findsNothing);
      await tester.tap(find.byKey(const Key('onboarding_continue_button')));
      await tester.pumpAndSettle();

      expect(router().state.uri.path, '/settings');
    });
  });
}
