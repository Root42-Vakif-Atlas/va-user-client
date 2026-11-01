import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/catalog/presentation/catalog_presentation.dart';
import 'package:vakif_atlas/features/route_planner/domain/entities/travel_route.dart';
import 'package:vakif_atlas/shared/widgets/organisms/a11y_map_controls.dart';
import 'package:vakif_atlas/shared/widgets/organisms/app_map.dart';
import 'package:vakif_atlas/shared/widgets/organisms/map_pin.dart';

/// Rotayı karayolu çizgisi ve numaralı duraklarla gösteren harita.
///
/// Sayfa kaydırmasıyla çakışmaması için sürükleme kapalıdır;
/// yakınlaştırma tek dokunuşlu kontrollerle yapılır. Görseldir: metin
/// karşılığı adım adım listedir.
class RouteMapPreview extends StatefulWidget {
  const RouteMapPreview({required this.route, super.key});

  final TravelRoute route;

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
    if (oldWidget.route != widget.route) {
      _showRoute();
    }
  }

  void _showRoute() => _map.showAll(
    [
      for (final leg in widget.route.legs)
        for (final point in leg.geometry) point.toLatLng(),
      for (final stop in widget.route.stops) stop.location.toLatLng(),
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
    final stops = widget.route.stops;
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
                  for (final leg in widget.route.legs)
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
