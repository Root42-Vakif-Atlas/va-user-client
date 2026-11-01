import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/auth/domain/entities/verification_challenge.dart';
import 'package:vakif_atlas/features/auth/domain/validation/credentials_validator.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/form_status.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/login_bloc.dart';
import 'package:vakif_atlas/features/auth/presentation/pending_verification.dart';
import 'package:vakif_atlas/features/auth/presentation/widgets/auth_feedback.dart';
import 'package:vakif_atlas/features/auth/presentation/widgets/login_form.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/atoms/diamond_divider.dart';
import 'package:vakif_atlas/shared/widgets/molecules/inline_message.dart';
import 'package:vakif_atlas/shared/widgets/templates/form_page_template.dart';

/// Giriş ekranı. `LoginBloc` üst ağaçtan (router) sağlanır.
///
/// Başarılı girişte yönlendirme `AuthGuard` tarafından yapılır; bu sayfa
/// yalnızca sonucu ekran okuyucuya ve titreşimle bildirir.
class LoginPage extends StatelessWidget {
  const LoginPage({
    required this.onContinueAsGuest,
    required this.onForgotPassword,
    required this.onCreateAccount,
    required this.onVerificationRequired,
    this.showLoginRequiredNotice = false,
    this.showPasswordResetNotice = false,
    super.key,
  });

  final VoidCallback onContinueAsGuest;
  final VoidCallback onForgotPassword;
  final VoidCallback onCreateAccount;

  /// Şifre doğru ancak e-posta doğrulanmamışsa doğrulama ekranına geçilir.
  final ValueChanged<PendingVerification> onVerificationRequired;

  /// Kullanıcı korumalı bir rotadan yönlendirildiyse `true`.
  final bool showLoginRequiredNotice;

  /// Şifre sıfırlama tamamlandıktan sonra gelindiyse `true`.
  final bool showPasswordResetNotice;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.invalidSubmissions != current.invalidSubmissions,
      listener: _onStateChanged,
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.loginTitle)),
        body: FormPageTemplate(
          children: [
            const _BrandHeader(),
            const SizedBox(height: AppSpacing.lg),
            if (showPasswordResetNotice) ...[
              InlineMessage(
                key: const Key('login_password_reset_notice'),
                type: InlineMessageType.success,
                message: l10n.loginPasswordResetSuccess,
              ),
              const SizedBox(height: AppSpacing.md),
            ] else if (showLoginRequiredNotice) ...[
              InlineMessage(message: l10n.loginRequiredNotice),
              const SizedBox(height: AppSpacing.md),
            ],
            LoginForm(
              onContinueAsGuest: onContinueAsGuest,
              onForgotPassword: onForgotPassword,
              onCreateAccount: onCreateAccount,
            ),
          ],
        ),
      ),
    );
  }

  void _onStateChanged(BuildContext context, LoginState state) {
    final l10n = context.l10n;
    switch (state.status) {
      case LoginStatus.success:
        // Kimlik bilgilerinin işletim sistemi şifre yöneticisine kaydedilmesi.
        TextInput.finishAutofillContext();
        announceFormOutcome(
          context,
          status: FormStatus.success,
          successMessage: l10n.loginSuccessAnnouncement(
            state.user?.displayName ?? '',
          ),
        );
      case LoginStatus.failure:
        announceFormOutcome(
          context,
          status: FormStatus.failure,
          failure: state.failure,
        );
      case LoginStatus.invalid:
        announceFormOutcome(context, status: FormStatus.invalid);
      case LoginStatus.verificationRequired:
        // Giriş yeni kod gönderdiyse sunucu bekleme süresini bildirir;
        // sayaç onunla başlar (aksi halde ilk "tekrar gönder" 429 alırdı).
        final failure = state.failure;
        onVerificationRequired(
          PendingVerification(
            challenge: VerificationChallenge(
              email: CredentialsValidator.normalizeEmail(state.email),
              resendAfter: failure is AuthFailure
                  ? failure.retryAfter ?? Duration.zero
                  : Duration.zero,
            ),
            password: state.password,
          ),
        );
      case LoginStatus.editing || LoginStatus.submitting:
        break;
    }
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
        const SizedBox(height: AppSpacing.sm),
        const DiamondDivider(),
        const SizedBox(height: AppSpacing.sm),
        AppText(
          l10n.loginHeading,
          role: AppTextRole.headlineLarge,
          isHeading: true,
        ),
        const SizedBox(height: AppSpacing.xs),
        AppText(l10n.loginSubtitle, color: colors.onSurfaceVariant),
      ],
    );
  }
}
