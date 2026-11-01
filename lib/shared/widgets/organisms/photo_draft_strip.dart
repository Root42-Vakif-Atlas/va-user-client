import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/a11y/reduce_motion.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/media/photo_attacher.dart';
import 'package:vakif_atlas/core/media/photo_draft.dart';
import 'package:vakif_atlas/core/media/photo_picker_service.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';

/// Formlardaki (Anı Köşesi, Sivil Koruma) fotoğraflar: küçük resim,
/// kaldırma, betim ekleme ve "Fotoğraf ekle" kutusu. Öğeler sığmadığında alt satıra geçer (%200 metin
/// ölçeğinde de yatay kaydırma gerekmez).
class PhotoDraftStrip extends StatelessWidget {
  const PhotoDraftStrip({
    required this.photos,
    required this.processing,
    required this.canAdd,
    required this.enabled,
    required this.onAdd,
    required this.onRemove,
    required this.onEditDescription,
    required this.maxDescriptionLength,
    this.keyPrefix = 'photo',
    super.key,
  });

  final List<PhotoDraft> photos;
  final int processing;
  final bool canAdd;
  final bool enabled;
  final VoidCallback onAdd;
  final ValueChanged<PhotoDraft> onRemove;
  final ValueChanged<PhotoDraft> onEditDescription;

  /// Betim alanının üst sınırı (formun kuralı).
  final int maxDescriptionLength;

  /// Test ve entegrasyon anahtarlarının öneki.
  final String keyPrefix;

  static const double tileSize = 96;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (var index = 0; index < photos.length; index++)
          _PhotoItem(
            key: ValueKey(photos[index].localId),
            photo: photos[index],
            index: index + 1,
            enabled: enabled,
            keyPrefix: keyPrefix,
            onRemove: () => onRemove(photos[index]),
            onEditDescription: () => onEditDescription(photos[index]),
          ),
        for (var index = 0; index < processing; index++)
          const _ProcessingTile(),
        if (canAdd)
          _AddTile(enabled: enabled, onTap: onAdd, keyPrefix: keyPrefix),
      ],
    );
  }
}

class _PhotoItem extends StatelessWidget {
  const _PhotoItem({
    required this.photo,
    required this.index,
    required this.enabled,
    required this.onRemove,
    required this.onEditDescription,
    required this.keyPrefix,
    super.key,
  });

  final PhotoDraft photo;
  final int index;
  final bool enabled;
  final String keyPrefix;
  final VoidCallback onRemove;
  final VoidCallback onEditDescription;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final description = photo.description.trim();
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    return SizedBox(
      width: PhotoDraftStrip.tileSize + AppSpacing.md,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            container: true,
            child: SizedBox.square(
              dimension: PhotoDraftStrip.tileSize,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Semantics(
                    image: true,
                    label: description.isEmpty
                        ? l10n.photoDraftNoDescription(index)
                        : l10n.photoDraftSemantics(index, description),
                    excludeSemantics: true,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      child: Image.memory(
                        photo.bytes,
                        fit: BoxFit.cover,
                        cacheWidth: (PhotoDraftStrip.tileSize * pixelRatio)
                            .round(),
                        gaplessPlayback: true,
                      ),
                    ),
                  ),
                  // Görünen daire küçük, dokunma alanı 48 dp.
                  PositionedDirectional(
                    top: 0,
                    end: 0,
                    child: IconButton(
                      key: Key('${keyPrefix}_remove_${photo.localId}'),
                      tooltip: l10n.photoRemove(index),
                      onPressed: enabled ? onRemove : null,
                      icon: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.surfaceElevated,
                          border: Border.all(
                            color: colors.outline,
                            width: AppSizes.borderThin,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.xxs),
                          child: Icon(
                            Icons.close,
                            size: AppSizes.iconSm,
                            color: colors.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          TextButton.icon(
            key: Key('${keyPrefix}_describe_${photo.localId}'),
            onPressed: enabled ? onEditDescription : null,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
              alignment: AlignmentDirectional.centerStart,
            ),
            icon: Icon(
              description.isEmpty ? Icons.add : Icons.edit_outlined,
              size: AppSizes.iconSm,
            ),
            label: Semantics(
              label: l10n.photoDescriptionAction(index),
              excludeSemantics: true,
              child: Text(
                description.isEmpty
                    ? l10n.photoAddDescription
                    : l10n.photoEditDescription,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProcessingTile extends StatelessWidget {
  const _ProcessingTile();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      label: context.l10n.photoProcessing,
      liveRegion: true,
      excludeSemantics: true,
      child: Container(
        width: PhotoDraftStrip.tileSize,
        height: PhotoDraftStrip.tileSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: context.reduceMotion
            ? AppIcon.decorative(
                Icons.hourglass_top,
                color: colors.onSurfaceVariant,
              )
            : const SizedBox.square(
                dimension: AppSizes.spinner,
                child: CircularProgressIndicator(
                  strokeWidth: AppSizes.spinnerStroke,
                ),
              ),
      ),
    );
  }
}

class _AddTile extends StatelessWidget {
  const _AddTile({
    required this.enabled,
    required this.onTap,
    required this.keyPrefix,
  });

  final bool enabled;
  final VoidCallback onTap;
  final String keyPrefix;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final foreground = enabled ? colors.primary : colors.onSurfaceVariant;
    return Semantics(
      button: true,
      enabled: enabled,
      label: context.l10n.photoAdd,
      onTap: enabled ? onTap : null,
      excludeSemantics: true,
      child: Material(
        color: colors.surfaceElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          side: BorderSide(color: colors.outline, width: AppSizes.borderThin),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: Key('${keyPrefix}_add_photo'),
          onTap: enabled ? onTap : null,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: PhotoDraftStrip.tileSize,
              minHeight: PhotoDraftStrip.tileSize,
              maxWidth: PhotoDraftStrip.tileSize + AppSpacing.md,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xs),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppIcon.decorative(
                    Icons.add_a_photo_outlined,
                    color: foreground,
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  AppText(
                    context.l10n.photoAdd,
                    role: AppTextRole.labelMedium,
                    color: foreground,
                    textAlign: TextAlign.center,
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

/// Fotoğraf betimini düzenler; kaydedilirse yeni metni döndürür.
Future<String?> showPhotoDescriptionSheet(
  BuildContext context, {
  required String initial,
  required int maxLength,
}) => showModalBottomSheet<String>(
  context: context,
  useSafeArea: true,
  showDragHandle: true,
  isScrollControlled: true,
  builder: (context) =>
      _PhotoDescriptionSheet(initial: initial, maxLength: maxLength),
);

/// Kamera destekleniyorsa kaynak seçtirir; desteklenmiyorsa doğrudan galeri.
Future<PhotoSource?> choosePhotoSource(
  BuildContext context, {
  required bool supportsCamera,
}) async {
  if (!supportsCamera) {
    return PhotoSource.gallery;
  }
  final l10n = context.l10n;
  final colors = context.colors;
  return showModalBottomSheet<PhotoSource>(
    context: context,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) => SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            key: const Key('photo_source_camera'),
            leading: AppIcon.decorative(
              Icons.photo_camera_outlined,
              color: colors.accentText,
            ),
            title: Text(l10n.photoTake),
            onTap: () => Navigator.of(context).pop(PhotoSource.camera),
          ),
          ListTile(
            key: const Key('photo_source_gallery'),
            leading: AppIcon.decorative(
              Icons.photo_library_outlined,
              color: colors.accentText,
            ),
            title: Text(l10n.photoChooseFromGallery),
            onTap: () => Navigator.of(context).pop(PhotoSource.gallery),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    ),
  );
}

/// [PhotoNotice] için kullanıcı mesajı.
String photoNoticeMessage(
  AppLocalizations l10n,
  PhotoNotice notice, {
  required int maxPhotos,
}) => switch (notice.kind) {
  // Web'de izin tarayıcının site ayarlarından verilir.
  PhotoNoticeKind.cameraDenied =>
    kIsWeb ? l10n.photoCameraDeniedBrowser : l10n.photoCameraDenied,
  PhotoNoticeKind.galleryDenied => l10n.photoGalleryDenied,
  PhotoNoticeKind.pickFailed => l10n.photoPickFailed,
  PhotoNoticeKind.unsupported => l10n.photoUnsupported(notice.count),
  PhotoNoticeKind.limitReached => l10n.photoLimitReached(maxPhotos),
};

class _PhotoDescriptionSheet extends StatefulWidget {
  const _PhotoDescriptionSheet({
    required this.initial,
    required this.maxLength,
  });

  final String initial;
  final int maxLength;

  @override
  State<_PhotoDescriptionSheet> createState() => _PhotoDescriptionSheetState();
}

class _PhotoDescriptionSheetState extends State<_PhotoDescriptionSheet> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initial,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() => Navigator.of(context).pop(_controller.text.trim());

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          MediaQuery.viewInsetsOf(context).bottom + AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppText(
              l10n.photoDescriptionTitle,
              role: AppTextRole.headlineMedium,
              isHeading: true,
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              key: const Key('photo_description_field'),
              controller: _controller,
              autofocus: true,
              minLines: 2,
              maxLines: 4,
              maxLength: widget.maxLength,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.photoDescriptionLabel,
                helperText: l10n.photoDescriptionHelper,
                helperMaxLines: 3,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton(
              key: const Key('photo_description_save'),
              onPressed: _save,
              child: Text(l10n.commonSave),
            ),
          ],
        ),
      ),
    );
  }
}
