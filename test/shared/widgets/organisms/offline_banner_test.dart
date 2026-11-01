import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/shared/widgets/organisms/offline_banner.dart';

import '../../../helpers/network_test_utils.dart';
import '../../../helpers/pump_app.dart';

void main() {
  testWidgets('çevrimdışı şerit görünür, duyurulur; alt ağaç korunur', (
    tester,
  ) async {
    final network = FakeNetworkStatus();
    final announcements = <(String, bool)>[];
    final childKey = GlobalKey();
    await tester.pumpApp(
      OfflineBanner(
        network: network,
        onAnnounce: (message, {required offline}) =>
            announcements.add((message, offline)),
        child: StatefulBuilder(
          key: childKey,
          builder: (_, _) => const Text('içerik'),
        ),
      ),
    );
    expect(find.byKey(const Key('offline_banner')), findsNothing);
    final childState = childKey.currentState;

    // Yayın akışı olayı bir sonraki mikro görevde iletir.
    network.online = false;
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('offline_banner')), findsOneWidget);
    expect(find.textContaining('Çevrimdışısınız'), findsOneWidget);
    expect(find.byIcon(Icons.cloud_off_outlined), findsOneWidget);
    expect(announcements.single.$2, isTrue);
    expect(childKey.currentState, same(childState));

    network.online = true;
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('offline_banner')), findsNothing);
    expect(announcements.last, ('İnternet bağlantısı yeniden kuruldu.', false));
    expect(childKey.currentState, same(childState));

    await network.dispose();
  });
}
