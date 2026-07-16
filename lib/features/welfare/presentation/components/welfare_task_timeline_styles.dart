import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_welfare_colors.dart';
import '../../domain/entities/welfare_models.dart';

/// 时间轴奖励节点三态视觉。
typedef WelfareTimelineNodeStyle = ({
  Color background,
  Color? border,
  Color text,
});

WelfareTimelineNodeStyle welfareTimelineNodeStyle(
  WelfareTaskTimelineNode node,
) {
  if (node.isActive) {
    return (
      background: AppWelfareColors.taskTimelineBubbleActive,
      border: AppWelfareColors.checkInCumulativeBorder,
      text: AppWelfareColors.checkInCtaTextDark,
    );
  }
  // 已领取 / 还不能领取：统一纯白 4% 气泡；已领取整体降到 30% 由外层处理。
  return (
    background: AppColors.surfaceCard,
    border: null,
    text: AppColors.textOnDark,
  );
}

/// 时间轴底部文案颜色：可领取白色（按钮内）、已领取白色（外层 30% 变淡）、
/// 未达成节点 60% 白。
Color welfareTimelineFooterColor(WelfareTaskTimelineNode node) {
  if (node.isActive || node.isReached) {
    return AppColors.textOnDark;
  }
  return AppWelfareColors.taskProgressLabel;
}
