import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/core/utils/list_equality.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/geo_point.dart';
import 'package:vakif_atlas/features/catalog/presentation/catalog_presentation.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/travel_route.dart';
import 'package:vakif_atlas/shared/widgets/organisms/a11y_map_controls.dart';
import 'package:vakif_atlas/shared/widgets/organisms/app_map.dart';
import 'package:vakif_atlas/shared/widgets/organisms/map_pin.dart';

/// Haritadaki numaralı durak.
typedef RouteMapStop = ({GeoPoint location, String name});

/// Rotayı karayolu çizgisi ve numaralı duraklarla gösteren harita (kayıtlı
/// rota veya oluşturucunun ön hesabı).
///
/// Sayfa kaydırmasıyla çakışmaması için sürükleme kapalıdır;
/// yakınlaştırma tek dokunuşlu kontrollerle yapılır. Görseldir: metin
/// karşılığı adım adım listedir.
class RouteMapPreview extends StatefulWidget {
  const RouteMapPreview({required this.stops, required this.legs, super.key});

  RouteMapPreview.route(TravelRoute route, {Key? key})
    : this(
        stops: [
          for (final stop in route.stops)
            (location: stop.location, name: stop.name),
        ],
        legs: route.legs,
        key: key,
      );

  final List<RouteMapStop> stops;

  /// `stops[i]` → `stops[i + 1]`.
  final List<RouteLeg> legs;

  static const double _aspectRatio = 4 / 3;
  static const double _maxHeight = 420;

  @override
  State<RouteMapPreview> createState() => _RouteMapPreviewState();
}

class _RouteMapPreviewState extends State<RouteMapPreview> {
  final AppMapController _map = AppMapController();

  TextDirection? _direction;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Kenar boşlukları yöne bağlı; yalnızca ilk açılışta ve yön değişince.
    final direction = Directionality.of(context);
    if (direction != _direction) {
      _direction = direction;
      _showRoute();
    }
  }

  @override
  void didUpdateWidget(RouteMapPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!elementsEqual(oldWidget.stops, widget.stops) ||
        !elementsEqual(oldWidget.legs, widget.legs)) {
      _showRoute();
    }
  }

  void _showRoute() => _map.showAll(
    [
      for (final leg in widget.legs)
        for (final point in leg.geometry) point.toLatLng(),
      for (final stop in widget.stops) stop.location.toLatLng(),
    ],
    // Sondaki kontrol sütunu ve alttaki atıf rotayı örtmesin.
    padding: const EdgeInsetsDirectional.fromSTEB(
      AppSpacing.xl,
      AppSpacing.xl,
      AppSizes.mapControl + AppSpacing.lg,
      AppSpacing.xxl,
    ).resolve(Directionality.of(context)),
  );

  @override
  Widget build(BuildContext context) {
    final stops = widget.stops;
    return LayoutBuilder(
      builder: (context, constraints) => SizedBox(
        height: math.min(
          constraints.maxWidth / RouteMapPreview._aspectRatio,
          RouteMapPreview._maxHeight,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: AppMap(
                key: const Key('route_map'),
                controller: _map,
                interactive: false,
                initialCenter: stops.first.location.toLatLng(),
                routeLines: [
                  for (final leg in widget.legs)
                    [for (final point in leg.geometry) point.toLatLng()],
                ],
                markers: [
                  for (var index = stops.length - 1; index >= 0; index--)
                    Marker(
                      point: stops[index].location.toLatLng(),
                      width: MapPin.extent(selected: false),
                      height: MapPin.extent(selected: false),
                      child: MapPin(
                        label: '${index + 1}',
                        semanticsLabel: stops[index].name,
                      ),
                    ),
                ],
              ),
            ),
            PositionedDirectional(
              top: AppSpacing.sm,
              end: AppSpacing.sm,
              child: A11yMapControls(
                onZoomIn: _map.zoomIn,
                onZoomOut: _map.zoomOut,
                onShowAll: _showRoute,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
