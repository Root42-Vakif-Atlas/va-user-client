import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/a11y/reduce_motion.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_durations.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/memory_presentation.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/widgets/memory_photo_grid.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/molecules/account_avatar.dart';
import 'package:vakif_atlas/shared/widgets/organisms/gallery_photo.dart';
import 'package:vakif_atlas/shared/widgets/templates/photo_viewer_page.dart';

enum _MemoryAction { delete, report }

/// Anı kartı: paylaşan, tarih, metin (uzunsa daraltılmış) ve fotoğraflar.
///
/// - Başlık (ad + tarih) ekran okuyucuya tek cümle olarak okunur.
/// - Metin görsel olarak daraltılsa da ekran okuyucu tamamını okur.
/// - Kendi anısında "Sil", başkasınınkinde "Bildir" işlemi sunulur.
class MemoryCard extends StatelessWidget {
  const MemoryCard({
    required this.memory,
    required this.isOwn,
    this.isBusy = false,
    this.onDelete,
    this.onReport,
    this.collapsedLines = 6,
    super.key,
  });

  final Memory memory;
  final bool isOwn;

  /// Silme / bildirme isteği sürüyor.
  final bool isBusy;
  final VoidCallback? onDelete;
  final VoidCallback? onReport;

  /// Bu satırdan uzun metin "Devamını oku" ile açılır.
  final int collapsedLines;

  static const double _avatarSize = 40;

  Future<void> _openPhoto(BuildContext context, int index) async {
    final l10n = context.l10n;
    final date = MemoryDates.posted(l10n, memory.createdAt);
    final credit = l10n.memoryPhotoCredit(memory.author.displayName, date);
    final creditSemantics = l10n.memoryCardSemantics(
      memory.author.displayName,
      date,
    );
    await Navigator.of(context).push(
      PhotoViewerPage.route(
        context,
        initialIndex: index,
        photos: [
          for (final photo in memory.photos)
            GalleryPhoto(
              url: photo.url,
              thumbnailUrl: photo.thumbnailUrl,
              description: photo.description ?? l10n.memoryPhotoNoDescription,
              credit: credit,
              creditSemanticsLabel: creditSemantics,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      key: Key('memory_card_${memory.id}'),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        border: Border.all(
          color: colors.outlineVariant,
          width: AppSizes.borderThin,
        ),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.xxs,
          AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: _Header(memory: memory, isOwn: isOwn),
                ),
                _ActionsButton(
                  memory: memory,
                  isBusy: isBusy,
                  onDelete: isOwn ? onDelete : null,
                  onReport: isOwn ? null : onReport,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.sm),
                  _ExpandableText(
                    key: Key('memory_text_${memory.id}'),
                    text: memory.text,
                    collapsedLines: collapsedLines,
                  ),
                  if (memory.photos.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sm),
                    MemoryPhotoGrid(
                      photos: memory.photos,
                      onOpen: (index) => unawaited(_openPhoto(context, index)),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.memory, required this.isOwn});

  final Memory memory;
  final bool isOwn;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final visitedOn = memory.visitedOn;
    final shared = l10n.memorySharedOn(
      MemoryDates.posted(l10n, memory.createdAt),
    );
    final visited = visitedOn == null
        ? null
        : l10n.memoryVisited(MemoryDates.day(l10n, visitedOn));
    final meta = [?visited, shared].join(' · ');
    return Semantics(
      container: true,
      label: [memory.headerSemantics(l10n, isOwn: isOwn), ?visited].join('. '),
      excludeSemantics: true,
      child: Row(
        children: [
          AccountAvatar(
            displayName: memory.author.displayName,
            size: MemoryCard._avatarSize,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xxs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    AppText(
                      memory.author.displayName,
                      role: AppTextRole.titleMedium,
                    ),
                    if (isOwn)
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: colors.secondaryContainer,
                          borderRadius: BorderRadius.circular(AppRadius.xs),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs,
                            vertical: AppSpacing.xxs / 2,
                          ),
                          child: AppText(
                            l10n.memoryOwnBadge,
                            role: AppTextRole.labelMedium,
                            color: colors.onSecondaryContainer,
                          ),
                        ),
                      ),
                  ],
                ),
                AppText(
                  meta,
                  role: AppTextRole.bodySmall,
                  color: colors.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionsButton extends StatelessWidget {
  const _ActionsButton({
    required this.memory,
    required this.isBusy,
    required this.onDelete,
    required this.onReport,
  });

  final Memory memory;
  final bool isBusy;
  final VoidCallback? onDelete;
  final VoidCallback? onReport;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final delete = onDelete;
    final report = onReport;
    if (delete == null && report == null) {
      return const SizedBox.shrink();
    }
    if (isBusy) {
      return SizedBox.square(
        dimension: AppSizes.minTouchTarget,
        child: Center(
          child: context.reduceMotion
              ? Icon(Icons.hourglass_top, color: colors.onSurfaceVariant)
              : const SizedBox.square(
                  dimension: AppSizes.spinner,
                  child: CircularProgressIndicator(
                    strokeWidth: AppSizes.spinnerStroke,
                  ),
                ),
        ),
      );
    }
    return PopupMenuButton<_MemoryAction>(
      popUpAnimationStyle: context.motionAnimationStyle,
      key: Key('memory_menu_${memory.id}'),
      tooltip: l10n.memoryMoreActions(memory.author.displayName),
      icon: const Icon(Icons.more_vert),
      onSelected: (action) => switch (action) {
        _MemoryAction.delete => delete?.call(),
        _MemoryAction.report => report?.call(),
      },
      itemBuilder: (context) => [
        if (delete != null)
          PopupMenuItem(
            key: const Key('memory_action_delete'),
            value: _MemoryAction.delete,
            child: ListTile(
              leading: Icon(Icons.delete_outlined, color: colors.error),
              title: Text(l10n.memoryDelete),
            ),
          ),
        if (report != null)
          PopupMenuItem(
            key: const Key('memory_action_report'),
            value: _MemoryAction.report,
            child: ListTile(
              leading: const Icon(Icons.flag_outlined),
              title: Text(l10n.memoryReport),
            ),
          ),
      ],
    );
  }
}

/// [collapsedLines] satırdan uzun metni daraltır. Ekran okuyucu her durumda
/// metnin tamamını okur; buton görsel uzunluğu değiştirir (klavye ve anahtar
/// erişimi için semantikte kalır).
class _ExpandableText extends StatefulWidget {
  const _ExpandableText({
    required this.text,
    required this.collapsedLines,
    super.key,
  });

  final String text;
  final int collapsedLines;

  @override
  State<_ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<_ExpandableText> {
  bool _expanded = false;

  bool _overflows(TextStyle style, double maxWidth, BuildContext context) {
    final painter = TextPainter(
      text: TextSpan(text: widget.text, style: style),
      maxLines: widget.collapsedLines,
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      locale: Localizations.localeOf(context),
    )..layout(maxWidth: maxWidth);
    final exceeded = painter.didExceedMaxLines;
    painter.dispose();
    return exceeded;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final style = context.textStyles.bodyLarge.copyWith(
      color: context.colors.onSurface,
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final overflows = _overflows(style, constraints.maxWidth, context);
        final collapsed = overflows && !_expanded;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedSize(
              duration: context.motionDuration(AppDurations.normal),
              alignment: Alignment.topCenter,
              child: Semantics(
                label: widget.text,
                excludeSemantics: true,
                child: Text(
                  widget.text,
                  style: style,
                  maxLines: collapsed ? widget.collapsedLines : null,
                  overflow: collapsed ? TextOverflow.ellipsis : null,
                ),
              ),
            ),
            if (overflows)
              TextButton(
                onPressed: () => setState(() => _expanded = !_expanded),
                child: Text(
                  _expanded ? l10n.memoryReadLess : l10n.memoryReadMore,
                ),
              ),
          ],
        );
      },
    );
  }
}
