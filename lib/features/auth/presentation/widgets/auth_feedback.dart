import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/a11y/haptic_feedback_service.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/l10n/failure_messages.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/form_status.dart';
import 'package:vakif_atlas/features/auth/presentation/cubit/resend_cooldown_cubit.dart';

/// Form sonucunu ekran okuyucuya ve titreşimle bildirir (WCAG 4.1.3).
///
/// - Başarı: [successMessage] kibar duyuru + başarı titreşimi.
/// - Hata: hata mesajı araya giren (assertive) duyuru + hata titreşimi.
/// - Geçersiz form: genel uyarı + uyarı titreşimi.
void announceFormOutcome(
  BuildContext context, {
  required FormStatus status,
  Failure? failure,
  String? successMessage,
}) {
  final l10n = context.l10n;
  final announcer = context.read<A11yAnnouncer>();
  final haptics = context.read<HapticFeedbackService>();

  switch (status) {
    case FormStatus.success:
      if (successMessage != null) {
        unawaited(announcer.announce(successMessage));
      }
      unawaited(haptics.success());
    case FormStatus.failure:
      if (failure != null) {
        unawaited(
          announcer.announce(failure.toUserMessage(l10n), assertive: true),
        );
      }
      unawaited(haptics.error());
    case FormStatus.invalid:
      unawaited(
        announcer.announce(l10n.loginFormInvalidAnnouncement, assertive: true),
      );
      unawaited(haptics.warning());
    case FormStatus.editing || FormStatus.submitting:
      break;
  }
}

/// "Kodu tekrar gönder" sonucunu duyurur ve sunucunun bildirdiği bekleme
/// süresini (`resendAfter` / `retryAfter`) başlatır.
void announceResendOutcome(
  BuildContext context, {
  required bool sent,
  required Duration? cooldown,
  required String? failureMessage,
}) {
  final announcer = context.read<A11yAnnouncer>();
  if (sent) {
    unawaited(announcer.announce(context.l10n.codeResentAnnouncement));
  } else if (failureMessage != null) {
    unawaited(announcer.announce(failureMessage, assertive: true));
  }
  if (cooldown != null) {
    context.read<ResendCooldownCubit>().start(cooldown);
  }
}
