part of 'route_builder_bloc.dart';

enum RouteBuilderStatus { loading, ready, submitting, saved }

/// "Sırayı optimize et" sonucu (duyuru için).
@freezed
abstract class RouteOptimizationOutcome with _$RouteOptimizationOutcome {
  const factory RouteOptimizationOutcome({
    required double beforeMeters,
    required double afterMeters,

    /// Her optimizasyonda artar; aynı sonucun tekrar duyurulmasını sağlar.
    required int sequence,
  }) = _RouteOptimizationOutcome;

  const RouteOptimizationOutcome._();

  bool get changed => afterMeters < beforeMeters - 1;
}

@freezed
abstract class RouteBuilderState with _$RouteBuilderState {
  const factory RouteBuilderState({
    @Default(RouteBuilderStatus.loading) RouteBuilderStatus status,

    /// Duraklardaki eserlerin ad / il / konum bilgisi (arayüz dilinde).
    /// Tüm katalog indirilmez: seçiciden gelen kayıt saklanır, eksikler
    /// kimlikle tek istekte çözülür.
    @Default(<String, MonumentPin>{}) Map<String, MonumentPin> monuments,

    /// Sunucunun döndürmediği (katalogdan kaldırılmış) durak eserleri.
    @Default(<String>{}) Set<String> unavailableMonumentIds,
    String? languageCode,
    @Default(<RouteStopPlan>[]) List<RouteStopPlan> stops,
    @Default('') String name,

    /// Düzenlenen rota; yeni rotada `null`.
    String? routeId,

    /// İlk gönderim denemesinden sonra doğrulama mesajları gösterilir.
    @Default(false) bool showValidation,

    /// Geçersiz her gönderimde artar (aynı hatanın tekrar duyurulması).
    @Default(0) int invalidSubmissions,

    /// Durak sınırına ulaşılmışken eklenmek istendiğinde artar.
    @Default(0) int limitNotices,
    RouteOptimizationOutcome? optimization,
    Failure? loadFailure,
    Failure? saveFailure,
    TravelRoute? savedRoute,
  }) = _RouteBuilderState;

  const RouteBuilderState._();

  bool get isEditing => routeId != null;

  /// Düzenlenmek istenen rota sunucuda yok (silinmiş veya başka cihazın).
  bool get isRouteMissing => switch (loadFailure) {
    ServerFailure(kind: ServerFailureKind.notFound) => true,
    _ => false,
  };

  bool get isSubmitting => status == RouteBuilderStatus.submitting;

  bool get isFull => stops.length >= RoutePlanRules.maxStops;

  bool contains(String monumentId) =>
      stops.any((stop) => stop.monumentId == monumentId);

  MonumentPin? monument(String monumentId) => monuments[monumentId];

  /// Bilgisi henüz alınmamış durak eserleri.
  List<String> get unresolvedMonumentIds => [
    for (final stop in stops)
      if (!monuments.containsKey(stop.monumentId) &&
          !unavailableMonumentIds.contains(stop.monumentId))
        stop.monumentId,
  ];

  /// Yükleme hatası düzenlemeyi engelliyor mu (duraklar adsız kalır veya
  /// düzenlenecek rota alınamadı).
  bool get isBlockedByLoadFailure =>
      loadFailure != null &&
      (unresolvedMonumentIds.isNotEmpty || (isEditing && stops.isEmpty));

  /// Durakların konumları; bir durağın bilgisi veya konumu yoksa `null`.
  List<GeoPoint>? get stopLocations {
    final locations = <GeoPoint>[];
    for (final stop in stops) {
      final location = monument(stop.monumentId)?.location;
      if (location == null) {
        return null;
      }
      locations.add(location);
    }
    return locations;
  }

  /// Durak sırasıyla iller (önerilen ad ve özet için).
  List<String> get cities => [
    for (final stop in stops) ?monument(stop.monumentId)?.city,
  ];

  double get straightLineMeters {
    final locations = stopLocations;
    return locations == null
        ? 0
        : OptimizeStopOrderUseCase.pathLength(locations);
  }

  Duration get visitTotal =>
      stops.fold(Duration.zero, (total, stop) => total + stop.visit);

  Duration get breakTotal => stops.fold(
    Duration.zero,
    (total, stop) =>
        stop.breaks.fold(total, (sum, pause) => sum + pause.duration),
  );

  /// Ad boşsa [fallbackName] ile gönderilecek plan.
  RoutePlan planFor(String fallbackName) => RoutePlan(
    name: name.trim().isEmpty ? fallbackName : name.trim(),
    stops: stops,
  );

  /// Kullanıcıya gösterilecek ilk kural ihlali.
  RoutePlanError? validationError(String fallbackName) =>
      RoutePlanRules.validate(planFor(fallbackName));
}
