import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';

/// Bölüm başlığı: uygulamadaki tek stil (`titleMedium`, ön plan rengi).
///
/// Başlık ekran okuyucuda başlık olarak işaretlenir (WCAG 1.3.1); renk
/// vurgusu yerine ağırlık ve boşlukla öne çıkar. [trailing] aynı satırın
/// sonuna eylem (ör. "Tümünü gör") koyar.
class SectionHeader extends StatelessWidget {
  const SectionHeader(
    this.title, {
    this.trailing,
    this.padding = EdgeInsets.zero,
    super.key,
  });

  final String title;
  final Widget? trailing;

  /// Sayfa kenar boşluğu dışarıdan verilir (liste tam genişlikteyse md).
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final heading = AppText(
      title,
      role: AppTextRole.titleMedium,
      color: context.colors.onSurface,
      isHeading: true,
    );
    final end = trailing;
    return Padding(
      padding: padding,
      child: end == null
          ? heading
          : Row(
              children: [
                Expanded(child: heading),
                end,
              ],
            ),
    );
  }
}
