import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_text_styles.dart';
import '../widgets/app_icon.dart';
import '../widgets/app_text.dart';

/// L2 — 榜单封面左上角名次角标。
///
/// 前三名使用专属切图；第 4 名起使用统一深色底数字角标，
/// 左上角贴合封面 `bookCover` 圆角，右下角 `md` 圆角。
class RankingRankBadge extends StatelessWidget {
  const RankingRankBadge({super.key, required this.rank});

  final int rank;

  static const Map<int, String> _topRankAssets = {
    1: 'assets/icons/ranking/rank_1.svg',
    2: 'assets/icons/ranking/rank_2.svg',
    3: 'assets/icons/ranking/rank_3.svg',
  };

  @override
  Widget build(BuildContext context) {
    final asset = _topRankAssets[rank];
    if (asset != null) {
      return AppIcon(
        assetPath: asset,
        width: AppSizes.rankingTopBadgeSize,
        height: AppSizes.rankingTopBadgeSize,
      );
    }

    return Container(
      width: AppSizes.rankingMutedBadgeSize,
      height: AppSizes.rankingMutedBadgeSize,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.rankingMutedBadgeScrim,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.bookCover),
          bottomRight: Radius.circular(AppRadius.md),
        ),
      ),
      child: AppText(
        '$rank',
        style: AppTextStyles.labelMedium.copyWith(
          color: AppColors.rankingMutedBadgeText,
          height: AppLineHeights.none,
        ),
      ),
    );
  }
}
