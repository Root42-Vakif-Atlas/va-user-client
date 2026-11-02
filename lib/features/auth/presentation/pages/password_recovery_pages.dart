import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/l10n/failure_messages.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/auth/domain/entities/verification_challenge.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/account_blocs.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/form_status.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/verification_bloc.dart';
import 'package:vakif_atlas/features/auth/presentation/widgets/auth_feedback.dart';
import 'package:vakif_atlas/features/auth/presentation/widgets/new_password_fields.dart';
import 'package:vakif_atlas/features/auth/presentation/widgets/resend_code_button.dart';
import 'package:vakif_atlas/features/auth/presentation/widgets/validation_messages.dart';
import 'package:vakif_atlas/features/auth/presentation/widgets/verification_code_field.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/molecules/app_text_field.dart';
import 'package:vakif_atlas/shared/widgets/molecules/inline_message.dart';
import 'package:vakif_atlas/shared/widgets/templates/form_page_template.dart';

/// Şifremi unuttum: e-posta adresine sıfırlama kodu ister.
///
/// Yanıt, hesabın var olup olmadığını açığa vurmaz; kullanıcı her durumda
/// kod girme ekranına yönlendirilir.
class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({
    required this.onCodeSent,
    required this.onBackToLogin,
    super.key,
  });

  final ValueChanged<VerificationChallenge> onCodeSent;
  final VoidCallback onBackToLogin;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.invalidSubmissions != current.invalidSubmissions,
      listener: (context, state) {
        final challenge = state.challenge;
        if (state.status == FormStatus.success && challenge != null) {
          onCodeSent(challenge);
        } else {
          announceFormOutcome(
            context,
            status: state.status,
            failure: state.failure,
          );
        }
      },
      builder: (context, state) {
        final bloc = context.read<ForgotPasswordBloc>();
        void submit() => bloc.add(const ForgotPasswordEvent.submitted());
        final failure = state.failure;

        return Scaffold(
          appBar: AppBar(title: Text(l10n.forgotPasswordTitle)),
          body: FormPageTemplate(
            children: [
              AppText(
                l10n.forgotPasswordHeading,
                role: AppTextRole.headlineLarge,
                isHeading: true,
              ),
              const SizedBox(height: AppSpacing.xs),
              AppText(
                l10n.forgotPasswordBody,
                color: context.colors.onSurfaceVariant,
              ),
              const SizedBox(height: AppSpacing.lg),
              if (state.status == FormStatus.failure && failure != null) ...[
                InlineMessage(
                  key: const Key('forgot_failure_message'),
                  type: InlineMessageType.error,
                  message: failure.toUserMessage(l10n),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              AppTextField(
                key: const Key('forgot_email_field'),
                label: l10n.loginEmailLabel,
                hint: l10n.loginEmailHint,
                errorText: state.showValidationErrors
                    ? l10n.emailError(state.emailError)
                    : null,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.email],
                enabled: !state.isSubmitting,
                onChanged: (value) =>
                    bloc.add(ForgotPasswordEvent.emailChanged(value)),
                onSubmitted: (_) => submit(),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton.primary(
                key: const Key('forgot_submit_button'),
                label: l10n.forgotPasswordSubmit,
                icon: Icons.mail_outlined,
                isLoading: state.isSubmitting,
                expand: true,
                onPressed: submit,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppButton.ghost(
                label: l10n.backToLogin,
                expand: true,
                onPressed: state.isSubmitting ? null : onBackToLogin,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Kod + yeni şifre ile şifre sıfırlama. Başarıda tüm oturumlar kapanır.
class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({required this.onPasswordReset, super.key});

  final VoidCallback onPasswordReset;

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final FocusNode _codeFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmationFocus = FocusNode();

  @override
  void dispose() {
    _codeFocus.dispose();
    _passwordFocus.dispose();
    _confirmationFocus.dispose();
    super.dispose();
  }

  void _onStateChanged(BuildContext context, ResetPasswordState state) {
    if (state.status == FormStatus.success) {
      TextInput.finishAutofillContext();
      widget.onPasswordReset();
      return;
    }
    announceFormOutcome(context, status: state.status, failure: state.failure);
    if (state.status == FormStatus.invalid) {
      if (state.codeError != null) {
        _codeFocus.requestFocus();
      } else if (state.passwordError != null) {
        _passwordFocus.requestFocus();
      } else {
        _confirmationFocus.requestFocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return MultiBlocListener(
      listeners: [
        BlocListener<ResetPasswordBloc, ResetPasswordState>(
          listenWhen: (previous, current) =>
              previous.status != current.status ||
              previous.invalidSubmissions != current.invalidSubmissions,
          listener: _onStateChanged,
        ),
        BlocListener<ResetPasswordBloc, ResetPasswordState>(
          listenWhen: (previous, current) =>
              previous.resendAttempts != current.resendAttempts,
          listener: (context, state) => announceResendOutcome(
            context,
            sent: state.resendStatus == ResendStatus.sent,
            cooldown: state.cooldown,
            failureMessage: state.failure?.toUserMessage(l10n),
          ),
        ),
      ],
      child: BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
        builder: (context, state) {
          final bloc = context.read<ResetPasswordBloc>();
          void submit() => bloc.add(const ResetPasswordEvent.submitted());
          final show = state.showValidationErrors;
          final enabled = !state.isSubmitting;
          final failure = state.failure;

          return Scaffold(
            appBar: AppBar(title: Text(l10n.resetPasswordTitle)),
            body: FormPageTemplate(
              children: [
                AppText(
                  l10n.forgotPasswordHeading,
                  role: AppTextRole.headlineLarge,
                  isHeading: true,
                ),
                const SizedBox(height: AppSpacing.xs),
                AppText(
                  l10n.resetPasswordBody(state.email),
                  color: context.colors.onSurfaceVariant,
                ),
                const SizedBox(height: AppSpacing.lg),
                if (state.status == FormStatus.failure && failure != null) ...[
                  InlineMessage(
                    key: const Key('reset_failure_message'),
                    type: InlineMessageType.error,
                    message: failure.toUserMessage(l10n),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      VerificationCodeField(
                        focusNode: _codeFocus,
                        error: show ? state.codeError : null,
                        enabled: enabled,
                        onChanged: (value) =>
                            bloc.add(ResetPasswordEvent.codeChanged(value)),
                        onSubmitted: _passwordFocus.requestFocus,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      NewPasswordFields(
                        keyPrefix: 'reset_password',
                        password: state.password,
                        strength: state.strength,
                        passwordLabel: l10n.newPasswordLabel,
                        confirmLabel: l10n.confirmNewPasswordLabel,
                        passwordError: show ? state.passwordError : null,
                        confirmationError: show
                            ? state.confirmationError
                            : null,
                        passwordFocus: _passwordFocus,
                        confirmationFocus: _confirmationFocus,
                        enabled: enabled,
                        onPasswordChanged: (value) =>
                            bloc.add(ResetPasswordEvent.passwordChanged(value)),
                        onConfirmationChanged: (value) => bloc.add(
                          ResetPasswordEvent.confirmationChanged(value),
                        ),
                        onSubmitted: submit,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton.primary(
                  key: const Key('reset_submit_button'),
                  label: l10n.resetPasswordSubmit,
                  icon: Icons.lock_reset,
                  isLoading: state.isSubmitting,
                  expand: true,
                  onPressed: submit,
                ),
                const SizedBox(height: AppSpacing.sm),
                ResendCodeButton(
                  isSending: state.resendStatus == ResendStatus.sending,
                  onPressed: () =>
                      bloc.add(const ResetPasswordEvent.resendRequested()),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
