import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:vakif_atlas/core/map/map_tile_source.dart';
import 'package:vakif_atlas/core/theme/brand_emblem_shape.dart';
import 'package:vakif_atlas/core/theme/tokens/app_colors.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/geo_point.dart';
import 'package:vakif_atlas/features/route_export/data/render/route_basemap.dart';
import 'package:vakif_atlas/features/route_export/domain/entities/route_document.dart';

/// PDF'te kullanılan yazı tipleri (Inter'in statik örnekleri; `pdf` paketi
/// değişken yazı tipi ağırlığı seçemez). OFL lisanslıdır, gömülmesine izin
/// verilir; yalnızca kullanılan glifler gömülür.
final class RoutePdfFonts {
  const RoutePdfFonts({required this.regular, required this.semiBold});

  final ByteData regular;
  final ByteData semiBold;

  static const String regularAsset =
      'assets/fonts/inter/static/Inter-Regular.ttf';
  static const String semiBoldAsset =
      'assets/fonts/inter/static/Inter-SemiBold.ttf';

  static Future<RoutePdfFonts> load() async => RoutePdfFonts(
    regular: await rootBundle.load(regularAsset),
    semiBold: await rootBundle.load(semiBoldAsset),
  );
}

/// [RouteDocument]'i yazdırılabilir A4 PDF'e dönüştürür.
///
/// - Metin gerçek metindir (seçilebilir, aranabilir, ekran okuyucuyla
///   okunabilir); en küçük punto 9, gövde 10,5.
/// - Bilgi yalnızca renkle verilmez; gri tonda yazdırıldığında da okunur.
/// - Rota haritası: uygulama haritasının altlığı ([RouteBasemapRenderer],
///   soluklaştırılmış) üzerinde vektör rota çizgisi ve numaralı duraklar
///   (yazdırmada keskin kalır). Altlık alınamazsa (çevrimdışı) yalnızca
///   vektör çizim kalır. Altlık atfı haritanın üzerinde, yol verisi atfı
///   (ODbL) her sayfanın altındadır.
/// - Başlıklar PDF ana hattına (yer imleri) eklenir; belge başlığı ve
///   yazarı meta veride yer alır.
@lazySingleton
class RoutePdfRenderer {
  RoutePdfRenderer(RouteBasemapRenderer basemap)
    : this.withFonts(RoutePdfFonts.load, basemap: basemap);

  /// `basemap` yoksa harita altlıksız vektör çizimdir.
  RoutePdfRenderer.withFonts(this._loadFonts, {this._basemap});

  final Future<RoutePdfFonts> Function() _loadFonts;
  final RouteBasemapRenderer? _basemap;
  Future<RoutePdfFonts>? _fonts;

  /// Çizimdeki en fazla nokta; uzun karayolu geometrisi seyreltilir.
  static const int maxSketchPoints = 1200;

  static const pw.EdgeInsets _margin = pw.EdgeInsets.fromLTRB(48, 40, 48, 36);
  static const double _sketchHeight = 260;
  static const double _sketchPadding = 28;
  static const double _markerSize = 16;

  static final PdfColor _ink = PdfColor.fromInt(AppColors.green10.toARGB32());
  static final PdfColor _primary = PdfColor.fromInt(
    AppColors.green30.toARGB32(),
  );
  static final PdfColor _muted = PdfColor.fromInt(
    AppColors.neutralVariant30.toARGB32(),
  );
  static final PdfColor _rule = PdfColor.fromInt(
    AppColors.neutralVariant80.toARGB32(),
  );
  static final PdfColor _panel = PdfColor.fromInt(
    AppColors.neutral96.toARGB32(),
  );
  static final PdfColor _accent = PdfColor.fromInt(
    AppColors.antiqueGold.toARGB32(),
  );
  static final PdfColor _paper = PdfColor.fromInt(AppColors.white.toARGB32());

  Future<Uint8List> render(RouteDocument document) async {
    final fonts = await (_fonts ??= _loadFonts());
    final sketch = _SketchGeometry.of(document);
    final basemap = await _basemap?.render(
      sketch.fit.window,
      widthPt: _sketchWidth,
      heightPt: _sketchHeight,
    );
    final theme = pw.ThemeData.withFont(
      base: pw.Font.ttf(fonts.regular),
      bold: pw.Font.ttf(fonts.semiBold),
    ).copyWith(defaultTextStyle: pw.TextStyle(fontSize: 10.5, color: _ink));
    final labels = document.labels;
    final pdf = pw.Document(
      title: document.title,
      author: labels.brand,
      creator: labels.brand,
      producer: labels.brand,
      subject: document.subtitle,
      keywords: document.stops.map((stop) => stop.name).join(', '),
      theme: theme,
    );

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: _margin,
          theme: theme,
        ),
        header: (context) => _header(labels),
        footer: (context) => _footer(labels, context),
        build: (context) => [
          pw.Header(
            level: 0,
            title: document.title,
            decoration: const pw.BoxDecoration(),
            padding: pw.EdgeInsets.zero,
            margin: const pw.EdgeInsets.only(bottom: 4),
            child: pw.Text(
              document.title,
              style: pw.TextStyle(
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
                color: _ink,
              ),
            ),
          ),
          pw.Text(
            document.subtitle,
            style: pw.TextStyle(fontSize: 11, color: _muted),
          ),
          pw.SizedBox(height: 18),
          _sectionHeading(labels.summaryHeading),
          _facts(document.facts),
          pw.SizedBox(height: 18),
          _sectionHeading(labels.sketchHeading),
          _sketch(sketch, basemap),
          pw.SizedBox(height: 4),
          pw.Text(
            labels.sketchCaption,
            style: pw.TextStyle(fontSize: 9, color: _muted),
          ),
          pw.SizedBox(height: 18),
          _sectionHeading(labels.stopsHeading),
          for (final (index, stop) in document.stops.indexed)
            _stop(index + 1, stop, labels),
          pw.SizedBox(height: 12),
          pw.Text(
            labels.disclaimer,
            style: pw.TextStyle(fontSize: 9, color: _muted),
          ),
        ],
      ),
    );
    return pdf.save();
  }

  pw.Widget _header(RouteDocumentLabels labels) => pw.Container(
    margin: const pw.EdgeInsets.only(bottom: 16),
    padding: const pw.EdgeInsets.only(bottom: 8),
    decoration: pw.BoxDecoration(
      border: pw.Border(bottom: pw.BorderSide(color: _accent, width: 0.8)),
    ),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        // Logo kutunun ortasındaki ~%52'lik alanı kaplar (simgedeki gibi
        // iç boşluklu); görünen yüksekliği ≈ 15 pt.
        pw.SizedBox(
          width: 22,
          height: 22,
          child: pw.CustomPaint(painter: _paintEmblem),
        ),
        pw.SizedBox(width: 2),
        pw.Text(
          labels.brand.toUpperCase(),
          style: pw.TextStyle(
            fontSize: 10,
            fontWeight: pw.FontWeight.bold,
            letterSpacing: 1.6,
            color: _primary,
          ),
        ),
        pw.Spacer(),
        pw.Text(
          labels.generatedOn,
          style: pw.TextStyle(fontSize: 9, color: _muted),
        ),
      ],
    ),
  );

  pw.Widget _footer(RouteDocumentLabels labels, pw.Context context) =>
      pw.Container(
        margin: const pw.EdgeInsets.only(top: 12),
        padding: const pw.EdgeInsets.only(top: 6),
        decoration: pw.BoxDecoration(
          border: pw.Border(top: pw.BorderSide(color: _rule, width: 0.5)),
        ),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Text(
                labels.attribution,
                style: pw.TextStyle(fontSize: 9, color: _muted),
              ),
            ),
            pw.SizedBox(width: 12),
            pw.Text(
              labels.page(context.pageNumber, context.pagesCount),
              style: pw.TextStyle(fontSize: 9, color: _muted),
            ),
          ],
        ),
      );

  pw.Widget _sectionHeading(String text) => pw.Header(
    level: 1,
    title: text,
    decoration: const pw.BoxDecoration(),
    padding: pw.EdgeInsets.zero,
    margin: const pw.EdgeInsets.only(bottom: 8),
    child: pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: 13,
        fontWeight: pw.FontWeight.bold,
        color: _primary,
      ),
    ),
  );

  pw.Widget _facts(List<RouteDocumentFact> facts) => pw.Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      for (final fact in facts)
        pw.Container(
          width: 156,
          padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: pw.BoxDecoration(
            color: _panel,
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                fact.label,
                style: pw.TextStyle(fontSize: 9, color: _muted),
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                fact.value,
                style: pw.TextStyle(
                  fontSize: 13,
                  fontWeight: pw.FontWeight.bold,
                  color: _ink,
                ),
              ),
            ],
          ),
        ),
    ],
  );

  static double get _sketchWidth => PdfPageFormat.a4.width - _margin.horizontal;

  pw.Widget _sketch(_SketchGeometry sketch, RouteBasemap? basemap) {
    final width = _sketchWidth;
    return pw.Container(
      width: width,
      height: _sketchHeight,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _rule, width: 0.6),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.ClipRRect(
        horizontalRadius: 6,
        verticalRadius: 6,
        child: pw.Stack(
          children: [
            if (basemap != null)
              pw.Image(
                pw.MemoryImage(basemap.image),
                width: width,
                height: _sketchHeight,
                fit: pw.BoxFit.fill,
              ),
            pw.CustomPaint(
              size: PdfPoint(width, _sketchHeight),
              painter: (canvas, size) => _paintPath(
                canvas,
                sketch.path,
                sketch.fit,
                cased: basemap != null,
              ),
            ),
            // Numaralı işaretler aşağıdaki durak listesine karşılık gelir.
            for (final (index, stop) in sketch.stops.indexed)
              _marker(index + 1, sketch.fit.place(stop), isStart: index == 0),
            if (basemap != null)
              pw.Positioned(
                right: 0,
                bottom: 0,
                child: pw.Container(
                  color: _paper,
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 1,
                  ),
                  child: pw.Text(
                    basemap.attribution,
                    style: pw.TextStyle(fontSize: 9, color: _muted),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// PDF koordinatı (y yukarı) → yığın konumu (üstten).
  pw.Widget _marker(int number, PdfPoint point, {required bool isStart}) =>
      pw.Positioned(
        left: point.x - _markerSize / 2,
        top: _sketchHeight - point.y - _markerSize / 2,
        child: pw.Container(
          width: _markerSize,
          height: _markerSize,
          alignment: pw.Alignment.center,
          decoration: pw.BoxDecoration(
            shape: pw.BoxShape.circle,
            color: isStart ? _primary : _paper,
            border: pw.Border.all(color: _primary, width: 1.2),
          ),
          child: pw.Text(
            '$number',
            style: pw.TextStyle(
              fontSize: 8,
              fontWeight: pw.FontWeight.bold,
              color: isStart ? _paper : _primary,
            ),
          ),
        ),
      );

  pw.Widget _stop(
    int number,
    RouteDocumentStop stop,
    RouteDocumentLabels labels,
  ) {
    final leg = stop.nextLeg;
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: 22,
            height: 22,
            alignment: pw.Alignment.center,
            decoration: pw.BoxDecoration(
              shape: pw.BoxShape.circle,
              color: _paper,
              border: pw.Border.all(color: _primary, width: 1.2),
            ),
            child: pw.Text(
              '$number',
              style: pw.TextStyle(
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
                color: _primary,
              ),
            ),
          ),
          pw.SizedBox(width: 10),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  stop.name,
                  style: const pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(stop.place, style: pw.TextStyle(color: _muted)),
                pw.SizedBox(height: 3),
                for (final detail in stop.details) pw.Text(detail),
                pw.SizedBox(height: 2),
                pw.UrlLink(
                  destination: stop.mapUrl,
                  child: pw.Text(
                    labels.mapLink,
                    style: pw.TextStyle(
                      color: _primary,
                      decoration: pw.TextDecoration.underline,
                    ),
                  ),
                ),
                if (leg != null) ...[
                  pw.SizedBox(height: 6),
                  pw.Container(
                    padding: const pw.EdgeInsets.only(left: 8),
                    decoration: pw.BoxDecoration(
                      border: pw.Border(
                        left: pw.BorderSide(color: _accent, width: 1.5),
                      ),
                    ),
                    child: pw.Text(leg, style: pw.TextStyle(color: _muted)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Uzun geometriyi eşit aralıklı noktalara seyreltir (uçlar korunur).
  static List<GeoPoint> _thin(List<GeoPoint> points) {
    if (points.length <= maxSketchPoints) {
      return points;
    }
    final step = points.length / maxSketchPoints;
    return [
      for (var i = 0; i < maxSketchPoints; i++) points[(i * step).floor()],
      points.last,
    ];
  }

  /// Harita üzerinde çizgi beyaz kenarlıklıdır ([cased]): yollardan ve
  /// yazılardan ayrışır.
  void _paintPath(
    PdfGraphics canvas,
    List<GeoPoint> path,
    _SketchProjection fit, {
    required bool cased,
  }) {
    if (path.length < 2) {
      return;
    }
    void stroke(PdfColor color, double width) {
      final first = fit.place(path.first);
      canvas
        ..setStrokeColor(color)
        ..setLineWidth(width)
        ..setLineJoin(PdfLineJoin.round)
        ..setLineCap(PdfLineCap.round)
        ..moveTo(first.x, first.y);
      for (final point in path.skip(1)) {
        final p = fit.place(point);
        canvas.lineTo(p.x, p.y);
      }
      canvas.strokePath();
    }

    if (cased) {
      stroke(_paper, 4.5);
    }
    stroke(_primary, cased ? 2.4 : 2);
  }

  /// Uygulama amblemi ([BrandEmblemShape], birim kare; PDF'te y yukarı).
  void _paintEmblem(PdfGraphics canvas, PdfPoint size) {
    final unit = math.min(size.x, size.y);
    double x(double value) => value * unit;
    double y(double value) => size.y - value * unit;
    void contours(List<List<EmblemPathCommand>> shape, PdfColor color) {
      canvas.setFillColor(color);
      for (final contour in shape) {
        for (final command in contour) {
          switch (command) {
            case EmblemMoveTo(x: final px, y: final py):
              canvas.moveTo(x(px), y(py));
            case EmblemLineTo(x: final px, y: final py):
              canvas.lineTo(x(px), y(py));
            case EmblemCubicTo(:final x1, :final y1, :final x2, :final y2):
              canvas.curveTo(
                x(x1),
                y(y1),
                x(x2),
                y(y2),
                x(command.x),
                y(command.y),
              );
            case EmblemClose():
              canvas.closePath();
          }
        }
      }
      canvas.fillPath();
    }

    contours(BrandEmblemShape.frame, _primary);
    contours(BrandEmblemShape.accent, _accent);
  }
}

/// Çizimin noktaları ve izdüşümü (altlık penceresi de buradan gelir).
final class _SketchGeometry {
  const _SketchGeometry(this.stops, this.path, this.fit);

  factory _SketchGeometry.of(RouteDocument document) {
    final stops = [for (final stop in document.stops) stop.location];
    final path = RoutePdfRenderer._thin(
      document.path.isEmpty ? stops : document.path,
    );
    return _SketchGeometry(
      stops,
      path,
      _SketchProjection.fit(
        [...path, ...stops],
        width: RoutePdfRenderer._sketchWidth,
        height: RoutePdfRenderer._sketchHeight,
        padding: RoutePdfRenderer._sketchPadding,
      ),
    );
  }

  final List<GeoPoint> stops;
  final List<GeoPoint> path;
  final _SketchProjection fit;
}

/// Noktaları normalize Web Mercator'da (karo koordinatlarıyla aynı) kutuya
/// oranı koruyarak sığdırır; kuzey yukarıdadır (PDF'te y yukarı doğru
/// artar). Çok yakın duraklarda ölçek bir sokak görünümüyle sınırlanır.
final class _SketchProjection {
  const _SketchProjection._(
    this._minX,
    this._minY,
    this._scale,
    this._offsetX,
    this._offsetY,
    this._width,
    this._height,
  );

  factory _SketchProjection.fit(
    List<GeoPoint> points, {
    required double width,
    required double height,
    required double padding,
  }) {
    final projected = points.map(_project).toList();
    if (projected.isEmpty) {
      return _SketchProjection._(
        0.5,
        0.5,
        maxScale,
        width / 2,
        height / 2,
        width,
        height,
      );
    }
    final minX = projected.map((p) => p.x).reduce(math.min);
    final maxX = projected.map((p) => p.x).reduce(math.max);
    final minY = projected.map((p) => p.y).reduce(math.min);
    final maxY = projected.map((p) => p.y).reduce(math.max);
    final spanX = maxX - minX;
    final spanY = maxY - minY;
    final scale = math.min(
      maxScale,
      math.min(
        spanX == 0 ? double.infinity : (width - 2 * padding) / spanX,
        spanY == 0 ? double.infinity : (height - 2 * padding) / spanY,
      ),
    );
    return _SketchProjection._(
      minX,
      minY,
      scale,
      (width - spanX * scale) / 2,
      (height - spanY * scale) / 2,
      width,
      height,
    );
  }

  /// En yakın görünüm: yakınlaştırma 17'de karo pikseli başına
  /// [RouteBasemapRenderer.pixelsPerPoint]'in tersi kadar nokta.
  static const double maxScale =
      MapTileSource.tileSize * (1 << 17) / RouteBasemapRenderer.pixelsPerPoint;

  final double _minX;
  final double _minY;
  final double _scale;
  final double _offsetX;
  final double _offsetY;
  final double _width;
  final double _height;

  /// Kutunun tamamının kapsadığı alan (altlık bu pencereden üretilir).
  MercatorWindow get window {
    final left = _minX - _offsetX / _scale;
    final top = _minY - _offsetY / _scale;
    return MercatorWindow(
      left: left,
      top: top,
      right: left + _width / _scale,
      bottom: top + _height / _scale,
    );
  }

  PdfPoint place(GeoPoint point) {
    final p = _project(point);
    return PdfPoint(
      _offsetX + (p.x - _minX) * _scale,
      _height - (_offsetY + (p.y - _minY) * _scale),
    );
  }

  /// Normalize Web Mercator: x batıdan doğuya, y kuzeyden güneye 0…1.
  static math.Point<double> _project(GeoPoint point) {
    final latitude = point.latitude * math.pi / 180;
    return math.Point(
      (point.longitude + 180) / 360,
      (1 - math.log(math.tan(math.pi / 4 + latitude / 2)) / math.pi) / 2,
    );
  }
}
