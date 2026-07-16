import 'package:flutter/material.dart';

import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_welfare_colors.dart';

/// 福利进度时间线节点圆点：已达/可领为橙色实心，未达为灰底，统一 2px 描边环。
///
/// 任务时间线（看视频 / 阅读时长奖励）与 7 日阅读福利进度共用同一实现，
/// 保证所有进度节点样式一致（三主题经 `_isLight` 分支自动解析）。
class WelfareTimelineDot extends StatelessWidget {
  const WelfareTimelineDot({super.key, required this.isHighlighted});

  /// 已达成或当前可领节点为高亮（橙色）。
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.welfareTaskTimelineDotSize,
      height: AppSizes.welfareTaskTimelineDotSize,
      decoration: BoxDecoration(
        color: isHighlighted
            ? AppWelfareColors.taskTimelineDotReached
            : AppWelfareColors.taskTimelineDot,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppWelfareColors.taskTimelineDotBorder,
          width: AppSizes.welfareTaskTimelineDotBorderWidth,
        ),
      ),
    );
  }
}
