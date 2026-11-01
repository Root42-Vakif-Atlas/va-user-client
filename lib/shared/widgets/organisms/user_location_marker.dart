import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_shadows.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';

/// Haritada gösterilecek kullanıcı konumu.
@immutable
final class MapUserLocation {
  const MapUserLocation({required this.point, required this.accuracyMeters});

  final LatLng point;

  /// Doğruluk dairesinin yarıçapı (metre).
  final double accuracyMeters;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MapUserLocation &&
          other.point == point &&
          other.accuracyMeters == accuracyMeters;

  @override
  int get hashCode => Object.hash(point, accuracyMeters);
}

/// "Konumunuz" noktası: tema bilgi rengi dolgu, zemin rengi halka ve
/// her altlıkta ≥ 3:1 ayrışan dış kontur (WCAG 1.4.11).
///
/// Etkileşimli değildir; ekran okuyucu yalnızca [semanticsLabel]'ı okur.
class UserLocationMarker extends StatelessWidget {
  const UserLocationMarker({required this.semanticsLabel, super.key});

  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      container: true,
      label: semanticsLabel,
      excludeSemantics: true,
      child: Center(
        child: Container(
          width: AppSizes.userLocationDot,
          height: AppSizes.userLocationDot,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.info,
            border: Border.all(
              color: colors.surface,
              width: AppSizes.borderHeavy,
            ),
            boxShadow: [
              BoxShadow(
                color: colors.onSurface,
                spreadRadius: AppSizes.borderThin,
              ),
              ...AppShadows.cardShadow,
            ],
          ),
        ),
      ),
    );
  }
}
