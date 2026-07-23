import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import 'nav_select_motion.dart';

/// 书架底栏选中动效（Figma 时间轴 · 当前 `yellow_dark`）。
///
/// 时间轴（相对比例；总时长 [AppDurations.bottomNavSelectMotion]）：
/// - 0–40%：白填充轮廓 + 白折线 opacity/trimStart 消退
/// - 40–80%：填充 spring 缩放（damping 12）
/// - 80–100%：棕折线 trimStart 显现
class NavBookshelfSelectIcon extends StatelessWidget {
  const NavBookshelfSelectIcon({
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
        painter: _BookshelfSelectPainter(progress: progress),
      ),
    );
  }
}

class _BookshelfSelectPainter extends CustomPainter {
  _BookshelfSelectPainter({required this.progress});

  final double progress;

  /// Figma 导出的描边展开填充轮廓（未选中白影）。
  static final Path _outlineFill = parseSvgPathData(
    'M17.959 3.8274L17.9035 2.82894L17.9035 2.82894L17.959 3.8274ZM21 '
    '6.99537H22V6.9953L21 6.99537ZM21 15.8967L22 15.8969V15.8967H21ZM16.7637 '
    '20.1409L16.8984 21.1318L16.8984 21.1318L16.7637 20.1409ZM7.23633 '
    '20.1409L7.10157 21.1318L7.1016 21.1318L7.23633 20.1409ZM3 15.8967H2V15.'
    '8969L3 15.8967ZM3 6.99537L2 6.9953V6.99537H3ZM6.04102 3.8274L6.09654 '
    '2.82894L6.09647 2.82894L6.04102 3.8274ZM9.61694 20.6992L9.94682 '
    '19.7552L9.61694 20.6992ZM17.959 3.8274L18.0144 4.82586C19.0735 4.76704 '
    '19.9999 5.67681 20 6.99543L21 6.99537L22 6.9953C21.9999 4.79462 20.3583 '
    '2.6926 17.9035 2.82894L17.959 3.8274ZM21 6.99537H20V15.8967H21H22V6.'
    '99537H21ZM21 15.8967L20 15.8966C19.9998 17.4661 18.5078 18.8945 16.6289 '
    '19.15L16.7637 20.1409L16.8984 21.1318C19.4278 20.7878 21.9996 18.776 22 '
    '15.8969L21 15.8967ZM16.7637 20.1409L16.6289 19.15C15.8078 19.2616 '
    '14.9282 19.4494 14.0532 19.7552L14.3831 20.6992L14.7129 21.6432C15.4371 '
    '21.3902 16.182 21.2292 16.8984 21.1318L16.7637 20.1409ZM9.61694 '
    '20.6992L9.94682 19.7552C9.07179 19.4494 8.19224 19.2616 7.37106 '
    '19.15L7.23633 20.1409L7.1016 21.1318C7.81795 21.2292 8.56287 21.3902 '
    '9.28706 21.6432L9.61694 20.6992ZM7.23633 20.1409L7.37109 19.15C5.49225 '
    '18.8945 4.0002 17.4661 4 15.8966L3 15.8967L2 15.8969C2.00037 18.776 '
    '4.57223 20.7878 7.10157 21.1318L7.23633 20.1409ZM3 15.8967H4V6.99537H3H2V'
    '15.8967H3ZM3 6.99537L4 6.99543C4.00008 5.67681 4.92652 4.76704 5.98556 '
    '4.82586L6.04102 3.8274L6.09647 2.82894C3.64167 2.6926 2.00014 4.79462 2 '
    '6.9953L3 6.99537ZM6.04102 3.8274L5.98549 4.82586C7.00849 4.88275 8.1703 '
    '5.053 9.28689 5.44348L9.61699 4.49953L9.94709 3.55558C8.60351 3.08573 '
    '7.24537 2.89283 6.09654 2.82894L6.04102 3.8274ZM14.383 4.49953L14.7131 '
    '5.44348C15.8297 5.053 16.9915 4.88275 18.0145 4.82586L17.959 3.8274L17.'
    '9035 2.82894C16.7546 2.89283 15.3965 3.08573 14.0529 3.55558L14.383 '
    '4.49953ZM9.61699 4.49953L9.28689 5.44348C11.0109 6.04638 12.9891 6.04638 '
    '14.7131 5.44348L14.383 4.49953L14.0529 3.55558C12.7563 4.00901 11.2437 '
    '4.00901 9.94709 3.55558L9.61699 4.49953ZM14.3831 20.6992L14.0532 '
    '19.7552C12.7564 20.2083 11.2436 20.2083 9.94682 19.7552L9.61694 '
    '20.6992L9.28706 21.6432C11.011 22.2457 12.989 22.2457 14.7129 '
    '21.6432L14.3831 20.6992Z',
  );

  static final Path _fold = parseSvgPathData(
    'M17 11C14 11 12 13 12 13C12 13 10 11 7 11',
  );

  static final Path _fillBody = parseSvgPathData(
    'M18.6211 2.86833C20.5733 2.75991 22 4.43356 22 6.38884V16.2785C21.9999 '
    '18.7501 19.742 20.6612 17.293 20.9943C16.4388 21.1105 15.5363 21.3044 '
    '14.6479 21.615C12.9697 22.2017 11.0303 22.2017 9.35214 21.615C8.4637 '
    '21.3044 7.56124 21.1105 6.70703 20.9943C4.25795 20.6612 2.00013 18.7501 '
    '2 16.2785V6.38884C2 4.43356 3.42669 2.75991 5.37891 2.86833C6.58546 '
    '2.93543 7.98542 3.13706 9.35216 3.61492C11.0303 4.20166 12.9697 4.20166 '
    '14.6478 3.61492C16.0146 3.13706 17.4145 2.93543 18.6211 2.86833Z',
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
      canvas.drawPath(
        _outlineFill,
        Paint()..color = AppColors.white100.withValues(alpha: outlineAlpha),
      );
      final foldPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = AppColors.white100.withValues(alpha: outlineAlpha);
      NavSelectMotion.drawTrimStart(canvas, _fold, outlineEase, foldPaint);
    }

    NavSelectMotion.paintFillWithBorder(
      canvas: canvas,
      path: _fillBody,
      fillFrom: const Offset(5.5, 6.48),
      fillTo: const Offset(21.73, 22.34),
      borderFrom: const Offset(12, 2.86),
      borderTo: const Offset(12, 22.06),
      scale: fillScale,
    );

    if (detailT > 0.001) {
      final detailPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = AppColors.navBookstoreSmileStroke.withValues(alpha: detailT);
      // Figma pathTrimStart 1→0：自末端显现。
      NavSelectMotion.drawTrimStart(
        canvas,
        _fold,
        1 - detailT,
        detailPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BookshelfSelectPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
