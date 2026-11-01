import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/a11y/haptic_feedback_service.dart';
import 'package:vakif_atlas/core/l10n/failure_messages.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/feedback/domain/entities/feedback_submission.dart';
import 'package:vakif_atlas/features/feedback/presentation/cubit/feedback_form_cubit.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/molecules/app_snack_bar.dart';
import 'package:vakif_atlas/shared/widgets/molecules/inline_message.dart';
import 'package:vakif_atlas/shared/widgets/templates/form_page_template.dart';

/// "Geri bildirim gönder": genel deneyim puanı (isteğe bağlı), konu ve
/// mesaj. Puan veya mesajdan biri yeterlidir. Başarıda teşekkür bildirilir
/// ve [onSubmitted] çağrılır. `FeedbackFormCubit` üst ağaçtan sağlanır.
class FeedbackPage extends StatelessWidget {
  const FeedbackPage({required this.onSubmitted, super.key});

  final VoidCallback onSubmitted;

  void _onChanged(BuildContext context, FeedbackFormState state) {
    final l10n = context.l10n;
    final announcer = context.read<A11yAnnouncer>();
    final haptics = context.read<HapticFeedbackService>();
    switch (state.status) {
      case FeedbackFormStatus.success:
        unawaited(haptics.success());
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            AppSnackBar.build(context, message: l10n.feedbackSent),
          );
        unawaited(announcer.announce(l10n.feedbackSent));
        onSubmitted();
      case FeedbackFormStatus.invalid:
        unawaited(haptics.error());
        final issue = state.issue;
        if (issue != null) {
          unawaited(
            announcer.announce(_issueMessage(l10n, issue), assertive: true),
          );
        }
      case FeedbackFormStatus.failure:
        unawaited(haptics.error());
        final failure = state.failure;
        if (failure != null) {
          unawaited(
            announcer.announce(failure.toUserMessage(l10n), assertive: true),
          );
        }
      case FeedbackFormStatus.editing || FeedbackFormStatus.submitting:
        break;
    }
  }

  static String _issueMessage(AppLocalizations l10n, FeedbackIssue issue) =>
      switch (issue) {
        FeedbackIssue.ratingOrMessageRequired => l10n.feedbackRequired,
        FeedbackIssue.messageTooLong => l10n.feedbackTooLong(
          FeedbackRules.maxMessage,
        ),
      };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.feedbackTitle)),
      body: BlocConsumer<FeedbackFormCubit, FeedbackFormState>(
        listenWhen: (previous, current) =>
            previous.status != current.status ||
            previous.invalidSubmissions != current.invalidSubmissions,
        listener: _onChanged,
        builder: (context, state) {
          final cubit = context.read<FeedbackFormCubit>();
          final enabled = !state.isSubmitting;
          final issue = state.showValidationErrors ? state.issue : null;
          final failure = state.failure;
          return FormPageTemplate(
            children: [
              _RatingField(
                rating: state.rating,
                enabled: enabled,
                onRate: cubit.rate,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppText(
                l10n.feedbackCategoryLabel,
                role: AppTextRole.titleMedium,
                isHeading: true,
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  for (final category in FeedbackCategory.values)
                    ChoiceChip(
                      key: Key('feedback_category_${category.name}'),
                      label: Text(_categoryLabel(l10n, category)),
                      selected: state.category == category,
                      onSelected: enabled
                          ? (_) => cubit.selectCategory(category)
                          : null,
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              TextField(
                key: const Key('feedback_message'),
                enabled: enabled,
                minLines: 5,
                maxLines: 10,
                maxLength: FeedbackRules.maxMessage,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                onChanged: cubit.changeMessage,
                decoration: InputDecoration(
                  labelText: l10n.feedbackMessageLabel,
                  hintText: l10n.feedbackMessageHint,
                  helperText: l10n.feedbackMessageHelper,
                  helperMaxLines: 3,
                  alignLabelWithHint: true,
                  errorText: issue == FeedbackIssue.messageTooLong
                      ? _issueMessage(l10n, issue!)
                      : null,
                ),
              ),
              if (issue == FeedbackIssue.ratingOrMessageRequired) ...[
                const SizedBox(height: AppSpacing.sm),
                InlineMessage(
                  key: const Key('feedback_required_error'),
                  type: InlineMessageType.error,
                  message: _issueMessage(l10n, issue!),
                ),
              ],
              if (state.status == FeedbackFormStatus.failure &&
                  failure != null) ...[
                const SizedBox(height: AppSpacing.sm),
                InlineMessage(
                  key: const Key('feedback_submit_error'),
                  type: InlineMessageType.error,
                  message: failure.toUserMessage(l10n),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              AppButton.primary(
                key: const Key('feedback_submit_button'),
                label: l10n.feedbackSubmit,
                icon: Icons.send_outlined,
                expand: true,
                isLoading: state.isSubmitting,
                onPressed: () => unawaited(cubit.submit()),
              ),
            ],
          );
        },
      ),
    );
  }

  static String _categoryLabel(
    AppLocalizations l10n,
    FeedbackCategory category,
  ) => switch (category) {
    FeedbackCategory.suggestion => l10n.feedbackCategorySuggestion,
    FeedbackCategory.bug => l10n.feedbackCategoryBug,
    FeedbackCategory.accessibility => l10n.feedbackCategoryAccessibility,
    FeedbackCategory.content => l10n.feedbackCategoryContent,
    FeedbackCategory.other => l10n.feedbackCategoryOther,
  };
}

/// 1–5 yıldız. Her yıldız ayrı, 48 dp, etiketli düğmedir ("4 yıldız");
/// seçili puan adıyla birlikte gösterilir ve okunur ("4 / 5, İyi").
class _RatingField extends StatelessWidget {
  const _RatingField({
    required this.rating,
    required this.enabled,
    required this.onRate,
  });

  final int? rating;
  final bool enabled;
  final ValueChanged<int> onRate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final value = rating;
    final names = [
      l10n.feedbackRating1,
      l10n.feedbackRating2,
      l10n.feedbackRating3,
      l10n.feedbackRating4,
      l10n.feedbackRating5,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(
          l10n.feedbackRatingLabel,
          role: AppTextRole.titleMedium,
          isHeading: true,
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            for (
              var star = FeedbackRules.minRating;
              star <= FeedbackRules.maxRating;
              star++
            )
              Semantics(
                selected: value != null && star <= value,
                child: IconButton(
                  key: Key('feedback_star_$star'),
                  tooltip: l10n.feedbackRateStars(star),
                  iconSize: AppSizes.iconLg,
                  onPressed: enabled ? () => onRate(star) : null,
                  icon: Icon(
                    value != null && star <= value
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: value != null && star <= value
                        ? colors.primary
                        : colors.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        ),
        AppText(
          value == null
              ? l10n.feedbackRatingOptional
              : l10n.feedbackRatingValue(value, names[value - 1]),
          key: const Key('feedback_rating_caption'),
          role: AppTextRole.bodyMedium,
          color: colors.onSurfaceVariant,
        ),
      ],
    );
  }
}
