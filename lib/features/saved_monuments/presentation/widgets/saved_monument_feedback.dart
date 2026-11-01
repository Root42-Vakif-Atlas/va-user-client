import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/features/saved_monuments/domain/entities/saved_monument.dart';
import 'package:vakif_atlas/features/saved_monuments/presentation/cubit/saved_monuments_cubit.dart';
import 'package:vakif_atlas/shared/widgets/molecules/app_snack_bar.dart';

/// Eseri kaydeder veya kaydedilenlerden çıkarır ve sonucu SnackBar ile
/// bildirir (SnackBar canlı bölgedir, ekran okuyucu okur). Kaydetmede
/// SnackBar'dan listeye ([onOpenSaved]), çıkarmada geri almaya geçilebilir.
Future<void> toggleSavedMonument(
  BuildContext context, {
  required SavedMonumentsCubit cubit,
  required String monumentId,
  required String monumentName,
  VoidCallback? onOpenSaved,
}) async {
  final l10n = context.l10n;
  final messenger = ScaffoldMessenger.of(context);
  final accessibleNavigation = MediaQuery.accessibleNavigationOf(context);
  final previous = cubit.state.find(monumentId);
  final outcome = await cubit.toggle(monumentId);
  final (String message, SnackBarAction? action) = switch (outcome) {
    SavedToggleOutcome.saved => (
      l10n.savedMonumentAdded(monumentName),
      onOpenSaved == null
          ? null
          : SnackBarAction(
              label: l10n.savedMonumentsTitle,
              onPressed: onOpenSaved,
            ),
    ),
    SavedToggleOutcome.removed => (
      l10n.savedMonumentRemoved(monumentName),
      previous == null ? null : _undo(l10n, cubit, previous),
    ),
    SavedToggleOutcome.limitReached => (
      l10n.savedMonumentsLimit(SavedMonumentRules.maxSaved),
      null,
    ),
    SavedToggleOutcome.failed => (l10n.savedMonumentsSaveFailed, null),
  };
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      AppSnackBar.create(
        accessibleNavigation: accessibleNavigation,
        message: message,
        action: action,
      ),
    );
}

SnackBarAction _undo(
  AppLocalizations l10n,
  SavedMonumentsCubit cubit,
  SavedMonument previous,
) => SnackBarAction(
  label: l10n.commonUndo,
  onPressed: () => cubit.restore(previous),
);
