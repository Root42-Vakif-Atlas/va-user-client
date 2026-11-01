import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';

/// Rotalarım üst çubuğundaki "Dışa aktarımlarım" kısayolu. Rota planlayıcı
/// bu widget'a bağımlı değildir; yönlendirici `RouteListPage.actions`'a
/// verir (ADR 52).
class RouteExportsShortcut extends StatelessWidget {
  const RouteExportsShortcut({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
    key: const Key('route_exports_shortcut'),
    tooltip: context.l10n.routeExportsTitle,
    icon: const Icon(Icons.picture_as_pdf_outlined),
    onPressed: onPressed,
  );
}
