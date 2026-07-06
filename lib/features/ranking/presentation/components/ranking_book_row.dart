import 'package:flutter/material.dart';

import '../../../../core/domain/entities/book.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/components/book_card_large_row.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_text.dart';

/// L3 — 榜单书行：映射到共享 [BookCardLargeRow]（大封面 + 标题/分类）。
class RankingBookRow extends StatelessWidget {
  const RankingBookRow({
    super.key,
    required this.book,
    required this.rank,
    this.onTap,
  });

  final Book book;
  final int rank;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return BookCardLargeRow(
      coverAsset: book.coverAsset,
      title: book.title,
      meta: book.category,
      description: book.summary,
      titleMaxLines: 2,
      leadingBadge: _RankingRowBadge(rank: rank),
      padding: EdgeInsets.zero,
      onTap: onTap,
    );
  }
}

class _RankingRowBadge extends StatelessWidget {
  const _RankingRowBadge({required this.rank});

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
      decoration: BoxDecoration(
        color: AppColors.overlayScrim,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: AppText(
        '$rank',
        style: AppTextStyles.labelMedium.copyWith(
          color: AppColors.textOnDark,
          height: 1.0,
        ),
      ),
    );
  }
}
