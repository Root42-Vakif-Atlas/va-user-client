import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/theme/theme_context.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/shared/widgets/atoms/app_text.dart';

/// Yasal metin onayı: onay kutusu + metni okuma bağlantısı + hata mesajı.
///
/// Onay kutusu ve "metni oku" bağlantısı ayrı dokunma hedefleridir; iç içe
/// etkileşimli öğeler ekran okuyucu ve motor kısıtı olan kullanıcılar için
/// sorun yaratır.
class ConsentTile extends StatelessWidget {
  const ConsentTile({
    required this.value,
    required this.label,
    required this.readLabel,
    required this.onChanged,
    required this.onRead,
    required this.enabled,
    this.errorText,
    super.key,
  });

  final bool value;
  final String label;
  final String readLabel;
  final ValueChanged<bool> onChanged;
  final VoidCallback onRead;
  final bool enabled;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final error = errorText;
    final key = this.key;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListTile(
          key: key is ValueKey<String> ? Key('${key.value}_checkbox') : null,
          value: value,
          enabled: enabled,
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(label),
          onChanged: (checked) => onChanged(checked ?? false),
        ),
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.xxl),
          child: TextButton(
            key: key is ValueKey<String> ? Key('${key.value}_read') : null,
            onPressed: onRead,
            child: Text(readLabel),
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.xxl),
            child: Semantics(
              liveRegion: true,
              child: AppText(
                error,
                role: AppTextRole.bodySmall,
                color: context.colors.error,
              ),
            ),
          ),
      ],
    );
  }
}
