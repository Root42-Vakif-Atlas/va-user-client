import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';

/// Durum görünümünün tonu: boş durum ve bilgi nötr, hata vurgulu.
enum StatusMessageTone { neutral, error }

/// Hata, boş durum ve hazırlık aşamasındaki sayfalar için ortak tam sayfa
/// görünüm.
///
/// İçerik görsel merkeze (ortanın biraz üstü) yerleşir; %200 metin
/// ölçeğinde kaydırılabilir kalır. Ayrıntı: [StatusMessageContent].
class StatusMessageView extends StatelessWidget {
  const StatusMessageView({
    required this.icon,
    required this.title,
    required this.message,
    this.tone = StatusMessageTone.neutral,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
    super.key,
  });

  final IconData icon;
  final String title;
  final String message;
  final StatusMessageTone tone;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final content = StatusMessageContent(
      icon: icon,
      title: title,
      message: message,
      tone: tone,
      actionLabel: actionLabel,
      actionIcon: actionIcon,
      onAction: onAction,
    );
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.hasBoundedHeight
                  ? (constraints.maxHeight - AppSpacing.lg * 2).clamp(
                      0,
                      double.infinity,
                    )
                  : 0,
            ),
            // Görsel merkez: tam ortadan biraz yukarıda daha dengeli durur.
            child: Align(alignment: const Alignment(0, -0.2), child: content),
          ),
        ),
      ),
    );
  }
}

/// İkon dairesi, başlık, kısa açıklama ve isteğe bağlı tek birincil eylem.
///
/// - Boş durumda bir sonraki adım varsa eylem verilir (ör. "Haritada
///   keşfet"); sayfada aynı eylem zaten görünüyorsa tekrarlanmaz.
/// - İkon dekoratiftir; başlık ekran okuyucu başlığıdır.
/// - [compact]: liste içinde (filtre sonucu boş vb.) daha küçük daire ve
///   başlık.
class StatusMessageContent extends StatelessWidget {
  const StatusMessageContent({
    required this.icon,
    required this.title,
    required this.message,
    this.tone = StatusMessageTone.neutral,
    this.compact = false,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
    this.actionKey,
    super.key,
  });

  final IconData icon;
  final String title;
  final String message;
  final StatusMessageTone tone;
  final bool compact;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;
  final Key? actionKey;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final action = actionLabel;
    final (Color badge, Color foreground) = switch (tone) {
      StatusMessageTone.neutral => (
        colors.secondaryContainer,
        colors.onSecondaryContainer,
      ),
      StatusMessageTone.error => (
        Color.alphaBlend(colors.error.withValues(alpha: 0.12), colors.surface),
        colors.error,
      ),
    };
    final badgeSize = compact
        ? AppSizes.statusBadgeCompact
        : AppSizes.statusBadge;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: AppSizes.statusTextWidth),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: badgeSize,
            height: badgeSize,
            decoration: BoxDecoration(color: badge, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: AppIcon.decorative(
              icon,
              size: compact ? AppSizes.iconLg : AppSizes.iconXl,
              color: foreground,
            ),
          ),
          SizedBox(height: compact ? AppSpacing.sm : AppSpacing.lg),
          AppText(
            title,
            role: compact ? AppTextRole.titleMedium : AppTextRole.titleLarge,
            textAlign: TextAlign.center,
            isHeading: true,
          ),
          const SizedBox(height: AppSpacing.xs),
          AppText(
            message,
            role: AppTextRole.bodyMedium,
            color: colors.onSurfaceVariant,
            textAlign: TextAlign.center,
          ),
          if (action != null) ...[
            SizedBox(height: compact ? AppSpacing.md : AppSpacing.lg),
            if (compact)
              AppButton.secondary(
                key: actionKey,
                label: action,
                icon: actionIcon,
                onPressed: onAction,
              )
            else
              AppButton.primary(
                key: actionKey,
                label: action,
                icon: actionIcon,
                onPressed: onAction,
              ),
          ],
        ],
      ),
    );
  }
}
