import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/l10n/measure_format.dart';
import 'package:vakif_atlas/core/theme/extensions/app_color_scheme.dart';
import 'package:vakif_atlas/features/civil_protection/domain/entities/damage_report.dart';

extension DamageCategoryPresentation on DamageCategory {
  String label(AppLocalizations l10n) => switch (this) {
    DamageCategory.structuralDamage => l10n.cpCategoryStructural,
    DamageCategory.collapseRisk => l10n.cpCategoryCollapse,
    DamageCategory.vandalism => l10n.cpCategoryVandalism,
    DamageCategory.theft => l10n.cpCategoryTheft,
    DamageCategory.fireOrWater => l10n.cpCategoryFireWater,
    DamageCategory.unauthorizedWork => l10n.cpCategoryUnauthorized,
    DamageCategory.other => l10n.cpCategoryOther,
  };

  String description(AppLocalizations l10n) => switch (this) {
    DamageCategory.structuralDamage => l10n.cpCategoryStructuralBody,
    DamageCategory.collapseRisk => l10n.cpCategoryCollapseBody,
    DamageCategory.vandalism => l10n.cpCategoryVandalismBody,
    DamageCategory.theft => l10n.cpCategoryTheftBody,
    DamageCategory.fireOrWater => l10n.cpCategoryFireWaterBody,
    DamageCategory.unauthorizedWork => l10n.cpCategoryUnauthorizedBody,
    DamageCategory.other => l10n.cpCategoryOtherBody,
  };

  IconData get icon => switch (this) {
    DamageCategory.structuralDamage => Icons.broken_image_outlined,
    DamageCategory.collapseRisk => Icons.warning_amber_outlined,
    DamageCategory.vandalism => Icons.format_paint_outlined,
    DamageCategory.theft => Icons.no_photography_outlined,
    DamageCategory.fireOrWater => Icons.local_fire_department_outlined,
    DamageCategory.unauthorizedWork => Icons.construction_outlined,
    DamageCategory.other => Icons.more_horiz,
  };
}

extension ReportUrgencyPresentation on ReportUrgency {
  String label(AppLocalizations l10n) => switch (this) {
    ReportUrgency.low => l10n.cpUrgencyLow,
    ReportUrgency.medium => l10n.cpUrgencyMedium,
    ReportUrgency.high => l10n.cpUrgencyHigh,
    ReportUrgency.critical => l10n.cpUrgencyCritical,
  };

  String description(AppLocalizations l10n) => switch (this) {
    ReportUrgency.low => l10n.cpUrgencyLowBody,
    ReportUrgency.medium => l10n.cpUrgencyMediumBody,
    ReportUrgency.high => l10n.cpUrgencyHighBody,
    ReportUrgency.critical => l10n.cpUrgencyCriticalBody,
  };

  /// Seviye yalnızca renkle değil, ikonla da ayırt edilir (WCAG 1.4.1).
  IconData get icon => switch (this) {
    ReportUrgency.low => Icons.keyboard_double_arrow_down,
    ReportUrgency.medium => Icons.drag_handle,
    ReportUrgency.high => Icons.keyboard_double_arrow_up,
    ReportUrgency.critical => Icons.report_outlined,
  };

  Color color(AppColorScheme colors) => switch (this) {
    ReportUrgency.low || ReportUrgency.medium => colors.onSurfaceVariant,
    ReportUrgency.high => colors.warning,
    ReportUrgency.critical => colors.error,
  };
}

extension DamageReportStatusPresentation on DamageReportStatus {
  String label(AppLocalizations l10n) => switch (this) {
    DamageReportStatus.received => l10n.cpStatusReceived,
    DamageReportStatus.inReview => l10n.cpStatusInReview,
    DamageReportStatus.forwarded => l10n.cpStatusForwarded,
    DamageReportStatus.resolved => l10n.cpStatusResolved,
    DamageReportStatus.closed => l10n.cpStatusClosed,
  };

  String description(AppLocalizations l10n) => switch (this) {
    DamageReportStatus.received => l10n.cpStatusReceivedBody,
    DamageReportStatus.inReview => l10n.cpStatusInReviewBody,
    DamageReportStatus.forwarded => l10n.cpStatusForwardedBody,
    DamageReportStatus.resolved => l10n.cpStatusResolvedBody,
    DamageReportStatus.closed => l10n.cpStatusClosedBody,
  };

  IconData get icon => switch (this) {
    DamageReportStatus.received => Icons.inbox_outlined,
    DamageReportStatus.inReview => Icons.manage_search,
    DamageReportStatus.forwarded => Icons.forward_to_inbox_outlined,
    DamageReportStatus.resolved => Icons.task_alt,
    DamageReportStatus.closed => Icons.do_not_disturb_on_outlined,
  };

  Color color(AppColorScheme colors) => switch (this) {
    DamageReportStatus.received || DamageReportStatus.inReview => colors.info,
    DamageReportStatus.forwarded => colors.primary,
    DamageReportStatus.resolved => colors.success,
    DamageReportStatus.closed => colors.onSurfaceVariant,
  };
}

/// Olağan akış: alındı → inceleniyor → iletildi → sonuçlandı. "Kapatıldı"
/// raporun son adımı olduğunda "sonuçlandı"nın yerini alır.
List<DamageReportStatus> statusSteps(DamageReport report) => [
  DamageReportStatus.received,
  DamageReportStatus.inReview,
  DamageReportStatus.forwarded,
  if (report.status == DamageReportStatus.closed)
    DamageReportStatus.closed
  else
    DamageReportStatus.resolved,
];

abstract final class ReportDates {
  static String day(AppLocalizations l10n, DateTime date) =>
      DateFormat.yMMMd(l10n.localeName).format(date.toLocal());

  static String dateTime(AppLocalizations l10n, DateTime date) =>
      DateFormat.yMMMd(l10n.localeName).add_Hm().format(date.toLocal());
}

extension ReportLocationCheckPresentation on ReportLocationCheck {
  String label(AppLocalizations l10n) {
    final distance = distanceMeters;
    return switch (verification) {
      LocationVerification.notProvided => l10n.cpLocationNotProvidedValue,
      LocationVerification.onSite => l10n.cpLocationOnSiteValue(
        l10n.distance(distance ?? 0),
      ),
      LocationVerification.distant => l10n.cpLocationDistantValue(
        l10n.distance(distance ?? 0),
      ),
    };
  }

  IconData get icon => switch (verification) {
    LocationVerification.notProvided => Icons.location_off_outlined,
    LocationVerification.onSite => Icons.where_to_vote_outlined,
    LocationVerification.distant => Icons.location_on_outlined,
  };
}
