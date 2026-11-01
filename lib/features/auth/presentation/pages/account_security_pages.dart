import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/l10n/failure_messages.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/account_blocs.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/form_status.dart';
import 'package:vakif_atlas/features/auth/presentation/widgets/auth_feedback.dart';
import 'package:vakif_atlas/features/auth/presentation/widgets/new_password_fields.dart';
import 'package:vakif_atlas/features/auth/presentation/widgets/validation_messages.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/molecules/app_text_field.dart';
import 'package:vakif_atlas/shared/widgets/molecules/inline_message.dart';
import 'package:vakif_atlas/shared/widgets/templates/form_page_template.dart';

/// Oturum açık kullanıcının şifre değiştirmesi.
class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({required this.onChanged, super.key});

  final VoidCallback onChanged;

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final FocusNode _currentFocus = FocusNode();
  final FocusNode _newFocus = FocusNode();
  final FocusNode _confirmationFocus = FocusNode();

  @override
  void dispose() {
    _currentFocus.dispose();
    _newFocus.dispose();
    _confirmationFocus.dispose();
    super.dispose();
  }

  void _onStateChanged(BuildContext context, ChangePasswordState state) {
    announceFormOutcome(
      context,
      status: state.status,
      failure: state.failure,
      successMessage: context.l10n.changePasswordSuccess,
    );
    switch (state.status) {
      case FormStatus.success:
        TextInput.finishAutofillContext();
        widget.onChanged();
      case FormStatus.invalid:
        if (state.currentPasswordError != null) {
          _currentFocus.requestFocus();
        } else if (state.newPasswordError != null || state.isSameAsCurrent) {
          _newFocus.requestFocus();
        } else {
          _confirmationFocus.requestFocus();
        }
      case FormStatus.editing || FormStatus.submitting || FormStatus.failure:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.invalidSubmissions != current.invalidSubmissions,
      listener: _onStateChanged,
      builder: (context, state) {
        final bloc = context.read<ChangePasswordBloc>();
        void submit() => bloc.add(const ChangePasswordEvent.submitted());
        final show = state.showValidationErrors;
        final enabled = !state.isSubmitting;
        final failure = state.failure;

        return Scaffold(
          appBar: AppBar(title: Text(l10n.changePasswordTitle)),
          body: FormPageTemplate(
            children: [
              if (state.status == FormStatus.failure && failure != null) ...[
                InlineMessage(
                  key: const Key('change_password_failure_message'),
                  type: InlineMessageType.error,
                  message: failure.toUserMessage(l10n),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextField(
                      key: const Key('change_password_current_field'),
                      focusNode: _currentFocus,
                      label: l10n.currentPasswordLabel,
                      errorText: show && state.currentPasswordError != null
                          ? l10n.validationCurrentPasswordEmpty
                          : null,
                      isPassword: true,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.password],
                      enabled: enabled,
                      onChanged: (value) => bloc.add(
                        ChangePasswordEvent.currentPasswordChanged(value),
                      ),
                      onSubmitted: (_) => _newFocus.requestFocus(),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    NewPasswordFields(
                      keyPrefix: 'change_password_new',
                      password: state.newPassword,
                      strength: state.strength,
                      passwordLabel: l10n.newPasswordLabel,
                      confirmLabel: l10n.confirmNewPasswordLabel,
                      passwordError: show ? state.newPasswordError : null,
                      confirmationError: show ? state.confirmationError : null,
                      passwordFocus: _newFocus,
                      confirmationFocus: _confirmationFocus,
                      enabled: enabled,
                      onPasswordChanged: (value) => bloc.add(
                        ChangePasswordEvent.newPasswordChanged(value),
                      ),
                      onConfirmationChanged: (value) => bloc.add(
                        ChangePasswordEvent.confirmationChanged(value),
                      ),
                      onSubmitted: submit,
                    ),
                    if (show &&
                        state.newPasswordError == null &&
                        state.isSameAsCurrent) ...[
                      const SizedBox(height: AppSpacing.xs),
                      InlineMessage(
                        type: InlineMessageType.error,
                        message: l10n.validationSamePassword,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton.primary(
                key: const Key('change_password_submit_button'),
                label: l10n.changePasswordSubmit,
                icon: Icons.password,
                isLoading: state.isSubmitting,
                expand: true,
                onPressed: submit,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Hesabın kalıcı olarak silinmesi (App Store 5.1.1(v), KVKK md. 7/11).
///
/// Kimlik yeniden doğrulaması (şifre) ve açık onay ister; işlem destructive
/// buton stiliyle ayrıştırılır.
class DeleteAccountPage extends StatelessWidget {
  const DeleteAccountPage({required this.onDeleted, super.key});

  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<DeleteAccountBloc, DeleteAccountState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.invalidSubmissions != current.invalidSubmissions,
      listener: (context, state) {
        announceFormOutcome(
          context,
          status: state.status,
          failure: state.failure,
          successMessage: l10n.accountDeletedAnnouncement,
        );
        if (state.status == FormStatus.success) {
          onDeleted();
        }
      },
      builder: (context, state) {
        final bloc = context.read<DeleteAccountBloc>();
        final show = state.showValidationErrors;
        final enabled = !state.isSubmitting;
        final failure = state.failure;

        return Scaffold(
          appBar: AppBar(title: Text(l10n.deleteAccountTitle)),
          body: FormPageTemplate(
            children: [
              AppText(
                l10n.deleteAccountHeading,
                role: AppTextRole.headlineMedium,
                isHeading: true,
              ),
              const SizedBox(height: AppSpacing.md),
              InlineMessage(
                type: InlineMessageType.warning,
                message: l10n.deleteAccountBody,
              ),
              const SizedBox(height: AppSpacing.lg),
              if (state.status == FormStatus.failure && failure != null) ...[
                InlineMessage(
                  key: const Key('delete_account_failure_message'),
                  type: InlineMessageType.error,
                  message: failure.toUserMessage(l10n),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              AppTextField(
                key: const Key('delete_account_password_field'),
                label: l10n.currentPasswordLabel,
                errorText: show
                    ? l10n.loginPasswordError(state.passwordError)
                    : null,
                isPassword: true,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                enabled: enabled,
                onChanged: (value) =>
                    bloc.add(DeleteAccountEvent.passwordChanged(value)),
              ),
              const SizedBox(height: AppSpacing.sm),
              CheckboxListTile(
                key: const Key('delete_account_confirm_checkbox'),
                value: state.confirmed,
                enabled: enabled,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(l10n.deleteAccountConfirm),
                subtitle: show && !state.confirmed
                    ? AppText(
                        l10n.validationDeleteConfirmRequired,
                        role: AppTextRole.bodySmall,
                        color: context.colors.error,
                      )
                    : null,
                onChanged: (checked) => bloc.add(
                  DeleteAccountEvent.confirmationChanged(
                    confirmed: checked ?? false,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton.destructive(
                key: const Key('delete_account_submit_button'),
                label: l10n.deleteAccountSubmit,
                icon: Icons.delete_forever_outlined,
                isLoading: state.isSubmitting,
                expand: true,
                onPressed: () => bloc.add(const DeleteAccountEvent.submitted()),
              ),
            ],
          ),
        );
      },
    );
  }
}
