// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Vakıf Atlas';

  @override
  String get appSlogan => 'Köklerden Geleceğe';

  @override
  String get errorInvalidRequest =>
      'Gönderilen istek geçersiz. Lütfen girdiğiniz bilgileri kontrol edin.';

  @override
  String get errorUnauthorized =>
      'Oturum süreniz doldu veya bu işlem için yetkiniz bulunmuyor.';

  @override
  String get errorNotFound => 'İstenen kaynak bulunamadı.';

  @override
  String get errorModerationRejected =>
      'Paylaşımınız topluluk kurallarına uygun bulunmadı.';

  @override
  String get errorServerUnavailable =>
      'Sunucu şu anda geçici olarak hizmet veremiyor. Lütfen birazdan tekrar deneyin.';

  @override
  String get errorOffline =>
      'İnternet bağlantınız yok. Bağlantınızı kontrol edip tekrar deneyin.';

  @override
  String get errorServerUnreachable =>
      'Vakıf Atlas sunucusuna şu anda ulaşılamıyor. İnternet bağlantınız çalışıyor; lütfen birazdan tekrar deneyin.';

  @override
  String get offlineBannerMessage =>
      'Çevrimdışısınız. Cihazdaki veriler gösteriliyor; değişiklikler bağlantı gelince eşitlenecek.';

  @override
  String get offlineAnnouncement =>
      'İnternet bağlantısı kesildi. Uygulama çevrimdışı modda çalışıyor.';

  @override
  String get onlineAnnouncement => 'İnternet bağlantısı yeniden kuruldu.';

  @override
  String get errorCacheRead =>
      'Yerel veri okunamadı, çevrimiçi kaynaklara başvuruluyor.';

  @override
  String get errorSecurityViolation =>
      'Güvenli bağlantı veya cihaz bütünlüğü doğrulanamadı.';

  @override
  String get errorInvalidCredentials =>
      'E-posta adresi veya şifre hatalı. Bilgilerinizi kontrol edip tekrar deneyin.';

  @override
  String get errorUnexpected =>
      'Beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.';

  @override
  String get commonRetry => 'Tekrar dene';

  @override
  String get commonUndo => 'Geri al';

  @override
  String get commonCancel => 'Vazgeç';

  @override
  String get commonClose => 'Kapat';

  @override
  String get commonLoading => 'Yükleniyor';

  @override
  String buttonLoadingSemantics(String label) {
    return '$label, işlem sürüyor';
  }

  @override
  String badgeOverflow(int max) {
    return '$max+';
  }

  @override
  String notificationCountSemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yeni bildirim',
      zero: 'Yeni bildirim yok',
    );
    return '$_temp0';
  }

  @override
  String get navMap => 'Harita';

  @override
  String get navRoutePlanner => 'Rotalar';

  @override
  String get navAiAssistant => 'Rehber';

  @override
  String get navProfile => 'Profil';

  @override
  String get navSettings => 'Ayarlar';

  @override
  String get navigationSemantics => 'Ana gezinme';

  @override
  String get mapDiscoveryTitle => 'Keşfet';

  @override
  String get monumentDetailTitle => 'Eser Detayı';

  @override
  String get routePlannerTitle => 'Rota Planlayıcı';

  @override
  String get memoryCornerTitle => 'Anı Köşesi';

  @override
  String get civilProtectionTitle => 'Sivil Koruma';

  @override
  String get aiAssistantTitle => 'Dijital Rehber';

  @override
  String get profileTitle => 'Profilim';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get loginTitle => 'Giriş Yap';

  @override
  String get featurePendingHeading => 'Bu bölüm hazırlanıyor';

  @override
  String featurePendingBody(String feature) {
    return '$feature bir sonraki sürümde kullanıma açılacak.';
  }

  @override
  String get notFoundTitle => 'Sayfa bulunamadı';

  @override
  String get notFoundBody =>
      'Aradığınız sayfa mevcut değil veya taşınmış olabilir.';

  @override
  String get notFoundAction => 'Ana sayfaya dön';

  @override
  String get splashLoadingSemantics => 'Vakıf Atlas açılıyor';

  @override
  String get loginHeading => 'Hoş geldiniz';

  @override
  String get loginSubtitle =>
      'Anı paylaşmak, Sivil Koruma bildirimi yapmak ve rozet kazanmak için giriş yapın.';

  @override
  String get loginRequiredNotice =>
      'Bu bölümü kullanmak için giriş yapmanız gerekiyor.';

  @override
  String get loginEmailLabel => 'E-posta';

  @override
  String get loginEmailHint => 'ad@eposta.com';

  @override
  String get loginPasswordLabel => 'Şifre';

  @override
  String get passwordShow => 'Şifreyi göster';

  @override
  String get passwordHide => 'Şifreyi gizle';

  @override
  String get loginSubmit => 'Giriş yap';

  @override
  String get loginContinueAsGuest => 'Misafir olarak devam et';

  @override
  String loginSuccessAnnouncement(String name) {
    return 'Giriş yapıldı. Hoş geldiniz, $name.';
  }

  @override
  String get loginFormInvalidAnnouncement =>
      'Formda düzeltilmesi gereken alanlar var.';

  @override
  String get validationEmailEmpty => 'E-posta adresinizi girin.';

  @override
  String get validationEmailInvalid =>
      'Geçerli bir e-posta adresi girin. Örnek: ad@eposta.com';

  @override
  String get validationPasswordEmpty => 'Şifrenizi girin.';

  @override
  String validationPasswordTooShort(int min) {
    return 'Şifre en az $min karakter olmalıdır.';
  }

  @override
  String profileEmailValue(String email) {
    return 'E-posta: $email';
  }

  @override
  String get gamificationSectionTitle => 'Seviye ve rozetler';

  @override
  String gamificationLevelTitle(int level, String title) {
    return 'Seviye $level · $title';
  }

  @override
  String gamificationXpProgress(int xp, int next) {
    return '$xp / $next XP';
  }

  @override
  String gamificationXpTotal(int xp) {
    return '$xp XP';
  }

  @override
  String gamificationXpToNext(int xp) {
    return 'Sonraki seviyeye $xp XP kaldı.';
  }

  @override
  String get gamificationMaxLevel => 'En yüksek seviyedesiniz.';

  @override
  String get gamificationProgressSemantics => 'Seviye ilerlemesi';

  @override
  String get gamificationRecentBadges => 'Son kazanılan rozetler';

  @override
  String get gamificationNoBadges =>
      'Henüz rozetiniz yok. Rota oluşturarak, anı paylaşarak veya hasar bildirerek kazanmaya başlayın.';

  @override
  String gamificationAllBadges(int unlocked, int total) {
    return 'Tüm rozetler ($unlocked/$total)';
  }

  @override
  String get gamificationLoading => 'Seviye bilgisi yükleniyor';

  @override
  String get gamificationLoadFailed => 'Seviye bilgisi yüklenemedi.';

  @override
  String get gamificationAchievementsTitle => 'Rozetler';

  @override
  String gamificationAchievementsSummary(int unlocked, int total) {
    return '$total rozetten $unlocked tanesini kazandınız.';
  }

  @override
  String get gamificationEarnedSection => 'Kazanılanlar';

  @override
  String get gamificationLockedSection => 'Kazanılacaklar';

  @override
  String gamificationUnlockedOn(String date) {
    return 'Kazanıldı: $date';
  }

  @override
  String gamificationLockedProgress(int progress, int target) {
    return 'Kilitli · $progress/$target';
  }

  @override
  String get gamificationHowToTitle => 'Nasıl XP kazanılır?';

  @override
  String get gamificationHowToRoute =>
      'Rota oluşturma: 50 XP (günde en çok 3 rota)';

  @override
  String get gamificationHowToMemory =>
      'Anı paylaşma: 30 XP (günde en çok 5 anı)';

  @override
  String get gamificationHowToReport =>
      'Hasar bildirimi: 40 XP (günde en çok 3 bildirim)';

  @override
  String get gamificationHowToCity => 'Bir ildeki esere ilk katkınız: 20 XP';

  @override
  String get gamificationHowToNote =>
      'XP, hesabınızla yaptığınız katkılar için verilir; misafir olarak oluşturulan rotalar sayılmaz.';

  @override
  String get gamificationCelebrationTitle => 'Tebrikler!';

  @override
  String gamificationLevelReached(int level, String title) {
    return 'Yeni seviye: $level · $title';
  }

  @override
  String gamificationBadgeEarned(String title) {
    return 'Yeni rozet: $title';
  }

  @override
  String get gamificationCelebrationViewBadges => 'Rozetleri gör';

  @override
  String get gamificationCelebrationClose => 'Harika';

  @override
  String get profileLogout => 'Çıkış yap';

  @override
  String get profileLogoutConfirmTitle => 'Çıkış yapılsın mı?';

  @override
  String get profileLogoutConfirmBody =>
      'Anı paylaşmak ve bildirim göndermek için yeniden giriş yapmanız gerekecek.';

  @override
  String get logoutAnnouncement => 'Çıkış yapıldı.';

  @override
  String get sessionExpiredMessage =>
      'Oturumunuzun süresi doldu. Lütfen tekrar giriş yapın.';

  @override
  String get settingsAppearanceSection => 'Görünüm';

  @override
  String get settingsThemeLabel => 'Tema';

  @override
  String get themeSystem => 'Cihaz ayarı';

  @override
  String get themeLight => 'Açık';

  @override
  String get themeDark => 'Koyu';

  @override
  String get settingsLanguageSection => 'Dil';

  @override
  String get settingsLanguageLabel => 'Uygulama dili';

  @override
  String get languageSystem => 'Cihaz dili';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get languageEnglish => 'English';

  @override
  String get settingsAccessibilitySection => 'Erişilebilirlik';

  @override
  String get colorBlindnessProtanopia => 'Protanopi (kırmızı)';

  @override
  String get colorBlindnessDeuteranopia => 'Deuteranopi (yeşil)';

  @override
  String get colorBlindnessTritanopia => 'Tritanopi (mavi)';

  @override
  String settingsTextScaleValue(int percent) {
    return '%$percent';
  }

  @override
  String get settingsSaveFailed =>
      'Ayar bu cihaza kaydedilemedi. Uygulama yeniden açıldığında önceki değer kullanılacak.';

  @override
  String get settingsLicenses => 'Açık kaynak lisansları';

  @override
  String get settingsFeedback => 'Geri bildirim gönder';

  @override
  String get settingsFeedbackSubtitle =>
      'Deneyiminizi puanlayın, öneri veya sorun iletin';

  @override
  String aboutVersion(String version) {
    return 'Sürüm $version';
  }

  @override
  String get aboutMission =>
      'Vakıflar Genel Müdürlüğü\'nün koruduğu vakıf eserlerini keşfetmenin, gezmenin ve birlikte korumanın erişilebilir yolu.';

  @override
  String get aboutDeveloper =>
      'Vakıflar Genel Müdürlüğü için Root42 tarafından geliştirildi.';

  @override
  String get feedbackTitle => 'Geri bildirim';

  @override
  String get feedbackRatingLabel =>
      'Vakıf Atlas deneyiminizi nasıl değerlendirirsiniz?';

  @override
  String get feedbackRatingOptional => 'Puan vermek isteğe bağlıdır.';

  @override
  String feedbackRateStars(int count) {
    return '$count yıldız';
  }

  @override
  String feedbackRatingValue(int value, String name) {
    return '$value / 5 · $name';
  }

  @override
  String get feedbackRating1 => 'Çok kötü';

  @override
  String get feedbackRating2 => 'Kötü';

  @override
  String get feedbackRating3 => 'Orta';

  @override
  String get feedbackRating4 => 'İyi';

  @override
  String get feedbackRating5 => 'Çok iyi';

  @override
  String get feedbackCategoryLabel => 'Konu';

  @override
  String get feedbackCategorySuggestion => 'Öneri';

  @override
  String get feedbackCategoryBug => 'Hata';

  @override
  String get feedbackCategoryAccessibility => 'Erişilebilirlik';

  @override
  String get feedbackCategoryContent => 'Eser bilgisi';

  @override
  String get feedbackCategoryOther => 'Diğer';

  @override
  String get feedbackMessageLabel => 'Mesajınız';

  @override
  String get feedbackMessageHint => 'Neyi beğendiniz, neyi geliştirebiliriz?';

  @override
  String get feedbackMessageHelper =>
      'Kişisel bilgi paylaşmayın. Uygulama sürümü ve cihaz türü (ör. Android) eklenir.';

  @override
  String get feedbackSubmit => 'Gönder';

  @override
  String get feedbackRequired => 'Bir puan verin veya mesaj yazın.';

  @override
  String feedbackTooLong(int max) {
    return 'Mesaj en fazla $max karakter olabilir.';
  }

  @override
  String get feedbackSent => 'Teşekkürler! Geri bildiriminiz alındı.';

  @override
  String get privacyOverlaySemantics => 'Uygulama içeriği gizlendi';

  @override
  String get integrityWarningMessage =>
      'Cihazınızda güvenlik değişiklikleri (root veya jailbreak) tespit edildi. Hesabınızın güvenliği için bazı işlemler kısıtlanabilir.';

  @override
  String get integrityWarningDismiss => 'Anladım';

  @override
  String get integrityBlockedTitle => 'Güvenli çalışma ortamı doğrulanamadı';

  @override
  String get integrityBlockedBody =>
      'Uygulamanın değiştirilmiş bir sürümü veya izinsiz bir müdahale tespit edildi. Lütfen Vakıf Atlas\'ı resmi uygulama mağazasından yeniden yükleyin.';

  @override
  String get startupFailedTitle => 'Uygulama başlatılamadı';

  @override
  String get startupFailedBody =>
      'Vakıf Atlas açılırken beklenmeyen bir sorun oluştu. Uygulamayı kapatıp yeniden açın; sorun sürerse uygulamayı güncelleyin.';

  @override
  String get errorEmailNotVerified =>
      'E-posta adresiniz henüz doğrulanmadı. Size gönderdiğimiz kodu girin.';

  @override
  String get errorInvalidVerificationCode =>
      'Kod hatalı. E-postanızdaki 6 haneli kodu kontrol edip tekrar deneyin.';

  @override
  String get errorVerificationCodeExpired =>
      'Kodun süresi doldu veya çok fazla hatalı deneme yapıldı. Yeni bir kod isteyin.';

  @override
  String get errorWeakPassword =>
      'Bu şifre güvenlik kurallarını karşılamıyor. Daha uzun ve tahmin edilmesi zor bir şifre seçin.';

  @override
  String get errorInvalidCurrentPassword => 'Mevcut şifreniz hatalı.';

  @override
  String get errorTooManyRequests =>
      'Çok fazla deneme yapıldı. Lütfen biraz sonra tekrar deneyin.';

  @override
  String errorTooManyRequestsRetry(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Çok fazla deneme yapıldı. $minutes dakika sonra tekrar deneyin.',
      one: 'Çok fazla deneme yapıldı. 1 dakika sonra tekrar deneyin.',
    );
    return '$_temp0';
  }

  @override
  String get validationNameEmpty => 'Adınızı ve soyadınızı girin.';

  @override
  String validationNameTooShort(int min) {
    return 'Ad soyad en az $min karakter olmalıdır.';
  }

  @override
  String validationNameTooLong(int max) {
    return 'Ad soyad en fazla $max karakter olabilir.';
  }

  @override
  String get validationNameInvalid =>
      'Ad soyad yalnızca harf, boşluk, kesme işareti ve tire içerebilir.';

  @override
  String validationPasswordTooLong(int max) {
    return 'Şifre en fazla $max karakter olabilir.';
  }

  @override
  String get validationPasswordCommon =>
      'Bu şifre çok yaygın ve kolay tahmin edilir. Farklı bir şifre seçin.';

  @override
  String get validationPasswordPersonalInfo =>
      'Şifre adınızı, e-posta adresinizi veya uygulama adını içermemelidir.';

  @override
  String get validationPasswordRepetitive =>
      'Şifre tekrar eden veya ardışık karakterlerden oluşmamalıdır.';

  @override
  String get validationConfirmPasswordEmpty => 'Şifrenizi tekrar girin.';

  @override
  String get validationPasswordMismatch =>
      'Şifreler eşleşmiyor. İki alana da aynı şifreyi girin.';

  @override
  String get validationSamePassword =>
      'Yeni şifre mevcut şifrenizden farklı olmalıdır.';

  @override
  String get validationCurrentPasswordEmpty => 'Mevcut şifrenizi girin.';

  @override
  String get validationCodeEmpty => 'E-postanıza gelen kodu girin.';

  @override
  String validationCodeInvalid(int length) {
    return 'Kod $length haneli bir sayı olmalıdır.';
  }

  @override
  String get validationTermsRequired =>
      'Devam etmek için Kullanım Koşulları\'nı kabul etmelisiniz.';

  @override
  String get validationPrivacyRequired =>
      'Devam etmek için KVKK Aydınlatma Metni\'ni okuduğunuzu onaylamalısınız.';

  @override
  String get validationDeleteConfirmRequired =>
      'Devam etmek için onay kutusunu işaretleyin.';

  @override
  String passwordRequirementsHint(int min) {
    return 'En az $min karakter. Kolay tahmin edilen ifadelerden ve kişisel bilgilerden kaçının.';
  }

  @override
  String get passwordStrengthWeak => 'Zayıf';

  @override
  String get passwordStrengthFair => 'Orta';

  @override
  String get passwordStrengthGood => 'İyi';

  @override
  String get passwordStrengthStrong => 'Güçlü';

  @override
  String passwordStrengthSemantics(String level) {
    return 'Şifre gücü: $level';
  }

  @override
  String get loginForgotPassword => 'Şifremi unuttum';

  @override
  String get loginNoAccount => 'Hesabınız yok mu?';

  @override
  String get loginCreateAccount => 'Hesap oluştur';

  @override
  String get loginPasswordResetSuccess =>
      'Şifreniz güncellendi ve tüm oturumlar kapatıldı. Yeni şifrenizle giriş yapın.';

  @override
  String get registerTitle => 'Hesap Oluştur';

  @override
  String get registerHeading => 'Vakıf Atlas\'a katılın';

  @override
  String get registerSubtitle =>
      'Anılarınızı paylaşmak ve kültürel mirasın korunmasına katkı sağlamak için ücretsiz hesap oluşturun.';

  @override
  String get registerNameLabel => 'Ad soyad';

  @override
  String get registerConfirmPasswordLabel => 'Şifre (tekrar)';

  @override
  String get registerAcceptTerms =>
      'Kullanım Koşulları\'nı okudum ve kabul ediyorum.';

  @override
  String get registerAcknowledgePrivacy => 'KVKK Aydınlatma Metni\'ni okudum.';

  @override
  String get registerReadTerms => 'Kullanım Koşulları\'nı oku';

  @override
  String get registerReadPrivacy => 'Aydınlatma Metni\'ni oku';

  @override
  String get registerSubmit => 'Hesap oluştur';

  @override
  String get registerHaveAccount => 'Zaten hesabınız var mı? Giriş yapın';

  @override
  String get verifyEmailTitle => 'E-posta Doğrulama';

  @override
  String get verifyEmailHeading => 'E-postanızı doğrulayın';

  @override
  String verifyEmailBody(String email) {
    return '$email adresine 6 haneli bir doğrulama kodu gönderdik. Kod 10 dakika geçerlidir.';
  }

  @override
  String get verificationCodeLabel => 'Doğrulama kodu';

  @override
  String get verificationCodeHint => '6 haneli kod';

  @override
  String get verifyEmailSubmit => 'Doğrula';

  @override
  String get verifyEmailChangeEmail => 'E-posta adresini değiştir';

  @override
  String get resendCode => 'Kodu tekrar gönder';

  @override
  String resendCodeIn(int seconds) {
    return 'Kodu tekrar gönder ($seconds sn)';
  }

  @override
  String get codeResentAnnouncement => 'Yeni kod gönderildi.';

  @override
  String emailVerifiedAnnouncement(String name) {
    return 'Hesabınız doğrulandı. Hoş geldiniz, $name.';
  }

  @override
  String get forgotPasswordTitle => 'Şifremi Unuttum';

  @override
  String get forgotPasswordHeading => 'Şifrenizi sıfırlayın';

  @override
  String get forgotPasswordBody =>
      'Hesabınıza kayıtlı e-posta adresini girin. Size bir sıfırlama kodu göndereceğiz.';

  @override
  String get forgotPasswordSubmit => 'Kod gönder';

  @override
  String get backToLogin => 'Girişe dön';

  @override
  String get resetPasswordTitle => 'Yeni Şifre';

  @override
  String resetPasswordBody(String email) {
    return '$email ile kayıtlı bir hesap varsa, bu adrese 6 haneli bir sıfırlama kodu gönderdik.';
  }

  @override
  String get newPasswordLabel => 'Yeni şifre';

  @override
  String get confirmNewPasswordLabel => 'Yeni şifre (tekrar)';

  @override
  String get resetPasswordSubmit => 'Şifreyi güncelle';

  @override
  String get changePasswordTitle => 'Şifre Değiştir';

  @override
  String get currentPasswordLabel => 'Mevcut şifre';

  @override
  String get changePasswordSubmit => 'Şifreyi değiştir';

  @override
  String get changePasswordSuccess => 'Şifreniz değiştirildi.';

  @override
  String get deleteAccountTitle => 'Hesabı Sil';

  @override
  String get deleteAccountHeading => 'Hesabınızı kalıcı olarak silin';

  @override
  String get deleteAccountBody =>
      'Hesabınız ve hesabınıza bağlı kişisel verileriniz (profil, anılar, rozetler) KVKK kapsamında silinir. Bu işlem geri alınamaz.';

  @override
  String get deleteAccountConfirm =>
      'Bu işlemin geri alınamayacağını anlıyorum.';

  @override
  String get deleteAccountSubmit => 'Hesabımı sil';

  @override
  String get accountDeletedAnnouncement => 'Hesabınız silindi.';

  @override
  String get profileSecuritySection => 'Güvenlik ve hesap';

  @override
  String get legalTermsTitle => 'Kullanım Koşulları';

  @override
  String get legalPrivacyTitle => 'KVKK Aydınlatma Metni';

  @override
  String legalVersion(String version, DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Sürüm $version · Yürürlük tarihi: $dateString';
  }

  @override
  String mapSemanticsLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vakıf eserleri haritası, $count eser',
      zero: 'Vakıf eserleri haritası, eser yok',
    );
    return '$_temp0';
  }

  @override
  String mapLoadedAnnouncement(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count eser haritada gösteriliyor',
      zero: 'Haritada gösterilecek eser bulunamadı',
    );
    return '$_temp0';
  }

  @override
  String get mapLoadingMonuments => 'Eserler yükleniyor';

  @override
  String get mapLoadErrorTitle => 'Eserler yüklenemedi';

  @override
  String get mapZoomIn => 'Yakınlaştır';

  @override
  String get mapZoomOut => 'Uzaklaştır';

  @override
  String get mapShowAll => 'Tüm eserleri göster';

  @override
  String get mapControlsSemantics => 'Harita kontrolleri';

  @override
  String mapAttributionSemantics(String attribution) {
    return 'Harita verileri: $attribution';
  }

  @override
  String monumentPinSemantics(String name, String district, String city) {
    return '$name, $district, $city';
  }

  @override
  String monumentSelectedAnnouncement(String name) {
    return '$name seçildi';
  }

  @override
  String monumentCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count eser',
      zero: 'Eser yok',
    );
    return '$_temp0';
  }

  @override
  String get monumentPreviewClose => 'Önizlemeyi kapat';

  @override
  String get monumentSave => 'Kaydet';

  @override
  String get monumentUnsave => 'Kaydedilenlerden çıkar';

  @override
  String monumentSaveSemantics(String name) {
    return 'Kaydet: $name';
  }

  @override
  String monumentUnsaveSemantics(String name) {
    return 'Kaydedilenlerden çıkar: $name';
  }

  @override
  String savedMonumentAdded(String name) {
    return 'Kaydedildi: $name';
  }

  @override
  String savedMonumentRemoved(String name) {
    return 'Kaydedilenlerden çıkarıldı: $name';
  }

  @override
  String savedMonumentsLimit(int max) {
    return 'En fazla $max eser kaydedebilirsiniz. Yer açmak için Kaydedilenler\'den eser çıkarın.';
  }

  @override
  String get savedMonumentsSaveFailed => 'Kaydedilemedi. Tekrar deneyin.';

  @override
  String get savedMonumentsTitle => 'Kaydedilenler';

  @override
  String savedMonumentsButton(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kaydedilenler, $count eser',
      zero: 'Kaydedilenler, kayıtlı eser yok',
    );
    return '$_temp0';
  }

  @override
  String savedMonumentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count eser',
    );
    return '$_temp0';
  }

  @override
  String get savedMonumentsEmptyTitle => 'Henüz kaydedilen eser yok';

  @override
  String get savedMonumentsEmptyBody =>
      'İlginizi çeken eserleri, eser sayfasındaki veya harita önizlemesindeki yer işareti simgesiyle buraya kaydedin.';

  @override
  String get emptyStateExploreMap => 'Haritada keşfet';

  @override
  String get savedMonumentsLoadFailedTitle => 'Kaydedilenler yüklenemedi';

  @override
  String savedMonumentSavedOn(String date) {
    return 'Kaydedildi: $date';
  }

  @override
  String get savedMonumentRemove => 'Kaldır';

  @override
  String get savedMonumentUnavailable => 'Artık katalogda olmayan eser';

  @override
  String get savedMonumentUnavailableBody =>
      'Bu eser katalogdan kaldırılmış; listeden çıkarabilirsiniz.';

  @override
  String get monumentViewDetails => 'Detayları gör';

  @override
  String monumentViewDetailsSemantics(String name) {
    return 'Detayları gör, $name';
  }

  @override
  String monumentLocation(String district, String city) {
    return '$district, $city';
  }

  @override
  String monumentLocationSemantics(String location) {
    return 'Konum: $location';
  }

  @override
  String monumentAddressSemantics(String address) {
    return 'Adres: $address';
  }

  @override
  String get monumentCategoryMosque => 'Cami';

  @override
  String get monumentCategoryComplex => 'Külliye';

  @override
  String get monumentCategoryMadrasa => 'Medrese';

  @override
  String get monumentCategoryInn => 'Han';

  @override
  String get monumentCategoryCaravanserai => 'Kervansaray';

  @override
  String get monumentCategoryBath => 'Hamam';

  @override
  String get monumentCategoryFountain => 'Çeşme';

  @override
  String get monumentCategoryTomb => 'Türbe';

  @override
  String get monumentCategoryHospital => 'Darüşşifa';

  @override
  String get monumentCategoryImaret => 'İmaret';

  @override
  String get monumentCategoryOther => 'Diğer yapı';

  @override
  String get historicalPeriodSeljuk => 'Selçuklu';

  @override
  String get historicalPeriodBeylik => 'Beylikler';

  @override
  String get historicalPeriodOttoman => 'Osmanlı';

  @override
  String get historicalPeriodOther => 'Diğer dönem';

  @override
  String monumentCategorySemantics(String category) {
    return 'Yapı türü: $category';
  }

  @override
  String monumentPeriodSemantics(String period) {
    return 'Dönem: $period';
  }

  @override
  String monumentConstructionSemantics(String date) {
    return 'Yapım tarihi: $date';
  }

  @override
  String get monumentUnescoBadge => 'UNESCO Dünya Mirası';

  @override
  String get monumentDetailLoading => 'Eser bilgileri yükleniyor';

  @override
  String get monumentDetailErrorTitle => 'Eser bilgileri yüklenemedi';

  @override
  String get monumentNotFoundTitle => 'Eser bulunamadı';

  @override
  String get monumentNotFoundBody =>
      'Aradığınız eser katalogda yer almıyor veya kaldırılmış olabilir.';

  @override
  String get monumentBackToMap => 'Haritaya dön';

  @override
  String get monumentShowOnMap => 'Haritada göster';

  @override
  String get monumentListen => 'Sesli dinle';

  @override
  String get monumentStopListening => 'Seslendirmeyi durdur';

  @override
  String get monumentAboutHeading => 'Hakkında';

  @override
  String get monumentHistoryHeading => 'Tarihçe';

  @override
  String get monumentFactsHeading => 'Eser künyesi';

  @override
  String get monumentFounderLabel => 'Bani';

  @override
  String get monumentArchitectLabel => 'Mimar';

  @override
  String get monumentConstructionLabel => 'Yapım tarihi';

  @override
  String get monumentPeriodLabel => 'Dönem';

  @override
  String get monumentCategoryLabel => 'Yapı türü';

  @override
  String get monumentLocationHeading => 'Konum';

  @override
  String get monumentPhotoCreditsHeading => 'Fotoğraf künyesi';

  @override
  String monumentSpeechIntro(String name, String category, String location) {
    return '$name. $category, $location.';
  }

  @override
  String photoCredit(String author, String license, String source) {
    return '$author · $license · $source';
  }

  @override
  String photoCreditSemantics(
    int index,
    String author,
    String license,
    String source,
  ) {
    return 'Fotoğraf $index: $author, lisans $license, kaynak $source';
  }

  @override
  String gallerySemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Fotoğraf galerisi, $count fotoğraf',
      zero: 'Fotoğraf galerisi, fotoğraf yok',
    );
    return '$_temp0';
  }

  @override
  String galleryPhotoSemantics(int index, int count, String description) {
    return 'Fotoğraf $index / $count: $description';
  }

  @override
  String galleryPosition(int index, int count) {
    return '$index / $count';
  }

  @override
  String galleryPositionSemantics(int index, int count) {
    return 'Fotoğraf $index / $count';
  }

  @override
  String galleryThumbnailSemantics(int index, String description) {
    return 'Fotoğraf $index: $description';
  }

  @override
  String get galleryPrevious => 'Önceki fotoğraf';

  @override
  String get galleryNext => 'Sonraki fotoğraf';

  @override
  String get galleryOpenFullScreen => 'tam ekran görüntüle';

  @override
  String get galleryCloseViewer => 'Galeriyi kapat';

  @override
  String get galleryImageError => 'Fotoğraf yüklenemedi';

  @override
  String monumentListItemSubtitle(String location, String category) {
    return '$location · $category';
  }

  @override
  String photoCreditTitle(int index, String description) {
    return '$index. $description';
  }

  @override
  String get photoCreditsNotice =>
      'Lisans koşulları fotoğrafların kaynak sayfalarında yer alır.';

  @override
  String distanceKilometers(String value) {
    return '$value km';
  }

  @override
  String distanceMeters(String value) {
    return '$value m';
  }

  @override
  String durationDaysShort(int count) {
    return '$count g';
  }

  @override
  String durationHoursShort(int count) {
    return '$count sa';
  }

  @override
  String durationMinutesShort(int count) {
    return '$count dk';
  }

  @override
  String durationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gün',
      one: '1 gün',
    );
    return '$_temp0';
  }

  @override
  String durationHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count saat',
      one: '1 saat',
    );
    return '$_temp0';
  }

  @override
  String durationMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dakika',
      one: '1 dakika',
    );
    return '$_temp0';
  }

  @override
  String get routeListTitle => 'Rotalarım';

  @override
  String get routeNewButton => 'Yeni rota';

  @override
  String get routeListLoading => 'Rotalar yükleniyor';

  @override
  String get routeListErrorTitle => 'Rotalar yüklenemedi';

  @override
  String get routeListEmptyTitle => 'Henüz rotanız yok';

  @override
  String get routeListEmptyBody =>
      'Eserleri seçip sıralayın; ziyaret süresi ve molalarla ilk kültür rotanızı oluşturun.';

  @override
  String routeDraftBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Taslak rotanızda $count eser var',
      one: 'Taslak rotanızda 1 eser var',
    );
    return '$_temp0';
  }

  @override
  String get routeDraftContinue => 'Devam et';

  @override
  String routeStopCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count durak',
      one: '1 durak',
    );
    return '$_temp0';
  }

  @override
  String routeCityChain(String from, String to) {
    return '$from → $to';
  }

  @override
  String routeCardSemantics(
    String name,
    String stops,
    String cities,
    String distance,
    String duration,
    String created,
  ) {
    return '$name. $stops: $cities. Toplam $distance, $duration. $created.';
  }

  @override
  String routeCreatedOn(String date) {
    return 'Oluşturulma: $date';
  }

  @override
  String routeTotalDistanceSemantics(String value) {
    return 'Toplam mesafe: $value';
  }

  @override
  String routeTotalDurationSemantics(String value) {
    return 'Toplam süre: $value';
  }

  @override
  String get routeDetailLoading => 'Rota yükleniyor';

  @override
  String get routeDetailTitle => 'Rota detayı';

  @override
  String get routeDeleting => 'Rota siliniyor';

  @override
  String get routeDetailErrorTitle => 'Rota yüklenemedi';

  @override
  String get routeNotFoundTitle => 'Rota bulunamadı';

  @override
  String get routeNotFoundBody => 'Rota silinmiş veya bu cihaza bağlı değil.';

  @override
  String get routeBackToList => 'Rotalarıma dön';

  @override
  String get routeEdit => 'Düzenle';

  @override
  String get routeDelete => 'Sil';

  @override
  String get routeDeleteConfirmTitle => 'Rota silinsin mi?';

  @override
  String routeDeleteConfirmBody(String name) {
    return '\"$name\" kalıcı olarak silinecek. Bu işlem geri alınamaz.';
  }

  @override
  String get routeDeletedMessage => 'Rota silindi';

  @override
  String get routeSummaryHeading => 'Süre ve mesafe';

  @override
  String get routeTotalDuration => 'Toplam süre';

  @override
  String get routeTravelTime => 'Yolculuk';

  @override
  String get routeVisitTime => 'Ziyaret';

  @override
  String get routeBreakTime => 'Mola';

  @override
  String get routeDistance => 'Karayolu mesafesi';

  @override
  String routeMetricSemantics(String label, String value) {
    return '$label: $value';
  }

  @override
  String get routeEstimateNote =>
      'Yolculuk süresi karayolu mesafesine göre araçla tahmin edilir; trafik ve hava koşulları değiştirebilir.';

  @override
  String get routeStepsHeading => 'Adım adım';

  @override
  String routeStopSemantics(
    int index,
    int count,
    String name,
    String location,
    String visit,
  ) {
    return 'Durak $index / $count: $name, $location. Ziyaret süresi $visit.';
  }

  @override
  String routeVisitLabel(String duration) {
    return 'Ziyaret · $duration';
  }

  @override
  String routeLegLabel(String distance, String duration) {
    return '$distance · araçla ≈ $duration';
  }

  @override
  String routeLegSemantics(String next, String distance, String duration) {
    return 'Sonraki durak $next: $distance, araçla yaklaşık $duration.';
  }

  @override
  String routeBreakSemantics(String kind, String duration) {
    return 'Mola: $kind, $duration';
  }

  @override
  String routeBreakLabel(String kind, String duration) {
    return '$kind · $duration';
  }

  @override
  String get routeBreakShort => 'Kısa mola';

  @override
  String get routeBreakMeal => 'Yemek molası';

  @override
  String get routeBreakRest => 'Dinlenme';

  @override
  String get routeBreakOvernight => 'Konaklama';

  @override
  String get routeBuilderNewTitle => 'Yeni rota';

  @override
  String get routeBuilderEditTitle => 'Rotayı düzenle';

  @override
  String get routeBuilderLoading => 'Eserler yükleniyor';

  @override
  String get routeNameLabel => 'Rota adı';

  @override
  String get routeNameHelper => 'Boş bırakırsanız önerilen ad kullanılır.';

  @override
  String routeDefaultName(String from, String to) {
    return '$from – $to Rotası';
  }

  @override
  String routeDefaultNameSingleCity(String city) {
    return '$city Rotası';
  }

  @override
  String get routeDefaultNameEmpty => 'Kültür Rotası';

  @override
  String routeStopsHeading(int count, int max) {
    return 'Duraklar ($count/$max)';
  }

  @override
  String get routeAddMonuments => 'Eser ekle';

  @override
  String get routePickerDone => 'Tamam';

  @override
  String get routeOptimize => 'Sırayı optimize et';

  @override
  String get routeOptimizeHint =>
      'İlk durak başlangıç olarak kalır; diğerleri en kısa karayolu yolculuk süresine göre sıralanır.';

  @override
  String routeOptimizedAnnouncement(String before, String after) {
    return 'Sıra optimize edildi: kuş uçuşu $before yerine $after.';
  }

  @override
  String get routeOptimizedUnchanged => 'Sıra zaten en kısa.';

  @override
  String get routeEmptyStops => 'Rota için en az 2 eser seçin.';

  @override
  String routeMoveUp(String name) {
    return '$name: yukarı taşı';
  }

  @override
  String routeMoveDown(String name) {
    return '$name: aşağı taşı';
  }

  @override
  String routeRemoveStop(String name) {
    return '$name: rotadan çıkar';
  }

  @override
  String routeStopMovedAnnouncement(String name, int position) {
    return '$name $position. sıraya taşındı';
  }

  @override
  String routeStopAddedAnnouncement(String name) {
    return '$name rotaya eklendi';
  }

  @override
  String routeStopRemovedAnnouncement(String name) {
    return '$name rotadan çıkarıldı';
  }

  @override
  String get routeVisitDuration => 'Ziyaret süresi';

  @override
  String routeDurationDecrease(String label) {
    return '$label: azalt';
  }

  @override
  String routeDurationIncrease(String label) {
    return '$label: artır';
  }

  @override
  String get routeAddBreak => 'Mola ekle';

  @override
  String get routeBreakPickerTitle => 'Mola türü';

  @override
  String routeBreakPickerDefault(String duration) {
    return 'Önerilen süre: $duration';
  }

  @override
  String routeRemoveBreak(String kind) {
    return '$kind: kaldır';
  }

  @override
  String routeBreakLimit(int max) {
    return 'Bir durağa en fazla $max mola eklenebilir.';
  }

  @override
  String routeStraightLineToNext(String distance) {
    return 'Sonraki durağa kuş uçuşu ≈ $distance';
  }

  @override
  String routeBuilderSummary(String stops, String distance) {
    return '$stops · kuş uçuşu ≈ $distance';
  }

  @override
  String routeOptimizedRoadAnnouncement(String before, String after) {
    return 'Sıra optimize edildi: yolculuk $before yerine $after.';
  }

  @override
  String routeBuilderRoadSummary(
    String stops,
    String distance,
    String duration,
  ) {
    return '$stops · karayolu $distance · yolculuk ≈ $duration';
  }

  @override
  String routeRoadToNext(String distance, String duration) {
    return 'Sonraki durağa karayolu $distance · ≈ $duration';
  }

  @override
  String get routeBuilderMapHeading => 'Karayolu önizlemesi';

  @override
  String routeBuilderTimes(String visit, String breaks) {
    return 'Ziyaret $visit · Mola $breaks';
  }

  @override
  String get routeBuilderTravelNote =>
      'Karayolu mesafesi ve yolculuk süresi durakları değiştirdikçe hesaplanır; bağlantı yoksa kuş uçuşu gösterilir.';

  @override
  String get routeCreate => 'Rotayı oluştur';

  @override
  String get routeSaveChanges => 'Değişiklikleri kaydet';

  @override
  String routeCreatedAnnouncement(
    String stops,
    String distance,
    String duration,
  ) {
    return 'Rota oluşturuldu: $stops, $distance, toplam $duration.';
  }

  @override
  String get routeUpdatedAnnouncement => 'Rota güncellendi.';

  @override
  String routeValidationNameTooLong(int max) {
    return 'Rota adı en fazla $max karakter olabilir.';
  }

  @override
  String get routeValidationGeneric => 'Rota bilgilerini kontrol edin.';

  @override
  String routeLimitReached(int max) {
    return 'Bir rotada en fazla $max eser olabilir.';
  }

  @override
  String get routeAddToRoute => 'Rotaya ekle';

  @override
  String get routeRemoveFromRoute => 'Rotadan çıkar';

  @override
  String routeAddedSnack(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rotaya eklendi · taslakta $count eser',
      one: 'Rotaya eklendi · taslakta 1 eser',
    );
    return '$_temp0';
  }

  @override
  String get routeGoToDraft => 'Rotaya git';

  @override
  String get mapSearchHint => 'Yer veya eser ara';

  @override
  String mapSearchEditSemantics(String query) {
    return 'Arama: $query. Düzenlemek için dokunun';
  }

  @override
  String get mapSearchClear => 'Aramayı temizle';

  @override
  String get mapFiltersButton => 'Filtreler';

  @override
  String mapFiltersButtonActive(int count) {
    return 'Filtreler, $count etkin';
  }

  @override
  String mapResultsShowing(int count) {
    return '$count eser gösteriliyor';
  }

  @override
  String get mapNoMatches => 'Eşleşen eser yok';

  @override
  String get mapClearRefinements => 'Temizle';

  @override
  String get mapClearRefinementsSemantics => 'Arama ve filtreleri temizle';

  @override
  String get mapRefinementsClearedAnnouncement =>
      'Arama ve filtreler temizlendi, tüm eserler gösteriliyor';

  @override
  String get mapLocateMe => 'Konumumu göster';

  @override
  String get mapLocating => 'Konumunuz alınıyor';

  @override
  String get mapUserLocationSemantics => 'Konumunuz';

  @override
  String get mapLocationShownAnnouncement => 'Konumunuz gösteriliyor';

  @override
  String get locationIssueServiceDisabled =>
      'Konum servisleri kapalı. Konumunuzu görmek için açın.';

  @override
  String get locationIssuePermissionDenied =>
      'Konum izni verilmedi. Konumunuzu görmek için izin verin.';

  @override
  String get locationIssuePermissionDeniedForever =>
      'Konum izni kapalı. Ayarlardan izin verebilirsiniz.';

  @override
  String get locationIssueUnavailable =>
      'Konumunuz şu anda alınamıyor. Lütfen tekrar deneyin.';

  @override
  String get locationOutsideRegion => 'Konumunuz harita alanının dışında.';

  @override
  String get locationOpenSettings => 'Ayarlar';

  @override
  String get searchAllMonuments => 'Tüm eserler';

  @override
  String get searchPlacesHeader => 'Yerler';

  @override
  String get searchMonumentsHeader => 'Eserler';

  @override
  String searchShowOnMap(String name) {
    return '$name: haritada göster';
  }

  @override
  String get searchNoResultsTitle => 'Sonuç bulunamadı';

  @override
  String searchNoResultsBody(String query) {
    return '“$query” için eşleşen yer veya eser yok. Yazımı kontrol edin ya da daha kısa bir arama deneyin.';
  }

  @override
  String searchResultsAnnouncement(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sonuç',
      zero: 'Sonuç bulunamadı',
    );
    return '$_temp0';
  }

  @override
  String get searchRemoveFilters => 'Filtreleri kaldır';

  @override
  String searchPlaceAnnouncement(String place, int count) {
    return '$place: $count eser';
  }

  @override
  String get filterSheetTitle => 'Filtreler';

  @override
  String get filterCategorySection => 'Yapı türü';

  @override
  String get filterPeriodSection => 'Dönem';

  @override
  String get filterCitySection => 'İl';

  @override
  String filterOptionWithCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String get accountButtonGuestSemantics => 'Hesap menüsü, misafir';

  @override
  String accountButtonSemantics(String name) {
    return 'Hesap menüsü, $name';
  }

  @override
  String get accountMenuGuestTitle => 'Misafir';

  @override
  String get accountMenuGuestBody =>
      'Anı paylaşmak ve hasar bildirmek için giriş yapın.';

  @override
  String get accountMenuProfile => 'Profilim';

  @override
  String get accountMenuSignIn => 'Giriş yap veya kayıt ol';

  @override
  String searchResultsTotal(int count) {
    return '$count sonuç';
  }

  @override
  String searchApplyToMap(int count) {
    return '$count sonucu haritada göster';
  }

  @override
  String get searchLoadingMore => 'Daha fazla sonuç yükleniyor';

  @override
  String get searchLoadMoreFailed => 'Sonraki sonuçlar yüklenemedi.';

  @override
  String searchEndOfResults(int count) {
    return 'Tüm sonuçlar gösterildi ($count)';
  }

  @override
  String searchMoreLoadedAnnouncement(int count) {
    return '$count sonuç daha yüklendi';
  }

  @override
  String get searchLoadFailedTitle => 'Sonuçlar yüklenemedi';

  @override
  String get searchNoFilterResultsBody =>
      'Seçili filtrelere uyan eser yok. Filtreleri kaldırmayı deneyin.';

  @override
  String filterSelectionSummary(String first, int more) {
    return '$first +$more';
  }

  @override
  String filterGroupSemantics(String group, String selection) {
    return '$group filtresi: $selection';
  }

  @override
  String get filterNoneSelected => 'seçim yok';

  @override
  String get filterApplyButton => 'Uygula';

  @override
  String get filterGroupClear => 'Temizle';

  @override
  String get filterClearAllChip => 'Filtreleri temizle';

  @override
  String get mapRefinementFailed => 'Arama haritaya uygulanamadı.';

  @override
  String mapClusterSemantics(int count) {
    return '$count eserlik küme. Yakınlaştırmak için dokunun.';
  }

  @override
  String mapClusterListSemantics(int count) {
    return 'Aynı konumda $count eser. Listelemek için dokunun.';
  }

  @override
  String mapClusterExpandedAnnouncement(int count) {
    return '$count eserlik bölgeye yakınlaştırıldı';
  }

  @override
  String get mapClusterSheetTitle => 'Bu konumdaki eserler';

  @override
  String get mapPreviewLoading => 'Önizleme yükleniyor';

  @override
  String get mapPreviewLoadFailed => 'Eser önizlemesi yüklenemedi.';

  @override
  String get mapClusterLoadFailed => 'Bu konumdaki eserler yüklenemedi.';

  @override
  String get settingsReduceMotionSystemOn =>
      'Cihazınızın erişilebilirlik ayarlarında açık olduğu için uygulamada her zaman uygulanır.';

  @override
  String get settingsPermissionsSection => 'Gizlilik ve izinler';

  @override
  String get settingsAboutSection => 'Hakkında';

  @override
  String get settingsReplayOnboarding => 'Uygulama tanıtımını yeniden göster';

  @override
  String get settingsPrivacyNotice => 'KVKK Aydınlatma Metni';

  @override
  String get settingsTermsOfUse => 'Kullanım Koşulları';

  @override
  String get permissionLocationTitle => 'Konum';

  @override
  String get permissionLocationPurpose =>
      'Yakınınızdaki vakıf eserlerini haritada göstermek için kullanılır. Haritada konumunuz yalnızca cihazınızda işlenir. Yalnızca bir hasar bildirimine eklemeyi seçerseniz o bildirimle gönderilir.';

  @override
  String get permissionStatusChecking => 'Durum kontrol ediliyor';

  @override
  String get permissionStatusGranted => 'İzin verildi';

  @override
  String get permissionStatusNotGranted => 'İzin verilmedi';

  @override
  String get permissionStatusBlocked =>
      'Kapalı. Sistem ayarlarından izin verebilirsiniz.';

  @override
  String get permissionStatusBlockedBrowser =>
      'Kapalı. Tarayıcınızın adres çubuğundaki simgeden veya site ayarlarından izin verebilirsiniz.';

  @override
  String get permissionStatusServiceDisabled =>
      'Cihazın konum servisleri kapalı.';

  @override
  String get permissionStatusUnsupported => 'Bu cihazda kullanılamıyor.';

  @override
  String permissionStatusSemantics(String permission, String status) {
    return '$permission izni: $status';
  }

  @override
  String get permissionLocationAllow => 'Konum iznini ver';

  @override
  String get permissionCameraTitle => 'Kamera';

  @override
  String get permissionCameraPurpose =>
      'Anı Köşesi\'nde ve hasar bildirimlerinde fotoğraf çekmek için kullanılır. Fotoğraf yalnızca siz paylaştığınızda yüklenir; konum bilgisi önceden silinir.';

  @override
  String get permissionCameraAllow => 'Kamera iznini ver';

  @override
  String get permissionMicrophoneTitle => 'Mikrofon';

  @override
  String get permissionMicrophonePurpose =>
      'Dijital Rehber\'e sesli soru sormak için kullanılır. Konuşmanız cihazınızın veya tarayıcınızın konuşma tanıma servisiyle metne çevrilir; uygulama ses kaydı saklamaz ve siz göndermeden soru iletilmez.';

  @override
  String get permissionMicrophoneAllow => 'Mikrofon iznini ver';

  @override
  String get permissionOpenAppSettings => 'Uygulama ayarlarını aç';

  @override
  String get permissionOpenLocationSettings => 'Konum ayarlarını aç';

  @override
  String get permissionManageInSettings => 'Sistem ayarlarında yönet';

  @override
  String get permissionOnDemandNote =>
      'İzin vermeseniz de uygulamayı kullanabilirsiniz. Bir özellik izne ihtiyaç duyduğunda (fotoğraf çekmek, sesli soru sormak) yeniden sorulur.';

  @override
  String onboardingStepCounter(int current, int total) {
    return 'Adım $current / $total';
  }

  @override
  String onboardingStepAnnouncement(int current, int total, String title) {
    return 'Adım $current / $total: $title';
  }

  @override
  String get onboardingBack => 'Geri';

  @override
  String get onboardingSkip => 'Atla';

  @override
  String get onboardingSkipSemantics => 'Tanıtımı atla';

  @override
  String get onboardingStart => 'Başlayın';

  @override
  String get onboardingNext => 'Devam';

  @override
  String get onboardingWelcomeTitle => 'Hoş geldiniz';

  @override
  String get onboardingWelcomeDescription =>
      'Vakıf eserlerini haritada keşfedin, ayrıntılarını inceleyin ve gezinizi planlayın. Başlamadan önce uygulamayı size göre ayarlayalım; önce dilinizi seçin.';

  @override
  String get onboardingDisplayTitle => 'Görünüm';

  @override
  String get onboardingDisplayDescription =>
      'Açık, koyu veya cihazınızı izleyen temayı seçin. Değişiklik hemen uygulanır.';

  @override
  String get onboardingAccessibilityTitle => 'Erişilebilirlik';

  @override
  String get onboardingAccessibilityDescription =>
      'Vakıf Atlas ekran okuyucu (TalkBack, VoiceOver), klavye ve büyük metinle kullanılabilir. Metin boyutu, yüksek kontrast, renk görme, hareket ve titreşim tercihlerini tek sayfadan ayarlayın; sonra hesap menüsündeki Erişilebilirlik\'ten de değiştirebilirsiniz.';

  @override
  String get onboardingChangeLaterNote =>
      'Bu tercihleri istediğiniz zaman Ayarlar\'dan değiştirebilirsiniz.';

  @override
  String get onboardingTourTitle => 'Vakıf Atlas\'ı tanıyın';

  @override
  String get onboardingTourDescription =>
      'Uygulamayı nasıl kullanacağınıza kısa bir bakış.';

  @override
  String get onboardingTourMapTitle => 'Haritada keşfedin';

  @override
  String get onboardingTourMapBody =>
      'Eserler haritada gruplanarak gösterilir. Bir gruba dokunarak yakınlaşın; bir esere dokunarak ayrıntılarını ve fotoğraflarını açın.';

  @override
  String get onboardingTourSearchTitle => 'Arayın ve filtreleyin';

  @override
  String get onboardingTourSearchBody =>
      'Eser, il veya ilçe adıyla arayın; yapı türü, dönem ve ile göre daraltın ve sonuçları haritada görün.';

  @override
  String get onboardingTourRoutesTitle => 'Rotanızı planlayın';

  @override
  String get onboardingTourRoutesBody =>
      '2–10 eserden gezi rotası oluşturun, sırayı tek dokunuşla en kısa yola göre düzenleyin. Rotalarınız hesap gerektirmeden bu cihaza bağlı olarak saklanır.';

  @override
  String get onboardingTourContributeTitle => 'Katkıda bulunun';

  @override
  String get onboardingTourContributeBody =>
      'Hesabınızla Anı Köşesi\'nde eserlerle ilgili anılarınızı paylaşabilir, gördüğünüz hasarları bildirebilirsiniz.';

  @override
  String get onboardingPermissionsTitle => 'İzinler';

  @override
  String get onboardingPermissionsDescription =>
      'İzinler yalnızca ilgili özellik için, nedeni açıklanarak istenir. Hiçbiri zorunlu değildir; izin vermeden de uygulamayı kullanabilirsiniz.';

  @override
  String get onboardingPermissionsChangeLater =>
      'İzinleri istediğiniz zaman Ayarlar\'dan veya cihazınızın sistem ayarlarından değiştirebilirsiniz.';

  @override
  String get onboardingPrivacyNoticeLink => 'KVKK Aydınlatma Metni\'ni okuyun';

  @override
  String get onboardingAccountTitle => 'Nasıl devam etmek istersiniz?';

  @override
  String get onboardingAccountDescription =>
      'Harita, arama ve rota planlama için hesap gerekmez. Anı paylaşmak ve hasar bildirmek için giriş yapın.';

  @override
  String get onboardingSignIn => 'Giriş yap';

  @override
  String get onboardingCreateAccount => 'Hesap oluştur';

  @override
  String get onboardingContinueAsGuest => 'Misafir olarak devam et';

  @override
  String onboardingSignedInTitle(String name) {
    return 'Hoş geldiniz, $name';
  }

  @override
  String get onboardingSignedInDescription =>
      'Oturumunuz açık ve tercihleriniz kaydedildi.';

  @override
  String get onboardingContinueSignedIn => 'Uygulamaya devam et';

  @override
  String get routePickerSearchHint => 'Rotaya eklenecek eseri ara';

  @override
  String routePickerStopSubtitle(String details, int position) {
    return '$details · $position. durak';
  }

  @override
  String get routeExportAction => 'PDF olarak dışa aktar';

  @override
  String get routeExportInProgress => 'PDF hazırlanıyor';

  @override
  String get routeExportReadyTitle => 'PDF hazır';

  @override
  String routeExportReadyAnnouncement(String fileName) {
    return 'PDF hazır: $fileName';
  }

  @override
  String get routeExportSavedNote => 'Dışa aktarımlarım\'a kaydedildi.';

  @override
  String get routeExportGuestSavedNote =>
      'Bu cihazın Dışa aktarımlarım listesine kaydedildi. Giriş yaparsanız hesabınıza taşınır ve diğer cihazlarınızda da görünür.';

  @override
  String get routeExportOpenExports => 'Dışa aktarımlarım';

  @override
  String get routeExportArchiveFailed =>
      'PDF hazır ancak Dışa aktarımlarım\'a kaydedilemedi. Yine de paylaşabilir veya yazdırabilirsiniz.';

  @override
  String get routeExportFailed => 'PDF oluşturulamadı. Lütfen tekrar deneyin.';

  @override
  String get routeExportShare => 'Paylaş';

  @override
  String get routeExportCopyLink => 'Bağlantıyı kopyala';

  @override
  String routeExportLinkCopied(String date) {
    return 'Bağlantı kopyalandı. Bağlantıya sahip herkes PDF\'i $date tarihine kadar açabilir; dışa aktarımı silerseniz bağlantı çalışmaz.';
  }

  @override
  String get routeExportPrint => 'Yazdır';

  @override
  String get routeExportPreview => 'Önizle';

  @override
  String get routeExportSignIn => 'Giriş yap';

  @override
  String get routeExportShareFailed => 'Paylaşım penceresi açılamadı.';

  @override
  String get routeExportPrintFailed => 'Yazdırma penceresi açılamadı.';

  @override
  String get routeExportSketchHeading => 'Rota haritası';

  @override
  String get routeExportSketchCaption =>
      'Kuzey yukarıdadır. Numaralar aşağıdaki durak listesine karşılık gelir; içi dolu işaret başlangıç durağıdır.';

  @override
  String get routeExportStopsHeading => 'Duraklar ve yolculuk';

  @override
  String get routeExportMapLink => 'Konumu haritada aç';

  @override
  String get routeExportAttribution =>
      'Yol verisi © OpenStreetMap katkıcıları (ODbL); mesafe ve süreler OSRM ile hesaplanmıştır.';

  @override
  String routeExportPageOf(String page, String total) {
    return 'Sayfa $page / $total';
  }

  @override
  String routeExportGeneratedOn(String date) {
    return 'Hazırlanma: $date';
  }

  @override
  String get routeExportsTitle => 'Dışa aktarımlarım';

  @override
  String get routeExportsEmptyTitle => 'Henüz dışa aktarım yok';

  @override
  String get routeExportsEmptyBody =>
      'Bir rotanın sayfasındaki PDF simgesine dokunduğunuzda dışa aktarım burada görünür.';

  @override
  String routeExportsItemSubtitle(String date, String stops, String size) {
    return '$date · $stops · $size';
  }

  @override
  String routeExportsMoreActions(String name) {
    return '$name için işlemler';
  }

  @override
  String get routeExportsDelete => 'Sil';

  @override
  String get routeExportsDeleteConfirmTitle => 'Dışa aktarım silinsin mi?';

  @override
  String routeExportsDeleteConfirmBody(String name) {
    return '“$name” PDF\'i arşivinizden kalıcı olarak silinecek. Rotanın kendisi silinmez.';
  }

  @override
  String get routeExportsDeleted => 'Dışa aktarım silindi';

  @override
  String get routeExportsLoadFailedTitle => 'Dışa aktarımlar yüklenemedi';

  @override
  String fileSizeKilobytes(String size) {
    return '$size KB';
  }

  @override
  String fileSizeMegabytes(String size) {
    return '$size MB';
  }

  @override
  String get memoryCornerSubtitle => 'Ziyaretçilerin bu esere dair anıları';

  @override
  String memoryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count anı',
      one: '1 anı',
      zero: 'Henüz anı yok',
    );
    return '$_temp0';
  }

  @override
  String get memoryShare => 'Anı paylaş';

  @override
  String memoryViewAll(int count) {
    return 'Tüm anıları gör ($count)';
  }

  @override
  String get memoryEmptyTitle => 'Henüz anı paylaşılmamış';

  @override
  String get memoryEmptyBody =>
      'Bu eseri ziyaret ettiyseniz ilk anıyı siz paylaşın.';

  @override
  String get memoryLoading => 'Anılar yükleniyor';

  @override
  String get memoryLoadFailedTitle => 'Anılar yüklenemedi';

  @override
  String get memoryLoadMoreFailed => 'Daha fazla anı yüklenemedi.';

  @override
  String get myMemoriesTitle => 'Anılarım';

  @override
  String myMemoriesViewAll(int count) {
    return 'Tüm anılarım ($count)';
  }

  @override
  String get myMemoriesEmptyTitle => 'Henüz anı paylaşmadınız';

  @override
  String get myMemoriesEmptyBody =>
      'Ziyaret ettiğiniz bir eserin Anı Köşesi\'nde fotoğraf ve notla anınızı paylaşın.';

  @override
  String get myMemoriesLoading => 'Anılarınız yükleniyor';

  @override
  String get myMemoriesLoadFailed => 'Anılarınız yüklenemedi.';

  @override
  String get myMemoriesUnknownMonument => 'Vakıf eseri';

  @override
  String get myMemoriesOpenCorner => 'Anı Köşesi\'nde gör';

  @override
  String myMemoriesOpenCornerSemantics(String name) {
    return '$name Anı Köşesi\'nde gör';
  }

  @override
  String myMemoriesPreviewSemantics(String name, String date, String text) {
    return '$name, $date: $text';
  }

  @override
  String get myMemoriesStatusPending =>
      'İnceleniyor; onaylanınca Anı Köşesi\'nde yayınlanır. O zamana kadar yalnızca burada görünür.';

  @override
  String get myMemoriesStatusRejected =>
      'Topluluk kurallarına uymadığı için yayınlanmadı; Anı Köşesi\'nde görünmez, yalnızca burada görünür.';

  @override
  String get memoryOwnBadge => 'Siz';

  @override
  String memoryVisited(String date) {
    return 'Ziyaret: $date';
  }

  @override
  String memoryCardSemantics(String author, String date) {
    return '$author tarafından $date tarihinde paylaşıldı';
  }

  @override
  String memoryOwnCardSemantics(String date) {
    return 'Sizin anınız, $date tarihinde paylaşıldı';
  }

  @override
  String get memoryReadMore => 'Devamını oku';

  @override
  String get memoryReadLess => 'Daha az göster';

  @override
  String memoryMoreActions(String author) {
    return '$author anısı için diğer işlemler';
  }

  @override
  String get memoryDelete => 'Sil';

  @override
  String get memoryReport => 'Bildir';

  @override
  String get memoryDeleteConfirmTitle => 'Anı silinsin mi?';

  @override
  String get memoryDeleteConfirmBody =>
      'Bu anı ve fotoğrafları herkes için kalıcı olarak silinecek.';

  @override
  String get memoryDeleted => 'Anınız silindi';

  @override
  String get memoryReportTitle => 'Anıyı bildir';

  @override
  String get memoryReportQuestion => 'Bu anı neden uygun değil?';

  @override
  String get memoryReportReasonOffensive =>
      'Nefret söylemi, taciz veya hakaret';

  @override
  String get memoryReportReasonInappropriate =>
      'Müstehcen, şiddet içeren veya rahatsız edici';

  @override
  String get memoryReportReasonSpam => 'Reklam veya spam';

  @override
  String get memoryReportReasonPersonalInfo =>
      'Başkalarının kişisel bilgilerini içeriyor';

  @override
  String get memoryReportReasonUnrelated => 'Bu eserle ilgisi yok';

  @override
  String get memoryReportReasonOther => 'Diğer';

  @override
  String get memoryReportNoteLabel => 'Açıklama (isteğe bağlı)';

  @override
  String get memoryReportReasonRequired => 'Bir neden seçin.';

  @override
  String get memoryReportNotice =>
      'Bildiriminiz Vakıflar Genel Müdürlüğü tarafından incelenir. Bildirdiğiniz anı artık size gösterilmez.';

  @override
  String get memoryReported => 'Bildiriminiz alındı, teşekkür ederiz';

  @override
  String get memorySignInTitle => 'Giriş yapmanız gerekiyor';

  @override
  String get memorySignInToShare =>
      'Anı paylaşmak için giriş yapın. Anıları okumak için giriş gerekmez.';

  @override
  String get memorySignInToReport => 'Bir anıyı bildirmek için giriş yapın.';

  @override
  String get memoryComposerClose => 'Anı paylaşmayı kapat';

  @override
  String get memoryTextLabel => 'Anınız';

  @override
  String get memoryTextHint =>
      'Bu eserde neler yaşadınız, neler dikkatinizi çekti?';

  @override
  String get memoryTextEmptyError => 'Anınızı yazın.';

  @override
  String memoryTextTooLongError(int max) {
    return 'Anı en fazla $max karakter olabilir.';
  }

  @override
  String get photosHeading => 'Fotoğraflar';

  @override
  String photosHint(int max) {
    return 'İsteğe bağlı · en fazla $max fotoğraf';
  }

  @override
  String photosCountSemantics(int count, int max) {
    return '$max fotoğraftan $count tanesi eklendi';
  }

  @override
  String get photoAdd => 'Fotoğraf ekle';

  @override
  String get photoTake => 'Fotoğraf çek';

  @override
  String get photoChooseFromGallery => 'Galeriden seç';

  @override
  String photoRemove(int index) {
    return '$index. fotoğrafı kaldır';
  }

  @override
  String get photoAddDescription => 'Açıklama ekle';

  @override
  String get photoEditDescription => 'Açıklamayı düzenle';

  @override
  String photoDraftSemantics(int index, String description) {
    return 'Fotoğraf $index: $description';
  }

  @override
  String photoDraftNoDescription(int index) {
    return 'Fotoğraf $index, açıklama eklenmedi';
  }

  @override
  String photoDescriptionAction(int index) {
    return '$index. fotoğraf için açıklama';
  }

  @override
  String get photoProcessing => 'Fotoğraf hazırlanıyor';

  @override
  String get photoDescriptionTitle => 'Fotoğraf açıklaması';

  @override
  String get photoDescriptionLabel => 'Açıklama';

  @override
  String get photoDescriptionHelper =>
      'Ekran okuyucu kullananlar için fotoğrafta ne göründüğünü kısaca anlatın.';

  @override
  String photoDescriptionTooLong(int max) {
    return 'Açıklama en fazla $max karakter olabilir.';
  }

  @override
  String get commonSave => 'Kaydet';

  @override
  String get photoCameraDenied =>
      'Kamera izni verilmedi. İzni cihaz ayarlarından verebilirsiniz.';

  @override
  String get photoCameraDeniedBrowser =>
      'Kamera izni verilmedi. Tarayıcınızın adres çubuğundaki kamera simgesinden veya site ayarlarından izin verebilirsiniz.';

  @override
  String get cameraCaptureTitle => 'Fotoğraf çek';

  @override
  String get cameraCaptureOpening =>
      'Kamera açılıyor. Tarayıcınız izin isterse onaylayın.';

  @override
  String get cameraCaptureReady =>
      'Kamera hazır. Fotoğrafı çekmek için deklanşöre dokunun.';

  @override
  String get cameraCaptureShutter => 'Fotoğrafı çek';

  @override
  String get cameraCaptureSwitch => 'Kamerayı değiştir';

  @override
  String get cameraCaptureCapturing => 'Fotoğraf çekiliyor';

  @override
  String get cameraCaptureDeniedTitle => 'Kamera izni verilmedi';

  @override
  String get cameraCaptureDeniedBody =>
      'Tarayıcınızın adres çubuğundaki kamera simgesinden veya site ayarlarından bu siteye kamera izni verip tekrar deneyin.';

  @override
  String get cameraCaptureNoCameraTitle => 'Kamera bulunamadı';

  @override
  String get cameraCaptureNoCameraBody =>
      'Bu cihazda kullanılabilir kamera yok. Fotoğrafı galeriden seçebilirsiniz.';

  @override
  String get cameraCaptureFailedTitle => 'Kamera açılamadı';

  @override
  String get cameraCaptureFailedBody =>
      'Kamera başka bir uygulama tarafından kullanılıyor olabilir. Kapatıp tekrar deneyin.';

  @override
  String get cameraCaptureShotFailed => 'Fotoğraf çekilemedi. Tekrar deneyin.';

  @override
  String get photoGalleryDenied =>
      'Fotoğraflara erişim izni verilmedi. İzni cihaz ayarlarından verebilirsiniz.';

  @override
  String get photoPickFailed => 'Fotoğraf seçilemedi. Lütfen tekrar deneyin.';

  @override
  String photoUnsupported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count fotoğraf açılamadı. JPEG, PNG veya WebP biçiminde fotoğraflar seçin.',
      one: 'Bir fotoğraf açılamadı. JPEG, PNG veya WebP biçiminde bir fotoğraf seçin.',
    );
    return '$_temp0';
  }

  @override
  String photoLimitReached(int max) {
    return 'En fazla $max fotoğraf ekleyebilirsiniz.';
  }

  @override
  String get memoryVisitHeading => 'Ziyaret tarihi';

  @override
  String get memoryVisitOptional => 'İsteğe bağlı';

  @override
  String get memoryVisitPick => 'Tarih seçin';

  @override
  String memoryVisitChange(String date) {
    return 'Ziyaret tarihi: $date. Değiştir';
  }

  @override
  String get memoryVisitClear => 'Ziyaret tarihini kaldır';

  @override
  String memoryPublicNotice(String name) {
    return 'Anınız herkese açık olarak bu eserin sayfasında “$name” adıyla görünür. Fotoğraflardaki konum ve cihaz bilgileri yüklenmeden önce silinir. Lütfen başkalarının kişisel bilgilerini paylaşmayın.';
  }

  @override
  String get memorySubmit => 'Paylaş';

  @override
  String photosUploading(int percent) {
    return 'Fotoğraflar yükleniyor · %$percent';
  }

  @override
  String get photosUploadingSemantics => 'Fotoğraf yükleme ilerlemesi';

  @override
  String get memoryShared => 'Anınız paylaşıldı';

  @override
  String get memoryFixErrors => 'Paylaşmadan önce işaretli alanları düzeltin.';

  @override
  String get memoryDiscardTitle => 'Anı taslağı silinsin mi?';

  @override
  String get memoryDiscardBody =>
      'Yazdıklarınız ve eklediğiniz fotoğraflar kaybolacak.';

  @override
  String get memoryDiscardConfirm => 'Taslağı sil';

  @override
  String get memoryKeepEditing => 'Düzenlemeye devam et';

  @override
  String get memoryPhotoNoDescription =>
      'Paylaşan kişi bu fotoğraf için açıklama eklememiş.';

  @override
  String memoryPhotoCredit(String author, String date) {
    return '$author · $date';
  }

  @override
  String photoTileSemantics(int index, int count, String description) {
    return 'Fotoğraf $index / $count: $description';
  }

  @override
  String photoTileNoDescription(int index, int count) {
    return 'Fotoğraf $index / $count, açıklama yok';
  }

  @override
  String get photoOpenHint => 'tam ekran aç';

  @override
  String get memoryEntryOpenHint => 'zaman çizelgesini aç';

  @override
  String get memoryEntryLatest => 'Son anı';

  @override
  String memoryEntrySemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Anı Köşesi, $count anı',
      one: 'Anı Köşesi, 1 anı',
      zero: 'Anı Köşesi, henüz anı yok',
    );
    return '$_temp0';
  }

  @override
  String memorySharedOn(String date) {
    return 'Paylaşım: $date';
  }

  @override
  String get memoryFilterHeading => 'Zamana göre filtrele';

  @override
  String memoryFilterAll(int count) {
    return 'Tümü ($count)';
  }

  @override
  String memoryFilterYear(String year, int count) {
    return '$year ($count)';
  }

  @override
  String memoryFilterYearSemantics(String year, int count) {
    return '$year yılı, $count anı';
  }

  @override
  String get memoryFilterRange => 'Tarih aralığı';

  @override
  String get memoryFilterRangeHelp => 'Anı tarihi aralığı seçin';

  @override
  String get memoryFilterClearRange => 'Tarih aralığını kaldır';

  @override
  String get memoryFilterEmptyTitle => 'Bu dönemde anı yok';

  @override
  String get memoryFilterEmptyBody =>
      'Farklı bir yıl veya tarih aralığı seçin.';

  @override
  String get memoryFilterClear => 'Filtreyi temizle';

  @override
  String memoryFilterResult(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count anı gösteriliyor',
      one: '1 anı gösteriliyor',
      zero: 'Bu dönemde anı yok',
    );
    return '$_temp0';
  }

  @override
  String get memoryTimelineHint =>
      'Anılar ziyaret tarihine (yoksa paylaşım tarihine) göre sıralanır.';

  @override
  String get navCivilProtection => 'Sivil Koruma';

  @override
  String get cpIntroTitle => 'Kültürel mirası birlikte koruyalım';

  @override
  String get cpIntroBody =>
      'Vakıf eserlerinde gördüğünüz hasarı, vandalizmi veya tehlikeyi Vakıflar Genel Müdürlüğü\'ne bildirin. Her bildirime bir kayıt numarası verilir ve süreci buradan takip edersiniz.';

  @override
  String get cpIntroStep1Title => 'Eseri ve durumu seçin';

  @override
  String get cpIntroStep1Body =>
      'Hasar türünü ve ne kadar acil olduğunu belirtin.';

  @override
  String get cpIntroStep2Title => 'Anlatın ve fotoğraflayın';

  @override
  String get cpIntroStep2Body =>
      'Ne gördüğünüzü yazın; fotoğraflar değerlendirmeyi hızlandırır.';

  @override
  String get cpIntroStep3Title => 'Süreci takip edin';

  @override
  String get cpIntroStep3Body =>
      'VGM\'nin incelemesini ve yaptığı işlemi bu ekrandan izleyin.';

  @override
  String get cpSignInPrompt =>
      'Bildirim göndermek ve takip etmek için giriş yapın.';

  @override
  String get cpEmergencyNotice =>
      'Can güvenliğini tehdit eden acil durumlarda önce 112 Acil Çağrı Merkezi\'ni arayın.';

  @override
  String get cpNewReport => 'Hasar bildir';

  @override
  String get cpMyReports => 'Bildirimlerim';

  @override
  String get cpReportsEmptyTitle => 'Henüz bildiriminiz yok';

  @override
  String get cpReportsEmptyBody =>
      'Bir vakıf eserinde hasar veya tehlike gördüğünüzde buradan bildirebilirsiniz.';

  @override
  String get cpReportsLoading => 'Bildirimler yükleniyor';

  @override
  String get cpReportsLoadFailed => 'Bildirimler yüklenemedi';

  @override
  String get cpLoadMoreFailed => 'Daha fazla bildirim yüklenemedi.';

  @override
  String cpReportItemSemantics(
    String monument,
    String category,
    String reference,
    String status,
    String date,
  ) {
    return '$monument, $category. Kayıt $reference. Durum: $status. $date';
  }

  @override
  String get cpCategoryStructural => 'Yapısal hasar';

  @override
  String get cpCategoryStructuralBody => 'Çatlak, ayrışma, bozulma';

  @override
  String get cpCategoryCollapse => 'Çökme veya düşme tehlikesi';

  @override
  String get cpCategoryCollapseBody => 'Gevşemiş taş, sarkan parça, eğilme';

  @override
  String get cpCategoryVandalism => 'Vandalizm';

  @override
  String get cpCategoryVandalismBody => 'Yazı, çizim, kırma, tahribat';

  @override
  String get cpCategoryTheft => 'Hırsızlık veya eksik parça';

  @override
  String get cpCategoryTheftBody => 'Çini, kitabe, süsleme veya parça eksik';

  @override
  String get cpCategoryFireWater => 'Yangın veya su hasarı';

  @override
  String get cpCategoryFireWaterBody => 'Yangın izi, su baskını, sızıntı';

  @override
  String get cpCategoryUnauthorized => 'İzinsiz yapı veya onarım';

  @override
  String get cpCategoryUnauthorizedBody => 'İzinsiz inşaat, kazı veya müdahale';

  @override
  String get cpCategoryOther => 'Diğer';

  @override
  String get cpCategoryOtherBody => 'Yukarıdakilere uymayan bir durum';

  @override
  String get cpUrgencyLow => 'Düşük';

  @override
  String get cpUrgencyLowBody => 'Acil değil, zamanla kötüleşebilir';

  @override
  String get cpUrgencyMedium => 'Orta';

  @override
  String get cpUrgencyMediumBody => 'Kısa sürede incelenmeli';

  @override
  String get cpUrgencyHigh => 'Yüksek';

  @override
  String get cpUrgencyHighBody => 'Hasar büyüyor veya ziyaretçileri etkiliyor';

  @override
  String get cpUrgencyCritical => 'Kritik';

  @override
  String get cpUrgencyCriticalBody =>
      'Yapı veya çevresi için ciddi ve yakın tehlike';

  @override
  String get cpStatusReceived => 'Alındı';

  @override
  String get cpStatusInReview => 'İnceleniyor';

  @override
  String get cpStatusForwarded => 'Yetkili birime iletildi';

  @override
  String get cpStatusResolved => 'Sonuçlandı';

  @override
  String get cpStatusClosed => 'Kapatıldı';

  @override
  String get cpStatusReceivedBody => 'Bildiriminiz kayda alındı.';

  @override
  String get cpStatusInReviewBody =>
      'VGM Sivil Koruma birimi bildiriminizi inceliyor.';

  @override
  String get cpStatusForwardedBody =>
      'Gerekli işlem için yetkili bölge müdürlüğüne iletildi.';

  @override
  String get cpStatusResolvedBody => 'Gerekli işlem yapıldı.';

  @override
  String get cpStatusClosedBody => 'Bildirim işlem gerektirmeden kapatıldı.';

  @override
  String get cpStatusPending => 'Bekleniyor';

  @override
  String cpStatusStepSemantics(String status, String state) {
    return '$status, $state';
  }

  @override
  String get cpStatusDone => 'tamamlandı';

  @override
  String get cpStatusCurrent => 'şu anki adım';

  @override
  String get cpWizardTitle => 'Hasar bildirimi';

  @override
  String get cpWizardClose => 'Bildirimi kapat';

  @override
  String cpStepProgress(int current, int total, String title) {
    return 'Adım $current/$total: $title';
  }

  @override
  String get cpStepMonument => 'Eser';

  @override
  String get cpStepCategory => 'Hasar türü';

  @override
  String get cpStepUrgency => 'Aciliyet';

  @override
  String get cpStepDetails => 'Açıklama ve fotoğraf';

  @override
  String get cpStepLocation => 'Konum';

  @override
  String get cpStepReview => 'Gözden geçir';

  @override
  String get cpStepMonumentQuestion => 'Bildiriminiz hangi eserle ilgili?';

  @override
  String get cpStepCategoryQuestion => 'Ne gördünüz?';

  @override
  String get cpStepUrgencyQuestion => 'Ne kadar acil?';

  @override
  String get cpStepDetailsQuestion => 'Durumu anlatın';

  @override
  String get cpStepLocationQuestion => 'Konumunuzu eklemek ister misiniz?';

  @override
  String get cpStepReviewQuestion => 'Bildiriminizi kontrol edin';

  @override
  String get cpChooseMonument => 'Eser seç';

  @override
  String get cpChangeMonument => 'Eseri değiştir';

  @override
  String get cpMonumentPickerTitle => 'Eser seçin';

  @override
  String get cpMonumentPickerHint => 'Eser veya yer ara';

  @override
  String get cpMonumentLoadFailed => 'Eser bilgisi alınamadı.';

  @override
  String get cpDescriptionLabel => 'Açıklama';

  @override
  String get cpDescriptionHint =>
      'Hasarın yerini ve durumunu anlatın: hangi cephe, ne büyüklükte, ne zamandır…';

  @override
  String cpDescriptionTooShort(int min) {
    return 'En az $min karakterle açıklayın.';
  }

  @override
  String cpDescriptionTooLong(int max) {
    return 'Açıklama en fazla $max karakter olabilir.';
  }

  @override
  String get cpLocationExplain =>
      'Konumunuz, bildirimin eserin yanında yapıldığını doğrulamak için yalnızca bu bildirimle VGM\'ye iletilir; başka bir amaçla kullanılmaz. Eklemeden de gönderebilirsiniz.';

  @override
  String get cpLocationToggle => 'Konumumu bu bildirime ekle';

  @override
  String get cpLocationLocating => 'Konumunuz alınıyor…';

  @override
  String cpLocationFound(int accuracy) {
    return 'Konumunuz alındı (±$accuracy m).';
  }

  @override
  String cpLocationDistance(String distance) {
    return 'Esere yaklaşık $distance uzaklıktasınız.';
  }

  @override
  String get cpLocationOnSite =>
      'Eserin yakınındasınız; bildiriminiz yerinde yapılmış olarak işaretlenecek.';

  @override
  String get cpLocationFar =>
      'Esere uzaktasınız; bildiriminiz yine de iletilir.';

  @override
  String get cpLocationServiceDisabled =>
      'Konum servisleri kapalı. Ayarlardan açabilir veya konumsuz devam edebilirsiniz.';

  @override
  String get cpLocationDenied =>
      'Konum izni verilmedi. Konumsuz devam edebilirsiniz.';

  @override
  String get cpLocationDeniedForever =>
      'Konum izni kapalı. Ayarlardan izin verebilir veya konumsuz devam edebilirsiniz.';

  @override
  String get cpLocationUnavailable =>
      'Konumunuz şu anda alınamıyor. Tekrar deneyebilir veya konumsuz devam edebilirsiniz.';

  @override
  String get cpLocationUnsupported => 'Bu cihazda konum eklenemiyor.';

  @override
  String get cpReviewEdit => 'Düzenle';

  @override
  String cpReviewEditSemantics(String section) {
    return '$section düzenle';
  }

  @override
  String cpReviewPhotos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fotoğraf',
      one: '1 fotoğraf',
      zero: 'Fotoğraf eklenmedi',
    );
    return '$_temp0';
  }

  @override
  String get cpReviewLocationShared => 'Konum eklendi';

  @override
  String get cpReviewLocationNotShared => 'Konum eklenmedi';

  @override
  String get cpNext => 'İleri';

  @override
  String get cpBack => 'Geri';

  @override
  String get cpSubmit => 'Bildirimi gönder';

  @override
  String cpSubmitted(String code) {
    return 'Bildiriminiz alındı · $code';
  }

  @override
  String get cpFixStep => 'Devam etmeden önce bu adımı tamamlayın.';

  @override
  String get cpMonumentRequired => 'Bir eser seçin.';

  @override
  String get cpCategoryRequired => 'Bir hasar türü seçin.';

  @override
  String get cpUrgencyRequired => 'Aciliyeti seçin.';

  @override
  String get cpDiscardTitle => 'Bildirim taslağı silinsin mi?';

  @override
  String get cpDiscardBody => 'Girdiğiniz bilgiler ve fotoğraflar kaybolacak.';

  @override
  String get cpDiscardConfirm => 'Taslağı sil';

  @override
  String get cpKeepEditing => 'Düzenlemeye devam et';

  @override
  String get cpDetailTitle => 'Bildirim';

  @override
  String get cpReferenceLabel => 'Kayıt numarası';

  @override
  String get cpCopyReference => 'Kayıt numarasını kopyala';

  @override
  String get cpReferenceCopied => 'Kayıt numarası kopyalandı';

  @override
  String get cpStatusHeading => 'Süreç';

  @override
  String get cpDetailsHeading => 'Bildirim bilgileri';

  @override
  String get cpCategoryField => 'Hasar türü';

  @override
  String get cpUrgencyField => 'Aciliyet';

  @override
  String get cpDescriptionField => 'Açıklama';

  @override
  String get cpPhotosField => 'Fotoğraflar';

  @override
  String get cpLocationField => 'Konum';

  @override
  String cpLocationOnSiteValue(String distance) {
    return 'Yerinde doğrulandı (esere $distance)';
  }

  @override
  String cpLocationDistantValue(String distance) {
    return 'Esere $distance uzaktan bildirildi';
  }

  @override
  String get cpLocationNotProvidedValue => 'Konum paylaşılmadı';

  @override
  String cpSubmittedOn(String date) {
    return 'Gönderim: $date';
  }

  @override
  String get cpNoteFromVgm => 'VGM notu';

  @override
  String get cpDetailLoadFailed => 'Bildirim yüklenemedi';

  @override
  String get cpNotFoundTitle => 'Bildirim bulunamadı';

  @override
  String get cpNotFoundBody => 'Bu bildirim size ait değil veya kaldırılmış.';

  @override
  String get cpBackToList => 'Bildirimlerime dön';

  @override
  String get cpPhotoNoDescription => 'Bu fotoğraf için açıklama eklenmemiş.';

  @override
  String get cpPhotoCredit => 'Bildiriminizin fotoğrafı';

  @override
  String get monumentReportTitle => 'Bir sorun mu gördünüz?';

  @override
  String get monumentReportBody =>
      'Bu eserde hasar, vandalizm veya tehlike gördüyseniz Sivil Koruma\'ya bildirin.';

  @override
  String get accountButtonTooltip => 'Hesap ve ayarlar';

  @override
  String get guideWelcomeTitle => 'Size nasıl yardımcı olabilirim?';

  @override
  String get guideWelcomeBody =>
      'Vakıf eserleri hakkında sorun ya da uygulamada ne yapmak istediğinizi yazın; sizi ilgili sayfaya yönlendireyim.';

  @override
  String get guideStartersHeading => 'Örnek sorular';

  @override
  String get guideStarterMonument => 'Süleymaniye Camii\'ni kim yaptırdı?';

  @override
  String get guideStarterList => 'Konya\'daki Selçuklu eserleri';

  @override
  String get guideStarterRoute => 'Rota nasıl planlarım?';

  @override
  String get guideStarterDamage => 'Hasar nasıl bildiririm?';

  @override
  String guideAskSuggestion(String question) {
    return 'Sor: $question';
  }

  @override
  String get guideSuggestionsSemantics => 'Önerilen sorular';

  @override
  String guideQuestionSemantics(String text) {
    return 'Siz: $text';
  }

  @override
  String guideAnswerAnnouncement(String text) {
    return 'Rehber: $text';
  }

  @override
  String guideSources(String names) {
    return 'Kaynak: VGM kataloğu — $names';
  }

  @override
  String get guideTyping => 'Rehber yanıt hazırlıyor…';

  @override
  String get guideSendFailed => 'Soru gönderilemedi.';

  @override
  String get guideNewConversation => 'Yeni sohbet';

  @override
  String get guideResetAnnouncement => 'Yeni sohbet başlatıldı.';

  @override
  String get guideInputLabel => 'Rehbere sorun';

  @override
  String get guideInputHint => 'Bir eser, şehir veya yapmak istediğiniz şey…';

  @override
  String guideInputCounter(int count, int max) {
    return '$count/$max';
  }

  @override
  String get guideSend => 'Gönder';

  @override
  String get guideVoiceStart => 'Sesli sor';

  @override
  String get guideVoiceStop => 'Dinlemeyi durdur';

  @override
  String get guideVoiceListening =>
      'Dinleniyor… Sorunuzu söyleyin, bitince durdurun.';

  @override
  String guideVoiceHeard(String text) {
    return 'Söylediğiniz: $text. Göndermek için Gönder\'e dokunun.';
  }

  @override
  String get guideVoicePermissionDenied =>
      'Sesli soru için mikrofon izni gerekiyor.';

  @override
  String get guideVoicePermissionBlocked =>
      'Mikrofon izni kapalı. Sistem ayarlarından açabilirsiniz.';

  @override
  String get guideVoicePermissionBlockedWeb =>
      'Mikrofon izni kapalı. Tarayıcının site ayarlarından açabilirsiniz.';

  @override
  String get guideVoiceUnavailable =>
      'Bu cihazda veya tarayıcıda sesli soru kullanılamıyor. Sorunuzu yazabilirsiniz.';

  @override
  String get guideVoiceNoMatch =>
      'Konuşmanız anlaşılamadı. Tekrar deneyin veya yazın.';

  @override
  String get guideVoiceFailed =>
      'Sesli soru alınamadı. Tekrar deneyin veya yazın.';

  @override
  String get guidePrivacyNotice =>
      'Yanıtlar VGM kataloğuna dayanır. Kişisel bilgilerinizi paylaşmayın.';

  @override
  String guideActionOpenMonument(String name) {
    return '$name sayfasını aç';
  }

  @override
  String get guideActionShowOnMap => 'Haritada göster';

  @override
  String get guideActionOpenMemories => 'Anıları gör';

  @override
  String get guideActionReportDamage => 'Hasar bildir';

  @override
  String guideActionSearch(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count eseri listele',
      one: '1 eseri listele',
    );
    return '$_temp0';
  }

  @override
  String get guideActionSearchAll => 'Eserlerde ara';

  @override
  String get guideActionOpenMap => 'Haritayı aç';

  @override
  String get guideActionOpenRoutes => 'Rotalarım';

  @override
  String get guideActionNewRoute => 'Rota oluştur';

  @override
  String get guideActionOpenCivilProtection => 'Sivil Koruma';

  @override
  String get guideActionOpenSettings => 'Ayarları aç';

  @override
  String guideActionForMonument(String action, String name) {
    return '$action: $name';
  }

  @override
  String get accessibilityTitle => 'Erişilebilirlik';

  @override
  String get accessibilityIntro =>
      'Bir kutucuğa her dokunuşta bir sonraki seviyeye geçilir; son seviyeden sonra kapanır. Tercihler tüm uygulamaya hemen uygulanır ve bu cihazda saklanır.';

  @override
  String get accessibilityDeviceNote =>
      'Ekran okuyucu, kalın yazı ve cihaz yazı boyutu cihazınızın ayarlarından gelir; uygulama bunlara uyar. Buradaki metin boyutu cihaz boyutuyla çarpılır.';

  @override
  String get accessibilityReset => 'Varsayılanlara dön';

  @override
  String get accessibilityResetDone =>
      'Erişilebilirlik tercihleri varsayılana döndürüldü.';

  @override
  String get settingsAccessibilityDescription =>
      'Metin boyutu, yüksek kontrast, renk görme, hareket ve titreşim';

  @override
  String get onboardingAccessibilityOpen => 'Erişilebilirlik ayarlarını aç';

  @override
  String get guideActionOpenAccessibility => 'Erişilebilirlik ayarlarını aç';

  @override
  String get a11yImageHidden => 'Görsel gizlendi';

  @override
  String get a11yFeatureReadAloud => 'Sesli Okuma';

  @override
  String get a11yFeatureReadOnFocus => 'Odakta Oku';

  @override
  String get a11yFeatureGrayscale => 'Gri Tonlama';

  @override
  String get a11yFeatureContrast => 'Kontrast';

  @override
  String get a11yFeatureZoom => 'Yakınlaştırma';

  @override
  String get a11yFeatureHideImages => 'Görseli Gizle';

  @override
  String get a11yFeatureHighlightLinks => 'Bağlantıları Vurgula';

  @override
  String get a11yFeatureColorBlindness => 'Renk Körlüğü';

  @override
  String get a11yFeatureEasyReading => 'Kolay Okuma';

  @override
  String get a11yFeatureBlueLightFilter => 'Mavi Ekran Filtresi';

  @override
  String get a11yFeatureStopAnimations => 'Animasyonları Durdur';

  @override
  String get a11yFeatureDyslexiaFriendly => 'Disleksi Dostu';

  @override
  String get a11yFeatureReadingGuide => 'Okuma Çizgisi';

  @override
  String get a11yFeatureFocusHighlight => 'Odaklanma';

  @override
  String get a11yFeatureBigCursor => 'Büyük İmleç';

  @override
  String get a11yFeatureLineHeight => 'Satır Yüksekliği';

  @override
  String get a11yFeatureAlignLeft => 'Sola Hizala';

  @override
  String get a11yFeatureHaptics => 'Titreşim';

  @override
  String get a11yLevelOff => 'Kapalı';

  @override
  String get a11yLevelOn => 'Açık';

  @override
  String get a11yContrastAuto => 'Yüksek kontrast';

  @override
  String get a11yContrastDark => 'Koyu yüksek kontrast';

  @override
  String get a11yContrastLight => 'Açık yüksek kontrast';

  @override
  String get a11yContrastInvert => 'Ters renkler';

  @override
  String get a11yBlueLightLow => 'Hafif';

  @override
  String get a11yBlueLightHigh => 'Güçlü';

  @override
  String get a11yDyslexiaFont => 'Okunaklı font';

  @override
  String get a11yDyslexiaSpacing => 'Okunaklı font ve geniş aralık';

  @override
  String get a11yDyslexiaCream => 'Okunaklı font, geniş aralık ve krem zemin';

  @override
  String get a11yGuideThin => 'İnce çizgi';

  @override
  String get a11yGuideThick => 'Kalın çizgi';

  @override
  String get a11yGuideMask => 'Okuma maskesi';

  @override
  String get a11yFocusVisible => 'Belirgin';

  @override
  String get a11yFocusThick => 'Kalın';

  @override
  String get a11yFocusExtra => 'Çok kalın';

  @override
  String get a11yCursorLarge => 'Büyük';

  @override
  String get a11yCursorExtra => 'Çok büyük';

  @override
  String a11yLineHeightValue(String value) {
    return '$value kat';
  }

  @override
  String a11yTileState(String feature, String state) {
    return '$feature: $state';
  }

  @override
  String a11yTileLevel(int level, int levels) {
    return 'Seviye $level / $levels';
  }

  @override
  String get a11yTileHint => 'sonraki seviye';

  @override
  String get mapAccessibilityButton => 'Erişilebilirlik';

  @override
  String get settingsShowAccessibilityButton =>
      'Haritada Erişilebilirlik butonunu göster';

  @override
  String get settingsShowAccessibilityButtonDescription =>
      'Kapalıyken erişilebilirlik paneline buradan ve ilk açılış tanıtımından ulaşabilirsiniz; tercihleriniz uygulanmaya devam eder.';

  @override
  String complexMemberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yapı',
      one: '1 yapı',
      zero: 'Yapı listelenmedi',
    );
    return '$_temp0';
  }

  @override
  String get complexMembersTitle => 'Külliyedeki yapılar';

  @override
  String complexMembersSeeAll(int count) {
    return 'Tüm yapıları gör ($count)';
  }

  @override
  String complexMembersPageTitle(String name) {
    return '$name yapıları';
  }

  @override
  String get complexMembersEmpty =>
      'Bu külliyenin yapıları henüz kataloğa eklenmedi.';

  @override
  String get complexMembersFilterEmpty => 'Bu türde yapı yok.';

  @override
  String get complexMembersLoadFailed => 'Külliyenin yapıları yüklenemedi.';

  @override
  String complexMembersEndOfList(int count) {
    return 'Tüm yapılar gösterildi ($count)';
  }

  @override
  String complexMemberSemantics(int index, String name, String category) {
    return '$index. $name, $category';
  }

  @override
  String complexPartOf(String name) {
    return '$name yapılarından biri';
  }

  @override
  String get complexPartOfHint =>
      'Külliyeyi ve diğer yapılarını görmek için dokunun';

  @override
  String get complexSiblingsTitle => 'Külliyedeki diğer yapılar';

  @override
  String get complexLayoutTitle => 'Yerleşim planı';

  @override
  String complexLayoutMapSemantics(String name, String members) {
    return '$name yerleşim planı, $members. Yapılar yukarıdaki listede aynı sırayla yer alır.';
  }

  @override
  String get complexOpen => 'Külliyeyi gör';

  @override
  String complexOpenSemantics(String name) {
    return 'Külliyeyi gör, $name';
  }

  @override
  String get complexFactMembers => 'Yapılar';

  @override
  String complexListItemSubtitle(String location, String members) {
    return '$location · Külliye · $members';
  }

  @override
  String monumentListItemMemberSubtitle(
    String location,
    String category,
    String complex,
  ) {
    return '$location · $category · $complex';
  }

  @override
  String mapComplexSemantics(
    String name,
    String members,
    String district,
    String city,
  ) {
    return '$name, külliye, $members, $district, $city';
  }

  @override
  String mapComplexMemberSemantics(String name, String complex) {
    return '$name, $complex içinde';
  }

  @override
  String mapComplexAreaSemantics(String name) {
    return '$name yerleşim alanı. Külliyeyi seçmek için dokunun.';
  }

  @override
  String get memoryStatusApproved => 'Yayında';

  @override
  String get memoryStatusPending => 'İncelemede';

  @override
  String get memoryStatusRejected => 'Yayınlanmadı';

  @override
  String get memorySharedPending =>
      'Anınız incelemeye alındı. Onaylanınca Anı Köşesi\'nde yayınlanacak; durumunu Anılarım\'da görebilirsiniz.';

  @override
  String get memorySharedRejected =>
      'Anınız topluluk kurallarına uygun bulunmadığı için yayınlanmadı. Anılarım\'da görebilirsiniz.';

  @override
  String get memoryOpenMyMemories => 'Anılarım';

  @override
  String myMemoriesPreviewStatusSemantics(String status, String summary) {
    return '$status. $summary';
  }

  @override
  String get monumentLocationPending =>
      'Bu eserin konumu henüz girilmedi; haritada ve rota planlayıcıda yer almıyor.';

  @override
  String monumentNickname(String name) {
    return 'Halk arasında: $name';
  }

  @override
  String monumentPartFallback(int index) {
    return 'Bölüm $index';
  }

  @override
  String routePickerNoLocation(String details) {
    return '$details · Konum yok, rotaya eklenemez';
  }

  @override
  String get settingsNotificationsSection => 'Bildirimler';

  @override
  String get nearbyAlertsSettingTitle => 'Yakındaki eser bildirimleri';

  @override
  String get nearbyAlertsSettingDescription =>
      'Bir vakıf eserinin yanından geçerken fotoğrafı ve kısa bilgisiyle haber verilir. Konumunuz saklanmaz; çevrenizdeki eserleri bulmak için yalnızca yaklaşık bölgeniz kullanılır.';

  @override
  String get nearbyAlertsBackgroundNote =>
      'Uygulama arka plandayken de çalışır. Açıkken Android\'de kalıcı bir bildirim, iOS\'ta konum göstergesi görünür.';

  @override
  String get nearbyAlertsNotificationsBlocked =>
      'Vakıf Atlas için bildirimler kapalı. Uyarı alabilmek için sistem ayarlarından açın.';

  @override
  String get nearbyAlertsLocationBlocked =>
      'Konum erişimi kapalı. Uyarı alabilmek için uygulama kullanılırken konuma izin verin.';

  @override
  String get nearbyAlertsOpenSettings => 'Ayarları aç';

  @override
  String get nearbyAlertsEnabled => 'Yakındaki eser bildirimleri açıldı.';

  @override
  String get nearbyAlertsDisabled => 'Yakındaki eser bildirimleri kapatıldı.';

  @override
  String get nearbyAlertsChannelName => 'Yakındaki eserler';

  @override
  String get nearbyAlertsChannelDescription =>
      'Bir vakıf eserinin yakınından geçtiğinizde';

  @override
  String nearbyAlertTitle(String name) {
    return '$name yakınındasınız';
  }

  @override
  String nearbyAlertSubtitle(String distance, String category) {
    return '$distance uzakta · $category';
  }

  @override
  String get nearbyAlertCallToAction => 'Ayrıntılar için dokunun.';

  @override
  String get nearbyAlertsTrackingTitle => 'Yakındaki eser bildirimleri açık';

  @override
  String get nearbyAlertsTrackingText =>
      'Bir vakıf eserine yaklaştığınızda size haber vereceğiz.';

  @override
  String get nearbyAlertsTrackingChannel => 'Yakındaki eserler için konum';

  @override
  String nearbyAlertSubtitleApproximate(String category) {
    return 'Yakınınızda · $category';
  }
}
