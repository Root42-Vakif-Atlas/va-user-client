import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/a11y/haptic_feedback_service.dart';
import 'package:vakif_atlas/core/a11y/reduce_motion.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/map_discovery/presentation/cubit/user_location_cubit.dart';
import 'package:vakif_atlas/shared/widgets/molecules/map_control_surface.dart';

/// "Konumumu göster" butonu (birincil renk, daire).
///
/// - Takip açıkken dolu, değilken boş ok ikonu; ekran okuyucuya aç/kapa
///   durumu olarak bildirilir.
/// - Konum alınırken buton yükleme göstergesi taşır ve "Konumunuz alınıyor"
///   olarak okunur (hareket azaltmada dönmeyen ikon).
/// - Platformda konum yoksa hiç gösterilmez.
class MapLocationButton extends StatelessWidget {
  const MapLocationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserLocationCubit, UserLocationState>(
      buildWhen: (previous, current) =>
          previous.isSupported != current.isSupported ||
          previous.status != current.status ||
          previous.following != current.following,
      builder: (context, state) {
        if (!state.isSupported) {
          return const SizedBox.shrink();
        }
        final l10n = context.l10n;
        final colors = context.colors;
        final locating = state.status == UserLocationStatus.locating;
        return MapControlButton(
          key: const Key('map_locate_button'),
          tooltip: locating ? l10n.mapLocating : l10n.mapLocateMe,
          primary: true,
          circle: true,
          toggled: state.following,
          onPressed: locating
              ? null
              : () {
                  unawaited(context.read<HapticFeedbackService>().selection());
                  unawaited(context.read<UserLocationCubit>().locate());
                },
          child: locating
              ? (context.reduceMotion
                    ? Icon(Icons.hourglass_top, color: colors.onPrimary)
                    : SizedBox.square(
                        dimension: AppSizes.spinner,
                        child: CircularProgressIndicator(
                          strokeWidth: AppSizes.spinnerStroke,
                          color: colors.onPrimary,
                        ),
                      ))
              : Icon(
                  state.following ? Icons.near_me : Icons.near_me_outlined,
                  color: colors.onPrimary,
                ),
        );
      },
    );
  }
}
