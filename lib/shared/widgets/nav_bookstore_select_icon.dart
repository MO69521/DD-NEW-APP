import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import 'nav_select_motion.dart';

/// 书城底栏选中动效（Figma 时间轴试接入 · 当前 `yellow_dark`）。
///
/// 时间轴（相对比例；总时长 [AppDurations.bottomNavSelectMotion]）：
/// - 0–40%：白描边屋形 + 笑脸 trim/opacity（起始 60%）→ 0
/// - 40–80%：白→浅黄→橙填充屋形 spring 缩放 0→1（damping 8）
/// - 80–100%：棕描边笑脸 trim/opacity 0→1
class NavBookstoreSelectIcon extends StatelessWidget {
  const NavBookstoreSelectIcon({
    super.key,
    required this.progress,
    this.size = AppSizes.bottomNavIconSize,
  });

  /// 0–1，对应完整选中动效进度；冷启动已选中时应为 1。
  final double progress;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _BookstoreSelectPainter(progress: progress),
      ),
    );
  }
}

class _BookstoreSelectPainter extends CustomPainter {
  _BookstoreSelectPainter({required this.progress});

  final double progress;

  static final Path _outlineHouse = parseSvgPathData(
    'M10.1932 21.0175H13.8068L15.0067 21.0157C17.5359 21.0018 18.9469 '
    '20.8939 19.8748 20.0558L19.9754 19.9597C21.0338 18.9013 21.0341 '
    '17.1972 21.0341 13.7902V11.5591C21.0341 9.56039 21.0338 8.56035 '
    '20.5647 7.73192C20.0957 6.90372 19.2389 6.38946 17.5254 5.36136L15.7186 '
    '4.2771C13.907 3.19011 13.0009 2.64673 12 2.64673C10.9991 2.64673 '
    '10.0931 3.19011 8.2814 4.2771L6.47459 5.36136L5.34268 6.0495C4.35699 '
    '6.66657 3.78706 7.11083 3.43529 7.73192L3.35236 7.88984C2.96594 '
    '8.68952 2.96594 9.68535 2.96594 11.5589V11.5591V13.7902C2.96594 '
    '17.1972 2.96622 18.9013 4.02462 19.9597L4.1252 20.0558C5.05312 '
    '20.8939 6.46413 21.0018 8.99336 21.0157L10.1932 21.0175Z',
  );

  static final Path _smile = parseSvgPathData(
    'M9 15C9 15 10.1829 16 12 16C13.8171 16 15 15 15 15',
  );

  static final Path _fillHouse = parseSvgPathData(
    'M12 1.56555C12.5737 1.56555 13.1163 1.72122 13.7637 2.02551C14.409 '
    '2.32892 15.1663 2.78347 16.167 3.38391L18.167 4.58411C19.1139 5.15225 '
    '19.831 5.58175 20.375 5.9845C20.9206 6.38847 21.2985 6.7704 21.5674 '
    '7.24524C21.8363 7.72015 21.9685 8.2413 22.0342 8.91711C22.0996 9.59071 '
    '22.0996 10.4263 22.0996 11.5304V14.0001C22.0996 15.8827 22.1006 17.3051 '
    '21.9531 18.4025C21.8052 19.5027 21.5068 20.2921 20.8994 20.8995C20.292 '
    '21.507 19.5027 21.8053 18.4023 21.9532C17.3049 22.1008 15.8827 22.1007 '
    '14 22.1007H10C8.11726 22.1007 6.69511 22.1008 5.59766 21.9532C4.49731 '
    '21.8053 3.70805 21.507 3.10059 20.8995C2.49322 20.2921 2.1948 19.5027 '
    '2.04688 18.4025C1.89938 17.3051 1.90039 15.8827 1.90039 14.0001V11.5304'
    'C1.90039 10.4263 1.90038 9.59071 1.96582 8.91711C2.03151 8.2413 2.16373 '
    '7.72015 2.43262 7.24524C2.70148 6.7704 3.07939 6.38847 3.625 5.9845C4.'
    '16897 5.58175 4.88611 5.15225 5.83301 4.58411L7.83301 3.38391C8.83374 '
    '2.78347 9.59096 2.32892 10.2363 2.02551C10.8837 1.72122 11.4263 1.56555 '
    '12 1.56555Z',
  );

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24);

    final outlineFade = NavSelectMotion.outlineFade(progress);
    final outlineEase = NavSelectMotion.ease.transform(outlineFade);
    final outlineT =
        (1 - outlineEase) * AppColors.navBookstoreOutlineOpacity;
    final fillScale = NavSelectMotion.fillScale(progress, damping: 8);
    final smileT = NavSelectMotion.ease.transform(
      NavSelectMotion.detailFade(progress),
    );

    if (outlineT > 0.001) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.08
        ..color = AppColors.white100.withValues(alpha: outlineT)
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round;
      NavSelectMotion.drawTrimEnd(canvas, _outlineHouse, 1 - outlineEase, paint);

      final smilePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = AppColors.white100.withValues(alpha: outlineT)
        ..strokeCap = StrokeCap.square;
      NavSelectMotion.drawTrimEnd(
        canvas,
        _smile,
        1 - outlineEase,
        smilePaint,
      );
    }

    NavSelectMotion.paintFillWithBorder(
      canvas: canvas,
      path: _fillHouse,
      fillFrom: const Offset(5.5, 5.5),
      fillTo: const Offset(22.64, 21.31),
      borderFrom: const Offset(12, 1.67),
      borderTo: const Offset(12, 22),
      scale: fillScale,
    );

    if (smileT > 0.001) {
      final smilePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = AppColors.navBookstoreSmileStroke.withValues(alpha: smileT)
        ..strokeCap = StrokeCap.square;
      NavSelectMotion.drawTrimEnd(canvas, _smile, smileT, smilePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _BookstoreSelectPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
