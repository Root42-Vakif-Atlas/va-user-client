import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vakif_atlas/core/l10n/failure_messages.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/catalog/presentation/catalog_presentation.dart';
import 'package:vakif_atlas/features/saved_monuments/presentation/cubit/saved_monuments_cubit.dart';
import 'package:vakif_atlas/features/saved_monuments/presentation/cubit/saved_monuments_list_cubit.dart';
import 'package:vakif_atlas/features/saved_monuments/presentation/widgets/saved_monument_feedback.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/atoms/leading_icon_tile.dart';
import 'package:vakif_atlas/shared/widgets/templates/loading_status_view.dart';
import 'package:vakif_atlas/shared/widgets/templates/status_message_view.dart';

/// Kaydedilenler (`/saved`): cihazda kaydedilen eserler, en yeni önce.
///
/// Satıra dokunmak eser detayını açar; her satırda "Haritada göster" ve
/// "Kaldır" (geri alınabilir) vardır. `SavedMonumentsListCubit` ve uygulama
/// genelindeki `SavedMonumentsCubit` üst ağaçtan sağlanır.
class SavedMonumentsPage extends StatefulWidget {
  const SavedMonumentsPage({
    required this.onOpenMonument,
    required this.onShowOnMap,
    required this.onExplore,
    super.key,
  });

  final ValueChanged<String> onOpenMonument;
  final ValueChanged<String> onShowOnMap;

  /// Boş listede "Haritada keşfet".
  final VoidCallback onExplore;

  @override
  State<SavedMonumentsPage> createState() => _SavedMonumentsPageState();
}

class _SavedMonumentsPageState extends State<SavedMonumentsPage> {
  String? _languageCode;

  SavedMonumentsListCubit get _list => context.read<SavedMonumentsListCubit>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // İçerik arayüz dilinde çözülür; dil değişince yeniden yüklenir.
    final languageCode = Localizations.localeOf(context).languageCode;
    if (languageCode != _languageCode) {
      _languageCode = languageCode;
      unawaited(_list.load(languageCode: languageCode));
    }
  }

  void _remove(SavedMonumentEntry entry) {
    final l10n = context.l10n;
    unawaited(
      toggleSavedMonument(
        context,
        cubit: context.read<SavedMonumentsCubit>(),
        monumentId: entry.saved.monumentId,
        monumentName: entry.pin?.name ?? l10n.savedMonumentUnavailable,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.savedMonumentsTitle)),
      body: BlocBuilder<SavedMonumentsListCubit, SavedMonumentsListState>(
        builder: (context, state) => switch (state) {
          SavedMonumentsListState(
            status: SavedMonumentsListStatus.loading,
            :final entries,
          )
              when entries.isEmpty =>
            LoadingStatusView(label: l10n.savedMonumentsTitle),
          SavedMonumentsListState(
            status: SavedMonumentsListStatus.failure,
            :final failure,
          ) =>
            StatusMessageView(
              key: const Key('saved_monuments_error'),
              tone: StatusMessageTone.error,
              icon: Icons.bookmarks_outlined,
              title: l10n.savedMonumentsLoadFailedTitle,
              message: failure?.toUserMessage(l10n) ?? '',
              actionLabel: l10n.commonRetry,
              onAction: () => unawaited(
                _list.load(languageCode: _languageCode ?? l10n.localeName),
              ),
            ),
          SavedMonumentsListState(:final entries) when entries.isEmpty =>
            StatusMessageView(
              key: const Key('saved_monuments_empty'),
              icon: Icons.bookmark_border,
              title: l10n.savedMonumentsEmptyTitle,
              message: l10n.savedMonumentsEmptyBody,
              actionLabel: l10n.emptyStateExploreMap,
              actionIcon: Icons.map_outlined,
              onAction: widget.onExplore,
            ),
          SavedMonumentsListState(:final entries) => _SavedList(
            entries: entries,
            onOpen: widget.onOpenMonument,
            onShowOnMap: widget.onShowOnMap,
            onRemove: _remove,
          ),
        },
      ),
    );
  }
}

class _SavedList extends StatelessWidget {
  const _SavedList({
    required this.entries,
    required this.onOpen,
    required this.onShowOnMap,
    required this.onRemove,
  });

  final List<SavedMonumentEntry> entries;
  final ValueChanged<String> onOpen;
  final ValueChanged<String> onShowOnMap;
  final ValueChanged<SavedMonumentEntry> onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SafeArea(
      top: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
          child: ListView.separated(
            key: const Key('saved_monuments_list'),
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            itemCount: entries.length + 1,
            separatorBuilder: (_, index) =>
                index == 0 ? const SizedBox.shrink() : const Divider(height: 0),
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    0,
                    AppSpacing.md,
                    AppSpacing.md,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppText(
                        l10n.savedMonumentsCount(entries.length),
                        role: AppTextRole.titleMedium,
                        isHeading: true,
                      ),
                    ],
                  ),
                );
              }
              final entry = entries[index - 1];
              return _SavedRow(
                entry: entry,
                onOpen: onOpen,
                onShowOnMap: onShowOnMap,
                onRemove: onRemove,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SavedRow extends StatelessWidget {
  const _SavedRow({
    required this.entry,
    required this.onOpen,
    required this.onShowOnMap,
    required this.onRemove,
  });

  final SavedMonumentEntry entry;
  final ValueChanged<String> onOpen;
  final ValueChanged<String> onShowOnMap;
  final ValueChanged<SavedMonumentEntry> onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final id = entry.saved.monumentId;
    final pin = entry.pin;
    final savedOn = l10n.savedMonumentSavedOn(
      DateFormat.yMMMd(l10n.localeName).format(entry.saved.savedAt.toLocal()),
    );
    final name = pin?.name ?? l10n.savedMonumentUnavailable;
    final remove = IconButton(
      key: Key('saved_monument_remove_$id'),
      tooltip: '${l10n.savedMonumentRemove}: $name',
      onPressed: () => onRemove(entry),
      icon: const Icon(Icons.bookmark_remove_outlined),
    );
    final leading = LeadingIconTile(
      icon: pin?.category.icon ?? Icons.help_outlined,
      tone: LeadingIconTone.heritage,
    );
    if (pin == null) {
      return ListTile(
        key: Key('saved_monument_$id'),
        leading: leading,
        title: Text(name),
        subtitle: Text('${l10n.savedMonumentUnavailableBody}\n$savedOn'),
        isThreeLine: true,
        trailing: remove,
      );
    }
    final location = l10n.monumentLocation(pin.district, pin.city);
    return ListTile(
      key: Key('saved_monument_$id'),
      leading: leading,
      title: Text(name),
      subtitle: Text('${pin.category.label(l10n)} · $location\n$savedOn'),
      isThreeLine: true,
      onTap: () => onOpen(id),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            key: Key('saved_monument_map_$id'),
            tooltip: l10n.searchShowOnMap(name),
            onPressed: () => onShowOnMap(id),
            icon: const Icon(Icons.map_outlined),
          ),
          remove,
        ],
      ),
    );
  }
}
