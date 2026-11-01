import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';

import '../../../helpers/pump_app.dart';

Widget _localized(ThemeData theme, Widget child) {
  return Theme(
    data: theme,
    child: Localizations(
      locale: const Locale('tr'),
      delegates: AppLocalizations.localizationsDelegates,
      child: ColoredBox(
        color: theme.colorScheme.surface,
        child: Padding(padding: const EdgeInsets.all(16), child: child),
      ),
    ),
  );
}

Widget _variants() {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppButton.primary(label: 'Rotaya ekle', onPressed: () {}),
      const SizedBox(height: 8),
      AppButton.secondary(label: 'Geri', onPressed: () {}),
      const SizedBox(height: 8),
      AppButton.ghost(label: 'Daha fazla', onPressed: () {}),
      const SizedBox(height: 8),
      AppButton.destructive(label: 'Sil', onPressed: () {}),
      const SizedBox(height: 8),
      const AppButton.primary(label: 'Devre dışı', onPressed: null),
    ],
  );
}

void main() {
  for (final MapEntry(key: name, value: theme) in testThemes.entries) {
    goldenTest(
      'AppButton varyantları — $name',
      fileName: 'app_button_$name',
      builder: () => GoldenTestGroup(
        columns: 2,
        children: [
          GoldenTestScenario(
            name: 'compact (390)',
            constraints: const BoxConstraints(maxWidth: 390),
            child: _localized(theme, _variants()),
          ),
          GoldenTestScenario.withTextScaleFactor(
            name: 'textScale 2.0x',
            textScaler: const TextScaler.linear(2),
            constraints: const BoxConstraints(maxWidth: 390),
            child: _localized(theme, _variants()),
          ),
        ],
      ),
    );
  }
}
