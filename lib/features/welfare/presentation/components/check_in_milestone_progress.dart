import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_welfare_colors.dart';
import '../../domain/entities/welfare_models.dart';
import 'check_in_cumulative_badge.dart';
import 'check_in_milestone_bubble.dart';
import 'check_in_progress_dot.dart';

/// 里程碑列中心在进度段内的 x 坐标。
List<double> checkInMilestoneCenterXs({
  required int milestoneCount,
  required double segmentWidth,
}) {
  return List<double>.generate(
    milestoneCount,
    (index) => segmentWidth * (index + 0.5) / milestoneCount,
  );
}

/// 按里程碑天数分段插值，计算进度段内橙色填充宽度（Figma 520:9226）。
double computeCheckInSegmentFillWidth({
  required int totalDays,
  required List<CheckInMilestone> milestones,
  required double segmentWidth,
}) {
  if (milestones.isEmpty || segmentWidth <= 0) {
    return 0;
  }

  if (totalDays <= 0) {
    return 0;
  }

  final milestoneXs = checkInMilestoneCenterXs(
    milestoneCount: milestones.length,
    segmentWidth: segmentWidth,
  );

  final first = milestones.first;
  if (totalDays <= first.requiredDays) {
    return milestoneXs.first * totalDays / first.requiredDays;
  }

  for (var index = 0; index < milestones.length - 1; index++) {
    final current = milestones[index];
    final next = milestones[index + 1];
    if (totalDays <= next.requiredDays) {
      final segmentProgress =
          (totalDays - current.requiredDays) /
          (next.requiredDays - current.requiredDays);
      return milestoneXs[index] +
          (milestoneXs[index + 1] - milestoneXs[index]) * segmentProgress;
    }
  }

  return milestoneXs.last;
}

/// L3 组件 — 累计签到进度条 + 里程碑气泡（Figma 520:9226）。
class CheckInMilestoneProgress extends StatelessWidget {
  const CheckInMilestoneProgress({
    super.key,
    required this.totalDays,
    required this.milestones,
    this.cumulativeBadgeTitle = '累计签到',
    this.cumulativeBadgeValue,
    this.milestoneLabels,
  });

  final int totalDays;
  final List<CheckInMilestone> milestones;
  final String cumulativeBadgeTitle;
  final int? cumulativeBadgeValue;
  final List<String>? milestoneLabels;

  @override
  Widget build(BuildContext context) {
    final lineTop = AppSizes.welfareCheckInProgressLineTop;
    final lineHeight = AppSizes.welfareCheckInProgressLineHeight;

    return SizedBox(
      height: AppSizes.welfareCheckInMilestoneHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CheckInCumulativeBadge(
            title: cumulativeBadgeTitle,
            value: cumulativeBadgeValue ?? totalDays,
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final segmentWidth = constraints.maxWidth;
                final filledWidth = computeCheckInSegmentFillWidth(
                  totalDays: totalDays,
                  milestones: milestones,
                  segmentWidth: segmentWidth,
                );
                final milestoneXs = checkInMilestoneCenterXs(
                  milestoneCount: milestones.length,
                  segmentWidth: segmentWidth,
                );
                final dotSize = AppSizes.welfareCheckInProgressDotSize;
                final dotTop =
                    AppSizes.welfareCheckInProgressLineCenterY - dotSize / 2;

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      top: lineTop,
                      child: Container(
                        height: lineHeight,
                        decoration: BoxDecoration(
                          color: AppWelfareColors.checkInProgressTrack,
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: filledWidth,
                          height: lineHeight,
                          decoration: BoxDecoration(
                            color: AppWelfareColors.checkInProgressFill,
                            borderRadius: BorderRadius.circular(AppRadius.full),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        for (var index = 0; index < milestones.length; index++)
                          Expanded(
                            child: CheckInMilestoneBubble(
                              milestone: milestones[index],
                              milestoneLabel:
                                  milestoneLabels != null &&
                                      index < milestoneLabels!.length
                                  ? milestoneLabels![index]
                                  : null,
                            ),
                          ),
                      ],
                    ),
                    for (var index = 0; index < milestones.length; index++)
                      Positioned(
                        left: milestoneXs[index] - dotSize / 2,
                        top: dotTop,
                        child: const CheckInProgressDot(),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
