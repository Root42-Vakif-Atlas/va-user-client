import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vakif_atlas/core/config/app_config.dart';
import 'package:vakif_atlas/core/map/map_tile_source.dart';
import 'package:vakif_atlas/core/observability/app_logger.dart';

/// Harita altyapısının DI kayıtları.
@module
abstract class MapModule {
  @lazySingleton
  MapTileSource mapTileSource(
    AppConfig config,
    PackageInfo packageInfo,
    AppLogger logger,
  ) => MapTileSource(
    config: config.mapTiles,
    userAgentPackageName: packageInfo.packageName,
    logger: logger,
  );
}
