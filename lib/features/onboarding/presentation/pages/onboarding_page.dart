import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/a11y/reduce_motion.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_durations.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/onboarding/presentation/widgets/onboarding_widgets.dart';
import 'package:vakif_atlas/features/settings/presentation/widgets/permission_card_list.dart';
import 'package:vakif_atlas/features/settings/presentation/widgets/preference_settings.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/atoms/brand_emblem.dart';
import 'package:vakif_atlas/shared/widgets/atoms/diamond_divider.dart';

/// Tanıtımın bitiş biçimi; yönlendirme router'da yapılır.
enum OnboardingExit {
  signIn,
  createAccount,
  guest,

  /// Oturum zaten açıksa (ör. tanıtım ayarlardan yeniden açıldı).
  continueSignedIn,
}

enum OnboardingStep {
  welcome,
  display,
  accessibility,
  tour,
  permissions,
  account,
}

/// İlk açılış tanıtımı: dil ve tema, erişilebilirlik sayfasına giriş,
/// uygulamanın kullanımı, izinler ve hesap seçimi.
///
/// - Tercihler `AppSettingsCubit` ile anında uygulanır; Ayarlar'dan
///   sonradan değiştirilebilir. Erişilebilirlik tercihleri burada
///   denetlenmez: adım tek yapılandırma noktası olan Erişilebilirlik
///   sayfasını açar (tanıtım sırasında da erişilebilir).
/// - Adımlar kaydırma hareketiyle değil butonlarla değişir (WCAG 2.5.1;
///   metin ölçeği kaydırıcısıyla çakışmaz). Her adım değişimi ekran
///   okuyucuya duyurulur; sistem geri hareketi önceki adıma döner.
/// - "Atla" tercihleri varsayılanda bırakıp hesap adımına geçer; hiçbir
///   izin istenmez.
/// - `LocationPermissionCubit` ve `DevicePermissionsCubit` üst ağaçtan
///   (router) sağlanır.
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({
    required this.onFinished,
    required this.onOpenPrivacyNotice,
    required this.onOpenAccessibility,
    this.signedInDisplayName,
    super.key,
  });

  final ValueChanged<OnboardingExit> onFinished;
  final VoidCallback onOpenPrivacyNotice;
  final VoidCallback onOpenAccessibility;

  /// Oturum açıksa kullanıcının adı; hesap adımında giriş seçenekleri
  /// yerine "devam et" gösterilir.
  final String? signedInDisplayName;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with ReduceMotionMixin {
  static const List<OnboardingStep> _steps = OnboardingStep.values;

  int _index = 0;

  OnboardingStep get _step => _steps[_index];

  bool get _isFirst => _index == 0;

  bool get _isLast => _index == _steps.length - 1;

  void _goTo(int index) {
    if (index == _index || index < 0 || index >= _steps.length) {
      return;
    }
    setState(() => _index = index);
    final l10n = context.l10n;
    unawaited(
      context.read<A11yAnnouncer>().announce(
        l10n.onboardingStepAnnouncement(
          index + 1,
          _steps.length,
          _titleOf(_steps[index], l10n),
        ),
      ),
    );
  }

  String _titleOf(OnboardingStep step, AppLocalizations l10n) => switch (step) {
    OnboardingStep.welcome => l10n.onboardingWelcomeTitle,
    OnboardingStep.display => l10n.onboardingDisplayTitle,
    OnboardingStep.accessibility => l10n.onboardingAccessibilityTitle,
    OnboardingStep.tour => l10n.onboardingTourTitle,
    OnboardingStep.permissions => l10n.onboardingPermissionsTitle,
    OnboardingStep.account => l10n.onboardingAccountTitle,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return PopScope(
      canPop: _isFirst,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _goTo(_index - 1);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: _isFirst
              ? null
              : BackButton(
                  key: const Key('onboarding_back_button'),
                  onPressed: () => _goTo(_index - 1),
                ),
          title: AppText(
            l10n.onboardingStepCounter(_index + 1, _steps.length),
            key: const Key('onboarding_step_counter'),
            role: AppTextRole.titleMedium,
            color: context.colors.onSurfaceVariant,
          ),
          actions: [
            if (!_isLast)
              TextButton(
                key: const Key('onboarding_skip_button'),
                onPressed: () => _goTo(_steps.length - 1),
                child: Text(
                  l10n.onboardingSkip,
                  semanticsLabel: l10n.onboardingSkipSemantics,
                ),
              ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(
              AppSizes.stepIndicator + AppSpacing.xs,
            ),
            child: OnboardingProgress(current: _index, total: _steps.length),
          ),
        ),
        body: SafeArea(
          bottom: false,
          child: AnimatedSwitcher(
            duration: motionDuration(AppDurations.normal),
            child: KeyedSubtree(
              key: ValueKey(_step),
              child: _StepScrollView(child: _buildStep(context)),
            ),
          ),
        ),
        bottomNavigationBar: _isLast
            ? null
            : SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.sm,
                    AppSpacing.md,
                    AppSpacing.md,
                  ),
                  child: Align(
                    heightFactor: 1,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: AppSizes.maxContentWidth,
                      ),
                      child: AppButton.primary(
                        key: const Key('onboarding_next_button'),
                        label: _isFirst
                            ? l10n.onboardingStart
                            : l10n.onboardingNext,
                        expand: true,
                        onPressed: () => _goTo(_index + 1),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildStep(BuildContext context) => switch (_step) {
    OnboardingStep.welcome => const _WelcomeStep(),
    OnboardingStep.display => const _DisplayStep(),
    OnboardingStep.accessibility => _AccessibilityStep(
      onOpenAccessibility: widget.onOpenAccessibility,
    ),
    OnboardingStep.tour => const _TourStep(),
    OnboardingStep.permissions => _PermissionsStep(
      onOpenPrivacyNotice: widget.onOpenPrivacyNotice,
    ),
    OnboardingStep.account => _AccountStep(
      signedInDisplayName: widget.signedInDisplayName,
      onFinished: widget.onFinished,
    ),
  };
}

class _StepScrollView extends StatelessWidget {
  const _StepScrollView({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
          child: child,
        ),
      ),
    );
  }
}

class _WelcomeStep extends StatelessWidget {
  const _WelcomeStep();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Column(
      key: const Key('onboarding_step_welcome'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Center(child: BrandEmblem(size: AppSizes.onboardingEmblem)),
        const SizedBox(height: AppSpacing.md),
        AppText(
          l10n.appTitle,
          role: AppTextRole.displayMedium,
          color: colors.onSurface,
          textAlign: TextAlign.center,
        ),
        AppText(
          l10n.appSlogan,
          role: AppTextRole.bodyMedium,
          color: colors.onSurfaceVariant,
          textAlign: TextAlign.center,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: DiamondDivider(),
        ),
        OnboardingStepHeader(
          title: l10n.onboardingWelcomeTitle,
          description: l10n.onboardingWelcomeDescription,
          leading: const SizedBox.shrink(),
        ),
        const SizedBox(height: AppSpacing.md),
        const LanguageSetting(),
      ],
    );
  }
}

class _DisplayStep extends StatelessWidget {
  const _DisplayStep();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      key: const Key('onboarding_step_display'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OnboardingStepHeader(
          icon: Icons.contrast,
          title: l10n.onboardingDisplayTitle,
          description: l10n.onboardingDisplayDescription,
        ),
        const SizedBox(height: AppSpacing.sm),
        const ThemeSetting(),
        const SizedBox(height: AppSpacing.lg),
        OnboardingNote(l10n.onboardingChangeLaterNote),
      ],
    );
  }
}

class _AccessibilityStep extends StatelessWidget {
  const _AccessibilityStep({required this.onOpenAccessibility});

  final VoidCallback onOpenAccessibility;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      key: const Key('onboarding_step_accessibility'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OnboardingStepHeader(
          icon: Icons.accessibility_new,
          title: l10n.onboardingAccessibilityTitle,
          description: l10n.onboardingAccessibilityDescription,
        ),
        const SizedBox(height: AppSpacing.md),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: AppButton.secondary(
            key: const Key('onboarding_open_accessibility_button'),
            label: l10n.onboardingAccessibilityOpen,
            icon: Icons.accessibility_new,
            expand: true,
            onPressed: onOpenAccessibility,
          ),
        ),
      ],
    );
  }
}

class _TourStep extends StatelessWidget {
  const _TourStep();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      key: const Key('onboarding_step_tour'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OnboardingStepHeader(
          icon: Icons.explore_outlined,
          title: l10n.onboardingTourTitle,
          description: l10n.onboardingTourDescription,
        ),
        const SizedBox(height: AppSpacing.sm),
        OnboardingFeatureRow(
          icon: Icons.map_outlined,
          title: l10n.onboardingTourMapTitle,
          description: l10n.onboardingTourMapBody,
        ),
        OnboardingFeatureRow(
          icon: Icons.search,
          title: l10n.onboardingTourSearchTitle,
          description: l10n.onboardingTourSearchBody,
        ),
        OnboardingFeatureRow(
          icon: Icons.route_outlined,
          title: l10n.onboardingTourRoutesTitle,
          description: l10n.onboardingTourRoutesBody,
        ),
        OnboardingFeatureRow(
          icon: Icons.volunteer_activism_outlined,
          title: l10n.onboardingTourContributeTitle,
          description: l10n.onboardingTourContributeBody,
        ),
      ],
    );
  }
}

class _PermissionsStep extends StatelessWidget {
  const _PermissionsStep({required this.onOpenPrivacyNotice});

  final VoidCallback onOpenPrivacyNotice;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      key: const Key('onboarding_step_permissions'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OnboardingStepHeader(
          icon: Icons.privacy_tip_outlined,
          title: l10n.onboardingPermissionsTitle,
          description: l10n.onboardingPermissionsDescription,
        ),
        const SizedBox(height: AppSpacing.lg),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: PermissionCardList(),
        ),
        const SizedBox(height: AppSpacing.md),
        OnboardingNote(
          l10n.permissionOnDemandNote,
          icon: Icons.touch_app_outlined,
        ),
        const SizedBox(height: AppSpacing.sm),
        OnboardingNote(l10n.onboardingPermissionsChangeLater),
        const SizedBox(height: AppSpacing.sm),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              key: const Key('onboarding_privacy_notice_button'),
              onPressed: onOpenPrivacyNotice,
              icon: const Icon(Icons.description_outlined),
              label: Text(l10n.onboardingPrivacyNoticeLink),
            ),
          ),
        ),
      ],
    );
  }
}

class _AccountStep extends StatelessWidget {
  const _AccountStep({
    required this.signedInDisplayName,
    required this.onFinished,
  });

  final String? signedInDisplayName;
  final ValueChanged<OnboardingExit> onFinished;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final name = signedInDisplayName;
    final actions = name != null
        ? [
            AppButton.primary(
              key: const Key('onboarding_continue_button'),
              label: l10n.onboardingContinueSignedIn,
              icon: Icons.arrow_forward,
              expand: true,
              onPressed: () => onFinished(OnboardingExit.continueSignedIn),
            ),
          ]
        : [
            AppButton.primary(
              key: const Key('onboarding_sign_in_button'),
              label: l10n.onboardingSignIn,
              icon: Icons.login,
              expand: true,
              onPressed: () => onFinished(OnboardingExit.signIn),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppButton.secondary(
              key: const Key('onboarding_create_account_button'),
              label: l10n.onboardingCreateAccount,
              icon: Icons.person_add_alt,
              expand: true,
              onPressed: () => onFinished(OnboardingExit.createAccount),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppButton.ghost(
              key: const Key('onboarding_guest_button'),
              label: l10n.onboardingContinueAsGuest,
              expand: true,
              onPressed: () => onFinished(OnboardingExit.guest),
            ),
          ];

    return Column(
      key: const Key('onboarding_step_account'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OnboardingStepHeader(
          icon: Icons.account_circle_outlined,
          title: name != null
              ? l10n.onboardingSignedInTitle(name)
              : l10n.onboardingAccountTitle,
          description: name != null
              ? l10n.onboardingSignedInDescription
              : l10n.onboardingAccountDescription,
        ),
        const SizedBox(height: AppSpacing.xl),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: actions,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        OnboardingNote(l10n.onboardingChangeLaterNote),
      ],
    );
  }
}
