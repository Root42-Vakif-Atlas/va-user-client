import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/a11y/haptic_feedback_service.dart';
import 'package:vakif_atlas/core/a11y/reduce_motion.dart';
import 'package:vakif_atlas/core/l10n/failure_messages.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/location/location_service.dart';
import 'package:vakif_atlas/core/map/map_defaults.dart';
import 'package:vakif_atlas/core/map/map_tiles.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_durations.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/map_tile.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_detail.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';
import 'package:vakif_atlas/features/catalog/presentation/catalog_presentation.dart';
import 'package:vakif_atlas/features/map_discovery/presentation/bloc/map_discovery_bloc.dart';
import 'package:vakif_atlas/features/map_discovery/presentation/cubit/monument_tiles_cubit.dart';
import 'package:vakif_atlas/features/map_discovery/presentation/cubit/user_location_cubit.dart';
import 'package:vakif_atlas/features/map_discovery/presentation/pages/monument_search_page.dart';
import 'package:vakif_atlas/features/map_discovery/presentation/widgets/complex_footprint_layer.dart';
import 'package:vakif_atlas/features/map_discovery/presentation/widgets/map_location_button.dart';
import 'package:vakif_atlas/features/map_discovery/presentation/widgets/map_results_banner.dart';
import 'package:vakif_atlas/features/map_discovery/presentation/widgets/map_search_bar.dart';
import 'package:vakif_atlas/features/map_discovery/presentation/widgets/map_status_views.dart';
import 'package:vakif_atlas/features/map_discovery/presentation/widgets/monument_cluster_sheet.dart';
import 'package:vakif_atlas/features/map_discovery/presentation/widgets/monument_markers.dart';
import 'package:vakif_atlas/features/map_discovery/presentation/widgets/monument_preview_panel.dart';
import 'package:vakif_atlas/shared/widgets/molecules/map_control_surface.dart';
import 'package:vakif_atlas/shared/widgets/molecules/app_snack_bar.dart';
import 'package:vakif_atlas/shared/widgets/organisms/a11y_map_controls.dart';
import 'package:vakif_atlas/shared/widgets/organisms/app_map.dart';
import 'package:vakif_atlas/shared/widgets/organisms/user_location_marker.dart';

/// Ana harita: VGM vakıf eserleri pin olarak gösterilir, seçilen eserin
/// özeti haritanın altında açılır ve detay sayfasına geçilir.
///
/// Harita tam ekrandır; üstte hesap görseli, arama çubuğu ve filtre, sağda
/// yakınlaştırma ve konum kontrolleri yüzer. Arama ve filtre tek ekranda
/// (`MonumentSearchPage`) yapılır; sonuçlar haritaya uygulanabilir. İçerik
/// arayüz dilinde istenir; dil değiştiğinde eserler yeniden yüklenir.
/// Harita önizleme kartına eklenen, eser bağlamlı eylem (ör. kaydet).
typedef MapPreviewActionBuilder = Widget Function(
  BuildContext context,
  MonumentDetail monument,
);

class MapDiscoveryPage extends StatefulWidget {
  const MapDiscoveryPage({
    required this.onOpenMonument,
    required this.onOpenSearch,
    this.onOpenComplex,
    this.focusMonumentId,
    this.searchResult,
    this.accountButton,
    this.savedButton,
    this.previewActionBuilder,
    this.onOpenAccessibility,
    super.key,
  });

  final ValueChanged<String> onOpenMonument;

  /// Külliye detayı (ayrı görünüm). Verilmezse külliye de [onOpenMonument]
  /// ile açılır.
  final ValueChanged<String>? onOpenComplex;

  /// Arama ekranını [initial] sorguyla açar ve kullanıcının seçimini döner.
  final Future<MonumentSearchResult?> Function(MonumentSearchQuery initial)
  onOpenSearch;

  /// Derin bağlantıyla odaklanılması istenen eser (`/?monument=<id>`).
  final String? focusMonumentId;

  /// Başka bir sekmeden (Dijital Rehber) açılan aramanın haritaya dönen
  /// seçimi; her yeni değer bir kez uygulanır.
  final MonumentSearchResult? searchResult;

  /// Arama çubuğunun başında gösterilen hesap butonu.
  final Widget? accountButton;

  /// Arama çubuğunun sağındaki "Kaydedilenler" butonu. Sayfa kaydedilen
  /// eserler özelliğine bağımlı olmasın diye kompozisyon kökünde kurulur.
  final Widget? savedButton;

  /// Önizleme kartında kapat butonunun yanındaki eylem (kaydet).
  final MapPreviewActionBuilder? previewActionBuilder;

  /// Sol alttaki Erişilebilirlik butonu (konum butonunun karşısı); verilmezse
  /// gösterilmez.
  final VoidCallback? onOpenAccessibility;

  @override
  State<MapDiscoveryPage> createState() => _MapDiscoveryPageState();
}

class _MapDiscoveryPageState extends State<MapDiscoveryPage> {
  final AppMapController _map = AppMapController();
  String? _languageCode;
  bool _cameraPlaced = false;

  /// Panelin harita alanından alabileceği en yüksek pay; %200 metin
  /// ölçeğinde panel kendi içinde kaydırılır.
  static const double _panelMaxHeightFactor = 0.5;

  MapDiscoveryBloc get _bloc => context.read<MapDiscoveryBloc>();
  UserLocationCubit get _location => context.read<UserLocationCubit>();

  @override
  void initState() {
    super.initState();
    final focus = widget.focusMonumentId;
    if (focus != null) {
      _bloc.add(MapDiscoveryEvent.monumentSelected(focus));
    }
    final result = widget.searchResult;
    if (result != null) {
      // Eserler yüklenmeye başladıktan sonra uygulanır.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _applySearchResult(result);
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageCode = Localizations.localeOf(context).languageCode;
    if (languageCode != _languageCode) {
      _languageCode = languageCode;
      _bloc.add(MapDiscoveryEvent.loadRequested(languageCode: languageCode));
    }
    // Başka sekmeye geçildiğinde veya üstte tam ekran sayfa açıkken konum
    // akışı durur (pil).
    _location.setVisible(visible: TickerMode.valuesOf(context).enabled);
  }

  @override
  void didUpdateWidget(MapDiscoveryPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    final focus = widget.focusMonumentId;
    if (focus != null && focus != oldWidget.focusMonumentId) {
      _bloc.add(MapDiscoveryEvent.monumentSelected(focus));
    }
    final result = widget.searchResult;
    if (result != null && !identical(result, oldWidget.searchResult)) {
      _applySearchResult(result);
    }
  }

  /// Eserler kameraya sığdırılırken üstteki arama çubuğu ve yandaki kontrol
  /// sütununun örttüğü kenarlar boş bırakılır.
  EdgeInsets get _fitPadding => const EdgeInsetsDirectional.fromSTEB(
    AppSpacing.xl,
    AppSizes.mapSearchBar + AppSpacing.x4l,
    AppSizes.mapControl + AppSpacing.xl,
    AppSpacing.xl,
  ).resolve(Directionality.of(context));

  MonumentTilesCubit get _tiles => context.read<MonumentTilesCubit>();

  static const double _zoomEpsilon = 0.01;

  /// [bounds] alanını kameraya sığdırır.
  void _fit(GeoBounds? bounds, {double maxZoom = MapDefaults.focusZoom}) {
    if (bounds == null) {
      return;
    }
    // Tek noktaya inen alan (tek eser / aynı yapı): sığdırma yerine odak.
    if (bounds.isPoint) {
      _map.focus(bounds.center.toLatLng(), zoom: maxZoom);
      return;
    }
    _map.showAll(
      [LatLng(bounds.south, bounds.west), LatLng(bounds.north, bounds.east)],
      padding: _fitPadding,
      maxZoom: maxZoom,
    );
  }

  /// Haritada gösterilecek seçili eser: dokunulan pin veya önizleme detayı.
  static MonumentPin? _selectedPin(MapDiscoveryState state) {
    final detail = state.selection;
    return state.selectedPin ??
        (detail == null
            ? null
            : MonumentPin(
                id: detail.id,
                name: detail.name,
                category: detail.category,
                city: detail.city,
                district: detail.district,
                location: detail.location,
                complex: detail.complex,
                memberCount: detail.memberCount,
              ));
  }

  /// Külliye veya üyesi seçilince külliyenin açıldığı seviyeye
  /// yakınlaşılır: yerleşim alanı ve yapılar görünür.
  static double _focusZoom(MonumentPin? pin) =>
      pin != null && (pin.isComplex || pin.complex != null)
      ? MapTiles.complexExpandZoom.toDouble()
      : MapDefaults.focusZoom;

  void _openDetails(MonumentDetail monument) {
    final openComplex = widget.onOpenComplex;
    if (monument.isComplex && openComplex != null) {
      openComplex(monument.id);
    } else {
      widget.onOpenMonument(monument.id);
    }
  }

  /// Kapsam, sorgu veya dil değişince karolar yeniden istenir.
  void _configureTiles(MapDiscoveryState state) {
    final extent = state.extent;
    final languageCode = _languageCode;
    if (extent == null || languageCode == null) {
      return;
    }
    unawaited(
      _tiles.configure(
        version: extent.version,
        languageCode: languageCode,
        query: state.query,
      ),
    );
  }

  void _onCameraIdle(MapCamera camera) {
    final visible = camera.visibleBounds;
    unawaited(
      _tiles.viewportChanged(
        zoom: camera.zoom,
        bounds: GeoBounds(
          south: visible.south,
          west: visible.west,
          north: visible.north,
          east: visible.east,
        ),
      ),
    );
  }

  void _announce(String message, {bool assertive = false}) => unawaited(
    context.read<A11yAnnouncer>().announce(message, assertive: assertive),
  );

  HapticFeedbackService get _haptics => context.read<HapticFeedbackService>();

  // ---------------------------------------------------------------------
  // Eser durumu dinleyicileri
  // ---------------------------------------------------------------------

  void _onMonumentsLoaded(BuildContext context, MapDiscoveryState state) {
    _announce(context.l10n.mapLoadedAnnouncement(state.total));
    if (_cameraPlaced) {
      return;
    }
    _cameraPlaced = true;
    final selected = state.selectedLocation;
    if (selected != null) {
      _map.focus(selected.toLatLng(), zoom: _focusZoom(_selectedPin(state)));
    } else {
      _fit(state.extent?.bounds);
    }
  }

  /// Seçilen eserin konumu belli olunca (pinden hemen, aramadan / derin
  /// bağlantıdan önizleme gelince) kamera odaklanır ve duyurulur.
  void _onSelectionLocated(BuildContext context, MapDiscoveryState state) {
    final location = state.selectedLocation;
    final pin = _selectedPin(state);
    if (location == null || pin == null) {
      return;
    }
    _location.stopFollowing();
    _map.focus(location.toLatLng(), zoom: _focusZoom(pin));
    _announce(context.l10n.monumentSelectedAnnouncement(pin.name));
  }

  void _onSelectionNotFound(BuildContext context, MapDiscoveryState state) {
    final failure = state.selectionFailure;
    if (failure != null) {
      _showMessage(failure.toUserMessage(context.l10n));
    }
  }

  /// Sorgu veya filtre değişti: kamera eşleşen eserlere sığdırılır ve
  /// sonuç duyurulur.
  void _onRefinementChanged(BuildContext context, MapDiscoveryState state) {
    final l10n = context.l10n;
    final total = state.total;
    if (!state.isRefined) {
      _announce(l10n.mapRefinementsClearedAnnouncement);
    } else if (total == 0) {
      _announce(l10n.mapNoMatches);
    } else {
      _announce(l10n.mapResultsShowing(total));
    }
    if (total > 0 && state.selectedLocation == null) {
      _location.stopFollowing();
      _fit(state.extent?.bounds);
    }
  }

  void _onTilesFailed(BuildContext context, MonumentTilesState state) {
    final failure = state.failure;
    if (failure != null) {
      _showMessage(
        '${context.l10n.mapLoadErrorTitle}. ${failure.toUserMessage(context.l10n)}',
      );
    }
  }

  void _onFailure(BuildContext context, MapDiscoveryState state) {
    final failure = state.failure;
    if (failure == null) {
      return;
    }
    _announce(failure.toUserMessage(context.l10n), assertive: true);
    unawaited(_haptics.error());
  }

  // ---------------------------------------------------------------------
  // Konum dinleyicileri
  // ---------------------------------------------------------------------

  void _onCenterRequested(BuildContext context, UserLocationState state) {
    final position = state.position;
    if (position == null) {
      return;
    }
    final point = LatLng(position.latitude, position.longitude);
    if (!MapDefaults.region.contains(point)) {
      _location.stopFollowing();
      _showMessage(context.l10n.locationOutsideRegion);
      return;
    }
    _map.locate(point);
    _announce(context.l10n.mapLocationShownAnnouncement);
  }

  void _onPositionUpdated(BuildContext context, UserLocationState state) {
    final position = state.position;
    if (position == null) {
      return;
    }
    final point = LatLng(position.latitude, position.longitude);
    if (MapDefaults.region.contains(point)) {
      _map.panTo(point);
    }
  }

  void _onLocationIssue(BuildContext context, UserLocationState state) {
    final issue = state.issue;
    if (issue == null) {
      return;
    }
    final l10n = context.l10n;
    final message = switch (issue) {
      LocationIssue.serviceDisabled => l10n.locationIssueServiceDisabled,
      LocationIssue.permissionDenied => l10n.locationIssuePermissionDenied,
      LocationIssue.permissionDeniedForever =>
        l10n.locationIssuePermissionDeniedForever,
      LocationIssue.unavailable => l10n.locationIssueUnavailable,
    };
    unawaited(_haptics.warning());
    _showMessage(
      message,
      action: _location.canOpenSettings(issue)
          ? SnackBarAction(
              label: l10n.locationOpenSettings,
              onPressed: () => unawaited(_location.openSettings(issue)),
            )
          : null,
    );
  }

  void _showMessage(String message, {SnackBarAction? action}) {
    AppSnackBar.show(
      context,
      key: const Key('map_message_snackbar'),
      message: message,
      action: action,
    );
    _announce(message, assertive: true);
  }

  // ---------------------------------------------------------------------
  // Kullanıcı eylemleri
  // ---------------------------------------------------------------------

  void _selectFromPin(MonumentPin pin) {
    unawaited(_haptics.mapPinTap());
    _bloc.add(MapDiscoveryEvent.monumentSelected(pin.id, pin: pin));
  }

  /// Küme: üyelerinin sınırına yakınlaşılır (sunucu yeni seviyede alt
  /// kümeleri / eserleri döner). Sınırı tek noktaya inen (aynı konumdaki)
  /// küme yakınlaştırmayla ayrışmaz; liste açılır.
  ///
  /// Yakın zum'da (ör. külliye içinde birbirine çok yakın yapılar) sığdırma
  /// en az bir seviye yakınlaştırır, uzaklaştırmaz; en yakın seviyede hâlâ
  /// ayrışmayan küme de liste açar.
  void _onClusterSelected(MapTileCluster cluster) {
    unawaited(_haptics.mapPinTap());
    final zoom = _map.zoom;
    if (cluster.bounds.isPoint ||
        (zoom != null && zoom >= MapTiles.maxZoom - _zoomEpsilon)) {
      unawaited(_openClusterList(cluster));
      return;
    }
    _location.stopFollowing();
    final minimum = (MapTiles.singlesZoom + 1).toDouble();
    _fit(
      cluster.bounds,
      maxZoom: zoom == null || zoom + 1 <= minimum
          ? minimum
          : (zoom + 1).clamp(minimum, MapTiles.maxZoom.toDouble()),
    );
    _announce(context.l10n.mapClusterExpandedAnnouncement(cluster.count));
  }

  Future<void> _openClusterList(MapTileCluster cluster) async {
    final bloc = _bloc..add(MapDiscoveryEvent.clusterOpened(cluster.bounds));
    final id = await showModalBottomSheet<String>(
      context: context,
      sheetAnimationStyle: context.motionAnimationStyle,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      // Alt sayfa ayrı bir rotadır; BLoC açıkça aktarılır.
      builder: (sheetContext) => BlocProvider.value(
        value: bloc,
        child: BlocBuilder<MapDiscoveryBloc, MapDiscoveryState>(
          buildWhen: (previous, current) =>
              previous.clusterStatus != current.clusterStatus,
          builder: (context, state) => MonumentClusterSheet(
            pins: state.clusterMonuments,
            isLoading: state.clusterStatus == SelectionStatus.loading,
            hasError: state.clusterStatus == SelectionStatus.failure,
            onRetry: () =>
                bloc.add(MapDiscoveryEvent.clusterOpened(cluster.bounds)),
            onSelected: (id) => Navigator.of(sheetContext).pop(id),
          ),
        ),
      ),
    );
    if (id != null && mounted) {
      _bloc.add(MapDiscoveryEvent.monumentSelected(id));
    }
  }

  Future<void> _openSearch(MapDiscoveryState state) async {
    final result = await widget.onOpenSearch(state.query);
    if (result == null || !mounted) {
      return;
    }
    _applySearchResult(result);
  }

  void _applySearchResult(MonumentSearchResult result) {
    switch (result) {
      case MonumentSearchOpenDetails(:final monumentId, :final isComplex):
        _bloc.add(MapDiscoveryEvent.monumentSelected(monumentId));
        final openComplex = widget.onOpenComplex;
        if (isComplex && openComplex != null) {
          openComplex(monumentId);
        } else {
          widget.onOpenMonument(monumentId);
        }
      case MonumentSearchShowOnMap(:final monumentId):
        unawaited(_haptics.selection());
        _bloc.add(MapDiscoveryEvent.monumentSelected(monumentId));
      case MonumentSearchPlaceChosen(:final place):
        _showPlace(place);
      case MonumentSearchAppliedToMap(:final query):
        unawaited(_haptics.selection());
        _bloc
          ..add(const MapDiscoveryEvent.selectionCleared())
          ..add(MapDiscoveryEvent.refinementApplied(query));
    }
  }

  /// Bölge önerisi haritadaki daraltmanın yerini alır: tüm eserler
  /// gösterilir, kamera bölgeye sığdırılır.
  void _showPlace(MonumentPlace place) {
    _bloc.add(const MapDiscoveryEvent.selectionCleared());
    if (_bloc.state.isRefined) {
      _bloc.add(const MapDiscoveryEvent.refinementsCleared());
    }
    _location.stopFollowing();
    _fit(place.bounds);
    final l10n = context.l10n;
    final district = place.district;
    _announce(
      l10n.searchPlaceAnnouncement(
        district == null
            ? place.city
            : l10n.monumentLocation(district, place.city),
        place.count,
      ),
    );
  }

  void _onRefinementFailed(BuildContext context, MapDiscoveryState state) {
    final failure = state.refinementFailure;
    if (failure == null) {
      return;
    }
    _showMessage(
      '${context.l10n.mapRefinementFailed} ${failure.toUserMessage(context.l10n)}',
    );
  }

  void _retry() {
    final languageCode = _languageCode;
    if (languageCode != null) {
      _bloc.add(MapDiscoveryEvent.loadRequested(languageCode: languageCode));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Harita durum çubuğunun altına uzanır; simgeler tema zeminine göre
      // seçilir.
      value: colors.brightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: MultiBlocListener(
        listeners: [
          BlocListener<MapDiscoveryBloc, MapDiscoveryState>(
            listenWhen: (previous, current) =>
                current.status == MapDiscoveryStatus.success &&
                previous.status != MapDiscoveryStatus.success,
            listener: _onMonumentsLoaded,
          ),
          BlocListener<MapDiscoveryBloc, MapDiscoveryState>(
            listenWhen: (previous, current) =>
                current.selectedLocation != null &&
                (previous.selectedId != current.selectedId ||
                    previous.selectedLocation == null),
            listener: _onSelectionLocated,
          ),
          BlocListener<MapDiscoveryBloc, MapDiscoveryState>(
            listenWhen: (previous, current) =>
                current.selectedId == null &&
                current.selectionFailure != null &&
                previous.selectionFailure != current.selectionFailure,
            listener: _onSelectionNotFound,
          ),
          // Katalog sürümü, sorgu veya dil (yeniden yükleme) değişince
          // karolar yeniden istenir.
          BlocListener<MapDiscoveryBloc, MapDiscoveryState>(
            listenWhen: (previous, current) =>
                current.extent != null &&
                (previous.extent != current.extent ||
                    previous.query != current.query),
            listener: (_, state) => _configureTiles(state),
          ),
          BlocListener<MonumentTilesCubit, MonumentTilesState>(
            listenWhen: (previous, current) =>
                current.failure != null && previous.failure != current.failure,
            listener: _onTilesFailed,
          ),
          BlocListener<MapDiscoveryBloc, MapDiscoveryState>(
            listenWhen: (previous, current) =>
                current.status == MapDiscoveryStatus.success &&
                previous.query != current.query,
            listener: _onRefinementChanged,
          ),
          BlocListener<MapDiscoveryBloc, MapDiscoveryState>(
            listenWhen: (previous, current) =>
                current.refinementFailure != null &&
                previous.refinementFailure != current.refinementFailure,
            listener: _onRefinementFailed,
          ),
          BlocListener<MapDiscoveryBloc, MapDiscoveryState>(
            listenWhen: (previous, current) =>
                current.status == MapDiscoveryStatus.failure &&
                previous.status != MapDiscoveryStatus.failure,
            listener: _onFailure,
          ),
          BlocListener<UserLocationCubit, UserLocationState>(
            listenWhen: (previous, current) =>
                previous.centerRequest != current.centerRequest,
            listener: _onCenterRequested,
          ),
          BlocListener<UserLocationCubit, UserLocationState>(
            listenWhen: (previous, current) =>
                current.following &&
                previous.centerRequest == current.centerRequest &&
                previous.position != current.position,
            listener: _onPositionUpdated,
          ),
          BlocListener<UserLocationCubit, UserLocationState>(
            listenWhen: (previous, current) =>
                current.issue != null && previous.issue != current.issue,
            listener: _onLocationIssue,
          ),
        ],
        child: BlocBuilder<MapDiscoveryBloc, MapDiscoveryState>(
          builder: (context, state) => Scaffold(
            body: Semantics(
              namesRoute: true,
              label: context.l10n.mapDiscoveryTitle,
              explicitChildNodes: true,
              child: LayoutBuilder(
                builder: (context, constraints) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: _buildMap(context, state)),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight:
                            constraints.maxHeight * _panelMaxHeightFactor,
                      ),
                      child: _BottomPanel(
                        state: state,
                        onClose: () => _bloc.add(
                          const MapDiscoveryEvent.selectionCleared(),
                        ),
                        onViewDetails: _openDetails,
                        onOpenComplex: widget.onOpenComplex,
                        actionBuilder: widget.previewActionBuilder,
                        onRetry: _retry,
                        onRetrySelection: () => _bloc.add(
                          const MapDiscoveryEvent.selectionRetryRequested(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMap(BuildContext context, MapDiscoveryState state) {
    final l10n = context.l10n;

    return Stack(
      children: [
        Positioned.fill(
          child: BlocBuilder<UserLocationCubit, UserLocationState>(
            buildWhen: (previous, current) =>
                previous.position != current.position,
            builder: (context, location) {
              final position = location.position;
              final tiles = context.watch<MonumentTilesCubit>().state;
              return AppMap(
                key: const Key('map_discovery_map'),
                controller: _map,
                semanticsLabel: l10n.mapSemanticsLabel(state.total),
                layers: [
                  ComplexFootprintLayer(
                    complexes: tiles.complexes,
                    selectedId: state.selectedId,
                    onSelected: _selectFromPin,
                  ),
                  MonumentClusterLayer(
                    items: tiles.items,
                    expandedComplexIds: {
                      for (final complex in tiles.complexes) complex.pin.id,
                    },
                    selected: _selectedPin(state),
                    onPinSelected: _selectFromPin,
                    onClusterSelected: _onClusterSelected,
                  ),
                ],
                onCameraIdle: _onCameraIdle,
                userLocation: position == null
                    ? null
                    : MapUserLocation(
                        point: LatLng(position.latitude, position.longitude),
                        accuracyMeters: position.accuracyMeters,
                      ),
                // Atıf kontrol sütununun altında, konum butonuyla aynı sağ
                // kenarda çizilir (aşağıda).
                showAttribution: false,
                onBackgroundTap: state.selectedId == null
                    ? null
                    : () =>
                          _bloc.add(const MapDiscoveryEvent.selectionCleared()),
                onUserGesture: _location.stopFollowing,
              );
            },
          ),
        ),
        Positioned.fill(
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.xs,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      if (widget.accountButton case final account?) ...[
                        account,
                        const SizedBox(width: AppSpacing.sm),
                      ],
                      Expanded(
                        child: MapSearchBar(
                          query: state.query.normalizedText,
                          activeFilterCount: state.query.filter.activeCount,
                          onOpenSearch: () => _openSearch(state),
                          onClearQuery: () => _bloc.add(
                            MapDiscoveryEvent.refinementApplied(
                              state.query.withText(''),
                            ),
                          ),
                          // Filtreler arama ekranındadır.
                          onOpenFilters: () => _openSearch(state),
                        ),
                      ),
                      if (widget.savedButton case final saved?) ...[
                        const SizedBox(width: AppSpacing.sm),
                        saved,
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (state.isRefined &&
                                      state.status ==
                                          MapDiscoveryStatus.success)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: AppSpacing.xs,
                                      ),
                                      child: MapResultsBanner(
                                        key: const Key('map_results_banner'),
                                        visibleCount: state.total,
                                        onClear: () => _bloc.add(
                                          const MapDiscoveryEvent.refinementsCleared(),
                                        ),
                                      ),
                                    ),
                                  if (state.isLoading ||
                                      state.isRefining ||
                                      context.select(
                                        (MonumentTilesCubit c) =>
                                            c.state.isLoading,
                                      ))
                                    const MapLoadingBadge(),
                                ],
                              ),
                              if (widget.onOpenAccessibility case final open?)
                                Align(
                                  alignment: AlignmentDirectional.bottomStart,
                                  child: MapControlButton(
                                    key: const Key('map_accessibility_button'),
                                    tooltip:
                                        context.l10n.mapAccessibilityButton,
                                    icon: Icons.accessibility_new,
                                    // Konum butonuyla aynı (birincil) renk.
                                    primary: true,
                                    circle: true,
                                    onPressed: open,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        _EndControls(
                          zoomControls: A11yMapControls(
                            onZoomIn: _map.zoomIn,
                            onZoomOut: _map.zoomOut,
                            onShowAll: () {
                              _location.stopFollowing();
                              _fit(state.extent?.bounds);
                            },
                          ),
                          locationButton: const MapLocationButton(),
                        ),
                      ],
                    ),
                  ),
                  // ODbL atfı kaldırılamaz; konum butonunun altında, aynı
                  // sağ kenara yaslı ve hiçbir kontrolün örtmediği yerde.
                  const SizedBox(height: AppSpacing.xs),
                  const Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: MapAttribution(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Sağ kenardaki kontrol sütunu: üstte yakınlaştırma, altta konum.
///
/// Butonlar metin ölçeğinden bağımsız sabit boyutludur; harita alanı
/// sütunun doğal yüksekliğinden kısaysa (%200 metin ölçeği + açık önizleme)
/// sütun taşmak yerine kaydırılır. Yeterli alanda kaydırma katmanı eklenmez,
/// böylece sütun arasındaki boşlukta harita sürüklenebilir.
class _EndControls extends StatelessWidget {
  const _EndControls({
    required this.zoomControls,
    required this.locationButton,
  });

  final Widget zoomControls;
  final Widget locationButton;

  /// Yakınlaştır, uzaklaştır, tümünü göster, aralarındaki çizgiler, boşluk
  /// ve konum butonu.
  static const double _naturalHeight =
      AppSizes.mapControl * 4 + AppSizes.borderThin * 2 + AppSpacing.sm;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxHeight >= _naturalHeight) {
          return Column(
            children: [zoomControls, const Spacer(), locationButton],
          );
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              zoomControls,
              const SizedBox(height: AppSpacing.sm),
              locationButton,
            ],
          ),
        );
      },
    );
  }
}

/// Haritanın altındaki alan: seçili eserin özeti veya yükleme hatası.
class _BottomPanel extends StatelessWidget {
  const _BottomPanel({
    required this.state,
    required this.onClose,
    required this.onViewDetails,
    required this.onOpenComplex,
    required this.onRetry,
    required this.onRetrySelection,
    required this.actionBuilder,
  });

  final MapPreviewActionBuilder? actionBuilder;
  final MapDiscoveryState state;
  final VoidCallback onClose;
  final ValueChanged<MonumentDetail> onViewDetails;
  final ValueChanged<String>? onOpenComplex;
  final VoidCallback onRetry;
  final VoidCallback onRetrySelection;

  @override
  Widget build(BuildContext context) {
    final selection = state.selection;
    final selectedId = state.selectedId;
    final failure = state.failure;
    final Widget content;
    if (selectedId != null &&
        state.selectionStatus == SelectionStatus.success &&
        selection != null) {
      // Kart kendi gövdesini kaydırır; başlık ve aksiyon görünür kalır.
      content = MonumentPreviewPanel(
        key: ValueKey('preview_${selection.id}'),
        monument: selection,
        onClose: onClose,
        onViewDetails: () => onViewDetails(selection),
        onOpenComplex: onOpenComplex,
        action: actionBuilder?.call(context, selection),
      );
    } else if (selectedId != null &&
        state.selectionStatus != SelectionStatus.none) {
      content = MonumentPreviewStatus(
        key: ValueKey('preview_status_$selectedId'),
        name: state.selectedPin?.name,
        failure: state.selectionStatus == SelectionStatus.failure
            ? state.selectionFailure
            : null,
        onRetry: onRetrySelection,
        onClose: onClose,
      );
    } else if (state.status == MapDiscoveryStatus.failure && failure != null) {
      content = SingleChildScrollView(
        key: const ValueKey('map_load_error'),
        child: MapLoadErrorPanel(
          key: const Key('map_load_error_panel'),
          failure: failure,
          onRetry: onRetry,
        ),
      );
    } else {
      content = const SizedBox.shrink(key: Key('map_bottom_panel_empty'));
    }

    final duration = context.motionDuration(AppDurations.normal);
    final switcher = AnimatedSwitcher(duration: duration, child: content);
    return SafeArea(
      top: false,
      // Hareket azaltmada boyut geçişi yapılmaz (sıfır süreli AnimatedSize
      // yerleşim sırasında kendini yeniden kirletir).
      child: duration == Duration.zero
          ? switcher
          : AnimatedSize(
              duration: duration,
              alignment: Alignment.topCenter,
              child: switcher,
            ),
    );
  }
}
