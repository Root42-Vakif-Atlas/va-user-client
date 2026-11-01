import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/l10n/failure_messages.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_filter.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_summary.dart';
import 'package:vakif_atlas/features/catalog/presentation/bloc/monument_search_bloc.dart';
import 'package:vakif_atlas/features/catalog/presentation/widgets/search_filter_bar.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/molecules/inline_message.dart';
import 'package:vakif_atlas/shared/widgets/templates/status_message_view.dart';

/// Sunucu tarafı eser araması + filtre ekranının ortak gövdesi: arama
/// alanı, filtre çipleri, sayfalı sonuç listesi ve durum görünümleri.
///
/// Harita araması ve rota planlayıcının eser seçicisi aynı bileşeni farklı
/// satır ([itemBuilder]) ve eylemlerle kullanır. `MonumentSearchBloc` üst
/// ağaçtan sağlanır.
///
/// - Bloc daha önce yüklendiyse (ör. seçici yeniden açıldı) son arama ve
///   sonuçlar korunur; [initialQuery] yalnızca ilk aramada kullanılır.
/// - Metin yazma durduktan [debounce] sonra, filtre değişince hemen istenir.
/// - Sorgu boşken tüm eserler (alfabetik, sayfalı) listelenir.
/// - Sonuç sayısı ve yüklenen her yeni sayfa ekran okuyucuya duyurulur
///   (WCAG 4.1.3); altta yükleme / hata / liste sonu durumu görünür.
class MonumentSearchView extends StatefulWidget {
  const MonumentSearchView({
    required this.itemBuilder,
    this.initialQuery = MonumentSearchQuery.empty,
    this.hintText,
    this.autofocus,
    this.placeBuilder,
    this.floatingActionButtonBuilder,
    this.bottomBar,
    super.key,
  });

  final MonumentSearchQuery initialQuery;

  /// Sonuç satırı.
  final Widget Function(BuildContext context, MonumentSummary monument)
  itemBuilder;

  /// Arama alanı ipucu; varsayılan "Yer veya eser ara".
  final String? hintText;

  /// Varsayılan: başlangıç sorgusu boşsa klavye açılır.
  final bool? autofocus;

  /// İl / ilçe önerisi satırı; `null` → öneriler gösterilmez.
  final Widget Function(BuildContext context, MonumentPlace place)?
  placeBuilder;

  final Widget? Function(BuildContext context, MonumentSearchState state)?
  floatingActionButtonBuilder;

  /// Alt eylem çubuğu (ör. seçimi bitir).
  final Widget? bottomBar;

  /// Metin girişinin seyreltilme süresi.
  static const Duration debounce = Duration(milliseconds: 350);

  /// Liste sonuna bu mesafe kaldığında sonraki sayfa istenir.
  static const double loadMoreExtent = 600;

  @override
  State<MonumentSearchView> createState() => _MonumentSearchViewState();
}

class _MonumentSearchViewState extends State<MonumentSearchView> {
  late final TextEditingController _controller = TextEditingController(
    text: _resumed ? _bloc.state.query.text : widget.initialQuery.text,
  );
  final ScrollController _scroll = ScrollController();
  Timer? _debounce;
  String? _languageCode;

  MonumentSearchBloc get _bloc => context.read<MonumentSearchBloc>();

  bool get _showPlaces => widget.placeBuilder != null;

  /// Bloc bu görünümden önce arama yapmış.
  late final bool _resumed = _bloc.state.status != MonumentSearchStatus.initial;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_maybeLoadMore);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageCode = Localizations.localeOf(context).languageCode;
    if (languageCode != _languageCode) {
      final first = _languageCode == null;
      _languageCode = languageCode;
      if (first && _resumed && _bloc.state.languageCode == languageCode) {
        return;
      }
      _bloc.add(
        MonumentSearchEvent.started(
          languageCode: languageCode,
          query: first && !_resumed ? widget.initialQuery : _bloc.state.query,
        ),
      );
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _onTextChanged(String text) {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(MonumentSearchView.debounce, () {
      if (mounted) {
        _bloc.add(
          MonumentSearchEvent.queryChanged(_bloc.state.query.withText(text)),
        );
      }
    });
  }

  void _clearText() {
    _controller.clear();
    _onTextChanged('');
  }

  void _onFilterChanged(MonumentFilter filter) {
    _debounce?.cancel();
    _bloc.add(
      MonumentSearchEvent.queryChanged(
        _bloc.state.query.withText(_controller.text).withFilter(filter),
      ),
    );
  }

  void _maybeLoadMore() {
    if (!_scroll.hasClients) {
      return;
    }
    if (_scroll.position.extentAfter < MonumentSearchView.loadMoreExtent) {
      _bloc.add(const MonumentSearchEvent.nextPageRequested());
    }
  }

  void _announce(String message, {bool assertive = false}) => unawaited(
    context.read<A11yAnnouncer>().announce(message, assertive: assertive),
  );

  void _onPageLoaded(BuildContext context, MonumentSearchState state) {
    final l10n = context.l10n;
    final firstPage = state.items.length == state.lastPageSize;
    _announce(
      firstPage
          ? l10n.searchResultsAnnouncement(
              state.total + (_showPlaces ? state.places.length : 0),
            )
          : l10n.searchMoreLoadedAnnouncement(state.lastPageSize),
    );
    // İlk sayfa ekranı doldurmuyorsa kaydırma olmaz; sonraki sayfa yine de
    // istenir.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _maybeLoadMore();
      }
    });
  }

  void _onFailure(BuildContext context, MonumentSearchState state) {
    final l10n = context.l10n;
    final failure = state.failure;
    if (state.status == MonumentSearchStatus.failure && failure != null) {
      _announce(failure.toUserMessage(l10n), assertive: true);
    } else if (state.loadMoreFailure != null) {
      _announce(l10n.searchLoadMoreFailed, assertive: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return MultiBlocListener(
      listeners: [
        BlocListener<MonumentSearchBloc, MonumentSearchState>(
          listenWhen: (previous, current) =>
              current.status == MonumentSearchStatus.success &&
              (previous.status != MonumentSearchStatus.success ||
                  current.items.length > previous.items.length),
          listener: _onPageLoaded,
        ),
        BlocListener<MonumentSearchBloc, MonumentSearchState>(
          listenWhen: (previous, current) =>
              (current.status == MonumentSearchStatus.failure &&
                  previous.status != MonumentSearchStatus.failure) ||
              (current.loadMoreFailure != null &&
                  previous.loadMoreFailure == null),
          listener: _onFailure,
        ),
      ],
      child: BlocBuilder<MonumentSearchBloc, MonumentSearchState>(
        builder: (context, state) {
          final fab = widget.floatingActionButtonBuilder?.call(context, state);
          return Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
              title: TextField(
                key: const Key('monument_search_field'),
                controller: _controller,
                autofocus: widget.autofocus ?? widget.initialQuery.isEmpty,
                textInputAction: TextInputAction.search,
                onChanged: _onTextChanged,
                // Sonuçlar yazdıkça gelir; "Ara" klavyeyi kapatır.
                onSubmitted: (_) => FocusScope.of(context).unfocus(),
                style: context.textStyles.bodyLarge.copyWith(
                  color: colors.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText ?? l10n.mapSearchHint,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                ),
              ),
              actions: [
                if (_controller.text.isNotEmpty)
                  IconButton(
                    key: const Key('monument_search_clear_button'),
                    tooltip: l10n.mapSearchClear,
                    icon: const Icon(Icons.close),
                    onPressed: _clearText,
                  ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(
                  AppSizes.minTouchTarget + AppSpacing.xs,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: SearchFilterBar(
                    filter: state.query.filter,
                    facets: state.facets,
                    onChanged: _onFilterChanged,
                  ),
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: fab,
            bottomNavigationBar: widget.bottomBar,
            body: SafeArea(
              top: false,
              child: _buildBody(context, state, reserveFabSpace: fab != null),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    MonumentSearchState state, {
    required bool reserveFabSpace,
  }) {
    final l10n = context.l10n;
    final query = state.query;
    final failure = state.failure;
    final places = _showPlaces ? state.places : const <MonumentPlace>[];

    if (state.status == MonumentSearchStatus.failure && failure != null) {
      return StatusMessageView(
        key: const Key('monument_search_error'),
        tone: StatusMessageTone.error,
        icon: Icons.cloud_off_outlined,
        title: l10n.searchLoadFailedTitle,
        message: failure.toUserMessage(l10n),
        actionLabel: l10n.commonRetry,
        onAction: () => _bloc.add(const MonumentSearchEvent.retryRequested()),
      );
    }
    if (state.items.isEmpty && places.isEmpty) {
      if (state.status != MonumentSearchStatus.success) {
        return const Center(child: CircularProgressIndicator());
      }
      final text = query.normalizedText;
      return StatusMessageView(
        key: const Key('monument_search_empty'),
        icon: Icons.search_off,
        title: l10n.searchNoResultsTitle,
        message: text.isEmpty
            ? l10n.searchNoFilterResultsBody
            : l10n.searchNoResultsBody(text),
        actionLabel: query.filter.isEmpty ? null : l10n.searchRemoveFilters,
        onAction: query.filter.isEmpty
            ? null
            : () => _onFilterChanged(MonumentFilter.none),
      );
    }

    final placeBuilder = widget.placeBuilder;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Yeni sorgu yüklenirken önceki sonuçlar görünür kalır.
        if (state.isLoading)
          const LinearProgressIndicator(
            key: Key('monument_search_refreshing'),
            minHeight: AppSizes.borderThick,
          ),
        Expanded(
          child: CustomScrollView(
            key: const Key('monument_search_results'),
            controller: _scroll,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              if (placeBuilder != null && places.isNotEmpty) ...[
                _SectionHeader(title: l10n.searchPlacesHeader),
                SliverList.list(
                  children: [
                    for (final place in places) placeBuilder(context, place),
                  ],
                ),
              ],
              _SectionHeader(
                title: query.isEmpty
                    ? l10n.searchAllMonuments
                    : l10n.searchMonumentsHeader,
                trailing: l10n.searchResultsTotal(state.total),
              ),
              SliverList.separated(
                itemCount: state.items.length,
                separatorBuilder: (_, _) => const Divider(height: 0),
                itemBuilder: (context, index) =>
                    widget.itemBuilder(context, state.items[index]),
              ),
              SliverToBoxAdapter(
                child: _ListFooter(
                  state: state,
                  reserveFabSpace: reserveFabSpace,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Liste sonu: sonraki sayfa yükleniyor, yüklenemedi (tekrar dene) veya
/// tüm sonuçlar gösterildi.
class _ListFooter extends StatelessWidget {
  const _ListFooter({required this.state, required this.reserveFabSpace});

  final MonumentSearchState state;

  /// Altta yüzen buton son satırı örtmesin diye boşluk bırakılır.
  final bool reserveFabSpace;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final Widget content;
    if (state.loadMoreFailure != null) {
      content = Column(
        key: const Key('monument_search_load_more_error'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InlineMessage(
            message: l10n.searchLoadMoreFailed,
            type: InlineMessageType.error,
          ),
          const SizedBox(height: AppSpacing.xs),
          AppButton.secondary(
            key: const Key('monument_search_load_more_retry'),
            label: l10n.commonRetry,
            icon: Icons.refresh,
            onPressed: () => context.read<MonumentSearchBloc>().add(
              const MonumentSearchEvent.retryRequested(),
            ),
          ),
        ],
      );
    } else if (state.hasMore && !state.isLoadingMore) {
      // Sonraki sayfa sona yaklaşınca istenir; o zamana kadar gösterge
      // çizilmez (alt bilgi tembel listede de kurulur, ekran dışında dönen
      // gösterge boşuna kare üretirdi). Aynı yükseklik korunur: liste
      // yüklemeye geçince zıplamaz.
      content = const SizedBox(
        key: Key('monument_search_more_available'),
        height: AppSizes.iconLg,
      );
    } else if (state.hasMore) {
      content = Semantics(
        key: const Key('monument_search_loading_more'),
        label: l10n.searchLoadingMore,
        excludeSemantics: true,
        child: const Center(
          child: SizedBox.square(
            dimension: AppSizes.iconLg,
            child: CircularProgressIndicator(
              strokeWidth: AppSizes.spinnerStroke,
            ),
          ),
        ),
      );
    } else if (state.items.isNotEmpty) {
      content = AppText(
        l10n.searchEndOfResults(state.total),
        key: const Key('monument_search_end'),
        role: AppTextRole.bodyMedium,
        color: colors.onSurfaceVariant,
        textAlign: TextAlign.center,
      );
    } else {
      content = const SizedBox.shrink();
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        reserveFabSpace ? AppSpacing.x4l + AppSpacing.md : AppSpacing.md,
      ),
      child: content,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.trailing});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final trailing = this.trailing;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.xs,
        ),
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSpacing.xs,
          children: [
            AppText(
              title,
              role: AppTextRole.titleMedium,
              color: colors.accentText,
              isHeading: true,
            ),
            if (trailing != null)
              AppText(
                trailing,
                key: const Key('monument_search_total'),
                role: AppTextRole.bodyMedium,
                color: colors.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }
}

/// Arama sonucu satırlarının baş ikonu (yapı türü / yer).
class MonumentSearchLeadingIcon extends StatelessWidget {
  const MonumentSearchLeadingIcon({required this.icon, super.key});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: AppSizes.minTouchTarget,
      height: AppSizes.minTouchTarget,
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: AppIcon.decorative(icon, color: colors.accentText),
    );
  }
}
