import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/a11y/reduce_motion.dart';
import 'package:vakif_atlas/core/l10n/failure_messages.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/l10n/measure_format.dart';
import 'package:vakif_atlas/core/location/location_service.dart';
import 'package:vakif_atlas/core/media/photo_draft.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/catalog/presentation/bloc/monument_search_bloc.dart';
import 'package:vakif_atlas/features/catalog/presentation/catalog_presentation.dart';
import 'package:vakif_atlas/features/catalog/presentation/widgets/monument_search_view.dart';
import 'package:vakif_atlas/features/civil_protection/domain/entities/damage_report.dart';
import 'package:vakif_atlas/features/civil_protection/domain/entities/damage_report_draft.dart';
import 'package:vakif_atlas/features/civil_protection/presentation/bloc/damage_report_wizard_bloc.dart';
import 'package:vakif_atlas/features/civil_protection/presentation/civil_protection_presentation.dart';
import 'package:vakif_atlas/features/civil_protection/presentation/pages/report_monument_picker_page.dart';
import 'package:vakif_atlas/features/civil_protection/presentation/widgets/report_badges.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/molecules/confirm_dialog.dart';
import 'package:vakif_atlas/shared/widgets/templates/bottom_action_bar.dart';
import 'package:vakif_atlas/shared/widgets/molecules/app_snack_bar.dart';
import 'package:vakif_atlas/shared/widgets/molecules/inline_message.dart';
import 'package:vakif_atlas/shared/widgets/organisms/photo_draft_strip.dart';

/// Adım adım Sivil Koruma bildirimi (`/civil-protection/new`, oturum
/// gerekir).
///
/// - Adımlar butonla değişir (kaydırma hareketi gerekmez — WCAG 2.5.1) ve
///   her geçiş duyurulur; sistem geri tuşu önceki adıma döner.
/// - Eksik adımda alan hatası gösterilir ve duyurulur.
/// - Kaydedilmemiş içerikle çıkarken onay istenir.
///
/// [DamageReportWizardBloc] ve eser seçici için [MonumentSearchBloc] üst
/// ağaçtan sağlanır.
class DamageReportWizardPage extends StatefulWidget {
  const DamageReportWizardPage({
    required this.onClose,
    required this.onSubmitted,
    this.initialMonumentId,
    super.key,
  });

  /// Eser detayından gelindiyse seçili eser.
  final String? initialMonumentId;
  final VoidCallback onClose;
  final ValueChanged<DamageReport> onSubmitted;

  @override
  State<DamageReportWizardPage> createState() => _DamageReportWizardPageState();
}

class _DamageReportWizardPageState extends State<DamageReportWizardPage> {
  final TextEditingController _description = TextEditingController();
  final FocusNode _descriptionFocus = FocusNode();
  String? _languageCode;

  DamageReportWizardBloc get _bloc => context.read<DamageReportWizardBloc>();

  @override
  void initState() {
    super.initState();
    _description.addListener(
      () => _bloc.add(
        DamageReportWizardEvent.descriptionChanged(_description.text),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageCode = Localizations.localeOf(context).languageCode;
    if (languageCode != _languageCode) {
      _languageCode = languageCode;
      _bloc.add(
        DamageReportWizardEvent.started(
          languageCode: languageCode,
          monumentId: widget.initialMonumentId,
        ),
      );
    }
  }

  @override
  void dispose() {
    _description.dispose();
    _descriptionFocus.dispose();
    super.dispose();
  }

  void _announce(String message, {bool assertive = false}) => unawaited(
    context.read<A11yAnnouncer>().announce(message, assertive: assertive),
  );

  void _showSnack(String message, {SnackBarAction? action}) =>
      AppSnackBar.show(context, message: message, action: action);

  /// Sistem geri: önceki adım; ilk adımda (gerekirse onayla) kapatır.
  Future<void> _onBack() async {
    final state = _bloc.state;
    if (state.isSubmitting) {
      return;
    }
    if (state.step != ReportStep.monument) {
      _bloc.add(const DamageReportWizardEvent.backRequested());
      return;
    }
    await _confirmClose();
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
    final discard = await showConfirmDialog(
      context,
      title: l10n.cpDiscardTitle,
      body: l10n.cpDiscardBody,
      confirmLabel: l10n.cpDiscardConfirm,
      cancelLabel: l10n.cpKeepEditing,
      confirmKey: const Key('cp_discard_confirm'),
      cancelKey: const Key('cp_discard_cancel'),
    );
    if (discard && mounted) {
      widget.onClose();
    }
  }

  Future<void> _pickMonument() async {
    final picked = await Navigator.of(context).push(
      ReportMonumentPickerPage.route(
        context,
        search: context.read<MonumentSearchBloc>(),
      ),
    );
    if (picked != null && mounted) {
      _bloc.add(DamageReportWizardEvent.monumentSelected(picked));
    }
  }

  Future<void> _addPhotos() async {
    final source = await choosePhotoSource(
      context,
      supportsCamera: _bloc.supportsCamera,
    );
    if (source != null && mounted) {
      _bloc.add(DamageReportWizardEvent.photosRequested(source));
    }
  }

  Future<void> _editPhotoDescription(PhotoDraft photo) async {
    final description = await showPhotoDescriptionSheet(
      context,
      initial: photo.description,
      maxLength: DamageReportRules.maxPhotoDescriptionLength,
    );
    if (description != null && mounted) {
      _bloc.add(
        DamageReportWizardEvent.photoDescriptionChanged(
          localId: photo.localId,
          description: description,
        ),
      );
    }
  }

  String _stepTitle(AppLocalizations l10n, ReportStep step) => switch (step) {
    ReportStep.monument => l10n.cpStepMonument,
    ReportStep.category => l10n.cpStepCategory,
    ReportStep.urgency => l10n.cpStepUrgency,
    ReportStep.details => l10n.cpStepDetails,
    ReportStep.location => l10n.cpStepLocation,
    ReportStep.review => l10n.cpStepReview,
  };

  String? _issueMessage(AppLocalizations l10n, DamageReportIssue? issue) =>
      switch (issue) {
        null => null,
        DamageReportIssue.monumentMissing => l10n.cpMonumentRequired,
        DamageReportIssue.categoryMissing => l10n.cpCategoryRequired,
        DamageReportIssue.urgencyMissing => l10n.cpUrgencyRequired,
        DamageReportIssue.descriptionTooShort => l10n.cpDescriptionTooShort(
          DamageReportRules.minDescriptionLength,
        ),
        DamageReportIssue.descriptionTooLong => l10n.cpDescriptionTooLong(
          DamageReportRules.maxDescriptionLength,
        ),
        DamageReportIssue.photoDescriptionTooLong =>
          l10n.photoDescriptionTooLong(
            DamageReportRules.maxPhotoDescriptionLength,
          ),
        DamageReportIssue.tooManyPhotos || DamageReportIssue.photoTooLarge =>
          l10n.photoLimitReached(DamageReportRules.maxPhotos),
      };

  void _onStepChanged(BuildContext context, DamageReportWizardState state) {
    final l10n = context.l10n;
    _announce(
      l10n.cpStepProgress(
        state.stepNumber,
        state.stepCount,
        _stepTitle(l10n, state.step),
      ),
    );
  }

  void _onStepError(BuildContext context, DamageReportWizardState state) {
    final l10n = context.l10n;
    _announce(
      _issueMessage(l10n, state.stepIssue) ?? l10n.cpFixStep,
      assertive: true,
    );
    if (state.step == ReportStep.details) {
      _descriptionFocus.requestFocus();
    }
  }

  void _onPhotoNotice(BuildContext context, DamageReportWizardState state) {
    final notice = state.photoNotice;
    if (notice == null) {
      return;
    }
    final l10n = context.l10n;
    final message = photoNoticeMessage(
      l10n,
      notice,
      maxPhotos: DamageReportRules.maxPhotos,
    );
    _showSnack(
      message,
      action: notice.isPermissionDenied && _bloc.canOpenPhotoSettings
          ? SnackBarAction(
              label: l10n.locationOpenSettings,
              onPressed: () => unawaited(_bloc.openPhotoSettings()),
            )
          : null,
    );
    _announce(message, assertive: notice.isPermissionDenied);
  }

  void _onSubmitResult(BuildContext context, DamageReportWizardState state) {
    final l10n = context.l10n;
    final report = state.submitted;
    if (report != null) {
      final message = l10n.cpSubmitted(report.referenceCode);
      _showSnack(message);
      _announce(message);
      widget.onSubmitted(report);
      return;
    }
    final failure = state.submitFailure;
    if (failure != null) {
      _announce(failure.toUserMessage(l10n), assertive: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MultiBlocListener(
      listeners: [
        BlocListener<DamageReportWizardBloc, DamageReportWizardState>(
          listenWhen: (previous, current) => previous.step != current.step,
          listener: _onStepChanged,
        ),
        BlocListener<DamageReportWizardBloc, DamageReportWizardState>(
          listenWhen: (previous, current) =>
              current.stepErrorCount != previous.stepErrorCount,
          listener: _onStepError,
        ),
        BlocListener<DamageReportWizardBloc, DamageReportWizardState>(
          listenWhen: (previous, current) =>
              current.photoNoticeCount != previous.photoNoticeCount,
          listener: _onPhotoNotice,
        ),
        BlocListener<DamageReportWizardBloc, DamageReportWizardState>(
          listenWhen: (previous, current) =>
              previous.submitStatus == ReportSubmitStatus.submitting &&
              current.submitStatus != ReportSubmitStatus.submitting,
          listener: _onSubmitResult,
        ),
      ],
      child: BlocBuilder<DamageReportWizardBloc, DamageReportWizardState>(
        builder: (context, state) => PopScope(
          canPop:
              state.step == ReportStep.monument &&
              !state.isDirty &&
              !state.isSubmitting,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) {
              unawaited(_onBack());
            }
          },
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                key: const Key('cp_wizard_close'),
                tooltip: l10n.cpWizardClose,
                icon: const Icon(Icons.close),
                onPressed: state.isSubmitting
                    ? null
                    : () => unawaited(_confirmClose()),
              ),
              title: Text(l10n.cpWizardTitle),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(AppSizes.stepIndicator),
                child: _StepProgress(state: state),
              ),
            ),
            bottomNavigationBar: _WizardBar(
              state: state,
              onBack: () =>
                  _bloc.add(const DamageReportWizardEvent.backRequested()),
              onNext: () =>
                  _bloc.add(const DamageReportWizardEvent.nextRequested()),
              onSubmit: () =>
                  _bloc.add(const DamageReportWizardEvent.submitted()),
            ),
            body: SafeArea(
              bottom: false,
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppSizes.maxContentWidth,
                  ),
                  child: SingleChildScrollView(
                    key: ValueKey('cp_step_${state.step.name}'),
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.md,
                      AppSpacing.md,
                      AppSpacing.xl,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppText(
                          l10n.cpStepProgress(
                            state.stepNumber,
                            state.stepCount,
                            _stepTitle(l10n, state.step),
                          ),
                          key: const Key('cp_step_label'),
                          role: AppTextRole.labelLarge,
                          color: context.colors.onSurfaceVariant,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        switch (state.step) {
                          ReportStep.monument => _MonumentStep(
                            state: state,
                            error: state.showStepError
                                ? _issueMessage(l10n, state.stepIssue)
                                : null,
                            onPick: () => unawaited(_pickMonument()),
                          ),
                          ReportStep.category => _ChoiceStep<DamageCategory>(
                            title: l10n.cpStepCategoryQuestion,
                            keyPrefix: 'cp_category',
                            values: DamageCategory.values,
                            selected: state.category,
                            label: (value) => value.label(l10n),
                            description: (value) => value.description(l10n),
                            icon: (value) => value.icon,
                            error: state.showStepError
                                ? _issueMessage(l10n, state.stepIssue)
                                : null,
                            onSelected: (value) => _bloc.add(
                              DamageReportWizardEvent.categorySelected(value),
                            ),
                          ),
                          ReportStep.urgency => _ChoiceStep<ReportUrgency>(
                            title: l10n.cpStepUrgencyQuestion,
                            keyPrefix: 'cp_urgency',
                            values: ReportUrgency.values,
                            selected: state.urgency,
                            label: (value) => value.label(l10n),
                            description: (value) => value.description(l10n),
                            icon: (value) => value.icon,
                            iconColor: (value) => value.color(context.colors),
                            notice: InlineMessage(
                              message: l10n.cpEmergencyNotice,
                              type: InlineMessageType.warning,
                            ),
                            error: state.showStepError
                                ? _issueMessage(l10n, state.stepIssue)
                                : null,
                            onSelected: (value) => _bloc.add(
                              DamageReportWizardEvent.urgencySelected(value),
                            ),
                          ),
                          ReportStep.details => _DetailsStep(
                            state: state,
                            controller: _description,
                            focusNode: _descriptionFocus,
                            error: state.showStepError
                                ? _issueMessage(l10n, state.stepIssue)
                                : null,
                            onAddPhotos: () => unawaited(_addPhotos()),
                            onRemovePhoto: (photo) => _bloc.add(
                              DamageReportWizardEvent.photoRemoved(
                                photo.localId,
                              ),
                            ),
                            onEditDescription: (photo) =>
                                unawaited(_editPhotoDescription(photo)),
                          ),
                          ReportStep.location => _LocationStep(
                            state: state,
                            supported: _bloc.supportsLocation,
                            canOpenSettings: _bloc.canOpenLocationSettings,
                            onToggle: (enabled) => _bloc.add(
                              DamageReportWizardEvent.locationSharingChanged(
                                enabled: enabled,
                              ),
                            ),
                            onOpenSettings: (issue) =>
                                unawaited(_bloc.openLocationSettings(issue)),
                          ),
                          ReportStep.review => _ReviewStep(
                            state: state,
                            stepTitle: (step) => _stepTitle(l10n, step),
                            onEdit: (step) => _bloc.add(
                              DamageReportWizardEvent.stepSelected(step),
                            ),
                          ),
                        },
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StepProgress extends StatelessWidget {
  const _StepProgress({required this.state});

  final DamageReportWizardState state;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    // Metin karşılığı içerikteki "Adım n/6" etiketidir; çubuk görseldir.
    return ExcludeSemantics(
      child: Row(
        children: [
          for (var i = 0; i < state.stepCount; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.xxs),
            Expanded(
              child: Container(
                height: AppSizes.stepIndicator,
                color: i < state.stepNumber
                    ? colors.primary
                    : colors.outlineVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StepHeading extends StatelessWidget {
  const _StepHeading(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.md),
    child: AppText(title, role: AppTextRole.headlineMedium, isHeading: true),
  );
}

class _MonumentStep extends StatelessWidget {
  const _MonumentStep({
    required this.state,
    required this.error,
    required this.onPick,
  });

  final DamageReportWizardState state;
  final String? error;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final monument = state.monument;
    final message = error;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StepHeading(l10n.cpStepMonumentQuestion),
        if (state.monumentLoading)
          const _SmallProgress()
        else if (monument != null) ...[
          DecoratedBox(
            key: const Key('cp_selected_monument'),
            decoration: BoxDecoration(
              color: colors.surfaceElevated,
              border: Border.all(color: colors.outlineVariant),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: MergeSemantics(
                child: Row(
                  children: [
                    MonumentSearchLeadingIcon(icon: monument.category.icon),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(monument.name, role: AppTextRole.titleMedium),
                          AppText(
                            l10n.monumentLocation(
                              monument.district,
                              monument.city,
                            ),
                            role: AppTextRole.bodySmall,
                            color: colors.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: AppButton.ghost(
              key: const Key('cp_change_monument'),
              label: l10n.cpChangeMonument,
              icon: Icons.swap_horiz,
              onPressed: onPick,
            ),
          ),
        ] else
          AppButton.secondary(
            key: const Key('cp_choose_monument'),
            label: l10n.cpChooseMonument,
            icon: Icons.search,
            expand: true,
            onPressed: onPick,
          ),
        if (state.monumentFailure != null && monument == null) ...[
          const SizedBox(height: AppSpacing.sm),
          InlineMessage(
            message: l10n.cpMonumentLoadFailed,
            type: InlineMessageType.warning,
          ),
        ],
        if (message != null) ...[
          const SizedBox(height: AppSpacing.sm),
          InlineMessage(
            key: const Key('cp_step_error'),
            message: message,
            type: InlineMessageType.error,
          ),
        ],
      ],
    );
  }
}

/// Tek seçimli liste adımı (hasar türü, aciliyet).
class _ChoiceStep<T> extends StatelessWidget {
  const _ChoiceStep({
    required this.title,
    required this.keyPrefix,
    required this.values,
    required this.selected,
    required this.label,
    required this.description,
    required this.icon,
    required this.error,
    required this.onSelected,
    this.iconColor,
    this.notice,
  });

  final String title;
  final String keyPrefix;
  final List<T> values;
  final T? selected;
  final String Function(T value) label;
  final String Function(T value) description;
  final IconData Function(T value) icon;
  final Color Function(T value)? iconColor;
  final String? error;
  final Widget? notice;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final message = error;
    final extra = notice;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StepHeading(title),
        if (extra != null) ...[extra, const SizedBox(height: AppSpacing.sm)],
        if (message != null) ...[
          InlineMessage(
            key: const Key('cp_step_error'),
            message: message,
            type: InlineMessageType.error,
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        Semantics(
          container: true,
          label: title,
          explicitChildNodes: true,
          child: RadioGroup<T>(
            groupValue: selected,
            onChanged: (value) {
              if (value != null) {
                onSelected(value);
              }
            },
            child: Column(
              children: [
                for (final value in values)
                  RadioListTile<T>(
                    key: Key('${keyPrefix}_$value'),
                    value: value,
                    contentPadding: EdgeInsets.zero,
                    secondary: AppIcon.decorative(
                      icon(value),
                      color: iconColor?.call(value) ?? colors.accentText,
                    ),
                    title: Text(label(value)),
                    subtitle: Text(description(value)),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailsStep extends StatelessWidget {
  const _DetailsStep({
    required this.state,
    required this.controller,
    required this.focusNode,
    required this.error,
    required this.onAddPhotos,
    required this.onRemovePhoto,
    required this.onEditDescription,
  });

  final DamageReportWizardState state;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? error;
  final VoidCallback onAddPhotos;
  final ValueChanged<PhotoDraft> onRemovePhoto;
  final ValueChanged<PhotoDraft> onEditDescription;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final issue = state.showStepError ? state.stepIssue : null;
    final textError =
        issue == DamageReportIssue.descriptionTooShort ||
            issue == DamageReportIssue.descriptionTooLong
        ? error
        : null;
    final photoError = textError == null ? error : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StepHeading(l10n.cpStepDetailsQuestion),
        TextField(
          key: const Key('cp_description'),
          controller: controller,
          focusNode: focusNode,
          enabled: !state.isSubmitting,
          minLines: 5,
          maxLines: 12,
          maxLength: DamageReportRules.maxDescriptionLength,
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: l10n.cpDescriptionLabel,
            hintText: l10n.cpDescriptionHint,
            hintMaxLines: 3,
            alignLabelWithHint: true,
            errorText: textError,
            errorMaxLines: 2,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: MergeSemantics(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      l10n.photosHeading,
                      role: AppTextRole.titleMedium,
                      isHeading: true,
                    ),
                    AppText(
                      l10n.photosHint(DamageReportRules.maxPhotos),
                      role: AppTextRole.bodySmall,
                      color: colors.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
            Semantics(
              label: l10n.photosCountSemantics(
                state.photos.length,
                DamageReportRules.maxPhotos,
              ),
              excludeSemantics: true,
              child: AppText(
                '${state.photos.length}/${DamageReportRules.maxPhotos}',
                role: AppTextRole.labelLarge,
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        PhotoDraftStrip(
          keyPrefix: 'report',
          maxDescriptionLength: DamageReportRules.maxPhotoDescriptionLength,
          photos: state.photos,
          processing: state.processingPhotos,
          canAdd: state.remainingPhotos > 0,
          enabled: !state.isSubmitting,
          onAdd: onAddPhotos,
          onRemove: onRemovePhoto,
          onEditDescription: onEditDescription,
        ),
        if (photoError != null) ...[
          const SizedBox(height: AppSpacing.xs),
          InlineMessage(
            key: const Key('cp_step_error'),
            message: photoError,
            type: InlineMessageType.error,
          ),
        ],
      ],
    );
  }
}

class _LocationStep extends StatelessWidget {
  const _LocationStep({
    required this.state,
    required this.supported,
    required this.canOpenSettings,
    required this.onToggle,
    required this.onOpenSettings,
  });

  final DamageReportWizardState state;
  final bool supported;
  final bool Function(LocationIssue issue) canOpenSettings;
  final ValueChanged<bool> onToggle;
  final ValueChanged<LocationIssue> onOpenSettings;

  String _issueMessage(AppLocalizations l10n, LocationIssue issue) =>
      switch (issue) {
        LocationIssue.serviceDisabled => l10n.cpLocationServiceDisabled,
        LocationIssue.permissionDenied => l10n.cpLocationDenied,
        LocationIssue.permissionDeniedForever => l10n.cpLocationDeniedForever,
        LocationIssue.unavailable => l10n.cpLocationUnavailable,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final location = state.location;
    final distance = state.estimatedDistanceMeters;
    final issue = state.locationIssue;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StepHeading(l10n.cpStepLocationQuestion),
        AppText(l10n.cpLocationExplain),
        const SizedBox(height: AppSpacing.md),
        if (!supported)
          InlineMessage(message: l10n.cpLocationUnsupported)
        else ...[
          SwitchListTile(
            key: const Key('cp_location_toggle'),
            contentPadding: EdgeInsets.zero,
            value: state.shareLocation,
            onChanged: state.isSubmitting ? null : onToggle,
            title: Text(l10n.cpLocationToggle),
            secondary: const Icon(Icons.my_location),
          ),
          const SizedBox(height: AppSpacing.sm),
          switch (state.locationStatus) {
            ReportLocationStatus.off => const SizedBox.shrink(),
            ReportLocationStatus.locating => Row(
              children: [
                const _SmallProgress(),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Semantics(
                    liveRegion: true,
                    child: AppText(l10n.cpLocationLocating),
                  ),
                ),
              ],
            ),
            ReportLocationStatus.found => InlineMessage(
              key: const Key('cp_location_found'),
              type: InlineMessageType.success,
              message: [
                l10n.cpLocationFound(location?.accuracyMeters.round() ?? 0),
                if (distance != null) ...[
                  l10n.cpLocationDistance(l10n.distance(distance)),
                  if (distance <= DamageReportRules.onSiteRadiusMeters)
                    l10n.cpLocationOnSite
                  else
                    l10n.cpLocationFar,
                ],
              ].join(' '),
            ),
            ReportLocationStatus.failed => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InlineMessage(
                  key: const Key('cp_location_failed'),
                  type: InlineMessageType.warning,
                  message: issue == null
                      ? l10n.cpLocationUnavailable
                      : _issueMessage(l10n, issue),
                ),
                if (issue != null && canOpenSettings(issue))
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: AppButton.ghost(
                      label: l10n.locationOpenSettings,
                      icon: Icons.settings_outlined,
                      onPressed: () => onOpenSettings(issue),
                    ),
                  )
                else
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: AppButton.ghost(
                      label: l10n.commonRetry,
                      icon: Icons.refresh,
                      onPressed: () => onToggle(true),
                    ),
                  ),
              ],
            ),
          },
        ],
      ],
    );
  }
}

class _ReviewStep extends StatelessWidget {
  const _ReviewStep({
    required this.state,
    required this.stepTitle,
    required this.onEdit,
  });

  final DamageReportWizardState state;
  final String Function(ReportStep step) stepTitle;
  final ValueChanged<ReportStep> onEdit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final monument = state.monument;
    final category = state.category;
    final urgency = state.urgency;
    final failure = state.submitFailure;
    final locationShared = state.draft.location != null;
    final rows = <(ReportStep, Widget)>[
      (
        ReportStep.monument,
        AppText(
          monument == null
              ? '—'
              : '${monument.name} · '
                    '${l10n.monumentLocation(monument.district, monument.city)}',
        ),
      ),
      (ReportStep.category, AppText(category?.label(l10n) ?? '—')),
      (
        ReportStep.urgency,
        urgency == null
            ? const AppText('—')
            : ReportUrgencyLabel(urgency: urgency),
      ),
      (
        ReportStep.details,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(state.description.trim(), maxLines: 4),
            const SizedBox(height: AppSpacing.xxs),
            AppText(
              l10n.cpReviewPhotos(state.photos.length),
              role: AppTextRole.bodySmall,
              color: context.colors.onSurfaceVariant,
            ),
          ],
        ),
      ),
      (
        ReportStep.location,
        AppText(
          locationShared
              ? l10n.cpReviewLocationShared
              : l10n.cpReviewLocationNotShared,
        ),
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StepHeading(l10n.cpStepReviewQuestion),
        DecoratedBox(
          decoration: BoxDecoration(
            color: context.colors.surfaceElevated,
            border: Border.all(color: context.colors.outlineVariant),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Column(
            children: [
              for (var i = 0; i < rows.length; i++) ...[
                if (i > 0) const Divider(height: AppSizes.borderThin),
                _ReviewRow(
                  title: stepTitle(rows[i].$1),
                  value: rows[i].$2,
                  enabled: !state.isSubmitting,
                  editKey: Key('cp_review_edit_${rows[i].$1.name}'),
                  onEdit: () => onEdit(rows[i].$1),
                ),
              ],
            ],
          ),
        ),
        if (failure != null) ...[
          const SizedBox(height: AppSpacing.sm),
          InlineMessage(
            key: const Key('cp_submit_error'),
            message: failure.toUserMessage(l10n),
            type: InlineMessageType.error,
          ),
        ],
      ],
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({
    required this.title,
    required this.value,
    required this.enabled,
    required this.editKey,
    required this.onEdit,
  });

  final String title;
  final Widget value;
  final bool enabled;
  final Key editKey;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.xs,
        AppSpacing.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: MergeSemantics(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    title,
                    role: AppTextRole.labelLarge,
                    color: context.colors.onSurfaceVariant,
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  value,
                ],
              ),
            ),
          ),
          TextButton(
            key: editKey,
            onPressed: enabled ? onEdit : null,
            child: Text(
              l10n.cpReviewEdit,
              semanticsLabel: l10n.cpReviewEditSemantics(title),
            ),
          ),
        ],
      ),
    );
  }
}

/// Sabit alt eylemler: Geri / İleri, son adımda yükleme ilerlemesi +
/// "Bildirimi gönder".
class _WizardBar extends StatelessWidget {
  const _WizardBar({
    required this.state,
    required this.onBack,
    required this.onNext,
    required this.onSubmit,
  });

  final DamageReportWizardState state;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final progress = state.uploadProgress;
    final isReview = state.step == ReportStep.review;
    final busy = state.isSubmitting || state.processingPhotos > 0;
    return BottomActionBar(
      header: progress == null
          ? null
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppText(
                  l10n.photosUploading((progress * 100).round()),
                  role: AppTextRole.bodySmall,
                  color: colors.onSurfaceVariant,
                ),
                const SizedBox(height: AppSpacing.xxs),
                LinearProgressIndicator(
                  key: const Key('cp_upload_progress'),
                  value: progress,
                  semanticsLabel: l10n.photosUploadingSemantics,
                  semanticsValue: '%${(progress * 100).round()}',
                ),
              ],
            ),
      secondary: state.step == ReportStep.monument
          ? null
          : AppButton.secondary(
              key: const Key('cp_back'),
              label: l10n.cpBack,
              icon: Icons.arrow_back,
              expand: true,
              onPressed: state.isSubmitting ? null : onBack,
            ),
      primary: isReview
          ? AppButton.primary(
              key: const Key('cp_submit'),
              label: l10n.cpSubmit,
              icon: Icons.send_outlined,
              expand: true,
              isLoading: state.isSubmitting,
              onPressed: busy ? null : onSubmit,
            )
          : AppButton.primary(
              key: const Key('cp_next'),
              label: l10n.cpNext,
              icon: Icons.arrow_forward,
              expand: true,
              onPressed: state.processingPhotos > 0 || state.monumentLoading
                  ? null
                  : onNext,
            ),
    );
  }
}

class _SmallProgress extends StatelessWidget {
  const _SmallProgress();

  @override
  Widget build(BuildContext context) {
    if (context.reduceMotion) {
      return AppIcon.decorative(
        Icons.hourglass_top,
        color: context.colors.onSurfaceVariant,
      );
    }
    return const SizedBox.square(
      dimension: AppSizes.spinner,
      child: CircularProgressIndicator(strokeWidth: AppSizes.spinnerStroke),
    );
  }
}
