import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/l10n/failure_messages.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/login_bloc.dart';
import 'package:vakif_atlas/features/auth/presentation/widgets/validation_messages.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/atoms/diamond_divider.dart';
import 'package:vakif_atlas/shared/widgets/molecules/app_text_field.dart';
import 'package:vakif_atlas/shared/widgets/molecules/inline_message.dart';

/// E-posta / şifre formu.
///
/// Geçersiz gönderimde odak ilk hatalı alana taşınır (WCAG 3.3.1) ve hata
/// mesajları nasıl düzeltileceğini söyler (WCAG 3.3.3).
class LoginForm extends StatefulWidget {
  const LoginForm({
    required this.onContinueAsGuest,
    required this.onForgotPassword,
    required this.onCreateAccount,
    super.key,
  });

  final VoidCallback onContinueAsGuest;
  final VoidCallback onForgotPassword;
  final VoidCallback onCreateAccount;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _submit() {
    context.read<LoginBloc>().add(const LoginEvent.submitted());
  }

  void _focusFirstInvalidField(BuildContext context, LoginState state) {
    if (state.emailError != null) {
      _emailFocus.requestFocus();
    } else if (state.passwordError != null) {
      _passwordFocus.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<LoginBloc, LoginState>(
      listenWhen: (previous, current) =>
          previous.invalidSubmissions != current.invalidSubmissions,
      listener: _focusFirstInvalidField,
      builder: (context, state) {
        final bloc = context.read<LoginBloc>();
        final failure = state.failure;
        final showErrors = state.showValidationErrors;

        return AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (state.status == LoginStatus.failure && failure != null) ...[
                InlineMessage(
                  key: const Key('login_failure_message'),
                  type: InlineMessageType.error,
                  message: failure.toUserMessage(l10n),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              AppTextField(
                key: const Key('login_email_field'),
                focusNode: _emailFocus,
                label: l10n.loginEmailLabel,
                hint: l10n.loginEmailHint,
                errorText: showErrors
                    ? l10n.emailError(state.emailError)
                    : null,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                enabled: !state.isSubmitting,
                onChanged: (value) => bloc.add(LoginEvent.emailChanged(value)),
                onSubmitted: (_) => _passwordFocus.requestFocus(),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                key: const Key('login_password_field'),
                focusNode: _passwordFocus,
                label: l10n.loginPasswordLabel,
                errorText: showErrors
                    ? l10n.loginPasswordError(state.passwordError)
                    : null,
                isPassword: true,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                enabled: !state.isSubmitting,
                onChanged: (value) =>
                    bloc.add(LoginEvent.passwordChanged(value)),
                onSubmitted: (_) => _submit(),
              ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  key: const Key('login_forgot_password_button'),
                  onPressed: state.isSubmitting
                      ? null
                      : widget.onForgotPassword,
                  child: Text(l10n.loginForgotPassword),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppButton.primary(
                key: const Key('login_submit_button'),
                label: l10n.loginSubmit,
                icon: Icons.login,
                isLoading: state.isSubmitting,
                expand: true,
                onPressed: _submit,
              ),
              const SizedBox(height: AppSpacing.sm),
              const SizedBox(height: AppSpacing.md),
              const DiamondDivider(),
              const SizedBox(height: AppSpacing.xs),
              AppText(l10n.loginNoAccount, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.xs),
              AppButton.secondary(
                key: const Key('login_create_account_button'),
                label: l10n.loginCreateAccount,
                icon: Icons.person_add_alt_1_outlined,
                expand: true,
                onPressed: state.isSubmitting ? null : widget.onCreateAccount,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppButton.ghost(
                key: const Key('login_continue_as_guest_button'),
                label: l10n.loginContinueAsGuest,
                expand: true,
                onPressed: state.isSubmitting ? null : widget.onContinueAsGuest,
              ),
            ],
          ),
        );
      },
    );
  }
}
