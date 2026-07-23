import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import 'nav_select_motion.dart';

/// 「我的」底栏选中动效（Figma 时间轴 · 当前 `yellow_dark`）。
///
/// 时间轴（相对比例；总时长 [AppDurations.bottomNavSelectMotion]）：
/// - 0–40%：白描边外框 + 双眼 opacity/trimStart 消退
/// - 40–80%：填充 spring 缩放（damping 12）
/// - 80–100%：棕双眼 trimStart 显现
class NavProfileSelectIcon extends StatelessWidget {
  const NavProfileSelectIcon({
    super.key,
    required this.progress,
    this.size = AppSizes.bottomNavIconSize,
  });

  final double progress;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ProfileSelectPainter(progress: progress),
      ),
    );
  }
}

class _ProfileSelectPainter extends CustomPainter {
  _ProfileSelectPainter({required this.progress});

  final double progress;

  static final Path _outlineFrame = parseSvgPathData(
    'M3 12C3 7.02944 7.02944 3 12 3H16.8462C17.9198 3 18.4566 3 18.8925 '
    '3.13584C19.8338 3.42915 20.5709 4.16622 20.8642 5.10749C21 5.54341 21 '
    '6.08022 21 7.15385V12C21 16.9706 16.9706 21 12 21C7.02944 21 3 16.9706 '
    '3 12Z',
  );

  static final Path _eyeLeft = parseSvgPathData('M8 10V13');

  static final Path _eyeRight = parseSvgPathData('M13 10L12 11.5L13 13');

  static final Path _fillFace = parseSvgPathData(
    'M2 12C2 6.47715 6.47715 2 12 2H16.2857C17.8817 2 18.6796 2 19.3211 '
    '2.22447C20.4701 2.62651 21.3735 3.5299 21.7755 4.67888C22 5.32037 22 '
    '6.11834 22 7.71429V12C22 17.5228 17.5228 22 12 22C6.47715 22 2 17.5228 '
    '2 12Z',
  );

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24);

    final outlineFade = NavSelectMotion.outlineFade(progress);
    final outlineEase = NavSelectMotion.ease.transform(outlineFade);
    final outlineAlpha =
        (1 - outlineEase) * AppColors.navBookstoreOutlineOpacity;
    final fillScale = NavSelectMotion.fillScale(progress, damping: 12);
    final detailT = NavSelectMotion.ease.transform(
      NavSelectMotion.detailFade(progress),
    );

    if (outlineAlpha > 0.001) {
      final framePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = AppColors.white100.withValues(alpha: outlineAlpha)
        ..strokeJoin = StrokeJoin.round;
      NavSelectMotion.drawTrimStart(
        canvas,
        _outlineFrame,
        outlineEase,
        framePaint,
      );

      final eyePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = AppColors.white100.withValues(alpha: outlineAlpha)
        ..strokeCap = StrokeCap.square;
      NavSelectMotion.drawTrimStart(canvas, _eyeLeft, outlineEase, eyePaint);
      NavSelectMotion.drawTrimStart(canvas, _eyeRight, outlineEase, eyePaint);
    }

    NavSelectMotion.paintFillWithBorder(
      canvas: canvas,
      path: _fillFace,
      fillFrom: const Offset(5.5, 5.77),
      fillTo: const Offset(22.38, 21.6),
      borderFrom: const Offset(12, 2),
      borderTo: const Offset(12, 22),
      scale: fillScale,
    );

    if (detailT > 0.001) {
      final detailPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = AppColors.navBookstoreSmileStroke.withValues(alpha: detailT)
        ..strokeCap = StrokeCap.square;
      NavSelectMotion.drawTrimStart(
        canvas,
        _eyeLeft,
        1 - detailT,
        detailPaint,
      );
      NavSelectMotion.drawTrimStart(
        canvas,
        _eyeRight,
        1 - detailT,
        detailPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ProfileSelectPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
