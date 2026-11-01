import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/a11y/haptic_feedback_service.dart';
import 'package:vakif_atlas/core/l10n/failure_messages.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/sharing/document_share_service.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/route_export/domain/entities/route_export.dart';
import 'package:vakif_atlas/shared/widgets/molecules/app_snack_bar.dart';

/// PDF'i sistem paylaşım penceresine verir; açılamazsa bildirir.
Future<void> shareRouteExport(BuildContext context, RouteExportFile file) =>
    _run(
      context,
      (service) => service.sharePdf(bytes: file.bytes, fileName: file.fileName),
      failureMessage: context.l10n.routeExportShareFailed,
    );

/// PDF'i sistem yazdırma penceresine verir; açılamazsa bildirir.
Future<void> printRouteExport(BuildContext context, RouteExportFile file) =>
    _run(
      context,
      (service) => service.printPdf(bytes: file.bytes, name: file.fileName),
      failureMessage: context.l10n.routeExportPrintFailed,
    );

/// Paylaşılabilir bağlantıyı üretip panoya kopyalar; ne zamana kadar ve
/// kimin açabileceğini (bağlantıya sahip herkes) görsel ve sesli bildirir.
Future<void> copyRouteExportLink(
  BuildContext context,
  Future<Result<RouteExportLink>> Function() createLink,
) async {
  final l10n = context.l10n;
  final messenger = ScaffoldMessenger.of(context);
  final announcer = context.read<A11yAnnouncer>();
  final haptics = context.read<HapticFeedbackService>();
  final accessibleNavigation = MediaQuery.accessibleNavigationOf(context);
  final date = DateFormat.MMMMd(l10n.localeName).add_Hm();
  final result = await createLink();
  final (message, copied) = await result.fold(
    (failure) async => (failure.toUserMessage(l10n), false),
    (link) async {
      await Clipboard.setData(ClipboardData(text: link.url));
      return (
        l10n.routeExportLinkCopied(date.format(link.expiresAt.toLocal())),
        true,
      );
    },
  );
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      AppSnackBar.create(
        message: message,
        accessibleNavigation: accessibleNavigation,
      ),
    );
  unawaited(announcer.announce(message, assertive: !copied));
  unawaited(copied ? haptics.success() : haptics.error());
}

Future<void> _run(
  BuildContext context,
  Future<bool> Function(DocumentShareService service) action, {
  required String failureMessage,
}) async {
  final service = context.read<DocumentShareService>();
  final messenger = ScaffoldMessenger.of(context);
  final announcer = context.read<A11yAnnouncer>();
  final haptics = context.read<HapticFeedbackService>();
  final opened = await action(service);
  if (opened) {
    return;
  }
  // Kullanıcı pencereyi kendisi kapattığında da `false` dönebilir; mesaj
  // kısa ve bilgilendiricidir.
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(failureMessage)));
  unawaited(announcer.announce(failureMessage));
  unawaited(haptics.warning());
}
