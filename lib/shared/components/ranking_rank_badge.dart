import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_text_styles.dart';
import '../widgets/app_asset_image.dart';
import '../widgets/app_text.dart';

/// L2 — 榜单封面左上角名次角标。
///
/// 前三名使用专属切图；第 4 名起使用统一深色底数字角标，
/// 仅右下角保留圆角。
class RankingRankBadge extends StatelessWidget {
  const RankingRankBadge({super.key, required this.rank});

  final int rank;

  static const Map<int, String> _topRankAssets = {
    1: 'assets/icons/ranking/rank_1.png',
    2: 'assets/icons/ranking/rank_2.png',
    3: 'assets/icons/ranking/rank_3.png',
  };

  @override
  Widget build(BuildContext context) {
    final asset = _topRankAssets[rank];
    if (asset != null) {
      return AppAssetImage(
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
          bottomRight: Radius.circular(AppRadius.md),
        ),
      ),
      child: AppText(
        '$rank',
        style: AppTextStyles.labelMedium.copyWith(
          color: AppColors.textOnDark,
          height: AppLineHeights.none,
        ),
      ),
    );
  }
}
