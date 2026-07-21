import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_welfare_colors.dart';
import '../../../../shared/widgets/app_text.dart';

/// 左侧「累计签到 N 天」卡片（Figma 519:8475）。
class CheckInCumulativeBadge extends StatelessWidget {
  const CheckInCumulativeBadge({
    super.key,
    required this.value,
    this.title = '累计签到',
  });

  final int value;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppWelfareColors.checkInDayBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: AppSizes.welfareCheckInCumulativePadding,
              top: AppSizes.welfareCheckInDayHeaderPaddingTop,
              right: AppSizes.welfareCheckInCumulativePadding,
              bottom: AppSizes.welfareCheckInDayHeaderPaddingBottom,
            ),
            color: AppWelfareColors.checkInDayHeader,
            child: AppText(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.welfareCheckInCumulativeLabel.copyWith(
                color: AppWelfareColors.checkInDayLabelMuted,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: AppText(
                '$value',
                textAlign: TextAlign.center,
                style: AppTextStyles.welfareCheckInCumulativeValue.copyWith(
                  color: AppColors.textOnDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
