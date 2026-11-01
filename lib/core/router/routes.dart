/// Tanımlı rotalar (TRD §5).
abstract final class AppRoutes {
  static const String splash = '/splash';

  /// İlk açılış tanıtımı (`?from=` ile ilk istenen hedef korunur).
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String verifyEmail = '/verify-email';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String mapDiscovery = '/';

  /// Tam ekran eser araması (sorgu `GoRouter.extra` ile geçer).
  static const String monumentSearch = '/search';
  static const String monumentDetail = '/monument/:id';

  /// Külliye detayı (eser detayından ayrı görünüm) ve tüm yapıları.
  static const String complexDetail = '/complex/:id';
  static const String complexMonuments = '/complex/:id/monuments';
  static const String routePlanner = '/route-planner';
  static const String routeBuilder = '/route-planner/new';
  static const String routeDetail = '/route-planner/:routeId';
  static const String routeEdit = '/route-planner/:routeId/edit';

  /// Eserin tüm anıları (herkese açık).
  static const String memoryCorner = '/monument/:id/memory-corner';

  /// Anı paylaşma (oturum gerekir).
  static const String memoryComposer = '/monument/:id/memory-corner/new';

  /// Sivil Koruma sekmesi (misafire tanıtım, oturum açıkken bildirimler).
  static const String civilProtection = '/civil-protection';

  /// Yeni hasar bildirimi (`?monument=<id>` ile eser seçili açılır).
  static const String damageReportNew = '/civil-protection/new';
  static const String damageReportDetail =
      '/civil-protection/reports/:reportId';
  static const String aiAssistant = '/ai-assistant';
  static const String profile = '/profile';
  static const String changePassword = '/profile/change-password';
  static const String deleteAccount = '/profile/delete-account';

  /// Rota PDF'leri (giriş gerekmez; sahibi hesap veya kurulum — ADR 33).
  static const String routeExports = '/exports';
  static const String achievements = '/profile/achievements';
  static const String myMemories = '/profile/memories';
  static const String settings = '/settings';

  /// Geri bildirim formu (Ayarlar → Hakkında; giriş gerekmez).
  static const String feedback = '/settings/feedback';
  static const String accessibility = '/accessibility';
  static const String savedMonuments = '/saved';
  static const String legalDocument = '/legal/:document';

  /// Giriş sonrası dönülecek hedefin taşındığı sorgu parametresi.
  static const String fromParameter = 'from';

  /// Şifre sıfırlama tamamlandığında giriş ekranında bilgi gösterilir.
  static const String passwordResetParameter = 'reset';

  /// Haritanın açılışta odaklanacağı eser (`/?monument=<id>`).
  static const String monumentParameter = 'monument';

  static String monumentDetailPath(String id) =>
      '/monument/${Uri.encodeComponent(id)}';

  static String complexDetailPath(String id) =>
      '/complex/${Uri.encodeComponent(id)}';

  static String complexMonumentsPath(String id) =>
      '${complexDetailPath(id)}/monuments';

  /// Haritayı [id] kimlikli eser seçili ve odaklanmış olarak açar.
  static String mapDiscoveryWithMonument(String id) => Uri(
    path: mapDiscovery,
    queryParameters: {monumentParameter: id},
  ).toString();

  static String routeDetailPath(String id) =>
      '$routePlanner/${Uri.encodeComponent(id)}';

  static String routeEditPath(String id) => '${routeDetailPath(id)}/edit';

  static String memoryCornerPath(String id) =>
      '${monumentDetailPath(id)}/memory-corner';

  static String memoryComposerPath(String id) => '${memoryCornerPath(id)}/new';

  /// Yeni bildirim; [monumentId] verilirse eser seçili açılır.
  static String damageReportNewPath({String? monumentId}) => Uri(
    path: damageReportNew,
    queryParameters: monumentId == null
        ? null
        : {monumentParameter: monumentId},
  ).toString();

  static String damageReportPath(String id) =>
      '$civilProtection/reports/${Uri.encodeComponent(id)}';

  /// [document]: `terms-of-use` veya `privacy-notice`.
  static String legalDocumentPath(String document) =>
      '/legal/${Uri.encodeComponent(document)}';

  static String loginAfterPasswordReset() => Uri(
    path: login,
    queryParameters: {passwordResetParameter: '1'},
  ).toString();

  /// Anıları okumak herkese açıktır; yalnızca paylaşma oturum gerektirir.
  static final RegExp _memoryComposer = RegExp(
    r'^/monument/[^/]+/memory-corner/new$',
  );

  /// Yalnızca oturum açmamış kullanıcılar içindir; oturum açık kullanıcı
  /// ana sayfaya (veya hafızadaki hedefe) yönlendirilir.
  static const Set<String> _guestOnly = {
    login,
    register,
    verifyEmail,
    forgotPassword,
    resetPassword,
  };

  static bool isGuestOnly(String path) => _guestOnly.contains(path);

  /// Tanıtım tamamlanmadan da açılabilen rotalar: tanıtımın kendisi ve
  /// tanıtımdan bağlantı verilen yasal metinler (KVKK aydınlatma).
  /// Tanıtım sırasında da açılabilen rotalar: yasal metinler (izin öncesi
  /// KVKK metni) ve Erişilebilirlik (önce erişilebilirlik — ADR 31).
  static bool isAvailableBeforeOnboarding(String path) =>
      path == onboarding || path == accessibility || path.startsWith('/legal/');

  /// `citizen` rolü gerektiren rotalar.
  static bool requiresAuthentication(String path) =>
      path.startsWith('$civilProtection/') ||
      path == profile ||
      path.startsWith('$profile/') ||
      _memoryComposer.hasMatch(path);
}

/// GoRouter rota adları.
abstract final class AppRouteNames {
  static const String splash = 'splash';
  static const String onboarding = 'onboarding';
  static const String login = 'login';
  static const String register = 'register';
  static const String verifyEmail = 'verify-email';
  static const String forgotPassword = 'forgot-password';
  static const String resetPassword = 'reset-password';
  static const String mapDiscovery = 'map-discovery';
  static const String monumentSearch = 'monument-search';
  static const String monumentDetail = 'monument-detail';
  static const String complexDetail = 'complex-detail';
  static const String complexMonuments = 'complex-monuments';
  static const String routePlanner = 'route-planner';
  static const String routeBuilder = 'route-builder';
  static const String routeDetail = 'route-detail';
  static const String routeEdit = 'route-edit';
  static const String memoryCorner = 'memory-corner';
  static const String memoryComposer = 'memory-composer';
  static const String civilProtection = 'civil-protection';
  static const String damageReportNew = 'damage-report-new';
  static const String damageReportDetail = 'damage-report-detail';
  static const String aiAssistant = 'ai-assistant';
  static const String profile = 'profile';
  static const String changePassword = 'change-password';
  static const String deleteAccount = 'delete-account';
  static const String routeExports = 'route-exports';
  static const String achievements = 'achievements';
  static const String myMemories = 'my-memories';
  static const String settings = 'settings';
  static const String feedback = 'feedback';
  static const String accessibility = 'accessibility';
  static const String savedMonuments = 'saved-monuments';
  static const String legalDocument = 'legal-document';
}
