// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Vakıf Atlas';

  @override
  String get appSlogan => 'From Roots to the Future';

  @override
  String get errorInvalidRequest =>
      'The request is invalid. Please check the information you entered.';

  @override
  String get errorUnauthorized =>
      'Your session has expired or you are not authorized for this action.';

  @override
  String get errorNotFound => 'The requested resource could not be found.';

  @override
  String get errorModerationRejected =>
      'Your post did not meet the community guidelines.';

  @override
  String get errorServerUnavailable =>
      'The server is temporarily unavailable. Please try again shortly.';

  @override
  String get errorOffline =>
      'You are offline. Check your connection and try again.';

  @override
  String get errorServerUnreachable =>
      'The Vakıf Atlas server can\'t be reached right now. Your internet connection is working; please try again shortly.';

  @override
  String get offlineBannerMessage =>
      'You\'re offline. Showing data on this device; changes will sync when you\'re back online.';

  @override
  String get offlineAnnouncement =>
      'Internet connection lost. The app is working in offline mode.';

  @override
  String get onlineAnnouncement => 'Internet connection restored.';

  @override
  String get errorCacheRead =>
      'Local data could not be read; using online sources instead.';

  @override
  String get errorSecurityViolation =>
      'The secure connection or device integrity could not be verified.';

  @override
  String get errorInvalidCredentials =>
      'The email address or password is incorrect. Check your details and try again.';

  @override
  String get errorUnexpected =>
      'An unexpected error occurred. Please try again.';

  @override
  String get commonRetry => 'Try again';

  @override
  String get commonUndo => 'Undo';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonClose => 'Close';

  @override
  String get commonLoading => 'Loading';

  @override
  String buttonLoadingSemantics(String label) {
    return '$label, in progress';
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
      other: '$count new notifications',
      one: '1 new notification',
      zero: 'No new notifications',
    );
    return '$_temp0';
  }

  @override
  String get navMap => 'Map';

  @override
  String get navRoutePlanner => 'Routes';

  @override
  String get navAiAssistant => 'Guide';

  @override
  String get navProfile => 'Profile';

  @override
  String get navSettings => 'Settings';

  @override
  String get navigationSemantics => 'Main navigation';

  @override
  String get mapDiscoveryTitle => 'Discover';

  @override
  String get monumentDetailTitle => 'Monument Details';

  @override
  String get routePlannerTitle => 'Route Planner';

  @override
  String get memoryCornerTitle => 'Memory Corner';

  @override
  String get civilProtectionTitle => 'Civil Protection';

  @override
  String get aiAssistantTitle => 'Digital Guide';

  @override
  String get profileTitle => 'My Profile';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get loginTitle => 'Sign In';

  @override
  String get featurePendingHeading => 'This section is being prepared';

  @override
  String featurePendingBody(String feature) {
    return '$feature will be available in the next release.';
  }

  @override
  String get notFoundTitle => 'Page not found';

  @override
  String get notFoundBody =>
      'The page you are looking for does not exist or may have moved.';

  @override
  String get notFoundAction => 'Back to home';

  @override
  String get splashLoadingSemantics => 'Vakıf Atlas is starting';

  @override
  String get loginHeading => 'Welcome';

  @override
  String get loginSubtitle =>
      'Sign in to share memories, submit Civil Protection reports and earn badges.';

  @override
  String get loginRequiredNotice => 'You need to sign in to use this section.';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginEmailHint => 'name@email.com';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get passwordShow => 'Show password';

  @override
  String get passwordHide => 'Hide password';

  @override
  String get loginSubmit => 'Sign in';

  @override
  String get loginContinueAsGuest => 'Continue as guest';

  @override
  String loginSuccessAnnouncement(String name) {
    return 'Signed in. Welcome, $name.';
  }

  @override
  String get loginFormInvalidAnnouncement =>
      'Some fields in the form need to be corrected.';

  @override
  String get validationEmailEmpty => 'Enter your email address.';

  @override
  String get validationEmailInvalid =>
      'Enter a valid email address. Example: name@email.com';

  @override
  String get validationPasswordEmpty => 'Enter your password.';

  @override
  String validationPasswordTooShort(int min) {
    return 'The password must be at least $min characters long.';
  }

  @override
  String profileEmailValue(String email) {
    return 'Email: $email';
  }

  @override
  String get gamificationSectionTitle => 'Level and badges';

  @override
  String gamificationLevelTitle(int level, String title) {
    return 'Level $level · $title';
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
    return '$xp XP to the next level.';
  }

  @override
  String get gamificationMaxLevel => 'You\'ve reached the highest level.';

  @override
  String get gamificationProgressSemantics => 'Level progress';

  @override
  String get gamificationRecentBadges => 'Recently earned badges';

  @override
  String get gamificationNoBadges =>
      'No badges yet. Start earning by creating routes, sharing memories or reporting damage.';

  @override
  String gamificationAllBadges(int unlocked, int total) {
    return 'All badges ($unlocked/$total)';
  }

  @override
  String get gamificationLoading => 'Loading your level';

  @override
  String get gamificationLoadFailed => 'Couldn\'t load your level.';

  @override
  String get gamificationAchievementsTitle => 'Badges';

  @override
  String gamificationAchievementsSummary(int unlocked, int total) {
    return 'You\'ve earned $unlocked of $total badges.';
  }

  @override
  String get gamificationEarnedSection => 'Earned';

  @override
  String get gamificationLockedSection => 'To earn';

  @override
  String gamificationUnlockedOn(String date) {
    return 'Earned $date';
  }

  @override
  String gamificationLockedProgress(int progress, int target) {
    return 'Locked · $progress/$target';
  }

  @override
  String get gamificationHowToTitle => 'How to earn XP';

  @override
  String get gamificationHowToRoute =>
      'Creating a route: 50 XP (up to 3 routes a day)';

  @override
  String get gamificationHowToMemory =>
      'Sharing a memory: 30 XP (up to 5 memories a day)';

  @override
  String get gamificationHowToReport =>
      'Reporting damage: 40 XP (up to 3 reports a day)';

  @override
  String get gamificationHowToCity =>
      'Your first contribution in a province: 20 XP';

  @override
  String get gamificationHowToNote =>
      'XP is awarded for contributions made with your account; routes created as a guest don\'t count.';

  @override
  String get gamificationCelebrationTitle => 'Congratulations!';

  @override
  String gamificationLevelReached(int level, String title) {
    return 'New level: $level · $title';
  }

  @override
  String gamificationBadgeEarned(String title) {
    return 'New badge: $title';
  }

  @override
  String get gamificationCelebrationViewBadges => 'View badges';

  @override
  String get gamificationCelebrationClose => 'Great';

  @override
  String get profileLogout => 'Sign out';

  @override
  String get profileLogoutConfirmTitle => 'Sign out?';

  @override
  String get profileLogoutConfirmBody =>
      'You will need to sign in again to share memories and submit reports.';

  @override
  String get logoutAnnouncement => 'Signed out.';

  @override
  String get sessionExpiredMessage =>
      'Your session has expired. Please sign in again.';

  @override
  String get settingsAppearanceSection => 'Appearance';

  @override
  String get settingsThemeLabel => 'Theme';

  @override
  String get themeSystem => 'Device setting';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get settingsLanguageSection => 'Language';

  @override
  String get settingsLanguageLabel => 'App language';

  @override
  String get languageSystem => 'Device language';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get languageEnglish => 'English';

  @override
  String get settingsAccessibilitySection => 'Accessibility';

  @override
  String get colorBlindnessProtanopia => 'Protanopia (red)';

  @override
  String get colorBlindnessDeuteranopia => 'Deuteranopia (green)';

  @override
  String get colorBlindnessTritanopia => 'Tritanopia (blue)';

  @override
  String settingsTextScaleValue(int percent) {
    return '$percent%';
  }

  @override
  String get settingsSaveFailed =>
      'The setting could not be saved on this device. The previous value will be used when the app restarts.';

  @override
  String get settingsLicenses => 'Open source licenses';

  @override
  String get settingsFeedback => 'Send feedback';

  @override
  String get settingsFeedbackSubtitle =>
      'Rate your experience, share an idea or report a problem';

  @override
  String aboutVersion(String version) {
    return 'Version $version';
  }

  @override
  String get aboutMission =>
      'An accessible way to discover, visit and help protect the foundation heritage cared for by the General Directorate of Foundations.';

  @override
  String get aboutDeveloper =>
      'Developed by Root42 for the General Directorate of Foundations.';

  @override
  String get feedbackTitle => 'Feedback';

  @override
  String get feedbackRatingLabel =>
      'How would you rate your Vakıf Atlas experience?';

  @override
  String get feedbackRatingOptional => 'Rating is optional.';

  @override
  String feedbackRateStars(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stars',
      one: '1 star',
    );
    return '$_temp0';
  }

  @override
  String feedbackRatingValue(int value, String name) {
    return '$value / 5 · $name';
  }

  @override
  String get feedbackRating1 => 'Very poor';

  @override
  String get feedbackRating2 => 'Poor';

  @override
  String get feedbackRating3 => 'Okay';

  @override
  String get feedbackRating4 => 'Good';

  @override
  String get feedbackRating5 => 'Excellent';

  @override
  String get feedbackCategoryLabel => 'Topic';

  @override
  String get feedbackCategorySuggestion => 'Idea';

  @override
  String get feedbackCategoryBug => 'Bug';

  @override
  String get feedbackCategoryAccessibility => 'Accessibility';

  @override
  String get feedbackCategoryContent => 'Monument info';

  @override
  String get feedbackCategoryOther => 'Other';

  @override
  String get feedbackMessageLabel => 'Your message';

  @override
  String get feedbackMessageHint =>
      'What did you like, and what could we improve?';

  @override
  String get feedbackMessageHelper =>
      'Don\'t share personal information. The app version and device type (e.g. Android) are included.';

  @override
  String get feedbackSubmit => 'Send';

  @override
  String get feedbackRequired => 'Give a rating or write a message.';

  @override
  String feedbackTooLong(int max) {
    return 'The message can be at most $max characters.';
  }

  @override
  String get feedbackSent => 'Thank you! Your feedback was received.';

  @override
  String get privacyOverlaySemantics => 'App content hidden';

  @override
  String get integrityWarningMessage =>
      'Security modifications (root or jailbreak) were detected on your device. Some actions may be restricted to protect your account.';

  @override
  String get integrityWarningDismiss => 'Got it';

  @override
  String get integrityBlockedTitle =>
      'Secure environment could not be verified';

  @override
  String get integrityBlockedBody =>
      'A modified version of the app or unauthorized tampering was detected. Please reinstall Vakıf Atlas from the official app store.';

  @override
  String get startupFailedTitle => 'The app could not start';

  @override
  String get startupFailedBody =>
      'Something unexpected went wrong while opening Vakıf Atlas. Close and reopen the app; if the problem persists, update the app.';

  @override
  String get errorEmailNotVerified =>
      'Your email address has not been verified yet. Enter the code we sent you.';

  @override
  String get errorInvalidVerificationCode =>
      'The code is incorrect. Check the 6-digit code in your email and try again.';

  @override
  String get errorVerificationCodeExpired =>
      'The code has expired or too many wrong attempts were made. Request a new code.';

  @override
  String get errorWeakPassword =>
      'This password does not meet the security rules. Choose a longer password that is hard to guess.';

  @override
  String get errorInvalidCurrentPassword =>
      'Your current password is incorrect.';

  @override
  String get errorTooManyRequests =>
      'Too many attempts. Please try again later.';

  @override
  String errorTooManyRequestsRetry(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Too many attempts. Try again in $minutes minutes.',
      one: 'Too many attempts. Try again in 1 minute.',
    );
    return '$_temp0';
  }

  @override
  String get validationNameEmpty => 'Enter your full name.';

  @override
  String validationNameTooShort(int min) {
    return 'Your name must be at least $min characters long.';
  }

  @override
  String validationNameTooLong(int max) {
    return 'Your name can be at most $max characters long.';
  }

  @override
  String get validationNameInvalid =>
      'Your name can only contain letters, spaces, apostrophes and hyphens.';

  @override
  String validationPasswordTooLong(int max) {
    return 'The password can be at most $max characters long.';
  }

  @override
  String get validationPasswordCommon =>
      'This password is very common and easy to guess. Choose a different one.';

  @override
  String get validationPasswordPersonalInfo =>
      'The password must not contain your name, email address or the app name.';

  @override
  String get validationPasswordRepetitive =>
      'The password must not consist of repeated or sequential characters.';

  @override
  String get validationConfirmPasswordEmpty => 'Enter your password again.';

  @override
  String get validationPasswordMismatch =>
      'The passwords do not match. Enter the same password in both fields.';

  @override
  String get validationSamePassword =>
      'The new password must be different from your current password.';

  @override
  String get validationCurrentPasswordEmpty => 'Enter your current password.';

  @override
  String get validationCodeEmpty => 'Enter the code from your email.';

  @override
  String validationCodeInvalid(int length) {
    return 'The code must be a $length-digit number.';
  }

  @override
  String get validationTermsRequired =>
      'You must accept the Terms of Use to continue.';

  @override
  String get validationPrivacyRequired =>
      'You must confirm that you have read the Privacy Notice to continue.';

  @override
  String get validationDeleteConfirmRequired =>
      'Tick the confirmation box to continue.';

  @override
  String passwordRequirementsHint(int min) {
    return 'At least $min characters. Avoid easy-to-guess phrases and personal information.';
  }

  @override
  String get passwordStrengthWeak => 'Weak';

  @override
  String get passwordStrengthFair => 'Fair';

  @override
  String get passwordStrengthGood => 'Good';

  @override
  String get passwordStrengthStrong => 'Strong';

  @override
  String passwordStrengthSemantics(String level) {
    return 'Password strength: $level';
  }

  @override
  String get loginForgotPassword => 'Forgot password';

  @override
  String get loginNoAccount => 'Don\'t have an account?';

  @override
  String get loginCreateAccount => 'Create account';

  @override
  String get loginPasswordResetSuccess =>
      'Your password was updated and all sessions were signed out. Sign in with your new password.';

  @override
  String get registerTitle => 'Create Account';

  @override
  String get registerHeading => 'Join Vakıf Atlas';

  @override
  String get registerSubtitle =>
      'Create a free account to share your memories and help protect cultural heritage.';

  @override
  String get registerNameLabel => 'Full name';

  @override
  String get registerConfirmPasswordLabel => 'Confirm password';

  @override
  String get registerAcceptTerms => 'I have read and accept the Terms of Use.';

  @override
  String get registerAcknowledgePrivacy =>
      'I have read the Privacy Notice (KVKK).';

  @override
  String get registerReadTerms => 'Read the Terms of Use';

  @override
  String get registerReadPrivacy => 'Read the Privacy Notice';

  @override
  String get registerSubmit => 'Create account';

  @override
  String get registerHaveAccount => 'Already have an account? Sign in';

  @override
  String get verifyEmailTitle => 'Email Verification';

  @override
  String get verifyEmailHeading => 'Verify your email';

  @override
  String verifyEmailBody(String email) {
    return 'We sent a 6-digit verification code to $email. The code is valid for 10 minutes.';
  }

  @override
  String get verificationCodeLabel => 'Verification code';

  @override
  String get verificationCodeHint => '6-digit code';

  @override
  String get verifyEmailSubmit => 'Verify';

  @override
  String get verifyEmailChangeEmail => 'Change email address';

  @override
  String get resendCode => 'Resend code';

  @override
  String resendCodeIn(int seconds) {
    return 'Resend code (${seconds}s)';
  }

  @override
  String get codeResentAnnouncement => 'A new code has been sent.';

  @override
  String emailVerifiedAnnouncement(String name) {
    return 'Your account is verified. Welcome, $name.';
  }

  @override
  String get forgotPasswordTitle => 'Forgot Password';

  @override
  String get forgotPasswordHeading => 'Reset your password';

  @override
  String get forgotPasswordBody =>
      'Enter the email address registered to your account. We will send you a reset code.';

  @override
  String get forgotPasswordSubmit => 'Send code';

  @override
  String get backToLogin => 'Back to sign in';

  @override
  String get resetPasswordTitle => 'New Password';

  @override
  String resetPasswordBody(String email) {
    return 'If an account is registered with $email, we sent a 6-digit reset code to that address.';
  }

  @override
  String get newPasswordLabel => 'New password';

  @override
  String get confirmNewPasswordLabel => 'Confirm new password';

  @override
  String get resetPasswordSubmit => 'Update password';

  @override
  String get changePasswordTitle => 'Change Password';

  @override
  String get currentPasswordLabel => 'Current password';

  @override
  String get changePasswordSubmit => 'Change password';

  @override
  String get changePasswordSuccess => 'Your password has been changed.';

  @override
  String get deleteAccountTitle => 'Delete Account';

  @override
  String get deleteAccountHeading => 'Permanently delete your account';

  @override
  String get deleteAccountBody =>
      'Your account and the personal data linked to it (profile, memories, badges) will be deleted in accordance with KVKK. This cannot be undone.';

  @override
  String get deleteAccountConfirm => 'I understand that this cannot be undone.';

  @override
  String get deleteAccountSubmit => 'Delete my account';

  @override
  String get accountDeletedAnnouncement => 'Your account has been deleted.';

  @override
  String get profileSecuritySection => 'Security and account';

  @override
  String get legalTermsTitle => 'Terms of Use';

  @override
  String get legalPrivacyTitle => 'Privacy Notice (KVKK)';

  @override
  String legalVersion(String version, DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Version $version · Effective: $dateString';
  }

  @override
  String mapSemanticsLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Foundation monuments map, $count monuments',
      one: 'Foundation monuments map, 1 monument',
      zero: 'Foundation monuments map, no monuments',
    );
    return '$_temp0';
  }

  @override
  String mapLoadedAnnouncement(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count monuments shown on the map',
      one: '1 monument shown on the map',
      zero: 'No monuments to show on the map',
    );
    return '$_temp0';
  }

  @override
  String get mapLoadingMonuments => 'Loading monuments';

  @override
  String get mapLoadErrorTitle => 'Monuments could not be loaded';

  @override
  String get mapZoomIn => 'Zoom in';

  @override
  String get mapZoomOut => 'Zoom out';

  @override
  String get mapShowAll => 'Show all monuments';

  @override
  String get mapControlsSemantics => 'Map controls';

  @override
  String mapAttributionSemantics(String attribution) {
    return 'Map data: $attribution';
  }

  @override
  String monumentPinSemantics(String name, String district, String city) {
    return '$name, $district, $city';
  }

  @override
  String monumentSelectedAnnouncement(String name) {
    return '$name selected';
  }

  @override
  String monumentCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count monuments',
      one: '1 monument',
      zero: 'No monuments',
    );
    return '$_temp0';
  }

  @override
  String get monumentPreviewClose => 'Close preview';

  @override
  String get monumentSave => 'Save';

  @override
  String get monumentUnsave => 'Remove from saved';

  @override
  String monumentSaveSemantics(String name) {
    return 'Save: $name';
  }

  @override
  String monumentUnsaveSemantics(String name) {
    return 'Remove from saved: $name';
  }

  @override
  String savedMonumentAdded(String name) {
    return 'Saved: $name';
  }

  @override
  String savedMonumentRemoved(String name) {
    return 'Removed from saved: $name';
  }

  @override
  String savedMonumentsLimit(int max) {
    return 'You can save up to $max monuments. Remove one from Saved to make room.';
  }

  @override
  String get savedMonumentsSaveFailed => 'Couldn\'t save. Please try again.';

  @override
  String get savedMonumentsTitle => 'Saved';

  @override
  String savedMonumentsButton(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Saved, $count monuments',
      one: 'Saved, 1 monument',
      zero: 'Saved, no monuments',
    );
    return '$_temp0';
  }

  @override
  String savedMonumentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count monuments',
      one: '1 monument',
    );
    return '$_temp0';
  }

  @override
  String get savedMonumentsEmptyTitle => 'No saved monuments yet';

  @override
  String get savedMonumentsEmptyBody =>
      'Save monuments you like with the bookmark icon on a monument page or in the map preview.';

  @override
  String get emptyStateExploreMap => 'Explore the map';

  @override
  String get savedMonumentsLoadFailedTitle => 'Couldn\'t load saved monuments';

  @override
  String savedMonumentSavedOn(String date) {
    return 'Saved $date';
  }

  @override
  String get savedMonumentRemove => 'Remove';

  @override
  String get savedMonumentUnavailable => 'Monument no longer in the catalogue';

  @override
  String get savedMonumentUnavailableBody =>
      'This monument was removed from the catalogue; you can remove it from your list.';

  @override
  String get monumentViewDetails => 'View details';

  @override
  String monumentViewDetailsSemantics(String name) {
    return 'View details, $name';
  }

  @override
  String monumentLocation(String district, String city) {
    return '$district, $city';
  }

  @override
  String monumentLocationSemantics(String location) {
    return 'Location: $location';
  }

  @override
  String monumentAddressSemantics(String address) {
    return 'Address: $address';
  }

  @override
  String get monumentCategoryMosque => 'Mosque';

  @override
  String get monumentCategoryComplex => 'Complex';

  @override
  String get monumentCategoryMadrasa => 'Madrasa';

  @override
  String get monumentCategoryInn => 'Inn';

  @override
  String get monumentCategoryCaravanserai => 'Caravanserai';

  @override
  String get monumentCategoryBath => 'Bathhouse';

  @override
  String get monumentCategoryFountain => 'Fountain';

  @override
  String get monumentCategoryTomb => 'Tomb';

  @override
  String get monumentCategoryHospital => 'Hospital';

  @override
  String get monumentCategoryImaret => 'Public kitchen';

  @override
  String get monumentCategoryOther => 'Other building';

  @override
  String get historicalPeriodSeljuk => 'Seljuk';

  @override
  String get historicalPeriodBeylik => 'Anatolian Beyliks';

  @override
  String get historicalPeriodOttoman => 'Ottoman';

  @override
  String get historicalPeriodOther => 'Other period';

  @override
  String monumentCategorySemantics(String category) {
    return 'Type: $category';
  }

  @override
  String monumentPeriodSemantics(String period) {
    return 'Period: $period';
  }

  @override
  String monumentConstructionSemantics(String date) {
    return 'Built: $date';
  }

  @override
  String get monumentUnescoBadge => 'UNESCO World Heritage';

  @override
  String get monumentDetailLoading => 'Loading monument details';

  @override
  String get monumentDetailErrorTitle => 'Monument details could not be loaded';

  @override
  String get monumentNotFoundTitle => 'Monument not found';

  @override
  String get monumentNotFoundBody =>
      'The monument you are looking for is not in the catalogue or may have been removed.';

  @override
  String get monumentBackToMap => 'Back to map';

  @override
  String get monumentShowOnMap => 'Show on map';

  @override
  String get monumentListen => 'Listen';

  @override
  String get monumentStopListening => 'Stop reading aloud';

  @override
  String get monumentAboutHeading => 'About';

  @override
  String get monumentHistoryHeading => 'History';

  @override
  String get monumentFactsHeading => 'Monument facts';

  @override
  String get monumentFounderLabel => 'Founder';

  @override
  String get monumentArchitectLabel => 'Architect';

  @override
  String get monumentConstructionLabel => 'Construction';

  @override
  String get monumentPeriodLabel => 'Period';

  @override
  String get monumentCategoryLabel => 'Type';

  @override
  String get monumentLocationHeading => 'Location';

  @override
  String get monumentPhotoCreditsHeading => 'Photo credits';

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
    return 'Photo $index: $author, licence $license, source $source';
  }

  @override
  String gallerySemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Photo gallery, $count photos',
      one: 'Photo gallery, 1 photo',
      zero: 'Photo gallery, no photos',
    );
    return '$_temp0';
  }

  @override
  String galleryPhotoSemantics(int index, int count, String description) {
    return 'Photo $index of $count: $description';
  }

  @override
  String galleryPosition(int index, int count) {
    return '$index / $count';
  }

  @override
  String galleryPositionSemantics(int index, int count) {
    return 'Photo $index of $count';
  }

  @override
  String galleryThumbnailSemantics(int index, String description) {
    return 'Photo $index: $description';
  }

  @override
  String get galleryPrevious => 'Previous photo';

  @override
  String get galleryNext => 'Next photo';

  @override
  String get galleryOpenFullScreen => 'view full screen';

  @override
  String get galleryCloseViewer => 'Close gallery';

  @override
  String get galleryImageError => 'Photo could not be loaded';

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
      'Licence terms are available on the source page of each photo.';

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
    return '$count d';
  }

  @override
  String durationHoursShort(int count) {
    return '$count h';
  }

  @override
  String durationMinutesShort(int count) {
    return '$count min';
  }

  @override
  String durationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String durationHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours',
      one: '1 hour',
    );
    return '$_temp0';
  }

  @override
  String durationMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes',
      one: '1 minute',
    );
    return '$_temp0';
  }

  @override
  String get routeListTitle => 'My routes';

  @override
  String get routeNewButton => 'New route';

  @override
  String get routeListLoading => 'Loading routes';

  @override
  String get routeListErrorTitle => 'Routes could not be loaded';

  @override
  String get routeListEmptyTitle => 'No routes yet';

  @override
  String get routeListEmptyBody =>
      'Pick and order monuments, then add visit times and breaks to create your first culture route.';

  @override
  String routeDraftBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Your draft route has $count monuments',
      one: 'Your draft route has 1 monument',
    );
    return '$_temp0';
  }

  @override
  String get routeDraftContinue => 'Continue';

  @override
  String routeStopCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stops',
      one: '1 stop',
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
    return '$name. $stops: $cities. Total $distance, $duration. $created.';
  }

  @override
  String routeCreatedOn(String date) {
    return 'Created $date';
  }

  @override
  String routeTotalDistanceSemantics(String value) {
    return 'Total distance: $value';
  }

  @override
  String routeTotalDurationSemantics(String value) {
    return 'Total time: $value';
  }

  @override
  String get routeDetailLoading => 'Loading route';

  @override
  String get routeDetailTitle => 'Route details';

  @override
  String get routeDeleting => 'Deleting route';

  @override
  String get routeDetailErrorTitle => 'Route could not be loaded';

  @override
  String get routeNotFoundTitle => 'Route not found';

  @override
  String get routeNotFoundBody =>
      'The route may have been deleted or isn\'t linked to this device.';

  @override
  String get routeBackToList => 'Back to my routes';

  @override
  String get routeEdit => 'Edit';

  @override
  String get routeDelete => 'Delete';

  @override
  String get routeDeleteConfirmTitle => 'Delete route?';

  @override
  String routeDeleteConfirmBody(String name) {
    return '\"$name\" will be permanently deleted. This cannot be undone.';
  }

  @override
  String get routeDeletedMessage => 'Route deleted';

  @override
  String get routeSummaryHeading => 'Time and distance';

  @override
  String get routeTotalDuration => 'Total time';

  @override
  String get routeTravelTime => 'Travel';

  @override
  String get routeVisitTime => 'Visits';

  @override
  String get routeBreakTime => 'Breaks';

  @override
  String get routeDistance => 'Road distance';

  @override
  String routeMetricSemantics(String label, String value) {
    return '$label: $value';
  }

  @override
  String get routeEstimateNote =>
      'Travel time is estimated by car from the road distance; traffic and weather may change it.';

  @override
  String get routeStepsHeading => 'Step by step';

  @override
  String routeStopSemantics(
    int index,
    int count,
    String name,
    String location,
    String visit,
  ) {
    return 'Stop $index of $count: $name, $location. Visit time $visit.';
  }

  @override
  String routeVisitLabel(String duration) {
    return 'Visit · $duration';
  }

  @override
  String routeLegLabel(String distance, String duration) {
    return '$distance · ≈ $duration by car';
  }

  @override
  String routeLegSemantics(String next, String distance, String duration) {
    return 'Next stop $next: $distance, about $duration by car.';
  }

  @override
  String routeBreakSemantics(String kind, String duration) {
    return 'Break: $kind, $duration';
  }

  @override
  String routeBreakLabel(String kind, String duration) {
    return '$kind · $duration';
  }

  @override
  String get routeBreakShort => 'Short break';

  @override
  String get routeBreakMeal => 'Meal break';

  @override
  String get routeBreakRest => 'Rest';

  @override
  String get routeBreakOvernight => 'Overnight stay';

  @override
  String get routeBuilderNewTitle => 'New route';

  @override
  String get routeBuilderEditTitle => 'Edit route';

  @override
  String get routeBuilderLoading => 'Loading monuments';

  @override
  String get routeNameLabel => 'Route name';

  @override
  String get routeNameHelper => 'Leave empty to use the suggested name.';

  @override
  String routeDefaultName(String from, String to) {
    return '$from – $to Route';
  }

  @override
  String routeDefaultNameSingleCity(String city) {
    return '$city Route';
  }

  @override
  String get routeDefaultNameEmpty => 'Culture Route';

  @override
  String routeStopsHeading(int count, int max) {
    return 'Stops ($count/$max)';
  }

  @override
  String get routeAddMonuments => 'Add monuments';

  @override
  String get routePickerDone => 'Done';

  @override
  String get routeOptimize => 'Optimise order';

  @override
  String get routeOptimizeHint =>
      'The first stop stays as the start; the others are ordered by the shortest driving time.';

  @override
  String routeOptimizedAnnouncement(String before, String after) {
    return 'Order optimised: $after instead of $before as the crow flies.';
  }

  @override
  String get routeOptimizedUnchanged => 'The order is already the shortest.';

  @override
  String get routeEmptyStops => 'Choose at least 2 monuments for the route.';

  @override
  String routeMoveUp(String name) {
    return 'Move $name up';
  }

  @override
  String routeMoveDown(String name) {
    return 'Move $name down';
  }

  @override
  String routeRemoveStop(String name) {
    return 'Remove $name from the route';
  }

  @override
  String routeStopMovedAnnouncement(String name, int position) {
    return '$name moved to position $position';
  }

  @override
  String routeStopAddedAnnouncement(String name) {
    return '$name added to the route';
  }

  @override
  String routeStopRemovedAnnouncement(String name) {
    return '$name removed from the route';
  }

  @override
  String get routeVisitDuration => 'Visit time';

  @override
  String routeDurationDecrease(String label) {
    return 'Decrease $label';
  }

  @override
  String routeDurationIncrease(String label) {
    return 'Increase $label';
  }

  @override
  String get routeAddBreak => 'Add break';

  @override
  String get routeBreakPickerTitle => 'Break type';

  @override
  String routeBreakPickerDefault(String duration) {
    return 'Suggested time: $duration';
  }

  @override
  String routeRemoveBreak(String kind) {
    return 'Remove $kind';
  }

  @override
  String routeBreakLimit(int max) {
    return 'Up to $max breaks can be added per stop.';
  }

  @override
  String routeStraightLineToNext(String distance) {
    return '≈ $distance to the next stop as the crow flies';
  }

  @override
  String routeBuilderSummary(String stops, String distance) {
    return '$stops · ≈ $distance as the crow flies';
  }

  @override
  String routeOptimizedRoadAnnouncement(String before, String after) {
    return 'Order optimised: $after of driving instead of $before.';
  }

  @override
  String routeBuilderRoadSummary(
    String stops,
    String distance,
    String duration,
  ) {
    return '$stops · $distance by road · ≈ $duration driving';
  }

  @override
  String routeRoadToNext(String distance, String duration) {
    return '$distance by road to the next stop · ≈ $duration';
  }

  @override
  String get routeBuilderMapHeading => 'Road preview';

  @override
  String routeBuilderTimes(String visit, String breaks) {
    return 'Visits $visit · Breaks $breaks';
  }

  @override
  String get routeBuilderTravelNote =>
      'Road distance and travel time are calculated as you change the stops; without a connection, straight-line distance is shown.';

  @override
  String get routeCreate => 'Create route';

  @override
  String get routeSaveChanges => 'Save changes';

  @override
  String routeCreatedAnnouncement(
    String stops,
    String distance,
    String duration,
  ) {
    return 'Route created: $stops, $distance, $duration in total.';
  }

  @override
  String get routeUpdatedAnnouncement => 'Route updated.';

  @override
  String routeValidationNameTooLong(int max) {
    return 'The route name can be at most $max characters.';
  }

  @override
  String get routeValidationGeneric => 'Please check the route details.';

  @override
  String routeLimitReached(int max) {
    return 'A route can have at most $max monuments.';
  }

  @override
  String get routeAddToRoute => 'Add to route';

  @override
  String get routeRemoveFromRoute => 'Remove from route';

  @override
  String routeAddedSnack(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Added to route · $count monuments in draft',
      one: 'Added to route · 1 monument in draft',
    );
    return '$_temp0';
  }

  @override
  String get routeGoToDraft => 'Go to route';

  @override
  String get mapSearchHint => 'Search places or monuments';

  @override
  String mapSearchEditSemantics(String query) {
    return 'Search: $query. Tap to edit';
  }

  @override
  String get mapSearchClear => 'Clear search';

  @override
  String get mapFiltersButton => 'Filters';

  @override
  String mapFiltersButtonActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Filters, $count active',
      one: 'Filters, 1 active',
    );
    return '$_temp0';
  }

  @override
  String mapResultsShowing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count monuments shown',
      one: '1 monument shown',
    );
    return '$_temp0';
  }

  @override
  String get mapNoMatches => 'No matching monuments';

  @override
  String get mapClearRefinements => 'Clear';

  @override
  String get mapClearRefinementsSemantics => 'Clear search and filters';

  @override
  String get mapRefinementsClearedAnnouncement =>
      'Search and filters cleared, showing all monuments';

  @override
  String get mapLocateMe => 'Show my location';

  @override
  String get mapLocating => 'Finding your location';

  @override
  String get mapUserLocationSemantics => 'Your location';

  @override
  String get mapLocationShownAnnouncement => 'Showing your location';

  @override
  String get locationIssueServiceDisabled =>
      'Location services are off. Turn them on to see your location.';

  @override
  String get locationIssuePermissionDenied =>
      'Location permission was not granted. Allow it to see your location.';

  @override
  String get locationIssuePermissionDeniedForever =>
      'Location permission is off. You can allow it in Settings.';

  @override
  String get locationIssueUnavailable =>
      'Your location can\'t be found right now. Please try again.';

  @override
  String get locationOutsideRegion => 'Your location is outside the map area.';

  @override
  String get locationOpenSettings => 'Settings';

  @override
  String get searchAllMonuments => 'All monuments';

  @override
  String get searchPlacesHeader => 'Places';

  @override
  String get searchMonumentsHeader => 'Monuments';

  @override
  String searchShowOnMap(String name) {
    return 'Show $name on map';
  }

  @override
  String get searchNoResultsTitle => 'No results';

  @override
  String searchNoResultsBody(String query) {
    return 'No places or monuments match “$query”. Check the spelling or try a shorter search.';
  }

  @override
  String searchResultsAnnouncement(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count results',
      one: '1 result',
      zero: 'No results',
    );
    return '$_temp0';
  }

  @override
  String get searchRemoveFilters => 'Remove filters';

  @override
  String searchPlaceAnnouncement(String place, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$place: $count monuments',
      one: '$place: 1 monument',
    );
    return '$_temp0';
  }

  @override
  String get filterSheetTitle => 'Filters';

  @override
  String get filterCategorySection => 'Building type';

  @override
  String get filterPeriodSection => 'Period';

  @override
  String get filterCitySection => 'Province';

  @override
  String filterOptionWithCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String get accountButtonGuestSemantics => 'Account menu, guest';

  @override
  String accountButtonSemantics(String name) {
    return 'Account menu, $name';
  }

  @override
  String get accountMenuGuestTitle => 'Guest';

  @override
  String get accountMenuGuestBody =>
      'Sign in to share memories and report damage.';

  @override
  String get accountMenuProfile => 'My profile';

  @override
  String get accountMenuSignIn => 'Sign in or register';

  @override
  String searchResultsTotal(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count results',
      one: '1 result',
    );
    return '$_temp0';
  }

  @override
  String searchApplyToMap(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Show $count results on map',
      one: 'Show 1 result on map',
    );
    return '$_temp0';
  }

  @override
  String get searchLoadingMore => 'Loading more results';

  @override
  String get searchLoadMoreFailed => 'More results couldn\'t be loaded.';

  @override
  String searchEndOfResults(int count) {
    return 'All results shown ($count)';
  }

  @override
  String searchMoreLoadedAnnouncement(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count more results loaded',
      one: '1 more result loaded',
    );
    return '$_temp0';
  }

  @override
  String get searchLoadFailedTitle => 'Results couldn\'t be loaded';

  @override
  String get searchNoFilterResultsBody =>
      'No monuments match the selected filters. Try removing filters.';

  @override
  String filterSelectionSummary(String first, int more) {
    return '$first +$more';
  }

  @override
  String filterGroupSemantics(String group, String selection) {
    return '$group filter: $selection';
  }

  @override
  String get filterNoneSelected => 'none selected';

  @override
  String get filterApplyButton => 'Apply';

  @override
  String get filterGroupClear => 'Clear';

  @override
  String get filterClearAllChip => 'Clear filters';

  @override
  String get mapRefinementFailed =>
      'The search couldn\'t be applied to the map.';

  @override
  String mapClusterSemantics(int count) {
    return '$count monuments in this area. Tap to zoom in.';
  }

  @override
  String mapClusterListSemantics(int count) {
    return '$count monuments at the same place. Tap to list them.';
  }

  @override
  String mapClusterExpandedAnnouncement(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zoomed in to $count monuments',
      one: 'Zoomed in to 1 monument',
    );
    return '$_temp0';
  }

  @override
  String get mapClusterSheetTitle => 'Monuments at this place';

  @override
  String get mapPreviewLoading => 'Loading preview';

  @override
  String get mapPreviewLoadFailed =>
      'The monument preview couldn\'t be loaded.';

  @override
  String get mapClusterLoadFailed =>
      'The monuments at this place couldn\'t be loaded.';

  @override
  String get settingsReduceMotionSystemOn =>
      'It is on in your device\'s accessibility settings, so it is always applied in the app.';

  @override
  String get settingsPermissionsSection => 'Privacy and permissions';

  @override
  String get settingsAboutSection => 'About';

  @override
  String get settingsReplayOnboarding => 'Show the app introduction again';

  @override
  String get settingsPrivacyNotice => 'Privacy Notice (KVKK)';

  @override
  String get settingsTermsOfUse => 'Terms of Use';

  @override
  String get permissionLocationTitle => 'Location';

  @override
  String get permissionLocationPurpose =>
      'Used to show foundation monuments near you on the map. On the map your location is processed only on your device. It is sent only with a damage report you choose to add it to.';

  @override
  String get permissionStatusChecking => 'Checking status';

  @override
  String get permissionStatusGranted => 'Allowed';

  @override
  String get permissionStatusNotGranted => 'Not allowed';

  @override
  String get permissionStatusBlocked =>
      'Turned off. You can allow it in system settings.';

  @override
  String get permissionStatusBlockedBrowser =>
      'Turned off. You can allow it from the icon in your browser\'s address bar or in site settings.';

  @override
  String get permissionStatusServiceDisabled =>
      'Location services are turned off on this device.';

  @override
  String get permissionStatusUnsupported => 'Not available on this device.';

  @override
  String permissionStatusSemantics(String permission, String status) {
    return '$permission permission: $status';
  }

  @override
  String get permissionLocationAllow => 'Allow location access';

  @override
  String get permissionCameraTitle => 'Camera';

  @override
  String get permissionCameraPurpose =>
      'Used to take photos for the Memory Corner and damage reports. A photo is uploaded only when you share it; its location data is removed first.';

  @override
  String get permissionCameraAllow => 'Allow camera access';

  @override
  String get permissionMicrophoneTitle => 'Microphone';

  @override
  String get permissionMicrophonePurpose =>
      'Used to ask the Digital Guide by voice. Your speech is turned into text by your device\'s or browser\'s speech recognition service; the app keeps no recording and nothing is sent until you send it.';

  @override
  String get permissionMicrophoneAllow => 'Allow microphone access';

  @override
  String get permissionOpenAppSettings => 'Open app settings';

  @override
  String get permissionOpenLocationSettings => 'Open location settings';

  @override
  String get permissionManageInSettings => 'Manage in system settings';

  @override
  String get permissionOnDemandNote =>
      'You can use the app without granting these. When a feature needs a permission (taking a photo, asking by voice), you will be asked again.';

  @override
  String onboardingStepCounter(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String onboardingStepAnnouncement(int current, int total, String title) {
    return 'Step $current of $total: $title';
  }

  @override
  String get onboardingBack => 'Back';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingSkipSemantics => 'Skip introduction';

  @override
  String get onboardingStart => 'Get started';

  @override
  String get onboardingNext => 'Continue';

  @override
  String get onboardingWelcomeTitle => 'Welcome';

  @override
  String get onboardingWelcomeDescription =>
      'Discover foundation monuments on the map, explore their details and plan your visit. Let\'s set up the app for you first, starting with your language.';

  @override
  String get onboardingDisplayTitle => 'Appearance';

  @override
  String get onboardingDisplayDescription =>
      'Choose a light, dark or device-matching theme. The change applies immediately.';

  @override
  String get onboardingAccessibilityTitle => 'Accessibility';

  @override
  String get onboardingAccessibilityDescription =>
      'Vakıf Atlas works with screen readers (TalkBack, VoiceOver), keyboards and large text. Set text size, high contrast, colour vision, motion and vibration on a single page; you can change them later from Accessibility in the account menu.';

  @override
  String get onboardingChangeLaterNote =>
      'You can change these preferences at any time in Settings.';

  @override
  String get onboardingTourTitle => 'Get to know Vakıf Atlas';

  @override
  String get onboardingTourDescription => 'A quick look at how to use the app.';

  @override
  String get onboardingTourMapTitle => 'Explore the map';

  @override
  String get onboardingTourMapBody =>
      'Monuments are grouped on the map. Tap a group to zoom in; tap a monument to open its details and photos.';

  @override
  String get onboardingTourSearchTitle => 'Search and filter';

  @override
  String get onboardingTourSearchBody =>
      'Search by monument, province or district; narrow results by building type, period and province, and see them on the map.';

  @override
  String get onboardingTourRoutesTitle => 'Plan your route';

  @override
  String get onboardingTourRoutesBody =>
      'Create a trip of 2–10 monuments and reorder it for the shortest path with one tap. Your routes are linked to this device, no account needed.';

  @override
  String get onboardingTourContributeTitle => 'Contribute';

  @override
  String get onboardingTourContributeBody =>
      'With an account, you can share your memories of monuments in the Memory Corner and report damage you notice.';

  @override
  String get onboardingPermissionsTitle => 'Permissions';

  @override
  String get onboardingPermissionsDescription =>
      'Permissions are requested only for the related feature, with the reason explained. None are required; you can use the app without them.';

  @override
  String get onboardingPermissionsChangeLater =>
      'You can change permissions at any time in Settings or in your device\'s system settings.';

  @override
  String get onboardingPrivacyNoticeLink => 'Read the Privacy Notice';

  @override
  String get onboardingAccountTitle => 'How would you like to continue?';

  @override
  String get onboardingAccountDescription =>
      'You don\'t need an account for the map, search and route planning. Sign in to share memories and report damage.';

  @override
  String get onboardingSignIn => 'Sign in';

  @override
  String get onboardingCreateAccount => 'Create account';

  @override
  String get onboardingContinueAsGuest => 'Continue as guest';

  @override
  String onboardingSignedInTitle(String name) {
    return 'Welcome, $name';
  }

  @override
  String get onboardingSignedInDescription =>
      'You\'re signed in and your preferences are saved.';

  @override
  String get onboardingContinueSignedIn => 'Continue to the app';

  @override
  String get routePickerSearchHint => 'Search monuments to add';

  @override
  String routePickerStopSubtitle(String details, int position) {
    return '$details · stop $position';
  }

  @override
  String get routeExportAction => 'Export as PDF';

  @override
  String get routeExportInProgress => 'Preparing PDF';

  @override
  String get routeExportReadyTitle => 'PDF ready';

  @override
  String routeExportReadyAnnouncement(String fileName) {
    return 'PDF ready: $fileName';
  }

  @override
  String get routeExportSavedNote => 'Saved to My exports.';

  @override
  String get routeExportGuestSavedNote =>
      'Saved to My exports on this device. Sign in to move it to your account and see it on your other devices.';

  @override
  String get routeExportOpenExports => 'My exports';

  @override
  String get routeExportArchiveFailed =>
      'The PDF is ready but couldn\'t be saved to My exports. You can still share or print it.';

  @override
  String get routeExportFailed =>
      'The PDF couldn\'t be created. Please try again.';

  @override
  String get routeExportShare => 'Share';

  @override
  String get routeExportCopyLink => 'Copy link';

  @override
  String routeExportLinkCopied(String date) {
    return 'Link copied. Anyone with the link can open the PDF until $date; deleting the export disables the link.';
  }

  @override
  String get routeExportPrint => 'Print';

  @override
  String get routeExportPreview => 'Preview';

  @override
  String get routeExportSignIn => 'Sign in';

  @override
  String get routeExportShareFailed => 'The share sheet couldn\'t be opened.';

  @override
  String get routeExportPrintFailed => 'The print dialog couldn\'t be opened.';

  @override
  String get routeExportSketchHeading => 'Route map';

  @override
  String get routeExportSketchCaption =>
      'North is at the top. Numbers match the stop list below; the filled marker is the starting stop.';

  @override
  String get routeExportStopsHeading => 'Stops and travel';

  @override
  String get routeExportMapLink => 'Open location on map';

  @override
  String get routeExportAttribution =>
      'Road data © OpenStreetMap contributors (ODbL); distances and times calculated with OSRM.';

  @override
  String routeExportPageOf(String page, String total) {
    return 'Page $page of $total';
  }

  @override
  String routeExportGeneratedOn(String date) {
    return 'Prepared: $date';
  }

  @override
  String get routeExportsTitle => 'My exports';

  @override
  String get routeExportsEmptyTitle => 'No exports yet';

  @override
  String get routeExportsEmptyBody =>
      'When you tap the PDF icon on a route\'s page, the export appears here.';

  @override
  String routeExportsItemSubtitle(String date, String stops, String size) {
    return '$date · $stops · $size';
  }

  @override
  String routeExportsMoreActions(String name) {
    return 'Actions for $name';
  }

  @override
  String get routeExportsDelete => 'Delete';

  @override
  String get routeExportsDeleteConfirmTitle => 'Delete this export?';

  @override
  String routeExportsDeleteConfirmBody(String name) {
    return 'The “$name” PDF will be permanently deleted from your archive. The route itself isn\'t deleted.';
  }

  @override
  String get routeExportsDeleted => 'Export deleted';

  @override
  String get routeExportsLoadFailedTitle => 'Exports couldn\'t be loaded';

  @override
  String fileSizeKilobytes(String size) {
    return '$size KB';
  }

  @override
  String fileSizeMegabytes(String size) {
    return '$size MB';
  }

  @override
  String get memoryCornerSubtitle => 'Visitors\' memories of this monument';

  @override
  String memoryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count memories',
      one: '1 memory',
      zero: 'No memories yet',
    );
    return '$_temp0';
  }

  @override
  String get memoryShare => 'Share a memory';

  @override
  String memoryViewAll(int count) {
    return 'See all memories ($count)';
  }

  @override
  String get memoryEmptyTitle => 'No memories shared yet';

  @override
  String get memoryEmptyBody =>
      'If you have visited this monument, be the first to share a memory.';

  @override
  String get memoryLoading => 'Loading memories';

  @override
  String get memoryLoadFailedTitle => 'Memories couldn\'t be loaded';

  @override
  String get memoryLoadMoreFailed => 'More memories couldn\'t be loaded.';

  @override
  String get myMemoriesTitle => 'My memories';

  @override
  String myMemoriesViewAll(int count) {
    return 'All my memories ($count)';
  }

  @override
  String get myMemoriesEmptyTitle => 'You haven\'t shared any memories yet';

  @override
  String get myMemoriesEmptyBody =>
      'Share a memory with photos and a note in the Memory Corner of a monument you visited.';

  @override
  String get myMemoriesLoading => 'Loading your memories';

  @override
  String get myMemoriesLoadFailed => 'Couldn\'t load your memories.';

  @override
  String get myMemoriesUnknownMonument => 'Foundation monument';

  @override
  String get myMemoriesOpenCorner => 'View in Memory Corner';

  @override
  String myMemoriesOpenCornerSemantics(String name) {
    return 'View in $name Memory Corner';
  }

  @override
  String myMemoriesPreviewSemantics(String name, String date, String text) {
    return '$name, $date: $text';
  }

  @override
  String get myMemoriesStatusPending =>
      'Under review; it will appear in the Memory Corner once approved. Until then it is only shown here.';

  @override
  String get myMemoriesStatusRejected =>
      'Not published because it does not meet the community guidelines; it is not shown in the Memory Corner, only here.';

  @override
  String get memoryOwnBadge => 'You';

  @override
  String memoryVisited(String date) {
    return 'Visited: $date';
  }

  @override
  String memoryCardSemantics(String author, String date) {
    return 'Shared by $author on $date';
  }

  @override
  String memoryOwnCardSemantics(String date) {
    return 'Your memory, shared on $date';
  }

  @override
  String get memoryReadMore => 'Read more';

  @override
  String get memoryReadLess => 'Show less';

  @override
  String memoryMoreActions(String author) {
    return 'More actions for $author\'s memory';
  }

  @override
  String get memoryDelete => 'Delete';

  @override
  String get memoryReport => 'Report';

  @override
  String get memoryDeleteConfirmTitle => 'Delete this memory?';

  @override
  String get memoryDeleteConfirmBody =>
      'This memory and its photos will be permanently deleted for everyone.';

  @override
  String get memoryDeleted => 'Your memory was deleted';

  @override
  String get memoryReportTitle => 'Report memory';

  @override
  String get memoryReportQuestion => 'Why is this memory inappropriate?';

  @override
  String get memoryReportReasonOffensive =>
      'Hate speech, harassment or insults';

  @override
  String get memoryReportReasonInappropriate =>
      'Sexual, violent or disturbing content';

  @override
  String get memoryReportReasonSpam => 'Advertising or spam';

  @override
  String get memoryReportReasonPersonalInfo =>
      'Contains someone else\'s personal information';

  @override
  String get memoryReportReasonUnrelated => 'Not related to this monument';

  @override
  String get memoryReportReasonOther => 'Other';

  @override
  String get memoryReportNoteLabel => 'Details (optional)';

  @override
  String get memoryReportReasonRequired => 'Choose a reason.';

  @override
  String get memoryReportNotice =>
      'Your report is reviewed by the General Directorate of Foundations. You will no longer see this memory.';

  @override
  String get memoryReported => 'Thank you, your report was received';

  @override
  String get memorySignInTitle => 'Sign-in required';

  @override
  String get memorySignInToShare =>
      'Sign in to share a memory. You don\'t need to sign in to read memories.';

  @override
  String get memorySignInToReport => 'Sign in to report a memory.';

  @override
  String get memoryComposerClose => 'Close memory editor';

  @override
  String get memoryTextLabel => 'Your memory';

  @override
  String get memoryTextHint =>
      'What did you experience here, what caught your eye?';

  @override
  String get memoryTextEmptyError => 'Write your memory.';

  @override
  String memoryTextTooLongError(int max) {
    return 'A memory can be at most $max characters.';
  }

  @override
  String get photosHeading => 'Photos';

  @override
  String photosHint(int max) {
    return 'Optional · up to $max photos';
  }

  @override
  String photosCountSemantics(int count, int max) {
    return '$count of $max photos added';
  }

  @override
  String get photoAdd => 'Add photo';

  @override
  String get photoTake => 'Take a photo';

  @override
  String get photoChooseFromGallery => 'Choose from gallery';

  @override
  String photoRemove(int index) {
    return 'Remove photo $index';
  }

  @override
  String get photoAddDescription => 'Add description';

  @override
  String get photoEditDescription => 'Edit description';

  @override
  String photoDraftSemantics(int index, String description) {
    return 'Photo $index: $description';
  }

  @override
  String photoDraftNoDescription(int index) {
    return 'Photo $index, no description';
  }

  @override
  String photoDescriptionAction(int index) {
    return 'Description for photo $index';
  }

  @override
  String get photoProcessing => 'Preparing photo';

  @override
  String get photoDescriptionTitle => 'Photo description';

  @override
  String get photoDescriptionLabel => 'Description';

  @override
  String get photoDescriptionHelper =>
      'Briefly describe what the photo shows for people who use screen readers.';

  @override
  String photoDescriptionTooLong(int max) {
    return 'A description can be at most $max characters.';
  }

  @override
  String get commonSave => 'Save';

  @override
  String get photoCameraDenied =>
      'Camera access wasn\'t granted. You can allow it in your device settings.';

  @override
  String get photoCameraDeniedBrowser =>
      'Camera access was not granted. You can allow it from the camera icon in your browser\'s address bar or in site settings.';

  @override
  String get cameraCaptureTitle => 'Take a photo';

  @override
  String get cameraCaptureOpening =>
      'Opening the camera. Allow access if your browser asks.';

  @override
  String get cameraCaptureReady =>
      'Camera ready. Tap the shutter to take the photo.';

  @override
  String get cameraCaptureShutter => 'Take photo';

  @override
  String get cameraCaptureSwitch => 'Switch camera';

  @override
  String get cameraCaptureCapturing => 'Taking the photo';

  @override
  String get cameraCaptureDeniedTitle => 'Camera access not granted';

  @override
  String get cameraCaptureDeniedBody =>
      'Allow camera access for this site from the camera icon in your browser\'s address bar or in site settings, then try again.';

  @override
  String get cameraCaptureNoCameraTitle => 'No camera found';

  @override
  String get cameraCaptureNoCameraBody =>
      'There\'s no available camera on this device. You can pick a photo from your gallery instead.';

  @override
  String get cameraCaptureFailedTitle => 'Couldn\'t open the camera';

  @override
  String get cameraCaptureFailedBody =>
      'Another app may be using the camera. Close it and try again.';

  @override
  String get cameraCaptureShotFailed =>
      'Couldn\'t take the photo. Please try again.';

  @override
  String get photoGalleryDenied =>
      'Photo access wasn\'t granted. You can allow it in your device settings.';

  @override
  String get photoPickFailed =>
      'The photo couldn\'t be selected. Please try again.';

  @override
  String photoUnsupported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count photos couldn\'t be opened. Choose JPEG, PNG or WebP photos.',
      one: 'One photo couldn\'t be opened. Choose a JPEG, PNG or WebP photo.',
    );
    return '$_temp0';
  }

  @override
  String photoLimitReached(int max) {
    return 'You can add up to $max photos.';
  }

  @override
  String get memoryVisitHeading => 'Visit date';

  @override
  String get memoryVisitOptional => 'Optional';

  @override
  String get memoryVisitPick => 'Choose a date';

  @override
  String memoryVisitChange(String date) {
    return 'Visit date: $date. Change';
  }

  @override
  String get memoryVisitClear => 'Remove visit date';

  @override
  String memoryPublicNotice(String name) {
    return 'Your memory will be public on this monument\'s page under the name “$name”. Location and device details are removed from photos before upload. Please don\'t share other people\'s personal information.';
  }

  @override
  String get memorySubmit => 'Share';

  @override
  String photosUploading(int percent) {
    return 'Uploading photos · $percent%';
  }

  @override
  String get photosUploadingSemantics => 'Photo upload progress';

  @override
  String get memoryShared => 'Your memory was shared';

  @override
  String get memoryFixErrors => 'Fix the highlighted fields before sharing.';

  @override
  String get memoryDiscardTitle => 'Discard this memory?';

  @override
  String get memoryDiscardBody =>
      'Your text and the photos you added will be lost.';

  @override
  String get memoryDiscardConfirm => 'Discard';

  @override
  String get memoryKeepEditing => 'Keep editing';

  @override
  String get memoryPhotoNoDescription =>
      'No description was added for this photo.';

  @override
  String memoryPhotoCredit(String author, String date) {
    return '$author · $date';
  }

  @override
  String photoTileSemantics(int index, int count, String description) {
    return 'Photo $index of $count: $description';
  }

  @override
  String photoTileNoDescription(int index, int count) {
    return 'Photo $index of $count, no description';
  }

  @override
  String get photoOpenHint => 'open full screen';

  @override
  String get memoryEntryOpenHint => 'open timeline';

  @override
  String get memoryEntryLatest => 'Latest memory';

  @override
  String memoryEntrySemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Memory Corner, $count memories',
      one: 'Memory Corner, 1 memory',
      zero: 'Memory Corner, no memories yet',
    );
    return '$_temp0';
  }

  @override
  String memorySharedOn(String date) {
    return 'Shared: $date';
  }

  @override
  String get memoryFilterHeading => 'Filter by time';

  @override
  String memoryFilterAll(int count) {
    return 'All ($count)';
  }

  @override
  String memoryFilterYear(String year, int count) {
    return '$year ($count)';
  }

  @override
  String memoryFilterYearSemantics(String year, int count) {
    return 'Year $year, $count memories';
  }

  @override
  String get memoryFilterRange => 'Date range';

  @override
  String get memoryFilterRangeHelp => 'Choose a memory date range';

  @override
  String get memoryFilterClearRange => 'Remove date range';

  @override
  String get memoryFilterEmptyTitle => 'No memories in this period';

  @override
  String get memoryFilterEmptyBody => 'Choose a different year or date range.';

  @override
  String get memoryFilterClear => 'Clear filter';

  @override
  String memoryFilterResult(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Showing $count memories',
      one: 'Showing 1 memory',
      zero: 'No memories in this period',
    );
    return '$_temp0';
  }

  @override
  String get memoryTimelineHint =>
      'Memories are ordered by visit date (or share date if none).';

  @override
  String get navCivilProtection => 'Civil Protection';

  @override
  String get cpIntroTitle => 'Let\'s protect our heritage together';

  @override
  String get cpIntroBody =>
      'Report damage, vandalism or hazards you notice at foundation monuments to the General Directorate of Foundations. Every report gets a reference number and you can follow its progress here.';

  @override
  String get cpIntroStep1Title => 'Choose the monument and the issue';

  @override
  String get cpIntroStep1Body =>
      'Tell us the type of damage and how urgent it is.';

  @override
  String get cpIntroStep2Title => 'Describe and add photos';

  @override
  String get cpIntroStep2Body =>
      'Write what you saw; photos speed up the review.';

  @override
  String get cpIntroStep3Title => 'Follow the progress';

  @override
  String get cpIntroStep3Body =>
      'Track the review and the action taken by the Directorate here.';

  @override
  String get cpSignInPrompt => 'Sign in to send and follow reports.';

  @override
  String get cpEmergencyNotice =>
      'In an emergency that threatens life, call 112 first.';

  @override
  String get cpNewReport => 'Report damage';

  @override
  String get cpMyReports => 'My reports';

  @override
  String get cpReportsEmptyTitle => 'No reports yet';

  @override
  String get cpReportsEmptyBody =>
      'When you notice damage or a hazard at a foundation monument, you can report it here.';

  @override
  String get cpReportsLoading => 'Loading reports';

  @override
  String get cpReportsLoadFailed => 'Reports couldn\'t be loaded';

  @override
  String get cpLoadMoreFailed => 'More reports couldn\'t be loaded.';

  @override
  String cpReportItemSemantics(
    String monument,
    String category,
    String reference,
    String status,
    String date,
  ) {
    return '$monument, $category. Reference $reference. Status: $status. $date';
  }

  @override
  String get cpCategoryStructural => 'Structural damage';

  @override
  String get cpCategoryStructuralBody => 'Cracks, separation, deterioration';

  @override
  String get cpCategoryCollapse => 'Risk of collapse or falling parts';

  @override
  String get cpCategoryCollapseBody => 'Loose stones, hanging parts, leaning';

  @override
  String get cpCategoryVandalism => 'Vandalism';

  @override
  String get cpCategoryVandalismBody => 'Graffiti, scratches, breakage';

  @override
  String get cpCategoryTheft => 'Theft or missing part';

  @override
  String get cpCategoryTheftBody =>
      'Missing tile, inscription, ornament or part';

  @override
  String get cpCategoryFireWater => 'Fire or water damage';

  @override
  String get cpCategoryFireWaterBody => 'Fire marks, flooding, leaks';

  @override
  String get cpCategoryUnauthorized => 'Unauthorised construction or repair';

  @override
  String get cpCategoryUnauthorizedBody =>
      'Unauthorised building, digging or intervention';

  @override
  String get cpCategoryOther => 'Other';

  @override
  String get cpCategoryOtherBody => 'Something not listed above';

  @override
  String get cpUrgencyLow => 'Low';

  @override
  String get cpUrgencyLowBody => 'Not urgent, may worsen over time';

  @override
  String get cpUrgencyMedium => 'Medium';

  @override
  String get cpUrgencyMediumBody => 'Should be reviewed soon';

  @override
  String get cpUrgencyHigh => 'High';

  @override
  String get cpUrgencyHighBody => 'Damage is growing or affects visitors';

  @override
  String get cpUrgencyCritical => 'Critical';

  @override
  String get cpUrgencyCriticalBody =>
      'Serious, imminent danger to the building or surroundings';

  @override
  String get cpStatusReceived => 'Received';

  @override
  String get cpStatusInReview => 'In review';

  @override
  String get cpStatusForwarded => 'Forwarded to the responsible unit';

  @override
  String get cpStatusResolved => 'Resolved';

  @override
  String get cpStatusClosed => 'Closed';

  @override
  String get cpStatusReceivedBody => 'Your report has been registered.';

  @override
  String get cpStatusInReviewBody =>
      'The Directorate\'s civil protection unit is reviewing your report.';

  @override
  String get cpStatusForwardedBody =>
      'Forwarded to the responsible regional directorate for action.';

  @override
  String get cpStatusResolvedBody => 'The necessary action has been taken.';

  @override
  String get cpStatusClosedBody =>
      'The report was closed without further action.';

  @override
  String get cpStatusPending => 'Pending';

  @override
  String cpStatusStepSemantics(String status, String state) {
    return '$status, $state';
  }

  @override
  String get cpStatusDone => 'completed';

  @override
  String get cpStatusCurrent => 'current step';

  @override
  String get cpWizardTitle => 'Damage report';

  @override
  String get cpWizardClose => 'Close report';

  @override
  String cpStepProgress(int current, int total, String title) {
    return 'Step $current of $total: $title';
  }

  @override
  String get cpStepMonument => 'Monument';

  @override
  String get cpStepCategory => 'Type of damage';

  @override
  String get cpStepUrgency => 'Urgency';

  @override
  String get cpStepDetails => 'Description and photos';

  @override
  String get cpStepLocation => 'Location';

  @override
  String get cpStepReview => 'Review';

  @override
  String get cpStepMonumentQuestion => 'Which monument is this about?';

  @override
  String get cpStepCategoryQuestion => 'What did you notice?';

  @override
  String get cpStepUrgencyQuestion => 'How urgent is it?';

  @override
  String get cpStepDetailsQuestion => 'Describe the situation';

  @override
  String get cpStepLocationQuestion => 'Would you like to add your location?';

  @override
  String get cpStepReviewQuestion => 'Check your report';

  @override
  String get cpChooseMonument => 'Choose monument';

  @override
  String get cpChangeMonument => 'Change monument';

  @override
  String get cpMonumentPickerTitle => 'Choose a monument';

  @override
  String get cpMonumentPickerHint => 'Search monuments or places';

  @override
  String get cpMonumentLoadFailed => 'Monument details couldn\'t be loaded.';

  @override
  String get cpDescriptionLabel => 'Description';

  @override
  String get cpDescriptionHint =>
      'Describe where and what: which side, how large, since when…';

  @override
  String cpDescriptionTooShort(int min) {
    return 'Describe it in at least $min characters.';
  }

  @override
  String cpDescriptionTooLong(int max) {
    return 'The description can be at most $max characters.';
  }

  @override
  String get cpLocationExplain =>
      'Your location is sent to the Directorate only with this report, to confirm it was made on site, and is used for nothing else. You can send the report without it.';

  @override
  String get cpLocationToggle => 'Add my location to this report';

  @override
  String get cpLocationLocating => 'Getting your location…';

  @override
  String cpLocationFound(int accuracy) {
    return 'Location received (±$accuracy m).';
  }

  @override
  String cpLocationDistance(String distance) {
    return 'You are about $distance from the monument.';
  }

  @override
  String get cpLocationOnSite =>
      'You are near the monument; your report will be marked as made on site.';

  @override
  String get cpLocationFar =>
      'You are far from the monument; your report will still be sent.';

  @override
  String get cpLocationServiceDisabled =>
      'Location services are off. Turn them on in settings or continue without location.';

  @override
  String get cpLocationDenied =>
      'Location permission wasn\'t granted. You can continue without location.';

  @override
  String get cpLocationDeniedForever =>
      'Location permission is off. Allow it in settings or continue without location.';

  @override
  String get cpLocationUnavailable =>
      'Your location can\'t be determined right now. Try again or continue without location.';

  @override
  String get cpLocationUnsupported =>
      'Location can\'t be added on this device.';

  @override
  String get cpReviewEdit => 'Edit';

  @override
  String cpReviewEditSemantics(String section) {
    return 'Edit $section';
  }

  @override
  String cpReviewPhotos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count photos',
      one: '1 photo',
      zero: 'No photos',
    );
    return '$_temp0';
  }

  @override
  String get cpReviewLocationShared => 'Location added';

  @override
  String get cpReviewLocationNotShared => 'No location';

  @override
  String get cpNext => 'Next';

  @override
  String get cpBack => 'Back';

  @override
  String get cpSubmit => 'Send report';

  @override
  String cpSubmitted(String code) {
    return 'Report received · $code';
  }

  @override
  String get cpFixStep => 'Complete this step before continuing.';

  @override
  String get cpMonumentRequired => 'Choose a monument.';

  @override
  String get cpCategoryRequired => 'Choose a type of damage.';

  @override
  String get cpUrgencyRequired => 'Choose the urgency.';

  @override
  String get cpDiscardTitle => 'Discard this report?';

  @override
  String get cpDiscardBody =>
      'The details and photos you entered will be lost.';

  @override
  String get cpDiscardConfirm => 'Discard';

  @override
  String get cpKeepEditing => 'Keep editing';

  @override
  String get cpDetailTitle => 'Report';

  @override
  String get cpReferenceLabel => 'Reference number';

  @override
  String get cpCopyReference => 'Copy reference number';

  @override
  String get cpReferenceCopied => 'Reference number copied';

  @override
  String get cpStatusHeading => 'Progress';

  @override
  String get cpDetailsHeading => 'Report details';

  @override
  String get cpCategoryField => 'Type of damage';

  @override
  String get cpUrgencyField => 'Urgency';

  @override
  String get cpDescriptionField => 'Description';

  @override
  String get cpPhotosField => 'Photos';

  @override
  String get cpLocationField => 'Location';

  @override
  String cpLocationOnSiteValue(String distance) {
    return 'Verified on site ($distance from the monument)';
  }

  @override
  String cpLocationDistantValue(String distance) {
    return 'Reported $distance from the monument';
  }

  @override
  String get cpLocationNotProvidedValue => 'No location shared';

  @override
  String cpSubmittedOn(String date) {
    return 'Sent: $date';
  }

  @override
  String get cpNoteFromVgm => 'Note from the Directorate';

  @override
  String get cpDetailLoadFailed => 'The report couldn\'t be loaded';

  @override
  String get cpNotFoundTitle => 'Report not found';

  @override
  String get cpNotFoundBody =>
      'This report doesn\'t belong to you or has been removed.';

  @override
  String get cpBackToList => 'Back to my reports';

  @override
  String get cpPhotoNoDescription => 'No description was added for this photo.';

  @override
  String get cpPhotoCredit => 'Photo from your report';

  @override
  String get monumentReportTitle => 'Noticed a problem?';

  @override
  String get monumentReportBody =>
      'If you noticed damage, vandalism or a hazard at this monument, report it to Civil Protection.';

  @override
  String get accountButtonTooltip => 'Account and settings';

  @override
  String get guideWelcomeTitle => 'How can I help you?';

  @override
  String get guideWelcomeBody =>
      'Ask about foundation monuments or tell me what you\'d like to do in the app, and I\'ll take you to the right page.';

  @override
  String get guideStartersHeading => 'Try asking';

  @override
  String get guideStarterMonument => 'Who built the Süleymaniye Mosque?';

  @override
  String get guideStarterList => 'Seljuk monuments in Konya';

  @override
  String get guideStarterRoute => 'How do I plan a route?';

  @override
  String get guideStarterDamage => 'How do I report damage?';

  @override
  String guideAskSuggestion(String question) {
    return 'Ask: $question';
  }

  @override
  String get guideSuggestionsSemantics => 'Suggested questions';

  @override
  String guideQuestionSemantics(String text) {
    return 'You: $text';
  }

  @override
  String guideAnswerAnnouncement(String text) {
    return 'Guide: $text';
  }

  @override
  String guideSources(String names) {
    return 'Source: VGM catalogue — $names';
  }

  @override
  String get guideTyping => 'The guide is preparing an answer…';

  @override
  String get guideSendFailed => 'Your question could not be sent.';

  @override
  String get guideNewConversation => 'New conversation';

  @override
  String get guideResetAnnouncement => 'New conversation started.';

  @override
  String get guideInputLabel => 'Ask the guide';

  @override
  String get guideInputHint => 'A monument, city or something you want to do…';

  @override
  String guideInputCounter(int count, int max) {
    return '$count/$max';
  }

  @override
  String get guideSend => 'Send';

  @override
  String get guideVoiceStart => 'Ask by voice';

  @override
  String get guideVoiceStop => 'Stop listening';

  @override
  String get guideVoiceListening => 'Listening… Say your question, then stop.';

  @override
  String guideVoiceHeard(String text) {
    return 'You said: $text. Tap Send to send it.';
  }

  @override
  String get guideVoicePermissionDenied =>
      'Voice questions need microphone access.';

  @override
  String get guideVoicePermissionBlocked =>
      'Microphone access is turned off. You can allow it in system settings.';

  @override
  String get guideVoicePermissionBlockedWeb =>
      'Microphone access is turned off. You can allow it in your browser\'s site settings.';

  @override
  String get guideVoiceUnavailable =>
      'Voice questions aren\'t available on this device or browser. You can type your question.';

  @override
  String get guideVoiceNoMatch =>
      'We couldn\'t make out what you said. Try again or type it.';

  @override
  String get guideVoiceFailed =>
      'Couldn\'t get your voice question. Try again or type it.';

  @override
  String get guidePrivacyNotice =>
      'Answers are based on the VGM catalogue. Don\'t share personal information.';

  @override
  String guideActionOpenMonument(String name) {
    return 'Open $name';
  }

  @override
  String get guideActionShowOnMap => 'Show on map';

  @override
  String get guideActionOpenMemories => 'See memories';

  @override
  String get guideActionReportDamage => 'Report damage';

  @override
  String guideActionSearch(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'List $count monuments',
      one: 'List 1 monument',
    );
    return '$_temp0';
  }

  @override
  String get guideActionSearchAll => 'Search monuments';

  @override
  String get guideActionOpenMap => 'Open map';

  @override
  String get guideActionOpenRoutes => 'My routes';

  @override
  String get guideActionNewRoute => 'Create route';

  @override
  String get guideActionOpenCivilProtection => 'Civil Protection';

  @override
  String get guideActionOpenSettings => 'Open settings';

  @override
  String guideActionForMonument(String action, String name) {
    return '$action: $name';
  }

  @override
  String get accessibilityTitle => 'Accessibility';

  @override
  String get accessibilityIntro =>
      'Each tap on a tile moves to the next level; after the last level it turns off. Preferences apply to the whole app immediately and are stored on this device.';

  @override
  String get accessibilityDeviceNote =>
      'Screen readers, bold text and the device text size come from your device settings; the app follows them. The text size here is multiplied by the device size.';

  @override
  String get accessibilityReset => 'Reset to defaults';

  @override
  String get accessibilityResetDone =>
      'Accessibility preferences were reset to defaults.';

  @override
  String get settingsAccessibilityDescription =>
      'Text size, high contrast, colour vision, motion and vibration';

  @override
  String get onboardingAccessibilityOpen => 'Open accessibility settings';

  @override
  String get guideActionOpenAccessibility => 'Open accessibility settings';

  @override
  String get a11yImageHidden => 'Image hidden';

  @override
  String get a11yFeatureReadAloud => 'Read Aloud';

  @override
  String get a11yFeatureReadOnFocus => 'Read on Focus';

  @override
  String get a11yFeatureGrayscale => 'Grayscale';

  @override
  String get a11yFeatureContrast => 'Contrast';

  @override
  String get a11yFeatureZoom => 'Zoom';

  @override
  String get a11yFeatureHideImages => 'Hide Images';

  @override
  String get a11yFeatureHighlightLinks => 'Highlight Links';

  @override
  String get a11yFeatureColorBlindness => 'Colour Blindness';

  @override
  String get a11yFeatureEasyReading => 'Easy Reading';

  @override
  String get a11yFeatureBlueLightFilter => 'Blue Light Filter';

  @override
  String get a11yFeatureStopAnimations => 'Stop Animations';

  @override
  String get a11yFeatureDyslexiaFriendly => 'Dyslexia Friendly';

  @override
  String get a11yFeatureReadingGuide => 'Reading Guide';

  @override
  String get a11yFeatureFocusHighlight => 'Focus Highlight';

  @override
  String get a11yFeatureBigCursor => 'Big Cursor';

  @override
  String get a11yFeatureLineHeight => 'Line Height';

  @override
  String get a11yFeatureAlignLeft => 'Align Left';

  @override
  String get a11yFeatureHaptics => 'Vibration';

  @override
  String get a11yLevelOff => 'Off';

  @override
  String get a11yLevelOn => 'On';

  @override
  String get a11yContrastAuto => 'High contrast';

  @override
  String get a11yContrastDark => 'Dark high contrast';

  @override
  String get a11yContrastLight => 'Light high contrast';

  @override
  String get a11yContrastInvert => 'Inverted colours';

  @override
  String get a11yBlueLightLow => 'Low';

  @override
  String get a11yBlueLightHigh => 'High';

  @override
  String get a11yDyslexiaFont => 'Legible font';

  @override
  String get a11yDyslexiaSpacing => 'Legible font and wide spacing';

  @override
  String get a11yDyslexiaCream =>
      'Legible font, wide spacing and cream background';

  @override
  String get a11yGuideThin => 'Thin line';

  @override
  String get a11yGuideThick => 'Thick line';

  @override
  String get a11yGuideMask => 'Reading mask';

  @override
  String get a11yFocusVisible => 'Visible';

  @override
  String get a11yFocusThick => 'Thick';

  @override
  String get a11yFocusExtra => 'Extra thick';

  @override
  String get a11yCursorLarge => 'Large';

  @override
  String get a11yCursorExtra => 'Extra large';

  @override
  String a11yLineHeightValue(String value) {
    return '$value×';
  }

  @override
  String a11yTileState(String feature, String state) {
    return '$feature: $state';
  }

  @override
  String a11yTileLevel(int level, int levels) {
    return 'Level $level of $levels';
  }

  @override
  String get a11yTileHint => 'next level';

  @override
  String get mapAccessibilityButton => 'Accessibility';

  @override
  String get settingsShowAccessibilityButton =>
      'Show the Accessibility button on the map';

  @override
  String get settingsShowAccessibilityButtonDescription =>
      'When off, you can reach the accessibility panel from here and from the welcome tour; your preferences stay applied.';

  @override
  String complexMemberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count buildings',
      one: '1 building',
      zero: 'No buildings listed',
    );
    return '$_temp0';
  }

  @override
  String get complexMembersTitle => 'Buildings of the complex';

  @override
  String complexMembersSeeAll(int count) {
    return 'See all buildings ($count)';
  }

  @override
  String complexMembersPageTitle(String name) {
    return 'Buildings of $name';
  }

  @override
  String get complexMembersEmpty =>
      'The buildings of this complex have not been added to the catalogue yet.';

  @override
  String get complexMembersFilterEmpty => 'No buildings of this type.';

  @override
  String get complexMembersLoadFailed =>
      'The buildings of the complex could not be loaded.';

  @override
  String complexMembersEndOfList(int count) {
    return 'All buildings shown ($count)';
  }

  @override
  String complexMemberSemantics(int index, String name, String category) {
    return '$index. $name, $category';
  }

  @override
  String complexPartOf(String name) {
    return 'Part of $name';
  }

  @override
  String get complexPartOfHint =>
      'Tap to see the complex and its other buildings';

  @override
  String get complexSiblingsTitle => 'Other buildings of the complex';

  @override
  String get complexLayoutTitle => 'Site plan';

  @override
  String complexLayoutMapSemantics(String name, String members) {
    return 'Site plan of $name, $members. The buildings are listed above in the same order.';
  }

  @override
  String get complexOpen => 'View complex';

  @override
  String complexOpenSemantics(String name) {
    return 'View complex, $name';
  }

  @override
  String get complexFactMembers => 'Buildings';

  @override
  String complexListItemSubtitle(String location, String members) {
    return '$location · Complex · $members';
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
    return '$name, complex, $members, $district, $city';
  }

  @override
  String mapComplexMemberSemantics(String name, String complex) {
    return '$name, in $complex';
  }

  @override
  String mapComplexAreaSemantics(String name) {
    return 'Site of $name. Tap to select the complex.';
  }

  @override
  String get memoryStatusApproved => 'Published';

  @override
  String get memoryStatusPending => 'In review';

  @override
  String get memoryStatusRejected => 'Not published';

  @override
  String get memorySharedPending =>
      'Your memory is being reviewed. It will appear in the Memory Corner once approved; you can follow it in My memories.';

  @override
  String get memorySharedRejected =>
      'Your memory was not published because it does not meet the community guidelines. You can see it in My memories.';

  @override
  String get memoryOpenMyMemories => 'My memories';

  @override
  String myMemoriesPreviewStatusSemantics(String status, String summary) {
    return '$status. $summary';
  }

  @override
  String get monumentLocationPending =>
      'This monument\'s location has not been entered yet, so it is not on the map or in the route planner.';

  @override
  String monumentNickname(String name) {
    return 'Also known as: $name';
  }

  @override
  String monumentPartFallback(int index) {
    return 'Section $index';
  }

  @override
  String routePickerNoLocation(String details) {
    return '$details · No location, cannot be added to a route';
  }
}
