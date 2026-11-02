import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas/core/a11y/haptic_feedback_service.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/features/accessibility/presentation/accessibility_presentation.dart';
import 'package:vakif_atlas/features/accessibility/presentation/widgets/accessibility_tile.dart';
import 'package:vakif_atlas/features/settings/domain/entities/accessibility_preferences.dart';
import 'package:vakif_atlas/features/settings/presentation/cubit/app_settings_cubit.dart';
import 'package:vakif_atlas/features/settings/presentation/cubit/app_settings_state.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';
import 'package:vakif_atlas/shared/widgets/molecules/app_snack_bar.dart';

/// Erişilebilirlik paneli (`/accessibility`): uygulama genelindeki
/// erişilebilirlik tercihlerinin tek yapılandırma noktası.
///
/// Her kutucuk bir [AccessibilityFeature]'dır; dokunuş bir sonraki seviyeye
/// geçer (son seviyeden sonra kapanır), yeni durum duyurulur. Değişiklik
/// `AppSettingsCubit` (kök) üzerinden anında tüm uygulamaya uygulanır.
/// Haritadaki Erişilebilirlik butonu, Ayarlar ve tanıtım bu sayfayı açar (tanıtım sırasında da açılabilir). "Varsayılanlara dön" tema
/// ve dili korur, geri alınabilir.
///
/// "Büyük İmleç" yalnızca fare bağlı cihazda (veya açıkken) gösterilir.
class AccessibilityPage extends StatefulWidget {
  const AccessibilityPage({super.key});

  /// Kutucuk genişliği alt sınırı (metin ölçeğiyle ve geniş harf aralığıyla
  /// büyür): uzun tek kelimeler ("Yakınlaştırma") satır ortasında bölünmez.
  static const double minTileWidth = 108;

  /// Geniş harf / kelime aralığı (Kolay Okuma, Disleksi Dostu) açıkken.
  static const double wideSpacingFactor = 1.35;

  @override
  State<AccessibilityPage> createState() => _AccessibilityPageState();
}

class _AccessibilityPageState extends State<AccessibilityPage>
    with WidgetsBindingObserver {
  final MouseTracker _mouse = RendererBinding.instance.mouseTracker;

  /// Cihazın "hareketi azalt" ayarı (kökteki `MediaQuery` uygulama içi
  /// tercihle OR'landığından burada platformdan okunur). Sayfa açıkken
  /// ayar değişirse kutucuk kilidi güncellenir.
  late bool _systemReducesMotion = _readSystemReducesMotion();

  static bool _readSystemReducesMotion() => WidgetsBinding
      .instance
      .platformDispatcher
      .accessibilityFeatures
      .disableAnimations;

  @override
  void initState() {
    super.initState();
    _mouse.addListener(_onMouseChanged);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _mouse.removeListener(_onMouseChanged);
    super.dispose();
  }

  @override
  void didChangeAccessibilityFeatures() {
    final value = _readSystemReducesMotion();
    if (mounted && value != _systemReducesMotion) {
      setState(() => _systemReducesMotion = value);
    }
  }

  void _onMouseChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _cycle(AccessibilityFeature feature) async {
    final l10n = context.l10n;
    final cubit = context.read<AppSettingsCubit>();
    final announcer = context.read<A11yAnnouncer>();
    final haptics = context.read<HapticFeedbackService>();
    await cubit.cycleAccessibility(feature);
    // Titreşim kutucuğu kapatıldıysa son bir titreşim verilmez: servis,
    // durumla eşitlendikten sonra çağrılır.
    unawaited(haptics.selection());
    final level = cubit.state.settings.accessibility.level(feature);
    unawaited(
      announcer.announce(
        l10n.a11yTileState(
          feature.label(l10n),
          feature.levelLabel(l10n, level),
        ),
      ),
    );
  }

  Future<void> _reset() async {
    final l10n = context.l10n;
    final cubit = context.read<AppSettingsCubit>();
    final announcer = context.read<A11yAnnouncer>();
    final previous = await cubit.resetAccessibility();
    if (!mounted) {
      return;
    }
    AppSnackBar.show(
      context,
      key: const Key('accessibility_reset_snackbar'),
      message: l10n.accessibilityResetDone,
      action: SnackBarAction(
        label: l10n.commonUndo,
        onPressed: () => unawaited(cubit.restoreAccessibility(previous)),
      ),
    );
    unawaited(announcer.announce(l10n.accessibilityResetDone));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final preferences = context
        .select<AppSettingsCubit, AccessibilityPreferences>(
          (cubit) => cubit.state.settings.accessibility,
        );
    final features = [
      for (final feature in AccessibilityFeature.values)
        if (feature != AccessibilityFeature.bigCursor ||
            _mouse.mouseIsConnected ||
            preferences.isOn(feature))
          feature,
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.accessibilityTitle)),
      body: BlocListener<AppSettingsCubit, AppSettingsState>(
        listenWhen: (previous, current) =>
            current.saveFailure != null &&
            previous.saveFailure != current.saveFailure,
        listener: (context, state) =>
            AppSnackBar.show(context, message: l10n.settingsSaveFailed),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSizes.maxContentWidth,
              ),
              child: ListView(
                key: const Key('accessibility_list'),
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  AppText(
                    l10n.accessibilityIntro,
                    color: context.colors.onSurfaceVariant,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _TileGrid(
                    features: features,
                    preferences: preferences,
                    systemReducesMotion: _systemReducesMotion,
                    onTap: (feature) => unawaited(_cycle(feature)),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppText(
                    l10n.accessibilityDeviceNote,
                    role: AppTextRole.bodyMedium,
                    color: context.colors.onSurfaceVariant,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppButton.secondary(
                    key: const Key('accessibility_reset_button'),
                    label: l10n.accessibilityReset,
                    icon: Icons.restart_alt,
                    expand: true,
                    onPressed: preferences.isDefault
                        ? null
                        : () => unawaited(_reset()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Satır satır eşit yükseklikte kutucuklar: sütun sayısı genişlik ve metin
/// ölçeğine göre belirlenir (%200 metinde taşma olmaz).
class _TileGrid extends StatelessWidget {
  const _TileGrid({
    required this.features,
    required this.preferences,
    required this.systemReducesMotion,
    required this.onTap,
  });

  final List<AccessibilityFeature> features;
  final AccessibilityPreferences preferences;

  /// Cihazda "hareketi azalt" açıksa "Animasyonları Durdur" kilitli açıktır.
  final bool systemReducesMotion;
  final ValueChanged<AccessibilityFeature> onTap;

  @override
  Widget build(BuildContext context) {
    final scale =
        MediaQuery.textScalerOf(context).scale(1) *
        (preferences.wideTextSpacing ? AccessibilityPage.wideSpacingFactor : 1);
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns =
            (constraints.maxWidth / (AccessibilityPage.minTileWidth * scale))
                .floor()
                .clamp(1, 4);
        final rows = <Widget>[];
        for (var start = 0; start < features.length; start += columns) {
          final row = features.skip(start).take(columns).toList();
          rows.add(
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var index = 0; index < columns; index++) ...[
                    if (index > 0) const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: index < row.length
                          ? AccessibilityTile(
                              feature: row[index],
                              level: preferences.level(row[index]),
                              onTap: () => onTap(row[index]),
                              lockedState:
                                  row[index] ==
                                          AccessibilityFeature.stopAnimations &&
                                      systemReducesMotion
                                  ? context.l10n.settingsReduceMotionSystemOn
                                  : null,
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ],
              ),
            ),
          );
        }
        return Column(
          children: [
            for (var index = 0; index < rows.length; index++) ...[
              if (index > 0) const SizedBox(height: AppSpacing.xs),
              rows[index],
            ],
          ],
        );
      },
    );
  }
}
