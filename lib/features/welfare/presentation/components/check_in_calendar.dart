import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/welfare_models.dart';
import '../mappers/welfare_asset_mapper.dart';
import '../../../../core/theme/app_welfare_colors.dart';

/// L3 组件 — 7 日签到日历网格（Figma 519:8475）。
///
/// 行1: 4 等宽卡片（含今日）
/// 行2: [1] [1] [2 第7天]
class CheckInCalendar extends StatelessWidget {
  const CheckInCalendar({super.key, required this.days});

  final List<CheckInDay> days;

  static int _flexForDay(CheckInDay day, {required bool isSecondRow}) {
    if (isSecondRow && day.rewards.length >= 3) return 2;
    return 1;
  }

  Widget _buildRow(List<CheckInDay> rowDays, {required bool isSecondRow}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < rowDays.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.xs),
          Expanded(
            flex: _flexForDay(rowDays[i], isSecondRow: isSecondRow),
            child: _CheckInDayCard(day: rowDays[i]),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(days.length == 7, 'CheckInCalendar expects exactly 7 days');

    return Column(
      children: [
        _buildRow(days.sublist(0, 4), isSecondRow: false),
        const SizedBox(height: AppSpacing.xs),
        _buildRow(days.sublist(4, 7), isSecondRow: true),
      ],
    );
  }
}

class _CheckInDayCard extends StatelessWidget {
  const _CheckInDayCard({required this.day});

  final CheckInDay day;

  bool get _isToday => day.status == CheckInDayStatus.today;

  @override
  Widget build(BuildContext context) {
    final bodyColor = _isToday
        ? AppWelfareColors.checkInHighlightBg
        : AppWelfareColors.checkInDayBg;
    final headerColor = _isToday
        ? AppWelfareColors.checkInHighlightHeader
        : AppWelfareColors.checkInDayHeader;

    return Container(
      decoration: BoxDecoration(
        color: bodyColor,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: AppWelfareColors.checkInDayBorder,
          width: AppSizes.hairline,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xxs,
              AppSizes.welfareCheckInDayHeaderPaddingTop,
              AppSpacing.xxs,
              AppSizes.welfareCheckInDayHeaderPaddingBottom,
            ),
            color: headerColor,
            child: Center(
              child: AppText(
                day.displayLabel,
                style: _isToday
                    ? AppTextStyles.welfareCheckInDayLabelToday
                    : AppTextStyles.welfareCheckInDayLabelMuted,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppSizes.welfareCheckInDayBodyPaddingVertical,
            ),
            child: _RewardContent(day: day, isToday: _isToday),
          ),
        ],
      ),
    );
  }
}

class _RewardContent extends StatelessWidget {
  const _RewardContent({required this.day, required this.isToday});

  final CheckInDay day;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    if (day.rewards.length == 1) {
      final reward = day.rewards.first;
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppAssetImage(
            assetPath: WelfareAssetMapper.checkInRewardIconAsset(reward.type),
            width: AppSizes.welfareCheckInRewardIconSize,
            height: AppSizes.welfareCheckInRewardIconSize,
          ),
          const SizedBox(height: AppSpacing.insetXs),
          AppText(
            _rewardLabel(reward),
            style: isToday
                ? AppTextStyles.welfareCheckInRewardToday
                : AppTextStyles.welfareCheckInReward,
          ),
        ],
      );
    }

    return Row(
      children: day.rewards.map((reward) {
        return Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppAssetImage(
                assetPath: WelfareAssetMapper.checkInRewardIconAsset(
                  reward.type,
                ),
                width: AppSizes.welfareCheckInRewardIconSize,
                height: AppSizes.welfareCheckInRewardIconSize,
              ),
              const SizedBox(height: AppSpacing.insetXs),
              AppText(
                _rewardLabel(reward),
                style: AppTextStyles.welfareCheckInReward,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _rewardLabel(CheckInReward reward) {
    if (reward.label != null) return reward.label!;
    if (reward.type == CheckInRewardType.stardust) {
      return '+${reward.amount}';
    }
    return '+ ${reward.amount}';
  }
}
