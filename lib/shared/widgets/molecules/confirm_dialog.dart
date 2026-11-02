import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/a11y/reduce_motion.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';

/// Uygulamanın tek onay diyaloğu: vazgeçme solda (vurgusuz), onay sağda.
///
/// [destructive] iken onay butonu hata renginde dolgulu olur (silme, çıkış,
/// taslağı atma). Diyalog kapatılırsa (geri, dışarı dokunma) sonuç `false`.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String body,
  required String confirmLabel,
  required String cancelLabel,
  Key? confirmKey,
  Key? cancelKey,
  bool destructive = true,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    animationStyle: context.motionAnimationStyle,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        AppButton.ghost(
          key: cancelKey,
          label: cancelLabel,
          onPressed: () => Navigator.of(dialogContext).pop(false),
        ),
        if (destructive)
          AppButton.destructive(
            key: confirmKey,
            label: confirmLabel,
            onPressed: () => Navigator.of(dialogContext).pop(true),
          )
        else
          AppButton.primary(
            key: confirmKey,
            label: confirmLabel,
            onPressed: () => Navigator.of(dialogContext).pop(true),
          ),
      ],
    ),
  );
  return confirmed ?? false;
}
