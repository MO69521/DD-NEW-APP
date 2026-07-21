import 'package:flutter/material.dart';

import '../../core/domain/entities/book_cover_bottom_badge.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_icon_assets.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../widgets/app_asset_image.dart';
import '../widgets/app_text.dart';

/// L2 — 书籍封面右下角运营标签：热度或红色活动文案。
class BookCoverBottomBadgeView extends StatelessWidget {
  const BookCoverBottomBadgeView({super.key, required this.badge});

  final BookCoverBottomBadge badge;

  @override
  Widget build(BuildContext context) {
    final isPopularity = badge.type == BookCoverBottomBadgeType.popularity;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxs,
        vertical: AppSpacing.xxsHalf,
      ),
      decoration: BoxDecoration(
        color: isPopularity
            ? AppColors.bookCoverBottomPopularityBackground
            : AppColors.bookCoverBottomPromotionBackground,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isPopularity) ...[
            const AppAssetImage(
              assetPath: AppIconAssets.hotFlame,
              width: AppSizes.bookCoverTagIconSize,
              height: AppSizes.bookCoverTagIconSize,
              color: AppColors.bookCoverBottomPopularityIcon,
            ),
            const SizedBox(width: AppSpacing.xxsHalf),
          ],
          AppText(
            badge.label,
            style: AppTextStyles.bookCoverTagLabel.copyWith(
              color: AppColors.bookCoverBottomBadgeText,
            ),
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
