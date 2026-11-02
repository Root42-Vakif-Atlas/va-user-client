import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';

enum InlineMessageType { info, success, warning, error }

/// Form ve sayfa içi durum mesajı.
///
/// Durum yalnızca renkle değil, ikon + metin ile gösterilir (WCAG 1.4.1);
/// mesaj canlı bölge (live region) olarak işaretlendiğinden göründüğünde
/// ekran okuyucu tarafından okunur (WCAG 4.1.3).
///
/// Görünüm: kenar çizgisi yok. Bilgi nötr yüzeyde, başarı/uyarı/hata durum
/// renginin düz tonal zemininde durur; renk yalnızca ikonda, metin ön plan
/// renginde kalır (kontrast her temada ≥ 4.5:1). Yüksek kontrastta mesaj dört
/// kenardan çerçevelenir, çünkü düz tonlar orada ayırt edici olmaktan çıkar.
class InlineMessage extends StatelessWidget {
  const InlineMessage({
    required this.message,
    this.type = InlineMessageType.info,
    super.key,
  });

  final String message;
  final InlineMessageType type;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (icon, accent) = switch (type) {
      InlineMessageType.info => (Icons.info_outlined, colors.info),
      InlineMessageType.success => (
        Icons.check_circle_outlined,
        colors.success,
      ),
      InlineMessageType.warning => (
        Icons.warning_amber_outlined,
        colors.warning,
      ),
      InlineMessageType.error => (Icons.error_outlined, colors.error),
    };
    final fill = type == InlineMessageType.info
        ? colors.surfaceVariant
        : colors.tonal(accent);

    return Semantics(
      container: true,
      liveRegion: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: colors.isHighContrast
              ? Border.all(color: accent, width: AppSizes.borderThin)
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppIcon.decorative(icon, color: accent),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: AppText(message)),
            ],
          ),
        ),
      ),
    );
  }
}
