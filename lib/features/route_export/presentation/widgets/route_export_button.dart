import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/a11y/haptic_feedback_service.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/route_export/domain/entities/route_export.dart';
import 'package:vakif_atlas/features/route_export/presentation/cubit/route_export_cubit.dart';
import 'package:vakif_atlas/features/route_export/presentation/pages/route_export_preview_page.dart';
import 'package:vakif_atlas/features/route_export/presentation/route_document_builder.dart';
import 'package:vakif_atlas/features/route_export/presentation/widgets/route_export_actions.dart';
import 'package:vakif_atlas/features/route_export/presentation/widgets/route_export_ready_sheet.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/travel_route.dart';

/// Rota detayının üst çubuğundaki "PDF olarak dışa aktar" eylemi.
///
/// Rotayı yazdırılabilir belgeye dönüştürür; belge "Dışa aktarımlarım"
/// arşivine de kaydedilir (oturum açıksa hesabın, değilse kurulumun; girişte
/// hesaba taşınır). Hazır olunca
/// paylaş / yazdır / önizle sayfası açılır. `RouteExportCubit` üst ağaçtan
/// sağlanır. Rota planlayıcı bu widget'a bağımlı değildir; yönlendirici
/// `RouteDetailPage.exportActionBuilder` yuvasına verir.
class RouteExportButton extends StatelessWidget {
  const RouteExportButton({
    required this.route,
    required this.enabled,
    required this.onOpenExports,
    required this.onSignInToKeepExports,
    this.ownerId,
    this.previewBuilder = RouteExportPreviewPage.defaultPreview,
    super.key,
  });

  final TravelRoute route;

  /// Rota silinirken kapalıdır.
  final bool enabled;

  /// "Dışa aktarımlarım" listesini açar.
  final VoidCallback onOpenExports;

  /// Misafir dışa aktarımlarını hesabına taşımak için giriş yapmak istedi.
  final VoidCallback onSignInToKeepExports;

  /// Oturum açık kullanıcının kimliği; misafirde `null` (kurulumun arşivi).
  final String? ownerId;

  /// Testlerde PDF rasterleştirmesi yerine kullanılır.
  final PdfPreviewBuilder previewBuilder;

  void _export(BuildContext context) => unawaited(
    context.read<RouteExportCubit>().export(
      buildRouteDocument(route, context.l10n, now: DateTime.now()),
      ownerId: ownerId,
    ),
  );

  void _onChanged(BuildContext context, RouteExportState state) {
    final l10n = context.l10n;
    final announcer = context.read<A11yAnnouncer>();
    final haptics = context.read<HapticFeedbackService>();
    switch (state) {
      case RouteExportState(status: RouteExportStatus.ready, :final file?):
        unawaited(haptics.success());
        unawaited(
          announcer.announce(l10n.routeExportReadyAnnouncement(file.fileName)),
        );
        unawaited(_showSheet(context, file));
      case RouteExportState(status: RouteExportStatus.failure):
        unawaited(haptics.error());
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(l10n.routeExportFailed)));
        unawaited(announcer.announce(l10n.routeExportFailed, assertive: true));
      case _:
        break;
    }
  }

  Future<void> _showSheet(BuildContext context, RouteExportFile file) async {
    final title = route.name;
    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) => RouteExportReadySheet(
        file: file,
        isSignedIn: ownerId != null,
        onShare: () => shareRouteExport(sheetContext, file),
        // Bildirim alttaki sayfada gösterilir (modal sayfa onu örterdi).
        onCopyLink: () {
          Navigator.of(sheetContext).pop();
          unawaited(
            copyRouteExportLink(
              context,
              context.read<RouteExportCubit>().shareLink,
            ),
          );
        },
        onPrint: () => printRouteExport(sheetContext, file),
        onPreview: () {
          Navigator.of(sheetContext).pop();
          unawaited(
            Navigator.of(context).push(
              RouteExportPreviewPage.route(
                context,
                file: file,
                title: title,
                previewBuilder: previewBuilder,
              ),
            ),
          );
        },
        onOpenExports: () {
          Navigator.of(sheetContext).pop();
          onOpenExports();
        },
        onSignIn: () {
          Navigator.of(sheetContext).pop();
          onSignInToKeepExports();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<RouteExportCubit, RouteExportState>(
      listenWhen: (previous, current) =>
          previous.status != current.status || previous.file != current.file,
      listener: _onChanged,
      builder: (context, state) => IconButton(
        key: const Key('route_export_button'),
        tooltip: l10n.routeExportAction,
        icon: state.isExporting
            ? Semantics(
                liveRegion: true,
                label: l10n.routeExportInProgress,
                child: const SizedBox.square(
                  dimension: AppSizes.spinner,
                  child: CircularProgressIndicator(
                    strokeWidth: AppSizes.spinnerStroke,
                  ),
                ),
              )
            : const Icon(Icons.picture_as_pdf_outlined),
        onPressed: !enabled || state.isExporting
            ? null
            : () => _export(context),
      ),
    );
  }
}
