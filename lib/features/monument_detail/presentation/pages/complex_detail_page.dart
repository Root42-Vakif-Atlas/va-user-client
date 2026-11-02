import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/l10n/failure_messages.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/complex.dart';
import 'package:vakif_atlas/features/catalog/presentation/catalog_presentation.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/cubit/complex_detail_cubit.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/pages/monument_detail_page.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/widgets/complex_widgets.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/widgets/monument_header.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/widgets/monument_listen_button.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/widgets/monument_report_damage_section.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/widgets/monument_route_button.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/widgets/monument_sections.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/organisms/photo_gallery.dart';
import 'package:vakif_atlas/shared/widgets/templates/loading_status_view.dart';
import 'package:vakif_atlas/shared/widgets/templates/status_message_view.dart';

/// Külliye detay sayfası (`/complex/:id`): eser detayından ayrı görünüm.
///
/// Külliyenin künyesi ve anlatımının yanında içindeki yapıları (numaralı
/// liste + aynı numaralı yerleşim planı) gösterir; yapıya dokunmak o yapının
/// eser detayını açar. Kaydetme, rota, anı ve hasar bildirimi külliyenin
/// katalog kaydıyla, eser detayındaki yuvalarla bağlanır.
class ComplexDetailPage extends StatefulWidget {
  const ComplexDetailPage({
    required this.complexId,
    required this.onOpenMonument,
    required this.onSeeAllMembers,
    required this.onShowOnMap,
    required this.onBackToMap,
    this.routeMembership,
    this.memoriesBuilder,
    this.onReportDamage,
    this.saveButtonBuilder,
    super.key,
  });

  final String complexId;

  /// Üye yapının eser detayı.
  final ValueChanged<String> onOpenMonument;

  /// Tüm yapılar listesi (külliye adıyla).
  final ValueChanged<String> onSeeAllMembers;

  /// Ana harita, külliye açılmış (yakın zum) olarak.
  final VoidCallback onShowOnMap;
  final VoidCallback onBackToMap;
  final MonumentRouteMembership? routeMembership;
  final MonumentSectionBuilder? memoriesBuilder;
  final VoidCallback? onReportDamage;
  final MonumentSectionBuilder? saveButtonBuilder;

  @override
  State<ComplexDetailPage> createState() => _ComplexDetailPageState();
}

class _ComplexDetailPageState extends State<ComplexDetailPage> {
  String? _languageCode;

  ComplexDetailCubit get _cubit => context.read<ComplexDetailCubit>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageCode = Localizations.localeOf(context).languageCode;
    if (languageCode != _languageCode) {
      _languageCode = languageCode;
      _load();
    }
  }

  @override
  void didUpdateWidget(ComplexDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.complexId != widget.complexId) {
      _load();
    }
  }

  void _load() {
    final languageCode = _languageCode;
    if (languageCode != null) {
      unawaited(_cubit.load(id: widget.complexId, languageCode: languageCode));
    }
  }

  void _onFailure(BuildContext context, ComplexDetailState state) {
    final l10n = context.l10n;
    final message = switch (state) {
      ComplexDetailFailure() when state.isNotFound =>
        l10n.monumentNotFoundTitle,
      ComplexDetailFailure(:final failure) => failure.toUserMessage(l10n),
      _ => null,
    };
    if (message != null) {
      unawaited(
        context.read<A11yAnnouncer>().announce(message, assertive: true),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<ComplexDetailCubit, ComplexDetailState>(
      listenWhen: (previous, current) => current is ComplexDetailFailure,
      listener: _onFailure,
      builder: (context, state) => switch (state) {
        ComplexDetailLoaded(:final complex) => _ComplexDetailView(
          complex: complex,
          page: widget,
        ),
        ComplexDetailFailure() when state.isNotFound => _StatusScaffold(
          child: StatusMessageView(
            key: const Key('complex_detail_not_found'),
            icon: Icons.search_off_outlined,
            title: l10n.monumentNotFoundTitle,
            message: l10n.monumentNotFoundBody,
            actionLabel: l10n.monumentBackToMap,
            onAction: widget.onBackToMap,
          ),
        ),
        ComplexDetailFailure(:final failure) => _StatusScaffold(
          child: StatusMessageView(
            key: const Key('complex_detail_error'),
            tone: StatusMessageTone.error,
            icon: Icons.cloud_off_outlined,
            title: l10n.monumentDetailErrorTitle,
            message: failure.toUserMessage(l10n),
            actionLabel: l10n.commonRetry,
            onAction: () => unawaited(_cubit.retry()),
          ),
        ),
        _ => _StatusScaffold(
          child: LoadingStatusView(
            key: const Key('complex_detail_loading'),
            label: l10n.monumentDetailLoading,
          ),
        ),
      },
    );
  }
}

class _StatusScaffold extends StatelessWidget {
  const _StatusScaffold({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.monumentDetailTitle)),
      body: child,
    );
  }
}

class _ComplexDetailView extends StatelessWidget {
  const _ComplexDetailView({required this.complex, required this.page});

  final ComplexDetail complex;
  final ComplexDetailPage page;

  String _speechText(AppLocalizations l10n) {
    final monument = complex.monument;
    return [
      l10n.monumentSpeechIntro(
        monument.name,
        monument.category.label(l10n),
        l10n.monumentLocation(monument.district, monument.city),
      ),
      monument.description,
      if (complex.members.items.isNotEmpty)
        '${l10n.complexMembersTitle}: '
            '${complex.members.items.map((m) => m.name).join(', ')}.',
      monument.history,
    ].join('\n\n');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final monument = complex.monument;
    final images = monument.images;
    final membership = page.routeMembership;
    final memories = page.memoriesBuilder;
    final reportDamage = page.onReportDamage;
    final hasLayout = complex.members.items.any(
      (m) => m.location?.isValid ?? false,
    );
    return Scaffold(
      body: CustomScrollView(
        key: const Key('complex_detail_scroll'),
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text(
              monument.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            actions: [?page.saveButtonBuilder?.call(context, monument)],
          ),
          if (images.isNotEmpty)
            SliverToBoxAdapter(
              child: PhotoGallery(
                photos: [
                  for (var index = 0; index < images.length; index++)
                    images[index].toGalleryPhoto(l10n, index: index + 1),
                ],
              ),
            ),
          SliverSafeArea(
            top: false,
            sliver: SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppSizes.maxContentWidth,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.lg,
                      AppSpacing.md,
                      AppSpacing.xl,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        MonumentHeader(monument: monument),
                        const SizedBox(height: AppSpacing.md),
                        MonumentFactsCard(
                          monument: monument,
                          memberCount: complex.memberCount,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppText(
                          monument.shortDescription,
                          color: context.colors.onSurfaceVariant,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Wrap(
                          spacing: AppSpacing.xs,
                          runSpacing: AppSpacing.xs,
                          children: [
                            MonumentListenButton(
                              text: _speechText(l10n),
                              languageCode: Localizations.localeOf(context)
                                  .languageCode,
                            ),
                            if (membership != null)
                              MonumentRouteButton(membership: membership),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        const Divider(),
                        const SizedBox(height: AppSpacing.lg),
                        ComplexMembersSection(
                          complex: complex,
                          onOpenMonument: page.onOpenMonument,
                          onSeeAll: () => page.onSeeAllMembers(monument.name),
                        ),
                        if (hasLayout) ...[
                          const SizedBox(height: AppSpacing.xl),
                          ComplexLayoutMap(
                            complex: complex,
                            onOpenMonument: page.onOpenMonument,
                            onShowOnMap: page.onShowOnMap,
                          ),
                        ],
                        const SizedBox(height: AppSpacing.xl),
                        MonumentSection(
                          title: l10n.monumentAboutHeading,
                          child: MonumentParagraphs(text: monument.description),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        MonumentSection(
                          title: l10n.monumentHistoryHeading,
                          child: MonumentParagraphs(text: monument.history),
                        ),
                        if (memories != null) ...[
                          const SizedBox(height: AppSpacing.xl),
                          memories(context, monument),
                        ],
                        if (reportDamage != null) ...[
                          const SizedBox(height: AppSpacing.xl),
                          MonumentReportDamageSection(onReport: reportDamage),
                        ],
                        if (images.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.xl),
                          PhotoCreditsSection(images: images),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
