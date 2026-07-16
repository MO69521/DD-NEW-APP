import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';

/// L3 组件 — 福利奖励气泡：圆角矩形主体 + 底部居中向下小三角 + 可选 1px 描边。
///
/// 时间轴节点气泡与每日签到里程碑气泡共用，纯代码绘制（高度自适应内容），
/// 避免切图被裁切或拉伸。支持单色背景或渐变背景。
class WelfareRewardBubble extends StatelessWidget {
  const WelfareRewardBubble({
    super.key,
    this.background,
    this.gradientStart,
    this.gradientEnd,
    required this.child,
    this.border,
    this.padding,
  }) : assert(
         (background != null && gradientStart == null && gradientEnd == null) ||
             (background == null &&
                 gradientStart != null &&
                 gradientEnd != null),
         'Either provide background OR both gradientStart and gradientEnd',
       );

  final Color? background;
  final Color? gradientStart;
  final Color? gradientEnd;
  final Color? border;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  /// 默认内边距：内容四周留白 + 底部预留尾巴高度。
  static const EdgeInsets defaultPadding = EdgeInsets.only(
    left: AppSpacing.xs,
    right: AppSpacing.xs,
    top: AppSpacing.xxs,
    bottom: AppSpacing.xxs + AppSizes.welfareTaskTimelineTailHeight,
  );

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BubblePainter(
        background: background,
        gradientStart: gradientStart,
        gradientEnd: gradientEnd,
        border: border,
      ),
      child: Padding(padding: padding ?? defaultPadding, child: child),
    );
  }
}

class _BubblePainter extends CustomPainter {
  const _BubblePainter({
    this.background,
    this.gradientStart,
    this.gradientEnd,
    this.border,
  });

  final Color? background;
  final Color? gradientStart;
  final Color? gradientEnd;
  final Color? border;

  Path _buildPath(Size size) {
    const tailWidth = AppSizes.welfareTaskTimelineTailWidth;
    const tailHeight = AppSizes.welfareTaskTimelineTailHeight;
    const radius = AppRadius.welfareTaskBubble;
    final bodyBottom = size.height - tailHeight;
    final centerX = size.width / 2;
    final body = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, bodyBottom),
      const Radius.circular(radius),
    );
    return Path()
      ..addRRect(body)
      ..moveTo(centerX - tailWidth / 2, bodyBottom)
      ..lineTo(centerX, size.height)
      ..lineTo(centerX + tailWidth / 2, bodyBottom)
      ..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final path = _buildPath(size);

    // 绘制背景（单色或渐变）
    final Paint backgroundPaint = Paint();
    if (background != null) {
      backgroundPaint.color = background!;
    } else if (gradientStart != null && gradientEnd != null) {
      backgroundPaint.shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [gradientStart!, gradientEnd!],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    }
    canvas.drawPath(path, backgroundPaint);

    // 绘制描边
    if (border != null) {
      canvas.drawPath(
        path,
        Paint()
          ..color = border!
          ..style = PaintingStyle.stroke
          ..strokeWidth = AppSizes.hairline,
      );
    }
  }

  @override
  bool shouldRepaint(_BubblePainter oldDelegate) =>
      oldDelegate.background != background ||
      oldDelegate.gradientStart != gradientStart ||
      oldDelegate.gradientEnd != gradientEnd ||
      oldDelegate.border != border;
}
