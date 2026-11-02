import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/memory_presentation.dart';
import 'package:vakif_atlas/shared/widgets/atoms/status_badge.dart';

/// Anının moderasyon durumu ("İncelemede" / "Yayınlanmadı"): ikon + metin,
/// renk yalnızca destekleyicidir (WCAG 1.4.1); `ReportStatusBadge` ile aynı
/// ortak `StatusBadge` görünümü.
class MemoryStatusBadge extends StatelessWidget {
  const MemoryStatusBadge({required this.status, super.key});

  final MemoryModerationStatus status;

  @override
  Widget build(BuildContext context) {
    return StatusBadge(
      icon: status.icon,
      label: status.label(context.l10n),
      color: status.color(context.colors),
    );
  }
}
