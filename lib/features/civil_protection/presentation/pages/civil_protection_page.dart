import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/a11y/reduce_motion.dart';
import 'package:vakif_atlas/core/l10n/failure_messages.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/civil_protection/presentation/cubit/damage_report_list_cubit.dart';
import 'package:vakif_atlas/features/civil_protection/presentation/widgets/damage_report_card.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/molecules/inline_message.dart';
import 'package:vakif_atlas/shared/widgets/templates/loading_status_view.dart';
import 'package:vakif_atlas/shared/widgets/templates/status_message_view.dart';

/// Sivil Koruma sekmesi (`/civil-protection`).
///
/// - Misafir: hizmetin tanıtımı, nasıl işlediği ve giriş butonu.
/// - Oturum açık: "Bildirimlerim" (durum ve kayıt numarasıyla) ve
///   "Hasar bildir". [DamageReportListCubit] üst ağaçtan sağlanır.
///
/// Can güvenliği uyarısı (112) her iki durumda da görünür.
class CivilProtectionPage extends StatefulWidget {
  const CivilProtectionPage({
    required this.viewerId,
    required this.onSignIn,
    required this.onCreateReport,
    required this.onOpenReport,
    this.actions = const [],
    super.key,
  });

  /// Oturum açık kullanıcı; misafirde `null`.
  final String? viewerId;
  final VoidCallback onSignIn;
  final VoidCallback onCreateReport;
  final ValueChanged<String> onOpenReport;
  final List<Widget> actions;

  static const double loadMoreExtent = 600;

  @override
  State<CivilProtectionPage> createState() => _CivilProtectionPageState();
}

class _CivilProtectionPageState extends State<CivilProtectionPage> {
  String? _languageCode;

  DamageReportListCubit get _cubit => context.read<DamageReportListCubit>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageCode = Localizations.localeOf(context).languageCode;
    if (languageCode != _languageCode) {
      _languageCode = languageCode;
      _start();
    }
  }

  @override
  void didUpdateWidget(CivilProtectionPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewerId != widget.viewerId) {
      _start();
    }
  }

  void _start() {
    final languageCode = _languageCode;
    if (widget.viewerId != null && languageCode != null) {
      unawaited(_cubit.start(languageCode));
    }
  }

  bool _onScroll(ScrollNotification notification) {
    final metrics = notification.metrics;
    if (metrics.axis == Axis.vertical &&
        metrics.extentAfter < CivilProtectionPage.loadMoreExtent) {
      unawaited(_cubit.loadMore());
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final signedIn = widget.viewerId != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.civilProtectionTitle),
        actions: widget.actions,
      ),
      floatingActionButton: signedIn
          ? FloatingActionButton.extended(
              // Sekmeler aynı kabuk rotasında yaşadığından varsayılan hero
              // etiketi çakışır; FAB'lar arası paylaşılan öğe geçişi yoktur.
              heroTag: null,
              key: const Key('cp_new_report_fab'),
              onPressed: widget.onCreateReport,
              icon: const Icon(Icons.add_alert_outlined),
              label: Text(l10n.cpNewReport),
            )
          : null,
      body: signedIn
          ? NotificationListener<ScrollNotification>(
              onNotification: _onScroll,
              child: BlocBuilder<DamageReportListCubit, DamageReportListState>(
                builder: (context, state) => _ReportsView(
                  state: state,
                  onOpenReport: widget.onOpenReport,
                  onRefresh: _cubit.refresh,
                  onRetry: () => unawaited(_cubit.retry()),
                ),
              ),
            )
          : _GuestIntro(onSignIn: widget.onSignIn),
    );
  }
}

class _ReportsView extends StatelessWidget {
  const _ReportsView({
    required this.state,
    required this.onOpenReport,
    required this.onRefresh,
    required this.onRetry,
  });

  final DamageReportListState state;
  final ValueChanged<String> onOpenReport;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;

  static const double _fabClearance = AppSpacing.x4l + AppSpacing.md;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (state.items.isEmpty &&
        (state.status == DamageReportListStatus.initial ||
            state.status == DamageReportListStatus.loading)) {
      return LoadingStatusView(
        key: const Key('cp_reports_loading'),
        label: l10n.cpReportsLoading,
      );
    }
    if (state.status == DamageReportListStatus.failure) {
      return StatusMessageView(
        key: const Key('cp_reports_error'),
        tone: StatusMessageTone.error,
        icon: Icons.cloud_off_outlined,
        title: l10n.cpReportsLoadFailed,
        message: state.failure?.toUserMessage(l10n) ?? '',
        actionLabel: l10n.commonRetry,
        onAction: onRetry,
      );
    }
    final items = state.items;
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
          child: ListView(
            key: const Key('cp_reports_list'),
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              MediaQuery.paddingOf(context).bottom + _fabClearance,
            ),
            children: [
              AppText(
                l10n.cpMyReports,
                role: AppTextRole.headlineMedium,
                isHeading: true,
              ),
              const SizedBox(height: AppSpacing.sm),
              if (state.isEmpty)
                const _EmptyReports()
              else
                for (final report in items) ...[
                  DamageReportCard(
                    key: ValueKey(report.id),
                    report: report,
                    onTap: () => onOpenReport(report.id),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
              if (state.loadMoreFailure != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InlineMessage(
                      message: l10n.cpLoadMoreFailed,
                      type: InlineMessageType.error,
                    ),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: AppButton.ghost(
                        label: l10n.commonRetry,
                        icon: Icons.refresh,
                        onPressed: onRetry,
                      ),
                    ),
                  ],
                )
              else if (state.isLoadingMore)
                const _InlineProgress(),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyReports extends StatelessWidget {
  const _EmptyReports();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Center(
        child: StatusMessageContent(
          key: const Key('cp_reports_empty'),
          compact: true,
          icon: Icons.assignment_outlined,
          title: l10n.cpReportsEmptyTitle,
          message: l10n.cpReportsEmptyBody,
        ),
      ),
    );
  }
}

class _GuestIntro extends StatelessWidget {
  const _GuestIntro({required this.onSignIn});

  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final steps = [
      (l10n.cpIntroStep1Title, l10n.cpIntroStep1Body),
      (l10n.cpIntroStep2Title, l10n.cpIntroStep2Body),
      (l10n.cpIntroStep3Title, l10n.cpIntroStep3Body),
    ];
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
        child: ListView(
          key: const Key('cp_guest_intro'),
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Container(
                width: AppSizes.onboardingIcon,
                height: AppSizes.onboardingIcon,
                decoration: BoxDecoration(
                  color: colors.secondaryContainer,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: AppIcon.decorative(
                  Icons.shield_outlined,
                  size: AppSizes.iconLg,
                  color: colors.onSecondaryContainer,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppText(
              l10n.cpIntroTitle,
              role: AppTextRole.headlineLarge,
              isHeading: true,
            ),
            const SizedBox(height: AppSpacing.xs),
            AppText(l10n.cpIntroBody, color: colors.onSurfaceVariant),
            const SizedBox(height: AppSpacing.lg),
            for (var index = 0; index < steps.length; index++) ...[
              _IntroStep(
                number: index + 1,
                title: steps[index].$1,
                body: steps[index].$2,
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            const SizedBox(height: AppSpacing.sm),
            AppText(l10n.cpSignInPrompt, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.sm),
            AppButton.primary(
              key: const Key('cp_sign_in_button'),
              label: l10n.routeExportSignIn,
              icon: Icons.login,
              expand: true,
              onPressed: onSignIn,
            ),
          ],
        ),
      ),
    );
  }
}

class _IntroStep extends StatelessWidget {
  const _IntroStep({
    required this.number,
    required this.title,
    required this.body,
  });

  final int number;
  final String title;
  final String body;

  static const double _badge = 32;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return MergeSemantics(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: _badge,
            height: _badge,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.primary,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$number',
              textScaler: TextScaler.noScaling,
              style: context.textStyles.titleMedium.copyWith(
                color: colors.onPrimary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(title, role: AppTextRole.titleMedium),
                AppText(
                  body,
                  role: AppTextRole.bodyMedium,
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

class _InlineProgress extends StatelessWidget {
  const _InlineProgress();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: context.l10n.cpReportsLoading,
      liveRegion: true,
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Center(
          child: context.reduceMotion
              ? const Icon(Icons.hourglass_top)
              : const SizedBox.square(
                  dimension: AppSizes.spinner,
                  child: CircularProgressIndicator(
                    strokeWidth: AppSizes.spinnerStroke,
                  ),
                ),
        ),
      ),
    );
  }
}
