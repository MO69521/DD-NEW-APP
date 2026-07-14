import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/welfare_models.dart';
import '../mappers/welfare_asset_mapper.dart';
import '../../../../core/theme/app_welfare_colors.dart';

/// L3 组件 — 7 日签到日历网格（Figma 1492:2765）。
///
/// 统一 4 列网格，两行列边界严格对齐：
/// 行1: 4 等宽卡片（含今日）
/// 行2: [第5][第6][第7天 = 2 列宽 + 1 列间隙]
class CheckInCalendar extends StatelessWidget {
  const CheckInCalendar({super.key, required this.days});

  final List<CheckInDay> days;

  static const double _gap = AppSpacing.xs;

  @override
  Widget build(BuildContext context) {
    assert(days.length == 7, 'CheckInCalendar expects exactly 7 days');

    return LayoutBuilder(
      builder: (context, constraints) {
        final cellWidth = (constraints.maxWidth - _gap * 3) / 4;
        final wideWidth = cellWidth * 2 + _gap;

        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < 4; i++) ...[
                  if (i > 0) const SizedBox(width: _gap),
                  SizedBox(
                    width: cellWidth,
                    child: _CheckInDayCard(day: days[i]),
                  ),
                ],
              ],
            ),
            const SizedBox(height: _gap),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: cellWidth, child: _CheckInDayCard(day: days[4])),
                const SizedBox(width: _gap),
                SizedBox(width: cellWidth, child: _CheckInDayCard(day: days[5])),
                const SizedBox(width: _gap),
                SizedBox(width: wideWidth, child: _CheckInDayCard(day: days[6])),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _CheckInDayCard extends StatelessWidget {
  const _CheckInDayCard({required this.day});

  final CheckInDay day;

  bool get _isToday => day.status == CheckInDayStatus.today;
  bool get _isClaimed => day.status == CheckInDayStatus.claimed;

  @override
  Widget build(BuildContext context) {
    final bodyColor = _isToday
        ? AppWelfareColors.checkInHighlightBg
        : AppWelfareColors.checkInDayBg;
    final headerColor = _isToday
        ? AppWelfareColors.checkInHighlightHeader
        : AppWelfareColors.checkInDayHeader;
    final borderColor = _isToday
        ? AppWelfareColors.checkInHighlightBorder
        : AppWelfareColors.checkInDayBorder;
    final borderWidth = _isToday
        ? AppSizes.borderWidthEmphasis
        : AppSizes.hairline;

    return Container(
      decoration: BoxDecoration(
        color: bodyColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xxs,
              vertical: AppSpacing.xs,
            ),
            color: headerColor,
            child: Center(
              child: _isClaimed
                  ? Opacity(
                      opacity: AppSizes.welfareCheckInClaimedRewardOpacity,
                      child: AppText(
                        day.displayLabel,
                        style: AppTextStyles.welfareCheckInDayLabelMuted
                            .copyWith(color: AppColors.textOnDark),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  : AppText(
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
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: _isClaimed
                ? Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      _RewardContent(day: day, isToday: false, isClaimed: true),
                      // 对勾与图标区域（顶部）居中对齐：与奖励图标同尺寸、贴顶。
                      const SizedBox(
                        height: AppSizes.welfareCheckInRewardIconSize,
                        child: Center(
                          child: AppAssetImage(
                            assetPath:
                                'assets/icons/welfare/check_in_claimed.svg',
                            width: AppSizes.welfareCheckInClaimedCheckSize,
                            height: AppSizes.welfareCheckInClaimedCheckSize,
                          ),
                        ),
                      ),
                    ],
                  )
                : _RewardContent(day: day, isToday: _isToday),
          ),
        ],
      ),
    );
  }
}

class _RewardContent extends StatelessWidget {
  const _RewardContent({
    required this.day,
    required this.isToday,
    this.isClaimed = false,
  });

  final CheckInDay day;
  final bool isToday;
  final bool isClaimed;

  Widget _rewardIcon(CheckInReward reward) {
    final icon = AppAssetImage(
      assetPath: WelfareAssetMapper.checkInRewardIconAsset(reward.type),
      width: AppSizes.welfareCheckInRewardIconSize,
      height: AppSizes.welfareCheckInRewardIconSize,
    );
    if (!isClaimed) return icon;
    return Opacity(
      opacity: AppSizes.welfareCheckInClaimedIconOpacity,
      child: icon,
    );
  }

  Widget _rewardLabelText(CheckInReward reward) {
    final label = AppText(
      _rewardLabel(reward),
      style: isToday
          ? AppTextStyles.welfareCheckInRewardToday
          : AppTextStyles.welfareCheckInReward,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );
    if (!isClaimed) return label;
    return Opacity(
      opacity: AppSizes.welfareCheckInClaimedRewardOpacity,
      child: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (day.rewards.length == 1) {
      final reward = day.rewards.first;
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _rewardIcon(reward),
          const SizedBox(height: AppSpacing.xs),
          _rewardLabelText(reward),
        ],
      );
    }

    return Row(
      children: day.rewards.map((reward) {
        return Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _rewardIcon(reward),
              const SizedBox(height: AppSpacing.xs),
              _rewardLabelText(reward),
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
