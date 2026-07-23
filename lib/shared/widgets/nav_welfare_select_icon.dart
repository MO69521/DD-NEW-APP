import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import 'nav_select_motion.dart';

/// 福利底栏选中动效（Figma 时间轴 · 当前 `yellow_dark`）。
///
/// 时间轴（相对比例；总时长 [AppDurations.bottomNavSelectMotion]）：
/// - 0–40%：灰描边礼盒/火花/盖 + 白竖线 trimStart 消退
/// - 40–80%：白→浅黄→橙填充 spring 缩放（damping 8）
/// - 80–100%：棕竖线 trimEnd 描出
class NavWelfareSelectIcon extends StatelessWidget {
  const NavWelfareSelectIcon({
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
        painter: _WelfareSelectPainter(progress: progress),
      ),
    );
  }
}

class _WelfareSelectPainter extends CustomPainter {
  _WelfareSelectPainter({required this.progress});

  final double progress;

  static final Path _outlineBody = parseSvgPathData(
    'M4 10V18C4 19.6569 5.34315 21 7 21H17C18.6569 21 20 19.6569 20 18V10',
  );

  static final Path _sparkleRight = parseSvgPathData(
    'M16.1835 3.31451L15.1935 4.30446',
  );

  static final Path _sparkleLeft = parseSvgPathData(
    'M7.81946 3.32153L8.80941 4.31148',
  );

  static final Path _centerLine = parseSvgPathData(
    'M12 14C12 15.1988 12 15.8012 12 17',
  );

  static final Path _lid = parseSvgPathData(
    'M2 7.5C2 6.11929 3.11929 5 4.5 5H19.5C20.8807 5 22 6.11929 22 7.5C22 '
    '8.88071 20.8807 10 19.5 10H4.5C3.11929 10 2 8.88071 2 7.5Z',
  );

  static final Path _fillGift = parseSvgPathData(
    'M14.6992 1.82945C15.5192 1.0099 16.848 1.0099 17.668 1.82945C18.2287 '
    '2.39038 18.4044 3.18885 18.1982 3.89977H19.5C21.4882 3.89977 23.0996 '
    '5.51213 23.0996 7.50035C23.0994 8.91353 22.2842 10.134 21.0996 '
    '10.723V18.0004C21.0993 20.2645 19.2642 22.1 17 22.1H7C4.73579 22.1 '
    '2.90066 20.2645 2.90039 18.0004V10.723C1.71576 10.134 0.900589 8.91353 '
    '0.900391 7.50035C0.900391 5.51213 2.51178 3.89977 4.5 3.89977H5.80273C5.'
    '59981 3.19055 5.77597 2.39536 6.33496 1.83629C7.15495 1.01674 8.48371 '
    '1.01675 9.30371 1.83629L11.3672 3.89977H12.6289L14.6992 1.82945Z',
  );

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24);

    final outlineTrim = NavSelectMotion.ease.transform(
      NavSelectMotion.outlineFade(progress),
    );
    final fastTrim = NavSelectMotion.ease.transform(
      NavSelectMotion.phase(progress, 0, 0.354),
    );
    final fillScale = NavSelectMotion.fillScale(progress, damping: 8);
    final detailT = NavSelectMotion.ease.transform(
      NavSelectMotion.detailFade(progress),
    );

    // Figma `#9D9FA2` → 收敛 `neutralCool400` / 深色 `textSecondary`。
    final grayPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = AppColors.textSecondary
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    if (outlineTrim < 0.999) {
      NavSelectMotion.drawTrimStart(canvas, _outlineBody, outlineTrim, grayPaint);
      NavSelectMotion.drawTrimStart(
        canvas,
        _sparkleRight,
        outlineTrim,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.6
          ..color = AppColors.textSecondary
          ..strokeCap = StrokeCap.round,
      );
      NavSelectMotion.drawTrimStart(canvas, _lid, outlineTrim, grayPaint);
    }

    if (fastTrim < 0.999) {
      NavSelectMotion.drawTrimStart(
        canvas,
        _sparkleLeft,
        fastTrim,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.6
          ..color = AppColors.textSecondary
          ..strokeCap = StrokeCap.round,
      );
      NavSelectMotion.drawTrimStart(
        canvas,
        _centerLine,
        fastTrim,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = AppColors.white100.withValues(
            alpha: AppColors.navBookstoreOutlineOpacity,
          )
          ..strokeCap = StrokeCap.square,
      );
    }

    NavSelectMotion.paintFillWithBorder(
      canvas: canvas,
      path: _fillGift,
      fillFrom: const Offset(4.85, 5.22),
      fillTo: const Offset(22.34, 22.66),
      borderFrom: const Offset(12, 1.31),
      borderTo: const Offset(12, 22),
      scale: fillScale,
    );

    if (detailT > 0.001) {
      final detailPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = AppColors.navBookstoreSmileStroke.withValues(alpha: detailT)
        ..strokeCap = StrokeCap.square;
      NavSelectMotion.drawTrimEnd(canvas, _centerLine, detailT, detailPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _WelfareSelectPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
