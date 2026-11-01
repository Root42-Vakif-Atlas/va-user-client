import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/features/ai_assistant/domain/entities/guide_message.dart';

/// Rehber eylemlerinin ikon ve etiketleri. Etiketler istemcide
/// yerelleştirilir; sunucudan yalnızca eser adı gelir.
extension GuideActionPresentation on GuideAction {
  IconData get icon => switch (this) {
    GuideOpenMonument() => Icons.account_balance_outlined,
    GuideShowOnMap() => Icons.place_outlined,
    GuideOpenMemories() => Icons.photo_library_outlined,
    GuideReportDamage() => Icons.add_alert_outlined,
    GuideSearchMonuments() => Icons.manage_search,
    GuideOpenSection(:final destination) => switch (destination) {
      GuideDestination.map => Icons.map_outlined,
      GuideDestination.routePlanner => Icons.route_outlined,
      GuideDestination.routeBuilder => Icons.add_road,
      GuideDestination.civilProtection => Icons.shield_outlined,
      GuideDestination.settings => Icons.settings_outlined,
      GuideDestination.accessibility => Icons.accessibility_new,
    },
  };

  String label(AppLocalizations l10n) => switch (this) {
    GuideOpenMonument(:final monument) => l10n.guideActionOpenMonument(
      monument.name,
    ),
    GuideShowOnMap() => l10n.guideActionShowOnMap,
    GuideOpenMemories() => l10n.guideActionOpenMemories,
    GuideReportDamage() => l10n.guideActionReportDamage,
    GuideSearchMonuments(:final total) =>
      total > 0 ? l10n.guideActionSearch(total) : l10n.guideActionSearchAll,
    GuideOpenSection(:final destination) => switch (destination) {
      GuideDestination.map => l10n.guideActionOpenMap,
      GuideDestination.routePlanner => l10n.guideActionOpenRoutes,
      GuideDestination.routeBuilder => l10n.guideActionNewRoute,
      GuideDestination.civilProtection => l10n.guideActionOpenCivilProtection,
      GuideDestination.settings => l10n.guideActionOpenSettings,
      GuideDestination.accessibility => l10n.guideActionOpenAccessibility,
    },
  };

  /// Görünür etiketi içerir (WCAG 2.5.3); esere bağlı eylemlerde eser adı
  /// eklenir.
  String semanticsLabel(AppLocalizations l10n) {
    final visible = label(l10n);
    return switch (this) {
      GuideShowOnMap(:final monument) || GuideOpenMemories(:final monument) =>
        l10n.guideActionForMonument(visible, monument.name),
      GuideReportDamage(:final monument?) => l10n.guideActionForMonument(
        visible,
        monument.name,
      ),
      _ => visible,
    };
  }
}
