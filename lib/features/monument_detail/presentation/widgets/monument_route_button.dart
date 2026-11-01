import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';
import 'package:vakif_atlas/shared/widgets/molecules/app_snack_bar.dart';

/// Eserin yeni rota taslağındaki durumu.
///
/// Sayfa rota planlayıcıya bağımlı olmasın diye yalnızca değer ve geri
/// çağrılar taşır; taslağa bağlama yönlendiricide (kompozisyon kökü) yapılır.
@immutable
class MonumentRouteMembership {
  const MonumentRouteMembership({
    required this.isInRoute,
    required this.stopCount,
    required this.maxStops,
    required this.onToggle,
    required this.onOpenRoute,
  });

  final bool isInRoute;

  /// Taslaktaki eser sayısı (bu eser dahil).
  final int stopCount;
  final int maxStops;
  final VoidCallback onToggle;
  final VoidCallback onOpenRoute;

  bool get isFull => stopCount >= maxStops;
}

/// "Rotaya ekle" / "Rotadan çıkar". Sonuç SnackBar ile bildirilir;
/// eklemede SnackBar'dan taslağa geçilebilir.
class MonumentRouteButton extends StatelessWidget {
  const MonumentRouteButton({required this.membership, super.key});

  final MonumentRouteMembership membership;

  void _onPressed(BuildContext context) {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
    if (!membership.isInRoute && membership.isFull) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.routeLimitReached(membership.maxStops))),
      );
      return;
    }
    membership.onToggle();
    if (membership.isInRoute) {
      return;
    }
    messenger.showSnackBar(
      AppSnackBar.build(
        context,
        message: l10n.routeAddedSnack(membership.stopCount + 1),
        action: SnackBarAction(
          label: l10n.routeGoToDraft,
          onPressed: membership.onOpenRoute,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return membership.isInRoute
        ? AppButton.secondary(
            key: const Key('monument_route_button'),
            label: l10n.routeRemoveFromRoute,
            icon: Icons.remove_road,
            onPressed: () => _onPressed(context),
          )
        : AppButton.primary(
            key: const Key('monument_route_button'),
            label: l10n.routeAddToRoute,
            icon: Icons.add_road,
            onPressed: () => _onPressed(context),
          );
  }
}
