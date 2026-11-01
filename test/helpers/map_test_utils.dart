import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:vakif_atlas/core/config/map_tile_config.dart';
import 'package:vakif_atlas/core/map/map_tile_source.dart';

/// 1×1 saydam PNG (Pillow ile üretilip doğrulandı).
final Uint8List _transparentPng = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR4nGNgYGBgAAAABQABpfZFQAAAAABJRU5ErkJggg==',
);

/// Ağa çıkmadan saydam tile döndüren sağlayıcı; istenen URL'leri kaydeder.
class BlankTileProvider extends TileProvider {
  BlankTileProvider([this.requestedUrls]);

  final List<String>? requestedUrls;

  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) {
    requestedUrls?.add(getTileUrl(coordinates, options));
    return MemoryImage(_transparentPng);
  }
}

/// Testlerde kullanılan, ağa hiç çıkılmayan örnek altlık.
const MapTileConfig testMapTileConfig = MapTileConfig(
  lightUrlTemplate: 'https://tiles.example.org/{z}/{x}/{y}.png',
  attribution: '© OpenStreetMap contributors',
);

/// Testlerde ağa çıkmayan harita altlığı kaynağı.
MapTileSource testMapTileSource({
  List<String>? requestedUrls,
  MapTileConfig config = testMapTileConfig,
}) {
  return MapTileSource(
    config: config,
    userAgentPackageName: 'tr.gov.vgm.vakif_atlas.test',
    providerFactory: () => BlankTileProvider(requestedUrls),
  );
}
