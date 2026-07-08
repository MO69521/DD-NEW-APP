import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../core/theme/app_colors.dart';

/// L1 — 极光动画背景（GLSL 片元着色器，移植自 vue-bits Aurora）。
///
/// 颜色一律走设计 token（默认品牌紫→黄→紫），以 uniform 传入着色器。
/// 着色器加载失败时回退为静态渐变，保证不崩溃。
class AuroraBackground extends StatefulWidget {
  const AuroraBackground({
    super.key,
    this.colorStops,
    this.amplitude = 1.0,
    this.blend = 0.5,
    this.opacity = 1.0,
    this.child,
  });

  /// 三档极光颜色；缺省使用品牌色 紫 → 黄 → 紫。
  final List<Color>? colorStops;

  /// 噪声振幅（越大波动越强）。
  final double amplitude;

  /// 极光边缘柔和度。
  final double blend;

  /// 整体不透明度（0–1）；越小极光越淡。
  final double opacity;

  /// 叠加在极光之上的内容。
  final Widget? child;

  @override
  State<AuroraBackground> createState() => _AuroraBackgroundState();
}

class _AuroraBackgroundState extends State<AuroraBackground>
    with SingleTickerProviderStateMixin {
  Ticker? _ticker;
  ui.FragmentShader? _shader;
  final ValueNotifier<double> _time = ValueNotifier<double>(0);
  bool _ready = false;

  List<Color> get _colors =>
      widget.colorStops ??
      const [
        AppColors.accentYellow,
        AppColors.accentYellow,
        AppColors.accentYellow,
      ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final program = await ui.FragmentProgram.fromAsset(
        'assets/shaders/aurora.frag',
      );
      _shader = program.fragmentShader();
      _ticker = createTicker((elapsed) {
        _time.value = elapsed.inMicroseconds / Duration.microsecondsPerSecond;
      })..start();
      if (mounted) setState(() => _ready = true);
    } catch (_) {
      if (mounted) setState(() => _ready = false);
    }
  }

  @override
  void dispose() {
    _ticker?.dispose();
    _shader?.dispose();
    _time.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shader = _shader;
    Widget aurora;
    if (!_ready || shader == null) {
      aurora = _AuroraFallback(colors: _colors);
    } else {
      aurora = CustomPaint(
        painter: _AuroraPainter(
          shader: shader,
          time: _time,
          colors: _colors,
          amplitude: widget.amplitude,
          blend: widget.blend,
        ),
        child: const SizedBox.expand(),
      );
    }
    if (widget.opacity < 1.0) {
      aurora = Opacity(opacity: widget.opacity, child: aurora);
    }
    final child = widget.child;
    if (child == null) return aurora;
    return Stack(
      fit: StackFit.passthrough,
      children: [Positioned.fill(child: aurora), child],
    );
  }
}

class _AuroraPainter extends CustomPainter {
  _AuroraPainter({
    required this.shader,
    required this.time,
    required this.colors,
    required this.amplitude,
    required this.blend,
  }) : super(repaint: time);

  final ui.FragmentShader shader;
  final ValueNotifier<double> time;
  final List<Color> colors;
  final double amplitude;
  final double blend;

  @override
  void paint(Canvas canvas, Size size) {
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, time.value)
      ..setFloat(3, amplitude)
      ..setFloat(4, blend)
      ..setFloat(5, colors[0].r)
      ..setFloat(6, colors[0].g)
      ..setFloat(7, colors[0].b)
      ..setFloat(8, colors[1].r)
      ..setFloat(9, colors[1].g)
      ..setFloat(10, colors[1].b)
      ..setFloat(11, colors[2].r)
      ..setFloat(12, colors[2].g)
      ..setFloat(13, colors[2].b);
    canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(covariant _AuroraPainter oldDelegate) =>
      oldDelegate.colors != colors ||
      oldDelegate.amplitude != amplitude ||
      oldDelegate.blend != blend;
}

/// 着色器不可用时的静态渐变回退。
class _AuroraFallback extends StatelessWidget {
  const _AuroraFallback({required this.colors, this.child});

  final List<Color> colors;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.first.withValues(alpha: 0.55),
            colors.length > 1
                ? colors[1].withValues(alpha: 0.35)
                : colors.first.withValues(alpha: 0.35),
            Colors.transparent,
          ],
          stops: const [0.0, 0.4, 1.0],
        ),
      ),
      child: SizedBox.expand(child: child),
    );
  }
}
