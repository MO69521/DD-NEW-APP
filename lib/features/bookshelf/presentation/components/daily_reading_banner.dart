import 'package:flutter/material.dart';

import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/animated_count_text.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text.dart';

/// 今日阅读横幅：阅读时长文案 + 领福利（无插画、无底填充）。
///
/// 高度固定为 [AppSizes.bookshelfClaimWelfareCtaHeight]，与书架吸顶 Chrome
/// 占位一致（三主题共用）。
class DailyReadingBanner extends StatelessWidget {
  const DailyReadingBanner({
    super.key,
    required this.todayReadingMinutes,
    required this.onClaimWelfareTap,
  });

  final int todayReadingMinutes;
  final VoidCallback onClaimWelfareTap;

  static const String _energyIconAsset = 'assets/icons/welfare/energy.svg';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.bookshelfClaimWelfareCtaHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: _ReadingMinutesText(minutes: todayReadingMinutes),
            ),
          ),
          _ClaimWelfareButton(onTap: onClaimWelfareTap),
        ],
      ),
    );
  }
}

class _ReadingMinutesText extends StatelessWidget {
  const _ReadingMinutesText({required this.minutes});

  final int minutes;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        AppText(
          '今日已阅读 ',
          style: AppTextStyles.bookshelfReadingLabel,
        ),
        AnimatedCountText(
          value: minutes,
          style: AppTextStyles.bookshelfReadingMinutes,
        ),
        AppText(
          ' 分钟',
          style: AppTextStyles.bookshelfReadingLabel,
        ),
      ],
    );
  }
}

class _ClaimWelfareButton extends StatelessWidget {
  const _ClaimWelfareButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: '领福利',
      variant: AppButtonVariant.accent,
      size: AppButtonSize.small,
      onPressed: onTap,
      leadingIcon: const AppAssetImage(
        assetPath: DailyReadingBanner._energyIconAsset,
        width: AppSizes.bookshelfClaimWelfareIconSize,
        height: AppSizes.bookshelfClaimWelfareIconSize,
      ),
      iconLabelGap: AppSizes.buttonIconLabelGapTight,
    );
  }
}
