import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/l10n/failure_messages.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/auth/domain/entities/legal_document.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/form_status.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/register_bloc.dart';
import 'package:vakif_atlas/features/auth/presentation/pending_verification.dart';
import 'package:vakif_atlas/features/auth/presentation/widgets/auth_feedback.dart';
import 'package:vakif_atlas/features/auth/presentation/widgets/consent_tile.dart';
import 'package:vakif_atlas/features/auth/presentation/widgets/new_password_fields.dart';
import 'package:vakif_atlas/features/auth/presentation/widgets/validation_messages.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/molecules/app_text_field.dart';
import 'package:vakif_atlas/shared/widgets/molecules/inline_message.dart';
import 'package:vakif_atlas/shared/widgets/templates/form_page_template.dart';

/// Hesap oluşturma. `RegisterBloc` üst ağaçtan (router) sağlanır.
class RegisterPage extends StatefulWidget {
  const RegisterPage({
    required this.onRegistered,
    required this.onSignIn,
    required this.onOpenLegalDocument,
    super.key,
  });

  /// Doğrulama kodu gönderildiğinde doğrulama ekranına geçilir. Kullanıcı
  /// e-posta adresini düzeltmek için geri dönerse `true` tamamlanır.
  final Future<bool?> Function(PendingVerification) onRegistered;
  final VoidCallback onSignIn;
  final ValueChanged<LegalDocumentType> onOpenLegalDocument;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmationFocus = FocusNode();

  @override
  void dispose() {
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmationFocus.dispose();
    super.dispose();
  }

  void _submit() =>
      context.read<RegisterBloc>().add(const RegisterEvent.submitted());

  void _onStateChanged(BuildContext context, RegisterState state) {
    switch (state.status) {
      case FormStatus.success:
        final challenge = state.challenge;
        if (challenge != null) {
          // Yeni kimlik bilgisinin şifre yöneticisine kaydedilmesi.
          TextInput.finishAutofillContext();
          unawaited(
            _openVerification(
              PendingVerification(
                challenge: challenge,
                password: state.password,
              ),
            ),
          );
        }
      case FormStatus.invalid:
        announceFormOutcome(context, status: FormStatus.invalid);
        _focusFirstInvalid(state);
      case FormStatus.failure:
        announceFormOutcome(
          context,
          status: FormStatus.failure,
          failure: state.failure,
        );
      case FormStatus.editing || FormStatus.submitting:
        break;
    }
  }

  Future<void> _openVerification(PendingVerification pending) async {
    final changeEmail = await widget.onRegistered(pending);
    if (changeEmail ?? false) {
      if (mounted) {
        _emailFocus.requestFocus();
      }
    }
  }

  void _focusFirstInvalid(RegisterState state) {
    if (state.displayNameError != null) {
      _nameFocus.requestFocus();
    } else if (state.emailError != null) {
      _emailFocus.requestFocus();
    } else if (state.passwordError != null) {
      _passwordFocus.requestFocus();
    } else if (state.confirmationError != null) {
      _confirmationFocus.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<RegisterBloc, RegisterState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.invalidSubmissions != current.invalidSubmissions,
      listener: _onStateChanged,
      builder: (context, state) {
        final bloc = context.read<RegisterBloc>();
        final show = state.showValidationErrors;
        final enabled = !state.isSubmitting;
        final failure = state.failure;

        return Scaffold(
          appBar: AppBar(title: Text(l10n.registerTitle)),
          body: FormPageTemplate(
            children: [
              AppText(
                l10n.registerHeading,
                role: AppTextRole.headlineLarge,
                isHeading: true,
              ),
              const SizedBox(height: AppSpacing.xs),
              AppText(
                l10n.registerSubtitle,
                color: context.colors.onSurfaceVariant,
              ),
              const SizedBox(height: AppSpacing.lg),
              if (state.status == FormStatus.failure && failure != null) ...[
                InlineMessage(
                  key: const Key('register_failure_message'),
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
                      key: const Key('register_name_field'),
                      focusNode: _nameFocus,
                      label: l10n.registerNameLabel,
                      errorText: show
                          ? l10n.displayNameError(state.displayNameError)
                          : null,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.name],
                      enabled: enabled,
                      onChanged: (value) =>
                          bloc.add(RegisterEvent.displayNameChanged(value)),
                      onSubmitted: (_) => _emailFocus.requestFocus(),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      key: const Key('register_email_field'),
                      focusNode: _emailFocus,
                      label: l10n.loginEmailLabel,
                      hint: l10n.loginEmailHint,
                      errorText: show
                          ? l10n.emailError(state.emailError)
                          : null,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [
                        AutofillHints.email,
                        AutofillHints.username,
                      ],
                      enabled: enabled,
                      onChanged: (value) =>
                          bloc.add(RegisterEvent.emailChanged(value)),
                      onSubmitted: (_) => _passwordFocus.requestFocus(),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    NewPasswordFields(
                      keyPrefix: 'register_password',
                      password: state.password,
                      strength: state.strength,
                      passwordLabel: l10n.loginPasswordLabel,
                      confirmLabel: l10n.registerConfirmPasswordLabel,
                      passwordError: show ? state.passwordError : null,
                      confirmationError: show ? state.confirmationError : null,
                      passwordFocus: _passwordFocus,
                      confirmationFocus: _confirmationFocus,
                      enabled: enabled,
                      onPasswordChanged: (value) =>
                          bloc.add(RegisterEvent.passwordChanged(value)),
                      onConfirmationChanged: (value) =>
                          bloc.add(RegisterEvent.confirmationChanged(value)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              ConsentTile(
                key: const ValueKey('register_terms'),
                value: state.acceptedTerms,
                label: l10n.registerAcceptTerms,
                readLabel: l10n.registerReadTerms,
                enabled: enabled,
                errorText: show && !state.acceptedTerms
                    ? l10n.validationTermsRequired
                    : null,
                onChanged: (accepted) =>
                    bloc.add(RegisterEvent.termsChanged(accepted: accepted)),
                onRead: () =>
                    widget.onOpenLegalDocument(LegalDocumentType.termsOfUse),
              ),
              ConsentTile(
                key: const ValueKey('register_privacy'),
                value: state.acknowledgedPrivacyNotice,
                label: l10n.registerAcknowledgePrivacy,
                readLabel: l10n.registerReadPrivacy,
                enabled: enabled,
                errorText: show && !state.acknowledgedPrivacyNotice
                    ? l10n.validationPrivacyRequired
                    : null,
                onChanged: (acknowledged) => bloc.add(
                  RegisterEvent.privacyNoticeChanged(
                    acknowledged: acknowledged,
                  ),
                ),
                onRead: () =>
                    widget.onOpenLegalDocument(LegalDocumentType.privacyNotice),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton.primary(
                key: const Key('register_submit_button'),
                label: l10n.registerSubmit,
                icon: Icons.person_add_alt_1_outlined,
                isLoading: state.isSubmitting,
                expand: true,
                onPressed: _submit,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppButton.ghost(
                key: const Key('register_sign_in_button'),
                label: l10n.registerHaveAccount,
                expand: true,
                onPressed: enabled ? widget.onSignIn : null,
              ),
            ],
          ),
        );
      },
    );
  }
}
