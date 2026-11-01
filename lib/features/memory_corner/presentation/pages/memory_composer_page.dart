import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/l10n/failure_messages.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/media/photo_draft.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory_draft.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/bloc/memory_composer_bloc.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/memory_presentation.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/molecules/app_snack_bar.dart';
import 'package:vakif_atlas/shared/widgets/molecules/inline_message.dart';
import 'package:vakif_atlas/shared/widgets/organisms/photo_draft_strip.dart';
import 'package:vakif_atlas/shared/widgets/templates/loading_status_view.dart';
import 'package:vakif_atlas/shared/widgets/templates/status_message_view.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory.dart';

/// Anı paylaşma ekranı (`/monument/:id/memory-corner/new`, oturum gerekir).
///
/// - Metin zorunlu; fotoğraf (en çok 4, betimli) ve ziyaret tarihi isteğe
///   bağlı. Fotoğraflar seçildiği anda cihazda küçültülür, konum ve cihaz
///   bilgisi silinir.
/// - Kaydedilmemiş içerikle çıkarken onay istenir.
/// - Hatalar ilk denemeden sonra alanların altında gösterilir ve duyurulur;
///   metin hatasında odak metin alanına taşınır.
/// - Paylaşım tamamlanınca SnackBar ile bildirilir ve [onSubmitted] çağrılır.
class MemoryComposerPage extends StatefulWidget {
  const MemoryComposerPage({
    required this.monumentId,
    required this.authorName,
    required this.onClose,
    required this.onSubmitted,
    this.onOpenMyMemories,
    super.key,
  });

  final String monumentId;

  /// Oturumdaki tam ad; herkese açık kısaltması önizlemede gösterilir.
  final String authorName;
  final VoidCallback onClose;
  final VoidCallback onSubmitted;

  /// Paylaşım incelemeye alındıysa veya yayınlanmadıysa bildirimdeki eylem.
  final VoidCallback? onOpenMyMemories;

  @override
  State<MemoryComposerPage> createState() => _MemoryComposerPageState();
}

class _MemoryComposerPageState extends State<MemoryComposerPage> {
  final TextEditingController _text = TextEditingController();
  final FocusNode _textFocus = FocusNode();
  String? _languageCode;

  MemoryComposerBloc get _bloc => context.read<MemoryComposerBloc>();

  @override
  void initState() {
    super.initState();
    _text.addListener(
      () => _bloc.add(MemoryComposerEvent.textChanged(_text.text)),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageCode = Localizations.localeOf(context).languageCode;
    if (languageCode != _languageCode) {
      _languageCode = languageCode;
      _bloc.add(
        MemoryComposerEvent.started(
          monumentId: widget.monumentId,
          languageCode: languageCode,
        ),
      );
    }
  }

  @override
  void dispose() {
    _text.dispose();
    _textFocus.dispose();
    super.dispose();
  }

  Future<void> _confirmClose() async {
    final state = _bloc.state;
    if (state.isSubmitting) {
      return;
    }
    if (!state.isDirty) {
      widget.onClose();
      return;
    }
    final l10n = context.l10n;
    final discard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.memoryDiscardTitle),
        content: Text(l10n.memoryDiscardBody),
        actions: [
          TextButton(
            key: const Key('memory_discard_cancel'),
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.memoryKeepEditing),
          ),
          TextButton(
            key: const Key('memory_discard_confirm'),
            style: TextButton.styleFrom(foregroundColor: context.colors.error),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.memoryDiscardConfirm),
          ),
        ],
      ),
    );
    if ((discard ?? false) && mounted) {
      widget.onClose();
    }
  }

  Future<void> _addPhotos() async {
    final source = await choosePhotoSource(
      context,
      supportsCamera: _bloc.supportsCamera,
    );
    if (source != null && mounted) {
      _bloc.add(MemoryComposerEvent.photosRequested(source));
    }
  }

  Future<void> _editDescription(PhotoDraft photo) async {
    final description = await showPhotoDescriptionSheet(
      context,
      initial: photo.description,
      maxLength: MemoryRules.maxPhotoDescriptionLength,
    );
    if (description != null && mounted) {
      _bloc.add(
        MemoryComposerEvent.photoDescriptionChanged(
          localId: photo.localId,
          description: description,
        ),
      );
    }
  }

  Future<void> _pickVisitDate(DateTime? current) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? today,
      firstDate: DateTime(MemoryRules.earliestVisitYear),
      lastDate: today,
      helpText: context.l10n.memoryVisitHeading,
    );
    if (picked != null && mounted) {
      _bloc.add(MemoryComposerEvent.visitDateChanged(picked));
    }
  }

  void _announce(String message, {bool assertive = false}) => unawaited(
    context.read<A11yAnnouncer>().announce(message, assertive: assertive),
  );

  void _showSnack(String message, {SnackBarAction? action}) =>
      AppSnackBar.show(context, message: message, action: action);

  void _onPhotoNotice(BuildContext context, MemoryComposerState state) {
    final notice = state.photoNotice;
    if (notice == null) {
      return;
    }
    final l10n = context.l10n;
    final denied = notice.isPermissionDenied;
    final message = photoNoticeMessage(
      l10n,
      notice,
      maxPhotos: MemoryRules.maxPhotos,
    );
    _showSnack(
      message,
      action: denied && _bloc.canOpenAppSettings
          ? SnackBarAction(
              label: l10n.locationOpenSettings,
              onPressed: () => unawaited(_bloc.openAppSettings()),
            )
          : null,
    );
    _announce(message, assertive: denied);
  }

  void _onSubmitAttempt(BuildContext context, MemoryComposerState state) {
    final l10n = context.l10n;
    final issue = state.issue;
    if (state.isSubmitting || issue == null) {
      return;
    }
    _announce(l10n.memoryFixErrors, assertive: true);
    if (issue == MemoryDraftIssue.textEmpty ||
        issue == MemoryDraftIssue.textTooLong) {
      _textFocus.requestFocus();
    }
  }

  void _onSubmitFailure(BuildContext context, MemoryComposerState state) {
    final failure = state.submitFailure;
    if (failure != null) {
      _announce(failure.toUserMessage(context.l10n), assertive: true);
    }
  }

  /// YZ moderasyonu kararı paylaşım yanıtında gelir (ADR 58): yayında,
  /// incelemede veya yayınlanmadı. Son ikisinde "Anılarım" eylemi sunulur.
  void _onSubmitted(BuildContext context, MemoryComposerState state) {
    final l10n = context.l10n;
    final status = state.created?.status ?? MemoryModerationStatus.approved;
    final message = switch (status) {
      MemoryModerationStatus.approved => l10n.memoryShared,
      MemoryModerationStatus.pending => l10n.memorySharedPending,
      MemoryModerationStatus.rejected => l10n.memorySharedRejected,
    };
    final openMine = widget.onOpenMyMemories;
    _showSnack(
      message,
      action: status == MemoryModerationStatus.approved || openMine == null
          ? null
          : SnackBarAction(
              label: l10n.memoryOpenMyMemories,
              onPressed: openMine,
            ),
    );
    _announce(message, assertive: status == MemoryModerationStatus.rejected);
    widget.onSubmitted();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MultiBlocListener(
      listeners: [
        BlocListener<MemoryComposerBloc, MemoryComposerState>(
          listenWhen: (previous, current) =>
              current.photoNoticeCount != previous.photoNoticeCount,
          listener: _onPhotoNotice,
        ),
        BlocListener<MemoryComposerBloc, MemoryComposerState>(
          listenWhen: (previous, current) =>
              current.submitAttempts != previous.submitAttempts,
          listener: _onSubmitAttempt,
        ),
        BlocListener<MemoryComposerBloc, MemoryComposerState>(
          listenWhen: (previous, current) =>
              current.submitFailure != null &&
              previous.status == MemoryComposerStatus.submitting &&
              current.status == MemoryComposerStatus.editing,
          listener: _onSubmitFailure,
        ),
        BlocListener<MemoryComposerBloc, MemoryComposerState>(
          listenWhen: (previous, current) =>
              previous.status != MemoryComposerStatus.submitted &&
              current.status == MemoryComposerStatus.submitted,
          listener: _onSubmitted,
        ),
      ],
      child: BlocBuilder<MemoryComposerBloc, MemoryComposerState>(
        builder: (context, state) {
          final editable =
              state.status == MemoryComposerStatus.editing ||
              state.status == MemoryComposerStatus.submitting;
          return PopScope(
            canPop: !state.isDirty && !state.isSubmitting,
            onPopInvokedWithResult: (didPop, _) {
              if (!didPop) {
                unawaited(_confirmClose());
              }
            },
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  key: const Key('memory_composer_close'),
                  tooltip: l10n.memoryComposerClose,
                  icon: const Icon(Icons.close),
                  onPressed: state.isSubmitting
                      ? null
                      : () => unawaited(_confirmClose()),
                ),
                title: Text(l10n.memoryShare),
              ),
              bottomNavigationBar: editable
                  ? _SubmitBar(
                      state: state,
                      onSubmit: () =>
                          _bloc.add(const MemoryComposerEvent.submitted()),
                    )
                  : null,
              body: switch (state.status) {
                MemoryComposerStatus.loadingMonument => LoadingStatusView(
                  key: const Key('memory_composer_loading'),
                  label: l10n.commonLoading,
                ),
                MemoryComposerStatus.monumentFailure => _MonumentFailure(
                  failure: state.monumentFailure,
                  onRetry: () => _bloc.add(
                    MemoryComposerEvent.started(
                      monumentId: widget.monumentId,
                      languageCode: _languageCode ?? 'tr',
                    ),
                  ),
                  onClose: widget.onClose,
                ),
                _ => _ComposerForm(
                  state: state,
                  authorName: widget.authorName,
                  textController: _text,
                  textFocus: _textFocus,
                  onAddPhotos: () => unawaited(_addPhotos()),
                  onRemovePhoto: (photo) => _bloc.add(
                    MemoryComposerEvent.photoRemoved(photo.localId),
                  ),
                  onEditDescription: (photo) =>
                      unawaited(_editDescription(photo)),
                  onPickVisitDate: () =>
                      unawaited(_pickVisitDate(state.visitedOn)),
                  onClearVisitDate: () => _bloc.add(
                    const MemoryComposerEvent.visitDateChanged(null),
                  ),
                ),
              },
            ),
          );
        },
      ),
    );
  }
}

class _ComposerForm extends StatelessWidget {
  const _ComposerForm({
    required this.state,
    required this.authorName,
    required this.textController,
    required this.textFocus,
    required this.onAddPhotos,
    required this.onRemovePhoto,
    required this.onEditDescription,
    required this.onPickVisitDate,
    required this.onClearVisitDate,
  });

  final MemoryComposerState state;
  final String authorName;
  final TextEditingController textController;
  final FocusNode textFocus;
  final VoidCallback onAddPhotos;
  final ValueChanged<PhotoDraft> onRemovePhoto;
  final ValueChanged<PhotoDraft> onEditDescription;
  final VoidCallback onPickVisitDate;
  final VoidCallback onClearVisitDate;

  String? _textError(AppLocalizations l10n) {
    if (!state.showValidation) {
      return null;
    }
    return switch (state.issue) {
      MemoryDraftIssue.textEmpty => l10n.memoryTextEmptyError,
      MemoryDraftIssue.textTooLong => l10n.memoryTextTooLongError(
        MemoryRules.maxTextLength,
      ),
      _ => null,
    };
  }

  String? _photoError(AppLocalizations l10n) {
    if (!state.showValidation) {
      return null;
    }
    return switch (state.issue) {
      MemoryDraftIssue.descriptionTooLong => l10n.photoDescriptionTooLong(
        MemoryRules.maxPhotoDescriptionLength,
      ),
      MemoryDraftIssue.tooManyPhotos || MemoryDraftIssue.photoTooLarge =>
        l10n.photoLimitReached(MemoryRules.maxPhotos),
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final enabled = !state.isSubmitting;
    final submitFailure = state.submitFailure;
    final photoError = _photoError(l10n);
    return SafeArea(
      bottom: false,
      // Kısa form dikeyde ortalanmaz, üstten başlar.
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
          child: SingleChildScrollView(
            key: const Key('memory_composer_form'),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.xl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _MonumentContext(
                  name: state.monumentName ?? '',
                  place: state.monumentPlace,
                ),
                const SizedBox(height: AppSpacing.lg),
                TextField(
                  key: const Key('memory_composer_text'),
                  controller: textController,
                  focusNode: textFocus,
                  enabled: enabled,
                  minLines: 5,
                  maxLines: 12,
                  maxLength: MemoryRules.maxTextLength,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: l10n.memoryTextLabel,
                    hintText: l10n.memoryTextHint,
                    hintMaxLines: 2,
                    alignLabelWithHint: true,
                    errorText: _textError(l10n),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _FieldHeading(
                  title: l10n.photosHeading,
                  hint: l10n.photosHint(MemoryRules.maxPhotos),
                  trailing: Semantics(
                    label: l10n.photosCountSemantics(
                      state.photos.length,
                      MemoryRules.maxPhotos,
                    ),
                    excludeSemantics: true,
                    child: AppText(
                      '${state.photos.length}/${MemoryRules.maxPhotos}',
                      role: AppTextRole.labelLarge,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                PhotoDraftStrip(
                  keyPrefix: 'memory_composer',
                  maxDescriptionLength: MemoryRules.maxPhotoDescriptionLength,
                  photos: state.photos,
                  processing: state.processingPhotos,
                  canAdd: state.remainingPhotos > 0,
                  enabled: enabled,
                  onAdd: onAddPhotos,
                  onRemove: onRemovePhoto,
                  onEditDescription: onEditDescription,
                ),
                if (photoError != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  InlineMessage(
                    message: photoError,
                    type: InlineMessageType.error,
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                _FieldHeading(
                  title: l10n.memoryVisitHeading,
                  hint: l10n.memoryVisitOptional,
                ),
                const SizedBox(height: AppSpacing.xs),
                _VisitDateField(
                  visitedOn: state.visitedOn,
                  enabled: enabled,
                  onPick: onPickVisitDate,
                  onClear: onClearVisitDate,
                ),
                const SizedBox(height: AppSpacing.lg),
                InlineMessage(
                  message: l10n.memoryPublicNotice(
                    MemoryRules.publicDisplayName(authorName),
                  ),
                ),
                if (submitFailure != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  InlineMessage(
                    key: const Key('memory_composer_submit_error'),
                    message: submitFailure.toUserMessage(l10n),
                    type: InlineMessageType.error,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MonumentContext extends StatelessWidget {
  const _MonumentContext({required this.name, required this.place});

  final String name;
  final String? place;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final subtitle = place;
    return MergeSemantics(
      child: Row(
        children: [
          Container(
            width: AppSizes.minTouchTarget,
            height: AppSizes.minTouchTarget,
            decoration: BoxDecoration(
              color: colors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: AppIcon.decorative(
              Icons.account_balance_outlined,
              color: colors.accentText,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  name,
                  key: const Key('memory_composer_monument_name'),
                  role: AppTextRole.titleMedium,
                ),
                if (subtitle != null)
                  AppText(
                    subtitle,
                    role: AppTextRole.bodySmall,
                    color: colors.onSurfaceVariant,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldHeading extends StatelessWidget {
  const _FieldHeading({required this.title, required this.hint, this.trailing});

  final String title;
  final String hint;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final extra = trailing;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: MergeSemantics(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(title, role: AppTextRole.titleMedium, isHeading: true),
                AppText(
                  hint,
                  role: AppTextRole.bodySmall,
                  color: context.colors.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
        ?extra,
      ],
    );
  }
}

class _VisitDateField extends StatelessWidget {
  const _VisitDateField({
    required this.visitedOn,
    required this.enabled,
    required this.onPick,
    required this.onClear,
  });

  final DateTime? visitedOn;
  final bool enabled;
  final VoidCallback onPick;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final date = visitedOn;
    if (date == null) {
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: AppButton.secondary(
          key: const Key('memory_composer_visit_date'),
          label: l10n.memoryVisitPick,
          icon: Icons.event_outlined,
          onPressed: enabled ? onPick : null,
        ),
      );
    }
    final formatted = MemoryDates.day(l10n, date);
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.xs,
      children: [
        AppButton.secondary(
          key: const Key('memory_composer_visit_date'),
          label: formatted,
          semanticsLabel: l10n.memoryVisitChange(formatted),
          icon: Icons.event_outlined,
          onPressed: enabled ? onPick : null,
        ),
        IconButton(
          key: const Key('memory_composer_visit_clear'),
          tooltip: l10n.memoryVisitClear,
          icon: const Icon(Icons.close),
          onPressed: enabled ? onClear : null,
        ),
      ],
    );
  }
}

/// Sabit alt eylem: yükleme ilerlemesi + "Paylaş".
class _SubmitBar extends StatelessWidget {
  const _SubmitBar({required this.state, required this.onSubmit});

  final MemoryComposerState state;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final progress = state.uploadProgress;
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
                  if (progress != null) ...[
                    AppText(
                      l10n.photosUploading((progress * 100).round()),
                      role: AppTextRole.bodySmall,
                      color: colors.onSurfaceVariant,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    LinearProgressIndicator(
                      key: const Key('memory_composer_progress'),
                      value: progress,
                      semanticsLabel: l10n.photosUploadingSemantics,
                      semanticsValue: '%${(progress * 100).round()}',
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                  AppButton.primary(
                    key: const Key('memory_composer_submit'),
                    label: l10n.memorySubmit,
                    icon: Icons.send_outlined,
                    expand: true,
                    isLoading: state.isSubmitting,
                    onPressed: state.processingPhotos > 0 ? null : onSubmit,
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

class _MonumentFailure extends StatelessWidget {
  const _MonumentFailure({
    required this.failure,
    required this.onRetry,
    required this.onClose,
  });

  final Failure? failure;
  final VoidCallback onRetry;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final notFound = switch (failure) {
      ServerFailure(kind: ServerFailureKind.notFound) => true,
      _ => false,
    };
    return notFound
        ? StatusMessageView(
            key: const Key('memory_composer_not_found'),
            icon: Icons.search_off_outlined,
            title: l10n.monumentNotFoundTitle,
            message: l10n.monumentNotFoundBody,
            actionLabel: l10n.commonClose,
            onAction: onClose,
          )
        : StatusMessageView(
            key: const Key('memory_composer_error'),
            tone: StatusMessageTone.error,
            icon: Icons.cloud_off_outlined,
            title: l10n.monumentDetailErrorTitle,
            message: failure?.toUserMessage(l10n) ?? '',
            actionLabel: l10n.commonRetry,
            onAction: onRetry,
          );
  }
}
