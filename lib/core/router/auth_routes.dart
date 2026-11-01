import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vakif_atlas/core/di/injection.dart';
import 'package:vakif_atlas/core/router/routes.dart';
import 'package:vakif_atlas/core/router/transitions/app_transition_pages.dart';
import 'package:vakif_atlas/features/auth/domain/entities/legal_document.dart';
import 'package:vakif_atlas/features/auth/domain/entities/verification_challenge.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/account_blocs.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/login_bloc.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/register_bloc.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/verification_bloc.dart';
import 'package:vakif_atlas/features/auth/presentation/cubit/resend_cooldown_cubit.dart';
import 'package:vakif_atlas/features/auth/presentation/pending_verification.dart';
import 'package:vakif_atlas/features/auth/presentation/pages/account_security_pages.dart';
import 'package:vakif_atlas/features/auth/presentation/pages/legal_document_page.dart';
import 'package:vakif_atlas/features/auth/presentation/pages/login_page.dart';
import 'package:vakif_atlas/features/auth/presentation/pages/password_recovery_pages.dart';
import 'package:vakif_atlas/features/auth/presentation/pages/register_page.dart';
import 'package:vakif_atlas/features/auth/presentation/pages/verify_email_page.dart';
import 'package:vakif_atlas/shared/widgets/templates/not_found_page.dart';

/// Oturum açma, kayıt, doğrulama, şifre kurtarma ve yasal metin rotaları.
///
/// E-posta adresi URL'de değil `extra` ile taşınır; böylece kişisel veri
/// router loglarına, derin bağlantılara ve analitiğe sızmaz. `extra`
/// olmadan açılan doğrulama/sıfırlama ekranları akışın başına yönlendirilir.
List<RouteBase> authRoutes() {
  return [
    GoRoute(
      path: AppRoutes.login,
      name: AppRouteNames.login,
      pageBuilder: (context, state) => fadePage(
        context,
        state,
        BlocProvider<LoginBloc>(
          create: (_) => getIt<LoginBloc>(),
          child: LoginPage(
            showLoginRequiredNotice: state.uri.queryParameters.containsKey(
              AppRoutes.fromParameter,
            ),
            showPasswordResetNotice: state.uri.queryParameters.containsKey(
              AppRoutes.passwordResetParameter,
            ),
            onContinueAsGuest: () => context.go(AppRoutes.mapDiscovery),
            onForgotPassword: () => context.push(AppRoutes.forgotPassword),
            onCreateAccount: () => context.push(AppRoutes.register),
            onVerificationRequired: (pending) =>
                context.push(AppRoutes.verifyEmail, extra: pending),
          ),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.register,
      name: AppRouteNames.register,
      pageBuilder: (context, state) => slidePage(
        context,
        state,
        BlocProvider<RegisterBloc>(
          create: (_) => getIt<RegisterBloc>(),
          child: RegisterPage(
            // `push`: geri dönüşte form (yanlış yazılan e-posta) korunur.
            onRegistered: (pending) =>
                context.push<bool>(AppRoutes.verifyEmail, extra: pending),
            onSignIn: () => _backOr(context, AppRoutes.login),
            onOpenLegalDocument: (type) =>
                context.push(AppRoutes.legalDocumentPath(type.slug)),
          ),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.verifyEmail,
      name: AppRouteNames.verifyEmail,
      redirect: (context, state) =>
          state.extra is PendingVerification ? null : AppRoutes.register,
      pageBuilder: (context, state) {
        final pending = state.extra! as PendingVerification;
        final challenge = pending.challenge;
        return slidePage(
          context,
          state,
          MultiBlocProvider(
            providers: [
              BlocProvider<VerifyEmailBloc>(
                create: (_) => getIt<VerifyEmailBloc>(param1: pending),
              ),
              BlocProvider<ResendCooldownCubit>(
                create: (_) =>
                    getIt<ResendCooldownCubit>()..start(challenge.resendAfter),
              ),
            ],
            child: VerifyEmailPage(
              onChangeEmail: () => context.canPop()
                  ? context.pop(true)
                  : context.go(AppRoutes.register),
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      name: AppRouteNames.forgotPassword,
      pageBuilder: (context, state) => slidePage(
        context,
        state,
        BlocProvider<ForgotPasswordBloc>(
          create: (_) => getIt<ForgotPasswordBloc>(),
          child: ForgotPasswordPage(
            onCodeSent: (challenge) => context.pushReplacement(
              AppRoutes.resetPassword,
              extra: challenge,
            ),
            onBackToLogin: () => _backOr(context, AppRoutes.login),
          ),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.resetPassword,
      name: AppRouteNames.resetPassword,
      redirect: (context, state) => state.extra is VerificationChallenge
          ? null
          : AppRoutes.forgotPassword,
      pageBuilder: (context, state) {
        final challenge = state.extra! as VerificationChallenge;
        return slidePage(
          context,
          state,
          MultiBlocProvider(
            providers: [
              BlocProvider<ResetPasswordBloc>(
                create: (_) => getIt<ResetPasswordBloc>(param1: challenge),
              ),
              BlocProvider<ResendCooldownCubit>(
                create: (_) =>
                    getIt<ResendCooldownCubit>()..start(challenge.resendAfter),
              ),
            ],
            child: ResetPasswordPage(
              onPasswordReset: () =>
                  context.go(AppRoutes.loginAfterPasswordReset()),
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.legalDocument,
      name: AppRouteNames.legalDocument,
      pageBuilder: (context, state) {
        final type = LegalDocumentType.fromSlug(
          state.pathParameters['document'],
        );
        return slidePage(
          context,
          state,
          type == null
              ? NotFoundPage(onGoHome: () => context.go(AppRoutes.mapDiscovery))
              : BlocProvider<LegalDocumentCubit>(
                  create: (_) => getIt<LegalDocumentCubit>(),
                  child: LegalDocumentPage(type: type),
                ),
        );
      },
    ),
  ];
}

/// Profil altındaki, oturum gerektiren hesap güvenliği rotaları.
List<RouteBase> accountRoutes({
  required GlobalKey<NavigatorState> rootNavigatorKey,
  required AuthBloc authBloc,
}) {
  return [
    GoRoute(
      path: 'change-password',
      name: AppRouteNames.changePassword,
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) => slidePage(
        context,
        state,
        BlocProvider<ChangePasswordBloc>(
          create: (_) => getIt<ChangePasswordBloc>(
            param1: switch (authBloc.state) {
              AuthAuthenticated(:final user) => user,
              AuthUnknown() || AuthGuest() => null,
            },
          ),
          child: ChangePasswordPage(
            onChanged: () => _backOr(context, AppRoutes.profile),
          ),
        ),
      ),
    ),
    GoRoute(
      path: 'delete-account',
      name: AppRouteNames.deleteAccount,
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) => slidePage(
        context,
        state,
        BlocProvider<DeleteAccountBloc>(
          create: (_) => getIt<DeleteAccountBloc>(),
          child: DeleteAccountPage(
            onDeleted: () => context.go(AppRoutes.mapDiscovery),
          ),
        ),
      ),
    ),
  ];
}

void _backOr(BuildContext context, String fallback) {
  if (context.canPop()) {
    context.pop();
  } else {
    context.go(fallback);
  }
}
