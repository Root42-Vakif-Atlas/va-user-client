import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/map/map_tile_source.dart';
import 'package:vakif_atlas/core/theme/app_theme.dart';
import 'package:vakif_atlas/shared/widgets/organisms/app_map.dart';

import '../../../helpers/map_test_utils.dart';

/// Yüklenmesi hemen hata veren karo (ör. OSM 429 / zaman aşımı).
class _FailingImage extends ImageProvider<_FailingImage> {
  const _FailingImage(this.url);

  final String url;

  @override
  Future<_FailingImage> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture(this);

  @override
  ImageStreamCompleter loadImage(
    _FailingImage key,
    ImageDecoderCallback decode,
  ) => OneFrameImageStreamCompleter(
    Future<ImageInfo>.error(Exception('429 Too Many Requests')),
  );

  @override
  bool operator ==(Object other) => other is _FailingImage && other.url == url;

  @override
  int get hashCode => url.hashCode;
}

/// İlk istekte hata veren, sonra boş karo döndüren sağlayıcı.
class _FlakyTileProvider extends TileProvider {
  _FlakyTileProvider(this.calls);

  final Map<String, int> calls;

  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) {
    final url = getTileUrl(coordinates, options);
    final count = calls[url] = (calls[url] ?? 0) + 1;
    return count == 1
        ? _FailingImage(url)
        : BlankTileProvider().getImage(coordinates, options);
  }
}

void main() {
  Future<void> pumpMap(
    WidgetTester tester, {
    required MapTileSource source,
    ValueChanged<MapCamera>? onCameraIdle,
  }) async {
    await tester.pumpWidget(
      RepositoryProvider<MapTileSource>.value(
        value: source,
        child: MaterialApp(
          theme: AppTheme.light(),
          locale: const Locale('tr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: AppMap(semanticsLabel: 'Harita', onCameraIdle: onCameraIdle),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('başarısız altlık karosu kısa süre sonra kendiliğinden yeniden '
      'istenir (gri kalmaz)', (tester) async {
    final calls = <String, int>{};
    await pumpMap(
      tester,
      source: MapTileSource(
        config: testMapTileConfig,
        userAgentPackageName: 'tr.gov.vgm.vakif_atlas.test',
        providerFactory: () => _FlakyTileProvider(calls),
        tileFetcher: (_) async => null,
      ),
    );
    expect(calls, isNotEmpty);
    expect(calls.values, everyElement(1));

    await tester.pump(AppMap.tileRetryDelay + const Duration(milliseconds: 50));

    expect(calls.values, everyElement(greaterThanOrEqualTo(2)));
  });

  testWidgets('kamerayı değiştirmeyen olay (dokunma) yeniden yükleme '
      'istemez', (tester) async {
    var idle = 0;
    await pumpMap(
      tester,
      source: testMapTileSource(),
      onCameraIdle: (_) => idle++,
    );
    await tester.pump(AppMap.cameraIdleDelay * 2);
    expect(idle, 1);

    await tester.tapAt(tester.getCenter(find.byType(FlutterMap)));
    await tester.pump(AppMap.cameraIdleDelay * 2);
    expect(idle, 1);

    // Gerçek kaydırma yine yükleme ister.
    await tester.drag(find.byType(FlutterMap), const Offset(-120, 0));
    await tester.pump(AppMap.cameraIdleDelay * 2);
    expect(idle, 2);
  });
}
