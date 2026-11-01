import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/a11y/reduce_motion.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/ai_assistant/domain/entities/guide_message.dart';
import 'package:vakif_atlas/features/ai_assistant/presentation/ai_assistant_presentation.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/molecules/inline_message.dart';

/// Balonların sohbet sütunundaki en büyük payı.
const double _bubbleWidthFactor = 0.88;

/// Kullanıcının sorusu (sağda). Ekran okuyucu "Siz: …" olarak okur.
class GuideQuestionBubble extends StatelessWidget {
  const GuideQuestionBubble({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: FractionallySizedBox(
        widthFactor: _bubbleWidthFactor,
        alignment: AlignmentDirectional.centerEnd,
        child: Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Semantics(
            container: true,
            label: context.l10n.guideQuestionSemantics(text),
            excludeSemantics: true,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: const BorderRadiusDirectional.only(
                  topStart: Radius.circular(AppRadius.lg),
                  topEnd: Radius.circular(AppRadius.lg),
                  bottomStart: Radius.circular(AppRadius.lg),
                  bottomEnd: Radius.circular(AppRadius.xs),
                ).resolve(Directionality.of(context)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: AppText(text, color: colors.onPrimaryContainer),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Rehberin yanıtı (solda): metin, acil durum uyarısı, kaynaklar, eylem
/// butonları ve (en son yanıtta) devam önerileri.
class GuideAnswerBubble extends StatelessWidget {
  const GuideAnswerBubble({
    required this.message,
    required this.onAction,
    this.onSuggestion,
    super.key,
  });

  final GuideMessage message;
  final ValueChanged<GuideAction> onAction;

  /// `null` → öneriler gösterilmez (eski yanıtlar veya gönderim sürerken).
  final ValueChanged<String>? onSuggestion;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final sources = message.sources;
    final onSuggestion = this.onSuggestion;
    // Eylem ve öneriler balonun altında tam satır genişliğini kullanır.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FractionallySizedBox(
          widthFactor: _bubbleWidthFactor,
          alignment: AlignmentDirectional.centerStart,
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Semantics(
              container: true,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.surfaceVariant,
                  borderRadius: const BorderRadiusDirectional.only(
                    topStart: Radius.circular(AppRadius.xs),
                    topEnd: Radius.circular(AppRadius.lg),
                    bottomStart: Radius.circular(AppRadius.lg),
                    bottomEnd: Radius.circular(AppRadius.lg),
                  ).resolve(Directionality.of(context)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AppIcon.decorative(
                            Icons.assistant_outlined,
                            size: AppSizes.iconSm,
                            color: colors.accentText,
                          ),
                          const SizedBox(width: AppSpacing.xxs),
                          Flexible(
                            child: AppText(
                              l10n.aiAssistantTitle,
                              role: AppTextRole.labelMedium,
                              color: colors.accentText,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      if (message.notice == GuideNotice.emergency) ...[
                        InlineMessage(
                          message: l10n.cpEmergencyNotice,
                          type: InlineMessageType.warning,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                      ],
                      AppText(message.text, color: colors.onSurface),
                      if (sources.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.sm),
                        AppText(
                          l10n.guideSources(
                            sources.map((source) => source.name).join(', '),
                          ),
                          role: AppTextRole.bodySmall,
                          color: colors.onSurfaceVariant,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (message.actions.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final (index, action) in message.actions.indexed)
                AppButton.secondary(
                  key: Key('guide_action_${message.id}_$index'),
                  label: action.label(l10n),
                  semanticsLabel: action.semanticsLabel(l10n),
                  icon: action.icon,
                  onPressed: () => onAction(action),
                ),
            ],
          ),
        ],
        if (onSuggestion != null && message.suggestions.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          GuideSuggestionChips(
            suggestions: message.suggestions,
            onSelected: onSuggestion,
          ),
        ],
      ],
    );
  }
}

/// Dokunulduğunda soru olarak gönderilen öneriler.
class GuideSuggestionChips extends StatelessWidget {
  const GuideSuggestionChips({
    required this.suggestions,
    required this.onSelected,
    super.key,
  });

  final List<String> suggestions;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Semantics(
      container: true,
      label: l10n.guideSuggestionsSemantics,
      explicitChildNodes: true,
      child: Wrap(
        spacing: AppSpacing.xs,
        runSpacing: AppSpacing.xs,
        children: [
          for (final suggestion in suggestions)
            ActionChip(
              avatar: const AppIcon.decorative(
                Icons.chat_bubble_outline,
                size: AppSizes.iconSm,
              ),
              label: Text(suggestion),
              tooltip: l10n.guideAskSuggestion(suggestion),
              onPressed: () => onSelected(suggestion),
            ),
        ],
      ),
    );
  }
}

/// Yanıt beklenirken gösterilen durum; canlı bölge olarak okunur.
class GuideTypingIndicator extends StatelessWidget {
  const GuideTypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final label = context.l10n.guideTyping;
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Semantics(
        container: true,
        liveRegion: true,
        label: label,
        excludeSemantics: true,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (context.reduceMotion)
              AppIcon.decorative(
                Icons.hourglass_top,
                size: AppSizes.spinner,
                color: colors.accentText,
              )
            else
              SizedBox.square(
                dimension: AppSizes.spinner,
                child: CircularProgressIndicator(
                  strokeWidth: AppSizes.spinnerStroke,
                  color: colors.accentText,
                ),
              ),
            const SizedBox(width: AppSpacing.sm),
            Flexible(
              child: AppText(
                label,
                role: AppTextRole.bodyMedium,
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
