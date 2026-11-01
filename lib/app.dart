import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/a11y/accessibility_layers.dart';
import 'package:vakif_atlas/core/a11y/accessibility_scope.dart';
import 'package:vakif_atlas/core/a11y/app_text_scaler.dart';
import 'package:vakif_atlas/core/a11y/haptic_feedback_service.dart';
import 'package:vakif_atlas/core/a11y/voice_io_service.dart';
import 'package:vakif_atlas/core/config/app_config.dart';
import 'package:vakif_atlas/core/config/app_environment.dart';
import 'package:vakif_atlas/core/di/injection.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/map/map_tile_source.dart';
import 'package:vakif_atlas/core/network/network_status.dart';
import 'package:vakif_atlas/core/router/app_router.dart';
import 'package:vakif_atlas/core/router/routes.dart';
import 'package:vakif_atlas/core/security/device_integrity.dart';
import 'package:vakif_atlas/core/security/device_integrity_service.dart';
import 'package:vakif_atlas/core/security/privacy_screen_guard.dart';
import 'package:vakif_atlas/core/sharing/document_share_service.dart';
import 'package:vakif_atlas/core/theme/app_theme.dart';
import 'package:vakif_atlas/core/theme/app_theme_options.dart';
import 'package:vakif_atlas/core/theme/extensions/app_color_scheme.dart';
import 'package:vakif_atlas/core/theme/color_blindness_filter.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vakif_atlas/features/gamification/presentation/cubit/gamification_cubit.dart';
import 'package:vakif_atlas/features/gamification/presentation/widgets/gamification_celebrations.dart';
import 'package:vakif_atlas/features/settings/domain/entities/accessibility_preferences.dart';
import 'package:vakif_atlas/features/settings/domain/entities/app_settings.dart';
import 'package:vakif_atlas/features/settings/presentation/app_settings_presentation.dart';
import 'package:vakif_atlas/features/settings/presentation/cubit/app_settings_cubit.dart';
import 'package:vakif_atlas/features/settings/presentation/cubit/app_settings_state.dart';
import 'package:vakif_atlas/shared/widgets/organisms/offline_banner.dart';
import 'package:vakif_atlas/shared/widgets/organisms/privacy_screen_overlay.dart';
import 'package:vakif_atlas/shared/widgets/templates/status_message_view.dart';

/// Tema varyantları (renk şeması × erişilebilirlik seçenekleri) bir kez
/// üretilir ve yeniden kullanılır.
abstract final class _Themes {
  static final Map<(AppColorScheme, AppThemeOptions), ThemeData> _cache = {};

  static ThemeData of(AppColorScheme colors, AppThemeOptions options) =>
      _cache.putIfAbsent((
        colors,
        options,
      ), () => AppTheme.fromColors(colors, options: options));
}

/// Erişilebilirlik panelinin temaya yansıyan tercihleri.
AppThemeOptions _themeOptions(AccessibilityPreferences a11y) => AppThemeOptions(
  legibleFont: a11y.legibleFont,
  wideTextSpacing: a11y.wideTextSpacing,
  lineHeight: a11y.lineHeight,
  creamBackground: a11y.creamBackground,
  highlightLinks: a11y.highlightLinks,
);

/// Vakıf Atlas kök widget'ı.
///
/// Global durum yöneticilerini ve erişilebilirlik servislerini ağaca
/// sağlar; tema, dil, metin ölçeği ve renk körlüğü filtresini kullanıcı
/// tercihlerine göre uygular.
class VakifAtlasApp extends StatelessWidget {
  const VakifAtlasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<A11yAnnouncer>.value(value: getIt<A11yAnnouncer>()),
        RepositoryProvider<HapticFeedbackService>.value(
          value: getIt<HapticFeedbackService>(),
        ),
        RepositoryProvider<VoiceIoService>.value(
          value: getIt<VoiceIoService>(),
        ),
        RepositoryProvider<MapTileSource>.value(value: getIt<MapTileSource>()),
        RepositoryProvider<NetworkStatus>.value(value: getIt<NetworkStatus>()),
        RepositoryProvider<DocumentShareService>.value(
          value: getIt<DocumentShareService>(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AppSettingsCubit>.value(
            value: getIt<AppSettingsCubit>(),
          ),
          BlocProvider<AuthBloc>.value(value: getIt<AuthBloc>()),
          BlocProvider<GamificationCubit>.value(
            value: getIt<GamificationCubit>(),
          ),
        ],
        child: _AppView(
          config: getIt<AppConfig>(),
          router: getIt<AppRouter>(),
          privacyGuard: getIt<PrivacyScreenGuard>(),
          integrity: getIt<DeviceIntegrityService>().report,
        ),
      ),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView({
    required this.config,
    required this.router,
    required this.privacyGuard,
    required this.integrity,
  });

  final AppConfig config;
  final AppRouter router;
  final PrivacyScreenGuard privacyGuard;
  final DeviceIntegrityReport integrity;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsCubit, AppSettingsState>(
      buildWhen: (previous, current) => previous.settings != current.settings,
      builder: (context, state) {
        final settings = state.settings;
        final a11y = settings.accessibility;
        final options = _themeOptions(a11y);
        final highContrast = a11y.highContrast;
        return MaterialApp.router(
          onGenerateTitle: (context) => context.l10n.appTitle,
          debugShowCheckedModeBanner: config.environment == AppEnvironment.dev,
          theme: _Themes.of(
            highContrast
                ? AppColorScheme.highContrastLight
                : AppColorScheme.light,
            options,
          ),
          darkTheme: _Themes.of(
            highContrast
                ? AppColorScheme.highContrastDark
                : AppColorScheme.dark,
            options,
          ),
          // İşletim sisteminin "kontrastı artır" ayarı da desteklenir.
          highContrastTheme: _Themes.of(
            AppColorScheme.highContrastLight,
            options,
          ),
          highContrastDarkTheme: _Themes.of(
            AppColorScheme.highContrastDark,
            options,
          ),
          // Kontrast "koyu" / "açık" seviyeleri tema tercihini geçersiz kılar.
          themeMode: switch (a11y.contrast) {
            ContrastMode.dark => ThemeMode.dark,
            ContrastMode.light => ThemeMode.light,
            _ => settings.themeMode,
          },
          locale: settings.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          routerConfig: router.router,
          builder: (context, child) => _AppShell(
            router: router,
            settings: settings,
            privacyGuard: privacyGuard,
            showIntegrityWarning: integrity.verdict == IntegrityVerdict.warn,
            child: child!,
          ),
        );
      },
    );
  }
}

/// Tüm rotaları saran erişilebilirlik ve güvenlik katmanları.
class _AppShell extends StatelessWidget {
  const _AppShell({
    required this.router,
    required this.settings,
    required this.privacyGuard,
    required this.showIntegrityWarning,
    required this.child,
  });

  final AppRouter router;
  final AppSettings settings;
  final PrivacyScreenGuard privacyGuard;
  final bool showIntegrityWarning;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final a11y = settings.accessibility;
    return MediaQuery(
      data: mediaQuery.copyWith(
        textScaler: AppTextScaler.resolve(
          mediaQuery.textScaler,
          a11y.textScaleFactor,
        ),
        // Uygulama içi tercih cihaz ayarına eklenir; `context.reduceMotion`
        // kullanan tüm bileşenler ikisini birlikte dikkate alır.
        disableAnimations: mediaQuery.disableAnimations || a11y.reduceMotion,
      ),
      child: AccessibilityScope(
        hideImages: a11y.hideImages,
        alignLeft: a11y.alignLeft,
        child: AccessibilityColorFilter(
          profile: a11y.colorBlindnessProfile,
          grayscale: a11y.grayscale,
          invert: a11y.invertColors,
          blueLightFilter: a11y.blueLightFilter,
          child: AccessibilityLayers(
            readAloud: a11y.readAloud,
            readOnFocus: a11y.readOnFocus,
            focusHighlight: a11y.focusHighlight,
            readingGuide: a11y.readingGuide,
            bigCursor: a11y.bigCursor,
            child: PrivacyScreenOverlay(
              isObscured: privacyGuard.isObscured,
              child: OfflineBanner(
                network: context.read<NetworkStatus>(),
                onAnnounce: (message, {required offline}) => unawaited(
                  context.read<A11yAnnouncer>().announce(
                    message,
                    assertive: offline,
                  ),
                ),
                child: _SessionNotifications(
                  showIntegrityWarning: showIntegrityWarning,
                  child: _GamificationSession(
                    child: GamificationCelebrations(
                      navigatorKey: router.navigatorKey,
                      onOpenAchievements: () =>
                          unawaited(router.router.push(AppRoutes.achievements)),
                      child: child,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Oturumun beklenmedik sona ermesini ve cihaz bütünlüğü uyarısını
/// erişilebilir biçimde (görsel + ekran okuyucu) bildirir.
class _SessionNotifications extends StatefulWidget {
  const _SessionNotifications({
    required this.showIntegrityWarning,
    required this.child,
  });

  final bool showIntegrityWarning;
  final Widget child;

  @override
  State<_SessionNotifications> createState() => _SessionNotificationsState();
}

class _SessionNotificationsState extends State<_SessionNotifications> {
  @override
  void initState() {
    super.initState();
    if (widget.showIntegrityWarning) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _showIntegrityWarning(),
      );
    }
  }

  void _showIntegrityWarning() {
    if (!mounted) {
      return;
    }
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    messenger.showMaterialBanner(
      MaterialBanner(
        leading: const Icon(Icons.gpp_maybe_outlined),
        content: Text(l10n.integrityWarningMessage),
        actions: [
          TextButton(
            onPressed: messenger.hideCurrentMaterialBanner,
            child: Text(l10n.integrityWarningDismiss),
          ),
        ],
      ),
    );
    unawaited(
      context.read<A11yAnnouncer>().announce(l10n.integrityWarningMessage),
    );
  }

  void _onAuthChanged(BuildContext context, AuthState state) {
    final l10n = context.l10n;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.sessionExpiredMessage)));
    unawaited(
      context.read<A11yAnnouncer>().announce(
        l10n.sessionExpiredMessage,
        assertive: true,
      ),
    );
    unawaited(context.read<HapticFeedbackService>().warning());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          current is AuthGuest && current.sessionExpired && previous != current,
      listener: _onAuthChanged,
      child: widget.child,
    );
  }
}

/// Oyunlaştırmayı oturuma bağlar: oturum açılınca profil yüklenir,
/// kapanınca temizlenir; dil değişince ve uygulamaya dönülünce yenilenir.
/// Oyunlaştırma kimlik doğrulamaya bağımlı olmasın diye köktedir.
class _GamificationSession extends StatefulWidget {
  const _GamificationSession({required this.child});

  final Widget child;

  @override
  State<_GamificationSession> createState() => _GamificationSessionState();
}

class _GamificationSessionState extends State<_GamificationSession> {
  late final AppLifecycleListener _lifecycle;
  String? _languageCode;

  GamificationCubit get _cubit => context.read<GamificationCubit>();

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onResume: () => unawaited(_cubit.refresh()),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageCode = Localizations.localeOf(context).languageCode;
    if (languageCode == _languageCode) {
      return;
    }
    final first = _languageCode == null;
    _languageCode = languageCode;
    if (first) {
      _sync(context.read<AuthBloc>().state);
    } else {
      unawaited(_cubit.setLanguage(languageCode));
    }
  }

  void _sync(AuthState auth) {
    switch (auth) {
      case AuthAuthenticated():
        unawaited(_cubit.start(languageCode: _languageCode!));
      case AuthGuest():
        _cubit.stop();
      case AuthUnknown():
        break;
    }
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType ||
          (previous is AuthAuthenticated &&
              current is AuthAuthenticated &&
              previous.user.id != current.user.id),
      listener: (context, auth) {
        if (auth is AuthAuthenticated) {
          // Hesap değiştiyse önceki kullanıcının profili gösterilmez.
          _cubit.stop();
        }
        _sync(auth);
      },
      child: widget.child,
    );
  }
}

/// Cihaz bütünlüğü engelleyici bir tehdit tespit ettiğinde çalıştırılan,
/// hiçbir veri veya ağ erişimi içermeyen uygulama.
class SecurityBlockedApp extends StatelessWidget {
  const SecurityBlockedApp({super.key});

  @override
  Widget build(BuildContext context) => _StartupMessageApp(
    icon: Icons.gpp_bad_outlined,
    title: (l10n) => l10n.integrityBlockedTitle,
    message: (l10n) => l10n.integrityBlockedBody,
  );
}

/// Açılış dizisi (konfigürasyon, DI, güvenlik denetimleri) başarısız olunca
/// gösterilir; aksi halde native açılış ekranında takılı kalınırdı.
class StartupFailedApp extends StatelessWidget {
  const StartupFailedApp({super.key});

  @override
  Widget build(BuildContext context) => _StartupMessageApp(
    icon: Icons.error_outline,
    title: (l10n) => l10n.startupFailedTitle,
    message: (l10n) => l10n.startupFailedBody,
  );
}

/// DI'dan bağımsız, tek mesajlı uygulama kabuğu.
class _StartupMessageApp extends StatelessWidget {
  const _StartupMessageApp({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String Function(AppLocalizations l10n) title;
  final String Function(AppLocalizations l10n) message;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => context.l10n.appTitle,
      debugShowCheckedModeBanner: false,
      theme: _Themes.of(AppColorScheme.light, AppThemeOptions.standard),
      darkTheme: _Themes.of(AppColorScheme.dark, AppThemeOptions.standard),
      highContrastTheme: _Themes.of(
        AppColorScheme.highContrastLight,
        AppThemeOptions.standard,
      ),
      highContrastDarkTheme: _Themes.of(
        AppColorScheme.highContrastDark,
        AppThemeOptions.standard,
      ),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: Builder(
        builder: (context) => Scaffold(
          body: StatusMessageView(
            tone: StatusMessageTone.error,
            icon: icon,
            title: title(context.l10n),
            message: message(context.l10n),
          ),
        ),
      ),
    );
  }
}
