import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/l10n/failure_messages.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/cubit/my_memories_cubit.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/memory_presentation.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_network_image.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/molecules/inline_message.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/widgets/memory_status_badge.dart';
import 'package:vakif_atlas/shared/widgets/molecules/section_header.dart';

/// Eserin Anı Köşesi'ni açar (eser adı başlık için taşınır).
typedef OpenMonumentMemories = void Function(
  String monumentId,
  String monumentName,
);

/// Profildeki "Anılarım" önizlemesi: toplam, en son paylaşılan anılar ve
/// tam listeye geçiş. `MyMemoriesCubit` üst ağaçtan sağlanır; önizleme
/// boyutuyla kendisi yükler.
class MyMemoriesProfileSection extends StatefulWidget {
  const MyMemoriesProfileSection({
    required this.onOpenAll,
    required this.onOpenMonumentMemories,
    super.key,
  });

  static const int previewCount = 3;

  final VoidCallback onOpenAll;
  final OpenMonumentMemories onOpenMonumentMemories;

  @override
  State<MyMemoriesProfileSection> createState() =>
      _MyMemoriesProfileSectionState();
}

class _MyMemoriesProfileSectionState extends State<MyMemoriesProfileSection> {
  String? _languageCode;

  void _load() => unawaited(
    context.read<MyMemoriesCubit>().load(
      languageCode: _languageCode!,
      limit: MyMemoriesProfileSection.previewCount,
    ),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageCode = Localizations.localeOf(context).languageCode;
    if (languageCode != _languageCode) {
      _languageCode = languageCode;
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final state = context.watch<MyMemoriesCubit>().state;
    final Widget body = switch (state.status) {
      MyMemoriesStatus.loading => Semantics(
        label: l10n.myMemoriesLoading,
        liveRegion: true,
        excludeSemantics: true,
        child: const LinearProgressIndicator(),
      ),
      MyMemoriesStatus.failure => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InlineMessage(
            message:
                '${l10n.myMemoriesLoadFailed} '
                '${state.failure?.toUserMessage(l10n) ?? ''}',
            type: InlineMessageType.error,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton.secondary(
            key: const Key('my_memories_retry'),
            label: l10n.commonRetry,
            icon: Icons.refresh,
            onPressed: _load,
          ),
        ],
      ),
      MyMemoriesStatus.ready when state.items.isEmpty => AppText(
        key: const Key('my_memories_empty'),
        '${l10n.myMemoriesEmptyTitle}. ${l10n.myMemoriesEmptyBody}',
        role: AppTextRole.bodyMedium,
        color: colors.onSurfaceVariant,
      ),
      MyMemoriesStatus.ready => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final memory in state.items.take(
            MyMemoriesProfileSection.previewCount,
          ))
            _MemoryPreviewRow(
              memory: memory,
              monumentName:
                  state.monumentNames[memory.monumentId] ??
                  l10n.myMemoriesUnknownMonument,
              onOpen: widget.onOpenMonumentMemories,
            ),
          const SizedBox(height: AppSpacing.xs),
          AppButton.secondary(
            key: const Key('my_memories_view_all'),
            label: l10n.myMemoriesViewAll(state.total),
            icon: Icons.photo_library_outlined,
            expand: true,
            onPressed: widget.onOpenAll,
          ),
        ],
      ),
    };
    return Column(
      key: const Key('my_memories_section'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(l10n.myMemoriesTitle),
        const SizedBox(height: AppSpacing.sm),
        body,
      ],
    );
  }
}

/// Önizleme satırı: ilk fotoğraf (yoksa simge), eser adı, paylaşım tarihi
/// ve metnin başı. Dokununca eserin Anı Köşesi açılır; tek düğüm okunur.
class _MemoryPreviewRow extends StatelessWidget {
  const _MemoryPreviewRow({
    required this.memory,
    required this.monumentName,
    required this.onOpen,
  });

  final Memory memory;
  final String monumentName;
  final OpenMonumentMemories onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final date = MemoryDates.posted(l10n, memory.createdAt);
    final photo = memory.photos.firstOrNull;
    final summary = l10n.myMemoriesPreviewSemantics(
      monumentName,
      date,
      memory.text,
    );
    final reviewed = memory.status != MemoryModerationStatus.approved;
    return Semantics(
      button: true,
      label: reviewed
          ? l10n.myMemoriesPreviewStatusSemantics(
              memory.status.label(l10n),
              summary,
            )
          : summary,
      hint: l10n.myMemoriesOpenCorner,
      excludeSemantics: true,
      child: InkWell(
        key: Key('my_memory_${memory.id}'),
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: () => onOpen(memory.monumentId, monumentName),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: SizedBox.square(
                  dimension: AppSizes.minTouchTarget,
                  child: photo == null
                      ? ColoredBox(
                          color: colors.surfaceVariant,
                          child: Center(
                            child: AppIcon.decorative(
                              Icons.notes,
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        )
                      : AppNetworkImage(url: photo.thumbnailUrl),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(monumentName, role: AppTextRole.titleMedium),
                    AppText(
                      date,
                      role: AppTextRole.bodySmall,
                      color: colors.onSurfaceVariant,
                    ),
                    if (reviewed) ...[
                      const SizedBox(height: AppSpacing.xxs),
                      MemoryStatusBadge(status: memory.status),
                      const SizedBox(height: AppSpacing.xxs),
                    ],
                    AppText(
                      memory.text,
                      role: AppTextRole.bodyMedium,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
