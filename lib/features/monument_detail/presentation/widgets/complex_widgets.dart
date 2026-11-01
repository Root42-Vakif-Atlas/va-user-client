import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/map/map_tiles.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/geo_point.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/complex.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_summary.dart';
import 'package:vakif_atlas/features/catalog/presentation/catalog_presentation.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/widgets/monument_sections.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_network_image.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/organisms/app_map.dart';
import 'package:vakif_atlas/shared/widgets/organisms/map_pin.dart';

/// Külliyedeki bir yapının numaralı satırı. Numara yerleşim planındaki
/// pinle aynıdır; satırın tamamı tek butondur.
class ComplexMemberTile extends StatelessWidget {
  const ComplexMemberTile({
    required this.index,
    required this.monument,
    required this.onTap,
    super.key,
  });

  /// 1'den başlayan sıra.
  final int index;
  final MonumentSummary monument;
  final VoidCallback onTap;

  static const double _thumbnail = AppSizes.minTouchTarget + AppSpacing.xs;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final thumbnail = monument.thumbnailUrl;
    final category = monument.category.label(l10n);
    return Semantics(
      button: true,
      label: l10n.complexMemberSemantics(index, monument.name, category),
      excludeSemantics: true,
      onTap: onTap,
      child: InkWell(
        key: Key('complex_member_${monument.id}'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Row(
            children: [
              _NumberBadge(index: index),
              const SizedBox(width: AppSpacing.sm),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: SizedBox.square(
                  dimension: _thumbnail,
                  child: thumbnail == null
                      ? ColoredBox(
                          color: colors.surfaceVariant,
                          child: AppIcon.decorative(
                            monument.category.icon,
                            color: colors.accentText,
                          ),
                        )
                      : AppNetworkImage(url: thumbnail),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(monument.name, role: AppTextRole.titleMedium),
                    const SizedBox(height: AppSpacing.xxs),
                    Row(
                      children: [
                        AppIcon.decorative(
                          monument.category.icon,
                          size: AppSizes.iconSm,
                          color: colors.accentText,
                        ),
                        const SizedBox(width: AppSpacing.xxs),
                        Flexible(
                          child: AppText(
                            category,
                            role: AppTextRole.bodySmall,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              AppIcon.decorative(
                Icons.chevron_right,
                color: colors.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Liste numarası; yerleşim planındaki pinle aynı renk ve biçim (◇).
class _NumberBadge extends StatelessWidget {
  const _NumberBadge({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox.square(
      dimension: AppSizes.mapPinSide + AppSpacing.xs,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: math.pi / 4,
            child: Container(
              width: AppSizes.mapPinSide - AppSpacing.xxs,
              height: AppSizes.mapPinSide - AppSpacing.xxs,
              decoration: BoxDecoration(
                color: colors.brandAccent,
                borderRadius: BorderRadius.circular(AppRadius.xs),
                border: Border.all(
                  color: colors.complexAccent,
                  width: AppSizes.borderThick,
                ),
              ),
            ),
          ),
          Text(
            '$index',
            textScaler: TextScaler.noScaling,
            style: context.textStyles.labelLarge.copyWith(
              color: colors.onBrandAccent,
            ),
          ),
        ],
      ),
    );
  }
}

/// "Külliyedeki yapılar": ilk sayfanın numaralı satırları ve (daha fazlası
/// varsa) "Tüm yapıları gör".
class ComplexMembersSection extends StatelessWidget {
  const ComplexMembersSection({
    required this.complex,
    required this.onOpenMonument,
    required this.onSeeAll,
    super.key,
  });

  final ComplexDetail complex;
  final ValueChanged<String> onOpenMonument;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final members = complex.members.items;
    return MonumentSection(
      title: l10n.complexMembersTitle,
      child: Column(
        key: const Key('complex_members_section'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (members.isEmpty)
            AppText(
              l10n.complexMembersEmpty,
              color: context.colors.onSurfaceVariant,
            )
          else
            for (var index = 0; index < members.length; index++)
              ComplexMemberTile(
                index: index + 1,
                monument: members[index],
                onTap: () => onOpenMonument(members[index].id),
              ),
          if (complex.members.hasMore) ...[
            const SizedBox(height: AppSpacing.sm),
            AppButton.secondary(
              key: const Key('complex_members_see_all_button'),
              label: l10n.complexMembersSeeAll(complex.members.total),
              icon: Icons.list_alt_outlined,
              expand: true,
              onPressed: onSeeAll,
            ),
          ],
        ],
      ),
    );
  }
}

/// Yerleşim planı: külliye alanı ve listeyle aynı numaralı üye pinleri.
///
/// Liste birinciltir; harita tamamlayıcıdır (WCAG 1.3.1) ve ekran okuyucuya
/// tek, adlandırılmış öğe olarak sunulur. Pin dokunuşu yapının detayını açar.
class ComplexLayoutMap extends StatefulWidget {
  const ComplexLayoutMap({
    required this.complex,
    required this.onOpenMonument,
    required this.onShowOnMap,
    super.key,
  });

  final ComplexDetail complex;
  final ValueChanged<String> onOpenMonument;
  final VoidCallback onShowOnMap;

  @override
  State<ComplexLayoutMap> createState() => _ComplexLayoutMapState();
}

class _ComplexLayoutMapState extends State<ComplexLayoutMap> {
  final AppMapController _map = AppMapController();

  static const double _aspectRatio = 4 / 3;

  @override
  void initState() {
    super.initState();
    _fit();
  }

  @override
  void didUpdateWidget(ComplexLayoutMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.complex != widget.complex) {
      _fit();
    }
  }

  void _fit() {
    final points = [
      for (final point in widget.complex.footprint) point.toLatLng(),
      for (final member in widget.complex.members.items)
        if (member.location case final location? when location.isValid)
          location.toLatLng(),
    ];
    _map.showAll(
      points,
      padding: const EdgeInsets.all(AppSpacing.lg),
      maxZoom: MapTiles.maxZoom.toDouble(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final complex = widget.complex;
    final members = complex.members.items;
    // Yerleşim planı yalnızca konumlu yapı varken çizilir (sayfa denetler).
    final center =
        complex.bounds?.center ??
        complex.monument.location ??
        members.map((m) => m.location).whereType<GeoPoint>().first;
    return MonumentSection(
      title: l10n.complexLayoutTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: AspectRatio(
              aspectRatio: _aspectRatio,
              child: Semantics(
                container: true,
                label: l10n.complexLayoutMapSemantics(
                  complex.monument.name,
                  l10n.complexMemberCount(complex.memberCount),
                ),
                // Pinlerin karşılığı yukarıdaki numaralı listedir.
                excludeSemantics: true,
                child: AppMap(
                  key: const Key('complex_layout_map'),
                  controller: _map,
                  interactive: false,
                  initialCenter: center.toLatLng(),
                  initialZoom: MapTiles.complexExpandZoom.toDouble(),
                  layers: [
                    if (complex.footprint.length >= 3)
                      PolygonLayer(
                        polygons: [
                          Polygon(
                            points: [
                              for (final point in complex.footprint)
                                point.toLatLng(),
                            ],
                            color: colors.complexAccent.withValues(alpha: 0.12),
                            borderColor: colors.complexAccent,
                            borderStrokeWidth: AppSizes.mapComplexOutline,
                          ),
                        ],
                      ),
                  ],
                  markers: [
                    for (var index = 0; index < members.length; index++)
                      if (members[index].location case final location?
                          when location.isValid)
                        Marker(
                          key: ValueKey('layout_${members[index].id}'),
                          point: LatLng(location.latitude, location.longitude),
                          width: MapPin.extent(selected: false),
                          height: MapPin.extent(selected: false),
                          child: MapPin(
                            key: Key('complex_layout_pin_${members[index].id}'),
                            label: '${index + 1}',
                            memberOfComplex: true,
                            semanticsLabel: members[index].name,
                            onTap: () =>
                                widget.onOpenMonument(members[index].id),
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton.secondary(
            key: const Key('complex_show_on_map_button'),
            label: l10n.monumentShowOnMap,
            icon: Icons.map_outlined,
            expand: true,
            onPressed: widget.onShowOnMap,
          ),
        ],
      ),
    );
  }
}

/// Külliye yapısının detayında, bağlı olduğu külliyeye geçiş kartı
/// (kartın tamamı tek buton).
class ComplexMembershipCard extends StatelessWidget {
  const ComplexMembershipCard({
    required this.complex,
    required this.onOpen,
    super.key,
  });

  final ComplexRef complex;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final title = l10n.complexPartOf(complex.name);
    return Semantics(
      button: true,
      label: title,
      hint: l10n.complexPartOfHint,
      excludeSemantics: true,
      onTap: onOpen,
      child: Material(
        color: colors.surfaceElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(
            color: colors.complexAccent,
            width: AppSizes.borderThick,
          ),
        ),
        child: InkWell(
          key: const Key('monument_complex_card'),
          onTap: onOpen,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                AppIcon.decorative(
                  Icons.account_balance_outlined,
                  color: colors.complexAccent,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(title, role: AppTextRole.titleMedium),
                      const SizedBox(height: AppSpacing.xxs),
                      AppText(
                        l10n.complexPartOfHint,
                        role: AppTextRole.bodySmall,
                        color: colors.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
                AppIcon.decorative(
                  Icons.chevron_right,
                  color: colors.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// "Külliyedeki diğer yapılar": kendisi hariç kardeş yapıların listesi.
class ComplexSiblingsSection extends StatelessWidget {
  const ComplexSiblingsSection({
    required this.siblings,
    required this.onOpenMonument,
    super.key,
  });

  final List<MonumentSummary> siblings;
  final ValueChanged<String> onOpenMonument;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return MonumentSection(
      title: l10n.complexSiblingsTitle,
      child: Column(
        key: const Key('complex_siblings_section'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final sibling in siblings)
            ListTile(
              key: Key('complex_sibling_${sibling.id}'),
              contentPadding: EdgeInsets.zero,
              leading: AppIcon.decorative(
                sibling.category.icon,
                color: colors.accentText,
              ),
              title: Text(sibling.name),
              subtitle: Text(sibling.category.label(l10n)),
              trailing: AppIcon.decorative(
                Icons.chevron_right,
                color: colors.onSurfaceVariant,
              ),
              onTap: () => onOpenMonument(sibling.id),
            ),
        ],
      ),
    );
  }
}
