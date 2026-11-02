import 'package:flutter/widgets.dart';
import 'package:vakif_atlas/core/theme/tokens/app_durations.dart';

/// Cihazda "animasyonları azalt" ayarı açıksa animasyon süresini sıfırlar
/// (WCAG 2.3.3).
extension ReduceMotion on BuildContext {
  bool get reduceMotion => MediaQuery.disableAnimationsOf(this);

  /// Alt sayfa, diyalog ve seçici açılışlarında kullanılacak animasyon stili:
  /// hareket azaltma etkinse animasyonsuz, değilse Flutter varsayılanı
  /// (`null`). Bu açılışlar `MediaQuery.disableAnimations`'a bakmaz; uygulama
  /// içi "Animasyonları durdur" tercihinin onları da durdurması için gerekir.
  AnimationStyle? get motionAnimationStyle =>
      reduceMotion ? AnimationStyle.noAnimation : null;

  /// [duration] veya hareket azaltma etkinse [AppDurations.instant].
  Duration motionDuration(Duration duration) =>
      reduceMotion ? AppDurations.instant : duration;
}

/// `State` sınıflarında hareket azaltma kontrolü için mixin.
mixin ReduceMotionMixin<T extends StatefulWidget> on State<T> {
  bool get reduceMotion => context.reduceMotion;

  Duration motionDuration(Duration duration) =>
      context.motionDuration(duration);
}
