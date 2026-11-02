import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/a11y/reduce_motion.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_classification.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_filter.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';
import 'package:vakif_atlas/features/catalog/presentation/catalog_presentation.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';

/// Arama alanının altındaki filtre çipleri: Yapı türü ▾ · Dönem ▾ · İl ▾.
///
/// Her çip kendi grubunun çoklu seçim alt sayfasını açar; seçim özeti çipte
/// ("Cami +1") ve ekran okuyucu etiketinde gösterilir. Seçenek sayıları
/// sunucunun facet sayılarıdır.
class SearchFilterBar extends StatelessWidget {
  const SearchFilterBar({
    required this.filter,
    required this.facets,
    required this.onChanged,
    super.key,
  });

  final MonumentFilter filter;
  final MonumentFacets facets;
  final ValueChanged<MonumentFilter> onChanged;

  Future<void> _open<T>(
    BuildContext context, {
    required String title,
    required List<_Option<T>> options,
    required Set<T> selected,
    required MonumentFilter Function(Set<T> values) apply,
  }) async {
    final values = await showModalBottomSheet<Set<T>>(
      context: context,
      sheetAnimationStyle: context.motionAnimationStyle,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => _FilterOptionsSheet<T>(
        title: title,
        options: options,
        initial: selected,
      ),
    );
    if (values != null) {
      onChanged(apply(values));
    }
  }

  /// Facet'te olmayan ama seçili değerler de listelenir (0 sayıyla).
  static List<_Option<T>> _options<T>(
    Map<T, int> counts,
    Set<T> selected,
    String Function(T value) label, {
    IconData Function(T value)? icon,
    List<T>? order,
  }) {
    final keys = <T>[
      ...?order?.where((value) => counts.containsKey(value)),
      if (order == null) ...counts.keys,
      ...selected.where((value) => !counts.containsKey(value)),
    ];
    return [
      for (final key in keys)
        _Option(
          value: key,
          label: label(key),
          count: counts[key] ?? 0,
          icon: icon?.call(key),
        ),
    ];
  }

  /// Filtre il plaka koduyla tutulur; ad facet'lerden (içerik dilinde).
  String _cityName(int code) => facets.cityNames[code] ?? '$code';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: _buildRow(context, l10n),
    );
  }

  Widget _buildRow(BuildContext context, AppLocalizations l10n) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          _GroupChip(
            key: const Key('search_filter_category'),
            group: l10n.filterCategorySection,
            selection: [
              for (final c in MonumentCategory.values)
                if (filter.categories.contains(c)) c.label(l10n),
            ],
            onTap: () => _open<MonumentCategory>(
              context,
              title: l10n.filterCategorySection,
              selected: filter.categories,
              options: _options(
                facets.categories,
                filter.categories,
                (c) => c.label(l10n),
                icon: (c) => c.icon,
                order: MonumentCategory.values,
              ),
              apply: (values) => MonumentFilter(
                categories: values,
                periods: filter.periods,
                cities: filter.cities,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          _GroupChip(
            key: const Key('search_filter_period'),
            group: l10n.filterPeriodSection,
            selection: [
              for (final p in HistoricalPeriod.values)
                if (filter.periods.contains(p)) p.label(l10n),
            ],
            onTap: () => _open<HistoricalPeriod>(
              context,
              title: l10n.filterPeriodSection,
              selected: filter.periods,
              options: _options(
                facets.periods,
                filter.periods,
                (p) => p.label(l10n),
                order: HistoricalPeriod.values,
              ),
              apply: (values) => MonumentFilter(
                categories: filter.categories,
                periods: values,
                cities: filter.cities,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          _GroupChip(
            key: const Key('search_filter_city'),
            group: l10n.filterCitySection,
            selection: [
              for (final city in facets.cities.keys)
                if (filter.cities.contains(city)) _cityName(city),
              for (final city in filter.cities)
                if (!facets.cities.containsKey(city)) _cityName(city),
            ],
            onTap: () => _open<int>(
              context,
              title: l10n.filterCitySection,
              selected: filter.cities,
              options: _options(facets.cities, filter.cities, _cityName),
              apply: (values) => MonumentFilter(
                categories: filter.categories,
                periods: filter.periods,
                cities: values,
              ),
            ),
          ),
          if (!filter.isEmpty) ...[
            const SizedBox(width: AppSpacing.xs),
            ActionChip(
              key: const Key('search_filter_clear'),
              avatar: const Icon(Icons.close),
              label: Text(l10n.filterClearAllChip),
              onPressed: () => onChanged(MonumentFilter.none),
            ),
          ],
        ],
      ),
    );
  }
}

class _GroupChip extends StatelessWidget {
  const _GroupChip({
    required this.group,
    required this.selection,
    required this.onTap,
    super.key,
  });

  final String group;
  final List<String> selection;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final summary = switch (selection) {
      [] => null,
      [final only] => only,
      [final first, ...final rest] => l10n.filterSelectionSummary(
        first,
        rest.length,
      ),
    };
    return Semantics(
      button: true,
      selected: summary != null,
      label: l10n.filterGroupSemantics(
        group,
        selection.isEmpty ? l10n.filterNoneSelected : selection.join(', '),
      ),
      excludeSemantics: true,
      onTap: onTap,
      child: FilterChip(
        selected: summary != null,
        showCheckmark: false,
        onSelected: (_) => onTap(),
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(summary ?? group),
            const SizedBox(width: AppSpacing.xxs),
            const Icon(Icons.arrow_drop_down, size: AppSizes.iconInline),
          ],
        ),
      ),
    );
  }
}

class _Option<T> {
  const _Option({
    required this.value,
    required this.label,
    required this.count,
    this.icon,
  });

  final T value;
  final String label;
  final int count;
  final IconData? icon;
}

/// Bir filtre grubunun çoklu seçimi. "Uygula" ile seçim döner; seçim yalnızca
/// onay kutusu rengine değil işaretine de dayanır.
class _FilterOptionsSheet<T> extends StatefulWidget {
  const _FilterOptionsSheet({
    required this.title,
    required this.options,
    required this.initial,
  });

  final String title;
  final List<_Option<T>> options;
  final Set<T> initial;

  @override
  State<_FilterOptionsSheet<T>> createState() => _FilterOptionsSheetState<T>();
}

class _FilterOptionsSheetState<T> extends State<_FilterOptionsSheet<T>> {
  late final Set<T> _selected = {...widget.initial};

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                AppText(
                  widget.title,
                  role: AppTextRole.headlineMedium,
                  isHeading: true,
                ),
                TextButton(
                  key: const Key('filter_sheet_clear'),
                  onPressed: _selected.isEmpty
                      ? null
                      : () => setState(_selected.clear),
                  child: Text(l10n.filterGroupClear),
                ),
              ],
            ),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final option in widget.options)
                  CheckboxListTile(
                    key: Key('filter_option_${option.value}'),
                    value: _selected.contains(option.value),
                    onChanged: (checked) => setState(
                      () => checked ?? false
                          ? _selected.add(option.value)
                          : _selected.remove(option.value),
                    ),
                    secondary: option.icon == null
                        ? null
                        : Icon(option.icon, color: colors.onSurfaceVariant),
                    title: Text(
                      l10n.filterOptionWithCount(option.label, option.count),
                    ),
                    controlAffinity: ListTileControlAffinity.trailing,
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: AppButton.primary(
              key: const Key('filter_sheet_apply'),
              label: l10n.filterApplyButton,
              icon: Icons.check,
              expand: true,
              onPressed: () => Navigator.of(context).pop(_selected),
            ),
          ),
        ],
      ),
    );
  }
}
