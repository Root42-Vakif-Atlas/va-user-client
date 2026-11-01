import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_network_image.dart';

/// Anı fotoğraflarının kart içi yerleşimi (1–4 fotoğraf).
///
/// Alan görsel yüklenmeden en-boy oranıyla ayrılır (yerleşim kayması yok).
/// Her fotoğraf betimiyle etiketli bir butondur ve tam ekran açılır.
class MemoryPhotoGrid extends StatelessWidget {
  const MemoryPhotoGrid({
    required this.photos,
    required this.onOpen,
    super.key,
  });

  final List<MemoryPhoto> photos;
  final ValueChanged<int> onOpen;

  /// Tek fotoğrafta çok uzun / çok geniş görseller bu aralığa sığdırılır.
  static const double _minSingleRatio = 4 / 5;
  static const double _maxSingleRatio = 16 / 9;
  static const double _multiRatio = 3 / 2;
  static const double _gap = AppSpacing.xxs;

  @override
  Widget build(BuildContext context) {
    Widget tile(int index) => _PhotoTile(
      photo: photos[index],
      index: index,
      count: photos.length,
      onOpen: () => onOpen(index),
    );

    return switch (photos.length) {
      0 => const SizedBox.shrink(),
      1 => AspectRatio(
        aspectRatio: photos.single.aspectRatio.clamp(
          _minSingleRatio,
          _maxSingleRatio,
        ),
        child: tile(0),
      ),
      2 => AspectRatio(
        aspectRatio: 2,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: tile(0)),
            const SizedBox(width: _gap),
            Expanded(child: tile(1)),
          ],
        ),
      ),
      3 => AspectRatio(
        aspectRatio: _multiRatio,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: 2, child: tile(0)),
            const SizedBox(width: _gap),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: tile(1)),
                  const SizedBox(height: _gap),
                  Expanded(child: tile(2)),
                ],
              ),
            ),
          ],
        ),
      ),
      _ => AspectRatio(
        aspectRatio: _multiRatio,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var row = 0; row < 2; row++) ...[
              if (row > 0) const SizedBox(height: _gap),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: tile(row * 2)),
                    const SizedBox(width: _gap),
                    Expanded(child: tile(row * 2 + 1)),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    };
  }
}

class _PhotoTile extends StatelessWidget {
  const _PhotoTile({
    required this.photo,
    required this.index,
    required this.count,
    required this.onOpen,
  });

  final MemoryPhoto photo;
  final int index;
  final int count;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final description = photo.description;
    final label = description == null
        ? l10n.photoTileNoDescription(index + 1, count)
        : l10n.photoTileSemantics(index + 1, count, description);
    return Semantics(
      button: true,
      image: true,
      label: label,
      onTapHint: l10n.photoOpenHint,
      onTap: onOpen,
      excludeSemantics: true,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        // Dokunma geri bildirimi görselin üstünde çizilir.
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(
              color: context.colors.surfaceVariant,
              child: AppNetworkImage(url: photo.thumbnailUrl),
            ),
            Material(
              type: MaterialType.transparency,
              child: InkWell(
                key: Key('memory_photo_${photo.id}'),
                onTap: onOpen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
