import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_detail.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/molecules/info_chip.dart';
import 'package:vakif_atlas/shared/widgets/molecules/location_tag.dart';

/// Eser adı, konumu ve (varsa) UNESCO etiketi. Sınıflandırma ve tarih
/// bilgisi hemen altındaki künye kartındadır (tekrarlanmaz).
class MonumentHeader extends StatelessWidget {
  const MonumentHeader({required this.monument, super.key});

  final MonumentDetail monument;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final location = l10n.monumentLocation(monument.district, monument.city);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          monument.name,
          key: const Key('monument_detail_name'),
          role: AppTextRole.headlineLarge,
          isHeading: true,
        ),
        const SizedBox(height: AppSpacing.xs),
        LocationTag(
          label: location,
          semanticsLabel: l10n.monumentLocationSemantics(location),
        ),
        if (monument.isUnescoWorldHeritage) ...[
          const SizedBox(height: AppSpacing.sm),
          InfoChip(
            key: const Key('monument_detail_unesco_badge'),
            icon: Icons.workspace_premium_outlined,
            label: l10n.monumentUnescoBadge,
            semanticsLabel: l10n.monumentUnescoBadge,
          ),
        ],
      ],
    );
  }
}
