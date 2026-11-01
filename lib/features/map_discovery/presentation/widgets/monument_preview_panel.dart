import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/l10n/failure_messages.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_detail.dart';
import 'package:vakif_atlas/features/catalog/presentation/catalog_presentation.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/molecules/info_chip.dart';
import 'package:vakif_atlas/shared/widgets/molecules/inline_message.dart';
import 'package:vakif_atlas/shared/widgets/organisms/monument_card.dart';

/// Haritanın altında, seçilen eserin özet bilgisi ve detay geçişi.
class MonumentPreviewPanel extends StatelessWidget {
  const MonumentPreviewPanel({
    required this.monument,
    required this.onClose,
    required this.onViewDetails,
    this.onOpenComplex,
    this.action,
    super.key,
  });

  /// Kapat butonunun yanındaki eser bağlamlı eylem (kaydet).
  final Widget? action;

  /// Külliye üyesinde "Külliyeyi gör" (bağlı olduğu külliyenin kimliğiyle).
  final ValueChanged<String>? onOpenComplex;

  /// Önizleme eser detayından üretilir (önbellekli; detay sayfası aynı
  /// kaydı kullanır).
  final MonumentDetail monument;
  final VoidCallback onClose;
  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final location = l10n.monumentLocation(monument.district, monument.city);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.md,
      ),
      // Yükseklik içeriğe göre; panelin üst sınırı sayfada belirlenir.
      child: Center(
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
          child: MonumentCard(
            key: const Key('monument_preview_card'),
            name: monument.name,
            locationLabel: location,
            locationSemanticsLabel: l10n.monumentLocationSemantics(location),
            description: monument.shortDescription,
            tags: [
              monument.category.chip(l10n),
              monument.period.chip(l10n),
              if (monument.memberCount case final count?)
                InfoChip(
                  icon: Icons.apartment_outlined,
                  label: l10n.complexMemberCount(count),
                  semanticsLabel: l10n.complexMemberCount(count),
                ),
              if (monument.complex case final complex?)
                InfoChip(
                  icon: Icons.account_balance_outlined,
                  label: complex.name,
                  semanticsLabel: l10n.complexPartOf(complex.name),
                ),
            ],
            address: monument.address,
            addressSemanticsLabel: l10n.monumentAddressSemantics(
              monument.address,
            ),
            thumbnailUrl: monument.images.firstOrNull?.thumbnailUrl,
            scrollableBody: true,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ?action,
                IconButton(
                  key: const Key('monument_preview_close_button'),
                  tooltip: l10n.monumentPreviewClose,
                  icon: const Icon(Icons.close),
                  onPressed: onClose,
                ),
              ],
            ),
            action: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppButton.primary(
                  key: const Key('monument_preview_details_button'),
                  label: monument.isComplex
                      ? l10n.complexOpen
                      : l10n.monumentViewDetails,
                  semanticsLabel: monument.isComplex
                      ? l10n.complexOpenSemantics(monument.name)
                      : l10n.monumentViewDetailsSemantics(monument.name),
                  icon: Icons.arrow_forward,
                  expand: true,
                  onPressed: onViewDetails,
                ),
                if ((monument.complex, onOpenComplex) case (
                  final complex?,
                  final open?,
                )) ...[
                  const SizedBox(height: AppSpacing.xs),
                  AppButton.secondary(
                    key: const Key('monument_preview_complex_button'),
                    label: l10n.complexOpen,
                    semanticsLabel: l10n.complexOpenSemantics(complex.name),
                    icon: Icons.account_balance_outlined,
                    expand: true,
                    onPressed: () => open(complex.id),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Önizleme yüklenirken veya yüklenemediğinde gösterilen kart; seçili eserin
/// adı (pin kaydından) hemen görünür.
class MonumentPreviewStatus extends StatelessWidget {
  const MonumentPreviewStatus({
    required this.name,
    required this.failure,
    required this.onRetry,
    required this.onClose,
    super.key,
  });

  final String? name;

  /// `null` → yükleniyor.
  final Failure? failure;
  final VoidCallback onRetry;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final failure = this.failure;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: Center(
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
          child: DecoratedBox(
            key: const Key('monument_preview_status'),
            decoration: BoxDecoration(
              color: colors.surfaceElevated,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: colors.outlineVariant,
                width: AppSizes.borderThin,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppText(
                          name ?? l10n.mapPreviewLoading,
                          role: AppTextRole.titleLarge,
                          isHeading: true,
                        ),
                      ),
                      IconButton(
                        key: const Key('monument_preview_close_button'),
                        tooltip: l10n.monumentPreviewClose,
                        icon: const Icon(Icons.close),
                        onPressed: onClose,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  if (failure == null)
                    Semantics(
                      label: l10n.mapPreviewLoading,
                      liveRegion: true,
                      excludeSemantics: true,
                      child: const LinearProgressIndicator(
                        minHeight: AppSizes.borderThick,
                      ),
                    )
                  else ...[
                    InlineMessage(
                      message:
                          '${l10n.mapPreviewLoadFailed} '
                          '${failure.toUserMessage(l10n)}',
                      type: InlineMessageType.error,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppButton.secondary(
                      key: const Key('monument_preview_retry'),
                      label: l10n.commonRetry,
                      icon: Icons.refresh,
                      onPressed: onRetry,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
