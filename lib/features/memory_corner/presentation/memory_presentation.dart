import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/extensions/app_color_scheme.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory_draft.dart';

/// Giriş gerektiren işlem; yönlendirici dönüş hedefini buna göre seçer.
enum MemorySignInIntent { share, report }

extension MemoryReportReasonLabel on MemoryReportReason {
  String label(AppLocalizations l10n) => switch (this) {
    MemoryReportReason.offensive => l10n.memoryReportReasonOffensive,
    MemoryReportReason.inappropriate => l10n.memoryReportReasonInappropriate,
    MemoryReportReason.spam => l10n.memoryReportReasonSpam,
    MemoryReportReason.personalInfo => l10n.memoryReportReasonPersonalInfo,
    MemoryReportReason.unrelated => l10n.memoryReportReasonUnrelated,
    MemoryReportReason.other => l10n.memoryReportReasonOther,
  };
}

/// Anı tarihleri arayüz dilinde: paylaşım "14 Eki 2026", ziyaret
/// "Eylül 2026" (ziyaretin ayı yeterince anlamlıdır).
abstract final class MemoryDates {
  static String posted(AppLocalizations l10n, DateTime date) =>
      DateFormat.yMMMd(l10n.localeName).format(date.toLocal());

  static String visited(AppLocalizations l10n, DateTime date) =>
      DateFormat.yMMMM(l10n.localeName).format(date);

  static String day(AppLocalizations l10n, DateTime date) =>
      DateFormat.yMMMMd(l10n.localeName).format(date);
}

/// Moderasyon durumu (ADR 58): ikon + metin; renk yalnızca destekleyicidir.
extension MemoryModerationStatusPresentation on MemoryModerationStatus {
  String label(AppLocalizations l10n) => switch (this) {
    MemoryModerationStatus.approved => l10n.memoryStatusApproved,
    MemoryModerationStatus.pending => l10n.memoryStatusPending,
    MemoryModerationStatus.rejected => l10n.memoryStatusRejected,
  };

  /// Yazara açıklama (yayında olan anı için yok).
  String? description(AppLocalizations l10n) => switch (this) {
    MemoryModerationStatus.approved => null,
    MemoryModerationStatus.pending => l10n.myMemoriesStatusPending,
    MemoryModerationStatus.rejected => l10n.myMemoriesStatusRejected,
  };

  IconData get icon => switch (this) {
    MemoryModerationStatus.approved => Icons.public,
    MemoryModerationStatus.pending => Icons.hourglass_top_outlined,
    MemoryModerationStatus.rejected => Icons.visibility_off_outlined,
  };

  Color color(AppColorScheme colors) => switch (this) {
    MemoryModerationStatus.approved => colors.success,
    MemoryModerationStatus.pending => colors.info,
    MemoryModerationStatus.rejected => colors.error,
  };
}

extension MemorySemantics on Memory {
  /// Kartın başlık semantiği (yazar + tarih).
  String headerSemantics(AppLocalizations l10n, {required bool isOwn}) {
    final date = MemoryDates.posted(l10n, createdAt);
    return isOwn
        ? l10n.memoryOwnCardSemantics(date)
        : l10n.memoryCardSemantics(author.displayName, date);
  }
}
