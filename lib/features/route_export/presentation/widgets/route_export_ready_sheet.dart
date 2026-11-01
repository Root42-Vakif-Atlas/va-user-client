import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/route_export/domain/entities/route_export.dart';
import 'package:vakif_atlas/features/route_export/presentation/route_document_builder.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/molecules/inline_message.dart';

/// "PDF hazır": dosya bilgisi, arşiv durumu ve paylaş / yazdır / önizle.
class RouteExportReadySheet extends StatelessWidget {
  const RouteExportReadySheet({
    required this.file,
    required this.isSignedIn,
    required this.onShare,
    required this.onCopyLink,
    required this.onPrint,
    required this.onPreview,
    required this.onOpenExports,
    required this.onSignIn,
    super.key,
  });

  final RouteExportFile file;
  final bool isSignedIn;
  final VoidCallback onShare;

  /// Arşivdeki PDF'in bağlantısını kopyalar (yalnızca kaydedildiyse).
  final VoidCallback onCopyLink;
  final VoidCallback onPrint;
  final VoidCallback onPreview;
  final VoidCallback onOpenExports;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final (InlineMessageType type, String note) = switch (file) {
      RouteExportFile(archiveFailure: _?) => (
        InlineMessageType.warning,
        l10n.routeExportArchiveFailed,
      ),
      RouteExportFile(saved: _?) when isSignedIn => (
        InlineMessageType.success,
        l10n.routeExportSavedNote,
      ),
      _ => (InlineMessageType.success, l10n.routeExportGuestSavedNote),
    };
    final saved = file.saved != null;
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: Column(
          key: const Key('route_export_ready_sheet'),
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppText(
              l10n.routeExportReadyTitle,
              role: AppTextRole.headlineMedium,
              isHeading: true,
            ),
            const SizedBox(height: AppSpacing.xxs),
            AppText(
              '${file.fileName} · ${l10n.fileSize(file.bytes.length)}',
              role: AppTextRole.bodyMedium,
              color: colors.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.md),
            InlineMessage(type: type, message: note),
            if (saved || !isSignedIn) ...[
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  if (saved)
                    AppButton.ghost(
                      key: const Key('route_export_open_exports_button'),
                      label: l10n.routeExportOpenExports,
                      icon: Icons.folder_open_outlined,
                      onPressed: onOpenExports,
                    ),
                  if (!isSignedIn)
                    AppButton.ghost(
                      key: const Key('route_export_sign_in_button'),
                      label: l10n.routeExportSignIn,
                      icon: Icons.login,
                      onPressed: onSignIn,
                    ),
                ],
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            AppButton.primary(
              key: const Key('route_export_share_button'),
              label: l10n.routeExportShare,
              icon: Icons.ios_share,
              expand: true,
              onPressed: onShare,
            ),
            if (saved) ...[
              const SizedBox(height: AppSpacing.xs),
              AppButton.secondary(
                key: const Key('route_export_copy_link_button'),
                label: l10n.routeExportCopyLink,
                icon: Icons.link,
                expand: true,
                onPressed: onCopyLink,
              ),
            ],
            const SizedBox(height: AppSpacing.xs),
            AppButton.secondary(
              key: const Key('route_export_print_button'),
              label: l10n.routeExportPrint,
              icon: Icons.print_outlined,
              expand: true,
              onPressed: onPrint,
            ),
            const SizedBox(height: AppSpacing.xs),
            AppButton.ghost(
              key: const Key('route_export_preview_button'),
              label: l10n.routeExportPreview,
              icon: Icons.visibility_outlined,
              expand: true,
              onPressed: onPreview,
            ),
          ],
        ),
      ),
    );
  }
}
