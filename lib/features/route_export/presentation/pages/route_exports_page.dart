import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/l10n/failure_messages.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/route_export/domain/entities/route_export.dart';
import 'package:vakif_atlas/features/route_export/presentation/cubit/route_exports_cubit.dart';
import 'package:vakif_atlas/features/route_export/presentation/pages/route_export_preview_page.dart';
import 'package:vakif_atlas/features/route_export/presentation/route_document_builder.dart';
import 'package:vakif_atlas/features/route_export/presentation/widgets/route_export_actions.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';
import 'package:vakif_atlas/shared/widgets/templates/loading_status_view.dart';
import 'package:vakif_atlas/shared/widgets/templates/status_message_view.dart';

enum _ExportAction { share, copyLink, print, delete }

/// "Dışa aktarımlarım" (`/exports`): sahibin arşivindeki rota PDF'leri —
/// oturum açıksa hesabın, misafirde bu kurulumun (girişte hesaba taşınır).
/// `RouteExportsCubit` üst ağaçtan sağlanır.
class RouteExportsPage extends StatefulWidget {
  const RouteExportsPage({
    required this.ownerId,
    required this.onOpenRoutes,
    this.previewBuilder = RouteExportPreviewPage.defaultPreview,
    super.key,
  });

  /// Oturum açık kullanıcı; misafirde `null`.
  final String? ownerId;

  /// Boş listede "Rotalarım" (PDF bir rotanın detayından üretilir).
  final VoidCallback onOpenRoutes;

  /// Testlerde PDF rasterleştirmesi yerine kullanılır.
  final PdfPreviewBuilder previewBuilder;

  @override
  State<RouteExportsPage> createState() => _RouteExportsPageState();
}

class _RouteExportsPageState extends State<RouteExportsPage> {
  RouteExportsCubit get _cubit => context.read<RouteExportsCubit>();

  @override
  void initState() {
    super.initState();
    unawaited(_cubit.start(widget.ownerId));
  }

  @override
  void didUpdateWidget(RouteExportsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ownerId != widget.ownerId) {
      unawaited(_cubit.start(widget.ownerId));
    }
  }

  Future<RouteExportFile?> _file(RouteExport export) => _cubit.open(export.id);

  Future<void> _preview(RouteExport export) async {
    final file = await _file(export);
    if (file == null || !mounted) {
      return;
    }
    await Navigator.of(context).push(
      RouteExportPreviewPage.route(
        context,
        file: file,
        title: export.routeName,
        previewBuilder: widget.previewBuilder,
      ),
    );
  }

  Future<void> _onAction(RouteExport export, _ExportAction action) async {
    switch (action) {
      case _ExportAction.share || _ExportAction.print:
        final file = await _file(export);
        if (file == null || !mounted) {
          return;
        }
        await (action == _ExportAction.share
            ? shareRouteExport(context, file)
            : printRouteExport(context, file));
      case _ExportAction.copyLink:
        await copyRouteExportLink(context, () => _cubit.shareLink(export.id));
      case _ExportAction.delete:
        await _confirmDelete(export);
    }
  }

  Future<void> _confirmDelete(RouteExport export) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.routeExportsDeleteConfirmTitle),
        content: Text(l10n.routeExportsDeleteConfirmBody(export.routeName)),
        actions: [
          TextButton(
            key: const Key('route_export_delete_cancel'),
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            key: const Key('route_export_delete_confirm'),
            style: TextButton.styleFrom(foregroundColor: context.colors.error),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.routeExportsDelete),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await _cubit.delete(export.id);
    }
  }

  void _notify(BuildContext context, String message, {bool assertive = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
    unawaited(
      context.read<A11yAnnouncer>().announce(message, assertive: assertive),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.routeExportsTitle)),
      body: MultiBlocListener(
        listeners: [
          BlocListener<RouteExportsCubit, RouteExportsState>(
            listenWhen: (previous, current) =>
                current.deletions > previous.deletions,
            listener: (context, _) =>
                _notify(context, l10n.routeExportsDeleted),
          ),
          BlocListener<RouteExportsCubit, RouteExportsState>(
            listenWhen: (previous, current) =>
                current.actionFailure != null &&
                current.actionFailure != previous.actionFailure,
            listener: (context, state) => _notify(
              context,
              state.actionFailure!.toUserMessage(l10n),
              assertive: true,
            ),
          ),
        ],
        child: BlocBuilder<RouteExportsCubit, RouteExportsState>(
          builder: (context, state) => switch (state) {
            RouteExportsState(status: RouteExportsStatus.loading) =>
              LoadingStatusView(label: l10n.routeExportsTitle),
            RouteExportsState(
              status: RouteExportsStatus.failure,
              :final failure,
            ) =>
              StatusMessageView(
                key: const Key('route_exports_error'),
                tone: StatusMessageTone.error,
                icon: Icons.folder_off_outlined,
                title: l10n.routeExportsLoadFailedTitle,
                message: failure?.toUserMessage(l10n) ?? '',
                actionLabel: l10n.commonRetry,
                onAction: () => _cubit.start(widget.ownerId),
              ),
            RouteExportsState(:final items) when items.isEmpty =>
              StatusMessageView(
                key: const Key('route_exports_empty'),
                icon: Icons.picture_as_pdf_outlined,
                title: l10n.routeExportsEmptyTitle,
                message: l10n.routeExportsEmptyBody,
                actionLabel: l10n.routeListTitle,
                actionIcon: Icons.route_outlined,
                onAction: widget.onOpenRoutes,
              ),
            RouteExportsState(:final items) => _ExportList(
              items: items,
              onOpen: (export) => unawaited(_preview(export)),
              onAction: (export, action) =>
                  unawaited(_onAction(export, action)),
            ),
          },
        ),
      ),
    );
  }
}

class _ExportList extends StatelessWidget {
  const _ExportList({
    required this.items,
    required this.onOpen,
    required this.onAction,
  });

  final List<RouteExport> items;
  final ValueChanged<RouteExport> onOpen;
  final void Function(RouteExport export, _ExportAction action) onAction;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final date = DateFormat.yMMMd(l10n.localeName).add_Hm();
    return SafeArea(
      top: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
          child: ListView.separated(
            key: const Key('route_exports_list'),
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            itemCount: items.length,
            separatorBuilder: (_, _) => const Divider(height: 0),
            itemBuilder: (context, index) {
              final export = items[index];
              return ListTile(
                key: Key('route_export_${export.id}'),
                leading: Container(
                  width: AppSizes.minTouchTarget,
                  height: AppSizes.minTouchTarget,
                  decoration: BoxDecoration(
                    color: colors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: AppIcon.decorative(
                    Icons.picture_as_pdf_outlined,
                    color: colors.accentText,
                  ),
                ),
                title: Text(export.routeName),
                subtitle: Text(
                  l10n.routeExportsItemSubtitle(
                    date.format(export.createdAt.toLocal()),
                    l10n.routeStopCount(export.stopCount),
                    l10n.fileSize(export.byteSize),
                  ),
                ),
                onTap: () => onOpen(export),
                trailing: PopupMenuButton<_ExportAction>(
                  key: Key('route_export_menu_${export.id}'),
                  tooltip: l10n.routeExportsMoreActions(export.routeName),
                  onSelected: (action) => onAction(export, action),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      key: const Key('route_export_action_share'),
                      value: _ExportAction.share,
                      child: ListTile(
                        leading: const Icon(Icons.ios_share),
                        title: Text(l10n.routeExportShare),
                      ),
                    ),
                    PopupMenuItem(
                      key: const Key('route_export_action_copy_link'),
                      value: _ExportAction.copyLink,
                      child: ListTile(
                        leading: const Icon(Icons.link),
                        title: Text(l10n.routeExportCopyLink),
                      ),
                    ),
                    PopupMenuItem(
                      key: const Key('route_export_action_print'),
                      value: _ExportAction.print,
                      child: ListTile(
                        leading: const Icon(Icons.print_outlined),
                        title: Text(l10n.routeExportPrint),
                      ),
                    ),
                    PopupMenuItem(
                      key: const Key('route_export_action_delete'),
                      value: _ExportAction.delete,
                      child: ListTile(
                        leading: Icon(
                          Icons.delete_outline,
                          color: colors.error,
                        ),
                        title: Text(l10n.routeExportsDelete),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
