import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/l10n/failure_messages.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/catalog/presentation/catalog_presentation.dart';
import 'package:vakif_atlas/features/catalog/presentation/widgets/monument_search_view.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/cubit/complex_members_cubit.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/widgets/complex_widgets.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_progress_indicator.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/templates/loading_status_view.dart';
import 'package:vakif_atlas/shared/widgets/templates/status_message_view.dart';

/// Külliyenin tüm yapıları (`/complex/:id/monuments`): tür çipleriyle
/// süzülen, sona yaklaşınca sonraki sayfayı isteyen numaralı liste.
class ComplexMembersPage extends StatefulWidget {
  const ComplexMembersPage({
    required this.complexId,
    required this.onOpenMonument,
    this.complexName,
    super.key,
  });

  final String complexId;

  /// Başlık için (`GoRouter.extra`); yoksa genel başlık.
  final String? complexName;
  final ValueChanged<String> onOpenMonument;

  @override
  State<ComplexMembersPage> createState() => _ComplexMembersPageState();
}

class _ComplexMembersPageState extends State<ComplexMembersPage> {
  final ScrollController _scroll = ScrollController();
  String? _languageCode;

  ComplexMembersCubit get _cubit => context.read<ComplexMembersCubit>();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageCode = Localizations.localeOf(context).languageCode;
    if (languageCode != _languageCode) {
      _languageCode = languageCode;
      unawaited(
        _cubit.load(complexId: widget.complexId, languageCode: languageCode),
      );
    }
  }

  void _onScroll() {
    if (_scroll.hasClients &&
        _scroll.position.extentAfter < MonumentSearchView.loadMoreExtent) {
      unawaited(_cubit.loadMore());
    }
  }

  void _announce(BuildContext context, ComplexMembersState state) {
    final l10n = context.l10n;
    final message = switch (state.status) {
      ComplexMembersStatus.success when state.items.isEmpty =>
        l10n.complexMembersFilterEmpty,
      ComplexMembersStatus.success => l10n.complexMemberCount(state.total),
      ComplexMembersStatus.failure => l10n.complexMembersLoadFailed,
      _ => null,
    };
    if (message != null) {
      unawaited(context.read<A11yAnnouncer>().announce(message));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final name = widget.complexName;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          name == null
              ? l10n.complexMembersTitle
              : l10n.complexMembersPageTitle(name),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: BlocConsumer<ComplexMembersCubit, ComplexMembersState>(
        listenWhen: (previous, current) =>
            previous.status != current.status &&
            current.status != ComplexMembersStatus.loading,
        listener: _announce,
        builder: (context, state) {
          if (state.status == ComplexMembersStatus.failure) {
            return StatusMessageView(
              key: const Key('complex_members_error'),
              tone: StatusMessageTone.error,
              icon: Icons.cloud_off_outlined,
              title: l10n.complexMembersLoadFailed,
              message: (state.failure)?.toUserMessage(l10n) ?? '',
              actionLabel: l10n.commonRetry,
              onAction: () => unawaited(_cubit.retry()),
            );
          }
          if (state.status != ComplexMembersStatus.success &&
              state.items.isEmpty) {
            return LoadingStatusView(
              key: const Key('complex_members_loading'),
              label: l10n.complexMembersTitle,
            );
          }
          return CustomScrollView(
            key: const Key('complex_members_list'),
            controller: _scroll,
            slivers: [
              if (state.availableCategories.length > 1)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.sm,
                      AppSpacing.md,
                      0,
                    ),
                    child: Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: [
                        for (final category in state.availableCategories)
                          FilterChip(
                            key: Key('complex_members_chip_${category.name}'),
                            avatar: Icon(category.icon),
                            label: Text(category.label(l10n)),
                            selected: state.categories.contains(category),
                            onSelected: (_) =>
                                unawaited(_cubit.toggleCategory(category)),
                          ),
                      ],
                    ),
                  ),
                ),
              if (state.items.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Center(
                      child: AppText(
                        state.categories.isEmpty
                            ? l10n.complexMembersEmpty
                            : l10n.complexMembersFilterEmpty,
                        key: const Key('complex_members_empty'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  sliver: SliverList.builder(
                    itemCount: state.items.length,
                    itemBuilder: (context, index) => ComplexMemberTile(
                      index: index + 1,
                      monument: state.items[index],
                      onTap: () => widget.onOpenMonument(state.items[index].id),
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                child: _Footer(state: state, cubit: _cubit),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.state, required this.cubit});

  final ComplexMembersState state;
  final ComplexMembersCubit cubit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final Widget child;
    if (state.isLoadingMore) {
      child = Semantics(
        label: l10n.commonLoading,
        liveRegion: true,
        excludeSemantics: true,
        child: const Center(child: AppProgressIndicator(strokeWidth: 4)),
      );
    } else if (state.failure != null && state.items.isNotEmpty) {
      child = AppButton.secondary(
        key: const Key('complex_members_retry_more'),
        label: l10n.commonRetry,
        icon: Icons.refresh,
        onPressed: () => unawaited(cubit.retry()),
      );
    } else if (!state.hasMore && state.items.isNotEmpty) {
      child = AppText(
        l10n.complexMembersEndOfList(state.total),
        key: const Key('complex_members_end'),
        role: AppTextRole.bodySmall,
        textAlign: TextAlign.center,
      );
    } else {
      child = const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.xs,
        AppSpacing.md,
        AppSpacing.xl,
      ),
      child: child,
    );
  }
}
