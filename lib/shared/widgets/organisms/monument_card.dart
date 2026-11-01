import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_network_image.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/molecules/location_tag.dart';

/// Eser özet kartı (harita önizlemesi, listeler).
///
/// Feature'dan bağımsızdır; metinler çağıran tarafından yerelleştirilmiş
/// verilir. %200 metin ölçeğinde içerik alt satırlara akar, sabit yükseklik
/// kullanılmaz.
class MonumentCard extends StatelessWidget {
  const MonumentCard({
    required this.name,
    required this.locationLabel,
    required this.locationSemanticsLabel,
    required this.description,
    this.tags = const [],
    this.address,
    this.addressSemanticsLabel,
    this.thumbnailUrl,
    this.trailing,
    this.action,
    this.scrollableBody = false,
    super.key,
  });

  final String name;
  final String locationLabel;
  final String locationSemanticsLabel;
  final String description;

  /// Yapı türü, dönem gibi bilgi etiketleri (`InfoChip`).
  final List<Widget> tags;
  final String? address;
  final String? addressSemanticsLabel;
  final String? thumbnailUrl;

  /// Başlık satırının sonunda (ör. kapat butonu).
  final Widget? trailing;

  /// Kartın birincil aksiyonu (ör. "Detayları gör").
  final Widget? action;

  /// `true` → yüksekliği sınırlı bir alanda (ör. harita altı panel) birincil
  /// aksiyon sabit kalır, içerik kaydırılır; böylece aksiyon %200 metin
  /// ölçeğinde de görünür ve taşma olmaz. Ebeveyn yüksekliği sınırlı
  /// olmalıdır.
  final bool scrollableBody;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final thumbnail = thumbnailUrl;
    final street = address;
    final actionWidget = action;

    final header = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (thumbnail != null) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: SizedBox.square(
              dimension: AppSizes.thumbnail,
              child: AppNetworkImage(url: thumbnail),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(name, role: AppTextRole.titleLarge, isHeading: true),
              const SizedBox(height: AppSpacing.xxs),
              LocationTag(
                label: locationLabel,
                semanticsLabel: locationSemanticsLabel,
              ),
            ],
          ),
        ),
        ?trailing,
      ],
    );

    final body = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (tags.isNotEmpty) ...[
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: tags,
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        // Metin kesilmez: büyütülmüş metinde içerik kaybolmamalı (WCAG 1.4.4).
        AppText(description, role: AppTextRole.bodyMedium),
        if (street != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Semantics(
            label: addressSemanticsLabel ?? street,
            excludeSemantics: true,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppIcon.decorative(
                  Icons.signpost_outlined,
                  size: AppSizes.iconSm,
                  color: colors.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.xxs),
                Expanded(child: AppText(street, role: AppTextRole.bodySmall)),
              ],
            ),
          ),
        ],
      ],
    );

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        header,
        const SizedBox(height: AppSpacing.sm),
        body,
      ],
    );

    return DecoratedBox(
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (scrollableBody)
              Flexible(child: SingleChildScrollView(child: content))
            else
              content,
            if (actionWidget != null) ...[
              const SizedBox(height: AppSpacing.md),
              actionWidget,
            ],
          ],
        ),
      ),
    );
  }
}
