import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/l10n/failure_messages.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/form_status.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/verification_bloc.dart';
import 'package:vakif_atlas/features/auth/presentation/widgets/auth_feedback.dart';
import 'package:vakif_atlas/features/auth/presentation/widgets/resend_code_button.dart';
import 'package:vakif_atlas/features/auth/presentation/widgets/verification_code_field.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/molecules/inline_message.dart';
import 'package:vakif_atlas/shared/widgets/templates/form_page_template.dart';

/// E-posta doğrulama. `VerifyEmailBloc` ve `ResendCooldownCubit` üst
/// ağaçtan sağlanır. Başarılı doğrulamada oturum açılır ve yönlendirmeyi
/// `AuthGuard` yapar.
class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({required this.onChangeEmail, super.key});

  /// Yanlış yazılan adresi düzeltmek için önceki forma (kayıt / giriş)
  /// girilen bilgiler korunarak dönülür.
  final VoidCallback onChangeEmail;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return MultiBlocListener(
      listeners: [
        BlocListener<VerifyEmailBloc, VerifyEmailState>(
          listenWhen: (previous, current) =>
              previous.status != current.status ||
              previous.invalidSubmissions != current.invalidSubmissions,
          listener: (context, state) => announceFormOutcome(
            context,
            status: state.status,
            failure: state.failure,
            successMessage: l10n.emailVerifiedAnnouncement(
              state.user?.displayName ?? '',
            ),
          ),
        ),
        BlocListener<VerifyEmailBloc, VerifyEmailState>(
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
      child: BlocBuilder<VerifyEmailBloc, VerifyEmailState>(
        builder: (context, state) {
          final bloc = context.read<VerifyEmailBloc>();
          void submit() => bloc.add(const VerifyEmailEvent.submitted());
          final failure = state.failure;

          return Scaffold(
            appBar: AppBar(title: Text(l10n.verifyEmailTitle)),
            body: FormPageTemplate(
              children: [
                AppText(
                  l10n.verifyEmailHeading,
                  role: AppTextRole.headlineLarge,
                  isHeading: true,
                ),
                const SizedBox(height: AppSpacing.xs),
                AppText(
                  l10n.verifyEmailBody(state.email),
                  color: context.colors.onSurfaceVariant,
                ),
                const SizedBox(height: AppSpacing.xs),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: AppButton.ghost(
                    key: const Key('verify_change_email_button'),
                    label: l10n.verifyEmailChangeEmail,
                    icon: Icons.edit_outlined,
                    onPressed: state.isSubmitting ? null : onChangeEmail,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                if (state.status == FormStatus.failure && failure != null) ...[
                  InlineMessage(
                    key: const Key('verify_failure_message'),
                    type: InlineMessageType.error,
                    message: failure.toUserMessage(l10n),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                VerificationCodeField(
                  error: state.showValidationErrors ? state.codeError : null,
                  enabled: !state.isSubmitting,
                  onChanged: (value) =>
                      bloc.add(VerifyEmailEvent.codeChanged(value)),
                  onSubmitted: submit,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton.primary(
                  key: const Key('verify_submit_button'),
                  label: l10n.verifyEmailSubmit,
                  icon: Icons.verified_outlined,
                  isLoading: state.isSubmitting,
                  expand: true,
                  onPressed: submit,
                ),
                const SizedBox(height: AppSpacing.sm),
                ResendCodeButton(
                  isSending: state.resendStatus == ResendStatus.sending,
                  onPressed: () =>
                      bloc.add(const VerifyEmailEvent.resendRequested()),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
