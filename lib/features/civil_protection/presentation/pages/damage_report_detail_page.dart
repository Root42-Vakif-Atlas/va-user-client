import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/l10n/failure_messages.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/civil_protection/domain/entities/damage_report.dart';
import 'package:vakif_atlas/features/civil_protection/presentation/civil_protection_presentation.dart';
import 'package:vakif_atlas/features/civil_protection/presentation/cubit/damage_report_detail_cubit.dart';
import 'package:vakif_atlas/features/civil_protection/presentation/widgets/report_badges.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_network_image.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/organisms/gallery_photo.dart';
import 'package:vakif_atlas/shared/widgets/templates/loading_status_view.dart';
import 'package:vakif_atlas/shared/widgets/templates/photo_viewer_page.dart';
import 'package:vakif_atlas/shared/widgets/templates/status_message_view.dart';

/// Bir Sivil Koruma bildiriminin ayrıntısı
/// (`/civil-protection/reports/:reportId`, yalnızca bildiren görür):
/// kayıt numarası, işlem süreci (durum geçmişi) ve bildirim bilgileri.
/// [DamageReportDetailCubit] üst ağaçtan sağlanır.
class DamageReportDetailPage extends StatefulWidget {
  const DamageReportDetailPage({
    required this.reportId,
    required this.onBackToList,
    super.key,
  });

  final String reportId;
  final VoidCallback onBackToList;

  @override
  State<DamageReportDetailPage> createState() => _DamageReportDetailPageState();
}

class _DamageReportDetailPageState extends State<DamageReportDetailPage> {
  String? _languageCode;

  DamageReportDetailCubit get _cubit => context.read<DamageReportDetailCubit>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageCode = Localizations.localeOf(context).languageCode;
    if (languageCode != _languageCode) {
      _languageCode = languageCode;
      unawaited(_cubit.load(id: widget.reportId, languageCode: languageCode));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.cpDetailTitle)),
      body: BlocBuilder<DamageReportDetailCubit, DamageReportDetailState>(
        builder: (context, state) => switch (state) {
          DamageReportDetailLoading() => LoadingStatusView(
            key: const Key('cp_detail_loading'),
            label: l10n.commonLoading,
          ),
          DamageReportDetailFailure() when state.isNotFound =>
            StatusMessageView(
              key: const Key('cp_detail_not_found'),
              icon: Icons.search_off_outlined,
              title: l10n.cpNotFoundTitle,
              message: l10n.cpNotFoundBody,
              actionLabel: l10n.cpBackToList,
              onAction: widget.onBackToList,
            ),
          DamageReportDetailFailure(:final failure) => StatusMessageView(
            key: const Key('cp_detail_error'),
            tone: StatusMessageTone.error,
            icon: Icons.cloud_off_outlined,
            title: l10n.cpDetailLoadFailed,
            message: failure.toUserMessage(l10n),
            actionLabel: l10n.commonRetry,
            onAction: () => unawaited(_cubit.retry()),
          ),
          DamageReportDetailLoaded(:final report) => _ReportView(
            report: report,
          ),
        },
      ),
    );
  }
}

class _ReportView extends StatelessWidget {
  const _ReportView({required this.report});

  final DamageReport report;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
        child: ListView(
          key: const Key('cp_detail_view'),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.xl,
          ),
          children: [
            _Summary(report: report),
            const SizedBox(height: AppSpacing.xl),
            AppText(
              l10n.cpStatusHeading,
              role: AppTextRole.headlineMedium,
              isHeading: true,
            ),
            const SizedBox(height: AppSpacing.sm),
            _StatusTimeline(report: report),
            const SizedBox(height: AppSpacing.xl),
            AppText(
              l10n.cpDetailsHeading,
              role: AppTextRole.headlineMedium,
              isHeading: true,
            ),
            const SizedBox(height: AppSpacing.sm),
            _Details(report: report),
          ],
        ),
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.report});

  final DamageReport report;

  Future<void> _copy(BuildContext context) async {
    final message = context.l10n.cpReferenceCopied;
    final announcer = context.read<A11yAnnouncer>();
    final messenger = ScaffoldMessenger.of(context);
    await Clipboard.setData(ClipboardData(text: report.referenceCode));
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
    unawaited(announcer.announce(message));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        border: Border.all(color: colors.outlineVariant),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.xs,
          AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: MergeSemantics(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          l10n.cpReferenceLabel,
                          role: AppTextRole.labelLarge,
                          color: colors.onSurfaceVariant,
                        ),
                        SelectableText(
                          report.referenceCode,
                          key: const Key('cp_reference_code'),
                          style: context.textStyles.titleLarge,
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  key: const Key('cp_copy_reference'),
                  tooltip: l10n.cpCopyReference,
                  icon: const Icon(Icons.copy_outlined),
                  onPressed: () => unawaited(_copy(context)),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ReportStatusBadge(status: report.status),
            const SizedBox(height: AppSpacing.md),
            AppText(report.monument.name, role: AppTextRole.titleMedium),
            AppText(
              l10n.monumentLocation(
                report.monument.district,
                report.monument.city,
              ),
              role: AppTextRole.bodyMedium,
              color: colors.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.xxs),
            AppText(
              l10n.cpSubmittedOn(ReportDates.dateTime(l10n, report.createdAt)),
              role: AppTextRole.bodySmall,
              color: colors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

/// İşlem süreci: tamamlanan adımlar tarihli ve işaretli, şu anki adım
/// vurgulu, sonraki adımlar "bekleniyor". Durum metinle de söylenir.
class _StatusTimeline extends StatelessWidget {
  const _StatusTimeline({required this.report});

  final DamageReport report;

  static const double _dot = 24;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final steps = statusSteps(report);
    final reached = {
      for (final change in report.history) change.status: change,
    };
    return Column(
      key: const Key('cp_status_timeline'),
      children: [
        for (var i = 0; i < steps.length; i++)
          () {
            final status = steps[i];
            final change = reached[status];
            final done = change != null;
            final current = status == report.status;
            final last = i == steps.length - 1;
            final note = change?.note;
            final stateLabel = current
                ? l10n.cpStatusCurrent
                : done
                ? l10n.cpStatusDone
                : l10n.cpStatusPending;
            return Semantics(
              key: Key('cp_status_${status.name}'),
              container: true,
              label: [
                l10n.cpStatusStepSemantics(status.label(l10n), stateLabel),
                if (change != null) ReportDates.dateTime(l10n, change.at),
                if (done) status.description(l10n),
                if (note != null) '${l10n.cpNoteFromVgm}: $note',
              ].join('. '),
              excludeSemantics: true,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: _dot,
                      child: Column(
                        children: [
                          Container(
                            width: _dot,
                            height: _dot,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: done
                                  ? status.color(colors)
                                  : colors.surface,
                              border: Border.all(
                                color: done
                                    ? status.color(colors)
                                    : colors.outline,
                                width: AppSizes.borderThick,
                              ),
                            ),
                            child: done
                                ? Icon(
                                    current ? status.icon : Icons.check,
                                    size: AppSizes.iconSm,
                                    color: colors.surface,
                                  )
                                : null,
                          ),
                          if (!last)
                            Expanded(
                              child: Container(
                                width: AppSizes.borderThick,
                                color: reached.containsKey(steps[i + 1])
                                    ? status.color(colors)
                                    : colors.outlineVariant,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: last ? 0 : AppSpacing.md,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              status.label(l10n),
                              role: AppTextRole.titleMedium,
                              color: done
                                  ? colors.onSurface
                                  : colors.onSurfaceVariant,
                            ),
                            AppText(
                              change == null
                                  ? l10n.cpStatusPending
                                  : ReportDates.dateTime(l10n, change.at),
                              role: AppTextRole.bodySmall,
                              color: colors.onSurfaceVariant,
                            ),
                            if (done) ...[
                              const SizedBox(height: AppSpacing.xxs),
                              AppText(
                                status.description(l10n),
                                role: AppTextRole.bodyMedium,
                              ),
                            ],
                            if (note != null) ...[
                              const SizedBox(height: AppSpacing.xs),
                              _VgmNote(note: note),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }(),
      ],
    );
  }
}

class _VgmNote extends StatelessWidget {
  const _VgmNote({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              context.l10n.cpNoteFromVgm,
              role: AppTextRole.labelLarge,
              color: colors.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.xxs),
            AppText(note, role: AppTextRole.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.report});

  final DamageReport report;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final rows = <(String, Widget)>[
      (l10n.cpCategoryField, AppText(report.category.label(l10n))),
      (l10n.cpUrgencyField, ReportUrgencyLabel(urgency: report.urgency)),
      (l10n.cpDescriptionField, AppText(report.description)),
      (
        l10n.cpLocationField,
        Row(
          children: [
            AppIcon.decorative(
              report.locationCheck.icon,
              size: AppSizes.iconSm,
              color: colors.accentText,
            ),
            const SizedBox(width: AppSpacing.xxs),
            Expanded(child: AppText(report.locationCheck.label(l10n))),
          ],
        ),
      ),
      if (report.photos.isNotEmpty)
        (l10n.cpPhotosField, _ReportPhotos(photos: report.photos)),
    ];
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        border: Border.all(color: colors.outlineVariant),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) const Divider(height: AppSizes.borderThin),
            MergeSemantics(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppText(
                      rows[i].$1,
                      role: AppTextRole.labelLarge,
                      color: colors.onSurfaceVariant,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    rows[i].$2,
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ReportPhotos extends StatelessWidget {
  const _ReportPhotos({required this.photos});

  final List<ReportPhoto> photos;

  static const double _size = 88;

  Future<void> _open(BuildContext context, int index) async {
    final l10n = context.l10n;
    await Navigator.of(context).push(
      PhotoViewerPage.route(
        context,
        initialIndex: index,
        photos: [
          for (final photo in photos)
            GalleryPhoto(
              url: photo.url,
              thumbnailUrl: photo.thumbnailUrl,
              description: photo.description ?? l10n.cpPhotoNoDescription,
              credit: l10n.cpPhotoCredit,
              creditSemanticsLabel: l10n.cpPhotoCredit,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        for (var i = 0; i < photos.length; i++)
          Semantics(
            button: true,
            image: true,
            label: photos[i].description == null
                ? l10n.photoTileNoDescription(i + 1, photos.length)
                : l10n.photoTileSemantics(
                    i + 1,
                    photos.length,
                    photos[i].description!,
                  ),
            onTap: () => unawaited(_open(context, i)),
            excludeSemantics: true,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: SizedBox.square(
                dimension: _size,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AppNetworkImage(url: photos[i].thumbnailUrl),
                    Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        key: Key('cp_photo_${photos[i].id}'),
                        onTap: () => unawaited(_open(context, i)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
