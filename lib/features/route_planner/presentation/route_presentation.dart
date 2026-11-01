import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/route_plan.dart';

extension RouteBreakKindPresentation on RouteBreakKind {
  String label(AppLocalizations l10n) => switch (this) {
    RouteBreakKind.shortBreak => l10n.routeBreakShort,
    RouteBreakKind.meal => l10n.routeBreakMeal,
    RouteBreakKind.rest => l10n.routeBreakRest,
    RouteBreakKind.overnight => l10n.routeBreakOvernight,
  };

  IconData get icon => switch (this) {
    RouteBreakKind.shortBreak => Icons.local_cafe_outlined,
    RouteBreakKind.meal => Icons.restaurant_outlined,
    RouteBreakKind.rest => Icons.self_improvement_outlined,
    RouteBreakKind.overnight => Icons.hotel_outlined,
  };
}

/// Kullanıcı ad vermezse rotaya önerilen ad (ör. "Edirne – İzmir Rotası").
String suggestedRouteName(AppLocalizations l10n, List<String> cities) {
  if (cities.isEmpty) {
    return l10n.routeDefaultNameEmpty;
  }
  if (cities.first == cities.last) {
    return l10n.routeDefaultNameSingleCity(cities.first);
  }
  return l10n.routeDefaultName(cities.first, cities.last);
}

/// Rota illeri zinciri: "Edirne → İstanbul → Bursa".
String routeCityChain(AppLocalizations l10n, List<String> cities) =>
    cities.isEmpty ? '' : cities.reduce(l10n.routeCityChain);

extension RoutePlanErrorPresentation on RoutePlanError {
  /// Gönderim engellendiğinde gösterilen ve duyurulan mesaj.
  String message(AppLocalizations l10n) => switch (this) {
    RoutePlanError.tooFewStops => l10n.routeEmptyStops,
    RoutePlanError.tooManyStops => l10n.routeLimitReached(
      RoutePlanRules.maxStops,
    ),
    RoutePlanError.nameTooLong => l10n.routeValidationNameTooLong(
      RoutePlanRules.maxNameLength,
    ),
    RoutePlanError.emptyName ||
    RoutePlanError.duplicateStop ||
    RoutePlanError.visitOutOfRange ||
    RoutePlanError.tooManyBreaks ||
    RoutePlanError.breakOutOfRange => l10n.routeValidationGeneric,
  };
}
