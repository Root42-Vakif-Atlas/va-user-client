import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_icon.dart';

/// [LeadingIconTile]'ın anlam tonu. Ton süs değil anlam taşır: aynı türden
/// satırlar aynı tonda görünür, böylece liste tek renkli bir duvara dönüşmez.
enum LeadingIconTone {
  /// Eylem ve uygulama: birincil (logo yeşili) tonal kap.
  primary,

  /// Genel bilgi ve ikincil satırlar: nötr yüzey.
  neutral,

  /// Vakıf eseri, anı, geri bildirim: Antik Altın tonal kabı.
  heritage,

  /// Külliye, rota, gizlilik ve hukuk: İznik mavisi tonal kabı.
  complex,

  /// Geri dönüşsüz eylem: hata tonu.
  danger,
}

/// Satırın başındaki tonal ikon kutusu; ikon her zaman süstür (satırın metni
/// anlamı taşır), kutu en az 48 dp'dir.
class LeadingIconTile extends StatelessWidget {
  const LeadingIconTile({
    required this.icon,
    this.tone = LeadingIconTone.neutral,
    this.size = AppSizes.minTouchTarget,
    super.key,
  });

  final IconData icon;
  final LeadingIconTone tone;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (fill, foreground) = switch (tone) {
      LeadingIconTone.primary => (
        colors.primaryContainer,
        colors.onPrimaryContainer,
      ),
      LeadingIconTone.neutral => (
        colors.surfaceVariant,
        colors.onSurfaceVariant,
      ),
      LeadingIconTone.heritage => (
        colors.brandAccentContainer,
        colors.onBrandAccentContainer,
      ),
      LeadingIconTone.complex => (
        colors.complexAccentContainer,
        colors.onComplexAccentContainer,
      ),
      LeadingIconTone.danger => (
        colors.tonal(colors.error, strength: 0.14),
        colors.error,
      ),
    };
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: colors.isHighContrast
            ? Border.all(color: foreground, width: AppSizes.borderThin)
            : null,
      ),
      alignment: Alignment.center,
      child: AppIcon.decorative(icon, color: foreground),
    );
  }
}
