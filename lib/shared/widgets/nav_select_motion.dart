import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

import '../../core/theme/app_colors.dart';

/// 底栏 Tab 选中路径动效共享工具（Figma 时间轴 · `yellow_dark`）。
abstract final class NavSelectMotion {
  static const Cubic ease = Cubic(0.5, 0.0, 0.5, 1.0);

  static SpringSimulation scaleSpring({double damping = 8}) {
    return SpringSimulation(
      SpringDescription(mass: 1, stiffness: 100, damping: damping),
      0,
      1,
      0,
    );
  }

  static double phase(double t, double start, double end) {
    if (t <= start) return 0;
    if (t >= end) return 1;
    return (t - start) / (end - start);
  }

  /// 前 40%：白描边消退进度（0→1）。
  static double outlineFade(double progress) => phase(progress, 0, 0.4);

  /// 40–80%：填充 spring 缩放；[damping] 书城/福利 8，书架/我的 12。
  static double fillScale(double progress, {double damping = 8}) {
    if (progress <= 0.4) return 0;
    if (progress >= 0.8) return 1;
    final local = (progress - 0.4) / 0.4;
    return scaleSpring(damping: damping).x(local * 0.4).clamp(0.0, 1.35);
  }

  /// 后 20%：细节描边出现进度（0→1）。
  static double detailFade(double progress) => phase(progress, 0.8, 1.0);

  static void drawTrimEnd(
    Canvas canvas,
    Path path,
    double trimEnd,
    Paint paint,
  ) {
    for (final metric in path.computeMetrics()) {
      final length = metric.length * trimEnd.clamp(0.0, 1.0);
      if (length <= 0) continue;
      canvas.drawPath(metric.extractPath(0, length), paint);
    }
  }

  /// pathTrimStart：可见段为 [trimStart, 1]；0→1 消退，1→0 显现。
  static void drawTrimStart(
    Canvas canvas,
    Path path,
    double trimStart,
    Paint paint,
  ) {
    final start = trimStart.clamp(0.0, 1.0);
    if (start >= 1) return;
    for (final metric in path.computeMetrics()) {
      final length = metric.length;
      final from = length * start;
      if (from >= length) continue;
      canvas.drawPath(metric.extractPath(from, length), paint);
    }
  }

  static void paintFillWithBorder({
    required Canvas canvas,
    required Path path,
    required Offset fillFrom,
    required Offset fillTo,
    required Offset borderFrom,
    required Offset borderTo,
    required double scale,
  }) {
    if (scale <= 0.001) return;
    canvas.save();
    canvas.translate(12, 12);
    canvas.scale(scale);
    canvas.translate(-12, -12);
    canvas.drawPath(
      path,
      Paint()
        ..shader = ui.Gradient.linear(
          fillFrom,
          fillTo,
          const [
            AppColors.white100,
            AppColors.navBookstoreFillMid,
            AppColors.navBookstoreFillEnd,
          ],
          const [0, 0.498, 1],
        ),
    );
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.2
        ..shader = ui.Gradient.linear(
          borderFrom,
          borderTo,
          const [
            AppColors.white100,
            AppColors.white100,
            AppColors.white00,
          ],
          const [0, 0.4, 1],
        ),
    );
    canvas.restore();
  }
}
