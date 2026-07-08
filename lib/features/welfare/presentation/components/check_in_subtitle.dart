import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_welfare_colors.dart';

/// L3 — 签到副标题：「已累计签到 X 天，再签到 Y 天可领丰厚奖励」。
///
/// 每日签到区块与签到成功弹窗共用。
class CheckInSubtitle extends StatelessWidget {
  const CheckInSubtitle({
    super.key,
    required this.totalDays,
    required this.daysUntilNextReward,
  });

  final int totalDays;
  final int daysUntilNextReward;

  @override
  Widget build(BuildContext context) {
    final highlightStyle = AppTextStyles.welfareSubtitle.copyWith(
      color: AppWelfareColors.accentOrange,
    );

    return RichText(
      softWrap: true,
      text: TextSpan(
        style: AppTextStyles.welfareSubtitle.copyWith(
          color: AppWelfareColors.subtitleMuted,
        ),
        children: [
          const TextSpan(text: '已累计签到 '),
          TextSpan(text: '$totalDays', style: highlightStyle),
          const TextSpan(text: ' 天，再签到 '),
          TextSpan(text: '$daysUntilNextReward', style: highlightStyle),
          const TextSpan(text: ' 天可领丰厚奖励'),
        ],
      ),
    );
  }
}
