import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/theme/app_theme.dart';

/// Testlerde kullanılan tema varyantları.
final Map<String, ThemeData> testThemes = {
  'dark': AppTheme.dark(),
  'light': AppTheme.light(),
  'highContrastDark': AppTheme.highContrastDark(),
  'highContrastLight': AppTheme.highContrastLight(),
};

extension PumpApp on WidgetTester {
  /// [child] widget'ını tema, yerelleştirme ve metin ölçeğiyle çizer.
  Future<void> pumpApp(
    Widget child, {
    ThemeData? theme,
    double textScale = 1,
    Locale locale = const Locale('tr'),
    bool disableAnimations = false,
    Size? surfaceSize,
  }) async {
    if (surfaceSize != null) {
      view.physicalSize = surfaceSize * view.devicePixelRatio;
      addTearDown(view.resetPhysicalSize);
    }
    await pumpWidget(
      MaterialApp(
        theme: theme ?? AppTheme.dark(),
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, app) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(textScale),
            disableAnimations: disableAnimations,
          ),
          child: app!,
        ),
        home: Scaffold(body: child),
      ),
    );
  }
}
