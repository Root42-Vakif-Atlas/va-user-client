import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';

/// Pusula/karo (◇) motifli marka ayırıcısı (Design System §1.1).
///
/// Dekoratiftir; ekran okuyucudan gizlenir.
class DiamondDivider extends StatelessWidget {
  const DiamondDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final line = Expanded(
      child: Divider(color: colors.outlineVariant, height: AppSpacing.md),
    );

    return ExcludeSemantics(
      child: Row(
        children: [
          line,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            child: Transform.rotate(
              angle: math.pi / 4,
              child: SizedBox.square(
                dimension: AppSizes.diamond,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: colors.brandAccent,
                      width: AppSizes.borderThin,
                    ),
                  ),
                ),
              ),
            ),
          ),
          line,
        ],
      ),
    );
  }
}
