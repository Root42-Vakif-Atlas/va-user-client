import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('tr'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In tr, this message translates to:
  /// **'Vakıf Atlas'**
  String get appTitle;

  /// No description provided for @appSlogan.
  ///
  /// In tr, this message translates to:
  /// **'Köklerden Geleceğe'**
  String get appSlogan;

  /// No description provided for @errorInvalidRequest.
  ///
  /// In tr, this message translates to:
  /// **'Gönderilen istek geçersiz. Lütfen girdiğiniz bilgileri kontrol edin.'**
  String get errorInvalidRequest;

  /// No description provided for @errorUnauthorized.
  ///
  /// In tr, this message translates to:
  /// **'Oturum süreniz doldu veya bu işlem için yetkiniz bulunmuyor.'**
  String get errorUnauthorized;

  /// No description provided for @errorNotFound.
  ///
  /// In tr, this message translates to:
  /// **'İstenen kaynak bulunamadı.'**
  String get errorNotFound;

  /// No description provided for @errorModerationRejected.
  ///
  /// In tr, this message translates to:
  /// **'Paylaşımınız topluluk kurallarına uygun bulunmadı.'**
  String get errorModerationRejected;

  /// No description provided for @errorServerUnavailable.
  ///
  /// In tr, this message translates to:
  /// **'Sunucu şu anda geçici olarak hizmet veremiyor. Lütfen birazdan tekrar deneyin.'**
  String get errorServerUnavailable;

  /// No description provided for @errorOffline.
  ///
  /// In tr, this message translates to:
  /// **'İnternet bağlantınız yok. Bağlantınızı kontrol edip tekrar deneyin.'**
  String get errorOffline;

  /// No description provided for @errorServerUnreachable.
  ///
  /// In tr, this message translates to:
  /// **'Vakıf Atlas sunucusuna şu anda ulaşılamıyor. İnternet bağlantınız çalışıyor; lütfen birazdan tekrar deneyin.'**
  String get errorServerUnreachable;

  /// No description provided for @offlineBannerMessage.
  ///
  /// In tr, this message translates to:
  /// **'Çevrimdışısınız. Cihazdaki veriler gösteriliyor; değişiklikler bağlantı gelince eşitlenecek.'**
  String get offlineBannerMessage;

  /// No description provided for @offlineAnnouncement.
  ///
  /// In tr, this message translates to:
  /// **'İnternet bağlantısı kesildi. Uygulama çevrimdışı modda çalışıyor.'**
  String get offlineAnnouncement;

  /// No description provided for @onlineAnnouncement.
  ///
  /// In tr, this message translates to:
  /// **'İnternet bağlantısı yeniden kuruldu.'**
  String get onlineAnnouncement;

  /// No description provided for @errorCacheRead.
  ///
  /// In tr, this message translates to:
  /// **'Yerel veri okunamadı, çevrimiçi kaynaklara başvuruluyor.'**
  String get errorCacheRead;

  /// No description provided for @errorSecurityViolation.
  ///
  /// In tr, this message translates to:
  /// **'Güvenli bağlantı veya cihaz bütünlüğü doğrulanamadı.'**
  String get errorSecurityViolation;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In tr, this message translates to:
  /// **'E-posta adresi veya şifre hatalı. Bilgilerinizi kontrol edip tekrar deneyin.'**
  String get errorInvalidCredentials;

  /// No description provided for @errorUnexpected.
  ///
  /// In tr, this message translates to:
  /// **'Beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.'**
  String get errorUnexpected;

  /// No description provided for @commonRetry.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar dene'**
  String get commonRetry;

  /// No description provided for @commonUndo.
  ///
  /// In tr, this message translates to:
  /// **'Geri al'**
  String get commonUndo;

  /// No description provided for @commonCancel.
  ///
  /// In tr, this message translates to:
  /// **'Vazgeç'**
  String get commonCancel;

  /// No description provided for @commonClose.
  ///
  /// In tr, this message translates to:
  /// **'Kapat'**
  String get commonClose;

  /// No description provided for @commonLoading.
  ///
  /// In tr, this message translates to:
  /// **'Yükleniyor'**
  String get commonLoading;

  /// No description provided for @buttonLoadingSemantics.
  ///
  /// In tr, this message translates to:
  /// **'{label}, işlem sürüyor'**
  String buttonLoadingSemantics(String label);

  /// No description provided for @badgeOverflow.
  ///
  /// In tr, this message translates to:
  /// **'{max}+'**
  String badgeOverflow(int max);

  /// No description provided for @notificationCountSemantics.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =0{Yeni bildirim yok} other{{count} yeni bildirim}}'**
  String notificationCountSemantics(int count);

  /// No description provided for @navMap.
  ///
  /// In tr, this message translates to:
  /// **'Harita'**
  String get navMap;

  /// No description provided for @navRoutePlanner.
  ///
  /// In tr, this message translates to:
  /// **'Rotalar'**
  String get navRoutePlanner;

  /// No description provided for @navAiAssistant.
  ///
  /// In tr, this message translates to:
  /// **'Rehber'**
  String get navAiAssistant;

  /// No description provided for @navProfile.
  ///
  /// In tr, this message translates to:
  /// **'Profil'**
  String get navProfile;

  /// No description provided for @navSettings.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get navSettings;

  /// No description provided for @navigationSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Ana gezinme'**
  String get navigationSemantics;

  /// No description provided for @mapDiscoveryTitle.
  ///
  /// In tr, this message translates to:
  /// **'Keşfet'**
  String get mapDiscoveryTitle;

  /// No description provided for @monumentDetailTitle.
  ///
  /// In tr, this message translates to:
  /// **'Eser Detayı'**
  String get monumentDetailTitle;

  /// No description provided for @routePlannerTitle.
  ///
  /// In tr, this message translates to:
  /// **'Rota Planlayıcı'**
  String get routePlannerTitle;

  /// No description provided for @memoryCornerTitle.
  ///
  /// In tr, this message translates to:
  /// **'Anı Köşesi'**
  String get memoryCornerTitle;

  /// No description provided for @civilProtectionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sivil Koruma'**
  String get civilProtectionTitle;

  /// No description provided for @aiAssistantTitle.
  ///
  /// In tr, this message translates to:
  /// **'Dijital Rehber'**
  String get aiAssistantTitle;

  /// No description provided for @profileTitle.
  ///
  /// In tr, this message translates to:
  /// **'Profilim'**
  String get profileTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get settingsTitle;

  /// No description provided for @loginTitle.
  ///
  /// In tr, this message translates to:
  /// **'Giriş Yap'**
  String get loginTitle;

  /// No description provided for @featurePendingHeading.
  ///
  /// In tr, this message translates to:
  /// **'Bu bölüm hazırlanıyor'**
  String get featurePendingHeading;

  /// No description provided for @featurePendingBody.
  ///
  /// In tr, this message translates to:
  /// **'{feature} bir sonraki sürümde kullanıma açılacak.'**
  String featurePendingBody(String feature);

  /// No description provided for @notFoundTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sayfa bulunamadı'**
  String get notFoundTitle;

  /// No description provided for @notFoundBody.
  ///
  /// In tr, this message translates to:
  /// **'Aradığınız sayfa mevcut değil veya taşınmış olabilir.'**
  String get notFoundBody;

  /// No description provided for @notFoundAction.
  ///
  /// In tr, this message translates to:
  /// **'Ana sayfaya dön'**
  String get notFoundAction;

  /// No description provided for @splashLoadingSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Vakıf Atlas açılıyor'**
  String get splashLoadingSemantics;

  /// No description provided for @loginHeading.
  ///
  /// In tr, this message translates to:
  /// **'Hoş geldiniz'**
  String get loginHeading;

  /// No description provided for @loginSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Anı paylaşmak, Sivil Koruma bildirimi yapmak ve rozet kazanmak için giriş yapın.'**
  String get loginSubtitle;

  /// No description provided for @loginRequiredNotice.
  ///
  /// In tr, this message translates to:
  /// **'Bu bölümü kullanmak için giriş yapmanız gerekiyor.'**
  String get loginRequiredNotice;

  /// No description provided for @loginEmailLabel.
  ///
  /// In tr, this message translates to:
  /// **'E-posta'**
  String get loginEmailLabel;

  /// No description provided for @loginEmailHint.
  ///
  /// In tr, this message translates to:
  /// **'ad@eposta.com'**
  String get loginEmailHint;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In tr, this message translates to:
  /// **'Şifre'**
  String get loginPasswordLabel;

  /// No description provided for @passwordShow.
  ///
  /// In tr, this message translates to:
  /// **'Şifreyi göster'**
  String get passwordShow;

  /// No description provided for @passwordHide.
  ///
  /// In tr, this message translates to:
  /// **'Şifreyi gizle'**
  String get passwordHide;

  /// No description provided for @loginSubmit.
  ///
  /// In tr, this message translates to:
  /// **'Giriş yap'**
  String get loginSubmit;

  /// No description provided for @loginContinueAsGuest.
  ///
  /// In tr, this message translates to:
  /// **'Misafir olarak devam et'**
  String get loginContinueAsGuest;

  /// No description provided for @loginSuccessAnnouncement.
  ///
  /// In tr, this message translates to:
  /// **'Giriş yapıldı. Hoş geldiniz, {name}.'**
  String loginSuccessAnnouncement(String name);

  /// No description provided for @loginFormInvalidAnnouncement.
  ///
  /// In tr, this message translates to:
  /// **'Formda düzeltilmesi gereken alanlar var.'**
  String get loginFormInvalidAnnouncement;

  /// No description provided for @validationEmailEmpty.
  ///
  /// In tr, this message translates to:
  /// **'E-posta adresinizi girin.'**
  String get validationEmailEmpty;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In tr, this message translates to:
  /// **'Geçerli bir e-posta adresi girin. Örnek: ad@eposta.com'**
  String get validationEmailInvalid;

  /// No description provided for @validationPasswordEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Şifrenizi girin.'**
  String get validationPasswordEmpty;

  /// No description provided for @validationPasswordTooShort.
  ///
  /// In tr, this message translates to:
  /// **'Şifre en az {min} karakter olmalıdır.'**
  String validationPasswordTooShort(int min);

  /// No description provided for @profileEmailValue.
  ///
  /// In tr, this message translates to:
  /// **'E-posta: {email}'**
  String profileEmailValue(String email);

  /// No description provided for @gamificationSectionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Seviye ve rozetler'**
  String get gamificationSectionTitle;

  /// No description provided for @gamificationLevelTitle.
  ///
  /// In tr, this message translates to:
  /// **'Seviye {level} · {title}'**
  String gamificationLevelTitle(int level, String title);

  /// No description provided for @gamificationXpProgress.
  ///
  /// In tr, this message translates to:
  /// **'{xp} / {next} XP'**
  String gamificationXpProgress(int xp, int next);

  /// No description provided for @gamificationXpTotal.
  ///
  /// In tr, this message translates to:
  /// **'{xp} XP'**
  String gamificationXpTotal(int xp);

  /// No description provided for @gamificationXpToNext.
  ///
  /// In tr, this message translates to:
  /// **'Sonraki seviyeye {xp} XP kaldı.'**
  String gamificationXpToNext(int xp);

  /// No description provided for @gamificationMaxLevel.
  ///
  /// In tr, this message translates to:
  /// **'En yüksek seviyedesiniz.'**
  String get gamificationMaxLevel;

  /// No description provided for @gamificationProgressSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Seviye ilerlemesi'**
  String get gamificationProgressSemantics;

  /// No description provided for @gamificationRecentBadges.
  ///
  /// In tr, this message translates to:
  /// **'Son kazanılan rozetler'**
  String get gamificationRecentBadges;

  /// No description provided for @gamificationNoBadges.
  ///
  /// In tr, this message translates to:
  /// **'Henüz rozetiniz yok. Rota oluşturarak, anı paylaşarak veya hasar bildirerek kazanmaya başlayın.'**
  String get gamificationNoBadges;

  /// No description provided for @gamificationAllBadges.
  ///
  /// In tr, this message translates to:
  /// **'Tüm rozetler ({unlocked}/{total})'**
  String gamificationAllBadges(int unlocked, int total);

  /// No description provided for @gamificationLoading.
  ///
  /// In tr, this message translates to:
  /// **'Seviye bilgisi yükleniyor'**
  String get gamificationLoading;

  /// No description provided for @gamificationLoadFailed.
  ///
  /// In tr, this message translates to:
  /// **'Seviye bilgisi yüklenemedi.'**
  String get gamificationLoadFailed;

  /// No description provided for @gamificationAchievementsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Rozetler'**
  String get gamificationAchievementsTitle;

  /// No description provided for @gamificationAchievementsSummary.
  ///
  /// In tr, this message translates to:
  /// **'{total} rozetten {unlocked} tanesini kazandınız.'**
  String gamificationAchievementsSummary(int unlocked, int total);

  /// No description provided for @gamificationEarnedSection.
  ///
  /// In tr, this message translates to:
  /// **'Kazanılanlar'**
  String get gamificationEarnedSection;

  /// No description provided for @gamificationLockedSection.
  ///
  /// In tr, this message translates to:
  /// **'Kazanılacaklar'**
  String get gamificationLockedSection;

  /// No description provided for @gamificationUnlockedOn.
  ///
  /// In tr, this message translates to:
  /// **'Kazanıldı: {date}'**
  String gamificationUnlockedOn(String date);

  /// No description provided for @gamificationLockedProgress.
  ///
  /// In tr, this message translates to:
  /// **'Kilitli · {progress}/{target}'**
  String gamificationLockedProgress(int progress, int target);

  /// No description provided for @gamificationHowToTitle.
  ///
  /// In tr, this message translates to:
  /// **'Nasıl XP kazanılır?'**
  String get gamificationHowToTitle;

  /// No description provided for @gamificationHowToRoute.
  ///
  /// In tr, this message translates to:
  /// **'Rota oluşturma: 50 XP (günde en çok 3 rota)'**
  String get gamificationHowToRoute;

  /// No description provided for @gamificationHowToMemory.
  ///
  /// In tr, this message translates to:
  /// **'Anı paylaşma: 30 XP (günde en çok 5 anı)'**
  String get gamificationHowToMemory;

  /// No description provided for @gamificationHowToReport.
  ///
  /// In tr, this message translates to:
  /// **'Hasar bildirimi: 40 XP (günde en çok 3 bildirim)'**
  String get gamificationHowToReport;

  /// No description provided for @gamificationHowToCity.
  ///
  /// In tr, this message translates to:
  /// **'Bir ildeki esere ilk katkınız: 20 XP'**
  String get gamificationHowToCity;

  /// No description provided for @gamificationHowToNote.
  ///
  /// In tr, this message translates to:
  /// **'XP, hesabınızla yaptığınız katkılar için verilir; misafir olarak oluşturulan rotalar sayılmaz.'**
  String get gamificationHowToNote;

  /// No description provided for @gamificationCelebrationTitle.
  ///
  /// In tr, this message translates to:
  /// **'Tebrikler!'**
  String get gamificationCelebrationTitle;

  /// No description provided for @gamificationLevelReached.
  ///
  /// In tr, this message translates to:
  /// **'Yeni seviye: {level} · {title}'**
  String gamificationLevelReached(int level, String title);

  /// No description provided for @gamificationBadgeEarned.
  ///
  /// In tr, this message translates to:
  /// **'Yeni rozet: {title}'**
  String gamificationBadgeEarned(String title);

  /// No description provided for @gamificationCelebrationViewBadges.
  ///
  /// In tr, this message translates to:
  /// **'Rozetleri gör'**
  String get gamificationCelebrationViewBadges;

  /// No description provided for @gamificationCelebrationClose.
  ///
  /// In tr, this message translates to:
  /// **'Harika'**
  String get gamificationCelebrationClose;

  /// No description provided for @profileLogout.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış yap'**
  String get profileLogout;

  /// No description provided for @profileLogoutConfirmTitle.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış yapılsın mı?'**
  String get profileLogoutConfirmTitle;

  /// No description provided for @profileLogoutConfirmBody.
  ///
  /// In tr, this message translates to:
  /// **'Anı paylaşmak ve bildirim göndermek için yeniden giriş yapmanız gerekecek.'**
  String get profileLogoutConfirmBody;

  /// No description provided for @logoutAnnouncement.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış yapıldı.'**
  String get logoutAnnouncement;

  /// No description provided for @sessionExpiredMessage.
  ///
  /// In tr, this message translates to:
  /// **'Oturumunuzun süresi doldu. Lütfen tekrar giriş yapın.'**
  String get sessionExpiredMessage;

  /// No description provided for @settingsAppearanceSection.
  ///
  /// In tr, this message translates to:
  /// **'Görünüm'**
  String get settingsAppearanceSection;

  /// No description provided for @settingsThemeLabel.
  ///
  /// In tr, this message translates to:
  /// **'Tema'**
  String get settingsThemeLabel;

  /// No description provided for @themeSystem.
  ///
  /// In tr, this message translates to:
  /// **'Cihaz ayarı'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In tr, this message translates to:
  /// **'Açık'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In tr, this message translates to:
  /// **'Koyu'**
  String get themeDark;

  /// No description provided for @settingsLanguageSection.
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get settingsLanguageSection;

  /// No description provided for @settingsLanguageLabel.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama dili'**
  String get settingsLanguageLabel;

  /// No description provided for @languageSystem.
  ///
  /// In tr, this message translates to:
  /// **'Cihaz dili'**
  String get languageSystem;

  /// No description provided for @languageTurkish.
  ///
  /// In tr, this message translates to:
  /// **'Türkçe'**
  String get languageTurkish;

  /// No description provided for @languageEnglish.
  ///
  /// In tr, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @settingsAccessibilitySection.
  ///
  /// In tr, this message translates to:
  /// **'Erişilebilirlik'**
  String get settingsAccessibilitySection;

  /// No description provided for @colorBlindnessProtanopia.
  ///
  /// In tr, this message translates to:
  /// **'Protanopi (kırmızı)'**
  String get colorBlindnessProtanopia;

  /// No description provided for @colorBlindnessDeuteranopia.
  ///
  /// In tr, this message translates to:
  /// **'Deuteranopi (yeşil)'**
  String get colorBlindnessDeuteranopia;

  /// No description provided for @colorBlindnessTritanopia.
  ///
  /// In tr, this message translates to:
  /// **'Tritanopi (mavi)'**
  String get colorBlindnessTritanopia;

  /// No description provided for @settingsTextScaleValue.
  ///
  /// In tr, this message translates to:
  /// **'%{percent}'**
  String settingsTextScaleValue(int percent);

  /// No description provided for @settingsSaveFailed.
  ///
  /// In tr, this message translates to:
  /// **'Ayar bu cihaza kaydedilemedi. Uygulama yeniden açıldığında önceki değer kullanılacak.'**
  String get settingsSaveFailed;

  /// No description provided for @settingsLicenses.
  ///
  /// In tr, this message translates to:
  /// **'Açık kaynak lisansları'**
  String get settingsLicenses;

  /// No description provided for @settingsFeedback.
  ///
  /// In tr, this message translates to:
  /// **'Geri bildirim gönder'**
  String get settingsFeedback;

  /// No description provided for @settingsFeedbackSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Deneyiminizi puanlayın, öneri veya sorun iletin'**
  String get settingsFeedbackSubtitle;

  /// No description provided for @aboutVersion.
  ///
  /// In tr, this message translates to:
  /// **'Sürüm {version}'**
  String aboutVersion(String version);

  /// No description provided for @aboutMission.
  ///
  /// In tr, this message translates to:
  /// **'Vakıflar Genel Müdürlüğü\'nün koruduğu vakıf eserlerini keşfetmenin, gezmenin ve birlikte korumanın erişilebilir yolu.'**
  String get aboutMission;

  /// No description provided for @aboutDeveloper.
  ///
  /// In tr, this message translates to:
  /// **'Vakıflar Genel Müdürlüğü için Root42 tarafından geliştirildi.'**
  String get aboutDeveloper;

  /// No description provided for @feedbackTitle.
  ///
  /// In tr, this message translates to:
  /// **'Geri bildirim'**
  String get feedbackTitle;

  /// No description provided for @feedbackRatingLabel.
  ///
  /// In tr, this message translates to:
  /// **'Vakıf Atlas deneyiminizi nasıl değerlendirirsiniz?'**
  String get feedbackRatingLabel;

  /// No description provided for @feedbackRatingOptional.
  ///
  /// In tr, this message translates to:
  /// **'Puan vermek isteğe bağlıdır.'**
  String get feedbackRatingOptional;

  /// No description provided for @feedbackRateStars.
  ///
  /// In tr, this message translates to:
  /// **'{count} yıldız'**
  String feedbackRateStars(int count);

  /// No description provided for @feedbackRatingValue.
  ///
  /// In tr, this message translates to:
  /// **'{value} / 5 · {name}'**
  String feedbackRatingValue(int value, String name);

  /// No description provided for @feedbackRating1.
  ///
  /// In tr, this message translates to:
  /// **'Çok kötü'**
  String get feedbackRating1;

  /// No description provided for @feedbackRating2.
  ///
  /// In tr, this message translates to:
  /// **'Kötü'**
  String get feedbackRating2;

  /// No description provided for @feedbackRating3.
  ///
  /// In tr, this message translates to:
  /// **'Orta'**
  String get feedbackRating3;

  /// No description provided for @feedbackRating4.
  ///
  /// In tr, this message translates to:
  /// **'İyi'**
  String get feedbackRating4;

  /// No description provided for @feedbackRating5.
  ///
  /// In tr, this message translates to:
  /// **'Çok iyi'**
  String get feedbackRating5;

  /// No description provided for @feedbackCategoryLabel.
  ///
  /// In tr, this message translates to:
  /// **'Konu'**
  String get feedbackCategoryLabel;

  /// No description provided for @feedbackCategorySuggestion.
  ///
  /// In tr, this message translates to:
  /// **'Öneri'**
  String get feedbackCategorySuggestion;

  /// No description provided for @feedbackCategoryBug.
  ///
  /// In tr, this message translates to:
  /// **'Hata'**
  String get feedbackCategoryBug;

  /// No description provided for @feedbackCategoryAccessibility.
  ///
  /// In tr, this message translates to:
  /// **'Erişilebilirlik'**
  String get feedbackCategoryAccessibility;

  /// No description provided for @feedbackCategoryContent.
  ///
  /// In tr, this message translates to:
  /// **'Eser bilgisi'**
  String get feedbackCategoryContent;

  /// No description provided for @feedbackCategoryOther.
  ///
  /// In tr, this message translates to:
  /// **'Diğer'**
  String get feedbackCategoryOther;

  /// No description provided for @feedbackMessageLabel.
  ///
  /// In tr, this message translates to:
  /// **'Mesajınız'**
  String get feedbackMessageLabel;

  /// No description provided for @feedbackMessageHint.
  ///
  /// In tr, this message translates to:
  /// **'Neyi beğendiniz, neyi geliştirebiliriz?'**
  String get feedbackMessageHint;

  /// No description provided for @feedbackMessageHelper.
  ///
  /// In tr, this message translates to:
  /// **'Kişisel bilgi paylaşmayın. Uygulama sürümü ve cihaz türü (ör. Android) eklenir.'**
  String get feedbackMessageHelper;

  /// No description provided for @feedbackSubmit.
  ///
  /// In tr, this message translates to:
  /// **'Gönder'**
  String get feedbackSubmit;

  /// No description provided for @feedbackRequired.
  ///
  /// In tr, this message translates to:
  /// **'Bir puan verin veya mesaj yazın.'**
  String get feedbackRequired;

  /// No description provided for @feedbackTooLong.
  ///
  /// In tr, this message translates to:
  /// **'Mesaj en fazla {max} karakter olabilir.'**
  String feedbackTooLong(int max);

  /// No description provided for @feedbackSent.
  ///
  /// In tr, this message translates to:
  /// **'Teşekkürler! Geri bildiriminiz alındı.'**
  String get feedbackSent;

  /// No description provided for @privacyOverlaySemantics.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama içeriği gizlendi'**
  String get privacyOverlaySemantics;

  /// No description provided for @integrityWarningMessage.
  ///
  /// In tr, this message translates to:
  /// **'Cihazınızda güvenlik değişiklikleri (root veya jailbreak) tespit edildi. Hesabınızın güvenliği için bazı işlemler kısıtlanabilir.'**
  String get integrityWarningMessage;

  /// No description provided for @integrityWarningDismiss.
  ///
  /// In tr, this message translates to:
  /// **'Anladım'**
  String get integrityWarningDismiss;

  /// No description provided for @integrityBlockedTitle.
  ///
  /// In tr, this message translates to:
  /// **'Güvenli çalışma ortamı doğrulanamadı'**
  String get integrityBlockedTitle;

  /// No description provided for @integrityBlockedBody.
  ///
  /// In tr, this message translates to:
  /// **'Uygulamanın değiştirilmiş bir sürümü veya izinsiz bir müdahale tespit edildi. Lütfen Vakıf Atlas\'ı resmi uygulama mağazasından yeniden yükleyin.'**
  String get integrityBlockedBody;

  /// No description provided for @startupFailedTitle.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama başlatılamadı'**
  String get startupFailedTitle;

  /// No description provided for @startupFailedBody.
  ///
  /// In tr, this message translates to:
  /// **'Vakıf Atlas açılırken beklenmeyen bir sorun oluştu. Uygulamayı kapatıp yeniden açın; sorun sürerse uygulamayı güncelleyin.'**
  String get startupFailedBody;

  /// No description provided for @errorEmailNotVerified.
  ///
  /// In tr, this message translates to:
  /// **'E-posta adresiniz henüz doğrulanmadı. Size gönderdiğimiz kodu girin.'**
  String get errorEmailNotVerified;

  /// No description provided for @errorInvalidVerificationCode.
  ///
  /// In tr, this message translates to:
  /// **'Kod hatalı. E-postanızdaki 6 haneli kodu kontrol edip tekrar deneyin.'**
  String get errorInvalidVerificationCode;

  /// No description provided for @errorVerificationCodeExpired.
  ///
  /// In tr, this message translates to:
  /// **'Kodun süresi doldu veya çok fazla hatalı deneme yapıldı. Yeni bir kod isteyin.'**
  String get errorVerificationCodeExpired;

  /// No description provided for @errorWeakPassword.
  ///
  /// In tr, this message translates to:
  /// **'Bu şifre güvenlik kurallarını karşılamıyor. Daha uzun ve tahmin edilmesi zor bir şifre seçin.'**
  String get errorWeakPassword;

  /// No description provided for @errorInvalidCurrentPassword.
  ///
  /// In tr, this message translates to:
  /// **'Mevcut şifreniz hatalı.'**
  String get errorInvalidCurrentPassword;

  /// No description provided for @errorTooManyRequests.
  ///
  /// In tr, this message translates to:
  /// **'Çok fazla deneme yapıldı. Lütfen biraz sonra tekrar deneyin.'**
  String get errorTooManyRequests;

  /// No description provided for @errorTooManyRequestsRetry.
  ///
  /// In tr, this message translates to:
  /// **'{minutes, plural, =1{Çok fazla deneme yapıldı. 1 dakika sonra tekrar deneyin.} other{Çok fazla deneme yapıldı. {minutes} dakika sonra tekrar deneyin.}}'**
  String errorTooManyRequestsRetry(int minutes);

  /// No description provided for @validationNameEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Adınızı ve soyadınızı girin.'**
  String get validationNameEmpty;

  /// No description provided for @validationNameTooShort.
  ///
  /// In tr, this message translates to:
  /// **'Ad soyad en az {min} karakter olmalıdır.'**
  String validationNameTooShort(int min);

  /// No description provided for @validationNameTooLong.
  ///
  /// In tr, this message translates to:
  /// **'Ad soyad en fazla {max} karakter olabilir.'**
  String validationNameTooLong(int max);

  /// No description provided for @validationNameInvalid.
  ///
  /// In tr, this message translates to:
  /// **'Ad soyad yalnızca harf, boşluk, kesme işareti ve tire içerebilir.'**
  String get validationNameInvalid;

  /// No description provided for @validationPasswordTooLong.
  ///
  /// In tr, this message translates to:
  /// **'Şifre en fazla {max} karakter olabilir.'**
  String validationPasswordTooLong(int max);

  /// No description provided for @validationPasswordCommon.
  ///
  /// In tr, this message translates to:
  /// **'Bu şifre çok yaygın ve kolay tahmin edilir. Farklı bir şifre seçin.'**
  String get validationPasswordCommon;

  /// No description provided for @validationPasswordPersonalInfo.
  ///
  /// In tr, this message translates to:
  /// **'Şifre adınızı, e-posta adresinizi veya uygulama adını içermemelidir.'**
  String get validationPasswordPersonalInfo;

  /// No description provided for @validationPasswordRepetitive.
  ///
  /// In tr, this message translates to:
  /// **'Şifre tekrar eden veya ardışık karakterlerden oluşmamalıdır.'**
  String get validationPasswordRepetitive;

  /// No description provided for @validationConfirmPasswordEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Şifrenizi tekrar girin.'**
  String get validationConfirmPasswordEmpty;

  /// No description provided for @validationPasswordMismatch.
  ///
  /// In tr, this message translates to:
  /// **'Şifreler eşleşmiyor. İki alana da aynı şifreyi girin.'**
  String get validationPasswordMismatch;

  /// No description provided for @validationSamePassword.
  ///
  /// In tr, this message translates to:
  /// **'Yeni şifre mevcut şifrenizden farklı olmalıdır.'**
  String get validationSamePassword;

  /// No description provided for @validationCurrentPasswordEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Mevcut şifrenizi girin.'**
  String get validationCurrentPasswordEmpty;

  /// No description provided for @validationCodeEmpty.
  ///
  /// In tr, this message translates to:
  /// **'E-postanıza gelen kodu girin.'**
  String get validationCodeEmpty;

  /// No description provided for @validationCodeInvalid.
  ///
  /// In tr, this message translates to:
  /// **'Kod {length} haneli bir sayı olmalıdır.'**
  String validationCodeInvalid(int length);

  /// No description provided for @validationTermsRequired.
  ///
  /// In tr, this message translates to:
  /// **'Devam etmek için Kullanım Koşulları\'nı kabul etmelisiniz.'**
  String get validationTermsRequired;

  /// No description provided for @validationPrivacyRequired.
  ///
  /// In tr, this message translates to:
  /// **'Devam etmek için KVKK Aydınlatma Metni\'ni okuduğunuzu onaylamalısınız.'**
  String get validationPrivacyRequired;

  /// No description provided for @validationDeleteConfirmRequired.
  ///
  /// In tr, this message translates to:
  /// **'Devam etmek için onay kutusunu işaretleyin.'**
  String get validationDeleteConfirmRequired;

  /// No description provided for @passwordRequirementsHint.
  ///
  /// In tr, this message translates to:
  /// **'En az {min} karakter. Kolay tahmin edilen ifadelerden ve kişisel bilgilerden kaçının.'**
  String passwordRequirementsHint(int min);

  /// No description provided for @passwordStrengthWeak.
  ///
  /// In tr, this message translates to:
  /// **'Zayıf'**
  String get passwordStrengthWeak;

  /// No description provided for @passwordStrengthFair.
  ///
  /// In tr, this message translates to:
  /// **'Orta'**
  String get passwordStrengthFair;

  /// No description provided for @passwordStrengthGood.
  ///
  /// In tr, this message translates to:
  /// **'İyi'**
  String get passwordStrengthGood;

  /// No description provided for @passwordStrengthStrong.
  ///
  /// In tr, this message translates to:
  /// **'Güçlü'**
  String get passwordStrengthStrong;

  /// No description provided for @passwordStrengthSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Şifre gücü: {level}'**
  String passwordStrengthSemantics(String level);

  /// No description provided for @loginForgotPassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifremi unuttum'**
  String get loginForgotPassword;

  /// No description provided for @loginNoAccount.
  ///
  /// In tr, this message translates to:
  /// **'Hesabınız yok mu?'**
  String get loginNoAccount;

  /// No description provided for @loginCreateAccount.
  ///
  /// In tr, this message translates to:
  /// **'Hesap oluştur'**
  String get loginCreateAccount;

  /// No description provided for @loginPasswordResetSuccess.
  ///
  /// In tr, this message translates to:
  /// **'Şifreniz güncellendi ve tüm oturumlar kapatıldı. Yeni şifrenizle giriş yapın.'**
  String get loginPasswordResetSuccess;

  /// No description provided for @registerTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hesap Oluştur'**
  String get registerTitle;

  /// No description provided for @registerHeading.
  ///
  /// In tr, this message translates to:
  /// **'Vakıf Atlas\'a katılın'**
  String get registerHeading;

  /// No description provided for @registerSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Anılarınızı paylaşmak ve kültürel mirasın korunmasına katkı sağlamak için ücretsiz hesap oluşturun.'**
  String get registerSubtitle;

  /// No description provided for @registerNameLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ad soyad'**
  String get registerNameLabel;

  /// No description provided for @registerConfirmPasswordLabel.
  ///
  /// In tr, this message translates to:
  /// **'Şifre (tekrar)'**
  String get registerConfirmPasswordLabel;

  /// No description provided for @registerAcceptTerms.
  ///
  /// In tr, this message translates to:
  /// **'Kullanım Koşulları\'nı okudum ve kabul ediyorum.'**
  String get registerAcceptTerms;

  /// No description provided for @registerAcknowledgePrivacy.
  ///
  /// In tr, this message translates to:
  /// **'KVKK Aydınlatma Metni\'ni okudum.'**
  String get registerAcknowledgePrivacy;

  /// No description provided for @registerReadTerms.
  ///
  /// In tr, this message translates to:
  /// **'Kullanım Koşulları\'nı oku'**
  String get registerReadTerms;

  /// No description provided for @registerReadPrivacy.
  ///
  /// In tr, this message translates to:
  /// **'Aydınlatma Metni\'ni oku'**
  String get registerReadPrivacy;

  /// No description provided for @registerSubmit.
  ///
  /// In tr, this message translates to:
  /// **'Hesap oluştur'**
  String get registerSubmit;

  /// No description provided for @registerHaveAccount.
  ///
  /// In tr, this message translates to:
  /// **'Zaten hesabınız var mı? Giriş yapın'**
  String get registerHaveAccount;

  /// No description provided for @verifyEmailTitle.
  ///
  /// In tr, this message translates to:
  /// **'E-posta Doğrulama'**
  String get verifyEmailTitle;

  /// No description provided for @verifyEmailHeading.
  ///
  /// In tr, this message translates to:
  /// **'E-postanızı doğrulayın'**
  String get verifyEmailHeading;

  /// No description provided for @verifyEmailBody.
  ///
  /// In tr, this message translates to:
  /// **'{email} adresine 6 haneli bir doğrulama kodu gönderdik. Kod 10 dakika geçerlidir.'**
  String verifyEmailBody(String email);

  /// No description provided for @verificationCodeLabel.
  ///
  /// In tr, this message translates to:
  /// **'Doğrulama kodu'**
  String get verificationCodeLabel;

  /// No description provided for @verificationCodeHint.
  ///
  /// In tr, this message translates to:
  /// **'6 haneli kod'**
  String get verificationCodeHint;

  /// No description provided for @verifyEmailSubmit.
  ///
  /// In tr, this message translates to:
  /// **'Doğrula'**
  String get verifyEmailSubmit;

  /// Doğrulama ekranında yanlış yazılan e-postayı düzeltmek için kayıt formuna dönüş
  ///
  /// In tr, this message translates to:
  /// **'E-posta adresini değiştir'**
  String get verifyEmailChangeEmail;

  /// No description provided for @resendCode.
  ///
  /// In tr, this message translates to:
  /// **'Kodu tekrar gönder'**
  String get resendCode;

  /// No description provided for @resendCodeIn.
  ///
  /// In tr, this message translates to:
  /// **'Kodu tekrar gönder ({seconds} sn)'**
  String resendCodeIn(int seconds);

  /// No description provided for @codeResentAnnouncement.
  ///
  /// In tr, this message translates to:
  /// **'Yeni kod gönderildi.'**
  String get codeResentAnnouncement;

  /// No description provided for @emailVerifiedAnnouncement.
  ///
  /// In tr, this message translates to:
  /// **'Hesabınız doğrulandı. Hoş geldiniz, {name}.'**
  String emailVerifiedAnnouncement(String name);

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In tr, this message translates to:
  /// **'Şifremi Unuttum'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordHeading.
  ///
  /// In tr, this message translates to:
  /// **'Şifrenizi sıfırlayın'**
  String get forgotPasswordHeading;

  /// No description provided for @forgotPasswordBody.
  ///
  /// In tr, this message translates to:
  /// **'Hesabınıza kayıtlı e-posta adresini girin. Size bir sıfırlama kodu göndereceğiz.'**
  String get forgotPasswordBody;

  /// No description provided for @forgotPasswordSubmit.
  ///
  /// In tr, this message translates to:
  /// **'Kod gönder'**
  String get forgotPasswordSubmit;

  /// No description provided for @backToLogin.
  ///
  /// In tr, this message translates to:
  /// **'Girişe dön'**
  String get backToLogin;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Şifre'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordBody.
  ///
  /// In tr, this message translates to:
  /// **'{email} ile kayıtlı bir hesap varsa, bu adrese 6 haneli bir sıfırlama kodu gönderdik.'**
  String resetPasswordBody(String email);

  /// No description provided for @newPasswordLabel.
  ///
  /// In tr, this message translates to:
  /// **'Yeni şifre'**
  String get newPasswordLabel;

  /// No description provided for @confirmNewPasswordLabel.
  ///
  /// In tr, this message translates to:
  /// **'Yeni şifre (tekrar)'**
  String get confirmNewPasswordLabel;

  /// No description provided for @resetPasswordSubmit.
  ///
  /// In tr, this message translates to:
  /// **'Şifreyi güncelle'**
  String get resetPasswordSubmit;

  /// No description provided for @changePasswordTitle.
  ///
  /// In tr, this message translates to:
  /// **'Şifre Değiştir'**
  String get changePasswordTitle;

  /// No description provided for @currentPasswordLabel.
  ///
  /// In tr, this message translates to:
  /// **'Mevcut şifre'**
  String get currentPasswordLabel;

  /// No description provided for @changePasswordSubmit.
  ///
  /// In tr, this message translates to:
  /// **'Şifreyi değiştir'**
  String get changePasswordSubmit;

  /// No description provided for @changePasswordSuccess.
  ///
  /// In tr, this message translates to:
  /// **'Şifreniz değiştirildi.'**
  String get changePasswordSuccess;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hesabı Sil'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountHeading.
  ///
  /// In tr, this message translates to:
  /// **'Hesabınızı kalıcı olarak silin'**
  String get deleteAccountHeading;

  /// No description provided for @deleteAccountBody.
  ///
  /// In tr, this message translates to:
  /// **'Hesabınız ve hesabınıza bağlı kişisel verileriniz (profil, anılar, rozetler) KVKK kapsamında silinir. Bu işlem geri alınamaz.'**
  String get deleteAccountBody;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In tr, this message translates to:
  /// **'Bu işlemin geri alınamayacağını anlıyorum.'**
  String get deleteAccountConfirm;

  /// No description provided for @deleteAccountSubmit.
  ///
  /// In tr, this message translates to:
  /// **'Hesabımı sil'**
  String get deleteAccountSubmit;

  /// No description provided for @accountDeletedAnnouncement.
  ///
  /// In tr, this message translates to:
  /// **'Hesabınız silindi.'**
  String get accountDeletedAnnouncement;

  /// No description provided for @profileSecuritySection.
  ///
  /// In tr, this message translates to:
  /// **'Güvenlik ve hesap'**
  String get profileSecuritySection;

  /// No description provided for @legalTermsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kullanım Koşulları'**
  String get legalTermsTitle;

  /// No description provided for @legalPrivacyTitle.
  ///
  /// In tr, this message translates to:
  /// **'KVKK Aydınlatma Metni'**
  String get legalPrivacyTitle;

  /// No description provided for @legalVersion.
  ///
  /// In tr, this message translates to:
  /// **'Sürüm {version} · Yürürlük tarihi: {date}'**
  String legalVersion(String version, DateTime date);

  /// No description provided for @mapSemanticsLabel.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =0{Vakıf eserleri haritası, eser yok} other{Vakıf eserleri haritası, {count} eser}}'**
  String mapSemanticsLabel(int count);

  /// No description provided for @mapLoadedAnnouncement.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =0{Haritada gösterilecek eser bulunamadı} other{{count} eser haritada gösteriliyor}}'**
  String mapLoadedAnnouncement(int count);

  /// No description provided for @mapLoadingMonuments.
  ///
  /// In tr, this message translates to:
  /// **'Eserler yükleniyor'**
  String get mapLoadingMonuments;

  /// No description provided for @mapLoadErrorTitle.
  ///
  /// In tr, this message translates to:
  /// **'Eserler yüklenemedi'**
  String get mapLoadErrorTitle;

  /// No description provided for @mapZoomIn.
  ///
  /// In tr, this message translates to:
  /// **'Yakınlaştır'**
  String get mapZoomIn;

  /// No description provided for @mapZoomOut.
  ///
  /// In tr, this message translates to:
  /// **'Uzaklaştır'**
  String get mapZoomOut;

  /// No description provided for @mapShowAll.
  ///
  /// In tr, this message translates to:
  /// **'Tüm eserleri göster'**
  String get mapShowAll;

  /// No description provided for @mapControlsSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Harita kontrolleri'**
  String get mapControlsSemantics;

  /// No description provided for @mapAttributionSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Harita verileri: {attribution}'**
  String mapAttributionSemantics(String attribution);

  /// No description provided for @monumentPinSemantics.
  ///
  /// In tr, this message translates to:
  /// **'{name}, {district}, {city}'**
  String monumentPinSemantics(String name, String district, String city);

  /// No description provided for @monumentSelectedAnnouncement.
  ///
  /// In tr, this message translates to:
  /// **'{name} seçildi'**
  String monumentSelectedAnnouncement(String name);

  /// No description provided for @monumentCount.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =0{Eser yok} other{{count} eser}}'**
  String monumentCount(int count);

  /// No description provided for @monumentPreviewClose.
  ///
  /// In tr, this message translates to:
  /// **'Önizlemeyi kapat'**
  String get monumentPreviewClose;

  /// No description provided for @monumentSave.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get monumentSave;

  /// No description provided for @monumentUnsave.
  ///
  /// In tr, this message translates to:
  /// **'Kaydedilenlerden çıkar'**
  String get monumentUnsave;

  /// No description provided for @monumentSaveSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet: {name}'**
  String monumentSaveSemantics(String name);

  /// No description provided for @monumentUnsaveSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Kaydedilenlerden çıkar: {name}'**
  String monumentUnsaveSemantics(String name);

  /// No description provided for @savedMonumentAdded.
  ///
  /// In tr, this message translates to:
  /// **'Kaydedildi: {name}'**
  String savedMonumentAdded(String name);

  /// No description provided for @savedMonumentRemoved.
  ///
  /// In tr, this message translates to:
  /// **'Kaydedilenlerden çıkarıldı: {name}'**
  String savedMonumentRemoved(String name);

  /// No description provided for @savedMonumentsLimit.
  ///
  /// In tr, this message translates to:
  /// **'En fazla {max} eser kaydedebilirsiniz. Yer açmak için Kaydedilenler\'den eser çıkarın.'**
  String savedMonumentsLimit(int max);

  /// No description provided for @savedMonumentsSaveFailed.
  ///
  /// In tr, this message translates to:
  /// **'Kaydedilemedi. Tekrar deneyin.'**
  String get savedMonumentsSaveFailed;

  /// No description provided for @savedMonumentsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kaydedilenler'**
  String get savedMonumentsTitle;

  /// No description provided for @savedMonumentsButton.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =0{Kaydedilenler, kayıtlı eser yok} other{Kaydedilenler, {count} eser}}'**
  String savedMonumentsButton(int count);

  /// No description provided for @savedMonumentsCount.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, other{{count} eser}}'**
  String savedMonumentsCount(int count);

  /// No description provided for @savedMonumentsEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Henüz kaydedilen eser yok'**
  String get savedMonumentsEmptyTitle;

  /// No description provided for @savedMonumentsEmptyBody.
  ///
  /// In tr, this message translates to:
  /// **'İlginizi çeken eserleri, eser sayfasındaki veya harita önizlemesindeki yer işareti simgesiyle buraya kaydedin.'**
  String get savedMonumentsEmptyBody;

  /// No description provided for @emptyStateExploreMap.
  ///
  /// In tr, this message translates to:
  /// **'Haritada keşfet'**
  String get emptyStateExploreMap;

  /// No description provided for @savedMonumentsLoadFailedTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kaydedilenler yüklenemedi'**
  String get savedMonumentsLoadFailedTitle;

  /// No description provided for @savedMonumentSavedOn.
  ///
  /// In tr, this message translates to:
  /// **'Kaydedildi: {date}'**
  String savedMonumentSavedOn(String date);

  /// No description provided for @savedMonumentRemove.
  ///
  /// In tr, this message translates to:
  /// **'Kaldır'**
  String get savedMonumentRemove;

  /// No description provided for @savedMonumentUnavailable.
  ///
  /// In tr, this message translates to:
  /// **'Artık katalogda olmayan eser'**
  String get savedMonumentUnavailable;

  /// No description provided for @savedMonumentUnavailableBody.
  ///
  /// In tr, this message translates to:
  /// **'Bu eser katalogdan kaldırılmış; listeden çıkarabilirsiniz.'**
  String get savedMonumentUnavailableBody;

  /// No description provided for @monumentViewDetails.
  ///
  /// In tr, this message translates to:
  /// **'Detayları gör'**
  String get monumentViewDetails;

  /// No description provided for @monumentViewDetailsSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Detayları gör, {name}'**
  String monumentViewDetailsSemantics(String name);

  /// No description provided for @monumentLocation.
  ///
  /// In tr, this message translates to:
  /// **'{district}, {city}'**
  String monumentLocation(String district, String city);

  /// No description provided for @monumentLocationSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Konum: {location}'**
  String monumentLocationSemantics(String location);

  /// No description provided for @monumentAddressSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Adres: {address}'**
  String monumentAddressSemantics(String address);

  /// No description provided for @monumentCategoryMosque.
  ///
  /// In tr, this message translates to:
  /// **'Cami'**
  String get monumentCategoryMosque;

  /// No description provided for @monumentCategoryComplex.
  ///
  /// In tr, this message translates to:
  /// **'Külliye'**
  String get monumentCategoryComplex;

  /// No description provided for @monumentCategoryMadrasa.
  ///
  /// In tr, this message translates to:
  /// **'Medrese'**
  String get monumentCategoryMadrasa;

  /// No description provided for @monumentCategoryInn.
  ///
  /// In tr, this message translates to:
  /// **'Han'**
  String get monumentCategoryInn;

  /// No description provided for @monumentCategoryCaravanserai.
  ///
  /// In tr, this message translates to:
  /// **'Kervansaray'**
  String get monumentCategoryCaravanserai;

  /// No description provided for @monumentCategoryBath.
  ///
  /// In tr, this message translates to:
  /// **'Hamam'**
  String get monumentCategoryBath;

  /// No description provided for @monumentCategoryFountain.
  ///
  /// In tr, this message translates to:
  /// **'Çeşme'**
  String get monumentCategoryFountain;

  /// No description provided for @monumentCategoryTomb.
  ///
  /// In tr, this message translates to:
  /// **'Türbe'**
  String get monumentCategoryTomb;

  /// No description provided for @monumentCategoryHospital.
  ///
  /// In tr, this message translates to:
  /// **'Darüşşifa'**
  String get monumentCategoryHospital;

  /// No description provided for @monumentCategoryImaret.
  ///
  /// In tr, this message translates to:
  /// **'İmaret'**
  String get monumentCategoryImaret;

  /// No description provided for @monumentCategoryOther.
  ///
  /// In tr, this message translates to:
  /// **'Diğer yapı'**
  String get monumentCategoryOther;

  /// No description provided for @historicalPeriodSeljuk.
  ///
  /// In tr, this message translates to:
  /// **'Selçuklu'**
  String get historicalPeriodSeljuk;

  /// No description provided for @historicalPeriodBeylik.
  ///
  /// In tr, this message translates to:
  /// **'Beylikler'**
  String get historicalPeriodBeylik;

  /// No description provided for @historicalPeriodOttoman.
  ///
  /// In tr, this message translates to:
  /// **'Osmanlı'**
  String get historicalPeriodOttoman;

  /// No description provided for @historicalPeriodOther.
  ///
  /// In tr, this message translates to:
  /// **'Diğer dönem'**
  String get historicalPeriodOther;

  /// No description provided for @monumentCategorySemantics.
  ///
  /// In tr, this message translates to:
  /// **'Yapı türü: {category}'**
  String monumentCategorySemantics(String category);

  /// No description provided for @monumentPeriodSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Dönem: {period}'**
  String monumentPeriodSemantics(String period);

  /// No description provided for @monumentConstructionSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Yapım tarihi: {date}'**
  String monumentConstructionSemantics(String date);

  /// No description provided for @monumentUnescoBadge.
  ///
  /// In tr, this message translates to:
  /// **'UNESCO Dünya Mirası'**
  String get monumentUnescoBadge;

  /// No description provided for @monumentDetailLoading.
  ///
  /// In tr, this message translates to:
  /// **'Eser bilgileri yükleniyor'**
  String get monumentDetailLoading;

  /// No description provided for @monumentDetailErrorTitle.
  ///
  /// In tr, this message translates to:
  /// **'Eser bilgileri yüklenemedi'**
  String get monumentDetailErrorTitle;

  /// No description provided for @monumentNotFoundTitle.
  ///
  /// In tr, this message translates to:
  /// **'Eser bulunamadı'**
  String get monumentNotFoundTitle;

  /// No description provided for @monumentNotFoundBody.
  ///
  /// In tr, this message translates to:
  /// **'Aradığınız eser katalogda yer almıyor veya kaldırılmış olabilir.'**
  String get monumentNotFoundBody;

  /// No description provided for @monumentBackToMap.
  ///
  /// In tr, this message translates to:
  /// **'Haritaya dön'**
  String get monumentBackToMap;

  /// No description provided for @monumentShowOnMap.
  ///
  /// In tr, this message translates to:
  /// **'Haritada göster'**
  String get monumentShowOnMap;

  /// No description provided for @monumentListen.
  ///
  /// In tr, this message translates to:
  /// **'Sesli dinle'**
  String get monumentListen;

  /// No description provided for @monumentStopListening.
  ///
  /// In tr, this message translates to:
  /// **'Seslendirmeyi durdur'**
  String get monumentStopListening;

  /// No description provided for @monumentAboutHeading.
  ///
  /// In tr, this message translates to:
  /// **'Hakkında'**
  String get monumentAboutHeading;

  /// No description provided for @monumentHistoryHeading.
  ///
  /// In tr, this message translates to:
  /// **'Tarihçe'**
  String get monumentHistoryHeading;

  /// No description provided for @monumentFactsHeading.
  ///
  /// In tr, this message translates to:
  /// **'Eser künyesi'**
  String get monumentFactsHeading;

  /// No description provided for @monumentFounderLabel.
  ///
  /// In tr, this message translates to:
  /// **'Bani'**
  String get monumentFounderLabel;

  /// No description provided for @monumentArchitectLabel.
  ///
  /// In tr, this message translates to:
  /// **'Mimar'**
  String get monumentArchitectLabel;

  /// No description provided for @monumentConstructionLabel.
  ///
  /// In tr, this message translates to:
  /// **'Yapım tarihi'**
  String get monumentConstructionLabel;

  /// No description provided for @monumentPeriodLabel.
  ///
  /// In tr, this message translates to:
  /// **'Dönem'**
  String get monumentPeriodLabel;

  /// No description provided for @monumentCategoryLabel.
  ///
  /// In tr, this message translates to:
  /// **'Yapı türü'**
  String get monumentCategoryLabel;

  /// No description provided for @monumentLocationHeading.
  ///
  /// In tr, this message translates to:
  /// **'Konum'**
  String get monumentLocationHeading;

  /// No description provided for @monumentPhotoCreditsHeading.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf künyesi'**
  String get monumentPhotoCreditsHeading;

  /// No description provided for @monumentSpeechIntro.
  ///
  /// In tr, this message translates to:
  /// **'{name}. {category}, {location}.'**
  String monumentSpeechIntro(String name, String category, String location);

  /// No description provided for @photoCredit.
  ///
  /// In tr, this message translates to:
  /// **'{author} · {license} · {source}'**
  String photoCredit(String author, String license, String source);

  /// No description provided for @photoCreditSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf {index}: {author}, lisans {license}, kaynak {source}'**
  String photoCreditSemantics(
    int index,
    String author,
    String license,
    String source,
  );

  /// No description provided for @gallerySemantics.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =0{Fotoğraf galerisi, fotoğraf yok} other{Fotoğraf galerisi, {count} fotoğraf}}'**
  String gallerySemantics(int count);

  /// No description provided for @galleryPhotoSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf {index} / {count}: {description}'**
  String galleryPhotoSemantics(int index, int count, String description);

  /// No description provided for @galleryPosition.
  ///
  /// In tr, this message translates to:
  /// **'{index} / {count}'**
  String galleryPosition(int index, int count);

  /// No description provided for @galleryPositionSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf {index} / {count}'**
  String galleryPositionSemantics(int index, int count);

  /// No description provided for @galleryThumbnailSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf {index}: {description}'**
  String galleryThumbnailSemantics(int index, String description);

  /// No description provided for @galleryPrevious.
  ///
  /// In tr, this message translates to:
  /// **'Önceki fotoğraf'**
  String get galleryPrevious;

  /// No description provided for @galleryNext.
  ///
  /// In tr, this message translates to:
  /// **'Sonraki fotoğraf'**
  String get galleryNext;

  /// No description provided for @galleryOpenFullScreen.
  ///
  /// In tr, this message translates to:
  /// **'tam ekran görüntüle'**
  String get galleryOpenFullScreen;

  /// No description provided for @galleryCloseViewer.
  ///
  /// In tr, this message translates to:
  /// **'Galeriyi kapat'**
  String get galleryCloseViewer;

  /// No description provided for @galleryImageError.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf yüklenemedi'**
  String get galleryImageError;

  /// No description provided for @monumentListItemSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'{location} · {category}'**
  String monumentListItemSubtitle(String location, String category);

  /// No description provided for @photoCreditTitle.
  ///
  /// In tr, this message translates to:
  /// **'{index}. {description}'**
  String photoCreditTitle(int index, String description);

  /// No description provided for @photoCreditsNotice.
  ///
  /// In tr, this message translates to:
  /// **'Lisans koşulları fotoğrafların kaynak sayfalarında yer alır.'**
  String get photoCreditsNotice;

  /// No description provided for @distanceKilometers.
  ///
  /// In tr, this message translates to:
  /// **'{value} km'**
  String distanceKilometers(String value);

  /// No description provided for @distanceMeters.
  ///
  /// In tr, this message translates to:
  /// **'{value} m'**
  String distanceMeters(String value);

  /// No description provided for @durationDaysShort.
  ///
  /// In tr, this message translates to:
  /// **'{count} g'**
  String durationDaysShort(int count);

  /// No description provided for @durationHoursShort.
  ///
  /// In tr, this message translates to:
  /// **'{count} sa'**
  String durationHoursShort(int count);

  /// No description provided for @durationMinutesShort.
  ///
  /// In tr, this message translates to:
  /// **'{count} dk'**
  String durationMinutesShort(int count);

  /// No description provided for @durationDays.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =1{1 gün} other{{count} gün}}'**
  String durationDays(int count);

  /// No description provided for @durationHours.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =1{1 saat} other{{count} saat}}'**
  String durationHours(int count);

  /// No description provided for @durationMinutes.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =1{1 dakika} other{{count} dakika}}'**
  String durationMinutes(int count);

  /// No description provided for @routeListTitle.
  ///
  /// In tr, this message translates to:
  /// **'Rotalarım'**
  String get routeListTitle;

  /// No description provided for @routeNewButton.
  ///
  /// In tr, this message translates to:
  /// **'Yeni rota'**
  String get routeNewButton;

  /// No description provided for @routeListLoading.
  ///
  /// In tr, this message translates to:
  /// **'Rotalar yükleniyor'**
  String get routeListLoading;

  /// No description provided for @routeListErrorTitle.
  ///
  /// In tr, this message translates to:
  /// **'Rotalar yüklenemedi'**
  String get routeListErrorTitle;

  /// No description provided for @routeListEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Henüz rotanız yok'**
  String get routeListEmptyTitle;

  /// No description provided for @routeListEmptyBody.
  ///
  /// In tr, this message translates to:
  /// **'Eserleri seçip sıralayın; ziyaret süresi ve molalarla ilk kültür rotanızı oluşturun.'**
  String get routeListEmptyBody;

  /// No description provided for @routeDraftBanner.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =1{Taslak rotanızda 1 eser var} other{Taslak rotanızda {count} eser var}}'**
  String routeDraftBanner(int count);

  /// No description provided for @routeDraftContinue.
  ///
  /// In tr, this message translates to:
  /// **'Devam et'**
  String get routeDraftContinue;

  /// No description provided for @routeStopCount.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =1{1 durak} other{{count} durak}}'**
  String routeStopCount(int count);

  /// No description provided for @routeCityChain.
  ///
  /// In tr, this message translates to:
  /// **'{from} → {to}'**
  String routeCityChain(String from, String to);

  /// No description provided for @routeCardSemantics.
  ///
  /// In tr, this message translates to:
  /// **'{name}. {stops}: {cities}. Toplam {distance}, {duration}. {created}.'**
  String routeCardSemantics(
    String name,
    String stops,
    String cities,
    String distance,
    String duration,
    String created,
  );

  /// No description provided for @routeCreatedOn.
  ///
  /// In tr, this message translates to:
  /// **'Oluşturulma: {date}'**
  String routeCreatedOn(String date);

  /// No description provided for @routeTotalDistanceSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Toplam mesafe: {value}'**
  String routeTotalDistanceSemantics(String value);

  /// No description provided for @routeTotalDurationSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Toplam süre: {value}'**
  String routeTotalDurationSemantics(String value);

  /// No description provided for @routeDetailLoading.
  ///
  /// In tr, this message translates to:
  /// **'Rota yükleniyor'**
  String get routeDetailLoading;

  /// App bar title while a route is loading or failed.
  ///
  /// In tr, this message translates to:
  /// **'Rota detayı'**
  String get routeDetailTitle;

  /// Live status while a route is being deleted.
  ///
  /// In tr, this message translates to:
  /// **'Rota siliniyor'**
  String get routeDeleting;

  /// No description provided for @routeDetailErrorTitle.
  ///
  /// In tr, this message translates to:
  /// **'Rota yüklenemedi'**
  String get routeDetailErrorTitle;

  /// No description provided for @routeNotFoundTitle.
  ///
  /// In tr, this message translates to:
  /// **'Rota bulunamadı'**
  String get routeNotFoundTitle;

  /// No description provided for @routeNotFoundBody.
  ///
  /// In tr, this message translates to:
  /// **'Rota silinmiş veya bu cihaza bağlı değil.'**
  String get routeNotFoundBody;

  /// No description provided for @routeBackToList.
  ///
  /// In tr, this message translates to:
  /// **'Rotalarıma dön'**
  String get routeBackToList;

  /// No description provided for @routeEdit.
  ///
  /// In tr, this message translates to:
  /// **'Düzenle'**
  String get routeEdit;

  /// No description provided for @routeDelete.
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get routeDelete;

  /// No description provided for @routeDeleteConfirmTitle.
  ///
  /// In tr, this message translates to:
  /// **'Rota silinsin mi?'**
  String get routeDeleteConfirmTitle;

  /// No description provided for @routeDeleteConfirmBody.
  ///
  /// In tr, this message translates to:
  /// **'\"{name}\" kalıcı olarak silinecek. Bu işlem geri alınamaz.'**
  String routeDeleteConfirmBody(String name);

  /// No description provided for @routeDeletedMessage.
  ///
  /// In tr, this message translates to:
  /// **'Rota silindi'**
  String get routeDeletedMessage;

  /// No description provided for @routeSummaryHeading.
  ///
  /// In tr, this message translates to:
  /// **'Süre ve mesafe'**
  String get routeSummaryHeading;

  /// No description provided for @routeTotalDuration.
  ///
  /// In tr, this message translates to:
  /// **'Toplam süre'**
  String get routeTotalDuration;

  /// No description provided for @routeTravelTime.
  ///
  /// In tr, this message translates to:
  /// **'Yolculuk'**
  String get routeTravelTime;

  /// No description provided for @routeVisitTime.
  ///
  /// In tr, this message translates to:
  /// **'Ziyaret'**
  String get routeVisitTime;

  /// No description provided for @routeBreakTime.
  ///
  /// In tr, this message translates to:
  /// **'Mola'**
  String get routeBreakTime;

  /// No description provided for @routeDistance.
  ///
  /// In tr, this message translates to:
  /// **'Karayolu mesafesi'**
  String get routeDistance;

  /// No description provided for @routeMetricSemantics.
  ///
  /// In tr, this message translates to:
  /// **'{label}: {value}'**
  String routeMetricSemantics(String label, String value);

  /// No description provided for @routeEstimateNote.
  ///
  /// In tr, this message translates to:
  /// **'Yolculuk süresi karayolu mesafesine göre araçla tahmin edilir; trafik ve hava koşulları değiştirebilir.'**
  String get routeEstimateNote;

  /// No description provided for @routeStepsHeading.
  ///
  /// In tr, this message translates to:
  /// **'Adım adım'**
  String get routeStepsHeading;

  /// No description provided for @routeStopSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Durak {index} / {count}: {name}, {location}. Ziyaret süresi {visit}.'**
  String routeStopSemantics(
    int index,
    int count,
    String name,
    String location,
    String visit,
  );

  /// No description provided for @routeVisitLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ziyaret · {duration}'**
  String routeVisitLabel(String duration);

  /// No description provided for @routeLegLabel.
  ///
  /// In tr, this message translates to:
  /// **'{distance} · araçla ≈ {duration}'**
  String routeLegLabel(String distance, String duration);

  /// No description provided for @routeLegSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Sonraki durak {next}: {distance}, araçla yaklaşık {duration}.'**
  String routeLegSemantics(String next, String distance, String duration);

  /// No description provided for @routeBreakSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Mola: {kind}, {duration}'**
  String routeBreakSemantics(String kind, String duration);

  /// Timeline break row: kind and short duration.
  ///
  /// In tr, this message translates to:
  /// **'{kind} · {duration}'**
  String routeBreakLabel(String kind, String duration);

  /// No description provided for @routeBreakShort.
  ///
  /// In tr, this message translates to:
  /// **'Kısa mola'**
  String get routeBreakShort;

  /// No description provided for @routeBreakMeal.
  ///
  /// In tr, this message translates to:
  /// **'Yemek molası'**
  String get routeBreakMeal;

  /// No description provided for @routeBreakRest.
  ///
  /// In tr, this message translates to:
  /// **'Dinlenme'**
  String get routeBreakRest;

  /// No description provided for @routeBreakOvernight.
  ///
  /// In tr, this message translates to:
  /// **'Konaklama'**
  String get routeBreakOvernight;

  /// No description provided for @routeBuilderNewTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yeni rota'**
  String get routeBuilderNewTitle;

  /// No description provided for @routeBuilderEditTitle.
  ///
  /// In tr, this message translates to:
  /// **'Rotayı düzenle'**
  String get routeBuilderEditTitle;

  /// No description provided for @routeBuilderLoading.
  ///
  /// In tr, this message translates to:
  /// **'Eserler yükleniyor'**
  String get routeBuilderLoading;

  /// No description provided for @routeNameLabel.
  ///
  /// In tr, this message translates to:
  /// **'Rota adı'**
  String get routeNameLabel;

  /// No description provided for @routeNameHelper.
  ///
  /// In tr, this message translates to:
  /// **'Boş bırakırsanız önerilen ad kullanılır.'**
  String get routeNameHelper;

  /// No description provided for @routeDefaultName.
  ///
  /// In tr, this message translates to:
  /// **'{from} – {to} Rotası'**
  String routeDefaultName(String from, String to);

  /// No description provided for @routeDefaultNameSingleCity.
  ///
  /// In tr, this message translates to:
  /// **'{city} Rotası'**
  String routeDefaultNameSingleCity(String city);

  /// No description provided for @routeDefaultNameEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Kültür Rotası'**
  String get routeDefaultNameEmpty;

  /// No description provided for @routeStopsHeading.
  ///
  /// In tr, this message translates to:
  /// **'Duraklar ({count}/{max})'**
  String routeStopsHeading(int count, int max);

  /// No description provided for @routeAddMonuments.
  ///
  /// In tr, this message translates to:
  /// **'Eser ekle'**
  String get routeAddMonuments;

  /// No description provided for @routePickerDone.
  ///
  /// In tr, this message translates to:
  /// **'Tamam'**
  String get routePickerDone;

  /// No description provided for @routeOptimize.
  ///
  /// In tr, this message translates to:
  /// **'Sırayı optimize et'**
  String get routeOptimize;

  /// No description provided for @routeOptimizeHint.
  ///
  /// In tr, this message translates to:
  /// **'İlk durak başlangıç olarak kalır; diğerleri en kısa kuş uçuşu mesafeye göre sıralanır.'**
  String get routeOptimizeHint;

  /// No description provided for @routeOptimizedAnnouncement.
  ///
  /// In tr, this message translates to:
  /// **'Sıra optimize edildi: kuş uçuşu {before} yerine {after}.'**
  String routeOptimizedAnnouncement(String before, String after);

  /// No description provided for @routeOptimizedUnchanged.
  ///
  /// In tr, this message translates to:
  /// **'Sıra zaten en kısa.'**
  String get routeOptimizedUnchanged;

  /// No description provided for @routeEmptyStops.
  ///
  /// In tr, this message translates to:
  /// **'Rota için en az 2 eser seçin.'**
  String get routeEmptyStops;

  /// No description provided for @routeMoveUp.
  ///
  /// In tr, this message translates to:
  /// **'{name}: yukarı taşı'**
  String routeMoveUp(String name);

  /// No description provided for @routeMoveDown.
  ///
  /// In tr, this message translates to:
  /// **'{name}: aşağı taşı'**
  String routeMoveDown(String name);

  /// No description provided for @routeRemoveStop.
  ///
  /// In tr, this message translates to:
  /// **'{name}: rotadan çıkar'**
  String routeRemoveStop(String name);

  /// No description provided for @routeStopMovedAnnouncement.
  ///
  /// In tr, this message translates to:
  /// **'{name} {position}. sıraya taşındı'**
  String routeStopMovedAnnouncement(String name, int position);

  /// No description provided for @routeStopAddedAnnouncement.
  ///
  /// In tr, this message translates to:
  /// **'{name} rotaya eklendi'**
  String routeStopAddedAnnouncement(String name);

  /// No description provided for @routeStopRemovedAnnouncement.
  ///
  /// In tr, this message translates to:
  /// **'{name} rotadan çıkarıldı'**
  String routeStopRemovedAnnouncement(String name);

  /// No description provided for @routeVisitDuration.
  ///
  /// In tr, this message translates to:
  /// **'Ziyaret süresi'**
  String get routeVisitDuration;

  /// No description provided for @routeDurationDecrease.
  ///
  /// In tr, this message translates to:
  /// **'{label}: azalt'**
  String routeDurationDecrease(String label);

  /// No description provided for @routeDurationIncrease.
  ///
  /// In tr, this message translates to:
  /// **'{label}: artır'**
  String routeDurationIncrease(String label);

  /// No description provided for @routeAddBreak.
  ///
  /// In tr, this message translates to:
  /// **'Mola ekle'**
  String get routeAddBreak;

  /// No description provided for @routeBreakPickerTitle.
  ///
  /// In tr, this message translates to:
  /// **'Mola türü'**
  String get routeBreakPickerTitle;

  /// No description provided for @routeBreakPickerDefault.
  ///
  /// In tr, this message translates to:
  /// **'Önerilen süre: {duration}'**
  String routeBreakPickerDefault(String duration);

  /// No description provided for @routeRemoveBreak.
  ///
  /// In tr, this message translates to:
  /// **'{kind}: kaldır'**
  String routeRemoveBreak(String kind);

  /// No description provided for @routeBreakLimit.
  ///
  /// In tr, this message translates to:
  /// **'Bir durağa en fazla {max} mola eklenebilir.'**
  String routeBreakLimit(int max);

  /// No description provided for @routeStraightLineToNext.
  ///
  /// In tr, this message translates to:
  /// **'Sonraki durağa kuş uçuşu ≈ {distance}'**
  String routeStraightLineToNext(String distance);

  /// No description provided for @routeBuilderSummary.
  ///
  /// In tr, this message translates to:
  /// **'{stops} · kuş uçuşu ≈ {distance}'**
  String routeBuilderSummary(String stops, String distance);

  /// No description provided for @routeBuilderTimes.
  ///
  /// In tr, this message translates to:
  /// **'Ziyaret {visit} · Mola {breaks}'**
  String routeBuilderTimes(String visit, String breaks);

  /// No description provided for @routeBuilderTravelNote.
  ///
  /// In tr, this message translates to:
  /// **'Karayolu mesafesi ve yolculuk süresi rota oluşturulunca hesaplanır.'**
  String get routeBuilderTravelNote;

  /// No description provided for @routeCreate.
  ///
  /// In tr, this message translates to:
  /// **'Rotayı oluştur'**
  String get routeCreate;

  /// No description provided for @routeSaveChanges.
  ///
  /// In tr, this message translates to:
  /// **'Değişiklikleri kaydet'**
  String get routeSaveChanges;

  /// No description provided for @routeCreatedAnnouncement.
  ///
  /// In tr, this message translates to:
  /// **'Rota oluşturuldu: {stops}, {distance}, toplam {duration}.'**
  String routeCreatedAnnouncement(
    String stops,
    String distance,
    String duration,
  );

  /// No description provided for @routeUpdatedAnnouncement.
  ///
  /// In tr, this message translates to:
  /// **'Rota güncellendi.'**
  String get routeUpdatedAnnouncement;

  /// No description provided for @routeValidationNameTooLong.
  ///
  /// In tr, this message translates to:
  /// **'Rota adı en fazla {max} karakter olabilir.'**
  String routeValidationNameTooLong(int max);

  /// No description provided for @routeValidationGeneric.
  ///
  /// In tr, this message translates to:
  /// **'Rota bilgilerini kontrol edin.'**
  String get routeValidationGeneric;

  /// No description provided for @routeLimitReached.
  ///
  /// In tr, this message translates to:
  /// **'Bir rotada en fazla {max} eser olabilir.'**
  String routeLimitReached(int max);

  /// No description provided for @routeAddToRoute.
  ///
  /// In tr, this message translates to:
  /// **'Rotaya ekle'**
  String get routeAddToRoute;

  /// No description provided for @routeRemoveFromRoute.
  ///
  /// In tr, this message translates to:
  /// **'Rotadan çıkar'**
  String get routeRemoveFromRoute;

  /// No description provided for @routeAddedSnack.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =1{Rotaya eklendi · taslakta 1 eser} other{Rotaya eklendi · taslakta {count} eser}}'**
  String routeAddedSnack(int count);

  /// No description provided for @routeGoToDraft.
  ///
  /// In tr, this message translates to:
  /// **'Rotaya git'**
  String get routeGoToDraft;

  /// No description provided for @mapSearchHint.
  ///
  /// In tr, this message translates to:
  /// **'Yer veya eser ara'**
  String get mapSearchHint;

  /// No description provided for @mapSearchEditSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Arama: {query}. Düzenlemek için dokunun'**
  String mapSearchEditSemantics(String query);

  /// No description provided for @mapSearchClear.
  ///
  /// In tr, this message translates to:
  /// **'Aramayı temizle'**
  String get mapSearchClear;

  /// No description provided for @mapFiltersButton.
  ///
  /// In tr, this message translates to:
  /// **'Filtreler'**
  String get mapFiltersButton;

  /// No description provided for @mapFiltersButtonActive.
  ///
  /// In tr, this message translates to:
  /// **'Filtreler, {count} etkin'**
  String mapFiltersButtonActive(int count);

  /// No description provided for @mapResultsShowing.
  ///
  /// In tr, this message translates to:
  /// **'{count} eser gösteriliyor'**
  String mapResultsShowing(int count);

  /// No description provided for @mapNoMatches.
  ///
  /// In tr, this message translates to:
  /// **'Eşleşen eser yok'**
  String get mapNoMatches;

  /// No description provided for @mapClearRefinements.
  ///
  /// In tr, this message translates to:
  /// **'Temizle'**
  String get mapClearRefinements;

  /// No description provided for @mapClearRefinementsSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Arama ve filtreleri temizle'**
  String get mapClearRefinementsSemantics;

  /// No description provided for @mapRefinementsClearedAnnouncement.
  ///
  /// In tr, this message translates to:
  /// **'Arama ve filtreler temizlendi, tüm eserler gösteriliyor'**
  String get mapRefinementsClearedAnnouncement;

  /// No description provided for @mapLocateMe.
  ///
  /// In tr, this message translates to:
  /// **'Konumumu göster'**
  String get mapLocateMe;

  /// No description provided for @mapLocating.
  ///
  /// In tr, this message translates to:
  /// **'Konumunuz alınıyor'**
  String get mapLocating;

  /// No description provided for @mapUserLocationSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Konumunuz'**
  String get mapUserLocationSemantics;

  /// No description provided for @mapLocationShownAnnouncement.
  ///
  /// In tr, this message translates to:
  /// **'Konumunuz gösteriliyor'**
  String get mapLocationShownAnnouncement;

  /// No description provided for @locationIssueServiceDisabled.
  ///
  /// In tr, this message translates to:
  /// **'Konum servisleri kapalı. Konumunuzu görmek için açın.'**
  String get locationIssueServiceDisabled;

  /// No description provided for @locationIssuePermissionDenied.
  ///
  /// In tr, this message translates to:
  /// **'Konum izni verilmedi. Konumunuzu görmek için izin verin.'**
  String get locationIssuePermissionDenied;

  /// No description provided for @locationIssuePermissionDeniedForever.
  ///
  /// In tr, this message translates to:
  /// **'Konum izni kapalı. Ayarlardan izin verebilirsiniz.'**
  String get locationIssuePermissionDeniedForever;

  /// No description provided for @locationIssueUnavailable.
  ///
  /// In tr, this message translates to:
  /// **'Konumunuz şu anda alınamıyor. Lütfen tekrar deneyin.'**
  String get locationIssueUnavailable;

  /// No description provided for @locationOutsideRegion.
  ///
  /// In tr, this message translates to:
  /// **'Konumunuz harita alanının dışında.'**
  String get locationOutsideRegion;

  /// No description provided for @locationOpenSettings.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get locationOpenSettings;

  /// No description provided for @searchAllMonuments.
  ///
  /// In tr, this message translates to:
  /// **'Tüm eserler'**
  String get searchAllMonuments;

  /// No description provided for @searchPlacesHeader.
  ///
  /// In tr, this message translates to:
  /// **'Yerler'**
  String get searchPlacesHeader;

  /// No description provided for @searchMonumentsHeader.
  ///
  /// In tr, this message translates to:
  /// **'Eserler'**
  String get searchMonumentsHeader;

  /// No description provided for @searchShowOnMap.
  ///
  /// In tr, this message translates to:
  /// **'{name}: haritada göster'**
  String searchShowOnMap(String name);

  /// No description provided for @searchNoResultsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sonuç bulunamadı'**
  String get searchNoResultsTitle;

  /// No description provided for @searchNoResultsBody.
  ///
  /// In tr, this message translates to:
  /// **'“{query}” için eşleşen yer veya eser yok. Yazımı kontrol edin ya da daha kısa bir arama deneyin.'**
  String searchNoResultsBody(String query);

  /// No description provided for @searchResultsAnnouncement.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =0{Sonuç bulunamadı} other{{count} sonuç}}'**
  String searchResultsAnnouncement(int count);

  /// No description provided for @searchRemoveFilters.
  ///
  /// In tr, this message translates to:
  /// **'Filtreleri kaldır'**
  String get searchRemoveFilters;

  /// No description provided for @searchPlaceAnnouncement.
  ///
  /// In tr, this message translates to:
  /// **'{place}: {count} eser'**
  String searchPlaceAnnouncement(String place, int count);

  /// No description provided for @filterSheetTitle.
  ///
  /// In tr, this message translates to:
  /// **'Filtreler'**
  String get filterSheetTitle;

  /// No description provided for @filterCategorySection.
  ///
  /// In tr, this message translates to:
  /// **'Yapı türü'**
  String get filterCategorySection;

  /// No description provided for @filterPeriodSection.
  ///
  /// In tr, this message translates to:
  /// **'Dönem'**
  String get filterPeriodSection;

  /// No description provided for @filterCitySection.
  ///
  /// In tr, this message translates to:
  /// **'İl'**
  String get filterCitySection;

  /// No description provided for @filterOptionWithCount.
  ///
  /// In tr, this message translates to:
  /// **'{label} ({count})'**
  String filterOptionWithCount(String label, int count);

  /// No description provided for @accountButtonGuestSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Hesap menüsü, misafir'**
  String get accountButtonGuestSemantics;

  /// No description provided for @accountButtonSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Hesap menüsü, {name}'**
  String accountButtonSemantics(String name);

  /// No description provided for @accountMenuGuestTitle.
  ///
  /// In tr, this message translates to:
  /// **'Misafir'**
  String get accountMenuGuestTitle;

  /// No description provided for @accountMenuGuestBody.
  ///
  /// In tr, this message translates to:
  /// **'Anı paylaşmak ve hasar bildirmek için giriş yapın.'**
  String get accountMenuGuestBody;

  /// No description provided for @accountMenuProfile.
  ///
  /// In tr, this message translates to:
  /// **'Profilim'**
  String get accountMenuProfile;

  /// No description provided for @accountMenuSignIn.
  ///
  /// In tr, this message translates to:
  /// **'Giriş yap veya kayıt ol'**
  String get accountMenuSignIn;

  /// No description provided for @searchResultsTotal.
  ///
  /// In tr, this message translates to:
  /// **'{count} sonuç'**
  String searchResultsTotal(int count);

  /// No description provided for @searchApplyToMap.
  ///
  /// In tr, this message translates to:
  /// **'{count} sonucu haritada göster'**
  String searchApplyToMap(int count);

  /// No description provided for @searchLoadingMore.
  ///
  /// In tr, this message translates to:
  /// **'Daha fazla sonuç yükleniyor'**
  String get searchLoadingMore;

  /// No description provided for @searchLoadMoreFailed.
  ///
  /// In tr, this message translates to:
  /// **'Sonraki sonuçlar yüklenemedi.'**
  String get searchLoadMoreFailed;

  /// No description provided for @searchEndOfResults.
  ///
  /// In tr, this message translates to:
  /// **'Tüm sonuçlar gösterildi ({count})'**
  String searchEndOfResults(int count);

  /// No description provided for @searchMoreLoadedAnnouncement.
  ///
  /// In tr, this message translates to:
  /// **'{count} sonuç daha yüklendi'**
  String searchMoreLoadedAnnouncement(int count);

  /// No description provided for @searchLoadFailedTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sonuçlar yüklenemedi'**
  String get searchLoadFailedTitle;

  /// No description provided for @searchNoFilterResultsBody.
  ///
  /// In tr, this message translates to:
  /// **'Seçili filtrelere uyan eser yok. Filtreleri kaldırmayı deneyin.'**
  String get searchNoFilterResultsBody;

  /// No description provided for @filterSelectionSummary.
  ///
  /// In tr, this message translates to:
  /// **'{first} +{more}'**
  String filterSelectionSummary(String first, int more);

  /// No description provided for @filterGroupSemantics.
  ///
  /// In tr, this message translates to:
  /// **'{group} filtresi: {selection}'**
  String filterGroupSemantics(String group, String selection);

  /// No description provided for @filterNoneSelected.
  ///
  /// In tr, this message translates to:
  /// **'seçim yok'**
  String get filterNoneSelected;

  /// No description provided for @filterApplyButton.
  ///
  /// In tr, this message translates to:
  /// **'Uygula'**
  String get filterApplyButton;

  /// No description provided for @filterGroupClear.
  ///
  /// In tr, this message translates to:
  /// **'Temizle'**
  String get filterGroupClear;

  /// No description provided for @filterClearAllChip.
  ///
  /// In tr, this message translates to:
  /// **'Filtreleri temizle'**
  String get filterClearAllChip;

  /// No description provided for @mapRefinementFailed.
  ///
  /// In tr, this message translates to:
  /// **'Arama haritaya uygulanamadı.'**
  String get mapRefinementFailed;

  /// No description provided for @mapClusterSemantics.
  ///
  /// In tr, this message translates to:
  /// **'{count} eserlik küme. Yakınlaştırmak için dokunun.'**
  String mapClusterSemantics(int count);

  /// No description provided for @mapClusterListSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Aynı konumda {count} eser. Listelemek için dokunun.'**
  String mapClusterListSemantics(int count);

  /// No description provided for @mapClusterExpandedAnnouncement.
  ///
  /// In tr, this message translates to:
  /// **'{count} eserlik bölgeye yakınlaştırıldı'**
  String mapClusterExpandedAnnouncement(int count);

  /// No description provided for @mapClusterSheetTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bu konumdaki eserler'**
  String get mapClusterSheetTitle;

  /// No description provided for @mapPreviewLoading.
  ///
  /// In tr, this message translates to:
  /// **'Önizleme yükleniyor'**
  String get mapPreviewLoading;

  /// No description provided for @mapPreviewLoadFailed.
  ///
  /// In tr, this message translates to:
  /// **'Eser önizlemesi yüklenemedi.'**
  String get mapPreviewLoadFailed;

  /// No description provided for @mapClusterLoadFailed.
  ///
  /// In tr, this message translates to:
  /// **'Bu konumdaki eserler yüklenemedi.'**
  String get mapClusterLoadFailed;

  /// No description provided for @settingsReduceMotionSystemOn.
  ///
  /// In tr, this message translates to:
  /// **'Cihazınızın erişilebilirlik ayarlarında açık olduğu için uygulamada her zaman uygulanır.'**
  String get settingsReduceMotionSystemOn;

  /// No description provided for @settingsPermissionsSection.
  ///
  /// In tr, this message translates to:
  /// **'Gizlilik ve izinler'**
  String get settingsPermissionsSection;

  /// No description provided for @settingsAboutSection.
  ///
  /// In tr, this message translates to:
  /// **'Hakkında'**
  String get settingsAboutSection;

  /// No description provided for @settingsReplayOnboarding.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama tanıtımını yeniden göster'**
  String get settingsReplayOnboarding;

  /// No description provided for @settingsPrivacyNotice.
  ///
  /// In tr, this message translates to:
  /// **'KVKK Aydınlatma Metni'**
  String get settingsPrivacyNotice;

  /// No description provided for @settingsTermsOfUse.
  ///
  /// In tr, this message translates to:
  /// **'Kullanım Koşulları'**
  String get settingsTermsOfUse;

  /// No description provided for @permissionLocationTitle.
  ///
  /// In tr, this message translates to:
  /// **'Konum'**
  String get permissionLocationTitle;

  /// No description provided for @permissionLocationPurpose.
  ///
  /// In tr, this message translates to:
  /// **'Yakınınızdaki vakıf eserlerini haritada göstermek için kullanılır. Haritada konumunuz yalnızca cihazınızda işlenir. Yalnızca bir hasar bildirimine eklemeyi seçerseniz o bildirimle gönderilir.'**
  String get permissionLocationPurpose;

  /// No description provided for @permissionStatusChecking.
  ///
  /// In tr, this message translates to:
  /// **'Durum kontrol ediliyor'**
  String get permissionStatusChecking;

  /// No description provided for @permissionStatusGranted.
  ///
  /// In tr, this message translates to:
  /// **'İzin verildi'**
  String get permissionStatusGranted;

  /// No description provided for @permissionStatusNotGranted.
  ///
  /// In tr, this message translates to:
  /// **'İzin verilmedi'**
  String get permissionStatusNotGranted;

  /// No description provided for @permissionStatusBlocked.
  ///
  /// In tr, this message translates to:
  /// **'Kapalı. Sistem ayarlarından izin verebilirsiniz.'**
  String get permissionStatusBlocked;

  /// No description provided for @permissionStatusBlockedBrowser.
  ///
  /// In tr, this message translates to:
  /// **'Kapalı. Tarayıcınızın adres çubuğundaki simgeden veya site ayarlarından izin verebilirsiniz.'**
  String get permissionStatusBlockedBrowser;

  /// No description provided for @permissionStatusServiceDisabled.
  ///
  /// In tr, this message translates to:
  /// **'Cihazın konum servisleri kapalı.'**
  String get permissionStatusServiceDisabled;

  /// No description provided for @permissionStatusUnsupported.
  ///
  /// In tr, this message translates to:
  /// **'Bu cihazda kullanılamıyor.'**
  String get permissionStatusUnsupported;

  /// No description provided for @permissionStatusSemantics.
  ///
  /// In tr, this message translates to:
  /// **'{permission} izni: {status}'**
  String permissionStatusSemantics(String permission, String status);

  /// No description provided for @permissionLocationAllow.
  ///
  /// In tr, this message translates to:
  /// **'Konum iznini ver'**
  String get permissionLocationAllow;

  /// No description provided for @permissionCameraTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kamera'**
  String get permissionCameraTitle;

  /// No description provided for @permissionCameraPurpose.
  ///
  /// In tr, this message translates to:
  /// **'Anı Köşesi\'nde ve hasar bildirimlerinde fotoğraf çekmek için kullanılır. Fotoğraf yalnızca siz paylaştığınızda yüklenir; konum bilgisi önceden silinir.'**
  String get permissionCameraPurpose;

  /// No description provided for @permissionCameraAllow.
  ///
  /// In tr, this message translates to:
  /// **'Kamera iznini ver'**
  String get permissionCameraAllow;

  /// No description provided for @permissionMicrophoneTitle.
  ///
  /// In tr, this message translates to:
  /// **'Mikrofon'**
  String get permissionMicrophoneTitle;

  /// No description provided for @permissionMicrophonePurpose.
  ///
  /// In tr, this message translates to:
  /// **'Dijital Rehber\'e sesli soru sormak için kullanılır. Konuşmanız cihazınızın veya tarayıcınızın konuşma tanıma servisiyle metne çevrilir; uygulama ses kaydı saklamaz ve siz göndermeden soru iletilmez.'**
  String get permissionMicrophonePurpose;

  /// No description provided for @permissionMicrophoneAllow.
  ///
  /// In tr, this message translates to:
  /// **'Mikrofon iznini ver'**
  String get permissionMicrophoneAllow;

  /// No description provided for @permissionOpenAppSettings.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama ayarlarını aç'**
  String get permissionOpenAppSettings;

  /// No description provided for @permissionOpenLocationSettings.
  ///
  /// In tr, this message translates to:
  /// **'Konum ayarlarını aç'**
  String get permissionOpenLocationSettings;

  /// No description provided for @permissionManageInSettings.
  ///
  /// In tr, this message translates to:
  /// **'Sistem ayarlarında yönet'**
  String get permissionManageInSettings;

  /// No description provided for @permissionOnDemandNote.
  ///
  /// In tr, this message translates to:
  /// **'İzin vermeseniz de uygulamayı kullanabilirsiniz. Bir özellik izne ihtiyaç duyduğunda (fotoğraf çekmek, sesli soru sormak) yeniden sorulur.'**
  String get permissionOnDemandNote;

  /// No description provided for @onboardingStepCounter.
  ///
  /// In tr, this message translates to:
  /// **'Adım {current} / {total}'**
  String onboardingStepCounter(int current, int total);

  /// No description provided for @onboardingStepAnnouncement.
  ///
  /// In tr, this message translates to:
  /// **'Adım {current} / {total}: {title}'**
  String onboardingStepAnnouncement(int current, int total, String title);

  /// No description provided for @onboardingSkip.
  ///
  /// In tr, this message translates to:
  /// **'Atla'**
  String get onboardingSkip;

  /// No description provided for @onboardingSkipSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Tanıtımı atla'**
  String get onboardingSkipSemantics;

  /// No description provided for @onboardingStart.
  ///
  /// In tr, this message translates to:
  /// **'Başlayın'**
  String get onboardingStart;

  /// No description provided for @onboardingNext.
  ///
  /// In tr, this message translates to:
  /// **'Devam'**
  String get onboardingNext;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hoş geldiniz'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeDescription.
  ///
  /// In tr, this message translates to:
  /// **'Vakıf eserlerini haritada keşfedin, ayrıntılarını inceleyin ve gezinizi planlayın. Başlamadan önce uygulamayı size göre ayarlayalım; önce dilinizi seçin.'**
  String get onboardingWelcomeDescription;

  /// No description provided for @onboardingDisplayTitle.
  ///
  /// In tr, this message translates to:
  /// **'Görünüm'**
  String get onboardingDisplayTitle;

  /// No description provided for @onboardingDisplayDescription.
  ///
  /// In tr, this message translates to:
  /// **'Açık, koyu veya cihazınızı izleyen temayı seçin. Değişiklik hemen uygulanır.'**
  String get onboardingDisplayDescription;

  /// No description provided for @onboardingAccessibilityTitle.
  ///
  /// In tr, this message translates to:
  /// **'Erişilebilirlik'**
  String get onboardingAccessibilityTitle;

  /// No description provided for @onboardingAccessibilityDescription.
  ///
  /// In tr, this message translates to:
  /// **'Vakıf Atlas ekran okuyucu (TalkBack, VoiceOver), klavye ve büyük metinle kullanılabilir. Metin boyutu, yüksek kontrast, renk görme, hareket ve titreşim tercihlerini tek sayfadan ayarlayın; sonra hesap menüsündeki Erişilebilirlik\'ten de değiştirebilirsiniz.'**
  String get onboardingAccessibilityDescription;

  /// No description provided for @onboardingChangeLaterNote.
  ///
  /// In tr, this message translates to:
  /// **'Bu tercihleri istediğiniz zaman Ayarlar\'dan değiştirebilirsiniz.'**
  String get onboardingChangeLaterNote;

  /// No description provided for @onboardingTourTitle.
  ///
  /// In tr, this message translates to:
  /// **'Vakıf Atlas\'ı tanıyın'**
  String get onboardingTourTitle;

  /// No description provided for @onboardingTourDescription.
  ///
  /// In tr, this message translates to:
  /// **'Uygulamayı nasıl kullanacağınıza kısa bir bakış.'**
  String get onboardingTourDescription;

  /// No description provided for @onboardingTourMapTitle.
  ///
  /// In tr, this message translates to:
  /// **'Haritada keşfedin'**
  String get onboardingTourMapTitle;

  /// No description provided for @onboardingTourMapBody.
  ///
  /// In tr, this message translates to:
  /// **'Eserler haritada gruplanarak gösterilir. Bir gruba dokunarak yakınlaşın; bir esere dokunarak ayrıntılarını ve fotoğraflarını açın.'**
  String get onboardingTourMapBody;

  /// No description provided for @onboardingTourSearchTitle.
  ///
  /// In tr, this message translates to:
  /// **'Arayın ve filtreleyin'**
  String get onboardingTourSearchTitle;

  /// No description provided for @onboardingTourSearchBody.
  ///
  /// In tr, this message translates to:
  /// **'Eser, il veya ilçe adıyla arayın; yapı türü, dönem ve ile göre daraltın ve sonuçları haritada görün.'**
  String get onboardingTourSearchBody;

  /// No description provided for @onboardingTourRoutesTitle.
  ///
  /// In tr, this message translates to:
  /// **'Rotanızı planlayın'**
  String get onboardingTourRoutesTitle;

  /// No description provided for @onboardingTourRoutesBody.
  ///
  /// In tr, this message translates to:
  /// **'2–10 eserden gezi rotası oluşturun, sırayı tek dokunuşla en kısa yola göre düzenleyin. Rotalarınız hesap gerektirmeden bu cihaza bağlı olarak saklanır.'**
  String get onboardingTourRoutesBody;

  /// No description provided for @onboardingTourContributeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Katkıda bulunun'**
  String get onboardingTourContributeTitle;

  /// No description provided for @onboardingTourContributeBody.
  ///
  /// In tr, this message translates to:
  /// **'Hesabınızla Anı Köşesi\'nde eserlerle ilgili anılarınızı paylaşabilir, gördüğünüz hasarları bildirebilirsiniz.'**
  String get onboardingTourContributeBody;

  /// No description provided for @onboardingPermissionsTitle.
  ///
  /// In tr, this message translates to:
  /// **'İzinler'**
  String get onboardingPermissionsTitle;

  /// No description provided for @onboardingPermissionsDescription.
  ///
  /// In tr, this message translates to:
  /// **'İzinler yalnızca ilgili özellik için, nedeni açıklanarak istenir. Hiçbiri zorunlu değildir; izin vermeden de uygulamayı kullanabilirsiniz.'**
  String get onboardingPermissionsDescription;

  /// No description provided for @onboardingPermissionsChangeLater.
  ///
  /// In tr, this message translates to:
  /// **'İzinleri istediğiniz zaman Ayarlar\'dan veya cihazınızın sistem ayarlarından değiştirebilirsiniz.'**
  String get onboardingPermissionsChangeLater;

  /// No description provided for @onboardingPrivacyNoticeLink.
  ///
  /// In tr, this message translates to:
  /// **'KVKK Aydınlatma Metni\'ni okuyun'**
  String get onboardingPrivacyNoticeLink;

  /// No description provided for @onboardingAccountTitle.
  ///
  /// In tr, this message translates to:
  /// **'Nasıl devam etmek istersiniz?'**
  String get onboardingAccountTitle;

  /// No description provided for @onboardingAccountDescription.
  ///
  /// In tr, this message translates to:
  /// **'Harita, arama ve rota planlama için hesap gerekmez. Anı paylaşmak ve hasar bildirmek için giriş yapın.'**
  String get onboardingAccountDescription;

  /// No description provided for @onboardingSignIn.
  ///
  /// In tr, this message translates to:
  /// **'Giriş yap'**
  String get onboardingSignIn;

  /// No description provided for @onboardingCreateAccount.
  ///
  /// In tr, this message translates to:
  /// **'Hesap oluştur'**
  String get onboardingCreateAccount;

  /// No description provided for @onboardingContinueAsGuest.
  ///
  /// In tr, this message translates to:
  /// **'Misafir olarak devam et'**
  String get onboardingContinueAsGuest;

  /// No description provided for @onboardingSignedInTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hoş geldiniz, {name}'**
  String onboardingSignedInTitle(String name);

  /// No description provided for @onboardingSignedInDescription.
  ///
  /// In tr, this message translates to:
  /// **'Oturumunuz açık ve tercihleriniz kaydedildi.'**
  String get onboardingSignedInDescription;

  /// No description provided for @onboardingContinueSignedIn.
  ///
  /// In tr, this message translates to:
  /// **'Uygulamaya devam et'**
  String get onboardingContinueSignedIn;

  /// No description provided for @routePickerSearchHint.
  ///
  /// In tr, this message translates to:
  /// **'Rotaya eklenecek eseri ara'**
  String get routePickerSearchHint;

  /// No description provided for @routePickerStopSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'{details} · {position}. durak'**
  String routePickerStopSubtitle(String details, int position);

  /// No description provided for @routeExportAction.
  ///
  /// In tr, this message translates to:
  /// **'PDF olarak dışa aktar'**
  String get routeExportAction;

  /// No description provided for @routeExportInProgress.
  ///
  /// In tr, this message translates to:
  /// **'PDF hazırlanıyor'**
  String get routeExportInProgress;

  /// No description provided for @routeExportReadyTitle.
  ///
  /// In tr, this message translates to:
  /// **'PDF hazır'**
  String get routeExportReadyTitle;

  /// No description provided for @routeExportReadyAnnouncement.
  ///
  /// In tr, this message translates to:
  /// **'PDF hazır: {fileName}'**
  String routeExportReadyAnnouncement(String fileName);

  /// No description provided for @routeExportSavedNote.
  ///
  /// In tr, this message translates to:
  /// **'Dışa aktarımlarım\'a kaydedildi.'**
  String get routeExportSavedNote;

  /// No description provided for @routeExportGuestSavedNote.
  ///
  /// In tr, this message translates to:
  /// **'Bu cihazın Dışa aktarımlarım listesine kaydedildi. Giriş yaparsanız hesabınıza taşınır ve diğer cihazlarınızda da görünür.'**
  String get routeExportGuestSavedNote;

  /// No description provided for @routeExportOpenExports.
  ///
  /// In tr, this message translates to:
  /// **'Dışa aktarımlarım'**
  String get routeExportOpenExports;

  /// No description provided for @routeExportArchiveFailed.
  ///
  /// In tr, this message translates to:
  /// **'PDF hazır ancak Dışa aktarımlarım\'a kaydedilemedi. Yine de paylaşabilir veya yazdırabilirsiniz.'**
  String get routeExportArchiveFailed;

  /// No description provided for @routeExportFailed.
  ///
  /// In tr, this message translates to:
  /// **'PDF oluşturulamadı. Lütfen tekrar deneyin.'**
  String get routeExportFailed;

  /// No description provided for @routeExportShare.
  ///
  /// In tr, this message translates to:
  /// **'Paylaş'**
  String get routeExportShare;

  /// No description provided for @routeExportCopyLink.
  ///
  /// In tr, this message translates to:
  /// **'Bağlantıyı kopyala'**
  String get routeExportCopyLink;

  /// No description provided for @routeExportLinkCopied.
  ///
  /// In tr, this message translates to:
  /// **'Bağlantı kopyalandı. Bağlantıya sahip herkes PDF\'i {date} tarihine kadar açabilir; dışa aktarımı silerseniz bağlantı çalışmaz.'**
  String routeExportLinkCopied(String date);

  /// No description provided for @routeExportPrint.
  ///
  /// In tr, this message translates to:
  /// **'Yazdır'**
  String get routeExportPrint;

  /// No description provided for @routeExportPreview.
  ///
  /// In tr, this message translates to:
  /// **'Önizle'**
  String get routeExportPreview;

  /// No description provided for @routeExportSignIn.
  ///
  /// In tr, this message translates to:
  /// **'Giriş yap'**
  String get routeExportSignIn;

  /// No description provided for @routeExportShareFailed.
  ///
  /// In tr, this message translates to:
  /// **'Paylaşım penceresi açılamadı.'**
  String get routeExportShareFailed;

  /// No description provided for @routeExportPrintFailed.
  ///
  /// In tr, this message translates to:
  /// **'Yazdırma penceresi açılamadı.'**
  String get routeExportPrintFailed;

  /// No description provided for @routeExportSketchHeading.
  ///
  /// In tr, this message translates to:
  /// **'Rota çizimi'**
  String get routeExportSketchHeading;

  /// No description provided for @routeExportSketchCaption.
  ///
  /// In tr, this message translates to:
  /// **'Şematik çizimdir, kuzey yukarıdadır. Numaralar aşağıdaki durak listesine karşılık gelir; içi dolu işaret başlangıç durağıdır.'**
  String get routeExportSketchCaption;

  /// No description provided for @routeExportStopsHeading.
  ///
  /// In tr, this message translates to:
  /// **'Duraklar ve yolculuk'**
  String get routeExportStopsHeading;

  /// No description provided for @routeExportMapLink.
  ///
  /// In tr, this message translates to:
  /// **'Konumu haritada aç'**
  String get routeExportMapLink;

  /// No description provided for @routeExportAttribution.
  ///
  /// In tr, this message translates to:
  /// **'Yol verisi © OpenStreetMap katkıcıları (ODbL); mesafe ve süreler OSRM ile hesaplanmıştır.'**
  String get routeExportAttribution;

  /// No description provided for @routeExportPageOf.
  ///
  /// In tr, this message translates to:
  /// **'Sayfa {page} / {total}'**
  String routeExportPageOf(String page, String total);

  /// No description provided for @routeExportGeneratedOn.
  ///
  /// In tr, this message translates to:
  /// **'Hazırlanma: {date}'**
  String routeExportGeneratedOn(String date);

  /// No description provided for @routeExportsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Dışa aktarımlarım'**
  String get routeExportsTitle;

  /// No description provided for @routeExportsEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Henüz dışa aktarım yok'**
  String get routeExportsEmptyTitle;

  /// No description provided for @routeExportsEmptyBody.
  ///
  /// In tr, this message translates to:
  /// **'Bir rotanın sayfasındaki PDF simgesine dokunduğunuzda dışa aktarım burada görünür.'**
  String get routeExportsEmptyBody;

  /// No description provided for @routeExportsItemSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'{date} · {stops} · {size}'**
  String routeExportsItemSubtitle(String date, String stops, String size);

  /// No description provided for @routeExportsMoreActions.
  ///
  /// In tr, this message translates to:
  /// **'{name} için işlemler'**
  String routeExportsMoreActions(String name);

  /// No description provided for @routeExportsDelete.
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get routeExportsDelete;

  /// No description provided for @routeExportsDeleteConfirmTitle.
  ///
  /// In tr, this message translates to:
  /// **'Dışa aktarım silinsin mi?'**
  String get routeExportsDeleteConfirmTitle;

  /// No description provided for @routeExportsDeleteConfirmBody.
  ///
  /// In tr, this message translates to:
  /// **'“{name}” PDF\'i arşivinizden kalıcı olarak silinecek. Rotanın kendisi silinmez.'**
  String routeExportsDeleteConfirmBody(String name);

  /// No description provided for @routeExportsDeleted.
  ///
  /// In tr, this message translates to:
  /// **'Dışa aktarım silindi'**
  String get routeExportsDeleted;

  /// No description provided for @routeExportsLoadFailedTitle.
  ///
  /// In tr, this message translates to:
  /// **'Dışa aktarımlar yüklenemedi'**
  String get routeExportsLoadFailedTitle;

  /// No description provided for @fileSizeKilobytes.
  ///
  /// In tr, this message translates to:
  /// **'{size} KB'**
  String fileSizeKilobytes(String size);

  /// No description provided for @fileSizeMegabytes.
  ///
  /// In tr, this message translates to:
  /// **'{size} MB'**
  String fileSizeMegabytes(String size);

  /// No description provided for @memoryCornerSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Ziyaretçilerin bu esere dair anıları'**
  String get memoryCornerSubtitle;

  /// No description provided for @memoryCount.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =0{Henüz anı yok} =1{1 anı} other{{count} anı}}'**
  String memoryCount(int count);

  /// No description provided for @memoryShare.
  ///
  /// In tr, this message translates to:
  /// **'Anı paylaş'**
  String get memoryShare;

  /// No description provided for @memoryViewAll.
  ///
  /// In tr, this message translates to:
  /// **'Tüm anıları gör ({count})'**
  String memoryViewAll(int count);

  /// No description provided for @memoryEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Henüz anı paylaşılmamış'**
  String get memoryEmptyTitle;

  /// No description provided for @memoryEmptyBody.
  ///
  /// In tr, this message translates to:
  /// **'Bu eseri ziyaret ettiyseniz ilk anıyı siz paylaşın.'**
  String get memoryEmptyBody;

  /// No description provided for @memoryLoading.
  ///
  /// In tr, this message translates to:
  /// **'Anılar yükleniyor'**
  String get memoryLoading;

  /// No description provided for @memoryLoadFailedTitle.
  ///
  /// In tr, this message translates to:
  /// **'Anılar yüklenemedi'**
  String get memoryLoadFailedTitle;

  /// No description provided for @memoryLoadMoreFailed.
  ///
  /// In tr, this message translates to:
  /// **'Daha fazla anı yüklenemedi.'**
  String get memoryLoadMoreFailed;

  /// No description provided for @myMemoriesTitle.
  ///
  /// In tr, this message translates to:
  /// **'Anılarım'**
  String get myMemoriesTitle;

  /// No description provided for @myMemoriesViewAll.
  ///
  /// In tr, this message translates to:
  /// **'Tüm anılarım ({count})'**
  String myMemoriesViewAll(int count);

  /// No description provided for @myMemoriesEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Henüz anı paylaşmadınız'**
  String get myMemoriesEmptyTitle;

  /// No description provided for @myMemoriesEmptyBody.
  ///
  /// In tr, this message translates to:
  /// **'Ziyaret ettiğiniz bir eserin Anı Köşesi\'nde fotoğraf ve notla anınızı paylaşın.'**
  String get myMemoriesEmptyBody;

  /// No description provided for @myMemoriesLoading.
  ///
  /// In tr, this message translates to:
  /// **'Anılarınız yükleniyor'**
  String get myMemoriesLoading;

  /// No description provided for @myMemoriesLoadFailed.
  ///
  /// In tr, this message translates to:
  /// **'Anılarınız yüklenemedi.'**
  String get myMemoriesLoadFailed;

  /// No description provided for @myMemoriesUnknownMonument.
  ///
  /// In tr, this message translates to:
  /// **'Vakıf eseri'**
  String get myMemoriesUnknownMonument;

  /// No description provided for @myMemoriesOpenCorner.
  ///
  /// In tr, this message translates to:
  /// **'Anı Köşesi\'nde gör'**
  String get myMemoriesOpenCorner;

  /// No description provided for @myMemoriesOpenCornerSemantics.
  ///
  /// In tr, this message translates to:
  /// **'{name} Anı Köşesi\'nde gör'**
  String myMemoriesOpenCornerSemantics(String name);

  /// No description provided for @myMemoriesPreviewSemantics.
  ///
  /// In tr, this message translates to:
  /// **'{name}, {date}: {text}'**
  String myMemoriesPreviewSemantics(String name, String date, String text);

  /// No description provided for @myMemoriesStatusPending.
  ///
  /// In tr, this message translates to:
  /// **'İnceleniyor; onaylanınca Anı Köşesi\'nde yayınlanır. O zamana kadar yalnızca burada görünür.'**
  String get myMemoriesStatusPending;

  /// No description provided for @myMemoriesStatusRejected.
  ///
  /// In tr, this message translates to:
  /// **'Topluluk kurallarına uymadığı için yayınlanmadı; Anı Köşesi\'nde görünmez, yalnızca burada görünür.'**
  String get myMemoriesStatusRejected;

  /// No description provided for @memoryOwnBadge.
  ///
  /// In tr, this message translates to:
  /// **'Siz'**
  String get memoryOwnBadge;

  /// No description provided for @memoryVisited.
  ///
  /// In tr, this message translates to:
  /// **'Ziyaret: {date}'**
  String memoryVisited(String date);

  /// No description provided for @memoryCardSemantics.
  ///
  /// In tr, this message translates to:
  /// **'{author} tarafından {date} tarihinde paylaşıldı'**
  String memoryCardSemantics(String author, String date);

  /// No description provided for @memoryOwnCardSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Sizin anınız, {date} tarihinde paylaşıldı'**
  String memoryOwnCardSemantics(String date);

  /// No description provided for @memoryReadMore.
  ///
  /// In tr, this message translates to:
  /// **'Devamını oku'**
  String get memoryReadMore;

  /// No description provided for @memoryReadLess.
  ///
  /// In tr, this message translates to:
  /// **'Daha az göster'**
  String get memoryReadLess;

  /// No description provided for @memoryMoreActions.
  ///
  /// In tr, this message translates to:
  /// **'{author} anısı için diğer işlemler'**
  String memoryMoreActions(String author);

  /// No description provided for @memoryDelete.
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get memoryDelete;

  /// No description provided for @memoryReport.
  ///
  /// In tr, this message translates to:
  /// **'Bildir'**
  String get memoryReport;

  /// No description provided for @memoryDeleteConfirmTitle.
  ///
  /// In tr, this message translates to:
  /// **'Anı silinsin mi?'**
  String get memoryDeleteConfirmTitle;

  /// No description provided for @memoryDeleteConfirmBody.
  ///
  /// In tr, this message translates to:
  /// **'Bu anı ve fotoğrafları herkes için kalıcı olarak silinecek.'**
  String get memoryDeleteConfirmBody;

  /// No description provided for @memoryDeleted.
  ///
  /// In tr, this message translates to:
  /// **'Anınız silindi'**
  String get memoryDeleted;

  /// No description provided for @memoryReportTitle.
  ///
  /// In tr, this message translates to:
  /// **'Anıyı bildir'**
  String get memoryReportTitle;

  /// No description provided for @memoryReportQuestion.
  ///
  /// In tr, this message translates to:
  /// **'Bu anı neden uygun değil?'**
  String get memoryReportQuestion;

  /// No description provided for @memoryReportReasonOffensive.
  ///
  /// In tr, this message translates to:
  /// **'Nefret söylemi, taciz veya hakaret'**
  String get memoryReportReasonOffensive;

  /// No description provided for @memoryReportReasonInappropriate.
  ///
  /// In tr, this message translates to:
  /// **'Müstehcen, şiddet içeren veya rahatsız edici'**
  String get memoryReportReasonInappropriate;

  /// No description provided for @memoryReportReasonSpam.
  ///
  /// In tr, this message translates to:
  /// **'Reklam veya spam'**
  String get memoryReportReasonSpam;

  /// No description provided for @memoryReportReasonPersonalInfo.
  ///
  /// In tr, this message translates to:
  /// **'Başkalarının kişisel bilgilerini içeriyor'**
  String get memoryReportReasonPersonalInfo;

  /// No description provided for @memoryReportReasonUnrelated.
  ///
  /// In tr, this message translates to:
  /// **'Bu eserle ilgisi yok'**
  String get memoryReportReasonUnrelated;

  /// No description provided for @memoryReportReasonOther.
  ///
  /// In tr, this message translates to:
  /// **'Diğer'**
  String get memoryReportReasonOther;

  /// No description provided for @memoryReportNoteLabel.
  ///
  /// In tr, this message translates to:
  /// **'Açıklama (isteğe bağlı)'**
  String get memoryReportNoteLabel;

  /// No description provided for @memoryReportReasonRequired.
  ///
  /// In tr, this message translates to:
  /// **'Bir neden seçin.'**
  String get memoryReportReasonRequired;

  /// No description provided for @memoryReportNotice.
  ///
  /// In tr, this message translates to:
  /// **'Bildiriminiz Vakıflar Genel Müdürlüğü tarafından incelenir. Bildirdiğiniz anı artık size gösterilmez.'**
  String get memoryReportNotice;

  /// No description provided for @memoryReported.
  ///
  /// In tr, this message translates to:
  /// **'Bildiriminiz alındı, teşekkür ederiz'**
  String get memoryReported;

  /// No description provided for @memorySignInTitle.
  ///
  /// In tr, this message translates to:
  /// **'Giriş yapmanız gerekiyor'**
  String get memorySignInTitle;

  /// No description provided for @memorySignInToShare.
  ///
  /// In tr, this message translates to:
  /// **'Anı paylaşmak için giriş yapın. Anıları okumak için giriş gerekmez.'**
  String get memorySignInToShare;

  /// No description provided for @memorySignInToReport.
  ///
  /// In tr, this message translates to:
  /// **'Bir anıyı bildirmek için giriş yapın.'**
  String get memorySignInToReport;

  /// No description provided for @memoryComposerClose.
  ///
  /// In tr, this message translates to:
  /// **'Anı paylaşmayı kapat'**
  String get memoryComposerClose;

  /// No description provided for @memoryTextLabel.
  ///
  /// In tr, this message translates to:
  /// **'Anınız'**
  String get memoryTextLabel;

  /// No description provided for @memoryTextHint.
  ///
  /// In tr, this message translates to:
  /// **'Bu eserde neler yaşadınız, neler dikkatinizi çekti?'**
  String get memoryTextHint;

  /// No description provided for @memoryTextEmptyError.
  ///
  /// In tr, this message translates to:
  /// **'Anınızı yazın.'**
  String get memoryTextEmptyError;

  /// No description provided for @memoryTextTooLongError.
  ///
  /// In tr, this message translates to:
  /// **'Anı en fazla {max} karakter olabilir.'**
  String memoryTextTooLongError(int max);

  /// No description provided for @photosHeading.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraflar'**
  String get photosHeading;

  /// No description provided for @photosHint.
  ///
  /// In tr, this message translates to:
  /// **'İsteğe bağlı · en fazla {max} fotoğraf'**
  String photosHint(int max);

  /// No description provided for @photosCountSemantics.
  ///
  /// In tr, this message translates to:
  /// **'{max} fotoğraftan {count} tanesi eklendi'**
  String photosCountSemantics(int count, int max);

  /// No description provided for @photoAdd.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf ekle'**
  String get photoAdd;

  /// No description provided for @photoTake.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf çek'**
  String get photoTake;

  /// No description provided for @photoChooseFromGallery.
  ///
  /// In tr, this message translates to:
  /// **'Galeriden seç'**
  String get photoChooseFromGallery;

  /// No description provided for @photoRemove.
  ///
  /// In tr, this message translates to:
  /// **'{index}. fotoğrafı kaldır'**
  String photoRemove(int index);

  /// No description provided for @photoAddDescription.
  ///
  /// In tr, this message translates to:
  /// **'Açıklama ekle'**
  String get photoAddDescription;

  /// No description provided for @photoEditDescription.
  ///
  /// In tr, this message translates to:
  /// **'Açıklamayı düzenle'**
  String get photoEditDescription;

  /// No description provided for @photoDraftSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf {index}: {description}'**
  String photoDraftSemantics(int index, String description);

  /// No description provided for @photoDraftNoDescription.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf {index}, açıklama eklenmedi'**
  String photoDraftNoDescription(int index);

  /// No description provided for @photoDescriptionAction.
  ///
  /// In tr, this message translates to:
  /// **'{index}. fotoğraf için açıklama'**
  String photoDescriptionAction(int index);

  /// No description provided for @photoProcessing.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf hazırlanıyor'**
  String get photoProcessing;

  /// No description provided for @photoDescriptionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf açıklaması'**
  String get photoDescriptionTitle;

  /// No description provided for @photoDescriptionLabel.
  ///
  /// In tr, this message translates to:
  /// **'Açıklama'**
  String get photoDescriptionLabel;

  /// No description provided for @photoDescriptionHelper.
  ///
  /// In tr, this message translates to:
  /// **'Ekran okuyucu kullananlar için fotoğrafta ne göründüğünü kısaca anlatın.'**
  String get photoDescriptionHelper;

  /// No description provided for @photoDescriptionTooLong.
  ///
  /// In tr, this message translates to:
  /// **'Açıklama en fazla {max} karakter olabilir.'**
  String photoDescriptionTooLong(int max);

  /// No description provided for @commonSave.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get commonSave;

  /// No description provided for @photoCameraDenied.
  ///
  /// In tr, this message translates to:
  /// **'Kamera izni verilmedi. İzni cihaz ayarlarından verebilirsiniz.'**
  String get photoCameraDenied;

  /// No description provided for @photoCameraDeniedBrowser.
  ///
  /// In tr, this message translates to:
  /// **'Kamera izni verilmedi. Tarayıcınızın adres çubuğundaki kamera simgesinden veya site ayarlarından izin verebilirsiniz.'**
  String get photoCameraDeniedBrowser;

  /// No description provided for @cameraCaptureTitle.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf çek'**
  String get cameraCaptureTitle;

  /// No description provided for @cameraCaptureOpening.
  ///
  /// In tr, this message translates to:
  /// **'Kamera açılıyor. Tarayıcınız izin isterse onaylayın.'**
  String get cameraCaptureOpening;

  /// No description provided for @cameraCaptureReady.
  ///
  /// In tr, this message translates to:
  /// **'Kamera hazır. Fotoğrafı çekmek için deklanşöre dokunun.'**
  String get cameraCaptureReady;

  /// No description provided for @cameraCaptureShutter.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğrafı çek'**
  String get cameraCaptureShutter;

  /// No description provided for @cameraCaptureSwitch.
  ///
  /// In tr, this message translates to:
  /// **'Kamerayı değiştir'**
  String get cameraCaptureSwitch;

  /// No description provided for @cameraCaptureCapturing.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf çekiliyor'**
  String get cameraCaptureCapturing;

  /// No description provided for @cameraCaptureDeniedTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kamera izni verilmedi'**
  String get cameraCaptureDeniedTitle;

  /// No description provided for @cameraCaptureDeniedBody.
  ///
  /// In tr, this message translates to:
  /// **'Tarayıcınızın adres çubuğundaki kamera simgesinden veya site ayarlarından bu siteye kamera izni verip tekrar deneyin.'**
  String get cameraCaptureDeniedBody;

  /// No description provided for @cameraCaptureNoCameraTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kamera bulunamadı'**
  String get cameraCaptureNoCameraTitle;

  /// No description provided for @cameraCaptureNoCameraBody.
  ///
  /// In tr, this message translates to:
  /// **'Bu cihazda kullanılabilir kamera yok. Fotoğrafı galeriden seçebilirsiniz.'**
  String get cameraCaptureNoCameraBody;

  /// No description provided for @cameraCaptureFailedTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kamera açılamadı'**
  String get cameraCaptureFailedTitle;

  /// No description provided for @cameraCaptureFailedBody.
  ///
  /// In tr, this message translates to:
  /// **'Kamera başka bir uygulama tarafından kullanılıyor olabilir. Kapatıp tekrar deneyin.'**
  String get cameraCaptureFailedBody;

  /// No description provided for @cameraCaptureShotFailed.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf çekilemedi. Tekrar deneyin.'**
  String get cameraCaptureShotFailed;

  /// No description provided for @photoGalleryDenied.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraflara erişim izni verilmedi. İzni cihaz ayarlarından verebilirsiniz.'**
  String get photoGalleryDenied;

  /// No description provided for @photoPickFailed.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf seçilemedi. Lütfen tekrar deneyin.'**
  String get photoPickFailed;

  /// No description provided for @photoUnsupported.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =1{Bir fotoğraf açılamadı. JPEG, PNG veya WebP biçiminde bir fotoğraf seçin.} other{{count} fotoğraf açılamadı. JPEG, PNG veya WebP biçiminde fotoğraflar seçin.}}'**
  String photoUnsupported(int count);

  /// No description provided for @photoLimitReached.
  ///
  /// In tr, this message translates to:
  /// **'En fazla {max} fotoğraf ekleyebilirsiniz.'**
  String photoLimitReached(int max);

  /// No description provided for @memoryVisitHeading.
  ///
  /// In tr, this message translates to:
  /// **'Ziyaret tarihi'**
  String get memoryVisitHeading;

  /// No description provided for @memoryVisitOptional.
  ///
  /// In tr, this message translates to:
  /// **'İsteğe bağlı'**
  String get memoryVisitOptional;

  /// No description provided for @memoryVisitPick.
  ///
  /// In tr, this message translates to:
  /// **'Tarih seçin'**
  String get memoryVisitPick;

  /// No description provided for @memoryVisitChange.
  ///
  /// In tr, this message translates to:
  /// **'Ziyaret tarihi: {date}. Değiştir'**
  String memoryVisitChange(String date);

  /// No description provided for @memoryVisitClear.
  ///
  /// In tr, this message translates to:
  /// **'Ziyaret tarihini kaldır'**
  String get memoryVisitClear;

  /// No description provided for @memoryPublicNotice.
  ///
  /// In tr, this message translates to:
  /// **'Anınız herkese açık olarak bu eserin sayfasında “{name}” adıyla görünür. Fotoğraflardaki konum ve cihaz bilgileri yüklenmeden önce silinir. Lütfen başkalarının kişisel bilgilerini paylaşmayın.'**
  String memoryPublicNotice(String name);

  /// No description provided for @memorySubmit.
  ///
  /// In tr, this message translates to:
  /// **'Paylaş'**
  String get memorySubmit;

  /// No description provided for @photosUploading.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraflar yükleniyor · %{percent}'**
  String photosUploading(int percent);

  /// No description provided for @photosUploadingSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf yükleme ilerlemesi'**
  String get photosUploadingSemantics;

  /// No description provided for @memoryShared.
  ///
  /// In tr, this message translates to:
  /// **'Anınız paylaşıldı'**
  String get memoryShared;

  /// No description provided for @memoryFixErrors.
  ///
  /// In tr, this message translates to:
  /// **'Paylaşmadan önce işaretli alanları düzeltin.'**
  String get memoryFixErrors;

  /// No description provided for @memoryDiscardTitle.
  ///
  /// In tr, this message translates to:
  /// **'Anı taslağı silinsin mi?'**
  String get memoryDiscardTitle;

  /// No description provided for @memoryDiscardBody.
  ///
  /// In tr, this message translates to:
  /// **'Yazdıklarınız ve eklediğiniz fotoğraflar kaybolacak.'**
  String get memoryDiscardBody;

  /// No description provided for @memoryDiscardConfirm.
  ///
  /// In tr, this message translates to:
  /// **'Taslağı sil'**
  String get memoryDiscardConfirm;

  /// No description provided for @memoryKeepEditing.
  ///
  /// In tr, this message translates to:
  /// **'Düzenlemeye devam et'**
  String get memoryKeepEditing;

  /// No description provided for @memoryPhotoNoDescription.
  ///
  /// In tr, this message translates to:
  /// **'Paylaşan kişi bu fotoğraf için açıklama eklememiş.'**
  String get memoryPhotoNoDescription;

  /// No description provided for @memoryPhotoCredit.
  ///
  /// In tr, this message translates to:
  /// **'{author} · {date}'**
  String memoryPhotoCredit(String author, String date);

  /// No description provided for @photoTileSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf {index} / {count}: {description}'**
  String photoTileSemantics(int index, int count, String description);

  /// No description provided for @photoTileNoDescription.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf {index} / {count}, açıklama yok'**
  String photoTileNoDescription(int index, int count);

  /// No description provided for @photoOpenHint.
  ///
  /// In tr, this message translates to:
  /// **'tam ekran aç'**
  String get photoOpenHint;

  /// No description provided for @memoryEntryOpenHint.
  ///
  /// In tr, this message translates to:
  /// **'zaman çizelgesini aç'**
  String get memoryEntryOpenHint;

  /// No description provided for @memoryEntryLatest.
  ///
  /// In tr, this message translates to:
  /// **'Son anı'**
  String get memoryEntryLatest;

  /// No description provided for @memoryEntrySemantics.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =0{Anı Köşesi, henüz anı yok} =1{Anı Köşesi, 1 anı} other{Anı Köşesi, {count} anı}}'**
  String memoryEntrySemantics(int count);

  /// No description provided for @memorySharedOn.
  ///
  /// In tr, this message translates to:
  /// **'Paylaşım: {date}'**
  String memorySharedOn(String date);

  /// No description provided for @memoryFilterHeading.
  ///
  /// In tr, this message translates to:
  /// **'Zamana göre filtrele'**
  String get memoryFilterHeading;

  /// No description provided for @memoryFilterAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümü ({count})'**
  String memoryFilterAll(int count);

  /// No description provided for @memoryFilterYear.
  ///
  /// In tr, this message translates to:
  /// **'{year} ({count})'**
  String memoryFilterYear(String year, int count);

  /// No description provided for @memoryFilterYearSemantics.
  ///
  /// In tr, this message translates to:
  /// **'{year} yılı, {count} anı'**
  String memoryFilterYearSemantics(String year, int count);

  /// No description provided for @memoryFilterRange.
  ///
  /// In tr, this message translates to:
  /// **'Tarih aralığı'**
  String get memoryFilterRange;

  /// No description provided for @memoryFilterRangeHelp.
  ///
  /// In tr, this message translates to:
  /// **'Anı tarihi aralığı seçin'**
  String get memoryFilterRangeHelp;

  /// No description provided for @memoryFilterClearRange.
  ///
  /// In tr, this message translates to:
  /// **'Tarih aralığını kaldır'**
  String get memoryFilterClearRange;

  /// No description provided for @memoryFilterEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bu dönemde anı yok'**
  String get memoryFilterEmptyTitle;

  /// No description provided for @memoryFilterEmptyBody.
  ///
  /// In tr, this message translates to:
  /// **'Farklı bir yıl veya tarih aralığı seçin.'**
  String get memoryFilterEmptyBody;

  /// No description provided for @memoryFilterClear.
  ///
  /// In tr, this message translates to:
  /// **'Filtreyi temizle'**
  String get memoryFilterClear;

  /// No description provided for @memoryFilterResult.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =0{Bu dönemde anı yok} =1{1 anı gösteriliyor} other{{count} anı gösteriliyor}}'**
  String memoryFilterResult(int count);

  /// No description provided for @memoryTimelineHint.
  ///
  /// In tr, this message translates to:
  /// **'Anılar ziyaret tarihine (yoksa paylaşım tarihine) göre sıralanır.'**
  String get memoryTimelineHint;

  /// No description provided for @navCivilProtection.
  ///
  /// In tr, this message translates to:
  /// **'Sivil Koruma'**
  String get navCivilProtection;

  /// No description provided for @cpIntroTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kültürel mirası birlikte koruyalım'**
  String get cpIntroTitle;

  /// No description provided for @cpIntroBody.
  ///
  /// In tr, this message translates to:
  /// **'Vakıf eserlerinde gördüğünüz hasarı, vandalizmi veya tehlikeyi Vakıflar Genel Müdürlüğü\'ne bildirin. Her bildirime bir kayıt numarası verilir ve süreci buradan takip edersiniz.'**
  String get cpIntroBody;

  /// No description provided for @cpIntroStep1Title.
  ///
  /// In tr, this message translates to:
  /// **'Eseri ve durumu seçin'**
  String get cpIntroStep1Title;

  /// No description provided for @cpIntroStep1Body.
  ///
  /// In tr, this message translates to:
  /// **'Hasar türünü ve ne kadar acil olduğunu belirtin.'**
  String get cpIntroStep1Body;

  /// No description provided for @cpIntroStep2Title.
  ///
  /// In tr, this message translates to:
  /// **'Anlatın ve fotoğraflayın'**
  String get cpIntroStep2Title;

  /// No description provided for @cpIntroStep2Body.
  ///
  /// In tr, this message translates to:
  /// **'Ne gördüğünüzü yazın; fotoğraflar değerlendirmeyi hızlandırır.'**
  String get cpIntroStep2Body;

  /// No description provided for @cpIntroStep3Title.
  ///
  /// In tr, this message translates to:
  /// **'Süreci takip edin'**
  String get cpIntroStep3Title;

  /// No description provided for @cpIntroStep3Body.
  ///
  /// In tr, this message translates to:
  /// **'VGM\'nin incelemesini ve yaptığı işlemi bu ekrandan izleyin.'**
  String get cpIntroStep3Body;

  /// No description provided for @cpSignInPrompt.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim göndermek ve takip etmek için giriş yapın.'**
  String get cpSignInPrompt;

  /// No description provided for @cpEmergencyNotice.
  ///
  /// In tr, this message translates to:
  /// **'Can güvenliğini tehdit eden acil durumlarda önce 112 Acil Çağrı Merkezi\'ni arayın.'**
  String get cpEmergencyNotice;

  /// No description provided for @cpNewReport.
  ///
  /// In tr, this message translates to:
  /// **'Hasar bildir'**
  String get cpNewReport;

  /// No description provided for @cpMyReports.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimlerim'**
  String get cpMyReports;

  /// No description provided for @cpReportsEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Henüz bildiriminiz yok'**
  String get cpReportsEmptyTitle;

  /// No description provided for @cpReportsEmptyBody.
  ///
  /// In tr, this message translates to:
  /// **'Bir vakıf eserinde hasar veya tehlike gördüğünüzde buradan bildirebilirsiniz.'**
  String get cpReportsEmptyBody;

  /// No description provided for @cpReportsLoading.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimler yükleniyor'**
  String get cpReportsLoading;

  /// No description provided for @cpReportsLoadFailed.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimler yüklenemedi'**
  String get cpReportsLoadFailed;

  /// No description provided for @cpLoadMoreFailed.
  ///
  /// In tr, this message translates to:
  /// **'Daha fazla bildirim yüklenemedi.'**
  String get cpLoadMoreFailed;

  /// No description provided for @cpReportItemSemantics.
  ///
  /// In tr, this message translates to:
  /// **'{monument}, {category}. Kayıt {reference}. Durum: {status}. {date}'**
  String cpReportItemSemantics(
    String monument,
    String category,
    String reference,
    String status,
    String date,
  );

  /// No description provided for @cpCategoryStructural.
  ///
  /// In tr, this message translates to:
  /// **'Yapısal hasar'**
  String get cpCategoryStructural;

  /// No description provided for @cpCategoryStructuralBody.
  ///
  /// In tr, this message translates to:
  /// **'Çatlak, ayrışma, bozulma'**
  String get cpCategoryStructuralBody;

  /// No description provided for @cpCategoryCollapse.
  ///
  /// In tr, this message translates to:
  /// **'Çökme veya düşme tehlikesi'**
  String get cpCategoryCollapse;

  /// No description provided for @cpCategoryCollapseBody.
  ///
  /// In tr, this message translates to:
  /// **'Gevşemiş taş, sarkan parça, eğilme'**
  String get cpCategoryCollapseBody;

  /// No description provided for @cpCategoryVandalism.
  ///
  /// In tr, this message translates to:
  /// **'Vandalizm'**
  String get cpCategoryVandalism;

  /// No description provided for @cpCategoryVandalismBody.
  ///
  /// In tr, this message translates to:
  /// **'Yazı, çizim, kırma, tahribat'**
  String get cpCategoryVandalismBody;

  /// No description provided for @cpCategoryTheft.
  ///
  /// In tr, this message translates to:
  /// **'Hırsızlık veya eksik parça'**
  String get cpCategoryTheft;

  /// No description provided for @cpCategoryTheftBody.
  ///
  /// In tr, this message translates to:
  /// **'Çini, kitabe, süsleme veya parça eksik'**
  String get cpCategoryTheftBody;

  /// No description provided for @cpCategoryFireWater.
  ///
  /// In tr, this message translates to:
  /// **'Yangın veya su hasarı'**
  String get cpCategoryFireWater;

  /// No description provided for @cpCategoryFireWaterBody.
  ///
  /// In tr, this message translates to:
  /// **'Yangın izi, su baskını, sızıntı'**
  String get cpCategoryFireWaterBody;

  /// No description provided for @cpCategoryUnauthorized.
  ///
  /// In tr, this message translates to:
  /// **'İzinsiz yapı veya onarım'**
  String get cpCategoryUnauthorized;

  /// No description provided for @cpCategoryUnauthorizedBody.
  ///
  /// In tr, this message translates to:
  /// **'İzinsiz inşaat, kazı veya müdahale'**
  String get cpCategoryUnauthorizedBody;

  /// No description provided for @cpCategoryOther.
  ///
  /// In tr, this message translates to:
  /// **'Diğer'**
  String get cpCategoryOther;

  /// No description provided for @cpCategoryOtherBody.
  ///
  /// In tr, this message translates to:
  /// **'Yukarıdakilere uymayan bir durum'**
  String get cpCategoryOtherBody;

  /// No description provided for @cpUrgencyLow.
  ///
  /// In tr, this message translates to:
  /// **'Düşük'**
  String get cpUrgencyLow;

  /// No description provided for @cpUrgencyLowBody.
  ///
  /// In tr, this message translates to:
  /// **'Acil değil, zamanla kötüleşebilir'**
  String get cpUrgencyLowBody;

  /// No description provided for @cpUrgencyMedium.
  ///
  /// In tr, this message translates to:
  /// **'Orta'**
  String get cpUrgencyMedium;

  /// No description provided for @cpUrgencyMediumBody.
  ///
  /// In tr, this message translates to:
  /// **'Kısa sürede incelenmeli'**
  String get cpUrgencyMediumBody;

  /// No description provided for @cpUrgencyHigh.
  ///
  /// In tr, this message translates to:
  /// **'Yüksek'**
  String get cpUrgencyHigh;

  /// No description provided for @cpUrgencyHighBody.
  ///
  /// In tr, this message translates to:
  /// **'Hasar büyüyor veya ziyaretçileri etkiliyor'**
  String get cpUrgencyHighBody;

  /// No description provided for @cpUrgencyCritical.
  ///
  /// In tr, this message translates to:
  /// **'Kritik'**
  String get cpUrgencyCritical;

  /// No description provided for @cpUrgencyCriticalBody.
  ///
  /// In tr, this message translates to:
  /// **'Yapı veya çevresi için ciddi ve yakın tehlike'**
  String get cpUrgencyCriticalBody;

  /// No description provided for @cpStatusReceived.
  ///
  /// In tr, this message translates to:
  /// **'Alındı'**
  String get cpStatusReceived;

  /// No description provided for @cpStatusInReview.
  ///
  /// In tr, this message translates to:
  /// **'İnceleniyor'**
  String get cpStatusInReview;

  /// No description provided for @cpStatusForwarded.
  ///
  /// In tr, this message translates to:
  /// **'Yetkili birime iletildi'**
  String get cpStatusForwarded;

  /// No description provided for @cpStatusResolved.
  ///
  /// In tr, this message translates to:
  /// **'Sonuçlandı'**
  String get cpStatusResolved;

  /// No description provided for @cpStatusClosed.
  ///
  /// In tr, this message translates to:
  /// **'Kapatıldı'**
  String get cpStatusClosed;

  /// No description provided for @cpStatusReceivedBody.
  ///
  /// In tr, this message translates to:
  /// **'Bildiriminiz kayda alındı.'**
  String get cpStatusReceivedBody;

  /// No description provided for @cpStatusInReviewBody.
  ///
  /// In tr, this message translates to:
  /// **'VGM Sivil Koruma birimi bildiriminizi inceliyor.'**
  String get cpStatusInReviewBody;

  /// No description provided for @cpStatusForwardedBody.
  ///
  /// In tr, this message translates to:
  /// **'Gerekli işlem için yetkili bölge müdürlüğüne iletildi.'**
  String get cpStatusForwardedBody;

  /// No description provided for @cpStatusResolvedBody.
  ///
  /// In tr, this message translates to:
  /// **'Gerekli işlem yapıldı.'**
  String get cpStatusResolvedBody;

  /// No description provided for @cpStatusClosedBody.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim işlem gerektirmeden kapatıldı.'**
  String get cpStatusClosedBody;

  /// No description provided for @cpStatusPending.
  ///
  /// In tr, this message translates to:
  /// **'Bekleniyor'**
  String get cpStatusPending;

  /// No description provided for @cpStatusStepSemantics.
  ///
  /// In tr, this message translates to:
  /// **'{status}, {state}'**
  String cpStatusStepSemantics(String status, String state);

  /// No description provided for @cpStatusDone.
  ///
  /// In tr, this message translates to:
  /// **'tamamlandı'**
  String get cpStatusDone;

  /// No description provided for @cpStatusCurrent.
  ///
  /// In tr, this message translates to:
  /// **'şu anki adım'**
  String get cpStatusCurrent;

  /// No description provided for @cpWizardTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hasar bildirimi'**
  String get cpWizardTitle;

  /// No description provided for @cpWizardClose.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimi kapat'**
  String get cpWizardClose;

  /// No description provided for @cpStepProgress.
  ///
  /// In tr, this message translates to:
  /// **'Adım {current}/{total}: {title}'**
  String cpStepProgress(int current, int total, String title);

  /// No description provided for @cpStepMonument.
  ///
  /// In tr, this message translates to:
  /// **'Eser'**
  String get cpStepMonument;

  /// No description provided for @cpStepCategory.
  ///
  /// In tr, this message translates to:
  /// **'Hasar türü'**
  String get cpStepCategory;

  /// No description provided for @cpStepUrgency.
  ///
  /// In tr, this message translates to:
  /// **'Aciliyet'**
  String get cpStepUrgency;

  /// No description provided for @cpStepDetails.
  ///
  /// In tr, this message translates to:
  /// **'Açıklama ve fotoğraf'**
  String get cpStepDetails;

  /// No description provided for @cpStepLocation.
  ///
  /// In tr, this message translates to:
  /// **'Konum'**
  String get cpStepLocation;

  /// No description provided for @cpStepReview.
  ///
  /// In tr, this message translates to:
  /// **'Gözden geçir'**
  String get cpStepReview;

  /// No description provided for @cpStepMonumentQuestion.
  ///
  /// In tr, this message translates to:
  /// **'Bildiriminiz hangi eserle ilgili?'**
  String get cpStepMonumentQuestion;

  /// No description provided for @cpStepCategoryQuestion.
  ///
  /// In tr, this message translates to:
  /// **'Ne gördünüz?'**
  String get cpStepCategoryQuestion;

  /// No description provided for @cpStepUrgencyQuestion.
  ///
  /// In tr, this message translates to:
  /// **'Ne kadar acil?'**
  String get cpStepUrgencyQuestion;

  /// No description provided for @cpStepDetailsQuestion.
  ///
  /// In tr, this message translates to:
  /// **'Durumu anlatın'**
  String get cpStepDetailsQuestion;

  /// No description provided for @cpStepLocationQuestion.
  ///
  /// In tr, this message translates to:
  /// **'Konumunuzu eklemek ister misiniz?'**
  String get cpStepLocationQuestion;

  /// No description provided for @cpStepReviewQuestion.
  ///
  /// In tr, this message translates to:
  /// **'Bildiriminizi kontrol edin'**
  String get cpStepReviewQuestion;

  /// No description provided for @cpChooseMonument.
  ///
  /// In tr, this message translates to:
  /// **'Eser seç'**
  String get cpChooseMonument;

  /// No description provided for @cpChangeMonument.
  ///
  /// In tr, this message translates to:
  /// **'Eseri değiştir'**
  String get cpChangeMonument;

  /// No description provided for @cpMonumentPickerTitle.
  ///
  /// In tr, this message translates to:
  /// **'Eser seçin'**
  String get cpMonumentPickerTitle;

  /// No description provided for @cpMonumentPickerHint.
  ///
  /// In tr, this message translates to:
  /// **'Eser veya yer ara'**
  String get cpMonumentPickerHint;

  /// No description provided for @cpMonumentLoadFailed.
  ///
  /// In tr, this message translates to:
  /// **'Eser bilgisi alınamadı.'**
  String get cpMonumentLoadFailed;

  /// No description provided for @cpDescriptionLabel.
  ///
  /// In tr, this message translates to:
  /// **'Açıklama'**
  String get cpDescriptionLabel;

  /// No description provided for @cpDescriptionHint.
  ///
  /// In tr, this message translates to:
  /// **'Hasarın yerini ve durumunu anlatın: hangi cephe, ne büyüklükte, ne zamandır…'**
  String get cpDescriptionHint;

  /// No description provided for @cpDescriptionTooShort.
  ///
  /// In tr, this message translates to:
  /// **'En az {min} karakterle açıklayın.'**
  String cpDescriptionTooShort(int min);

  /// No description provided for @cpDescriptionTooLong.
  ///
  /// In tr, this message translates to:
  /// **'Açıklama en fazla {max} karakter olabilir.'**
  String cpDescriptionTooLong(int max);

  /// No description provided for @cpLocationExplain.
  ///
  /// In tr, this message translates to:
  /// **'Konumunuz, bildirimin eserin yanında yapıldığını doğrulamak için yalnızca bu bildirimle VGM\'ye iletilir; başka bir amaçla kullanılmaz. Eklemeden de gönderebilirsiniz.'**
  String get cpLocationExplain;

  /// No description provided for @cpLocationToggle.
  ///
  /// In tr, this message translates to:
  /// **'Konumumu bu bildirime ekle'**
  String get cpLocationToggle;

  /// No description provided for @cpLocationLocating.
  ///
  /// In tr, this message translates to:
  /// **'Konumunuz alınıyor…'**
  String get cpLocationLocating;

  /// No description provided for @cpLocationFound.
  ///
  /// In tr, this message translates to:
  /// **'Konumunuz alındı (±{accuracy} m).'**
  String cpLocationFound(int accuracy);

  /// No description provided for @cpLocationDistance.
  ///
  /// In tr, this message translates to:
  /// **'Esere yaklaşık {distance} uzaklıktasınız.'**
  String cpLocationDistance(String distance);

  /// No description provided for @cpLocationOnSite.
  ///
  /// In tr, this message translates to:
  /// **'Eserin yakınındasınız; bildiriminiz yerinde yapılmış olarak işaretlenecek.'**
  String get cpLocationOnSite;

  /// No description provided for @cpLocationFar.
  ///
  /// In tr, this message translates to:
  /// **'Esere uzaktasınız; bildiriminiz yine de iletilir.'**
  String get cpLocationFar;

  /// No description provided for @cpLocationServiceDisabled.
  ///
  /// In tr, this message translates to:
  /// **'Konum servisleri kapalı. Ayarlardan açabilir veya konumsuz devam edebilirsiniz.'**
  String get cpLocationServiceDisabled;

  /// No description provided for @cpLocationDenied.
  ///
  /// In tr, this message translates to:
  /// **'Konum izni verilmedi. Konumsuz devam edebilirsiniz.'**
  String get cpLocationDenied;

  /// No description provided for @cpLocationDeniedForever.
  ///
  /// In tr, this message translates to:
  /// **'Konum izni kapalı. Ayarlardan izin verebilir veya konumsuz devam edebilirsiniz.'**
  String get cpLocationDeniedForever;

  /// No description provided for @cpLocationUnavailable.
  ///
  /// In tr, this message translates to:
  /// **'Konumunuz şu anda alınamıyor. Tekrar deneyebilir veya konumsuz devam edebilirsiniz.'**
  String get cpLocationUnavailable;

  /// No description provided for @cpLocationUnsupported.
  ///
  /// In tr, this message translates to:
  /// **'Bu cihazda konum eklenemiyor.'**
  String get cpLocationUnsupported;

  /// No description provided for @cpReviewEdit.
  ///
  /// In tr, this message translates to:
  /// **'Düzenle'**
  String get cpReviewEdit;

  /// No description provided for @cpReviewEditSemantics.
  ///
  /// In tr, this message translates to:
  /// **'{section} düzenle'**
  String cpReviewEditSemantics(String section);

  /// No description provided for @cpReviewPhotos.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =0{Fotoğraf eklenmedi} =1{1 fotoğraf} other{{count} fotoğraf}}'**
  String cpReviewPhotos(int count);

  /// No description provided for @cpReviewLocationShared.
  ///
  /// In tr, this message translates to:
  /// **'Konum eklendi'**
  String get cpReviewLocationShared;

  /// No description provided for @cpReviewLocationNotShared.
  ///
  /// In tr, this message translates to:
  /// **'Konum eklenmedi'**
  String get cpReviewLocationNotShared;

  /// No description provided for @cpNext.
  ///
  /// In tr, this message translates to:
  /// **'İleri'**
  String get cpNext;

  /// No description provided for @cpBack.
  ///
  /// In tr, this message translates to:
  /// **'Geri'**
  String get cpBack;

  /// No description provided for @cpSubmit.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimi gönder'**
  String get cpSubmit;

  /// No description provided for @cpSubmitted.
  ///
  /// In tr, this message translates to:
  /// **'Bildiriminiz alındı · {code}'**
  String cpSubmitted(String code);

  /// No description provided for @cpFixStep.
  ///
  /// In tr, this message translates to:
  /// **'Devam etmeden önce bu adımı tamamlayın.'**
  String get cpFixStep;

  /// No description provided for @cpMonumentRequired.
  ///
  /// In tr, this message translates to:
  /// **'Bir eser seçin.'**
  String get cpMonumentRequired;

  /// No description provided for @cpCategoryRequired.
  ///
  /// In tr, this message translates to:
  /// **'Bir hasar türü seçin.'**
  String get cpCategoryRequired;

  /// No description provided for @cpUrgencyRequired.
  ///
  /// In tr, this message translates to:
  /// **'Aciliyeti seçin.'**
  String get cpUrgencyRequired;

  /// No description provided for @cpDiscardTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim taslağı silinsin mi?'**
  String get cpDiscardTitle;

  /// No description provided for @cpDiscardBody.
  ///
  /// In tr, this message translates to:
  /// **'Girdiğiniz bilgiler ve fotoğraflar kaybolacak.'**
  String get cpDiscardBody;

  /// No description provided for @cpDiscardConfirm.
  ///
  /// In tr, this message translates to:
  /// **'Taslağı sil'**
  String get cpDiscardConfirm;

  /// No description provided for @cpKeepEditing.
  ///
  /// In tr, this message translates to:
  /// **'Düzenlemeye devam et'**
  String get cpKeepEditing;

  /// No description provided for @cpDetailTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim'**
  String get cpDetailTitle;

  /// No description provided for @cpReferenceLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt numarası'**
  String get cpReferenceLabel;

  /// No description provided for @cpCopyReference.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt numarasını kopyala'**
  String get cpCopyReference;

  /// No description provided for @cpReferenceCopied.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt numarası kopyalandı'**
  String get cpReferenceCopied;

  /// No description provided for @cpStatusHeading.
  ///
  /// In tr, this message translates to:
  /// **'Süreç'**
  String get cpStatusHeading;

  /// No description provided for @cpDetailsHeading.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim bilgileri'**
  String get cpDetailsHeading;

  /// No description provided for @cpCategoryField.
  ///
  /// In tr, this message translates to:
  /// **'Hasar türü'**
  String get cpCategoryField;

  /// No description provided for @cpUrgencyField.
  ///
  /// In tr, this message translates to:
  /// **'Aciliyet'**
  String get cpUrgencyField;

  /// No description provided for @cpDescriptionField.
  ///
  /// In tr, this message translates to:
  /// **'Açıklama'**
  String get cpDescriptionField;

  /// No description provided for @cpPhotosField.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraflar'**
  String get cpPhotosField;

  /// No description provided for @cpLocationField.
  ///
  /// In tr, this message translates to:
  /// **'Konum'**
  String get cpLocationField;

  /// No description provided for @cpLocationOnSiteValue.
  ///
  /// In tr, this message translates to:
  /// **'Yerinde doğrulandı (esere {distance})'**
  String cpLocationOnSiteValue(String distance);

  /// No description provided for @cpLocationDistantValue.
  ///
  /// In tr, this message translates to:
  /// **'Esere {distance} uzaktan bildirildi'**
  String cpLocationDistantValue(String distance);

  /// No description provided for @cpLocationNotProvidedValue.
  ///
  /// In tr, this message translates to:
  /// **'Konum paylaşılmadı'**
  String get cpLocationNotProvidedValue;

  /// No description provided for @cpSubmittedOn.
  ///
  /// In tr, this message translates to:
  /// **'Gönderim: {date}'**
  String cpSubmittedOn(String date);

  /// No description provided for @cpNoteFromVgm.
  ///
  /// In tr, this message translates to:
  /// **'VGM notu'**
  String get cpNoteFromVgm;

  /// No description provided for @cpDetailLoadFailed.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim yüklenemedi'**
  String get cpDetailLoadFailed;

  /// No description provided for @cpNotFoundTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim bulunamadı'**
  String get cpNotFoundTitle;

  /// No description provided for @cpNotFoundBody.
  ///
  /// In tr, this message translates to:
  /// **'Bu bildirim size ait değil veya kaldırılmış.'**
  String get cpNotFoundBody;

  /// No description provided for @cpBackToList.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimlerime dön'**
  String get cpBackToList;

  /// No description provided for @cpPhotoNoDescription.
  ///
  /// In tr, this message translates to:
  /// **'Bu fotoğraf için açıklama eklenmemiş.'**
  String get cpPhotoNoDescription;

  /// No description provided for @cpPhotoCredit.
  ///
  /// In tr, this message translates to:
  /// **'Bildiriminizin fotoğrafı'**
  String get cpPhotoCredit;

  /// No description provided for @monumentReportTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bir sorun mu gördünüz?'**
  String get monumentReportTitle;

  /// No description provided for @monumentReportBody.
  ///
  /// In tr, this message translates to:
  /// **'Bu eserde hasar, vandalizm veya tehlike gördüyseniz Sivil Koruma\'ya bildirin.'**
  String get monumentReportBody;

  /// No description provided for @accountButtonTooltip.
  ///
  /// In tr, this message translates to:
  /// **'Hesap ve ayarlar'**
  String get accountButtonTooltip;

  /// No description provided for @guideWelcomeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Size nasıl yardımcı olabilirim?'**
  String get guideWelcomeTitle;

  /// No description provided for @guideWelcomeBody.
  ///
  /// In tr, this message translates to:
  /// **'Vakıf eserleri hakkında sorun ya da uygulamada ne yapmak istediğinizi yazın; sizi ilgili sayfaya yönlendireyim.'**
  String get guideWelcomeBody;

  /// No description provided for @guideStartersHeading.
  ///
  /// In tr, this message translates to:
  /// **'Örnek sorular'**
  String get guideStartersHeading;

  /// No description provided for @guideStarterMonument.
  ///
  /// In tr, this message translates to:
  /// **'Süleymaniye Camii\'ni kim yaptırdı?'**
  String get guideStarterMonument;

  /// No description provided for @guideStarterList.
  ///
  /// In tr, this message translates to:
  /// **'Konya\'daki Selçuklu eserleri'**
  String get guideStarterList;

  /// No description provided for @guideStarterRoute.
  ///
  /// In tr, this message translates to:
  /// **'Rota nasıl planlarım?'**
  String get guideStarterRoute;

  /// No description provided for @guideStarterDamage.
  ///
  /// In tr, this message translates to:
  /// **'Hasar nasıl bildiririm?'**
  String get guideStarterDamage;

  /// No description provided for @guideAskSuggestion.
  ///
  /// In tr, this message translates to:
  /// **'Sor: {question}'**
  String guideAskSuggestion(String question);

  /// No description provided for @guideSuggestionsSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Önerilen sorular'**
  String get guideSuggestionsSemantics;

  /// No description provided for @guideQuestionSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Siz: {text}'**
  String guideQuestionSemantics(String text);

  /// No description provided for @guideAnswerAnnouncement.
  ///
  /// In tr, this message translates to:
  /// **'Rehber: {text}'**
  String guideAnswerAnnouncement(String text);

  /// No description provided for @guideSources.
  ///
  /// In tr, this message translates to:
  /// **'Kaynak: VGM kataloğu — {names}'**
  String guideSources(String names);

  /// No description provided for @guideTyping.
  ///
  /// In tr, this message translates to:
  /// **'Rehber yanıt hazırlıyor…'**
  String get guideTyping;

  /// No description provided for @guideSendFailed.
  ///
  /// In tr, this message translates to:
  /// **'Soru gönderilemedi.'**
  String get guideSendFailed;

  /// No description provided for @guideNewConversation.
  ///
  /// In tr, this message translates to:
  /// **'Yeni sohbet'**
  String get guideNewConversation;

  /// No description provided for @guideResetAnnouncement.
  ///
  /// In tr, this message translates to:
  /// **'Yeni sohbet başlatıldı.'**
  String get guideResetAnnouncement;

  /// No description provided for @guideInputLabel.
  ///
  /// In tr, this message translates to:
  /// **'Rehbere sorun'**
  String get guideInputLabel;

  /// No description provided for @guideInputHint.
  ///
  /// In tr, this message translates to:
  /// **'Bir eser, şehir veya yapmak istediğiniz şey…'**
  String get guideInputHint;

  /// No description provided for @guideInputCounter.
  ///
  /// In tr, this message translates to:
  /// **'{count}/{max}'**
  String guideInputCounter(int count, int max);

  /// No description provided for @guideSend.
  ///
  /// In tr, this message translates to:
  /// **'Gönder'**
  String get guideSend;

  /// No description provided for @guideVoiceStart.
  ///
  /// In tr, this message translates to:
  /// **'Sesli sor'**
  String get guideVoiceStart;

  /// No description provided for @guideVoiceStop.
  ///
  /// In tr, this message translates to:
  /// **'Dinlemeyi durdur'**
  String get guideVoiceStop;

  /// No description provided for @guideVoiceListening.
  ///
  /// In tr, this message translates to:
  /// **'Dinleniyor… Sorunuzu söyleyin, bitince durdurun.'**
  String get guideVoiceListening;

  /// No description provided for @guideVoiceHeard.
  ///
  /// In tr, this message translates to:
  /// **'Söylediğiniz: {text}. Göndermek için Gönder\'e dokunun.'**
  String guideVoiceHeard(String text);

  /// No description provided for @guideVoicePermissionDenied.
  ///
  /// In tr, this message translates to:
  /// **'Sesli soru için mikrofon izni gerekiyor.'**
  String get guideVoicePermissionDenied;

  /// No description provided for @guideVoicePermissionBlocked.
  ///
  /// In tr, this message translates to:
  /// **'Mikrofon izni kapalı. Sistem ayarlarından açabilirsiniz.'**
  String get guideVoicePermissionBlocked;

  /// No description provided for @guideVoicePermissionBlockedWeb.
  ///
  /// In tr, this message translates to:
  /// **'Mikrofon izni kapalı. Tarayıcının site ayarlarından açabilirsiniz.'**
  String get guideVoicePermissionBlockedWeb;

  /// No description provided for @guideVoiceUnavailable.
  ///
  /// In tr, this message translates to:
  /// **'Bu cihazda veya tarayıcıda sesli soru kullanılamıyor. Sorunuzu yazabilirsiniz.'**
  String get guideVoiceUnavailable;

  /// No description provided for @guideVoiceNoMatch.
  ///
  /// In tr, this message translates to:
  /// **'Konuşmanız anlaşılamadı. Tekrar deneyin veya yazın.'**
  String get guideVoiceNoMatch;

  /// No description provided for @guideVoiceFailed.
  ///
  /// In tr, this message translates to:
  /// **'Sesli soru alınamadı. Tekrar deneyin veya yazın.'**
  String get guideVoiceFailed;

  /// No description provided for @guidePrivacyNotice.
  ///
  /// In tr, this message translates to:
  /// **'Yanıtlar VGM kataloğuna dayanır. Kişisel bilgilerinizi paylaşmayın.'**
  String get guidePrivacyNotice;

  /// No description provided for @guideActionOpenMonument.
  ///
  /// In tr, this message translates to:
  /// **'{name} sayfasını aç'**
  String guideActionOpenMonument(String name);

  /// No description provided for @guideActionShowOnMap.
  ///
  /// In tr, this message translates to:
  /// **'Haritada göster'**
  String get guideActionShowOnMap;

  /// No description provided for @guideActionOpenMemories.
  ///
  /// In tr, this message translates to:
  /// **'Anıları gör'**
  String get guideActionOpenMemories;

  /// No description provided for @guideActionReportDamage.
  ///
  /// In tr, this message translates to:
  /// **'Hasar bildir'**
  String get guideActionReportDamage;

  /// No description provided for @guideActionSearch.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =1{1 eseri listele} other{{count} eseri listele}}'**
  String guideActionSearch(int count);

  /// No description provided for @guideActionSearchAll.
  ///
  /// In tr, this message translates to:
  /// **'Eserlerde ara'**
  String get guideActionSearchAll;

  /// No description provided for @guideActionOpenMap.
  ///
  /// In tr, this message translates to:
  /// **'Haritayı aç'**
  String get guideActionOpenMap;

  /// No description provided for @guideActionOpenRoutes.
  ///
  /// In tr, this message translates to:
  /// **'Rotalarım'**
  String get guideActionOpenRoutes;

  /// No description provided for @guideActionNewRoute.
  ///
  /// In tr, this message translates to:
  /// **'Rota oluştur'**
  String get guideActionNewRoute;

  /// No description provided for @guideActionOpenCivilProtection.
  ///
  /// In tr, this message translates to:
  /// **'Sivil Koruma'**
  String get guideActionOpenCivilProtection;

  /// No description provided for @guideActionOpenSettings.
  ///
  /// In tr, this message translates to:
  /// **'Ayarları aç'**
  String get guideActionOpenSettings;

  /// No description provided for @guideActionForMonument.
  ///
  /// In tr, this message translates to:
  /// **'{action}: {name}'**
  String guideActionForMonument(String action, String name);

  /// No description provided for @accessibilityTitle.
  ///
  /// In tr, this message translates to:
  /// **'Erişilebilirlik'**
  String get accessibilityTitle;

  /// No description provided for @accessibilityIntro.
  ///
  /// In tr, this message translates to:
  /// **'Bir kutucuğa her dokunuşta bir sonraki seviyeye geçilir; son seviyeden sonra kapanır. Tercihler tüm uygulamaya hemen uygulanır ve bu cihazda saklanır.'**
  String get accessibilityIntro;

  /// No description provided for @accessibilityDeviceNote.
  ///
  /// In tr, this message translates to:
  /// **'Ekran okuyucu, kalın yazı ve cihaz yazı boyutu cihazınızın ayarlarından gelir; uygulama bunlara uyar. Buradaki metin boyutu cihaz boyutuyla çarpılır.'**
  String get accessibilityDeviceNote;

  /// No description provided for @accessibilityReset.
  ///
  /// In tr, this message translates to:
  /// **'Varsayılanlara dön'**
  String get accessibilityReset;

  /// No description provided for @accessibilityResetDone.
  ///
  /// In tr, this message translates to:
  /// **'Erişilebilirlik tercihleri varsayılana döndürüldü.'**
  String get accessibilityResetDone;

  /// No description provided for @settingsAccessibilityDescription.
  ///
  /// In tr, this message translates to:
  /// **'Metin boyutu, yüksek kontrast, renk görme, hareket ve titreşim'**
  String get settingsAccessibilityDescription;

  /// No description provided for @onboardingAccessibilityOpen.
  ///
  /// In tr, this message translates to:
  /// **'Erişilebilirlik ayarlarını aç'**
  String get onboardingAccessibilityOpen;

  /// No description provided for @guideActionOpenAccessibility.
  ///
  /// In tr, this message translates to:
  /// **'Erişilebilirlik ayarlarını aç'**
  String get guideActionOpenAccessibility;

  /// No description provided for @a11yImageHidden.
  ///
  /// In tr, this message translates to:
  /// **'Görsel gizlendi'**
  String get a11yImageHidden;

  /// No description provided for @a11yFeatureReadAloud.
  ///
  /// In tr, this message translates to:
  /// **'Sesli Okuma'**
  String get a11yFeatureReadAloud;

  /// No description provided for @a11yFeatureReadOnFocus.
  ///
  /// In tr, this message translates to:
  /// **'Odakta Oku'**
  String get a11yFeatureReadOnFocus;

  /// No description provided for @a11yFeatureGrayscale.
  ///
  /// In tr, this message translates to:
  /// **'Gri Tonlama'**
  String get a11yFeatureGrayscale;

  /// No description provided for @a11yFeatureContrast.
  ///
  /// In tr, this message translates to:
  /// **'Kontrast'**
  String get a11yFeatureContrast;

  /// No description provided for @a11yFeatureZoom.
  ///
  /// In tr, this message translates to:
  /// **'Yakınlaştırma'**
  String get a11yFeatureZoom;

  /// No description provided for @a11yFeatureHideImages.
  ///
  /// In tr, this message translates to:
  /// **'Görseli Gizle'**
  String get a11yFeatureHideImages;

  /// No description provided for @a11yFeatureHighlightLinks.
  ///
  /// In tr, this message translates to:
  /// **'Bağlantıları Vurgula'**
  String get a11yFeatureHighlightLinks;

  /// No description provided for @a11yFeatureColorBlindness.
  ///
  /// In tr, this message translates to:
  /// **'Renk Körlüğü'**
  String get a11yFeatureColorBlindness;

  /// No description provided for @a11yFeatureEasyReading.
  ///
  /// In tr, this message translates to:
  /// **'Kolay Okuma'**
  String get a11yFeatureEasyReading;

  /// No description provided for @a11yFeatureBlueLightFilter.
  ///
  /// In tr, this message translates to:
  /// **'Mavi Ekran Filtresi'**
  String get a11yFeatureBlueLightFilter;

  /// No description provided for @a11yFeatureStopAnimations.
  ///
  /// In tr, this message translates to:
  /// **'Animasyonları Durdur'**
  String get a11yFeatureStopAnimations;

  /// No description provided for @a11yFeatureDyslexiaFriendly.
  ///
  /// In tr, this message translates to:
  /// **'Disleksi Dostu'**
  String get a11yFeatureDyslexiaFriendly;

  /// No description provided for @a11yFeatureReadingGuide.
  ///
  /// In tr, this message translates to:
  /// **'Okuma Çizgisi'**
  String get a11yFeatureReadingGuide;

  /// No description provided for @a11yFeatureFocusHighlight.
  ///
  /// In tr, this message translates to:
  /// **'Odaklanma'**
  String get a11yFeatureFocusHighlight;

  /// No description provided for @a11yFeatureBigCursor.
  ///
  /// In tr, this message translates to:
  /// **'Büyük İmleç'**
  String get a11yFeatureBigCursor;

  /// No description provided for @a11yFeatureLineHeight.
  ///
  /// In tr, this message translates to:
  /// **'Satır Yüksekliği'**
  String get a11yFeatureLineHeight;

  /// No description provided for @a11yFeatureAlignLeft.
  ///
  /// In tr, this message translates to:
  /// **'Sola Hizala'**
  String get a11yFeatureAlignLeft;

  /// No description provided for @a11yFeatureHaptics.
  ///
  /// In tr, this message translates to:
  /// **'Titreşim'**
  String get a11yFeatureHaptics;

  /// No description provided for @a11yLevelOff.
  ///
  /// In tr, this message translates to:
  /// **'Kapalı'**
  String get a11yLevelOff;

  /// No description provided for @a11yLevelOn.
  ///
  /// In tr, this message translates to:
  /// **'Açık'**
  String get a11yLevelOn;

  /// No description provided for @a11yContrastAuto.
  ///
  /// In tr, this message translates to:
  /// **'Yüksek kontrast'**
  String get a11yContrastAuto;

  /// No description provided for @a11yContrastDark.
  ///
  /// In tr, this message translates to:
  /// **'Koyu yüksek kontrast'**
  String get a11yContrastDark;

  /// No description provided for @a11yContrastLight.
  ///
  /// In tr, this message translates to:
  /// **'Açık yüksek kontrast'**
  String get a11yContrastLight;

  /// No description provided for @a11yContrastInvert.
  ///
  /// In tr, this message translates to:
  /// **'Ters renkler'**
  String get a11yContrastInvert;

  /// No description provided for @a11yBlueLightLow.
  ///
  /// In tr, this message translates to:
  /// **'Hafif'**
  String get a11yBlueLightLow;

  /// No description provided for @a11yBlueLightHigh.
  ///
  /// In tr, this message translates to:
  /// **'Güçlü'**
  String get a11yBlueLightHigh;

  /// No description provided for @a11yDyslexiaFont.
  ///
  /// In tr, this message translates to:
  /// **'Okunaklı font'**
  String get a11yDyslexiaFont;

  /// No description provided for @a11yDyslexiaSpacing.
  ///
  /// In tr, this message translates to:
  /// **'Okunaklı font ve geniş aralık'**
  String get a11yDyslexiaSpacing;

  /// No description provided for @a11yDyslexiaCream.
  ///
  /// In tr, this message translates to:
  /// **'Okunaklı font, geniş aralık ve krem zemin'**
  String get a11yDyslexiaCream;

  /// No description provided for @a11yGuideThin.
  ///
  /// In tr, this message translates to:
  /// **'İnce çizgi'**
  String get a11yGuideThin;

  /// No description provided for @a11yGuideThick.
  ///
  /// In tr, this message translates to:
  /// **'Kalın çizgi'**
  String get a11yGuideThick;

  /// No description provided for @a11yGuideMask.
  ///
  /// In tr, this message translates to:
  /// **'Okuma maskesi'**
  String get a11yGuideMask;

  /// No description provided for @a11yFocusVisible.
  ///
  /// In tr, this message translates to:
  /// **'Belirgin'**
  String get a11yFocusVisible;

  /// No description provided for @a11yFocusThick.
  ///
  /// In tr, this message translates to:
  /// **'Kalın'**
  String get a11yFocusThick;

  /// No description provided for @a11yFocusExtra.
  ///
  /// In tr, this message translates to:
  /// **'Çok kalın'**
  String get a11yFocusExtra;

  /// No description provided for @a11yCursorLarge.
  ///
  /// In tr, this message translates to:
  /// **'Büyük'**
  String get a11yCursorLarge;

  /// No description provided for @a11yCursorExtra.
  ///
  /// In tr, this message translates to:
  /// **'Çok büyük'**
  String get a11yCursorExtra;

  /// No description provided for @a11yLineHeightValue.
  ///
  /// In tr, this message translates to:
  /// **'{value} kat'**
  String a11yLineHeightValue(String value);

  /// No description provided for @a11yTileState.
  ///
  /// In tr, this message translates to:
  /// **'{feature}: {state}'**
  String a11yTileState(String feature, String state);

  /// No description provided for @a11yTileLevel.
  ///
  /// In tr, this message translates to:
  /// **'Seviye {level} / {levels}'**
  String a11yTileLevel(int level, int levels);

  /// No description provided for @a11yTileHint.
  ///
  /// In tr, this message translates to:
  /// **'sonraki seviye'**
  String get a11yTileHint;

  /// No description provided for @mapAccessibilityButton.
  ///
  /// In tr, this message translates to:
  /// **'Erişilebilirlik'**
  String get mapAccessibilityButton;

  /// No description provided for @settingsShowAccessibilityButton.
  ///
  /// In tr, this message translates to:
  /// **'Haritada Erişilebilirlik butonunu göster'**
  String get settingsShowAccessibilityButton;

  /// No description provided for @settingsShowAccessibilityButtonDescription.
  ///
  /// In tr, this message translates to:
  /// **'Kapalıyken erişilebilirlik paneline buradan ve ilk açılış tanıtımından ulaşabilirsiniz; tercihleriniz uygulanmaya devam eder.'**
  String get settingsShowAccessibilityButtonDescription;

  /// No description provided for @complexMemberCount.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =0{Yapı listelenmedi} =1{1 yapı} other{{count} yapı}}'**
  String complexMemberCount(int count);

  /// No description provided for @complexMembersTitle.
  ///
  /// In tr, this message translates to:
  /// **'Külliyedeki yapılar'**
  String get complexMembersTitle;

  /// No description provided for @complexMembersSeeAll.
  ///
  /// In tr, this message translates to:
  /// **'Tüm yapıları gör ({count})'**
  String complexMembersSeeAll(int count);

  /// No description provided for @complexMembersPageTitle.
  ///
  /// In tr, this message translates to:
  /// **'{name} yapıları'**
  String complexMembersPageTitle(String name);

  /// No description provided for @complexMembersEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Bu külliyenin yapıları henüz kataloğa eklenmedi.'**
  String get complexMembersEmpty;

  /// No description provided for @complexMembersFilterEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Bu türde yapı yok.'**
  String get complexMembersFilterEmpty;

  /// No description provided for @complexMembersLoadFailed.
  ///
  /// In tr, this message translates to:
  /// **'Külliyenin yapıları yüklenemedi.'**
  String get complexMembersLoadFailed;

  /// No description provided for @complexMembersEndOfList.
  ///
  /// In tr, this message translates to:
  /// **'Tüm yapılar gösterildi ({count})'**
  String complexMembersEndOfList(int count);

  /// No description provided for @complexMemberSemantics.
  ///
  /// In tr, this message translates to:
  /// **'{index}. {name}, {category}'**
  String complexMemberSemantics(int index, String name, String category);

  /// No description provided for @complexPartOf.
  ///
  /// In tr, this message translates to:
  /// **'{name} yapılarından biri'**
  String complexPartOf(String name);

  /// No description provided for @complexPartOfHint.
  ///
  /// In tr, this message translates to:
  /// **'Külliyeyi ve diğer yapılarını görmek için dokunun'**
  String get complexPartOfHint;

  /// No description provided for @complexSiblingsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Külliyedeki diğer yapılar'**
  String get complexSiblingsTitle;

  /// No description provided for @complexLayoutTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yerleşim planı'**
  String get complexLayoutTitle;

  /// No description provided for @complexLayoutMapSemantics.
  ///
  /// In tr, this message translates to:
  /// **'{name} yerleşim planı, {members}. Yapılar yukarıdaki listede aynı sırayla yer alır.'**
  String complexLayoutMapSemantics(String name, String members);

  /// No description provided for @complexOpen.
  ///
  /// In tr, this message translates to:
  /// **'Külliyeyi gör'**
  String get complexOpen;

  /// No description provided for @complexOpenSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Külliyeyi gör, {name}'**
  String complexOpenSemantics(String name);

  /// No description provided for @complexFactMembers.
  ///
  /// In tr, this message translates to:
  /// **'Yapılar'**
  String get complexFactMembers;

  /// No description provided for @complexListItemSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'{location} · Külliye · {members}'**
  String complexListItemSubtitle(String location, String members);

  /// No description provided for @monumentListItemMemberSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'{location} · {category} · {complex}'**
  String monumentListItemMemberSubtitle(
    String location,
    String category,
    String complex,
  );

  /// No description provided for @mapComplexSemantics.
  ///
  /// In tr, this message translates to:
  /// **'{name}, külliye, {members}, {district}, {city}'**
  String mapComplexSemantics(
    String name,
    String members,
    String district,
    String city,
  );

  /// No description provided for @mapComplexMemberSemantics.
  ///
  /// In tr, this message translates to:
  /// **'{name}, {complex} içinde'**
  String mapComplexMemberSemantics(String name, String complex);

  /// No description provided for @mapComplexAreaSemantics.
  ///
  /// In tr, this message translates to:
  /// **'{name} yerleşim alanı. Külliyeyi seçmek için dokunun.'**
  String mapComplexAreaSemantics(String name);

  /// No description provided for @memoryStatusApproved.
  ///
  /// In tr, this message translates to:
  /// **'Yayında'**
  String get memoryStatusApproved;

  /// No description provided for @memoryStatusPending.
  ///
  /// In tr, this message translates to:
  /// **'İncelemede'**
  String get memoryStatusPending;

  /// No description provided for @memoryStatusRejected.
  ///
  /// In tr, this message translates to:
  /// **'Yayınlanmadı'**
  String get memoryStatusRejected;

  /// No description provided for @memorySharedPending.
  ///
  /// In tr, this message translates to:
  /// **'Anınız incelemeye alındı. Onaylanınca Anı Köşesi\'nde yayınlanacak; durumunu Anılarım\'da görebilirsiniz.'**
  String get memorySharedPending;

  /// No description provided for @memorySharedRejected.
  ///
  /// In tr, this message translates to:
  /// **'Anınız topluluk kurallarına uygun bulunmadığı için yayınlanmadı. Anılarım\'da görebilirsiniz.'**
  String get memorySharedRejected;

  /// No description provided for @memoryOpenMyMemories.
  ///
  /// In tr, this message translates to:
  /// **'Anılarım'**
  String get memoryOpenMyMemories;

  /// No description provided for @myMemoriesPreviewStatusSemantics.
  ///
  /// In tr, this message translates to:
  /// **'{status}. {summary}'**
  String myMemoriesPreviewStatusSemantics(String status, String summary);

  /// No description provided for @monumentLocationPending.
  ///
  /// In tr, this message translates to:
  /// **'Bu eserin konumu henüz girilmedi; haritada ve rota planlayıcıda yer almıyor.'**
  String get monumentLocationPending;

  /// No description provided for @monumentNickname.
  ///
  /// In tr, this message translates to:
  /// **'Halk arasında: {name}'**
  String monumentNickname(String name);

  /// No description provided for @monumentPartFallback.
  ///
  /// In tr, this message translates to:
  /// **'Bölüm {index}'**
  String monumentPartFallback(int index);

  /// No description provided for @routePickerNoLocation.
  ///
  /// In tr, this message translates to:
  /// **'{details} · Konum yok, rotaya eklenemez'**
  String routePickerNoLocation(String details);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
