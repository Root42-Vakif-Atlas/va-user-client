import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/a11y/haptic_feedback_service.dart';
import 'package:vakif_atlas/core/a11y/reduce_motion.dart';
import 'package:vakif_atlas/core/l10n/failure_messages.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_durations.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/ai_assistant/domain/entities/guide_message.dart';
import 'package:vakif_atlas/features/ai_assistant/presentation/bloc/digital_guide_bloc.dart';
import 'package:vakif_atlas/features/ai_assistant/presentation/cubit/guide_voice_cubit.dart';
import 'package:vakif_atlas/features/ai_assistant/presentation/widgets/guide_chat_bubbles.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/molecules/inline_message.dart';

/// Dijital Rehber sekmesi (`/ai-assistant`): VGM kataloğuna dayalı sohbet.
///
/// - Rehber soruyu yanıtlar ve uygun ekranlara eylem butonlarıyla
///   yönlendirir; eylemler yalnızca kullanıcı dokununca çalışır
///   ([onAction], kompozisyon kökünde rotaya çevrilir).
/// - Yanıtlar ekran okuyucuya duyurulur (WCAG 4.1.3); öneriler sorunun
///   yazılmadan sorulmasını sağlar.
/// - Soru sesle de sorulabilir: tanınan metin soru alanına yazılır,
///   kullanıcı gözden geçirip gönderir ([GuideVoiceCubit]).
/// - [DigitalGuideBloc] ve [GuideVoiceCubit] üst ağaçtan sağlanır.
class DigitalGuidePage extends StatefulWidget {
  const DigitalGuidePage({
    required this.onAction,
    this.actions = const [],
    super.key,
  });

  final ValueChanged<GuideAction> onAction;
  final List<Widget> actions;

  @override
  State<DigitalGuidePage> createState() => _DigitalGuidePageState();
}

class _DigitalGuidePageState extends State<DigitalGuidePage> {
  final TextEditingController _input = TextEditingController();
  final FocusNode _inputFocus = FocusNode();
  final ScrollController _scroll = ScrollController();

  /// En son yanıtın balonu; yeni yanıtın başı görünür kaydırılır.
  final GlobalKey _latestAnswer = GlobalKey(debugLabel: 'latestAnswer');

  DigitalGuideBloc get _bloc => context.read<DigitalGuideBloc>();

  GuideVoiceCubit get _voice => context.read<GuideVoiceCubit>();

  /// Dinleme başladığında alanda yazılı olan metin; tanınan metin buna
  /// eklenir.
  String _voiceBase = '';
  late GuideVoiceState _lastVoice = _voice.state;

  String get _languageCode => Localizations.localeOf(context).languageCode;

  @override
  void dispose() {
    _input.dispose();
    _inputFocus.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _ask(String question) {
    if (GuideRules.validate(question) != null || _bloc.state.isSending) {
      return;
    }
    _bloc.add(
      DigitalGuideEvent.questionSubmitted(
        question: question,
        languageCode: _languageCode,
      ),
    );
  }

  void _submitInput() {
    final question = _input.text;
    if (GuideRules.validate(question) != null || _bloc.state.isSending) {
      return;
    }
    _ask(question);
    _input.clear();
    _voice.clearIssue();
  }

  void _toggleVoice() => unawaited(_voice.toggle(languageCode: _languageCode));

  void _onVoiceChanged(BuildContext context, GuideVoiceState voice) {
    final previous = _lastVoice;
    _lastVoice = voice;
    final l10n = context.l10n;
    final announcer = context.read<A11yAnnouncer>();
    final haptics = context.read<HapticFeedbackService>();
    if (voice.isListening && voice.session != previous.session) {
      _voiceBase = _input.text.trim();
      unawaited(haptics.selection());
      unawaited(announcer.announce(l10n.guideVoiceListening));
    }
    if (voice.isListening && voice.transcript != previous.transcript) {
      _showTranscript(voice.transcript);
    }
    if (previous.isListening && !voice.isListening) {
      unawaited(haptics.selection());
      final heard = voice.transcript.trim();
      if (heard.isNotEmpty) {
        _showTranscript(heard);
        unawaited(announcer.announce(l10n.guideVoiceHeard(heard)));
        _inputFocus.requestFocus();
      }
    }
    final issue = voice.issue;
    if (issue != null && issue != previous.issue) {
      unawaited(
        announcer.announce(_voiceIssueMessage(l10n, voice), assertive: true),
      );
    }
  }

  void _showTranscript(String transcript) {
    final joined = [
      _voiceBase,
      transcript.trim(),
    ].where((part) => part.isNotEmpty).join(' ');
    final text = String.fromCharCodes(
      joined.runes.take(GuideRules.maxQuestionLength),
    );
    _input.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  void _reset() {
    _bloc.add(const DigitalGuideEvent.conversationReset());
    _input.clear();
    unawaited(
      context.read<A11yAnnouncer>().announce(
        context.l10n.guideResetAnnouncement,
      ),
    );
    _inputFocus.requestFocus();
  }

  void _onStateChanged(BuildContext context, DigitalGuideState state) {
    final l10n = context.l10n;
    final announcer = context.read<A11yAnnouncer>();
    final failure = state.failure;
    if (failure != null) {
      unawaited(
        announcer.announce(
          '${l10n.guideSendFailed} ${failure.toUserMessage(l10n)}',
          assertive: true,
        ),
      );
    } else if (state.latestAnswer case final GuideMessage answer
        when !state.isSending) {
      unawaited(announcer.announce(l10n.guideAnswerAnnouncement(answer.text)));
      _reveal(answer: true);
      return;
    }
    _reveal(answer: false);
  }

  /// Soru ve bekleme göstergesi için sona; yeni yanıtta yanıtın başına
  /// kaydırılır (uzun yanıtın başı kaybolmaz).
  void _reveal({required bool answer}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scroll.hasClients) {
        return;
      }
      // Tembel listede son öğenin kurulması için önce sona atlanır.
      _scroll.jumpTo(_scroll.position.maxScrollExtent);
      if (!answer) {
        return;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final target = _latestAnswer.currentContext;
        if (!mounted || target == null || !target.mounted) {
          return;
        }
        unawaited(
          Scrollable.ensureVisible(
            target,
            duration: context.motionDuration(AppDurations.medium),
            curve: Curves.easeOut,
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<GuideVoiceCubit, GuideVoiceState>(
      listener: _onVoiceChanged,
      child: _buildConversation(context, l10n),
    );
  }

  Widget _buildConversation(BuildContext context, AppLocalizations l10n) {
    return BlocConsumer<DigitalGuideBloc, DigitalGuideState>(
      listenWhen: (previous, current) =>
          previous.entries.length != current.entries.length ||
          previous.isSending != current.isSending ||
          (current.failure != null && previous.failure != current.failure),
      listener: _onStateChanged,
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: Text(l10n.aiAssistantTitle),
          actions: [
            if (!state.isEmpty)
              IconButton(
                key: const Key('guide_new_conversation'),
                tooltip: l10n.guideNewConversation,
                icon: const Icon(Icons.add_comment_outlined),
                onPressed: _reset,
              ),
            ...widget.actions,
          ],
        ),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                child: state.isEmpty && !state.isSending
                    ? _Welcome(onSuggestion: _ask)
                    : _Conversation(
                        state: state,
                        controller: _scroll,
                        latestAnswerKey: _latestAnswer,
                        onAction: widget.onAction,
                        onSuggestion: _ask,
                        onRetry: () => _bloc.add(
                          DigitalGuideEvent.retryRequested(
                            languageCode: _languageCode,
                          ),
                        ),
                      ),
              ),
              _Composer(
                controller: _input,
                focusNode: _inputFocus,
                isSending: state.isSending,
                onSubmit: _submitInput,
                onToggleVoice: _toggleVoice,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// İçerik sütunu: okunabilir satır uzunluğu için ortalanmış, sınırlı genişlik.
class _ContentColumn extends StatelessWidget {
  const _ContentColumn({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
      child: child,
    ),
  );
}

class _Welcome extends StatelessWidget {
  const _Welcome({required this.onSuggestion});

  final ValueChanged<String> onSuggestion;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final starters = [
      (Icons.route_outlined, l10n.guideStarterRoute),
      (Icons.add_alert_outlined, l10n.guideStarterDamage),
    ];
    return _ContentColumn(
      child: ListView(
        key: const Key('guide_welcome'),
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const SizedBox(height: AppSpacing.md),
          Center(
            child: AppIcon.decorative(
              Icons.assistant_outlined,
              size: AppSizes.iconXl,
              color: colors.accentText,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppText(
            l10n.guideWelcomeTitle,
            role: AppTextRole.headlineMedium,
            textAlign: TextAlign.center,
            isHeading: true,
          ),
          const SizedBox(height: AppSpacing.xs),
          AppText(
            l10n.guideWelcomeBody,
            textAlign: TextAlign.center,
            color: colors.onSurfaceVariant,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppText(
            l10n.guideStartersHeading,
            role: AppTextRole.titleMedium,
            isHeading: true,
          ),
          const SizedBox(height: AppSpacing.xs),
          for (final (index, (icon, question)) in starters.indexed) ...[
            _StarterTile(
              key: Key('guide_starter_$index'),
              icon: icon,
              question: question,
              onTap: () => onSuggestion(question),
            ),
            const SizedBox(height: AppSpacing.xs),
          ],
        ],
      ),
    );
  }
}

class _StarterTile extends StatelessWidget {
  const _StarterTile({
    required this.icon,
    required this.question,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String question;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.surfaceVariant,
      borderRadius: BorderRadius.circular(AppRadius.md),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Semantics(
          button: true,
          label: context.l10n.guideAskSuggestion(question),
          excludeSemantics: true,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AppSizes.minTouchTarget,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  AppIcon.decorative(icon, color: colors.accentText),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: AppText(question)),
                  AppIcon.decorative(
                    Icons.north_east,
                    size: AppSizes.iconSm,
                    color: colors.onSurfaceVariant,
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

class _Conversation extends StatelessWidget {
  const _Conversation({
    required this.state,
    required this.controller,
    required this.latestAnswerKey,
    required this.onAction,
    required this.onSuggestion,
    required this.onRetry,
  });

  final DigitalGuideState state;
  final ScrollController controller;
  final GlobalKey latestAnswerKey;
  final ValueChanged<GuideAction> onAction;
  final ValueChanged<String> onSuggestion;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final entries = state.entries;
    final failure = state.failure;
    final latest = state.latestAnswer;
    return _ContentColumn(
      child: ListView(
        key: const Key('guide_conversation'),
        controller: controller,
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          for (final entry in entries) ...[
            switch (entry) {
              GuideQuestionEntry(:final id, :final text) => GuideQuestionBubble(
                key: ValueKey(id),
                text: text,
              ),
              GuideAnswerEntry(:final message) => KeyedSubtree(
                key: identical(message, latest)
                    ? latestAnswerKey
                    : ValueKey(message.id),
                child: GuideAnswerBubble(
                  message: message,
                  onAction: onAction,
                  onSuggestion: identical(message, latest) && !state.isSending
                      ? onSuggestion
                      : null,
                ),
              ),
            },
            const SizedBox(height: AppSpacing.md),
          ],
          if (state.isSending) const GuideTypingIndicator(),
          if (failure != null) ...[
            InlineMessage(
              key: const Key('guide_send_error'),
              message: '${l10n.guideSendFailed} ${failure.toUserMessage(l10n)}',
              type: InlineMessageType.error,
            ),
            const SizedBox(height: AppSpacing.xs),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: AppButton.secondary(
                key: const Key('guide_retry'),
                label: l10n.commonRetry,
                icon: Icons.refresh,
                onPressed: onRetry,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Soru yazma çubuğu ve gizlilik notu.
class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.focusNode,
    required this.isSending,
    required this.onSubmit,
    required this.onToggleVoice,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isSending;
  final VoidCallback onSubmit;
  final VoidCallback onToggleVoice;

  static const int _maxLines = 4;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final voice = context.watch<GuideVoiceCubit>().state;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.outlineVariant)),
      ),
      child: _ContentColumn(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.xs,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _VoiceStatus(voice: voice),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller,
                builder: (context, value, _) {
                  final length = value.text.trim().runes.length;
                  final canSend =
                      !isSending && GuideRules.validate(value.text) == null;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextField(
                          key: const Key('guide_input'),
                          controller: controller,
                          focusNode: focusNode,
                          // Dinlerken alan tanınan metinle güncellenir.
                          readOnly: voice.isListening,
                          minLines: 1,
                          maxLines: _maxLines,
                          textInputAction: TextInputAction.send,
                          textCapitalization: TextCapitalization.sentences,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(
                              GuideRules.maxQuestionLength,
                            ),
                          ],
                          onSubmitted: (_) => onSubmit(),
                          decoration: InputDecoration(
                            labelText: l10n.guideInputLabel,
                            hintText: l10n.guideInputHint,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            counterText: length >= GuideRules.counterThreshold
                                ? l10n.guideInputCounter(
                                    length,
                                    GuideRules.maxQuestionLength,
                                  )
                                : null,
                          ),
                        ),
                      ),
                      if (voice.isAvailable) ...[
                        const SizedBox(width: AppSpacing.xs),
                        _VoiceButton(voice: voice, onPressed: onToggleVoice),
                      ],
                      const SizedBox(width: AppSpacing.xs),
                      IconButton.filled(
                        key: const Key('guide_send'),
                        tooltip: l10n.guideSend,
                        constraints: const BoxConstraints.tightFor(
                          width: AppSizes.minTouchTarget,
                          height: AppSizes.minTouchTarget,
                        ),
                        onPressed: canSend && !voice.isListening
                            ? onSubmit
                            : null,
                        icon: const Icon(Icons.send),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xs),
              AppText(
                l10n.guidePrivacyNotice,
                role: AppTextRole.bodySmall,
                color: colors.onSurfaceVariant,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _voiceIssueMessage(AppLocalizations l10n, GuideVoiceState voice) =>
    switch (voice.issue) {
      null => '',
      GuideVoiceIssue.permissionDenied => l10n.guideVoicePermissionDenied,
      GuideVoiceIssue.permissionBlocked =>
        voice.canOpenSettings
            ? l10n.guideVoicePermissionBlocked
            : l10n.guideVoicePermissionBlockedWeb,
      GuideVoiceIssue.unavailable => l10n.guideVoiceUnavailable,
      GuideVoiceIssue.noMatch => l10n.guideVoiceNoMatch,
      GuideVoiceIssue.failed => l10n.guideVoiceFailed,
    };

/// Sesli soru düğmesi: dinlemiyorken "Sesli sor", dinlerken "Dinlemeyi
/// durdur" (ikon + ipucu + semantik etiket değişir).
class _VoiceButton extends StatelessWidget {
  const _VoiceButton({required this.voice, required this.onPressed});

  final GuideVoiceState voice;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final listening = voice.isListening;
    const constraints = BoxConstraints.tightFor(
      width: AppSizes.minTouchTarget,
      height: AppSizes.minTouchTarget,
    );
    final enabled = voice.status != GuideVoiceStatus.preparing;
    return listening
        ? IconButton.filledTonal(
            key: const Key('guide_voice_stop'),
            tooltip: l10n.guideVoiceStop,
            constraints: constraints,
            onPressed: onPressed,
            icon: const Icon(Icons.stop),
          )
        : IconButton.outlined(
            key: const Key('guide_voice_start'),
            tooltip: l10n.guideVoiceStart,
            constraints: constraints,
            onPressed: enabled ? onPressed : null,
            icon: const Icon(Icons.mic_none),
          );
  }
}

/// Dinleme göstergesi veya sesli sorunun alınamama nedeni. Durum
/// değişiklikleri sayfada duyurulur; burada yalnızca görünür metin vardır.
class _VoiceStatus extends StatelessWidget {
  const _VoiceStatus({required this.voice});

  final GuideVoiceState voice;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final issue = voice.issue;
    if (voice.isListening) {
      return Padding(
        key: const Key('guide_voice_listening'),
        padding: const EdgeInsets.only(bottom: AppSpacing.xs),
        child: Row(
          children: [
            AppIcon.decorative(Icons.mic, color: colors.primary),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: AppText(
                l10n.guideVoiceListening,
                role: AppTextRole.labelLarge,
              ),
            ),
          ],
        ),
      );
    }
    if (issue == null) {
      return const SizedBox.shrink();
    }
    final cubit = context.read<GuideVoiceCubit>();
    return Padding(
      key: const Key('guide_voice_issue'),
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InlineMessage(
            message: _voiceIssueMessage(l10n, voice),
            type: issue == GuideVoiceIssue.unavailable
                ? InlineMessageType.info
                : InlineMessageType.warning,
          ),
          if (issue == GuideVoiceIssue.permissionBlocked &&
              voice.canOpenSettings)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: AppButton.ghost(
                key: const Key('guide_voice_settings'),
                label: l10n.permissionOpenAppSettings,
                icon: Icons.open_in_new,
                onPressed: () => unawaited(cubit.openSettings()),
              ),
            ),
        ],
      ),
    );
  }
}
