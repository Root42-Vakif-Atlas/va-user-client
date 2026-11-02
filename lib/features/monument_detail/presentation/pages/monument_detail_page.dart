import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/l10n/failure_messages.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_detail.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_summary.dart';
import 'package:vakif_atlas/features/catalog/presentation/catalog_presentation.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/cubit/monument_detail_cubit.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/widgets/complex_widgets.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/widgets/monument_header.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/widgets/monument_listen_button.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/widgets/monument_location_section.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/widgets/monument_report_damage_section.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/widgets/monument_route_button.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/widgets/monument_sections.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/organisms/photo_gallery.dart';
import 'package:vakif_atlas/shared/widgets/templates/loading_status_view.dart';
import 'package:vakif_atlas/shared/widgets/templates/status_message_view.dart';

/// Eser kaydına bağlı, dışarıdan sağlanan sayfa bölümü.
typedef MonumentSectionBuilder = Widget Function(
  BuildContext context,
  MonumentDetail monument,
);

/// Eser detay sayfası (`/monument/:id`).
///
/// Derin bağlantıyla doğrudan açılabilir; içerik arayüz dilinde istenir ve
/// dil değiştiğinde yeniden yüklenir.
///
/// Külliye yapısında bağlı olduğu külliyeye geçiş kartı ve diğer yapılar
/// gösterilir. Açılan kayıt bir külliyeyse (eski bağlantı, rota durağı)
/// [onOpenComplex] ile külliye görünümüne geçilir.
class MonumentDetailPage extends StatefulWidget {
  const MonumentDetailPage({
    required this.monumentId,
    required this.onShowOnMap,
    required this.onBackToMap,
    this.routeMembership,
    this.memoriesBuilder,
    this.onReportDamage,
    this.saveButtonBuilder,
    this.onOpenComplex,
    this.onOpenMonument,
    super.key,
  });

  final String monumentId;

  /// Külliye görünümü (yönlendirici sayfayı değiştirir); `null` ise külliye
  /// kaydı da bu sayfada gösterilir ve geçiş kartı çıkmaz.
  final ValueChanged<String>? onOpenComplex;

  /// Külliyenin diğer yapılarından birinin detayı; `null` ise liste yok.
  final ValueChanged<String>? onOpenMonument;
  final VoidCallback onShowOnMap;

  /// Yeni rota taslağına ekleme; `null` ise buton gösterilmez.
  final MonumentRouteMembership? routeMembership;

  /// Eser bulunamadığında haritaya dönüş.
  final VoidCallback onBackToMap;

  /// Anı Köşesi bölümü. Sayfa Anı Köşesi'ne bağımlı olmasın diye bölüm
  /// yönlendiricide (kompozisyon kökü) kurulur; `null` ise gösterilmez.
  final MonumentSectionBuilder? memoriesBuilder;

  /// Sivil Koruma bildirimi bu eser seçili açılır; `null` ise bölüm yok.
  final VoidCallback? onReportDamage;

  /// Üst çubuktaki kaydet butonu; kaydedilen eserler özelliği kompozisyon
  /// kökünde bağlanır. `null` ise gösterilmez.
  final MonumentSectionBuilder? saveButtonBuilder;

  @override
  State<MonumentDetailPage> createState() => _MonumentDetailPageState();
}

class _MonumentDetailPageState extends State<MonumentDetailPage> {
  String? _languageCode;

  MonumentDetailCubit get _cubit => context.read<MonumentDetailCubit>();

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
  void didUpdateWidget(MonumentDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.monumentId != widget.monumentId) {
      _load();
    }
  }

  void _load() {
    final languageCode = _languageCode;
    if (languageCode != null) {
      unawaited(_cubit.load(id: widget.monumentId, languageCode: languageCode));
    }
  }

  void _onLoaded(BuildContext context, MonumentDetailState state) {
    final openComplex = widget.onOpenComplex;
    if (state case MonumentDetailLoaded(:final monument)
        when monument.isComplex && openComplex != null) {
      openComplex(monument.id);
    }
  }

  void _onStateChanged(BuildContext context, MonumentDetailState state) {
    final l10n = context.l10n;
    final message = switch (state) {
      MonumentDetailFailure() when state.isNotFound =>
        l10n.monumentNotFoundTitle,
      MonumentDetailFailure(:final failure) => failure.toUserMessage(l10n),
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
    return BlocConsumer<MonumentDetailCubit, MonumentDetailState>(
      listenWhen: (previous, current) =>
          current is MonumentDetailFailure ||
          (current is MonumentDetailLoaded &&
              previous is! MonumentDetailLoaded),
      listener: (context, state) {
        _onStateChanged(context, state);
        _onLoaded(context, state);
      },
      builder: (context, state) => switch (state) {
        // Külliye görünümüne geçilirken eser görünümü bir kare bile çizilmez.
        MonumentDetailLoaded(:final monument)
            when monument.isComplex && widget.onOpenComplex != null =>
          _StatusScaffold(
            child: LoadingStatusView(
              key: const Key('monument_detail_loading'),
              label: l10n.monumentDetailLoading,
            ),
          ),
        MonumentDetailLoaded(:final monument, :final siblings) =>
          _MonumentDetailView(
            monument: monument,
            siblings: siblings,
            onOpenComplex: widget.onOpenComplex,
            onOpenMonument: widget.onOpenMonument,
            onShowOnMap: widget.onShowOnMap,
            routeMembership: widget.routeMembership,
            memoriesBuilder: widget.memoriesBuilder,
            onReportDamage: widget.onReportDamage,
            saveButtonBuilder: widget.saveButtonBuilder,
          ),
        MonumentDetailFailure() when state.isNotFound => _StatusScaffold(
          child: StatusMessageView(
            key: const Key('monument_detail_not_found'),
            icon: Icons.search_off_outlined,
            title: l10n.monumentNotFoundTitle,
            message: l10n.monumentNotFoundBody,
            actionLabel: l10n.monumentBackToMap,
            onAction: widget.onBackToMap,
          ),
        ),
        MonumentDetailFailure(:final failure) => _StatusScaffold(
          child: StatusMessageView(
            key: const Key('monument_detail_error'),
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
            key: const Key('monument_detail_loading'),
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

class _MonumentDetailView extends StatelessWidget {
  const _MonumentDetailView({
    required this.monument,
    required this.siblings,
    required this.onOpenComplex,
    required this.onOpenMonument,
    required this.onShowOnMap,
    required this.routeMembership,
    required this.memoriesBuilder,
    required this.onReportDamage,
    required this.saveButtonBuilder,
  });

  final MonumentDetail monument;
  final List<MonumentSummary> siblings;
  final ValueChanged<String>? onOpenComplex;
  final ValueChanged<String>? onOpenMonument;
  final VoidCallback onShowOnMap;
  final MonumentRouteMembership? routeMembership;
  final MonumentSectionBuilder? memoriesBuilder;
  final VoidCallback? onReportDamage;
  final MonumentSectionBuilder? saveButtonBuilder;

  String _speechText(AppLocalizations l10n) => [
    l10n.monumentSpeechIntro(
      monument.name,
      monument.category.label(l10n),
      l10n.monumentLocation(monument.district, monument.city),
    ),
    monument.description,
    monument.history,
  ].join('\n\n');

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final images = monument.images;
    final membership = routeMembership;
    final memories = memoriesBuilder;
    final reportDamage = onReportDamage;
    final complex = monument.complex;
    final openComplex = onOpenComplex;
    final openMonument = onOpenMonument;
    return Scaffold(
      body: CustomScrollView(
        key: const Key('monument_detail_scroll'),
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text(
              monument.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            actions: [?saveButtonBuilder?.call(context, monument)],
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
                        if (complex != null && openComplex != null) ...[
                          const SizedBox(height: AppSpacing.md),
                          ComplexMembershipCard(
                            complex: complex,
                            onOpen: () => openComplex(complex.id),
                          ),
                        ],
                        const SizedBox(height: AppSpacing.md),
                        MonumentFactsCard(monument: monument),
                        if (monument.nickname case final nickname?) ...[
                          const SizedBox(height: AppSpacing.sm),
                          AppText(
                            l10n.monumentNickname(nickname),
                            key: const Key('monument_detail_nickname'),
                          ),
                        ],
                        if (monument.shortDescription.trim().isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.md),
                          AppText(
                            monument.shortDescription,
                            color: context.colors.onSurfaceVariant,
                          ),
                        ],
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
                        // VGM verisi: uzun metin bölümlerdedir (ör. cami,
                        // medrese); her bölüm kendi başlığı ve görselleriyle.
                        if (monument.parts.isEmpty)
                          MonumentSection(
                            title: l10n.monumentAboutHeading,
                            child: MonumentParagraphs(
                              text: monument.description,
                            ),
                          )
                        else
                          for (final (index, part)
                              in monument.parts.indexed) ...[
                            if (index > 0)
                              const SizedBox(height: AppSpacing.xl),
                            MonumentPartSection(
                              key: Key('monument_part_$index'),
                              part: part,
                              title: monument.parts.length == 1
                                  ? l10n.monumentAboutHeading
                                  : part.title ??
                                        l10n.monumentPartFallback(index + 1),
                            ),
                          ],
                        if (monument.history.trim().isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.xl),
                          MonumentSection(
                            title: l10n.monumentHistoryHeading,
                            child: MonumentParagraphs(text: monument.history),
                          ),
                        ],

                        const SizedBox(height: AppSpacing.xl),
                        MonumentLocationSection(
                          monument: monument,
                          onShowOnMap: onShowOnMap,
                        ),
                        if (siblings.isNotEmpty && openMonument != null) ...[
                          const SizedBox(height: AppSpacing.xl),
                          ComplexSiblingsSection(
                            siblings: siblings,
                            onOpenMonument: openMonument,
                          ),
                        ],
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
                          PhotoCreditsSection(
                            images: [
                              ...images,
                              for (final part in monument.parts) ...part.images,
                            ],
                          ),
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
