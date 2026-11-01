import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_summary.dart';
import 'package:vakif_atlas/features/catalog/presentation/bloc/monument_search_bloc.dart';
import 'package:vakif_atlas/features/catalog/presentation/catalog_presentation.dart';
import 'package:vakif_atlas/features/catalog/presentation/widgets/monument_search_view.dart';

/// Arama ekranından haritaya dönen seçim.
sealed class MonumentSearchResult {
  const MonumentSearchResult();
}

/// Eser satırına dokunuldu → eser detayı.
final class MonumentSearchOpenDetails extends MonumentSearchResult {
  const MonumentSearchOpenDetails(this.monumentId, {this.isComplex = false});

  final String monumentId;

  /// Külliye ayrı detay görünümünde açılır.
  final bool isComplex;
}

/// "Haritada göster" → eser haritada seçilir.
final class MonumentSearchShowOnMap extends MonumentSearchResult {
  const MonumentSearchShowOnMap(this.monumentId);

  final String monumentId;
}

/// İl / ilçe önerisi → harita o bölgeye odaklanır.
final class MonumentSearchPlaceChosen extends MonumentSearchResult {
  const MonumentSearchPlaceChosen(this.place);

  final MonumentPlace place;
}

/// "Sonuçları haritada göster" → sorgu ve filtre haritaya uygulanır.
final class MonumentSearchAppliedToMap extends MonumentSearchResult {
  const MonumentSearchAppliedToMap(this.query);

  final MonumentSearchQuery query;
}

/// Haritanın tam ekran araması: sonuçtan eser detayı, "haritada göster",
/// il/ilçe önerisi veya "N sonucu haritada göster" seçilir ve sonuç `pop`
/// ile haritaya döner. Sorgu boşken liste haritanın metin alternatifidir
/// (WCAG 1.1.1, 2.5.7). `MonumentSearchBloc` üst ağaçtan sağlanır.
class MonumentSearchPage extends StatelessWidget {
  const MonumentSearchPage({
    this.initialQuery = MonumentSearchQuery.empty,
    super.key,
  });

  final MonumentSearchQuery initialQuery;

  /// Metin girişinin seyreltilme süresi.
  static const Duration debounce = MonumentSearchView.debounce;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    void close(MonumentSearchResult result) =>
        Navigator.of(context).pop(result);

    return MonumentSearchView(
      initialQuery: initialQuery,
      placeBuilder: (context, place) => _PlaceTile(
        place: place,
        onTap: () => close(MonumentSearchPlaceChosen(place)),
      ),
      itemBuilder: (context, monument) => _MonumentTile(
        monument: monument,
        onTap: () => close(
          MonumentSearchOpenDetails(monument.id, isComplex: monument.isComplex),
        ),
        onShowOnMap: () => close(MonumentSearchShowOnMap(monument.id)),
      ),
      floatingActionButtonBuilder: (context, state) =>
          !state.query.isEmpty &&
              state.status == MonumentSearchStatus.success &&
              state.total > 0
          ? FloatingActionButton.extended(
              // Sekmeler aynı kabuk rotasında yaşadığından varsayılan hero
              // etiketi çakışır; FAB'lar arası paylaşılan öğe geçişi yoktur.
              heroTag: null,
              key: const Key('monument_search_apply_to_map'),
              onPressed: () => close(MonumentSearchAppliedToMap(state.query)),
              icon: const Icon(Icons.map_outlined),
              label: Text(l10n.searchApplyToMap(state.total)),
            )
          : null,
    );
  }
}

class _PlaceTile extends StatelessWidget {
  const _PlaceTile({required this.place, required this.onTap});

  final MonumentPlace place;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final district = place.district;
    return ListTile(
      key: Key('monument_search_place_${place.city}_${district ?? ''}'),
      leading: MonumentSearchLeadingIcon(
        icon: district == null
            ? Icons.location_city_outlined
            : Icons.place_outlined,
      ),
      title: Text(
        district == null
            ? place.city
            : l10n.monumentLocation(district, place.city),
      ),
      subtitle: Text(l10n.monumentCount(place.count)),
      onTap: onTap,
    );
  }
}

class _MonumentTile extends StatelessWidget {
  const _MonumentTile({
    required this.monument,
    required this.onTap,
    required this.onShowOnMap,
  });

  final MonumentSummary monument;
  final VoidCallback onTap;
  final VoidCallback onShowOnMap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListTile(
      key: Key('monument_search_item_${monument.id}'),
      leading: MonumentSearchLeadingIcon(icon: monument.category.icon),
      title: Text(monument.name),
      subtitle: Text(monument.listSubtitle(l10n)),
      trailing: IconButton(
        key: Key('monument_search_show_on_map_${monument.id}'),
        tooltip: l10n.searchShowOnMap(monument.name),
        icon: const Icon(Icons.map_outlined),
        onPressed: onShowOnMap,
      ),
      onTap: onTap,
    );
  }
}
