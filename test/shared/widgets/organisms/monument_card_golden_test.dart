import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_button.dart';
import 'package:vakif_atlas/shared/widgets/molecules/info_chip.dart';
import 'package:vakif_atlas/shared/widgets/organisms/map_pin.dart';
import 'package:vakif_atlas/shared/widgets/organisms/monument_card.dart';

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

/// Görseli olmayan kart (ağ görseli golden testinde deterministik değildir).
Widget _card() {
  return MonumentCard(
    name: 'Kızlarağası Hanı',
    locationLabel: 'Konak, İzmir',
    locationSemanticsLabel: 'Konum: Konak, İzmir',
    description:
        "Hacı Beşir Ağa'nın 1744'te yaptırdığı, Kemeraltı Çarşısı'nın "
        'kalbindeki iki katlı Osmanlı hanı.',
    tags: const [
      InfoChip(
        icon: Icons.storefront_outlined,
        label: 'Han',
        semanticsLabel: 'Yapı türü: Han',
      ),
      InfoChip(
        icon: Icons.history_edu_outlined,
        label: 'Osmanlı',
        semanticsLabel: 'Dönem: Osmanlı',
      ),
    ],
    address:
        'Konak Mahallesi, 871. Sokak, Kemeraltı Çarşısı, 35250 Konak/İzmir',
    trailing: IconButton(
      tooltip: 'Önizlemeyi kapat',
      icon: const Icon(Icons.close),
      onPressed: () {},
    ),
    action: AppButton.primary(
      label: 'Detayları gör',
      icon: Icons.arrow_forward,
      expand: true,
      onPressed: () {},
    ),
  );
}

Widget _pins() {
  return const Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      MapPin(icon: Icons.mosque_outlined, semanticsLabel: 'Cami'),
      MapPin(
        icon: Icons.fort_outlined,
        semanticsLabel: 'Kervansaray',
        selected: true,
      ),
    ],
  );
}

void main() {
  for (final MapEntry(key: name, value: theme) in testThemes.entries) {
    goldenTest(
      'MonumentCard ve MapPin — $name',
      fileName: 'monument_card_$name',
      builder: () => GoldenTestGroup(
        columns: 3,
        children: [
          GoldenTestScenario(
            name: 'compact (390)',
            constraints: const BoxConstraints(maxWidth: 390),
            child: _localized(theme, _card()),
          ),
          GoldenTestScenario.withTextScaleFactor(
            name: 'textScale 2.0x',
            textScaler: const TextScaler.linear(2),
            constraints: const BoxConstraints(maxWidth: 390),
            child: _localized(theme, _card()),
          ),
          GoldenTestScenario(
            name: 'pin (normal / seçili)',
            child: _localized(theme, _pins()),
          ),
        ],
      ),
    );
  }
}
