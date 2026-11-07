import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/nearby_alerts/presentation/cubit/nearby_alerts_cubit.dart';
import 'package:vakif_atlas/features/settings/presentation/cubit/app_settings_cubit.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';
import 'package:vakif_atlas/shared/widgets/atoms/leading_icon_tile.dart';
import 'package:vakif_atlas/shared/widgets/molecules/app_snack_bar.dart';
import 'package:vakif_atlas/shared/widgets/molecules/grouped_section.dart';
import 'package:vakif_atlas/shared/widgets/molecules/inline_message.dart';

/// Ayarlar → Bildirimler: yakındaki eser bildirimlerini açar / kapatır.
///
/// İzinler yalnızca anahtar açılırken istenir (bağlamsal izin). Kullanıcı
/// izni reddederse anahtar kapalı kalır ve sistem ayarlarına giden eylem
/// sunulur. Ayar açıkken izin sonradan sistemden kapatılırsa durum ve
/// çözümü anahtarın altında gösterilir. Platformda desteklenmiyorsa
/// (web, masaüstü) hiçbir şey çizilmez.
///
/// `NearbyAlertsCubit` ve `AppSettingsCubit` üst ağaçtan sağlanır.
class NearbyAlertsSetting extends StatefulWidget {
  const NearbyAlertsSetting({super.key});

  @override
  State<NearbyAlertsSetting> createState() => _NearbyAlertsSettingState();
}

class _NearbyAlertsSettingState extends State<NearbyAlertsSetting> {
  /// İzin pencereleri açıkken anahtar devre dışıdır (çift dokunma).
  bool _requesting = false;

  Future<void> _onChanged(bool enabled) async {
    final settings = context.read<AppSettingsCubit>();
    final alerts = context.read<NearbyAlertsCubit>();
    final l10n = context.l10n;
    if (!enabled) {
      await settings.setNearbyAlerts(enabled: false);
      await alerts.clearHistory();
      if (mounted) {
        AppSnackBar.show(context, message: l10n.nearbyAlertsDisabled);
      }
      return;
    }
    setState(() => _requesting = true);
    final activation = await alerts.requestActivation();
    if (!mounted) {
      return;
    }
    setState(() => _requesting = false);
    switch (activation) {
      case NearbyAlertsActivation.granted:
        await settings.setNearbyAlerts(enabled: true);
        if (mounted) {
          AppSnackBar.show(context, message: l10n.nearbyAlertsEnabled);
        }
      case NearbyAlertsActivation.notificationsDenied:
        _showBlocked(NearbyAlertsStatus.notificationsBlocked);
      case NearbyAlertsActivation.locationDenied:
        _showBlocked(NearbyAlertsStatus.locationBlocked);
      case NearbyAlertsActivation.unsupported:
        break;
    }
  }

  void _showBlocked(NearbyAlertsStatus status) {
    final l10n = context.l10n;
    final alerts = context.read<NearbyAlertsCubit>();
    AppSnackBar.show(
      context,
      message: _blockedMessage(l10n, status),
      action: alerts.canOpenSettings(status)
          ? SnackBarAction(
              label: l10n.nearbyAlertsOpenSettings,
              onPressed: () => unawaited(alerts.openSettings(status)),
            )
          : null,
    );
  }

  static String _blockedMessage(
    AppLocalizations l10n,
    NearbyAlertsStatus status,
  ) => status == NearbyAlertsStatus.notificationsBlocked
      ? l10n.nearbyAlertsNotificationsBlocked
      : l10n.nearbyAlertsLocationBlocked;

  @override
  Widget build(BuildContext context) {
    final alerts = context.read<NearbyAlertsCubit>();
    if (!alerts.isSupported) {
      return const SizedBox.shrink();
    }
    final l10n = context.l10n;
    final enabled = context.select<AppSettingsCubit, bool>(
      (cubit) => cubit.state.settings.nearbyAlerts,
    );
    final status = context.watch<NearbyAlertsCubit>().state;
    final blocked =
        enabled &&
        (status == NearbyAlertsStatus.notificationsBlocked ||
            status == NearbyAlertsStatus.locationBlocked);

    return GroupedSection(
      children: [
        SwitchListTile(
          key: const Key('settings_nearby_alerts_switch'),
          secondary: const LeadingIconTile(
            icon: Icons.notifications_active_outlined,
            tone: LeadingIconTone.heritage,
          ),
          title: Text(l10n.nearbyAlertsSettingTitle),
          // Açıkken arka plan göstergesi önceden açıklanır: kalıcı
          // bildirim / konum göstergesi kullanıcıyı şaşırtmasın.
          subtitle: Text(
            enabled && !blocked
                ? '${l10n.nearbyAlertsSettingDescription}\n\n'
                      '${l10n.nearbyAlertsBackgroundNote}'
                : l10n.nearbyAlertsSettingDescription,
          ),
          value: enabled,
          onChanged: _requesting
              ? null
              : (value) => unawaited(_onChanged(value)),
        ),
        if (blocked)
          Padding(
            key: const Key('settings_nearby_alerts_blocked'),
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InlineMessage(
                  type: InlineMessageType.warning,
                  message: _blockedMessage(l10n, status),
                ),
                if (alerts.canOpenSettings(status)) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: AppButton.secondary(
                      key: const Key('settings_nearby_alerts_open_settings'),
                      label: l10n.nearbyAlertsOpenSettings,
                      icon: Icons.open_in_new,
                      onPressed: () => unawaited(alerts.openSettings(status)),
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
