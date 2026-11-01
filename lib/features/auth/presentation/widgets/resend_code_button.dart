import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/features/auth/presentation/cubit/resend_cooldown_cubit.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';

/// Bekleme süresi dolana kadar devre dışı kalan "Kodu tekrar gönder" butonu.
///
/// Kalan süre her saniye ekran okuyucuya okunmaz (gürültü); buton etiketi
/// odaklanıldığında güncel süreyi içerir.
class ResendCodeButton extends StatelessWidget {
  const ResendCodeButton({
    required this.isSending,
    required this.onPressed,
    super.key,
  });

  final bool isSending;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<ResendCooldownCubit, int>(
      builder: (context, remaining) => AppButton.ghost(
        key: const Key('resend_code_button'),
        label: remaining > 0 ? l10n.resendCodeIn(remaining) : l10n.resendCode,
        icon: Icons.refresh,
        isLoading: isSending,
        expand: true,
        onPressed: remaining > 0 ? null : onPressed,
      ),
    );
  }
}
