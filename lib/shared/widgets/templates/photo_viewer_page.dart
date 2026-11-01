import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vakif_atlas/core/a11y/reduce_motion.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_durations.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_network_image.dart';
import 'package:vakif_atlas/shared/widgets/molecules/gallery_nav_button.dart';
import 'package:vakif_atlas/shared/widgets/organisms/gallery_photo.dart';

/// Tam ekran, yakınlaştırılabilir fotoğraf görüntüleyici.
///
/// - Altyazı (betim + lisans künyesi) canlı bölgedir; fotoğraf değiştiğinde
///   ekran okuyucu yeni betimi okur.
/// - ← / → tuşları ve butonlar fotoğraf değiştirir, Esc kapatır.
/// - Kapanırken son görüntülenen fotoğrafın sırası döner.
class PhotoViewerPage extends StatefulWidget {
  const PhotoViewerPage({
    required this.photos,
    this.initialIndex = 0,
    super.key,
  });

  final List<GalleryPhoto> photos;
  final int initialIndex;

  /// Hareket azaltmaya duyarlı, yumuşak geçişli tam ekran rota.
  static Route<int> route(
    BuildContext context, {
    required List<GalleryPhoto> photos,
    required int initialIndex,
  }) {
    final duration = context.motionDuration(AppDurations.medium);
    return PageRouteBuilder<int>(
      fullscreenDialog: true,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) =>
          PhotoViewerPage(photos: photos, initialIndex: initialIndex),
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(opacity: animation, child: child),
    );
  }

  @override
  State<PhotoViewerPage> createState() => _PhotoViewerPageState();
}

class _PhotoViewerPageState extends State<PhotoViewerPage> {
  late final PageController _pages = PageController(
    initialPage: widget.initialIndex,
  );
  late int _index = widget.initialIndex;
  bool _zoomed = false;

  static const double _captionMaxHeightFactor = 0.3;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    if (index < 0 || index >= widget.photos.length) {
      return;
    }
    final duration = context.motionDuration(AppDurations.medium);
    if (duration == Duration.zero) {
      _pages.jumpToPage(index);
    } else {
      unawaited(
        _pages.animateToPage(
          index,
          duration: duration,
          curve: Curves.easeOutCubic,
        ),
      );
    }
  }

  void _close() => Navigator.of(context).pop(_index);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final photos = widget.photos;
    final count = photos.length;
    final photo = photos[_index];

    return PopScope<int>(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _close();
        }
      },
      child: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.arrowLeft): () =>
              _goTo(_index - 1),
          const SingleActivator(LogicalKeyboardKey.arrowRight): () =>
              _goTo(_index + 1),
          const SingleActivator(LogicalKeyboardKey.escape): _close,
        },
        child: Focus(
          autofocus: true,
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                key: const Key('photo_viewer_close_button'),
                tooltip: l10n.galleryCloseViewer,
                icon: const Icon(Icons.close),
                onPressed: _close,
              ),
              title: Text(
                l10n.galleryPosition(_index + 1, count),
                semanticsLabel: l10n.galleryPositionSemantics(
                  _index + 1,
                  count,
                ),
              ),
            ),
            body: SafeArea(
              top: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        PageView.builder(
                          key: const Key('photo_viewer_pages'),
                          controller: _pages,
                          // Yakınlaştırılmış fotoğrafta kaydırma, sayfa
                          // değiştirmek yerine fotoğrafı gezdirir.
                          physics: _zoomed
                              ? const NeverScrollableScrollPhysics()
                              : null,
                          itemCount: count,
                          onPageChanged: (index) => setState(() {
                            _index = index;
                            _zoomed = false;
                          }),
                          itemBuilder: (context, index) => _ZoomablePhoto(
                            photo: photos[index],
                            onZoomChanged: (zoomed) {
                              if (zoomed != _zoomed) {
                                setState(() => _zoomed = zoomed);
                              }
                            },
                          ),
                        ),
                        if (_index > 0)
                          PositionedDirectional(
                            start: AppSpacing.xs,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: GalleryNavButton(
                                key: const Key('photo_viewer_previous_button'),
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
                                key: const Key('photo_viewer_next_button'),
                                icon: Icons.chevron_right,
                                tooltip: l10n.galleryNext,
                                onPressed: () => _goTo(_index + 1),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight:
                          MediaQuery.sizeOf(context).height *
                          _captionMaxHeightFactor,
                    ),
                    child: _ViewerCaption(photo: photo),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ZoomablePhoto extends StatefulWidget {
  const _ZoomablePhoto({required this.photo, required this.onZoomChanged});

  final GalleryPhoto photo;
  final ValueChanged<bool> onZoomChanged;

  @override
  State<_ZoomablePhoto> createState() => _ZoomablePhotoState();
}

class _ZoomablePhotoState extends State<_ZoomablePhoto> {
  final TransformationController _transformation = TransformationController();

  static const double _maxScale = 4;

  /// Bu ölçeğin üstü yakınlaştırılmış kabul edilir.
  static const double _zoomThreshold = 1.01;

  @override
  void dispose() {
    _transformation.dispose();
    super.dispose();
  }

  void _onInteractionEnd(ScaleEndDetails details) {
    final scale = _transformation.value.getMaxScaleOnAxis();
    widget.onZoomChanged(scale > _zoomThreshold);
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: _transformation,
      maxScale: _maxScale,
      onInteractionEnd: _onInteractionEnd,
      child: AppNetworkImage(
        url: widget.photo.url,
        semanticsLabel: widget.photo.description,
        fit: BoxFit.contain,
      ),
    );
  }
}

class _ViewerCaption extends StatelessWidget {
  const _ViewerCaption({required this.photo});

  final GalleryPhoto photo;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        border: Border(
          top: BorderSide(
            color: colors.outlineVariant,
            width: AppSizes.borderThin,
          ),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Semantics(
          container: true,
          liveRegion: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                photo.description,
                key: const Key('photo_viewer_caption'),
                style: context.textStyles.bodyLarge,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                photo.credit,
                style: context.textStyles.bodySmall,
                semanticsLabel: photo.creditSemanticsLabel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
