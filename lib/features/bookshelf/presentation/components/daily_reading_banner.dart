import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/animated_count_text.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text.dart';

/// 今日阅读横幅（Figma 220:9725 / 377:1909）：白熊插画 + 阅读时长 + 领福利。
class DailyReadingBanner extends StatelessWidget {
  const DailyReadingBanner({
    super.key,
    required this.todayReadingMinutes,
    required this.onClaimWelfareTap,
  });

  final int todayReadingMinutes;
  final VoidCallback onClaimWelfareTap;

  static const String _bearAsset = 'assets/images/bookshelf/reading_bear.png';
  static const String _energyIconAsset = 'assets/icons/welfare/energy.svg';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.bookshelfReadingBannerHeight,
      decoration: BoxDecoration(
        color: AppColors.surfaceGlass,
        borderRadius: BorderRadius.circular(AppRadius.bookshelfReadingBanner),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: AppSizes.bookshelfBearIllustrationInset,
            top: AppSizes.bookshelfBearIllustrationInset,
            width: AppSizes.bookshelfBearIllustrationWidth,
            height: AppSizes.bookshelfBearIllustrationPaintHeight,
            child: AppAssetImage(
              assetPath: _bearAsset,
              width: AppSizes.bookshelfBearIllustrationWidth,
              height: AppSizes.bookshelfBearIllustrationPaintHeight,
              fit: BoxFit.fitWidth,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: AppSizes.bookshelfReadingBannerContentInsetLeft,
              right: AppSpacing.sm,
              top: AppSpacing.sm,
              bottom: AppSpacing.sm,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: _ReadingMinutesText(minutes: todayReadingMinutes),
                ),
                _ClaimWelfareButton(onTap: onClaimWelfareTap),
              ],
            ),
          ),
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
          style: AppTextStyles.bookshelfReadingLabel.copyWith(
            color: AppColors.textOnDarkPlaceholder,
          ),
        ),
        AnimatedCountText(
          value: minutes,
          style: AppTextStyles.bookshelfReadingMinutes.copyWith(
            color: AppColors.textOnDark,
          ),
        ),
        AppText(
          ' 分钟',
          style: AppTextStyles.bookshelfReadingLabel.copyWith(
            color: AppColors.textOnDarkPlaceholder,
          ),
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
      leadingIcon: AppAssetImage(
        assetPath: DailyReadingBanner._energyIconAsset,
        width: AppSizes.bookshelfClaimWelfareIconSize,
        height: AppSizes.bookshelfClaimWelfareIconSize,
      ),
      iconLabelGap: AppSizes.buttonIconLabelGapTight,
    );
  }
}
