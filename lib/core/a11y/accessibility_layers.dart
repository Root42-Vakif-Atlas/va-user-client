import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas/core/a11y/voice_io_service.dart';
import 'package:vakif_atlas/core/theme/tokens/app_colors.dart';

/// Kökte tüm rotaların üzerine çizilen erişilebilirlik katmanları:
/// sesli okuma (dokunulan / odaktaki öğe), odak çerçevesi, okuma çizgisi /
/// maskesi ve büyük imleç.
///
/// Ağaç yapısı tercihler değişse de aynı kalır (her katman kapalıyken
/// yalnızca çocuğunu çizer); böylece açıp kapatmak gezinme yığınını ve sayfa
/// durumunu sıfırlamaz. Katmanlar dokunuşu tüketmez (`IgnorePointer`,
/// yarı saydam `Listener`).
class AccessibilityLayers extends StatelessWidget {
  const AccessibilityLayers({
    required this.child,
    this.readAloud = false,
    this.readOnFocus = false,
    this.focusHighlight = 0,
    this.readingGuide = 0,
    this.bigCursor = 0,
    super.key,
  });

  final bool readAloud;
  final bool readOnFocus;

  /// 0 kapalı; 1 – 3 çerçeve kalınlığı.
  final int focusHighlight;

  /// 0 kapalı; 1 ince çizgi, 2 kalın çizgi, 3 okuma maskesi.
  final int readingGuide;

  /// 0 kapalı; 1 büyük, 2 çok büyük.
  final int bigCursor;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _SpeechLayer(
      readAloud: readAloud,
      readOnFocus: readOnFocus,
      child: _FocusHighlightLayer(
        level: focusHighlight,
        child: _PointerOverlay(
          readingGuide: readingGuide,
          bigCursor: bigCursor,
          child: child,
        ),
      ),
    );
  }
}

// ── Sesli okuma ──────────────────────────────────────────────────────────

/// Semantik ağaçta [globalPosition]'daki en derin, etiketli düğümün metni.
///
/// Semantik ağaç fiziksel piksel koordinatındadır; kök düğümden başlayarak
/// her düğümün dönüşümü tersine uygulanır. Üstte çizilen (sonraki) kardeş
/// önce denenir.
String? semanticsTextAt(Offset globalPosition) {
  final view = WidgetsBinding.instance.renderViews.firstOrNull;
  final root = view?.owner?.semanticsOwner?.rootSemanticsNode;
  if (view == null || root == null) {
    return null;
  }
  final physical = globalPosition * view.flutterView.devicePixelRatio;

  SemanticsNode? hit(SemanticsNode node, Offset point) {
    var local = point;
    final transform = node.transform;
    if (transform != null) {
      final inverse = Matrix4.tryInvert(transform);
      if (inverse == null) {
        return null;
      }
      local = MatrixUtils.transformPoint(inverse, point);
    }
    if (!node.rect.contains(local) || node.isInvisible) {
      return null;
    }
    final children = <SemanticsNode>[];
    node.visitChildren((child) {
      children.add(child);
      return true;
    });
    for (final child in children.reversed) {
      final found = hit(child, local);
      if (found != null) {
        return found;
      }
    }
    final data = node.getSemanticsData();
    return data.label.isNotEmpty || data.value.isNotEmpty ? node : null;
  }

  final node = hit(root, physical);
  if (node == null) {
    return null;
  }
  final data = node.getSemanticsData();
  return [
    data.label,
    data.value,
  ].where((part) => part.trim().isNotEmpty).join('. ');
}

class _SpeechLayer extends StatefulWidget {
  const _SpeechLayer({
    required this.readAloud,
    required this.readOnFocus,
    required this.child,
  });

  final bool readAloud;
  final bool readOnFocus;
  final Widget child;

  @override
  State<_SpeechLayer> createState() => _SpeechLayerState();
}

class _SpeechLayerState extends State<_SpeechLayer> {
  /// Dokunma ile kaydırmayı ayırır (mantıksal piksel).
  static const double _tapSlop = 18;

  SemanticsHandle? _semantics;
  Offset? _downAt;
  FocusNode? _lastFocus;

  bool get _active => widget.readAloud || widget.readOnFocus;

  @override
  void initState() {
    super.initState();
    FocusManager.instance.addListener(_onFocusChanged);
    _sync();
  }

  @override
  void didUpdateWidget(_SpeechLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  @override
  void dispose() {
    FocusManager.instance.removeListener(_onFocusChanged);
    _semantics?.dispose();
    super.dispose();
  }

  /// Okuma için semantik ağaç gerekir; yalnızca özellik açıkken üretilir.
  void _sync() {
    if (_active && _semantics == null) {
      _semantics = SemanticsBinding.instance.ensureSemantics();
    } else if (!_active && _semantics != null) {
      _semantics!.dispose();
      _semantics = null;
      unawaited(context.read<VoiceIoService>().stop());
    }
  }

  void _speakAt(Offset position) {
    final text = semanticsTextAt(position);
    if (text == null || text.isEmpty) {
      return;
    }
    unawaited(
      context.read<VoiceIoService>().speak(
        text,
        languageCode: Localizations.localeOf(context).languageCode,
      ),
    );
  }

  void _onFocusChanged() {
    final focus = FocusManager.instance.primaryFocus;
    if (!widget.readOnFocus || focus == null || focus == _lastFocus) {
      return;
    }
    _lastFocus = focus;
    if (focus is FocusScopeNode) {
      return;
    }
    // Semantik ağaç odak değişiminden sonraki karede güncellenir.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final box = focus.context?.findRenderObject();
      if (!mounted || box is! RenderBox || !box.attached) {
        return;
      }
      _speakAt(box.localToGlobal(box.size.center(Offset.zero)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: widget.readAloud
          ? (event) => _downAt = event.position
          : null,
      onPointerUp: widget.readAloud
          ? (event) {
              final downAt = _downAt;
              _downAt = null;
              if (downAt != null &&
                  (event.position - downAt).distance <= _tapSlop) {
                _speakAt(event.position);
              }
            }
          : null,
      child: widget.child,
    );
  }
}

// ── Odak çerçevesi ───────────────────────────────────────────────────────

/// Klavye / fare odağındaki öğenin çevresine iki renkli (her zeminde
/// görünür) kalın çerçeve çizer (WCAG 2.4.7 / 2.4.13).
class _FocusHighlightLayer extends StatefulWidget {
  const _FocusHighlightLayer({required this.level, required this.child});

  final int level;
  final Widget child;

  @override
  State<_FocusHighlightLayer> createState() => _FocusHighlightLayerState();
}

class _FocusHighlightLayerState extends State<_FocusHighlightLayer> {
  final GlobalKey _stack = GlobalKey(debugLabel: 'focus_highlight_stack');
  Rect? _rect;
  bool _tracking = false;

  @override
  void initState() {
    super.initState();
    _startTracking();
  }

  @override
  void didUpdateWidget(_FocusHighlightLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    _startTracking();
  }

  /// Kare sonrası geri çağrı zinciri: çerçeve kaydırma ve yerleşimle birlikte
  /// izlenir, kendisi kare istemez (yalnızca konum değişince yeniden çizer).
  void _startTracking() {
    if (widget.level == 0 || _tracking) {
      return;
    }
    _tracking = true;
    SchedulerBinding.instance.addPostFrameCallback(_track);
  }

  void _track(Duration _) {
    if (!mounted || widget.level == 0) {
      _tracking = false;
      if (mounted && _rect != null) {
        setState(() => _rect = null);
      }
      return;
    }
    final next = _focusedRect();
    if (next != _rect) {
      setState(() => _rect = next);
    }
    SchedulerBinding.instance.addPostFrameCallback(_track);
  }

  Rect? _focusedRect() {
    final focus = FocusManager.instance.primaryFocus;
    if (focus == null || focus is FocusScopeNode) {
      return null;
    }
    final box = focus.context?.findRenderObject();
    final stack = _stack.currentContext?.findRenderObject();
    if (box is! RenderBox ||
        !box.attached ||
        !box.hasSize ||
        stack is! RenderBox) {
      return null;
    }
    final topLeft = stack.globalToLocal(box.localToGlobal(Offset.zero));
    return topLeft & box.size;
  }

  @override
  Widget build(BuildContext context) {
    final rect = widget.level == 0 ? null : _rect;
    return Stack(
      key: _stack,
      fit: StackFit.passthrough,
      children: [
        widget.child,
        if (rect != null)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _FocusRingPainter(rect: rect, level: widget.level),
              ),
            ),
          ),
      ],
    );
  }
}

class _FocusRingPainter extends CustomPainter {
  _FocusRingPainter({required this.rect, required this.level});

  final Rect rect;
  final int level;

  @override
  void paint(Canvas canvas, Size size) {
    final width = 2.0 + level * 2;
    final ring = RRect.fromRectAndRadius(
      rect.inflate(width / 2 + 2),
      const Radius.circular(6),
    );
    canvas
      ..drawRRect(
        ring.inflate(width / 2),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = AppColors.focusRingOuter,
      )
      ..drawRRect(
        ring,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = width
          ..color = AppColors.focusRingInner,
      );
  }

  @override
  bool shouldRepaint(_FocusRingPainter oldDelegate) =>
      oldDelegate.rect != rect || oldDelegate.level != level;
}

// ── Okuma çizgisi / maskesi ve büyük imleç ───────────────────────────────

class _PointerOverlay extends StatefulWidget {
  const _PointerOverlay({
    required this.readingGuide,
    required this.bigCursor,
    required this.child,
  });

  final int readingGuide;
  final int bigCursor;
  final Widget child;

  @override
  State<_PointerOverlay> createState() => _PointerOverlayState();
}

class _PointerOverlayState extends State<_PointerOverlay> {
  /// Okuma çizgisinin dikey konumu; dokunma veya fareyle taşınır.
  final ValueNotifier<double?> _guideY = ValueNotifier(null);

  /// Fare imlecinin konumu (yalnızca fare).
  final ValueNotifier<Offset?> _mouse = ValueNotifier(null);

  @override
  void dispose() {
    _guideY.dispose();
    _mouse.dispose();
    super.dispose();
  }

  void _onPointer(PointerEvent event) {
    if (widget.readingGuide > 0) {
      _guideY.value = event.localPosition.dy;
    }
    if (widget.bigCursor > 0) {
      _mouse.value = event.kind == PointerDeviceKind.mouse
          ? event.localPosition
          : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final active = widget.readingGuide > 0 || widget.bigCursor > 0;
    return Stack(
      fit: StackFit.passthrough,
      children: [
        MouseRegion(
          opaque: false,
          onExit: (_) => _mouse.value = null,
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerHover: active ? _onPointer : null,
            onPointerMove: active ? _onPointer : null,
            onPointerDown: active ? _onPointer : null,
            child: widget.child,
          ),
        ),
        if (widget.readingGuide > 0)
          Positioned.fill(
            child: IgnorePointer(
              child: ValueListenableBuilder<double?>(
                valueListenable: _guideY,
                builder: (context, y, _) => CustomPaint(
                  key: const Key('reading_guide'),
                  painter: _ReadingGuidePainter(
                    y: y,
                    level: widget.readingGuide,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
          ),
        if (widget.bigCursor > 0) ...[
          Positioned.fill(
            child: IgnorePointer(
              child: ValueListenableBuilder<Offset?>(
                valueListenable: _mouse,
                builder: (context, position, _) => CustomPaint(
                  key: const Key('big_cursor'),
                  painter: _BigCursorPainter(
                    position: position,
                    size: widget.bigCursor == 1 ? 40 : 56,
                  ),
                ),
              ),
            ),
          ),
          // Sistem imleci gizlenir; aksi halde büyük okun üstünde küçük
          // gerçek imleç de görünür (iki imleç). En üstte olduğundan
          // butonların "tıklama" imlecini de bastırır; saydam olduğundan
          // dokunuşlar ve fare olayları alttaki içeriğe ulaşır.
          const Positioned.fill(
            child: MouseRegion(
              key: Key('big_cursor_hide_system'),
              cursor: SystemMouseCursors.none,
              opaque: false,
              hitTestBehavior: HitTestBehavior.translucent,
            ),
          ),
        ],
      ],
    );
  }
}

class _ReadingGuidePainter extends CustomPainter {
  _ReadingGuidePainter({
    required this.y,
    required this.level,
    required this.color,
  });

  /// `null` → ekranın ortası (henüz dokunulmadı).
  final double? y;
  final int level;
  final Color color;

  /// Okuma maskesinde açık bırakılan şeridin yarı yüksekliği.
  static const double _maskHalfHeight = 36;

  @override
  void paint(Canvas canvas, Size size) {
    final center = (y ?? size.height / 2).clamp(0.0, size.height);
    if (level >= 3) {
      final dim = Paint()..color = AppColors.readingMaskScrim;
      canvas
        ..drawRect(
          Rect.fromLTRB(0, 0, size.width, center - _maskHalfHeight),
          dim,
        )
        ..drawRect(
          Rect.fromLTRB(0, center + _maskHalfHeight, size.width, size.height),
          dim,
        );
      return;
    }
    final thickness = level == 1 ? 3.0 : 8.0;
    canvas
      ..drawRect(
        Rect.fromCenter(
          center: Offset(size.width / 2, center),
          width: size.width,
          height: thickness + 2,
        ),
        Paint()..color = AppColors.focusRingOuter,
      )
      ..drawRect(
        Rect.fromCenter(
          center: Offset(size.width / 2, center),
          width: size.width,
          height: thickness,
        ),
        Paint()..color = color,
      );
  }

  @override
  bool shouldRepaint(_ReadingGuidePainter oldDelegate) =>
      oldDelegate.y != y ||
      oldDelegate.level != level ||
      oldDelegate.color != color;
}

class _BigCursorPainter extends CustomPainter {
  _BigCursorPainter({required this.position, required this.size});

  final Offset? position;
  final double size;

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final tip = position;
    if (tip == null) {
      return;
    }
    // Klasik ok imleci (20 birimlik ızgarada), ucu imleç konumunda.
    final unit = size / 20;
    Offset p(double x, double y) => tip + Offset(x * unit, y * unit);
    final arrow = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(p(0, 17).dx, p(0, 17).dy)
      ..lineTo(p(4.2, 13.2).dx, p(4.2, 13.2).dy)
      ..lineTo(p(7, 19.5).dx, p(7, 19.5).dy)
      ..lineTo(p(10, 18.2).dx, p(10, 18.2).dy)
      ..lineTo(p(7.2, 12).dx, p(7.2, 12).dy)
      ..lineTo(p(12.5, 12).dx, p(12.5, 12).dy)
      ..close();
    canvas
      ..drawPath(arrow, Paint()..color = AppColors.cursorFill)
      ..drawPath(
        arrow,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = unit * 1.2
          ..strokeJoin = StrokeJoin.round
          ..color = AppColors.cursorOutline,
      );
  }

  @override
  bool shouldRepaint(_BigCursorPainter oldDelegate) =>
      oldDelegate.position != position || oldDelegate.size != size;
}
