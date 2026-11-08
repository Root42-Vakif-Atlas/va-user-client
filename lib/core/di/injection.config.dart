// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:flutter_tts/flutter_tts.dart' as _i50;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:package_info_plus/package_info_plus.dart' as _i655;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:speech_to_text/speech_to_text.dart' as _i941;
import 'package:uuid/uuid.dart' as _i706;
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart' as _i840;
import 'package:vakif_atlas/core/a11y/haptic_feedback_service.dart' as _i1053;
import 'package:vakif_atlas/core/a11y/speech_input_service.dart' as _i744;
import 'package:vakif_atlas/core/a11y/voice_io_service.dart' as _i325;
import 'package:vakif_atlas/core/config/app_config.dart' as _i634;
import 'package:vakif_atlas/core/di/map_module.dart' as _i736;
import 'package:vakif_atlas/core/di/network_module.dart' as _i1000;
import 'package:vakif_atlas/core/di/register_module.dart' as _i407;
import 'package:vakif_atlas/core/events/user_activity_events.dart' as _i266;
import 'package:vakif_atlas/core/location/geolocator_location_service.dart'
    as _i1;
import 'package:vakif_atlas/core/location/location_service.dart' as _i963;
import 'package:vakif_atlas/core/map/map_tile_source.dart' as _i1068;
import 'package:vakif_atlas/core/media/camera_capture_controller.dart' as _i788;
import 'package:vakif_atlas/core/media/in_app_camera_launcher.dart' as _i330;
import 'package:vakif_atlas/core/media/photo_attacher.dart' as _i835;
import 'package:vakif_atlas/core/media/photo_picker_service.dart' as _i315;
import 'package:vakif_atlas/core/media/photo_processor.dart' as _i299;
import 'package:vakif_atlas/core/network/connectivity_service.dart' as _i682;
import 'package:vakif_atlas/core/network/dio_factory.dart' as _i898;
import 'package:vakif_atlas/core/network/http_transport.dart' as _i618;
import 'package:vakif_atlas/core/network/interceptors/correlation_interceptor.dart'
    as _i964;
import 'package:vakif_atlas/core/network/network_status.dart' as _i958;
import 'package:vakif_atlas/core/network/session_events.dart' as _i121;
import 'package:vakif_atlas/core/notifications/flutter_local_notification_service.dart'
    as _i51;
import 'package:vakif_atlas/core/notifications/local_notification_service.dart'
    as _i279;
import 'package:vakif_atlas/core/observability/app_bloc_observer.dart' as _i858;
import 'package:vakif_atlas/core/observability/app_logger.dart' as _i1016;
import 'package:vakif_atlas/core/observability/telemetry_service.dart' as _i326;
import 'package:vakif_atlas/core/permissions/permission_handler_service.dart'
    as _i685;
import 'package:vakif_atlas/core/permissions/permission_service.dart' as _i636;
import 'package:vakif_atlas/core/router/app_router.dart' as _i532;
import 'package:vakif_atlas/core/router/navigator_camera_launcher.dart'
    as _i276;
import 'package:vakif_atlas/core/security/device_integrity_service.dart'
    as _i862;
import 'package:vakif_atlas/core/security/privacy_screen_guard.dart' as _i833;
import 'package:vakif_atlas/core/sharing/document_share_service.dart' as _i277;
import 'package:vakif_atlas/core/storage/cache_store.dart' as _i568;
import 'package:vakif_atlas/core/storage/installation_id_service.dart' as _i808;
import 'package:vakif_atlas/core/storage/local_db_service.dart' as _i1019;
import 'package:vakif_atlas/core/storage/preferences_service.dart' as _i620;
import 'package:vakif_atlas/core/storage/secure_storage_service.dart' as _i227;
import 'package:vakif_atlas/features/ai_assistant/data/repositories/catalog_aware_digital_guide_repository.dart'
    as _i676;
import 'package:vakif_atlas/features/ai_assistant/data/repositories/digital_guide_repository_impl.dart'
    as _i189;
import 'package:vakif_atlas/features/ai_assistant/data/sources/digital_guide_remote_data_source.dart'
    as _i481;
import 'package:vakif_atlas/features/ai_assistant/di/ai_assistant_module.dart'
    as _i640;
import 'package:vakif_atlas/features/ai_assistant/domain/catalog_guide/catalog_guide.dart'
    as _i113;
import 'package:vakif_atlas/features/ai_assistant/domain/repositories/digital_guide_repository.dart'
    as _i702;
import 'package:vakif_atlas/features/ai_assistant/domain/usecases/digital_guide_usecases.dart'
    as _i976;
import 'package:vakif_atlas/features/ai_assistant/presentation/bloc/digital_guide_bloc.dart'
    as _i471;
import 'package:vakif_atlas/features/ai_assistant/presentation/cubit/guide_voice_cubit.dart'
    as _i957;
import 'package:vakif_atlas/features/auth/data/auth_token_refresher_impl.dart'
    as _i347;
import 'package:vakif_atlas/features/auth/data/repositories/auth_repository_impl.dart'
    as _i350;
import 'package:vakif_atlas/features/auth/data/repositories/legal_document_repository_impl.dart'
    as _i358;
import 'package:vakif_atlas/features/auth/data/sources/auth_local_data_source.dart'
    as _i455;
import 'package:vakif_atlas/features/auth/data/sources/auth_remote_data_source.dart'
    as _i47;
import 'package:vakif_atlas/features/auth/di/auth_module.dart' as _i621;
import 'package:vakif_atlas/features/auth/domain/entities/user_entity.dart'
    as _i875;
import 'package:vakif_atlas/features/auth/domain/entities/verification_challenge.dart'
    as _i906;
import 'package:vakif_atlas/features/auth/domain/repositories/auth_repository.dart'
    as _i626;
import 'package:vakif_atlas/features/auth/domain/repositories/legal_document_repository.dart'
    as _i1063;
import 'package:vakif_atlas/features/auth/domain/usecases/auth_usecases.dart'
    as _i743;
import 'package:vakif_atlas/features/auth/presentation/bloc/account_blocs.dart'
    as _i235;
import 'package:vakif_atlas/features/auth/presentation/bloc/auth_bloc.dart'
    as _i601;
import 'package:vakif_atlas/features/auth/presentation/bloc/login_bloc.dart'
    as _i71;
import 'package:vakif_atlas/features/auth/presentation/bloc/register_bloc.dart'
    as _i1046;
import 'package:vakif_atlas/features/auth/presentation/bloc/verification_bloc.dart'
    as _i323;
import 'package:vakif_atlas/features/auth/presentation/cubit/resend_cooldown_cubit.dart'
    as _i163;
import 'package:vakif_atlas/features/auth/presentation/pending_verification.dart'
    as _i463;
import 'package:vakif_atlas/features/catalog/data/repositories/catalog_repository_impl.dart'
    as _i108;
import 'package:vakif_atlas/features/catalog/data/sources/catalog_local_data_source.dart'
    as _i1041;
import 'package:vakif_atlas/features/catalog/data/sources/catalog_remote_data_source.dart'
    as _i134;
import 'package:vakif_atlas/features/catalog/di/catalog_module.dart' as _i1043;
import 'package:vakif_atlas/features/catalog/domain/repositories/catalog_repository.dart'
    as _i211;
import 'package:vakif_atlas/features/catalog/domain/usecases/catalog_usecases.dart'
    as _i735;
import 'package:vakif_atlas/features/catalog/presentation/bloc/monument_search_bloc.dart'
    as _i173;
import 'package:vakif_atlas/features/civil_protection/data/repositories/damage_report_repository_impl.dart'
    as _i209;
import 'package:vakif_atlas/features/civil_protection/data/sources/damage_report_remote_data_source.dart'
    as _i1014;
import 'package:vakif_atlas/features/civil_protection/di/civil_protection_module.dart'
    as _i932;
import 'package:vakif_atlas/features/civil_protection/domain/repositories/damage_report_repository.dart'
    as _i492;
import 'package:vakif_atlas/features/civil_protection/domain/usecases/damage_report_usecases.dart'
    as _i61;
import 'package:vakif_atlas/features/civil_protection/presentation/bloc/damage_report_wizard_bloc.dart'
    as _i385;
import 'package:vakif_atlas/features/civil_protection/presentation/cubit/damage_report_detail_cubit.dart'
    as _i892;
import 'package:vakif_atlas/features/civil_protection/presentation/cubit/damage_report_list_cubit.dart'
    as _i510;
import 'package:vakif_atlas/features/feedback/data/repositories/feedback_repository_impl.dart'
    as _i13;
import 'package:vakif_atlas/features/feedback/data/sources/feedback_remote_data_source.dart'
    as _i769;
import 'package:vakif_atlas/features/feedback/di/feedback_module.dart' as _i884;
import 'package:vakif_atlas/features/feedback/domain/repositories/feedback_repository.dart'
    as _i559;
import 'package:vakif_atlas/features/feedback/domain/usecases/submit_feedback_usecase.dart'
    as _i146;
import 'package:vakif_atlas/features/feedback/presentation/cubit/feedback_form_cubit.dart'
    as _i306;
import 'package:vakif_atlas/features/gamification/data/repositories/gamification_repository_impl.dart'
    as _i453;
import 'package:vakif_atlas/features/gamification/data/sources/gamification_remote_data_source.dart'
    as _i145;
import 'package:vakif_atlas/features/gamification/di/gamification_module.dart'
    as _i457;
import 'package:vakif_atlas/features/gamification/domain/repositories/gamification_repository.dart'
    as _i561;
import 'package:vakif_atlas/features/gamification/domain/usecases/gamification_usecases.dart'
    as _i978;
import 'package:vakif_atlas/features/gamification/presentation/cubit/gamification_cubit.dart'
    as _i548;
import 'package:vakif_atlas/features/map_discovery/presentation/bloc/map_discovery_bloc.dart'
    as _i729;
import 'package:vakif_atlas/features/map_discovery/presentation/cubit/monument_tiles_cubit.dart'
    as _i977;
import 'package:vakif_atlas/features/map_discovery/presentation/cubit/user_location_cubit.dart'
    as _i925;
import 'package:vakif_atlas/features/memory_corner/data/repositories/memory_repository_impl.dart'
    as _i91;
import 'package:vakif_atlas/features/memory_corner/data/sources/memory_remote_data_source.dart'
    as _i34;
import 'package:vakif_atlas/features/memory_corner/di/memory_corner_module.dart'
    as _i115;
import 'package:vakif_atlas/features/memory_corner/domain/repositories/memory_repository.dart'
    as _i673;
import 'package:vakif_atlas/features/memory_corner/domain/usecases/memory_usecases.dart'
    as _i592;
import 'package:vakif_atlas/features/memory_corner/presentation/bloc/memory_composer_bloc.dart'
    as _i73;
import 'package:vakif_atlas/features/memory_corner/presentation/bloc/memory_list_bloc.dart'
    as _i199;
import 'package:vakif_atlas/features/memory_corner/presentation/cubit/my_memories_cubit.dart'
    as _i256;
import 'package:vakif_atlas/features/monument_detail/presentation/cubit/complex_detail_cubit.dart'
    as _i981;
import 'package:vakif_atlas/features/monument_detail/presentation/cubit/complex_members_cubit.dart'
    as _i580;
import 'package:vakif_atlas/features/monument_detail/presentation/cubit/monument_detail_cubit.dart'
    as _i218;
import 'package:vakif_atlas/features/nearby_alerts/data/repositories/nearby_alert_log_repository_impl.dart'
    as _i719;
import 'package:vakif_atlas/features/nearby_alerts/data/repositories/nearby_monuments_repository_impl.dart'
    as _i628;
import 'package:vakif_atlas/features/nearby_alerts/di/nearby_alerts_module.dart'
    as _i426;
import 'package:vakif_atlas/features/nearby_alerts/domain/entities/nearby_alert_policy.dart'
    as _i927;
import 'package:vakif_atlas/features/nearby_alerts/domain/repositories/nearby_alerts_repositories.dart'
    as _i635;
import 'package:vakif_atlas/features/nearby_alerts/domain/usecases/nearby_alert_usecases.dart'
    as _i789;
import 'package:vakif_atlas/features/nearby_alerts/presentation/cubit/nearby_alerts_cubit.dart'
    as _i414;
import 'package:vakif_atlas/features/onboarding/data/repositories/onboarding_repository_impl.dart'
    as _i274;
import 'package:vakif_atlas/features/onboarding/di/onboarding_module.dart'
    as _i588;
import 'package:vakif_atlas/features/onboarding/domain/repositories/onboarding_repository.dart'
    as _i167;
import 'package:vakif_atlas/features/onboarding/domain/usecases/onboarding_usecases.dart'
    as _i667;
import 'package:vakif_atlas/features/onboarding/presentation/cubit/onboarding_cubit.dart'
    as _i208;
import 'package:vakif_atlas/features/route_export/data/render/route_basemap.dart'
    as _i476;
import 'package:vakif_atlas/features/route_export/data/render/route_pdf_renderer.dart'
    as _i888;
import 'package:vakif_atlas/features/route_export/data/repositories/route_export_repository_impl.dart'
    as _i237;
import 'package:vakif_atlas/features/route_export/data/route_export_account_cleanup.dart'
    as _i53;
import 'package:vakif_atlas/features/route_export/data/sources/route_export_local_data_source.dart'
    as _i942;
import 'package:vakif_atlas/features/route_export/data/sources/route_export_remote_data_source.dart'
    as _i899;
import 'package:vakif_atlas/features/route_export/di/route_export_module.dart'
    as _i159;
import 'package:vakif_atlas/features/route_export/domain/repositories/route_export_repository.dart'
    as _i264;
import 'package:vakif_atlas/features/route_export/domain/usecases/route_export_usecases.dart'
    as _i498;
import 'package:vakif_atlas/features/route_export/presentation/cubit/route_export_cubit.dart'
    as _i275;
import 'package:vakif_atlas/features/route_export/presentation/cubit/route_exports_cubit.dart'
    as _i686;
import 'package:vakif_atlas/features/route_planner/data/repositories/route_repository_impl.dart'
    as _i490;
import 'package:vakif_atlas/features/route_planner/data/sources/route_remote_data_source.dart'
    as _i72;
import 'package:vakif_atlas/features/route_planner/di/route_planner_module.dart'
    as _i242;
import 'package:vakif_atlas/features/route_planner/domain/repositories/route_repository.dart'
    as _i15;
import 'package:vakif_atlas/features/route_planner/domain/usecases/optimize_stop_order_usecase.dart'
    as _i617;
import 'package:vakif_atlas/features/route_planner/domain/usecases/route_usecases.dart'
    as _i327;
import 'package:vakif_atlas/features/route_planner/presentation/bloc/route_builder_bloc.dart'
    as _i362;
import 'package:vakif_atlas/features/route_planner/presentation/cubit/route_detail_cubit.dart'
    as _i1020;
import 'package:vakif_atlas/features/route_planner/presentation/cubit/route_list_cubit.dart'
    as _i749;
import 'package:vakif_atlas/features/saved_monuments/data/repositories/saved_monuments_repository_impl.dart'
    as _i331;
import 'package:vakif_atlas/features/saved_monuments/data/sources/saved_monuments_local_data_source.dart'
    as _i890;
import 'package:vakif_atlas/features/saved_monuments/data/sources/saved_monuments_remote_data_source.dart'
    as _i202;
import 'package:vakif_atlas/features/saved_monuments/di/saved_monuments_module.dart'
    as _i752;
import 'package:vakif_atlas/features/saved_monuments/domain/repositories/saved_monuments_repository.dart'
    as _i1001;
import 'package:vakif_atlas/features/saved_monuments/domain/usecases/saved_monuments_usecases.dart'
    as _i114;
import 'package:vakif_atlas/features/saved_monuments/presentation/cubit/saved_monuments_cubit.dart'
    as _i149;
import 'package:vakif_atlas/features/saved_monuments/presentation/cubit/saved_monuments_list_cubit.dart'
    as _i418;
import 'package:vakif_atlas/features/settings/data/repositories/settings_repository_impl.dart'
    as _i152;
import 'package:vakif_atlas/features/settings/di/settings_module.dart' as _i220;
import 'package:vakif_atlas/features/settings/domain/repositories/settings_repository.dart'
    as _i579;
import 'package:vakif_atlas/features/settings/domain/usecases/get_app_settings_usecase.dart'
    as _i731;
import 'package:vakif_atlas/features/settings/domain/usecases/save_app_settings_usecase.dart'
    as _i1038;
import 'package:vakif_atlas/features/settings/presentation/cubit/app_settings_cubit.dart'
    as _i638;
import 'package:vakif_atlas/features/settings/presentation/cubit/device_permissions_cubit.dart'
    as _i653;
import 'package:vakif_atlas/features/settings/presentation/cubit/location_permission_cubit.dart'
    as _i654;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    final nearbyAlertsModule = _$NearbyAlertsModule();
    final routePlannerModule = _$RoutePlannerModule();
    final settingsModule = _$SettingsModule();
    final mapModule = _$MapModule();
    final networkModule = _$NetworkModule();
    final onboardingModule = _$OnboardingModule();
    final authModule = _$AuthModule();
    final catalogModule = _$CatalogModule();
    final aiAssistantModule = _$AiAssistantModule();
    final civilProtectionModule = _$CivilProtectionModule();
    final savedMonumentsModule = _$SavedMonumentsModule();
    final gamificationModule = _$GamificationModule();
    final memoryCornerModule = _$MemoryCornerModule();
    final feedbackModule = _$FeedbackModule();
    final routeExportModule = _$RouteExportModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.sharedPreferences,
      preResolve: true,
    );
    await gh.factoryAsync<_i655.PackageInfo>(
      () => registerModule.packageInfo,
      preResolve: true,
    );
    gh.factory<_i163.ResendCooldownCubit>(() => _i163.ResendCooldownCubit());
    gh.lazySingleton<_i840.A11yAnnouncer>(() => _i840.A11yAnnouncer());
    gh.lazySingleton<_i1053.HapticFeedbackService>(
      () => _i1053.HapticFeedbackService(),
    );
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage,
    );
    gh.lazySingleton<_i895.Connectivity>(() => registerModule.connectivity);
    gh.lazySingleton<_i50.FlutterTts>(() => registerModule.flutterTts);
    gh.lazySingleton<_i941.SpeechToText>(() => registerModule.speechToText);
    gh.lazySingleton<_i706.Uuid>(() => registerModule.uuid);
    gh.lazySingleton<_i266.UserActivityEvents>(
      () => _i266.UserActivityEvents(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i299.PhotoProcessor>(() => const _i299.PhotoProcessor());
    gh.lazySingleton<_i121.SessionEvents>(
      () => _i121.SessionEvents(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i833.PrivacyScreenGuard>(
      () => _i833.PrivacyScreenGuard(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i1019.LocalDbService>(
      () => _i1019.LocalDbService(),
      dispose: (i) => i.close(),
    );
    gh.lazySingleton<_i927.NearbyAlertPolicy>(
      () => nearbyAlertsModule.nearbyAlertPolicy,
    );
    gh.lazySingleton<_i617.OptimizeStopOrderUseCase>(
      () => routePlannerModule.optimizeStopOrderUseCase,
    );
    gh.lazySingleton<_i277.DocumentShareService>(
      () => _i277.PrintingDocumentShareService(),
    );
    gh.lazySingleton<_i227.SecureStorageService>(
      () => _i227.SecureStorageService(gh<_i558.FlutterSecureStorage>()),
    );
    gh.factory<_i788.CameraCaptureController>(
      () => _i788.PlatformCameraCaptureController(),
    );
    gh.lazySingleton<_i963.LocationService>(
      () => _i1.GeolocatorLocationService(),
    );
    gh.lazySingleton<_i325.VoiceIoService>(
      () => _i325.VoiceIoService(gh<_i50.FlutterTts>()),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i620.PreferencesService>(
      () => _i620.PreferencesService(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i568.CacheStore>(
      () => _i568.CacheStore(gh<_i1019.LocalDbService>()),
    );
    gh.lazySingleton<_i326.TelemetryService>(
      () => _i326.DisabledTelemetryService(),
    );
    gh.factory<_i925.UserLocationCubit>(
      () => _i925.UserLocationCubit(gh<_i963.LocationService>()),
    );
    gh.factory<_i654.LocationPermissionCubit>(
      () => _i654.LocationPermissionCubit(gh<_i963.LocationService>()),
    );
    gh.lazySingleton<_i744.SpeechInputService>(
      () => _i744.SpeechToTextInputService(
        gh<_i941.SpeechToText>(),
        gh<_i325.VoiceIoService>(),
      ),
    );
    gh.lazySingleton<_i618.HttpTransport>(
      () => _i618.PlatformHttpTransport(gh<_i634.AppConfig>()),
    );
    gh.lazySingleton<_i808.InstallationIdService>(
      () => _i808.InstallationIdService(
        gh<_i620.PreferencesService>(),
        gh<_i706.Uuid>(),
      ),
    );
    gh.lazySingleton<_i1041.CatalogLocalDataSource>(
      () => _i1041.CatalogLocalDataSourceImpl(gh<_i568.CacheStore>()),
    );
    gh.lazySingleton<_i636.PermissionService>(
      () => _i685.PermissionHandlerService(),
    );
    gh.factory<_i957.GuideVoiceCubit>(
      () => _i957.GuideVoiceCubit(
        gh<_i744.SpeechInputService>(),
        gh<_i636.PermissionService>(),
      ),
    );
    gh.lazySingleton<_i898.DioFactory>(
      () => _i898.DioFactory(gh<_i634.AppConfig>(), gh<_i618.HttpTransport>()),
    );
    gh.lazySingleton<_i635.NearbyAlertLogRepository>(
      () => _i719.NearbyAlertLogRepositoryImpl(gh<_i620.PreferencesService>()),
    );
    gh.lazySingleton<_i958.NetworkStatus>(
      () => _i958.DeviceNetworkStatus(gh<_i895.Connectivity>()),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i890.SavedMonumentsLocalDataSource>(
      () =>
          _i890.SavedMonumentsLocalDataSourceImpl(gh<_i1019.LocalDbService>()),
    );
    gh.lazySingleton<_i579.SettingsRepository>(
      () => _i152.SettingsRepositoryImpl(gh<_i620.PreferencesService>()),
    );
    gh.lazySingleton<_i167.OnboardingRepository>(
      () => _i274.OnboardingRepositoryImpl(gh<_i620.PreferencesService>()),
    );
    gh.lazySingleton<_i731.GetAppSettingsUseCase>(
      () =>
          settingsModule.getAppSettingsUseCase(gh<_i579.SettingsRepository>()),
    );
    gh.lazySingleton<_i1038.SaveAppSettingsUseCase>(
      () =>
          settingsModule.saveAppSettingsUseCase(gh<_i579.SettingsRepository>()),
    );
    gh.lazySingleton<_i789.RecordNearbyAlertUseCase>(
      () => nearbyAlertsModule.recordNearbyAlertUseCase(
        gh<_i635.NearbyAlertLogRepository>(),
        gh<_i927.NearbyAlertPolicy>(),
      ),
    );
    gh.lazySingleton<_i942.RouteExportLocalDataSource>(
      () => _i942.RouteExportLocalDataSourceImpl(gh<_i1019.LocalDbService>()),
    );
    gh.lazySingleton<_i455.AuthLocalDataSource>(
      () => _i455.AuthLocalDataSourceImpl(gh<_i227.SecureStorageService>()),
    );
    gh.lazySingleton<_i1016.AppLogger>(
      () => _i1016.AppLogger(gh<_i634.AppConfig>()),
    );
    gh.lazySingleton<_i789.ClearNearbyAlertLogUseCase>(
      () => nearbyAlertsModule.clearNearbyAlertLogUseCase(
        gh<_i635.NearbyAlertLogRepository>(),
      ),
    );
    gh.lazySingleton<_i1068.MapTileSource>(
      () => mapModule.mapTileSource(
        gh<_i634.AppConfig>(),
        gh<_i655.PackageInfo>(),
        gh<_i1016.AppLogger>(),
      ),
    );
    gh.lazySingleton<_i361.Dio>(
      () => networkModule.storageDio(
        gh<_i898.DioFactory>(),
        gh<_i1016.AppLogger>(),
        gh<_i326.TelemetryService>(),
        gh<_i958.NetworkStatus>(),
      ),
      instanceName: 'storageDio',
    );
    gh.lazySingleton<_i361.Dio>(
      () => networkModule.probeDio(gh<_i898.DioFactory>()),
      instanceName: 'probeDio',
    );
    gh.lazySingleton<_i476.RouteBasemapRenderer>(
      () => _i476.RouteBasemapRenderer(
        gh<_i1068.MapTileSource>(),
        logger: gh<_i1016.AppLogger>(),
      ),
    );
    gh.factory<_i653.DevicePermissionsCubit>(
      () => _i653.DevicePermissionsCubit(gh<_i636.PermissionService>()),
    );
    gh.lazySingleton<_i638.AppSettingsCubit>(
      () => _i638.AppSettingsCubit(
        gh<_i731.GetAppSettingsUseCase>(),
        gh<_i1038.SaveAppSettingsUseCase>(),
        gh<_i1053.HapticFeedbackService>(),
      ),
    );
    gh.lazySingleton<_i279.LocalNotificationService>(
      () => _i51.FlutterLocalNotificationService(
        gh<_i361.Dio>(instanceName: 'storageDio'),
        gh<_i1016.AppLogger>(),
      ),
    );
    gh.lazySingleton<_i862.DeviceIntegrityService>(
      () => _i862.DeviceIntegrityService(
        gh<_i634.AppConfig>(),
        gh<_i655.PackageInfo>(),
        gh<_i1016.AppLogger>(),
        gh<_i326.TelemetryService>(),
      ),
    );
    gh.lazySingleton<_i667.IsOnboardingCompletedUseCase>(
      () => onboardingModule.isOnboardingCompletedUseCase(
        gh<_i167.OnboardingRepository>(),
      ),
    );
    gh.lazySingleton<_i667.CompleteOnboardingUseCase>(
      () => onboardingModule.completeOnboardingUseCase(
        gh<_i167.OnboardingRepository>(),
      ),
    );
    gh.lazySingleton<_i858.AppBlocObserver>(
      () => _i858.AppBlocObserver(
        gh<_i1016.AppLogger>(),
        gh<_i326.TelemetryService>(),
      ),
    );
    gh.lazySingleton<_i682.ConnectivityService>(
      () => _i682.ConnectivityService(
        gh<_i895.Connectivity>(),
        gh<_i361.Dio>(instanceName: 'probeDio'),
      ),
    );
    gh.lazySingleton<_i888.RoutePdfRenderer>(
      () => _i888.RoutePdfRenderer(gh<_i476.RouteBasemapRenderer>()),
    );
    gh.lazySingleton<_i208.OnboardingCubit>(
      () => _i208.OnboardingCubit(
        gh<_i667.IsOnboardingCompletedUseCase>(),
        gh<_i667.CompleteOnboardingUseCase>(),
      ),
    );
    gh.lazySingleton<_i964.CorrelationInterceptor>(
      () => networkModule.correlationInterceptor(
        gh<_i706.Uuid>(),
        gh<_i655.PackageInfo>(),
        gh<_i620.PreferencesService>(),
        gh<_i862.DeviceIntegrityService>(),
      ),
    );
    gh.lazySingleton<_i361.Dio>(
      () => networkModule.bareDio(
        gh<_i898.DioFactory>(),
        gh<_i1016.AppLogger>(),
        gh<_i326.TelemetryService>(),
        gh<_i964.CorrelationInterceptor>(),
        gh<_i958.NetworkStatus>(),
      ),
      instanceName: 'bareDio',
    );
    gh.lazySingleton<_i47.AuthTokenRemoteDataSource>(
      () => _i47.AuthTokenRemoteDataSourceImpl(
        gh<_i361.Dio>(instanceName: 'bareDio'),
      ),
    );
    gh.lazySingleton<_i121.AuthTokenRefresher>(
      () => _i347.AuthTokenRefresherImpl(
        gh<_i47.AuthTokenRemoteDataSource>(),
        gh<_i455.AuthLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i361.Dio>(
      () => networkModule.apiDio(
        gh<_i898.DioFactory>(),
        gh<_i1016.AppLogger>(),
        gh<_i326.TelemetryService>(),
        gh<_i964.CorrelationInterceptor>(),
        gh<_i227.SecureStorageService>(),
        gh<_i121.AuthTokenRefresher>(),
        gh<_i121.SessionEvents>(),
        gh<_i958.NetworkStatus>(),
      ),
      instanceName: 'apiDio',
    );
    gh.lazySingleton<_i481.DigitalGuideRemoteDataSource>(
      () => _i481.DigitalGuideRemoteDataSourceImpl(
        gh<_i361.Dio>(instanceName: 'apiDio'),
      ),
    );
    gh.lazySingleton<_i47.AuthRemoteDataSource>(
      () =>
          _i47.AuthRemoteDataSourceImpl(gh<_i361.Dio>(instanceName: 'apiDio')),
    );
    gh.lazySingleton<_i134.CatalogRemoteDataSource>(
      () => _i134.CatalogRemoteDataSourceImpl(
        gh<_i361.Dio>(instanceName: 'apiDio'),
      ),
    );
    gh.lazySingleton<_i189.DigitalGuideRepositoryImpl>(
      () => _i189.DigitalGuideRepositoryImpl(
        gh<_i481.DigitalGuideRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i47.LegalDocumentRemoteDataSource>(
      () => _i47.LegalDocumentRemoteDataSourceImpl(
        gh<_i361.Dio>(instanceName: 'apiDio'),
      ),
    );
    gh.lazySingleton<_i769.FeedbackRemoteDataSource>(
      () => _i769.FeedbackRemoteDataSourceImpl(
        gh<_i361.Dio>(instanceName: 'apiDio'),
      ),
    );
    gh.lazySingleton<_i145.GamificationRemoteDataSource>(
      () => _i145.GamificationRemoteDataSourceImpl(
        gh<_i361.Dio>(instanceName: 'apiDio'),
      ),
    );
    gh.lazySingleton<_i899.RouteExportRemoteDataSource>(
      () => _i899.RouteExportRemoteDataSourceImpl(
        gh<_i361.Dio>(instanceName: 'apiDio'),
        gh<_i361.Dio>(instanceName: 'storageDio'),
        gh<_i808.InstallationIdService>(),
      ),
    );
    gh.lazySingleton<_i34.MemoryRemoteDataSource>(
      () => _i34.MemoryRemoteDataSourceImpl(
        gh<_i361.Dio>(instanceName: 'apiDio'),
        gh<_i361.Dio>(instanceName: 'storageDio'),
      ),
    );
    gh.lazySingleton<_i202.SavedMonumentsRemoteDataSource>(
      () => _i202.SavedMonumentsRemoteDataSourceImpl(
        gh<_i361.Dio>(instanceName: 'apiDio'),
        gh<_i808.InstallationIdService>(),
      ),
    );
    gh.lazySingleton<_i1063.LegalDocumentRepository>(
      () => _i358.LegalDocumentRepositoryImpl(
        gh<_i47.LegalDocumentRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i626.AuthRepository>(
      () => _i350.AuthRepositoryImpl(
        gh<_i47.AuthRemoteDataSource>(),
        gh<_i47.AuthTokenRemoteDataSource>(),
        gh<_i455.AuthLocalDataSource>(),
        gh<_i121.SessionEvents>(),
      ),
    );
    gh.lazySingleton<_i743.GetLegalDocumentUseCase>(
      () => authModule.getLegalDocumentUseCase(
        gh<_i1063.LegalDocumentRepository>(),
      ),
    );
    gh.lazySingleton<_i211.CatalogRepository>(
      () => _i108.CatalogRepositoryImpl(
        gh<_i134.CatalogRemoteDataSource>(),
        gh<_i1041.CatalogLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i1014.DamageReportRemoteDataSource>(
      () => _i1014.DamageReportRemoteDataSourceImpl(
        gh<_i361.Dio>(instanceName: 'apiDio'),
        gh<_i361.Dio>(instanceName: 'storageDio'),
      ),
    );
    gh.lazySingleton<_i72.RouteRemoteDataSource>(
      () => _i72.RouteRemoteDataSourceImpl(
        gh<_i361.Dio>(instanceName: 'apiDio'),
        gh<_i808.InstallationIdService>(),
      ),
    );
    gh.lazySingleton<_i15.RouteRepository>(
      () => _i490.RouteRepositoryImpl(
        gh<_i72.RouteRemoteDataSource>(),
        gh<_i266.UserActivityEvents>(),
        gh<_i121.SessionEvents>(),
      ),
    );
    gh.lazySingleton<_i559.FeedbackRepository>(
      () => _i13.FeedbackRepositoryImpl(
        gh<_i769.FeedbackRemoteDataSource>(),
        gh<_i655.PackageInfo>(),
      ),
    );
    gh.factory<_i235.LegalDocumentCubit>(
      () => _i235.LegalDocumentCubit(gh<_i743.GetLegalDocumentUseCase>()),
    );
    gh.lazySingleton<_i1001.SavedMonumentsRepository>(
      () => _i331.SavedMonumentsRepositoryImpl(
        gh<_i890.SavedMonumentsLocalDataSource>(),
        gh<_i202.SavedMonumentsRemoteDataSource>(),
        gh<_i121.SessionEvents>(),
      ),
    );
    gh.lazySingleton<_i264.RouteExportRepository>(
      () => _i237.RouteExportRepositoryImpl(
        gh<_i888.RoutePdfRenderer>(),
        gh<_i899.RouteExportRemoteDataSource>(),
        gh<_i942.RouteExportLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i673.MemoryRepository>(
      () => _i91.MemoryRepositoryImpl(
        gh<_i34.MemoryRemoteDataSource>(),
        gh<_i266.UserActivityEvents>(),
      ),
    );
    gh.lazySingleton<_i735.SearchMonumentsUseCase>(
      () => catalogModule.searchMonumentsUseCase(gh<_i211.CatalogRepository>()),
    );
    gh.lazySingleton<_i735.GetMonumentPinsUseCase>(
      () => catalogModule.getMonumentPinsUseCase(gh<_i211.CatalogRepository>()),
    );
    gh.lazySingleton<_i735.GetMapTileUseCase>(
      () => catalogModule.getMapTileUseCase(gh<_i211.CatalogRepository>()),
    );
    gh.lazySingleton<_i735.GetMapExtentUseCase>(
      () => catalogModule.getMapExtentUseCase(gh<_i211.CatalogRepository>()),
    );
    gh.lazySingleton<_i735.GetMonumentDetailUseCase>(
      () =>
          catalogModule.getMonumentDetailUseCase(gh<_i211.CatalogRepository>()),
    );
    gh.lazySingleton<_i735.GetComplexDetailUseCase>(
      () =>
          catalogModule.getComplexDetailUseCase(gh<_i211.CatalogRepository>()),
    );
    gh.lazySingleton<_i735.GetComplexMembersUseCase>(
      () =>
          catalogModule.getComplexMembersUseCase(gh<_i211.CatalogRepository>()),
    );
    gh.lazySingleton<_i327.GetRoutesUseCase>(
      () => routePlannerModule.getRoutesUseCase(gh<_i15.RouteRepository>()),
    );
    gh.lazySingleton<_i327.GetRouteUseCase>(
      () => routePlannerModule.getRouteUseCase(gh<_i15.RouteRepository>()),
    );
    gh.lazySingleton<_i327.SaveRouteUseCase>(
      () => routePlannerModule.saveRouteUseCase(gh<_i15.RouteRepository>()),
    );
    gh.lazySingleton<_i327.DeleteRouteUseCase>(
      () => routePlannerModule.deleteRouteUseCase(gh<_i15.RouteRepository>()),
    );
    gh.lazySingleton<_i327.WatchRouteChangesUseCase>(
      () => routePlannerModule.watchRouteChangesUseCase(
        gh<_i15.RouteRepository>(),
      ),
    );
    gh.lazySingleton<_i327.PreviewRouteUseCase>(
      () => routePlannerModule.previewRouteUseCase(gh<_i15.RouteRepository>()),
    );
    gh.lazySingleton<_i327.GetTravelMatrixUseCase>(
      () =>
          routePlannerModule.getTravelMatrixUseCase(gh<_i15.RouteRepository>()),
    );
    gh.lazySingleton<_i492.DamageReportRepository>(
      () => _i209.DamageReportRepositoryImpl(
        gh<_i1014.DamageReportRemoteDataSource>(),
        gh<_i266.UserActivityEvents>(),
      ),
    );
    gh.lazySingleton<_i113.CatalogGuide>(
      () => aiAssistantModule.catalogGuide(gh<_i211.CatalogRepository>()),
    );
    gh.lazySingleton<_i61.GetDamageReportsUseCase>(
      () => civilProtectionModule.getDamageReportsUseCase(
        gh<_i492.DamageReportRepository>(),
      ),
    );
    gh.lazySingleton<_i61.GetDamageReportUseCase>(
      () => civilProtectionModule.getDamageReportUseCase(
        gh<_i492.DamageReportRepository>(),
      ),
    );
    gh.lazySingleton<_i61.SubmitDamageReportUseCase>(
      () => civilProtectionModule.submitDamageReportUseCase(
        gh<_i492.DamageReportRepository>(),
      ),
    );
    gh.lazySingleton<_i61.WatchSubmittedReportsUseCase>(
      () => civilProtectionModule.watchSubmittedReportsUseCase(
        gh<_i492.DamageReportRepository>(),
      ),
    );
    gh.lazySingleton<_i743.LoginUseCase>(
      () => authModule.loginUseCase(gh<_i626.AuthRepository>()),
    );
    gh.lazySingleton<_i743.LogoutUseCase>(
      () => authModule.logoutUseCase(gh<_i626.AuthRepository>()),
    );
    gh.lazySingleton<_i743.RefreshTokenUseCase>(
      () => authModule.refreshTokenUseCase(gh<_i626.AuthRepository>()),
    );
    gh.lazySingleton<_i743.RestoreSessionUseCase>(
      () => authModule.restoreSessionUseCase(gh<_i626.AuthRepository>()),
    );
    gh.lazySingleton<_i743.WatchAuthSessionUseCase>(
      () => authModule.watchAuthSessionUseCase(gh<_i626.AuthRepository>()),
    );
    gh.lazySingleton<_i743.RegisterUseCase>(
      () => authModule.registerUseCase(gh<_i626.AuthRepository>()),
    );
    gh.lazySingleton<_i743.VerifyEmailUseCase>(
      () => authModule.verifyEmailUseCase(gh<_i626.AuthRepository>()),
    );
    gh.lazySingleton<_i743.ResendVerificationCodeUseCase>(
      () =>
          authModule.resendVerificationCodeUseCase(gh<_i626.AuthRepository>()),
    );
    gh.lazySingleton<_i743.RequestPasswordResetUseCase>(
      () => authModule.requestPasswordResetUseCase(gh<_i626.AuthRepository>()),
    );
    gh.lazySingleton<_i743.ResetPasswordUseCase>(
      () => authModule.resetPasswordUseCase(gh<_i626.AuthRepository>()),
    );
    gh.lazySingleton<_i743.ChangePasswordUseCase>(
      () => authModule.changePasswordUseCase(gh<_i626.AuthRepository>()),
    );
    gh.lazySingleton<_i743.DeleteAccountUseCase>(
      () => authModule.deleteAccountUseCase(gh<_i626.AuthRepository>()),
    );
    gh.factory<_i981.ComplexDetailCubit>(
      () => _i981.ComplexDetailCubit(gh<_i735.GetComplexDetailUseCase>()),
    );
    gh.lazySingleton<_i561.GamificationRepository>(
      () => _i453.GamificationRepositoryImpl(
        gh<_i145.GamificationRemoteDataSource>(),
      ),
    );
    gh.factoryParam<_i323.VerifyEmailBloc, _i463.PendingVerification?, dynamic>(
      (pending, _) => _i323.VerifyEmailBloc(
        gh<_i743.VerifyEmailUseCase>(),
        gh<_i743.ResendVerificationCodeUseCase>(),
        pending,
      ),
    );
    gh.lazySingleton<_i114.GetSavedMonumentsUseCase>(
      () => savedMonumentsModule.getSavedMonumentsUseCase(
        gh<_i1001.SavedMonumentsRepository>(),
      ),
    );
    gh.lazySingleton<_i114.SaveMonumentUseCase>(
      () => savedMonumentsModule.saveMonumentUseCase(
        gh<_i1001.SavedMonumentsRepository>(),
      ),
    );
    gh.lazySingleton<_i114.RemoveSavedMonumentUseCase>(
      () => savedMonumentsModule.removeSavedMonumentUseCase(
        gh<_i1001.SavedMonumentsRepository>(),
      ),
    );
    gh.lazySingleton<_i114.WatchSavedMonumentsUseCase>(
      () => savedMonumentsModule.watchSavedMonumentsUseCase(
        gh<_i1001.SavedMonumentsRepository>(),
      ),
    );
    gh.factory<_i892.DamageReportDetailCubit>(
      () => _i892.DamageReportDetailCubit(gh<_i61.GetDamageReportUseCase>()),
    );
    gh.factory<_i235.ForgotPasswordBloc>(
      () => _i235.ForgotPasswordBloc(gh<_i743.RequestPasswordResetUseCase>()),
    );
    gh.factory<_i977.MonumentTilesCubit>(
      () => _i977.MonumentTilesCubit(gh<_i735.GetMapTileUseCase>()),
    );
    gh.lazySingleton<_i978.GetGamificationProfileUseCase>(
      () => gamificationModule.getGamificationProfileUseCase(
        gh<_i561.GamificationRepository>(),
      ),
    );
    gh.lazySingleton<_i978.AcknowledgeUnlocksUseCase>(
      () => gamificationModule.acknowledgeUnlocksUseCase(
        gh<_i561.GamificationRepository>(),
      ),
    );
    gh.factory<_i510.DamageReportListCubit>(
      () => _i510.DamageReportListCubit(
        gh<_i61.GetDamageReportsUseCase>(),
        gh<_i61.WatchSubmittedReportsUseCase>(),
      ),
    );
    gh.factory<_i173.MonumentSearchBloc>(
      () => _i173.MonumentSearchBloc(gh<_i735.SearchMonumentsUseCase>()),
    );
    gh.lazySingleton<_i635.NearbyMonumentsRepository>(
      () => _i628.NearbyMonumentsRepositoryImpl(gh<_i211.CatalogRepository>()),
    );
    gh.factory<_i71.LoginBloc>(() => _i71.LoginBloc(gh<_i743.LoginUseCase>()));
    gh.lazySingleton<_i548.GamificationCubit>(
      () => _i548.GamificationCubit(
        gh<_i978.GetGamificationProfileUseCase>(),
        gh<_i978.AcknowledgeUnlocksUseCase>(),
        gh<_i266.UserActivityEvents>(),
      ),
    );
    gh.lazySingleton<_i592.GetMemoriesUseCase>(
      () => memoryCornerModule.getMemoriesUseCase(gh<_i673.MemoryRepository>()),
    );
    gh.lazySingleton<_i592.GetMyMemoriesUseCase>(
      () =>
          memoryCornerModule.getMyMemoriesUseCase(gh<_i673.MemoryRepository>()),
    );
    gh.lazySingleton<_i592.CreateMemoryUseCase>(
      () =>
          memoryCornerModule.createMemoryUseCase(gh<_i673.MemoryRepository>()),
    );
    gh.lazySingleton<_i592.DeleteMemoryUseCase>(
      () =>
          memoryCornerModule.deleteMemoryUseCase(gh<_i673.MemoryRepository>()),
    );
    gh.lazySingleton<_i592.ReportMemoryUseCase>(
      () =>
          memoryCornerModule.reportMemoryUseCase(gh<_i673.MemoryRepository>()),
    );
    gh.lazySingleton<_i592.WatchMemoryChangesUseCase>(
      () => memoryCornerModule.watchMemoryChangesUseCase(
        gh<_i673.MemoryRepository>(),
      ),
    );
    gh.factory<_i749.RouteListCubit>(
      () => _i749.RouteListCubit(
        gh<_i327.GetRoutesUseCase>(),
        gh<_i327.WatchRouteChangesUseCase>(),
      ),
    );
    gh.factory<_i256.MyMemoriesCubit>(
      () => _i256.MyMemoriesCubit(
        gh<_i592.GetMyMemoriesUseCase>(),
        gh<_i592.DeleteMemoryUseCase>(),
        gh<_i735.GetMonumentPinsUseCase>(),
        gh<_i592.WatchMemoryChangesUseCase>(),
      ),
    );
    gh.factory<_i1020.RouteDetailCubit>(
      () => _i1020.RouteDetailCubit(
        gh<_i327.GetRouteUseCase>(),
        gh<_i327.DeleteRouteUseCase>(),
        gh<_i327.WatchRouteChangesUseCase>(),
      ),
    );
    gh.lazySingleton<_i53.RouteExportAccountCleanup>(
      () => _i53.RouteExportAccountCleanup(
        gh<_i121.SessionEvents>(),
        gh<_i264.RouteExportRepository>(),
      ),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i362.RouteBuilderBloc>(
      () => routePlannerModule.routeDraft(
        gh<_i735.GetMonumentPinsUseCase>(),
        gh<_i327.GetRouteUseCase>(),
        gh<_i327.SaveRouteUseCase>(),
        gh<_i617.OptimizeStopOrderUseCase>(),
        gh<_i327.PreviewRouteUseCase>(),
        gh<_i327.GetTravelMatrixUseCase>(),
      ),
      instanceName: 'routeDraft',
    );
    gh.lazySingleton<_i146.SubmitFeedbackUseCase>(
      () =>
          feedbackModule.submitFeedbackUseCase(gh<_i559.FeedbackRepository>()),
    );
    gh.factoryParam<_i235.ChangePasswordBloc, _i875.UserEntity?, dynamic>(
      (user, _) =>
          _i235.ChangePasswordBloc(gh<_i743.ChangePasswordUseCase>(), user),
    );
    gh.lazySingleton<_i498.CreateRouteExportUseCase>(
      () => routeExportModule.createRouteExportUseCase(
        gh<_i264.RouteExportRepository>(),
      ),
    );
    gh.lazySingleton<_i498.GetRouteExportsUseCase>(
      () => routeExportModule.getRouteExportsUseCase(
        gh<_i264.RouteExportRepository>(),
      ),
    );
    gh.lazySingleton<_i498.OpenRouteExportUseCase>(
      () => routeExportModule.openRouteExportUseCase(
        gh<_i264.RouteExportRepository>(),
      ),
    );
    gh.lazySingleton<_i498.CreateRouteExportShareLinkUseCase>(
      () => routeExportModule.createRouteExportShareLinkUseCase(
        gh<_i264.RouteExportRepository>(),
      ),
    );
    gh.lazySingleton<_i498.DeleteRouteExportUseCase>(
      () => routeExportModule.deleteRouteExportUseCase(
        gh<_i264.RouteExportRepository>(),
      ),
    );
    gh.lazySingleton<_i498.WatchRouteExportChangesUseCase>(
      () => routeExportModule.watchRouteExportChangesUseCase(
        gh<_i264.RouteExportRepository>(),
      ),
    );
    gh.factory<_i218.MonumentDetailCubit>(
      () => _i218.MonumentDetailCubit(
        gh<_i735.GetMonumentDetailUseCase>(),
        gh<_i735.GetComplexMembersUseCase>(),
      ),
    );
    gh.factory<_i1046.RegisterBloc>(
      () => _i1046.RegisterBloc(gh<_i743.RegisterUseCase>()),
    );
    gh.factory<_i729.MapDiscoveryBloc>(
      () => _i729.MapDiscoveryBloc(
        gh<_i735.GetMapExtentUseCase>(),
        gh<_i735.GetMonumentDetailUseCase>(),
        gh<_i735.SearchMonumentsUseCase>(),
      ),
    );
    gh.factory<_i580.ComplexMembersCubit>(
      () => _i580.ComplexMembersCubit(gh<_i735.GetComplexMembersUseCase>()),
    );
    gh.factory<_i418.SavedMonumentsListCubit>(
      () => _i418.SavedMonumentsListCubit(
        gh<_i114.GetSavedMonumentsUseCase>(),
        gh<_i735.GetMonumentPinsUseCase>(),
        gh<_i114.WatchSavedMonumentsUseCase>(),
      ),
    );
    gh.factory<_i362.RouteBuilderBloc>(
      () => _i362.RouteBuilderBloc(
        gh<_i735.GetMonumentPinsUseCase>(),
        gh<_i327.GetRouteUseCase>(),
        gh<_i327.SaveRouteUseCase>(),
        gh<_i617.OptimizeStopOrderUseCase>(),
        gh<_i327.PreviewRouteUseCase>(),
        gh<_i327.GetTravelMatrixUseCase>(),
      ),
    );
    gh.factoryParam<
      _i323.ResetPasswordBloc,
      _i906.VerificationChallenge?,
      dynamic
    >(
      (challenge, _) => _i323.ResetPasswordBloc(
        gh<_i743.ResetPasswordUseCase>(),
        gh<_i743.RequestPasswordResetUseCase>(),
        challenge,
      ),
    );
    gh.factory<_i235.DeleteAccountBloc>(
      () => _i235.DeleteAccountBloc(gh<_i743.DeleteAccountUseCase>()),
    );
    gh.lazySingleton<_i702.DigitalGuideRepository>(
      () => _i676.CatalogAwareDigitalGuideRepository(
        gh<_i189.DigitalGuideRepositoryImpl>(),
        gh<_i113.CatalogGuide>(),
      ),
    );
    gh.lazySingleton<_i601.AuthBloc>(
      () => _i601.AuthBloc(
        gh<_i743.RestoreSessionUseCase>(),
        gh<_i743.LogoutUseCase>(),
        gh<_i743.WatchAuthSessionUseCase>(),
      ),
    );
    gh.lazySingleton<_i149.SavedMonumentsCubit>(
      () => _i149.SavedMonumentsCubit(
        gh<_i114.GetSavedMonumentsUseCase>(),
        gh<_i114.SaveMonumentUseCase>(),
        gh<_i114.RemoveSavedMonumentUseCase>(),
        gh<_i114.WatchSavedMonumentsUseCase>(),
      ),
    );
    gh.factory<_i275.RouteExportCubit>(
      () => _i275.RouteExportCubit(
        gh<_i498.CreateRouteExportUseCase>(),
        gh<_i498.CreateRouteExportShareLinkUseCase>(),
      ),
    );
    gh.lazySingleton<_i532.AppRouter>(
      () => _i532.AppRouter(
        gh<_i601.AuthBloc>(),
        gh<_i208.OnboardingCubit>(),
        gh<_i634.AppConfig>(),
        gh<_i1053.HapticFeedbackService>(),
        gh<_i840.A11yAnnouncer>(),
        gh<_i362.RouteBuilderBloc>(instanceName: 'routeDraft'),
        gh<_i149.SavedMonumentsCubit>(),
        gh<_i548.GamificationCubit>(),
        gh<_i655.PackageInfo>(),
      ),
      dispose: (i) => i.dispose(),
    );
    gh.factory<_i199.MemoryListBloc>(
      () => _i199.MemoryListBloc(
        gh<_i592.GetMemoriesUseCase>(),
        gh<_i592.DeleteMemoryUseCase>(),
        gh<_i592.ReportMemoryUseCase>(),
        gh<_i592.WatchMemoryChangesUseCase>(),
      ),
    );
    gh.factory<_i686.RouteExportsCubit>(
      () => _i686.RouteExportsCubit(
        gh<_i498.GetRouteExportsUseCase>(),
        gh<_i498.OpenRouteExportUseCase>(),
        gh<_i498.CreateRouteExportShareLinkUseCase>(),
        gh<_i498.DeleteRouteExportUseCase>(),
        gh<_i498.WatchRouteExportChangesUseCase>(),
      ),
    );
    gh.lazySingleton<_i976.AskGuideUseCase>(
      () =>
          aiAssistantModule.askGuideUseCase(gh<_i702.DigitalGuideRepository>()),
    );
    gh.lazySingleton<_i976.EndGuideConversationUseCase>(
      () => aiAssistantModule.endGuideConversationUseCase(
        gh<_i702.DigitalGuideRepository>(),
      ),
    );
    gh.lazySingleton<_i789.FindNearbyAlertUseCase>(
      () => nearbyAlertsModule.findNearbyAlertUseCase(
        gh<_i635.NearbyMonumentsRepository>(),
        gh<_i635.NearbyAlertLogRepository>(),
        gh<_i927.NearbyAlertPolicy>(),
      ),
    );
    gh.factory<_i306.FeedbackFormCubit>(
      () => _i306.FeedbackFormCubit(gh<_i146.SubmitFeedbackUseCase>()),
    );
    gh.lazySingleton<_i414.NearbyAlertsCubit>(
      () => _i414.NearbyAlertsCubit(
        gh<_i963.LocationService>(),
        gh<_i279.LocalNotificationService>(),
        gh<_i789.FindNearbyAlertUseCase>(),
        gh<_i789.RecordNearbyAlertUseCase>(),
        gh<_i789.ClearNearbyAlertLogUseCase>(),
        gh<_i1016.AppLogger>(),
      ),
    );
    gh.lazySingleton<_i330.InAppCameraLauncher>(
      () => _i276.NavigatorCameraLauncher(gh<_i532.AppRouter>()),
    );
    gh.factory<_i471.DigitalGuideBloc>(
      () => _i471.DigitalGuideBloc(
        gh<_i976.AskGuideUseCase>(),
        gh<_i976.EndGuideConversationUseCase>(),
      ),
    );
    gh.lazySingleton<_i315.PhotoPickerService>(
      () => _i315.ImagePickerPhotoService(gh<_i330.InAppCameraLauncher>()),
    );
    gh.factory<_i835.PhotoAttacher>(
      () => _i835.PhotoAttacher(
        gh<_i315.PhotoPickerService>(),
        gh<_i299.PhotoProcessor>(),
        gh<_i636.PermissionService>(),
      ),
    );
    gh.factory<_i73.MemoryComposerBloc>(
      () => _i73.MemoryComposerBloc(
        gh<_i735.GetMonumentDetailUseCase>(),
        gh<_i592.CreateMemoryUseCase>(),
        gh<_i835.PhotoAttacher>(),
      ),
    );
    gh.factory<_i385.DamageReportWizardBloc>(
      () => _i385.DamageReportWizardBloc(
        gh<_i735.GetMonumentPinsUseCase>(),
        gh<_i61.SubmitDamageReportUseCase>(),
        gh<_i835.PhotoAttacher>(),
        gh<_i963.LocationService>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i407.RegisterModule {}

class _$NearbyAlertsModule extends _i426.NearbyAlertsModule {}

class _$RoutePlannerModule extends _i242.RoutePlannerModule {}

class _$SettingsModule extends _i220.SettingsModule {}

class _$MapModule extends _i736.MapModule {}

class _$NetworkModule extends _i1000.NetworkModule {}

class _$OnboardingModule extends _i588.OnboardingModule {}

class _$AuthModule extends _i621.AuthModule {}

class _$CatalogModule extends _i1043.CatalogModule {}

class _$AiAssistantModule extends _i640.AiAssistantModule {}

class _$CivilProtectionModule extends _i932.CivilProtectionModule {}

class _$SavedMonumentsModule extends _i752.SavedMonumentsModule {}

class _$GamificationModule extends _i457.GamificationModule {}

class _$MemoryCornerModule extends _i115.MemoryCornerModule {}

class _$FeedbackModule extends _i884.FeedbackModule {}

class _$RouteExportModule extends _i159.RouteExportModule {}
