import 'package:flutter/material.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';

/// Başlıklı, tek seçimli ayar grubu.
///
/// Her seçenek tam genişlikte, en az 48 dp yüksekliğinde dokunma alanına
/// sahiptir; ekran okuyucu grup adını ve seçili durumu okur.
class SettingsRadioGroup<T> extends StatelessWidget {
  const SettingsRadioGroup({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    required this.keyPrefix,
    this.description,
    super.key,
  });

  final String label;
  final String? description;
  final T value;

  /// `(değer, görünen etiket)` çiftleri.
  final List<(T, String)> options;
  final ValueChanged<T> onChanged;

  /// Entegrasyon testleri için seçenek anahtarlarının öneki.
  final String keyPrefix;

  @override
  Widget build(BuildContext context) {
    final details = description;

    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: AppText(label, role: AppTextRole.titleMedium),
            subtitle: details == null
                ? null
                : AppText(details, role: AppTextRole.bodyMedium),
          ),
          RadioGroup<T>(
            groupValue: value,
            onChanged: (selected) {
              if (selected != null) {
                onChanged(selected);
              }
            },
            child: Column(
              children: [
                for (final (option, optionLabel) in options)
                  RadioListTile<T>(
                    key: Key('${keyPrefix}_$option'),
                    value: option,
                    title: Text(optionLabel),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
