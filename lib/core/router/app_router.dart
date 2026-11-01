import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/a11y/haptic_feedback_service.dart';
import 'package:vakif_atlas/core/config/app_config.dart';
import 'package:vakif_atlas/core/config/app_environment.dart';
import 'package:vakif_atlas/core/di/injection.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/router/auth_routes.dart';
import 'package:vakif_atlas/core/router/guards/auth_guard.dart';
import 'package:vakif_atlas/core/router/guards/launch_guard.dart';
import 'package:vakif_atlas/core/router/router_extra_codec.dart';
import 'package:vakif_atlas/core/router/router_refresh_stream.dart';
import 'package:vakif_atlas/core/router/routes.dart';
import 'package:vakif_atlas/core/router/transitions/app_transition_pages.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/accessibility/presentation/pages/accessibility_page.dart';
import 'package:vakif_atlas/features/ai_assistant/domain/entities/guide_message.dart';
import 'package:vakif_atlas/features/ai_assistant/presentation/bloc/digital_guide_bloc.dart';
import 'package:vakif_atlas/features/ai_assistant/presentation/cubit/guide_voice_cubit.dart';
import 'package:vakif_atlas/features/ai_assistant/presentation/pages/digital_guide_page.dart';
import 'package:vakif_atlas/features/auth/domain/entities/legal_document.dart';
import 'package:vakif_atlas/features/auth/domain/entities/user_entity.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_detail.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';
import 'package:vakif_atlas/features/catalog/presentation/bloc/monument_search_bloc.dart';
import 'package:vakif_atlas/features/civil_protection/presentation/bloc/damage_report_wizard_bloc.dart';
import 'package:vakif_atlas/features/civil_protection/presentation/cubit/damage_report_detail_cubit.dart';
import 'package:vakif_atlas/features/civil_protection/presentation/cubit/damage_report_list_cubit.dart';
import 'package:vakif_atlas/features/civil_protection/presentation/pages/civil_protection_page.dart';
import 'package:vakif_atlas/features/civil_protection/presentation/pages/damage_report_detail_page.dart';
import 'package:vakif_atlas/features/civil_protection/presentation/pages/damage_report_wizard_page.dart';
import 'package:vakif_atlas/features/feedback/presentation/cubit/feedback_form_cubit.dart';
import 'package:vakif_atlas/features/feedback/presentation/pages/feedback_page.dart';
import 'package:vakif_atlas/features/gamification/presentation/cubit/gamification_cubit.dart';
import 'package:vakif_atlas/features/gamification/presentation/pages/achievements_page.dart';
import 'package:vakif_atlas/features/gamification/presentation/widgets/gamification_profile_section.dart';
import 'package:vakif_atlas/features/map_discovery/presentation/bloc/map_discovery_bloc.dart';
import 'package:vakif_atlas/features/map_discovery/presentation/cubit/monument_tiles_cubit.dart';
import 'package:vakif_atlas/features/map_discovery/presentation/cubit/user_location_cubit.dart';
import 'package:vakif_atlas/features/map_discovery/presentation/pages/map_discovery_page.dart';
import 'package:vakif_atlas/features/map_discovery/presentation/pages/monument_search_page.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/bloc/memory_composer_bloc.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/bloc/memory_list_bloc.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/cubit/my_memories_cubit.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/memory_presentation.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/pages/memory_composer_page.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/pages/memory_corner_page.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/pages/my_memories_page.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/widgets/monument_memories_section.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/widgets/my_memories_section.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/cubit/complex_detail_cubit.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/cubit/complex_members_cubit.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/cubit/monument_detail_cubit.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/pages/complex_detail_page.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/pages/complex_members_page.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/pages/monument_detail_page.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/widgets/monument_route_button.dart';
import 'package:vakif_atlas/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:vakif_atlas/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:vakif_atlas/features/profile/presentation/pages/profile_page.dart';
import 'package:vakif_atlas/features/profile/presentation/widgets/account_menu_sheet.dart';
import 'package:vakif_atlas/features/route_export/presentation/cubit/route_export_cubit.dart';
import 'package:vakif_atlas/features/route_export/presentation/widgets/route_export_button.dart';
import 'package:vakif_atlas/features/route_export/presentation/cubit/route_exports_cubit.dart';
import 'package:vakif_atlas/features/route_export/presentation/pages/route_exports_page.dart';
import 'package:vakif_atlas/features/route_export/presentation/widgets/route_exports_shortcut.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/route_plan.dart';
import 'package:vakif_atlas/features/route_planner/presentation/bloc/route_builder_bloc.dart';
import 'package:vakif_atlas/features/route_planner/presentation/cubit/route_detail_cubit.dart';
import 'package:vakif_atlas/features/route_planner/presentation/cubit/route_list_cubit.dart';
import 'package:vakif_atlas/features/route_planner/presentation/pages/route_builder_page.dart';
import 'package:vakif_atlas/features/route_planner/presentation/pages/route_detail_page.dart';
import 'package:vakif_atlas/features/route_planner/presentation/pages/route_list_page.dart';
import 'package:vakif_atlas/features/saved_monuments/presentation/cubit/saved_monuments_cubit.dart';
import 'package:vakif_atlas/features/saved_monuments/presentation/cubit/saved_monuments_list_cubit.dart';
import 'package:vakif_atlas/features/saved_monuments/presentation/pages/saved_monuments_page.dart';
import 'package:vakif_atlas/features/saved_monuments/presentation/widgets/saved_monument_feedback.dart';
import 'package:vakif_atlas/features/saved_monuments/presentation/widgets/saved_monuments_map_button.dart';
import 'package:vakif_atlas/features/settings/presentation/cubit/app_settings_cubit.dart';
import 'package:vakif_atlas/features/settings/presentation/cubit/device_permissions_cubit.dart';
import 'package:vakif_atlas/features/settings/presentation/cubit/location_permission_cubit.dart';
import 'package:vakif_atlas/features/settings/presentation/pages/settings_page.dart';
import 'package:vakif_atlas/shared/widgets/molecules/account_avatar.dart';
import 'package:vakif_atlas/shared/widgets/molecules/monument_save_button.dart';
import 'package:vakif_atlas/shared/widgets/templates/adaptive_app_scaffold.dart';
import 'package:vakif_atlas/shared/widgets/templates/not_found_page.dart';
import 'package:vakif_atlas/shared/widgets/templates/splash_view.dart';

/// Uygulamanın bildirimsel yönlendiricisi (TRD §5).
///
/// Oturum veya tanıtım durumu her değiştiğinde [LaunchGuard] yeniden
/// değerlendirilir.
/// Ana sekmeler (`Harita`, `Rotalar`, `Rehber`, `Sivil Koruma`) kendi
/// gezinme geçmişlerini korur; detay ekranları ve profil tam ekran olarak
/// üstte açılır.
@lazySingleton
class AppRouter {
  AppRouter(
    this._authBloc,
    this._onboarding,
    this._config,
    this._haptics,
    this._announcer,
    @Named(RouteBuilderBloc.draftInstance) this._routeDraft,
    this._saved,
    this._gamification,
    this._packageInfo,
  ) {
    _sessionGuard = _authBloc.stream.listen(_onAuthChanged);
  }

  final AuthBloc _authBloc;
  final OnboardingCubit _onboarding;
  final AppConfig _config;
  final HapticFeedbackService _haptics;
  final A11yAnnouncer _announcer;

  /// Uygulama genelindeki yeni rota taslağı (eser detayı + oluşturucu).
  final RouteBuilderBloc _routeDraft;

  /// Uygulama genelinde kaydedilen eserler (harita, önizleme, detay, liste).
  final SavedMonumentsCubit _saved;

  /// Uygulama genelinde seviye ve rozetler (profil, rozetler, kutlama).
  final GamificationCubit _gamification;

  /// Ayarlar → Hakkında'daki sürüm.
  final PackageInfo _packageInfo;

  String get _appVersion => _packageInfo.buildNumber.isEmpty
      ? _packageInfo.version
      : '${_packageInfo.version} (${_packageInfo.buildNumber})';

  final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey(
    debugLabel: 'root',
  );

  /// Uygulama kabuğundaki (Navigator'ın üstü) diyaloglar için.
  GlobalKey<NavigatorState> get navigatorKey => _rootNavigatorKey;

  late final StreamSubscription<AuthState> _sessionGuard;

  late final RouterRefreshStream _refresh = RouterRefreshStream([
    _authBloc.stream,
    _onboarding.stream,
  ]);

  late final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.mapDiscovery,
    debugLogDiagnostics: _config.environment == AppEnvironment.dev,
    refreshListenable: _refresh,
    extraCodec: const RouterExtraCodec(),
    redirect: (context, state) => LaunchGuard.redirect(
      auth: _authBloc.state,
      onboardingCompleted: _onboarding.isCompleted,
      location: state.uri,
    ),
    errorPageBuilder: (context, state) => fadePage(
      context,
      state,
      NotFoundPage(onGoHome: () => context.go(AppRoutes.mapDiscovery)),
    ),
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: AppRouteNames.splash,
        pageBuilder: (context, state) =>
            fadePage(context, state, const SplashView()),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: AppRouteNames.onboarding,
        pageBuilder: (context, state) {
          final target =
              AuthGuard.safeTarget(
                state.uri.queryParameters[AppRoutes.fromParameter],
              ) ??
              AppRoutes.mapDiscovery;
          return fadePage(
            context,
            state,
            MultiBlocProvider(
              providers: [
                BlocProvider<LocationPermissionCubit>(
                  create: (_) => getIt<LocationPermissionCubit>(),
                ),
                BlocProvider<DevicePermissionsCubit>(
                  create: (_) => getIt<DevicePermissionsCubit>(),
                ),
              ],
              child: BlocSelector<AuthBloc, AuthState, String?>(
                bloc: _authBloc,
                selector: (auth) => switch (auth) {
                  AuthAuthenticated(:final user) => user.displayName,
                  AuthUnknown() || AuthGuest() => null,
                },
                builder: (context, displayName) => OnboardingPage(
                  signedInDisplayName: displayName,
                  onOpenPrivacyNotice: () => context.push(
                    AppRoutes.legalDocumentPath(
                      LegalDocumentType.privacyNotice.slug,
                    ),
                  ),
                  onOpenAccessibility: () =>
                      context.push(AppRoutes.accessibility),
                  onFinished: (exit) =>
                      _finishOnboarding(context, exit, target),
                ),
              ),
            ),
          );
        },
      ),
      ...authRoutes(),
      // Alt gezinme çubuğunun üstünde tam ekran; sonuç `pop` ile haritaya
      // döner.
      GoRoute(
        path: AppRoutes.monumentSearch,
        name: AppRouteNames.monumentSearch,
        pageBuilder: (context, state) => fadePage(
          context,
          state,
          BlocProvider<MonumentSearchBloc>(
            create: (_) => getIt<MonumentSearchBloc>(),
            child: MonumentSearchPage(
              initialQuery: state.extra is MonumentSearchQuery
                  ? state.extra! as MonumentSearchQuery
                  : MonumentSearchQuery.empty,
            ),
          ),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => _MainShell(
          shell: shell,
          onTabSelected: () => unawaited(_haptics.selection()),
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.mapDiscovery,
                name: AppRouteNames.mapDiscovery,
                // Sorgu parametresi değişse de sayfa (ve BLoC) korunur;
                // yalnızca odaklanılacak eser güncellenir.
                pageBuilder: (context, state) => fadePage(
                  context,
                  state,
                  MultiBlocProvider(
                    providers: [
                      BlocProvider<MapDiscoveryBloc>(
                        create: (_) => getIt<MapDiscoveryBloc>(),
                      ),
                      BlocProvider<UserLocationCubit>(
                        create: (_) => getIt<UserLocationCubit>(),
                      ),
                      BlocProvider<MonumentTilesCubit>(
                        create: (_) => getIt<MonumentTilesCubit>(),
                      ),
                    ],
                    child: MapDiscoveryPage(
                      focusMonumentId: state
                          .uri
                          .queryParameters[AppRoutes.monumentParameter],
                      searchResult: state.extra is MonumentSearchResult
                          ? state.extra! as MonumentSearchResult
                          : null,
                      accountButton: const _AccountButton(),
                      // Ayarlar'dan gizlenebilir (her seferinde görmek
                      // istemeyen kullanıcı için).
                      onOpenAccessibility:
                          context.select(
                            (AppSettingsCubit cubit) =>
                                cubit.state.settings.showAccessibilityButton,
                          )
                          ? () => context.push(AppRoutes.accessibility)
                          : null,
                      savedButton:
                          BlocSelector<
                            SavedMonumentsCubit,
                            SavedMonumentsState,
                            int
                          >(
                            bloc: _saved,
                            selector: (saved) => saved.count,
                            builder: (context, count) =>
                                SavedMonumentsMapButton(
                                  count: count,
                                  onPressed: () =>
                                      context.push(AppRoutes.savedMonuments),
                                ),
                          ),
                      previewActionBuilder: (context, monument) =>
                          _saveButton(monument.id, monument.name),
                      onOpenSearch: (initial) =>
                          context.push<MonumentSearchResult>(
                            AppRoutes.monumentSearch,
                            extra: initial,
                          ),
                      onOpenMonument: (id) =>
                          context.push(AppRoutes.monumentDetailPath(id)),
                      onOpenComplex: (id) =>
                          context.push(AppRoutes.complexDetailPath(id)),
                    ),
                  ),
                ),
                routes: [
                  GoRoute(
                    path: 'monument/:id',
                    name: AppRouteNames.monumentDetail,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return slidePage(
                        context,
                        state,
                        BlocProvider<MonumentDetailCubit>(
                          create: (_) => getIt<MonumentDetailCubit>(),
                          child:
                              BlocSelector<
                                RouteBuilderBloc,
                                RouteBuilderState,
                                (bool, int)
                              >(
                                bloc: _routeDraft,
                                selector: (draft) =>
                                    (draft.contains(id), draft.stops.length),
                                builder: (context, draft) => MonumentDetailPage(
                                  monumentId: id,
                                  // Külliye kaydı ayrı görünümde açılır; eser
                                  // sayfası yığında kalmaz.
                                  onOpenComplex: (complexId) =>
                                      context.pushReplacement(
                                        AppRoutes.complexDetailPath(complexId),
                                      ),
                                  onOpenMonument: (memberId) => context.push(
                                    AppRoutes.monumentDetailPath(memberId),
                                  ),
                                  onShowOnMap: () => context.go(
                                    AppRoutes.mapDiscoveryWithMonument(id),
                                  ),
                                  onBackToMap: () =>
                                      context.go(AppRoutes.mapDiscovery),
                                  routeMembership: MonumentRouteMembership(
                                    isInRoute: draft.$1,
                                    stopCount: draft.$2,
                                    maxStops: RoutePlanRules.maxStops,
                                    onToggle: () => _routeDraft.add(
                                      RouteBuilderEvent.monumentToggled(id),
                                    ),
                                    onOpenRoute: () =>
                                        context.push(AppRoutes.routeBuilder),
                                  ),
                                  memoriesBuilder: _memoriesSection,
                                  saveButtonBuilder: (context, monument) =>
                                      _saveButton(monument.id, monument.name),
                                  onReportDamage: () => context.push(
                                    AppRoutes.damageReportNewPath(
                                      monumentId: id,
                                    ),
                                  ),
                                ),
                              ),
                        ),
                      );
                    },
                    routes: _memoryCornerRoutes(),
                  ),
                  ..._complexRoutes(),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.routePlanner,
                name: AppRouteNames.routePlanner,
                pageBuilder: (context, state) => fadePage(
                  context,
                  state,
                  BlocProvider<RouteListCubit>(
                    create: (_) => getIt<RouteListCubit>(),
                    child:
                        BlocSelector<RouteBuilderBloc, RouteBuilderState, int>(
                          bloc: _routeDraft,
                          selector: (draft) => draft.stops.length,
                          builder: (context, draftStopCount) => RouteListPage(
                            draftStopCount: draftStopCount,
                            actions: [
                              RouteExportsShortcut(
                                onPressed: () =>
                                    context.push(AppRoutes.routeExports),
                              ),
                              const _AppBarAccountButton(),
                            ],
                            onOpenDraft: () =>
                                context.push(AppRoutes.routeBuilder),
                            onOpenRoute: (id) =>
                                context.push(AppRoutes.routeDetailPath(id)),
                          ),
                        ),
                  ),
                ),
                routes: _routePlannerRoutes(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.aiAssistant,
                name: AppRouteNames.aiAssistant,
                // Sohbet sekme boyunca korunur (sekme sayfası yeniden
                // kurulmaz).
                pageBuilder: (context, state) => fadePage(
                  context,
                  state,
                  MultiBlocProvider(
                    providers: [
                      BlocProvider<DigitalGuideBloc>(
                        create: (_) => getIt<DigitalGuideBloc>(),
                      ),
                      BlocProvider<GuideVoiceCubit>(
                        create: (_) => getIt<GuideVoiceCubit>(),
                      ),
                    ],
                    child: DigitalGuidePage(
                      actions: const [_AppBarAccountButton()],
                      onAction: (action) => _openGuideAction(context, action),
                    ),
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.civilProtection,
                name: AppRouteNames.civilProtection,
                pageBuilder: (context, state) => fadePage(
                  context,
                  state,
                  BlocProvider<DamageReportListCubit>(
                    create: (_) => getIt<DamageReportListCubit>(),
                    child: BlocSelector<AuthBloc, AuthState, String?>(
                      bloc: _authBloc,
                      selector: _ownerId,
                      builder: (context, viewerId) => CivilProtectionPage(
                        viewerId: viewerId,
                        actions: const [_AppBarAccountButton()],
                        onSignIn: () => context.push(
                          AuthGuard.withFrom(
                            AppRoutes.login,
                            AppRoutes.civilProtection,
                          ),
                        ),
                        onCreateReport: () =>
                            context.push(AppRoutes.damageReportNewPath()),
                        onOpenReport: (id) =>
                            context.push(AppRoutes.damageReportPath(id)),
                      ),
                    ),
                  ),
                ),
                routes: _civilProtectionRoutes(),
              ),
            ],
          ),
        ],
      ),
      // Profil alt gezinme sekmesi değildir; hesap menüsünden tam ekran açılır.
      GoRoute(
        path: AppRoutes.profile,
        name: AppRouteNames.profile,
        pageBuilder: (context, state) => slidePage(
          context,
          state,
          ProfilePage(
            onOpenSettings: () => context.push(AppRoutes.settings),
            onOpenExports: () => context.push(AppRoutes.routeExports),
            onChangePassword: () => context.push(AppRoutes.changePassword),
            onDeleteAccount: () => context.push(AppRoutes.deleteAccount),
            onLogoutConfirmed: () => _logout(context),
            progressSection: BlocProvider<GamificationCubit>.value(
              value: _gamification,
              child: GamificationProfileSection(
                onOpenAchievements: () => context.push(AppRoutes.achievements),
              ),
            ),
            memoriesSection: BlocProvider<MyMemoriesCubit>(
              create: (_) => getIt<MyMemoriesCubit>(),
              child: MyMemoriesProfileSection(
                onOpenAll: () => context.push(AppRoutes.myMemories),
                onOpenMonumentMemories: (id, name) =>
                    context.push(AppRoutes.memoryCornerPath(id), extra: name),
              ),
            ),
          ),
        ),
        routes: [
          ...accountRoutes(
            rootNavigatorKey: _rootNavigatorKey,
            authBloc: _authBloc,
          ),
          GoRoute(
            path: 'memories',
            name: AppRouteNames.myMemories,
            parentNavigatorKey: _rootNavigatorKey,
            pageBuilder: (context, state) => slidePage(
              context,
              state,
              BlocProvider<MyMemoriesCubit>(
                create: (_) => getIt<MyMemoriesCubit>(),
                child: MyMemoriesPage(
                  onOpenMonumentMemories: (id, name) =>
                      context.push(AppRoutes.memoryCornerPath(id), extra: name),
                  onExplore: () => context.go(AppRoutes.mapDiscovery),
                ),
              ),
            ),
          ),
          GoRoute(
            path: 'achievements',
            name: AppRouteNames.achievements,
            parentNavigatorKey: _rootNavigatorKey,
            pageBuilder: (context, state) => slidePage(
              context,
              state,
              BlocProvider<GamificationCubit>.value(
                value: _gamification,
                child: const AchievementsPage(),
              ),
            ),
          ),
        ],
      ),
      // Giriş gerekmez: misafirin dışa aktarımları kuruluma aittir, girişte
      // hesaba taşınır (ADR 33). Oturum değişince liste yeni sahiple açılır.
      GoRoute(
        path: AppRoutes.routeExports,
        name: AppRouteNames.routeExports,
        pageBuilder: (context, state) => slidePage(
          context,
          state,
          BlocProvider<RouteExportsCubit>(
            create: (_) => getIt<RouteExportsCubit>(),
            child: BlocSelector<AuthBloc, AuthState, String?>(
              bloc: _authBloc,
              selector: _ownerId,
              builder: (context, ownerId) => RouteExportsPage(
                ownerId: ownerId,
                onOpenRoutes: () => context.go(AppRoutes.routePlanner),
              ),
            ),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.savedMonuments,
        name: AppRouteNames.savedMonuments,
        pageBuilder: (context, state) => slidePage(
          context,
          state,
          MultiBlocProvider(
            providers: [
              BlocProvider<SavedMonumentsCubit>.value(value: _saved),
              BlocProvider<SavedMonumentsListCubit>(
                create: (_) => getIt<SavedMonumentsListCubit>(),
              ),
            ],
            child: SavedMonumentsPage(
              onOpenMonument: (id) =>
                  context.push(AppRoutes.monumentDetailPath(id)),
              onShowOnMap: (id) =>
                  context.go(AppRoutes.mapDiscoveryWithMonument(id)),
              onExplore: () => context.go(AppRoutes.mapDiscovery),
            ),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.accessibility,
        name: AppRouteNames.accessibility,
        pageBuilder: (context, state) =>
            slidePage(context, state, const AccessibilityPage()),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: AppRouteNames.settings,
        pageBuilder: (context, state) => slidePage(
          context,
          state,
          MultiBlocProvider(
            providers: [
              BlocProvider<LocationPermissionCubit>(
                create: (_) => getIt<LocationPermissionCubit>(),
              ),
              BlocProvider<DevicePermissionsCubit>(
                create: (_) => getIt<DevicePermissionsCubit>(),
              ),
            ],
            child: SettingsPage(
              onReplayOnboarding: () => context.push(AppRoutes.onboarding),
              onOpenAccessibility: () => context.push(AppRoutes.accessibility),
              onOpenPrivacyNotice: () => context.push(
                AppRoutes.legalDocumentPath(
                  LegalDocumentType.privacyNotice.slug,
                ),
              ),
              onOpenTermsOfUse: () => context.push(
                AppRoutes.legalDocumentPath(LegalDocumentType.termsOfUse.slug),
              ),
              onOpenFeedback: () => context.push(AppRoutes.feedback),
              appVersion: _appVersion,
            ),
          ),
        ),
        routes: [
          GoRoute(
            path: 'feedback',
            name: AppRouteNames.feedback,
            pageBuilder: (context, state) => slidePage(
              context,
              state,
              BlocProvider<FeedbackFormCubit>(
                create: (_) => getIt<FeedbackFormCubit>(),
                child: FeedbackPage(
                  onSubmitted: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go(AppRoutes.settings);
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  );

  /// Yeni bildirim (eser seçici aramasıyla) ve bildirim ayrıntısı; ikisi de
  /// oturum gerektirir (misafir AuthGuard ile girişe, sonra buraya döner).
  List<RouteBase> _civilProtectionRoutes() => [
    GoRoute(
      path: 'new',
      name: AppRouteNames.damageReportNew,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => slidePage(
        context,
        state,
        MultiBlocProvider(
          providers: [
            BlocProvider<DamageReportWizardBloc>(
              create: (_) => getIt<DamageReportWizardBloc>(),
            ),
            _monumentPickerSearch(),
          ],
          child: DamageReportWizardPage(
            initialMonumentId:
                state.uri.queryParameters[AppRoutes.monumentParameter],
            onClose: () => _leaveOr(context, AppRoutes.civilProtection),
            // Gönderilen bildirimin ayrıntısı formun yerine açılır.
            onSubmitted: (report) =>
                context.pushReplacement(AppRoutes.damageReportPath(report.id)),
          ),
        ),
      ),
    ),
    GoRoute(
      path: 'reports/:reportId',
      name: AppRouteNames.damageReportDetail,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => slidePage(
        context,
        state,
        BlocProvider<DamageReportDetailCubit>(
          create: (_) => getIt<DamageReportDetailCubit>(),
          child: DamageReportDetailPage(
            reportId: state.pathParameters['reportId']!,
            onBackToList: () => context.go(AppRoutes.civilProtection),
          ),
        ),
      ),
    ),
  ];

  /// Dijital Rehber eylemleri yalnızca bu izinli rotalara çevrilir; sunucu
  /// yanıtından serbest adres açılmaz. Detaylar rehberin üstünde açılır
  /// (geri → sohbet), sekmeler `go` ile değişir.
  void _openGuideAction(BuildContext context, GuideAction action) {
    unawaited(_haptics.selection());
    switch (action) {
      case GuideOpenMonument(:final monument):
        unawaited(context.push(AppRoutes.monumentDetailPath(monument.id)));
      case GuideShowOnMap(:final monument):
        context.go(AppRoutes.mapDiscoveryWithMonument(monument.id));
      case GuideOpenMemories(:final monument):
        unawaited(
          context.push(
            AppRoutes.memoryCornerPath(monument.id),
            extra: monument.name,
          ),
        );
      case GuideReportDamage(:final monument):
        unawaited(
          context.push(AppRoutes.damageReportNewPath(monumentId: monument?.id)),
        );
      case GuideSearchMonuments(:final query):
        unawaited(_openGuideSearch(context, query));
      case GuideOpenSection(:final destination):
        switch (destination) {
          case GuideDestination.map:
            context.go(AppRoutes.mapDiscovery);
          case GuideDestination.routePlanner:
            context.go(AppRoutes.routePlanner);
          case GuideDestination.routeBuilder:
            unawaited(context.push(AppRoutes.routeBuilder));
          case GuideDestination.civilProtection:
            context.go(AppRoutes.civilProtection);
          case GuideDestination.settings:
            unawaited(context.push(AppRoutes.settings));
          case GuideDestination.accessibility:
            unawaited(context.push(AppRoutes.accessibility));
        }
    }
  }

  /// Rehberin önerdiği arama; eser detayı rehberin üstünde açılır, harita
  /// seçimleri harita sekmesine uygulanır.
  Future<void> _openGuideSearch(
    BuildContext context,
    MonumentSearchQuery query,
  ) async {
    final result = await context.push<MonumentSearchResult>(
      AppRoutes.monumentSearch,
      extra: query,
    );
    if (result == null || !context.mounted) {
      return;
    }
    switch (result) {
      case MonumentSearchOpenDetails(:final monumentId):
        unawaited(context.push(AppRoutes.monumentDetailPath(monumentId)));
      case MonumentSearchShowOnMap() ||
          MonumentSearchPlaceChosen() ||
          MonumentSearchAppliedToMap():
        context.go(AppRoutes.mapDiscovery, extra: result);
    }
  }

  /// Gezinme geçmişi yoksa (ör. girişten sonra doğrudan açıldı) [fallback].
  void _leaveOr(BuildContext context, String fallback) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(fallback);
    }
  }

  /// Eser detayındaki Anı Köşesi girişi (sayı + en son anı); zaman
  /// çizelgesi ayrı sayfada açılır.
  /// Eser bağlamlı kaydet butonu (harita önizlemesi + eser detayı).
  Widget _saveButton(String monumentId, String monumentName) =>
      BlocSelector<SavedMonumentsCubit, SavedMonumentsState, bool>(
        bloc: _saved,
        selector: (saved) => saved.contains(monumentId),
        builder: (context, isSaved) => MonumentSaveButton(
          isSaved: isSaved,
          monumentName: monumentName,
          onPressed: () => unawaited(
            toggleSavedMonument(
              context,
              cubit: _saved,
              monumentId: monumentId,
              monumentName: monumentName,
              onOpenSaved: () => context.push(AppRoutes.savedMonuments),
            ),
          ),
        ),
      );

  Widget _memoriesSection(BuildContext context, MonumentDetail monument) {
    final id = monument.id;
    return BlocProvider<MemoryListBloc>(
      create: (_) => getIt<MemoryListBloc>(),
      child: BlocSelector<AuthBloc, AuthState, String?>(
        bloc: _authBloc,
        selector: _ownerId,
        builder: (context, viewerId) => MonumentMemoriesSection(
          monumentId: id,
          viewerId: viewerId,
          onOpen: () => context.push(
            AppRoutes.memoryCornerPath(id),
            extra: monument.name,
          ),
        ),
      ),
    );
  }

  /// Tüm anılar (herkese açık) ve anı paylaşma (oturum gerekir; misafir
  /// AuthGuard ile girişe, girişten sonra paylaşma ekranına yönlenir).
  List<RouteBase> _memoryCornerRoutes() => [
    GoRoute(
      path: 'memory-corner',
      name: AppRouteNames.memoryCorner,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final id = state.pathParameters['id']!;
        final extra = state.extra;
        return slidePage(
          context,
          state,
          BlocProvider<MemoryListBloc>(
            create: (_) => getIt<MemoryListBloc>(),
            child: BlocSelector<AuthBloc, AuthState, String?>(
              bloc: _authBloc,
              selector: _ownerId,
              builder: (context, viewerId) => MemoryCornerPage(
                monumentId: id,
                monumentName: extra is String ? extra : null,
                viewerId: viewerId,
                onShare: () => context.push(AppRoutes.memoryComposerPath(id)),
                onSignIn: (intent) => _signInForMemory(
                  context,
                  intent,
                  monumentId: id,
                  returnPath: AppRoutes.memoryCornerPath(id),
                ),
              ),
            ),
          ),
        );
      },
      routes: [
        GoRoute(
          path: 'new',
          name: AppRouteNames.memoryComposer,
          parentNavigatorKey: _rootNavigatorKey,
          pageBuilder: (context, state) {
            final id = state.pathParameters['id']!;
            return slidePage(
              context,
              state,
              BlocProvider<MemoryComposerBloc>(
                create: (_) => getIt<MemoryComposerBloc>(),
                // Rota korumalıdır; oturum kapanırsa AuthGuard girişe
                // yönlendirir.
                child: BlocSelector<AuthBloc, AuthState, String?>(
                  bloc: _authBloc,
                  selector: (auth) => switch (auth) {
                    AuthAuthenticated(:final user) => user.displayName,
                    AuthUnknown() || AuthGuest() => null,
                  },
                  builder: (context, authorName) => authorName == null
                      ? const SizedBox.shrink()
                      : MemoryComposerPage(
                          monumentId: id,
                          authorName: authorName,
                          onClose: () => _leaveComposer(context, id),
                          onSubmitted: () => _leaveComposer(context, id),
                          // Bildirim eylemi kompozitör kapandıktan sonra çalışır.
                          onOpenMyMemories: () =>
                              unawaited(router.push(AppRoutes.myMemories)),
                        ),
                ),
              ),
            );
          },
        ),
      ],
    ),
  ];

  /// Paylaşmak için giriş → paylaşma ekranına, bildirmek için giriş → aynı
  /// ekrana dönülür.
  void _signInForMemory(
    BuildContext context,
    MemorySignInIntent intent, {
    required String monumentId,
    required String returnPath,
  }) {
    final target = switch (intent) {
      MemorySignInIntent.share => AppRoutes.memoryComposerPath(monumentId),
      MemorySignInIntent.report => returnPath,
    };
    unawaited(
      context.push(
        Uri(
          path: AppRoutes.login,
          queryParameters: {AppRoutes.fromParameter: target},
        ).toString(),
      ),
    );
  }

  /// Külliye detayı ve tüm yapıları (harita dalında, tam ekran). Yuvalar
  /// eser detayındakiyle aynıdır: kaydetme, rota, anı, hasar bildirimi
  /// külliyenin katalog kaydıyla çalışır.
  List<RouteBase> _complexRoutes() => [
    GoRoute(
      path: 'complex/:id',
      name: AppRouteNames.complexDetail,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final id = state.pathParameters['id']!;
        return slidePage(
          context,
          state,
          BlocProvider<ComplexDetailCubit>(
            create: (_) => getIt<ComplexDetailCubit>(),
            child:
                BlocSelector<RouteBuilderBloc, RouteBuilderState, (bool, int)>(
                  bloc: _routeDraft,
                  selector: (draft) => (draft.contains(id), draft.stops.length),
                  builder: (context, draft) => ComplexDetailPage(
                    complexId: id,
                    onOpenMonument: (memberId) =>
                        context.push(AppRoutes.monumentDetailPath(memberId)),
                    onSeeAllMembers: (name) => context.push(
                      AppRoutes.complexMonumentsPath(id),
                      extra: name,
                    ),
                    onShowOnMap: () =>
                        context.go(AppRoutes.mapDiscoveryWithMonument(id)),
                    onBackToMap: () => context.go(AppRoutes.mapDiscovery),
                    routeMembership: MonumentRouteMembership(
                      isInRoute: draft.$1,
                      stopCount: draft.$2,
                      maxStops: RoutePlanRules.maxStops,
                      onToggle: () => _routeDraft.add(
                        RouteBuilderEvent.monumentToggled(id),
                      ),
                      onOpenRoute: () => context.push(AppRoutes.routeBuilder),
                    ),
                    memoriesBuilder: _memoriesSection,
                    saveButtonBuilder: (context, monument) =>
                        _saveButton(monument.id, monument.name),
                    onReportDamage: () => context.push(
                      AppRoutes.damageReportNewPath(monumentId: id),
                    ),
                  ),
                ),
          ),
        );
      },
      routes: [
        GoRoute(
          path: 'monuments',
          name: AppRouteNames.complexMonuments,
          parentNavigatorKey: _rootNavigatorKey,
          pageBuilder: (context, state) {
            final id = state.pathParameters['id']!;
            return slidePage(
              context,
              state,
              BlocProvider<ComplexMembersCubit>(
                create: (_) => getIt<ComplexMembersCubit>(),
                child: ComplexMembersPage(
                  complexId: id,
                  complexName: state.extra is String
                      ? state.extra! as String
                      : null,
                  onOpenMonument: (memberId) =>
                      context.push(AppRoutes.monumentDetailPath(memberId)),
                ),
              ),
            );
          },
        ),
      ],
    ),
  ];

  /// Girişten sonra açılan paylaşma ekranının altında gezinme geçmişi
  /// olmayabilir; o durumda eser detayına dönülür.
  void _leaveComposer(BuildContext context, String monumentId) =>
      _leaveOr(context, AppRoutes.monumentDetailPath(monumentId));

  /// Oluşturucu, detay ve düzenleme tam ekran açılır. `new` sabit yolu
  /// `:routeId`'den önce eşleşir (sunucu kimlikleri `rt_` önekli).
  List<RouteBase> _routePlannerRoutes() => [
    GoRoute(
      path: 'new',
      name: AppRouteNames.routeBuilder,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => slidePage(
        context,
        state,
        MultiBlocProvider(
          providers: [
            BlocProvider<RouteBuilderBloc>.value(value: _routeDraft),
            _monumentPickerSearch(),
          ],
          child: RouteBuilderPage(
            onSaved: (route) => context.go(AppRoutes.routeDetailPath(route.id)),
          ),
        ),
      ),
    ),
    GoRoute(
      path: ':routeId',
      name: AppRouteNames.routeDetail,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final id = state.pathParameters['routeId']!;
        return slidePage(
          context,
          state,
          MultiBlocProvider(
            providers: [
              BlocProvider<RouteDetailCubit>(
                create: (_) => getIt<RouteDetailCubit>(),
              ),
              BlocProvider<RouteExportCubit>(
                create: (_) => getIt<RouteExportCubit>(),
              ),
            ],
            child: BlocSelector<AuthBloc, AuthState, String?>(
              bloc: _authBloc,
              selector: _ownerId,
              builder: (context, ownerId) => RouteDetailPage(
                routeId: id,
                onEdit: () => context.push(AppRoutes.routeEditPath(id)),
                onDeleted: () => context.go(AppRoutes.routePlanner),
                onBackToList: () => context.go(AppRoutes.routePlanner),
                exportActionBuilder: (context, route, {required enabled}) =>
                    RouteExportButton(
                      route: route,
                      enabled: enabled,
                      ownerId: ownerId,
                      onOpenExports: () => context.push(AppRoutes.routeExports),
                      // Girişten sonra bu rotaya dönülür.
                      onSignInToKeepExports: () => context.push(
                        Uri(
                          path: AppRoutes.login,
                          queryParameters: {
                            AppRoutes.fromParameter: AppRoutes.routeDetailPath(
                              id,
                            ),
                          },
                        ).toString(),
                      ),
                    ),
              ),
            ),
          ),
        );
      },
      routes: [
        GoRoute(
          path: 'edit',
          name: AppRouteNames.routeEdit,
          parentNavigatorKey: _rootNavigatorKey,
          pageBuilder: (context, state) => slidePage(
            context,
            state,
            MultiBlocProvider(
              providers: [
                BlocProvider<RouteBuilderBloc>(
                  create: (_) => getIt<RouteBuilderBloc>(),
                ),
                _monumentPickerSearch(),
              ],
              child: RouteBuilderPage(
                editingRouteId: state.pathParameters['routeId'],
                onSaved: (_) => context.pop(),
              ),
            ),
          ),
        ),
      ],
    ),
  ];

  /// Kullanıcıya özel verilerin (dışa aktarımlar) sahibi.
  static String? _ownerId(AuthState auth) => switch (auth) {
    AuthAuthenticated(:final user) => user.id,
    AuthUnknown() || AuthGuest() => null,
  };

  /// Oluşturucunun eser seçicisindeki arama; seçici ilk açıldığında
  /// oluşturulur ve oluşturucu boyunca son arama korunur.
  BlocProvider<MonumentSearchBloc> _monumentPickerSearch() =>
      BlocProvider<MonumentSearchBloc>(
        create: (_) => getIt<MonumentSearchBloc>(),
      );

  /// Tanıtım tamamlanır; misafir/oturum açık devam ilk istenen hedefe
  /// (ayarlardan yeniden açıldıysa önceki ekrana) döner.
  void _finishOnboarding(
    BuildContext context,
    OnboardingExit exit,
    String target,
  ) {
    unawaited(_onboarding.complete());
    switch (exit) {
      case OnboardingExit.signIn:
        context.go(AppRoutes.login);
      case OnboardingExit.createAccount:
        context.go(AppRoutes.register);
      case OnboardingExit.guest || OnboardingExit.continueSignedIn:
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(target);
        }
    }
  }

  void _logout(BuildContext context) {
    final announcement = context.l10n.logoutAnnouncement;
    context.go(AppRoutes.mapDiscovery);
    _authBloc.add(const AuthEvent.logoutRequested());
    unawaited(_announcer.announce(announcement));
  }

  /// GoRouter'ın yenileme yönlendirmesi `push` ile açılmış sayfalarda alttaki
  /// konumu değerlendirir (ör. haritanın üstündeki profil veya bir
  /// sayfanın üstünde açılan giriş). Üstteki gerçek konum burada ayrıca
  /// denetlenir:
  /// - Oturum kapanınca (çıkış / süre dolması) korumalı sayfadan girişe.
  /// - Giriş başarılı olunca (giriş veya giriş/kayıt üstünde açılan e-posta
  ///   doğrulaması) misafire özel ekrandan yığındaki girişin `from` hedefine.
  void _onAuthChanged(AuthState auth) {
    final location = router.state.uri;
    switch (auth) {
      case AuthGuest():
        if (AppRoutes.requiresAuthentication(location.path)) {
          router.go(AuthGuard.withFrom(AppRoutes.login, location.toString()));
        }
      case AuthAuthenticated():
        if (AppRoutes.isGuestOnly(location.path)) {
          router.go(
            AuthGuard.safeTarget(_loginReturnTarget()) ??
                AppRoutes.mapDiscovery,
          );
        }
      case AuthUnknown():
        return;
    }
  }

  /// Yığındaki (en üstteki) giriş ekranının `from` parametresi; ör. harita
  /// → giriş?from=… → kayıt → doğrulama akışında doğrulama sonrası hedef.
  String? _loginReturnTarget() {
    final configuration = router.routerDelegate.currentConfiguration;
    final locations = [
      configuration.uri,
      for (final match in configuration.matches)
        if (match is ImperativeRouteMatch) match.matches.uri,
    ];
    return locations.reversed
        .where((uri) => uri.path == AppRoutes.login)
        .firstOrNull
        ?.queryParameters[AppRoutes.fromParameter];
  }

  @disposeMethod
  void dispose() {
    unawaited(_sessionGuard.cancel());
    router.dispose();
    _refresh.dispose();
  }
}

class _MainShell extends StatelessWidget {
  const _MainShell({required this.shell, required this.onTabSelected});

  final StatefulNavigationShell shell;
  final VoidCallback onTabSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AdaptiveAppScaffold(
      navigationLabel: l10n.navigationSemantics,
      selectedIndex: shell.currentIndex,
      onDestinationSelected: (index) {
        onTabSelected();
        shell.goBranch(index, initialLocation: index == shell.currentIndex);
      },
      destinations: [
        AdaptiveDestination(
          key: const Key('nav_map'),
          icon: Icons.map_outlined,
          selectedIcon: Icons.map,
          label: l10n.navMap,
        ),
        AdaptiveDestination(
          key: const Key('nav_route_planner'),
          icon: Icons.route_outlined,
          selectedIcon: Icons.route,
          label: l10n.navRoutePlanner,
        ),
        AdaptiveDestination(
          key: const Key('nav_ai_assistant'),
          icon: Icons.assistant_outlined,
          selectedIcon: Icons.assistant,
          label: l10n.navAiAssistant,
        ),
        AdaptiveDestination(
          key: const Key('nav_civil_protection'),
          icon: Icons.shield_outlined,
          selectedIcon: Icons.shield,
          label: l10n.navCivilProtection,
        ),
      ],
      body: shell,
    );
  }
}

/// Haritadaki profil görseli: hesap menüsünü açar (profil veya giriş,
/// ayarlar).
class _AccountButton extends StatelessWidget {
  const _AccountButton({this.buttonKey = const Key('map_account_button')});

  final Key buttonKey;

  Future<void> _openMenu(BuildContext context, UserEntity? user) async {
    final destination = await showModalBottomSheet<String>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) => AccountMenuSheet(
        user: user,
        onOpenProfile: () => Navigator.of(sheetContext).pop(AppRoutes.profile),
        onSignIn: () => Navigator.of(sheetContext).pop(AppRoutes.login),
        onOpenSettings: () =>
            Navigator.of(sheetContext).pop(AppRoutes.settings),
      ),
    );
    if (destination == null || !context.mounted) {
      return;
    }
    unawaited(context.push(destination));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final user = switch (context.watch<AuthBloc>().state) {
      AuthAuthenticated(:final user) => user,
      AuthUnknown() || AuthGuest() => null,
    };
    return AccountAvatarButton(
      key: buttonKey,
      displayName: user?.displayName,
      semanticsLabel: user == null
          ? l10n.accountButtonGuestSemantics
          : l10n.accountButtonSemantics(user.displayName),
      onPressed: () => _openMenu(context, user),
    );
  }
}

/// Sekme başlıklarındaki hesap düğmesi (profil veya giriş + ayarlar).
/// Profil alt gezinme çubuğunda olmadığından hesaba buradan ulaşılır.
class _AppBarAccountButton extends StatelessWidget {
  const _AppBarAccountButton();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsetsDirectional.only(end: AppSpacing.xs),
    child: _AccountButton(buttonKey: Key('app_bar_account_button')),
  );
}
