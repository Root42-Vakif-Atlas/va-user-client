import 'package:intl/intl.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/l10n/measure_format.dart';
import 'package:vakif_atlas/core/utils/turkish_text.dart';
import 'package:vakif_atlas/features/catalog/presentation/catalog_presentation.dart';
import 'package:vakif_atlas/features/route_export/domain/entities/route_document.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/travel_route.dart';
import 'package:vakif_atlas/features/route_planner/presentation/route_presentation.dart';

/// Kayıtlı rotayı arayüz dilinde dışa aktarım belgesine dönüştürür.
///
/// Belge sunucunun hesapladığı rotadan (karayolu mesafe/süreleri) üretilir;
/// taslaktaki kuş uçuşu ön özet kullanılmaz.
RouteDocument buildRouteDocument(
  TravelRoute route,
  AppLocalizations l10n, {
  required DateTime now,
}) {
  final summary = route.summary;
  final cities = [for (final stop in route.stops) stop.city];
  final dateTime = DateFormat.yMMMMd(l10n.localeName).add_Hm();
  return RouteDocument(
    routeId: route.id,
    title: route.name,
    subtitle: [
      if (cities.isNotEmpty) routeCityChain(l10n, cities),
      l10n.routeStopCount(route.stops.length),
    ].join(' · '),
    languageCode: l10n.localeName,
    fileName: routeExportFileName(route.name, now),
    facts: [
      RouteDocumentFact(
        label: l10n.routeTotalDuration,
        value: l10n.durationLong(summary.total),
      ),
      RouteDocumentFact(
        label: l10n.routeDistance,
        value: l10n.distance(summary.distanceMeters),
      ),
      RouteDocumentFact(
        label: l10n.routeTravelTime,
        value: l10n.durationLong(summary.travel),
      ),
      RouteDocumentFact(
        label: l10n.routeVisitTime,
        value: l10n.durationLong(summary.visit),
      ),
      if (summary.breaks > Duration.zero)
        RouteDocumentFact(
          label: l10n.routeBreakTime,
          value: l10n.durationLong(summary.breaks),
        ),
    ],
    stops: [
      for (final (index, stop) in route.stops.indexed)
        RouteDocumentStop(
          name: stop.name,
          place: l10n.monumentListItemSubtitle(
            l10n.monumentLocation(stop.district, stop.city),
            stop.category.label(l10n),
          ),
          location: stop.location,
          mapUrl: _mapUrl(stop.location.latitude, stop.location.longitude),
          details: [
            l10n.routeVisitLabel(l10n.durationLong(stop.visit)),
            for (final pause in stop.breaks)
              l10n.routeBreakLabel(
                pause.kind.label(l10n),
                l10n.durationLong(pause.duration),
              ),
          ],
          nextLeg: index < route.legs.length
              ? l10n.routeLegLabel(
                  l10n.distance(route.legs[index].distanceMeters),
                  l10n.durationLong(route.legs[index].duration),
                )
              : null,
        ),
    ],
    path: [for (final leg in route.legs) ...leg.geometry],
    labels: RouteDocumentLabels(
      brand: l10n.appTitle,
      summaryHeading: l10n.routeSummaryHeading,
      sketchHeading: l10n.routeExportSketchHeading,
      sketchCaption: l10n.routeExportSketchCaption,
      stopsHeading: l10n.routeExportStopsHeading,
      mapLink: l10n.routeExportMapLink,
      disclaimer: l10n.routeEstimateNote,
      attribution: l10n.routeExportAttribution,
      generatedOn: l10n.routeExportGeneratedOn(dateTime.format(now.toLocal())),
      pageOf: l10n.routeExportPageOf(
        RouteDocumentLabels.pagePlaceholder,
        RouteDocumentLabels.totalPlaceholder,
      ),
    ),
  );
}

/// Konum yalnızca kullanıcı bağlantıya dokunduğunda haritaya gönderilir.
String _mapUrl(double latitude, double longitude) {
  final lat = latitude.toStringAsFixed(6);
  final lon = longitude.toStringAsFixed(6);
  return 'https://www.openstreetmap.org/?mlat=$lat&mlon=$lon#map=17/$lat/$lon';
}

/// Paylaşımda görünen dosya adı: `vakif-atlas-edirne-rotasi-2026-10-18.pdf`.
/// Türkçe harfler sadeleştirilir; ad boşsa `rota` kullanılır.
String routeExportFileName(String routeName, DateTime now) {
  const maxSlugLength = 60;
  var slug = TurkishText.fold(routeName)
      .replaceAll(RegExp('[^a-z0-9]+'), '-')
      .replaceAll(RegExp('^-+|-+\$'), '');
  if (slug.length > maxSlugLength) {
    slug = slug.substring(0, maxSlugLength).replaceAll(RegExp(r'-+$'), '');
  }
  final date = DateFormat('yyyy-MM-dd').format(now.toLocal());
  return 'vakif-atlas-${slug.isEmpty ? 'rota' : slug}-$date.pdf';
}

extension FileSizeFormat on AppLocalizations {
  /// `148 KB`, `1,2 MB`.
  String fileSize(int bytes) {
    const kilobyte = 1024;
    if (bytes < kilobyte * kilobyte) {
      return fileSizeKilobytes(
        NumberFormat.decimalPattern(localeName)
            .format((bytes / kilobyte).ceil()),
      );
    }
    return fileSizeMegabytes(
      NumberFormat.decimalPatternDigits(
        locale: localeName,
        decimalDigits: 1,
      ).format(bytes / (kilobyte * kilobyte)),
    );
  }
}
