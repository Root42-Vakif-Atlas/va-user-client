import 'package:vakif_atlas/core/utils/list_equality.dart';

/// Mola türü ve önerilen varsayılan süresi.
enum RouteBreakKind {
  shortBreak(Duration(minutes: 15)),
  meal(Duration(minutes: 45)),
  rest(Duration(hours: 2)),

  /// Uzun şehirler arası rotalarda gece konaklaması.
  overnight(Duration(hours: 10));

  const RouteBreakKind(this.defaultDuration);

  final Duration defaultDuration;
}

/// Bir durağın ardından verilen mola.
final class RouteBreak {
  const RouteBreak({required this.kind, required this.duration});

  RouteBreak.ofKind(this.kind) : duration = kind.defaultDuration;

  final RouteBreakKind kind;
  final Duration duration;

  RouteBreak copyWith({RouteBreakKind? kind, Duration? duration}) =>
      RouteBreak(kind: kind ?? this.kind, duration: duration ?? this.duration);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RouteBreak && other.kind == kind && other.duration == duration;

  @override
  int get hashCode => Object.hash(kind, duration);
}

/// Oluşturulacak / güncellenecek rotadaki durak: eser, ziyaret süresi ve
/// ardından verilen molalar.
final class RouteStopPlan {
  RouteStopPlan({
    required this.monumentId,
    this.visit = RoutePlanRules.defaultVisit,
    List<RouteBreak> breaks = const [],
  }) : breaks = List.unmodifiable(breaks);

  final String monumentId;
  final Duration visit;
  final List<RouteBreak> breaks;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RouteStopPlan &&
          other.monumentId == monumentId &&
          other.visit == visit &&
          elementsEqual(other.breaks, breaks);

  @override
  int get hashCode => Object.hash(monumentId, visit, Object.hashAll(breaks));
}

/// Sunucuya gönderilen rota tanımı. Mesafe, yolculuk süresi ve yol
/// geometrisini sunucu (Rota mikro servisi) hesaplar.
final class RoutePlan {
  RoutePlan({required this.name, required List<RouteStopPlan> stops})
    : stops = List.unmodifiable(stops);

  final String name;
  final List<RouteStopPlan> stops;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoutePlan &&
          other.name == name &&
          elementsEqual(other.stops, stops);

  @override
  int get hashCode => Object.hash(name, Object.hashAll(stops));
}

enum RoutePlanError {
  emptyName,
  nameTooLong,
  tooFewStops,
  tooManyStops,
  duplicateStop,
  visitOutOfRange,
  tooManyBreaks,
  breakOutOfRange,
}

/// Rota tanımının iş kuralları. İstemci kullanıcıya erken geri bildirim
/// için, sunucu ise yetkili doğrulama için aynı kuralları uygular.
abstract final class RoutePlanRules {
  static const int minStops = 2;
  static const int maxStops = 10;
  static const int maxNameLength = 60;
  static const int maxBreaksPerStop = 3;

  static const Duration defaultVisit = Duration(hours: 1);
  static const Duration minVisit = Duration(minutes: 15);
  static const Duration maxVisit = Duration(hours: 8);
  static const Duration minBreak = Duration(minutes: 15);
  static const Duration maxBreak = Duration(hours: 12);

  /// Süre ayarlayıcılarının adımı.
  static const Duration durationStep = Duration(minutes: 15);

  /// İlk ihlal edilen kural; plan geçerliyse `null`.
  static RoutePlanError? validate(RoutePlan plan) {
    final name = plan.name.trim();
    if (name.isEmpty) {
      return RoutePlanError.emptyName;
    }
    if (name.length > maxNameLength) {
      return RoutePlanError.nameTooLong;
    }
    if (plan.stops.length < minStops) {
      return RoutePlanError.tooFewStops;
    }
    if (plan.stops.length > maxStops) {
      return RoutePlanError.tooManyStops;
    }
    final ids = {for (final stop in plan.stops) stop.monumentId};
    if (ids.length != plan.stops.length) {
      return RoutePlanError.duplicateStop;
    }
    for (final stop in plan.stops) {
      if (stop.visit < minVisit || stop.visit > maxVisit) {
        return RoutePlanError.visitOutOfRange;
      }
      if (stop.breaks.length > maxBreaksPerStop) {
        return RoutePlanError.tooManyBreaks;
      }
      for (final pause in stop.breaks) {
        if (pause.duration < minBreak || pause.duration > maxBreak) {
          return RoutePlanError.breakOutOfRange;
        }
      }
    }
    return null;
  }

  /// [value] süresini [min, max] aralığına ve adıma oturtur.
  static Duration clampToStep(Duration value, Duration min, Duration max) {
    final step = durationStep.inMinutes;
    final snapped = (value.inMinutes / step).round() * step;
    return Duration(minutes: snapped.clamp(min.inMinutes, max.inMinutes));
  }
}
