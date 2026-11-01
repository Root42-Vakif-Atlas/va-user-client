import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_detail.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_image.dart';
import 'package:vakif_atlas/features/catalog/presentation/catalog_presentation.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_network_image.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';

/// Başlıklı bölüm (başlık ekran okuyucu başlık gezinmesine dahildir).
class MonumentSection extends StatelessWidget {
  const MonumentSection({required this.title, required this.child, super.key});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(title, role: AppTextRole.headlineMedium, isHeading: true),
        const SizedBox(height: AppSpacing.sm),
        child,
      ],
    );
  }
}

/// Paragrafları boş satırla ayrılmış düz metin.
class MonumentParagraphs extends StatelessWidget {
  const MonumentParagraphs({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final paragraphs = [
      for (final paragraph in text.split('\n\n'))
        if (paragraph.trim().isNotEmpty) paragraph.trim(),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < paragraphs.length; index++) ...[
          if (index > 0) const SizedBox(height: AppSpacing.sm),
          AppText(paragraphs[index]),
        ],
      ],
    );
  }
}

/// Eser künyesi: yapı türü, dönem, yapım tarihi, bani ve mimar — başlığın
/// hemen altında, iki sütunlu kompakt kart (dar ekranda veya büyük metin
/// ölçeğinde tek sütun). Her satır ekran okuyucuya "Etiket: değer" olarak
/// okunur.
class MonumentFactsCard extends StatelessWidget {
  const MonumentFactsCard({
    required this.monument,
    this.memberCount,
    super.key,
  });

  final MonumentDetail monument;

  /// Külliyede yapı sayısı satırı; `null` → gösterilmez.
  final int? memberCount;

  /// Bu genişliğin altında veya metin ölçeği [_singleColumnScale]'i
  /// aştığında tek sütuna geçilir (taşma olmadan okunur kalır).
  static const double _twoColumnMinWidth = 320;
  static const double _singleColumnScale = 1.3;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final architect = monument.architect;
    final facts = <(IconData, String, String)>[
      (
        monument.category.icon,
        l10n.monumentCategoryLabel,
        monument.category.label(l10n),
      ),
      (
        Icons.history_edu_outlined,
        l10n.monumentPeriodLabel,
        monument.period.label(l10n),
      ),
      (
        Icons.event_outlined,
        l10n.monumentConstructionLabel,
        monument.constructionDate,
      ),
      (Icons.person_outline, l10n.monumentFounderLabel, monument.founder),
      if (architect != null)
        (Icons.architecture, l10n.monumentArchitectLabel, architect),
      if (memberCount case final count?)
        (
          Icons.apartment_outlined,
          l10n.complexFactMembers,
          l10n.complexMemberCount(count),
        ),
    ];
    final scale = MediaQuery.textScalerOf(context).scale(1);
    return DecoratedBox(
      key: const Key('monument_facts_card'),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        border: Border.all(
          color: colors.outlineVariant,
          width: AppSizes.borderThin,
        ),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppText(
              l10n.monumentFactsHeading,
              role: AppTextRole.labelLarge,
              color: colors.onSurfaceVariant,
              isHeading: true,
            ),
            const SizedBox(height: AppSpacing.sm),
            LayoutBuilder(
              builder: (context, constraints) {
                final columns =
                    constraints.maxWidth >= _twoColumnMinWidth &&
                        scale <= _singleColumnScale
                    ? 2
                    : 1;
                final width =
                    (constraints.maxWidth - AppSpacing.md * (columns - 1)) /
                    columns;
                return Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.sm,
                  children: [
                    for (final (icon, label, value) in facts)
                      SizedBox(
                        width: width,
                        child: _Fact(icon: icon, label: label, value: value),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      label: '$label: $value',
      excludeSemantics: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIcon.decorative(
            icon,
            size: AppSizes.iconInline,
            color: colors.accentText,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  label,
                  role: AppTextRole.labelMedium,
                  color: colors.onSurfaceVariant,
                ),
                AppText(value, role: AppTextRole.titleMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Fotoğrafların lisans künyesi (CC BY / CC BY-SA atıf yükümlülüğü).
class PhotoCreditsSection extends StatelessWidget {
  const PhotoCreditsSection({required this.images, super.key});

  final List<MonumentImage> images;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return MonumentSection(
      title: l10n.monumentPhotoCreditsHeading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var index = 0; index < images.length; index++) ...[
            if (index > 0) const SizedBox(height: AppSpacing.sm),
            _PhotoCredit(index: index + 1, image: images[index]),
          ],
          const SizedBox(height: AppSpacing.xs),
          AppText(
            l10n.photoCreditsNotice,
            role: AppTextRole.bodySmall,
            color: colors.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

class _PhotoCredit extends StatelessWidget {
  const _PhotoCredit({required this.index, required this.image});

  final int index;
  final MonumentImage image;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final sourceUrl = image.sourceUrl;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          l10n.photoCreditTitle(index, image.altText),
          role: AppTextRole.bodyMedium,
        ),
        AppText(
          l10n.photoCredit(image.author, image.license, image.sourceName),
          role: AppTextRole.bodySmall,
          semanticsLabel: l10n.photoCreditSemantics(
            index,
            image.author,
            image.license,
            image.sourceName,
          ),
        ),
        if (sourceUrl != null)
          SelectableText(
            sourceUrl,
            style: context.textStyles.bodySmall.copyWith(
              color: context.colors.accentText,
            ),
          ),
      ],
    );
  }
}

/// Eser bölümü (VGM verisi): başlık, paragraflar ve bölüm görselleri.
/// Görseller yalnızca görseldir; betimi ekran okuyucuya okunur (WCAG 1.1.1),
/// künyeleri sayfa sonundaki görsel künyelerindedir.
class MonumentPartSection extends StatelessWidget {
  const MonumentPartSection({
    required this.part,
    required this.title,
    super.key,
  });

  final MonumentPart part;
  final String title;

  static const double _imageWidth = 160;

  @override
  Widget build(BuildContext context) {
    return MonumentSection(
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MonumentParagraphs(text: part.description),
          if (part.images.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final image in part.images)
                  SizedBox(
                    width: _imageWidth,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      child: AspectRatio(
                        aspectRatio: 4 / 3,
                        child: AppNetworkImage(
                          url: image.thumbnailUrl,
                          semanticsLabel: image.altText,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
