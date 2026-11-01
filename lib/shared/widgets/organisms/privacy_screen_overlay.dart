import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/launch_colors.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/shared/widgets/atoms/brand_emblem.dart';

/// Uygulama arka plandayken içeriği marka örtüsüyle (açılış ekranıyla aynı
/// sade logo) kapatır.
class PrivacyScreenOverlay extends StatelessWidget {
  const PrivacyScreenOverlay({
    required this.isObscured,
    required this.child,
    super.key,
  });

  final ValueListenable<bool> isObscured;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isObscured,
      child: child,
      builder: (context, obscured, app) => Stack(
        fit: StackFit.expand,
        children: [app!, if (obscured) const _BrandCover()],
      ),
    );
  }
}

/// Yerel açılış ekranıyla aynı: marka zemini ve ortada yalnızca amblem
/// (metin yok). Tema ve kontrast tercihinden bağımsızdır (`LaunchColors`).
class _BrandCover extends StatelessWidget {
  const _BrandCover();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: context.l10n.privacyOverlaySemantics,
      excludeSemantics: true,
      child: const ColoredBox(
        key: Key('privacy_screen_cover'),
        color: LaunchColors.background,
        child: Center(
          child: BrandEmblem(
            size: AppSizes.splashEmblem,
            frameColor: LaunchColors.foreground,
            accentColor: LaunchColors.accent,
          ),
        ),
      ),
    );
  }
}
