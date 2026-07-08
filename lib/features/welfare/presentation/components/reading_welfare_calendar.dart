import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_welfare_colors.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/welfare_models.dart';
import '../mappers/welfare_asset_mapper.dart';

/// L3 组件 — 7 日阅读福利日历（Figma 519:8876）。
class ReadingWelfareCalendar extends StatelessWidget {
  const ReadingWelfareCalendar({super.key, required this.days});

  final List<ReadingWelfareDay> days;

  static int _flexForDay(ReadingWelfareDay day, {required bool isSecondRow}) {
    if (isSecondRow && day.dayIndex == 7) return 2;
    return 1;
  }

  Widget _buildRow(
    List<ReadingWelfareDay> rowDays, {
    required bool isSecondRow,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < rowDays.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.xs),
          Expanded(
            flex: _flexForDay(rowDays[i], isSecondRow: isSecondRow),
            child: _ReadingWelfareDayCard(day: rowDays[i]),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(days.length == 7, 'ReadingWelfareCalendar expects exactly 7 days');

    return Column(
      children: [
        _buildRow(days.sublist(0, 4), isSecondRow: false),
        const SizedBox(height: AppSpacing.xs),
        _buildRow(days.sublist(4, 7), isSecondRow: true),
      ],
    );
  }
}

class _ReadingWelfareDayCard extends StatelessWidget {
  const _ReadingWelfareDayCard({required this.day});

  final ReadingWelfareDay day;

  bool get _isToday => day.status == CheckInDayStatus.today;

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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppAssetImage(
                  assetPath: WelfareAssetMapper.checkInRewardIconAsset(
                    CheckInRewardType.energy,
                  ),
                  width: AppSizes.welfareCheckInRewardIconSize,
                  height: AppSizes.welfareCheckInRewardIconSize,
                ),
                const SizedBox(height: AppSpacing.xs),
                AppText(
                  '${day.rewardMinutes}分钟',
                  style: _isToday
                      ? AppTextStyles.welfareCheckInRewardToday
                      : AppTextStyles.welfareCheckInReward,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
