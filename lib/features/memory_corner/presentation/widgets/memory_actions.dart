import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory_draft.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/memory_presentation.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/molecules/inline_message.dart';

/// Kullanıcının seçtiği bildirme nedeni ve notu.
@immutable
final class MemoryReportSubmission {
  const MemoryReportSubmission({required this.reason, required this.note});

  final MemoryReportReason reason;
  final String note;
}

/// Kalıcı silme onayı.
Future<bool> confirmMemoryDelete(BuildContext context) async {
  final l10n = context.l10n;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.memoryDeleteConfirmTitle),
      content: Text(l10n.memoryDeleteConfirmBody),
      actions: [
        TextButton(
          key: const Key('memory_delete_cancel'),
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.commonCancel),
        ),
        TextButton(
          key: const Key('memory_delete_confirm'),
          style: TextButton.styleFrom(foregroundColor: context.colors.error),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.memoryDelete),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}

/// Bildirme nedeni + isteğe bağlı not. Vazgeçilirse `null`.
Future<MemoryReportSubmission?> showMemoryReportSheet(BuildContext context) =>
    showModalBottomSheet<MemoryReportSubmission>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => const MemoryReportSheet(),
    );

/// Misafirin giriş gerektiren bir işlem denediğini açıklar; "Giriş yap"
/// seçilirse `true`.
Future<bool> showMemorySignInSheet(
  BuildContext context,
  MemorySignInIntent intent,
) async {
  final l10n = context.l10n;
  final confirmed = await showModalBottomSheet<bool>(
    context: context,
    useSafeArea: true,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppIcon.decorative(
              Icons.lock_person_outlined,
              size: AppSizes.iconLg,
              color: context.colors.accentText,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppText(
              l10n.memorySignInTitle,
              role: AppTextRole.headlineMedium,
              textAlign: TextAlign.center,
              isHeading: true,
            ),
            const SizedBox(height: AppSpacing.xs),
            AppText(switch (intent) {
              MemorySignInIntent.share => l10n.memorySignInToShare,
              MemorySignInIntent.report => l10n.memorySignInToReport,
            }, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.lg),
            AppButton.primary(
              key: const Key('memory_sign_in_button'),
              label: l10n.routeExportSignIn,
              icon: Icons.login,
              expand: true,
              onPressed: () => Navigator.of(context).pop(true),
            ),
            const SizedBox(height: AppSpacing.xs),
            AppButton.ghost(
              label: l10n.commonCancel,
              expand: true,
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ],
        ),
      ),
    ),
  );
  return confirmed ?? false;
}

class MemoryReportSheet extends StatefulWidget {
  const MemoryReportSheet({super.key});

  @override
  State<MemoryReportSheet> createState() => _MemoryReportSheetState();
}

class _MemoryReportSheetState extends State<MemoryReportSheet> {
  final TextEditingController _note = TextEditingController();
  MemoryReportReason? _reason;
  bool _showError = false;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  void _submit() {
    final reason = _reason;
    if (reason == null) {
      setState(() => _showError = true);
      return;
    }
    Navigator.of(context)
        .pop(MemoryReportSubmission(reason: reason, note: _note.text));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final viewInsets = MediaQuery.viewInsetsOf(context).bottom;
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: viewInsets + AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppText(
                    l10n.memoryReportTitle,
                    role: AppTextRole.headlineMedium,
                    isHeading: true,
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  AppText(
                    l10n.memoryReportQuestion,
                    color: context.colors.onSurfaceVariant,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            RadioGroup<MemoryReportReason>(
              groupValue: _reason,
              onChanged: (reason) => setState(() {
                _reason = reason;
                _showError = false;
              }),
              child: Column(
                children: [
                  for (final reason in MemoryReportReason.values)
                    RadioListTile<MemoryReportReason>(
                      key: Key('memory_report_reason_${reason.name}'),
                      value: reason,
                      title: Text(reason.label(l10n)),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_showError) ...[
                    InlineMessage(
                      key: const Key('memory_report_reason_error'),
                      message: l10n.memoryReportReasonRequired,
                      type: InlineMessageType.error,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                  TextField(
                    key: const Key('memory_report_note'),
                    controller: _note,
                    minLines: 2,
                    maxLines: 4,
                    maxLength: MemoryRules.maxReportNoteLength,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: l10n.memoryReportNoteLabel,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  AppText(
                    l10n.memoryReportNotice,
                    role: AppTextRole.bodySmall,
                    color: context.colors.onSurfaceVariant,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppButton.primary(
                    key: const Key('memory_report_submit'),
                    label: l10n.memoryReport,
                    icon: Icons.flag_outlined,
                    expand: true,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
