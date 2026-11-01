import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/a11y/reduce_motion.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_durations.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_network_image.dart';
import 'package:vakif_atlas/shared/widgets/molecules/gallery_nav_button.dart';
import 'package:vakif_atlas/shared/widgets/organisms/gallery_photo.dart';
import 'package:vakif_atlas/shared/widgets/templates/photo_viewer_page.dart';

export 'package:vakif_atlas/shared/widgets/organisms/gallery_photo.dart';

/// Kapak fotoğrafı alanı + küçük resim şeridi.
///
/// - Kaydırmaya alternatif olarak önceki/sonraki butonları ve küçük resimler
///   sunulur (WCAG 2.5.7).
/// - Fotoğrafa dokunulduğunda yakınlaştırılabilir tam ekran görüntüleyici
///   açılır; kapanınca galeri son görüntülenen fotoğrafta kalır.
/// - Hareket azaltma açıksa sayfa geçişleri anlıktır.
class PhotoGallery extends StatefulWidget {
  const PhotoGallery({required this.photos, super.key});

  final List<GalleryPhoto> photos;

  /// Kapak alanının en-boy oranı ve geniş ekranlardaki üst sınırı.
  static const double aspectRatio = 16 / 10;
  static const double maxHeight = 480;

  @override
  State<PhotoGallery> createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  final PageController _pages = PageController();
  int _index = 0;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    final target = index.clamp(0, widget.photos.length - 1);
    final duration = context.motionDuration(AppDurations.medium);
    if (duration == Duration.zero) {
      _pages.jumpToPage(target);
    } else {
      unawaited(
        _pages.animateToPage(
          target,
          duration: duration,
          curve: Curves.easeOutCubic,
        ),
      );
    }
  }

  Future<void> _open(int index) async {
    final lastIndex = await Navigator.of(context).push<int>(
      PhotoViewerPage.route(
        context,
        photos: widget.photos,
        initialIndex: index,
      ),
    );
    if (mounted && lastIndex != null && lastIndex != _index) {
      _pages.jumpToPage(lastIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final photos = widget.photos;
    if (photos.isEmpty) {
      return const SizedBox.shrink();
    }
    final l10n = context.l10n;
    final count = photos.length;
    final hasMany = count > 1;

    return Semantics(
      container: true,
      label: l10n.gallerySemantics(count),
      explicitChildNodes: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, constraints) => SizedBox(
              height: math.min(
                constraints.maxWidth / PhotoGallery.aspectRatio,
                PhotoGallery.maxHeight,
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    key: const Key('photo_gallery_pages'),
                    controller: _pages,
                    itemCount: count,
                    onPageChanged: (index) => setState(() => _index = index),
                    itemBuilder: (context, index) => _GalleryPage(
                      photo: photos[index],
                      semanticsLabel: l10n.galleryPhotoSemantics(
                        index + 1,
                        count,
                        photos[index].description,
                      ),
                      onOpen: () => _open(index),
                    ),
                  ),
                  PositionedDirectional(
                    top: AppSpacing.sm,
                    end: AppSpacing.sm,
                    child: ExcludeSemantics(
                      child: _Backdrop(
                        child: Text(
                          l10n.galleryPosition(_index + 1, count),
                          style: context.textStyles.labelMedium,
                        ),
                      ),
                    ),
                  ),
                  // Uygulanamayan yön butonu (ilk/son fotoğraf) fotoğrafın
                  // üzerinde gösterilmez; konum sayaçta ve etiketlerde okunur.
                  if (_index > 0)
                    PositionedDirectional(
                      start: AppSpacing.xs,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: GalleryNavButton(
                          key: const Key('photo_gallery_previous_button'),
                          icon: Icons.chevron_left,
                          tooltip: l10n.galleryPrevious,
                          onPressed: () => _goTo(_index - 1),
                        ),
                      ),
                    ),
                  if (_index < count - 1)
                    PositionedDirectional(
                      end: AppSpacing.xs,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: GalleryNavButton(
                          key: const Key('photo_gallery_next_button'),
                          icon: Icons.chevron_right,
                          tooltip: l10n.galleryNext,
                          onPressed: () => _goTo(_index + 1),
                        ),
                      ),
                    ),
                  if (hasMany) ...[
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: AppSpacing.sm,
                      child: Center(
                        child: ExcludeSemantics(
                          child: _DiamondPageIndicator(
                            count: count,
                            index: _index,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (hasMany)
            SizedBox(
              height: AppSizes.galleryThumbnail + AppSpacing.sm * 2,
              child: ListView.separated(
                key: const Key('photo_gallery_thumbnails'),
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                itemCount: count,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppSpacing.xs),
                itemBuilder: (context, index) => _GalleryThumbnail(
                  key: Key('photo_gallery_thumbnail_$index'),
                  photo: photos[index],
                  selected: index == _index,
                  semanticsLabel: l10n.galleryThumbnailSemantics(
                    index + 1,
                    photos[index].description,
                  ),
                  onTap: () => _goTo(index),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _GalleryPage extends StatelessWidget {
  const _GalleryPage({
    required this.photo,
    required this.semanticsLabel,
    required this.onOpen,
  });

  final GalleryPhoto photo;
  final String semanticsLabel;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      image: true,
      label: semanticsLabel,
      onTapHint: context.l10n.galleryOpenFullScreen,
      excludeSemantics: true,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppNetworkImage(url: photo.url),
          Material(
            type: MaterialType.transparency,
            child: InkWell(onTap: onOpen),
          ),
        ],
      ),
    );
  }
}

class _GalleryThumbnail extends StatelessWidget {
  const _GalleryThumbnail({
    required this.photo,
    required this.selected,
    required this.semanticsLabel,
    required this.onTap,
    super.key,
  });

  final GalleryPhoto photo;
  final bool selected;
  final String semanticsLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = BorderRadius.circular(AppRadius.sm);
    return Semantics(
      button: true,
      selected: selected,
      label: semanticsLabel,
      onTap: onTap,
      excludeSemantics: true,
      child: SizedBox.square(
        dimension: AppSizes.galleryThumbnail,
        child: DecoratedBox(
          // Seçili küçük resim yalnızca renkle değil kalın konturla da
          // ayrışır.
          position: DecorationPosition.foreground,
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(
              color: selected ? colors.primary : colors.outlineVariant,
              width: selected ? AppSizes.borderHeavy : AppSizes.borderThin,
            ),
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: Stack(
              fit: StackFit.expand,
              children: [
                AppNetworkImage(url: photo.thumbnailUrl),
                Material(
                  type: MaterialType.transparency,
                  child: InkWell(onTap: onTap),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Fotoğraf üzerinde okunabilirlik için yarı saydam zemin.
class _Backdrop extends StatelessWidget {
  const _Backdrop({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface.withValues(
          alpha: GalleryNavButton.backdropOpacity,
        ),
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
        child: child,
      ),
    );
  }
}

/// Pusula/karo (◇) motifli sayfa göstergesi; etkin sayfa dolu ve büyüktür.
class _DiamondPageIndicator extends StatelessWidget {
  const _DiamondPageIndicator({required this.count, required this.index});

  final int count;
  final int index;

  static const double _activeScale = 1.5;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return _Backdrop(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < count; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
              child: Transform.rotate(
                angle: math.pi / 4,
                child: AnimatedContainer(
                  duration: context.motionDuration(AppDurations.fast),
                  width: i == index
                      ? AppSizes.diamond * _activeScale
                      : AppSizes.diamond,
                  height: i == index
                      ? AppSizes.diamond * _activeScale
                      : AppSizes.diamond,
                  decoration: BoxDecoration(
                    color: i == index ? colors.primary : null,
                    border: Border.all(
                      color: i == index ? colors.primary : colors.onSurface,
                      width: AppSizes.borderThin,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
