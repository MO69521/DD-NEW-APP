import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_sizes.dart';

/// L2 — 强 CTA 液态扫光裁剪壳。
///
/// 用于已有“呼吸缩放 + 扫光”的按钮：保留宿主原本尺寸、padding、渐变或切图，
/// 只让扫光经过的边缘产生非常轻微的液态形变。
class LiquidSweepCtaClip extends StatelessWidget {
  const LiquidSweepCtaClip({
    super.key,
    required this.progress,
    required this.borderRadius,
    required this.child,
    this.gradientColors,
    this.borderColor,
    this.borderWidth = AppSizes.hairline,
  });

  final Animation<double> progress;
  final double borderRadius;
  final Widget child;
  final List<Color>? gradientColors;
  final Color? borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: gradientColors == null
          ? null
          : _LiquidSweepCtaBackgroundPainter(
              progress: progress,
              borderRadius: borderRadius,
              gradientColors: gradientColors!,
            ),
      foregroundPainter: borderColor == null
          ? null
          : _LiquidSweepCtaBorderPainter(
              progress: progress,
              borderRadius: borderRadius,
              borderColor: borderColor!,
              borderWidth: borderWidth,
            ),
      child: ClipPath(
        clipper: _LiquidSweepCtaClipper(
          progress: progress,
          borderRadius: borderRadius,
        ),
        child: child,
      ),
    );
  }
}

class _LiquidSweepCtaBackgroundPainter extends CustomPainter {
  _LiquidSweepCtaBackgroundPainter({
    required this.progress,
    required this.borderRadius,
    required this.gradientColors,
  }) : super(repaint: progress);

  final Animation<double> progress;
  final double borderRadius;
  final List<Color> gradientColors;

  @override
  void paint(Canvas canvas, Size size) {
    final path = _LiquidSweepCtaShape.buildPath(
      size: size,
      progress: progress.value,
      borderRadius: borderRadius,
    );
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          colors: gradientColors,
        ).createShader(Offset.zero & size),
    );
  }

  @override
  bool shouldRepaint(covariant _LiquidSweepCtaBackgroundPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.gradientColors != gradientColors;
  }
}

class _LiquidSweepCtaClipper extends CustomClipper<Path> {
  _LiquidSweepCtaClipper({
    required this.progress,
    required this.borderRadius,
  }) : super(reclip: progress);

  final Animation<double> progress;
  final double borderRadius;

  @override
  Path getClip(Size size) {
    return _LiquidSweepCtaShape.buildPath(
      size: size,
      progress: progress.value,
      borderRadius: borderRadius,
    );
  }

  @override
  bool shouldReclip(covariant _LiquidSweepCtaClipper oldClipper) {
    return oldClipper.progress != progress ||
        oldClipper.borderRadius != borderRadius;
  }
}

class _LiquidSweepCtaBorderPainter extends CustomPainter {
  _LiquidSweepCtaBorderPainter({
    required this.progress,
    required this.borderRadius,
    required this.borderColor,
    required this.borderWidth,
  }) : super(repaint: progress);

  final Animation<double> progress;
  final double borderRadius;
  final Color borderColor;
  final double borderWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final path = _LiquidSweepCtaShape.buildPath(
      size: size,
      progress: progress.value,
      borderRadius: borderRadius,
    );
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth
        ..color = borderColor,
    );
  }

  @override
  bool shouldRepaint(covariant _LiquidSweepCtaBorderPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth;
  }
}

abstract final class _LiquidSweepCtaShape {
  // 已确认的 CTA 液态扫光形变参数。不要在接入新按钮时改这些值；
  // 新按钮只应复用 LiquidSweepCtaClip，以保持全局扫光形变一致。
  static const int _segments = 40;
  static const double _slantFactor = 0.16;
  static const double _influenceWidthFactor = 0.42;
  static const double _deformAmountFactor = 0.014;

  static Path buildPath({
    required Size size,
    required double progress,
    required double borderRadius,
  }) {
    final radius = math.min(borderRadius, size.height / 2);
    final right = size.width;
    final bottom = size.height;
    final centerY = size.height / 2;
    final points = <Offset>[];

    for (var i = 0; i <= _segments; i++) {
      final t = i / _segments;
      final point = Offset(radius + (size.width - radius * 2) * t, 0);
      points.add(_offsetPoint(point, const Offset(0, -1), size, progress));
    }

    for (var i = 1; i <= _segments; i++) {
      final angle = -math.pi / 2 + math.pi * i / _segments;
      final normal = Offset(math.cos(angle), math.sin(angle));
      final point = Offset(right - radius, centerY) + normal * radius;
      points.add(_offsetPoint(point, normal, size, progress));
    }

    for (var i = 1; i <= _segments; i++) {
      final t = i / _segments;
      final point = Offset(
        right - radius - (size.width - radius * 2) * t,
        bottom,
      );
      points.add(_offsetPoint(point, const Offset(0, 1), size, progress));
    }

    for (var i = 1; i < _segments; i++) {
      final angle = math.pi / 2 + math.pi * i / _segments;
      final normal = Offset(math.cos(angle), math.sin(angle));
      final point = Offset(radius, centerY) + normal * radius;
      points.add(_offsetPoint(point, normal, size, progress));
    }

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    return path..close();
  }

  static Offset _offsetPoint(
    Offset point,
    Offset normal,
    Size size,
    double progress,
  ) {
    final bandWidth = size.width * AppSizes.membershipCtaSweepBandWidthRatio;
    final centerX = -bandWidth / 2 + (size.width + bandWidth) * progress;
    final localY = point.dy / size.height;
    final slantedX = point.dx + (localY - 0.5) * size.width * _slantFactor;
    final distance = (slantedX - centerX).abs();
    final proximity = (1 - distance / (bandWidth * _influenceWidthFactor))
        .clamp(0.0, 1.0);
    final eased = Curves.easeInOutCubic.transform(proximity);
    final amount = eased * size.height * _deformAmountFactor;
    return point + normal * amount;
  }
}
