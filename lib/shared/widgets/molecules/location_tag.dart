import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';

/// Konum etiketi (ör. "Fatih, İstanbul").
class LocationTag extends StatelessWidget {
  const LocationTag({
    required this.label,
    required this.semanticsLabel,
    super.key,
  });

  final String label;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      label: semanticsLabel,
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIcon.decorative(
            Icons.place_outlined,
            size: AppSizes.iconSm,
            color: colors.accentText,
          ),
          const SizedBox(width: AppSpacing.xxs),
          Flexible(
            child: Text(
              label,
              style: context.textStyles.labelLarge.copyWith(
                color: colors.accentText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
