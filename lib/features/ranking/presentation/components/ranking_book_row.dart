import 'package:flutter/material.dart';

import '../../../../core/domain/entities/book.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../../../shared/widgets/book_cover.dart';

/// 榜单书行（Figma 220:8539）：左封面 80x109 + 右标题/分类。
class RankingBookRow extends StatelessWidget {
  const RankingBookRow({
    super.key,
    required this.book,
    this.onTap,
  });

  final Book book;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BookCover(
            assetPath: book.coverAsset,
            width: AppSizes.rankingBookRowCoverWidth,
            height: AppSizes.rankingBookRowCoverHeight,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: SizedBox(
              height: AppSizes.rankingBookRowCoverHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    book.title,
                    style: AppTextStyles.bookTitleDark,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: AppSizes.rankingBookRowTitleCategoryGap,
                  ),
                  AppText(
                    book.category,
                    style: AppTextStyles.bookTagDark,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
