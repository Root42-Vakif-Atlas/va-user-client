import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';

/// Sayfanın tek "tamamla" eylemi için sabit alt çubuk: form, adım adım akış
/// ve seçim sayfalarında birincil eylemin her zaman aynı yerde durmasını
/// sağlar.
///
/// Yerleşim kuralı:
/// - [primary] sağda ve geniştir (iki kat pay); yalnızca bu eylem vurgulu.
/// - [secondary] (Geri / Vazgeç) solda, daha dar ve vurgusuz.
/// - Yıkıcı eylem bu çubukta bulunmaz; sayfanın sonunda ayrı bölümde durur.
/// - [header]: eylemlerin üstünde özet, hata veya yükleme ilerlemesi.
///
/// Çubuk içerik kadar yükselir, güvenli alanı korur ve %200 metin ölçeğinde
/// bile eylemlere kaydırmadan ulaşılabilir kalır (WCAG 2.5.8, 1.4.4).
class BottomActionBar extends StatelessWidget {
  const BottomActionBar({
    required this.primary,
    this.secondary,
    this.header,
    super.key,
  });

  /// Genellikle `AppButton.primary(expand: true)`.
  final Widget primary;

  /// Genellikle `AppButton.secondary(expand: true)`.
  final Widget? secondary;
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final back = secondary;
    final top = header;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          top: BorderSide(
            color: colors.outlineVariant,
            width: AppSizes.borderThin,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Align(
          // Alt yuvada dikeyde genişlememesi için yalnızca içerik kadar yükseklik.
          alignment: Alignment.topCenter,
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSizes.maxContentWidth,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (top != null) ...[
                    top,
                    const SizedBox(height: AppSpacing.sm),
                  ],
                  if (back == null)
                    primary
                  else
                    Row(
                      children: [
                        Expanded(child: back),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(flex: 2, child: primary),
                      ],
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
