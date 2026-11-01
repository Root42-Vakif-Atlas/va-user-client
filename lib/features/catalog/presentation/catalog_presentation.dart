import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/geo_point.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_classification.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_image.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_summary.dart';
import 'package:vakif_atlas/shared/widgets/molecules/info_chip.dart';
import 'package:vakif_atlas/shared/widgets/organisms/gallery_photo.dart';

/// Katalog varlıklarının arayüz karşılıkları (etiket, ikon, harita noktası).
///
/// Harita Keşfi, Eser Detayı ve ileride Rota Planlayıcı aynı eşlemeleri
/// kullanır.
extension MonumentCategoryPresentation on MonumentCategory {
  String label(AppLocalizations l10n) => switch (this) {
    MonumentCategory.mosque => l10n.monumentCategoryMosque,
    MonumentCategory.complex => l10n.monumentCategoryComplex,
    MonumentCategory.madrasa => l10n.monumentCategoryMadrasa,
    MonumentCategory.inn => l10n.monumentCategoryInn,
    MonumentCategory.caravanserai => l10n.monumentCategoryCaravanserai,
    MonumentCategory.bath => l10n.monumentCategoryBath,
    MonumentCategory.fountain => l10n.monumentCategoryFountain,
    MonumentCategory.tomb => l10n.monumentCategoryTomb,
    MonumentCategory.hospital => l10n.monumentCategoryHospital,
    MonumentCategory.imaret => l10n.monumentCategoryImaret,
    MonumentCategory.other => l10n.monumentCategoryOther,
  };

  IconData get icon => switch (this) {
    MonumentCategory.mosque => Icons.mosque_outlined,
    MonumentCategory.complex => Icons.account_balance_outlined,
    MonumentCategory.madrasa => Icons.menu_book_outlined,
    MonumentCategory.inn => Icons.storefront_outlined,
    MonumentCategory.caravanserai => Icons.fort_outlined,
    MonumentCategory.bath => Icons.hot_tub_outlined,
    MonumentCategory.fountain => Icons.water_drop_outlined,
    MonumentCategory.tomb => Icons.hexagon_outlined,
    MonumentCategory.hospital => Icons.local_hospital_outlined,
    MonumentCategory.imaret => Icons.soup_kitchen_outlined,
    MonumentCategory.other => Icons.place_outlined,
  };

  InfoChip chip(AppLocalizations l10n) => InfoChip(
    icon: icon,
    label: label(l10n),
    semanticsLabel: l10n.monumentCategorySemantics(label(l10n)),
  );
}

/// Liste satırının alt başlığı: konum · tür, külliyede yapı sayısı, üyede
/// bağlı olduğu külliye.
extension MonumentSummaryPresentation on MonumentSummary {
  String listSubtitle(AppLocalizations l10n) {
    final location = l10n.monumentLocation(district, city);
    if (memberCount case final count?) {
      return l10n.complexListItemSubtitle(
        location,
        l10n.complexMemberCount(count),
      );
    }
    if (complex case final complex?) {
      return l10n.monumentListItemMemberSubtitle(
        location,
        category.label(l10n),
        complex.name,
      );
    }
    return l10n.monumentListItemSubtitle(location, category.label(l10n));
  }
}

extension HistoricalPeriodPresentation on HistoricalPeriod {
  String label(AppLocalizations l10n) => switch (this) {
    HistoricalPeriod.seljuk => l10n.historicalPeriodSeljuk,
    HistoricalPeriod.beylik => l10n.historicalPeriodBeylik,
    HistoricalPeriod.ottoman => l10n.historicalPeriodOttoman,
    HistoricalPeriod.other => l10n.historicalPeriodOther,
  };

  InfoChip chip(AppLocalizations l10n) => InfoChip(
    icon: Icons.history_edu_outlined,
    label: label(l10n),
    semanticsLabel: l10n.monumentPeriodSemantics(label(l10n)),
  );
}

extension GeoPointPresentation on GeoPoint {
  LatLng toLatLng() => LatLng(latitude, longitude);
}

extension MonumentImagePresentation on MonumentImage {
  GalleryPhoto toGalleryPhoto(AppLocalizations l10n, {required int index}) =>
      GalleryPhoto(
        url: url,
        thumbnailUrl: thumbnailUrl,
        description: altText,
        credit: l10n.photoCredit(author, license, sourceName),
        creditSemanticsLabel: l10n.photoCreditSemantics(
          index,
          author,
          license,
          sourceName,
        ),
      );
}
