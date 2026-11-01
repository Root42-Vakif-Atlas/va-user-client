import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:vakif_atlas/core/a11y/reduce_motion.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/tokens/app_durations.dart';
import 'package:vakif_atlas/features/route_export/domain/entities/route_export.dart';
import 'package:vakif_atlas/features/route_export/presentation/widgets/route_export_actions.dart';

/// PDF sayfalarının görsel önizlemesini çizer.
typedef PdfPreviewBuilder = Widget Function(
  BuildContext context,
  Uint8List bytes,
  String fileName,
);

/// PDF önizlemesi; paylaş ve yazdır üst çubukta.
///
/// Önizleme sayfaların görüntüsüdür; aynı içerik rota detayında erişilebilir
/// metin olarak bulunur. Önizleme çizici testlerde değiştirilebilir.
class RouteExportPreviewPage extends StatelessWidget {
  const RouteExportPreviewPage({
    required this.file,
    required this.title,
    this.previewBuilder = defaultPreview,
    super.key,
  });

  final RouteExportFile file;
  final String title;
  final PdfPreviewBuilder previewBuilder;

  static Widget defaultPreview(
    BuildContext context,
    Uint8List bytes,
    String fileName,
  ) => PdfPreview(
    build: (_) async => bytes,
    pdfFileName: fileName,
    useActions: false,
    canChangePageFormat: false,
    canChangeOrientation: false,
    canDebug: false,
  );

  /// Hareket azaltmaya duyarlı, yumuşak geçişli tam ekran rota.
  static Route<void> route(
    BuildContext context, {
    required RouteExportFile file,
    required String title,
    PdfPreviewBuilder previewBuilder = defaultPreview,
  }) {
    final duration = context.motionDuration(AppDurations.medium);
    return PageRouteBuilder<void>(
      fullscreenDialog: true,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) =>
          RouteExportPreviewPage(
            file: file,
            title: title,
            previewBuilder: previewBuilder,
          ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(opacity: animation, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            key: const Key('route_export_preview_share'),
            tooltip: l10n.routeExportShare,
            icon: const Icon(Icons.ios_share),
            onPressed: () => shareRouteExport(context, file),
          ),
          IconButton(
            key: const Key('route_export_preview_print'),
            tooltip: l10n.routeExportPrint,
            icon: const Icon(Icons.print_outlined),
            onPressed: () => printRouteExport(context, file),
          ),
        ],
      ),
      body: Semantics(
        label: file.fileName,
        child: previewBuilder(context, file.bytes, file.fileName),
      ),
    );
  }
}
