import 'package:flutter/material.dart';

import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_welfare_colors.dart';

/// 进度条里程碑节点圆点（Figma Ellipse524：fill #1B212A，stroke #121721，2px）。
class CheckInProgressDot extends StatelessWidget {
  const CheckInProgressDot({super.key, this.reached = false});

  final bool reached;

  @override
  Widget build(BuildContext context) {
    const dotSize = AppSizes.welfareCheckInProgressDotSize;

    return Container(
      width: dotSize,
      height: dotSize,
      decoration: BoxDecoration(
        color: reached
            ? AppWelfareColors.checkInProgressFill
            : AppWelfareColors.checkInProgressDotFill,
        shape: BoxShape.circle,
        border: Border.all(
          color: reached
              ? AppWelfareColors.checkInProgressFill
              : AppWelfareColors.checkInProgressDotStroke,
          width: AppSizes.welfareCheckInProgressDotBorderWidth,
        ),
      ),
    );
  }
}
