import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vakif_atlas/core/a11y/reduce_motion.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/map/map_defaults.dart';
import 'package:vakif_atlas/core/map/map_tile_filters.dart';
import 'package:vakif_atlas/core/map/map_tile_source.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_durations.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/shared/widgets/organisms/user_location_marker.dart';

/// [AppMap] kamerasına dışarıdan komut verir (ör. seçilen esere odaklan).
///
/// Harita henüz hazır değilken verilen son komut, harita hazır olduğunda
/// uygulanır.
class AppMapController {
  _AppMapState? _state;
  void Function(_AppMapState state)? _pending;

  /// [point] noktasına uçar ve yakınlaşır.
  void focus(LatLng point, {double zoom = MapDefaults.focusZoom}) =>
      _run((state) => state._animateTo(point, zoom));

  /// Tüm [points] ekrana sığacak şekilde kamerayı ayarlar.
  ///
  /// [padding]: harita üstündeki kontrollerin örttüğü kenarlar için ek boşluk.
  ///
  /// [maxZoom]: sığdırmanın en fazla yakınlaşacağı seviye (ör. küme
  /// genişletmede sokak ölçeği).
  void showAll(
    List<LatLng> points, {
    EdgeInsets padding = const EdgeInsets.all(AppSpacing.xxl),
    double maxZoom = MapDefaults.focusZoom,
  }) => _run((state) => state._fit(points, padding, maxZoom));

  /// Kullanıcı konumuna gider; yakınlaştırma en az [MapDefaults.locateZoom]
  /// olur, daha yakındaysa korunur.
  void locate(LatLng point) => _run(
    (state) => state._animateTo(
      point,
      state._map.camera.zoom < MapDefaults.locateZoom
          ? MapDefaults.locateZoom
          : state._map.camera.zoom,
    ),
  );

  /// Yakınlaştırmayı değiştirmeden [point] noktasını ortalar (konum takibi).
  void panTo(LatLng point) => _run(
    (state) => state._animateTo(
      point,
      state._map.camera.zoom,
      duration: AppDurations.medium,
    ),
  );

  /// Haritanın şu anki yakınlaştırma seviyesi; harita hazır değilse `null`.
  double? get zoom {
    final state = _state;
    return state != null && state._ready ? state._map.camera.zoom : null;
  }

  void zoomIn() => _run((state) => state._zoomBy(MapDefaults.zoomStep));

  void zoomOut() => _run((state) => state._zoomBy(-MapDefaults.zoomStep));

  void _run(void Function(_AppMapState state) command) {
    final state = _state;
    if (state != null && state._ready) {
      command(state);
    } else {
      _pending = command;
    }
  }

  void _attach(_AppMapState state) => _state = state;

  void _detach(_AppMapState state) {
    if (identical(_state, state)) {
      _state = null;
    }
  }

  void _flush(_AppMapState state) {
    final pending = _pending;
    _pending = null;
    pending?.call(state);
  }
}

/// Tema, erişilebilirlik ve lisans kurallarını uygulayan harita (TRD §10.D).
///
/// - Altlık açık/koyu temaya göre seçilir; yüksek kontrast temalar aynı
///   parlaklıktaki altlığı kullanır, pin ve kontroller 7:1 renklerle çizilir.
/// - Döndürme kapalıdır; kamera Türkiye bölgesinden çıkamaz.
/// - Hareket azaltma açıksa kamera geçişleri ve tile belirmesi anlıktır.
/// - Altlık görselleri ekran okuyucuya sunulmaz; yalnızca [markers] ve
///   [semanticsLabel] okunur.
class AppMap extends StatefulWidget {
  const AppMap({
    this.semanticsLabel,
    this.controller,
    this.markers = const [],
    this.layers = const [],
    this.routeLines = const [],
    this.userLocation,
    this.initialCenter = MapDefaults.turkeyCenter,
    this.initialZoom = MapDefaults.overviewZoom,
    this.interactive = true,
    this.onBackgroundTap,
    this.onUserGesture,
    this.onCameraIdle,
    this.showAttribution = true,
    super.key,
  });

  /// Harita bölgesinin ekran okuyucu adı. `null` → harita ekran okuyucudan
  /// gizlenir (metin alternatifi çağıranda sunulmalıdır).
  final String? semanticsLabel;
  final AppMapController? controller;
  final List<Marker> markers;

  /// [markers]'dan önce eklenen FlutterMap katmanları (ör. kümelenmiş
  /// pinler; `MapCamera.of(context)` ile kameraya göre çizilir).
  final List<Widget> layers;

  /// Rota çizgileri; tema vurgu rengiyle ve her altlıkta ≥ 3:1 ayrışması
  /// için kontrast konturuyla çizilir (WCAG 1.4.11). Görseldir; metin
  /// karşılığı (adım listesi) çağıranda sunulur.
  final List<List<LatLng>> routeLines;

  /// Verildiğinde "konumunuz" noktası ve doğruluk dairesi çizilir (eser
  /// pinlerinin altında; pinler dokunulabilir kalır).
  final MapUserLocation? userLocation;
  final LatLng initialCenter;
  final double initialZoom;

  /// `false` → harita yalnızca gösterim amaçlıdır (dokunma, kaydırma ve klavye
  /// kapalı).
  final bool interactive;

  /// Pin dışında bir yere dokunulduğunda.
  final VoidCallback? onBackgroundTap;

  /// Kullanıcı haritayı sürükleyip yakınlaştırdığında (ör. konum takibini
  /// bırakmak için). Program kaynaklı kamera hareketlerinde çağrılmaz.
  final VoidCallback? onUserGesture;

  /// Kamera durduğunda (ör. görünür karoları istemek için). Açılışta da
  /// bir kez çağrılır.
  final ValueChanged<MapCamera>? onCameraIdle;

  /// Kamera bu süre hareketsiz kalınca [onCameraIdle] çağrılır.
  static const Duration cameraIdleDelay = Duration(milliseconds: 250);

  /// `false` → atıf haritanın sağ alt köşesine çizilmez; çağıran
  /// [MapAttribution]'ı kendi kontrollerinin hizasında **göstermek
  /// zorundadır** (ODbL / OSM karo politikası: atıf sürekli görünür).
  final bool showAttribution;

  @override
  State<AppMap> createState() => _AppMapState();
}

class _AppMapState extends State<AppMap> with SingleTickerProviderStateMixin {
  final MapController _map = MapController();
  late final AnimationController _camera = AnimationController(vsync: this)
    ..addListener(_onCameraTick);

  /// `TileLayer` kapanırken sağlayıcıyı da kapatır; bu harita ömrü boyunca
  /// aynı sağlayıcıyı kullanır.
  late final TileProvider _tileProvider = context
      .read<MapTileSource>()
      .createTileProvider();

  /// Koyu tema filtresi eklenip kaldırıldığında `TileLayer` yeniden
  /// oluşturulmaz (aksi halde sağlayıcıyı kapatır); yalnızca taşınır.
  final GlobalKey _tileLayerKey = GlobalKey(debugLabel: 'tiles');

  bool _ready = false;
  void Function(double progress)? _cameraStep;

  static final Animatable<double> _panCurve = CurveTween(
    curve: const Interval(0, 0.7, curve: Curves.easeInOutCubic),
  );
  static final Animatable<double> _zoomCurve = CurveTween(
    curve: const Interval(0.25, 1, curve: Curves.easeInOutCubic),
  );

  @override
  void initState() {
    super.initState();
    widget.controller?._attach(this);
  }

  @override
  void didUpdateWidget(AppMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach(this);
      widget.controller?._attach(this);
      if (_ready) {
        widget.controller?._flush(this);
      }
    }
  }

  @override
  void dispose() {
    _idleTimer?.cancel();
    widget.controller?._detach(this);
    _camera.dispose();
    _map.dispose();
    super.dispose();
  }

  void _onMapReady() {
    _ready = true;
    widget.controller?._flush(this);
    _scheduleIdle();
  }

  /// Kamera hareketi (kullanıcı veya animasyon) [AppMap.cameraIdleDelay]
  /// boyunca durunca [AppMap.onCameraIdle] çağrılır; her karede istek
  /// atılmaz.
  Timer? _idleTimer;

  void _scheduleIdle() {
    final onIdle = widget.onCameraIdle;
    if (onIdle == null) {
      return;
    }
    _idleTimer?.cancel();
    _idleTimer = Timer(AppMap.cameraIdleDelay, () {
      if (mounted) {
        onIdle(_map.camera);
      }
    });
  }

  void _onCameraTick() => _cameraStep?.call(_camera.value);

  void _animateTo(
    LatLng center,
    double zoom, {
    Duration duration = AppDurations.verySlow,
  }) {
    final target = zoom.clamp(MapDefaults.minZoom, MapDefaults.maxZoom);
    final effective = context.motionDuration(duration);
    _camera.stop();
    if (effective == Duration.zero) {
      _map.move(center, target);
      return;
    }

    final start = _map.camera;
    final latitude = Tween(
      begin: start.center.latitude,
      end: center.latitude,
    ).chain(_panCurve);
    final longitude = Tween(
      begin: start.center.longitude,
      end: center.longitude,
    ).chain(_panCurve);
    // Önce kaydırılır, sonra yakınlaşılır: uzak noktalar arasında yüksek
    // yakınlaştırmada gereksiz tile indirilmez.
    final zoomTween = Tween(begin: start.zoom, end: target).chain(_zoomCurve);
    _cameraStep = (progress) => _map.move(
      LatLng(latitude.transform(progress), longitude.transform(progress)),
      zoomTween.transform(progress),
    );
    _camera
      ..duration = effective
      ..forward(from: 0);
  }

  void _fit(List<LatLng> points, EdgeInsets padding, double maxZoom) {
    if (points.isEmpty) {
      _animateTo(MapDefaults.turkeyCenter, MapDefaults.overviewZoom);
      return;
    }
    if (points.length == 1) {
      _animateTo(points.single, maxZoom);
      return;
    }
    final target = CameraFit.coordinates(
      coordinates: points,
      padding: padding,
      maxZoom: maxZoom,
    ).fit(_map.camera);
    _animateTo(target.center, target.zoom);
  }

  void _zoomBy(double delta) {
    final camera = _map.camera;
    _animateTo(
      camera.center,
      camera.zoom + delta,
      duration: AppDurations.normal,
    );
  }

  Widget _buildTiles(BuildContext context, MapTileSource source) {
    final colors = context.colors;
    final brightness = colors.brightness;
    final tiles = TileLayer(
      key: _tileLayerKey,
      urlTemplate: source.urlTemplateFor(brightness),
      userAgentPackageName: source.userAgentPackageName,
      tileProvider: _tileProvider,
      retinaMode:
          source.supportsRetina(brightness) &&
          RetinaMode.isHighDensity(context),
      tileDisplay: context.reduceMotion
          ? const TileDisplay.instantaneous()
          : const TileDisplay.fadeIn(),
      evictErrorTileStrategy: EvictErrorTileStrategy.notVisibleRespectMargin,
    );
    if (!source.usesDarkFilter(brightness)) {
      return tiles;
    }
    // Tüm katman için tek filtre (tile başına filtre katmanı oluşturulmaz).
    return ColorFiltered(
      colorFilter: duotoneTileFilter(
        shadow: colors.surface,
        highlight: colors.onSurfaceVariant,
      ),
      child: tiles,
    );
  }

  static const double _accuracyFillOpacity = 0.15;
  static const double _accuracyBorderOpacity = 0.5;

  List<Widget> _userLocationLayers(
    BuildContext context,
    MapUserLocation location,
  ) {
    final colors = context.colors;
    return [
      ExcludeSemantics(
        child: CircleLayer(
          circles: [
            CircleMarker(
              point: location.point,
              radius: location.accuracyMeters,
              useRadiusInMeter: true,
              color: colors.info.withValues(alpha: _accuracyFillOpacity),
              borderColor: colors.info.withValues(
                alpha: _accuracyBorderOpacity,
              ),
              borderStrokeWidth: AppSizes.borderThin,
            ),
          ],
        ),
      ),
      MarkerLayer(
        markers: [
          Marker(
            point: location.point,
            width: AppSizes.minTouchTarget,
            height: AppSizes.minTouchTarget,
            child: UserLocationMarker(
              key: const Key('map_user_location'),
              semanticsLabel: context.l10n.mapUserLocationSemantics,
            ),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final source = context.read<MapTileSource>();
    final interactive = widget.interactive;

    final map = FlutterMap(
      mapController: _map,
      options: MapOptions(
        initialCenter: widget.initialCenter,
        initialZoom: widget.initialZoom,
        minZoom: MapDefaults.minZoom,
        maxZoom: MapDefaults.maxZoom,
        cameraConstraint: CameraConstraint.containCenter(
          bounds: MapDefaults.region,
        ),
        backgroundColor: colors.surfaceVariant,
        interactionOptions: InteractionOptions(
          flags: interactive
              ? InteractiveFlag.all & ~InteractiveFlag.rotate
              : InteractiveFlag.none,
          // Ok tuşlarıyla kaydırma açık; harita odağı kendiliğinden almaz,
          // böylece ekran okuyucu ve klavye sırası korunur.
          keyboardOptions: interactive
              ? const KeyboardOptions(autofocus: false)
              : const KeyboardOptions.disabled(),
        ),
        onTap: widget.onBackgroundTap == null
            ? null
            : (_, _) => widget.onBackgroundTap!(),
        // Kullanıcı haritayı tuttuğunda kamera animasyonu onun hareketini
        // ezmez.
        onPointerDown: (_, _) => _camera.stop(),
        onPositionChanged: widget.onUserGesture == null
            ? null
            : (_, hasGesture) {
                if (hasGesture) {
                  widget.onUserGesture!();
                }
              },
        onMapReady: _onMapReady,
        onMapEvent: (_) => _scheduleIdle(),
      ),
      children: [
        // Haritanın adı etkileşimli yüzeyin (sürükle / dokun / klavye)
        // etiketidir; yüzeyin kendi semantik düğümüne katılır.
        if (widget.semanticsLabel case final label?)
          Semantics(label: label, child: const SizedBox.expand()),
        ExcludeSemantics(child: _buildTiles(context, source)),
        if (widget.routeLines.isNotEmpty)
          ExcludeSemantics(
            child: PolylineLayer(
              polylines: [
                for (final points in widget.routeLines)
                  Polyline(
                    points: points,
                    color: colors.primary,
                    strokeWidth: AppSizes.routeLine,
                    borderColor: colors.onPrimary,
                    borderStrokeWidth: AppSizes.borderThick,
                  ),
              ],
            ),
          ),
        if (widget.userLocation case final location?)
          ..._userLocationLayers(context, location),
        ...widget.layers,
        MarkerLayer(markers: widget.markers),
        if (widget.showAttribution)
          const Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: Padding(
              padding: EdgeInsetsDirectional.all(AppSpacing.xxs),
              child: MapAttribution(),
            ),
          ),
      ],
    );

    if (widget.semanticsLabel == null) {
      return ExcludeSemantics(child: map);
    }
    return Semantics(container: true, explicitChildNodes: true, child: map);
  }
}

/// Lisans gereği haritada sürekli görünen altlık atfı (OpenStreetMap ODbL).
///
/// Metin etkin altlık kaynağından ([MapTileSource]) gelir; kaldırılamaz,
/// yalnızca konumlandırılabilir.
class MapAttribution extends StatelessWidget {
  const MapAttribution({super.key});

  static const double _backdropOpacity = 0.9;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final attribution = context.read<MapTileSource>().attribution;
    // Kendi düğümüdür: haritanın etkileşimli yüzeyinin etiketiyle birleşmez.
    return Semantics(
      container: true,
      child: DecoratedBox(
        key: const Key('map_attribution'),
        decoration: BoxDecoration(
          color: colors.surface.withValues(alpha: _backdropOpacity),
          borderRadius: BorderRadius.circular(AppRadius.xs),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: AppSpacing.xxs,
          ),
          child: Text(
            attribution,
            style: context.textStyles.labelSmall.copyWith(
              color: colors.onSurface,
            ),
            semanticsLabel: context.l10n.mapAttributionSemantics(attribution),
          ),
        ),
      ),
    );
  }
}
