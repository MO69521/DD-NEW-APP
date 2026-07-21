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
  // 已领取 / 还不能领取：与行内奖励角标同底（深色 4% 白 / 浅色弱实体面）；
  // 原 surfaceCard 与福利卡片容器同色导致气泡不可见。已领取仅内容降 30%，背景保持实体。
  return (
    background: AppWelfareColors.taskRewardChipBg,
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
