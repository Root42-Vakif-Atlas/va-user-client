import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/shared/widgets/templates/status_message_view.dart';

/// Henüz yayınlanmamış bir modülün sayfası.
///
/// Rota, yetkilendirme ve derin bağlantı altyapısı hazırken modül içeriği
/// sonraki fazda eklenir; kullanıcıya bu durum yerelleştirilmiş ve
/// erişilebilir biçimde bildirilir.
class FeaturePendingPage extends StatelessWidget {
  const FeaturePendingPage({
    required this.title,
    required this.icon,
    this.actions = const [],
    super.key,
  });

  /// Ekran başlığı ve mesajda kullanılan modül adı.
  final String title;
  final IconData icon;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: actions),
      body: StatusMessageView(
        icon: icon,
        title: l10n.featurePendingHeading,
        message: l10n.featurePendingBody(title),
      ),
    );
  }
}
