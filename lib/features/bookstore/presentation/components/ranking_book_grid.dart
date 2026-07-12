import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/domain/entities/book.dart';
import '../../../../shared/components/ranking_rank_badge.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../../../shared/widgets/book_cover.dart';

/// 榜单宫格书单（2 列 × 3 行，左图右文），最多展示 6 本。
class RankingBookGrid extends StatelessWidget {
  const RankingBookGrid({
    super.key,
    required this.books,
    this.onBookTap,
    this.heroNamespace,
  });

  final List<Book> books;

  /// 回调携带该卡封面的屏内唯一 Hero 标签，供详情页同 tag 飞行。
  final void Function(Book book, Object coverHeroTag)? onBookTap;

  /// Hero 标签命名空间；非空时封面参与飞行，标签为 `book-cover-<ns>-<id>`。
  final String? heroNamespace;

  static double get contentHeight {
    final coverHeight =
        AppSizes.rankingRowCoverWidth / AppSizes.bookCoverRankingAspectRatio;
    return coverHeight * 3 + AppSpacing.md * 2;
  }

  @override
  Widget build(BuildContext context) {
    final visibleBooks = books.take(AppSizes.rankingGridMaxItems).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        const columns = 2;
        final coverWidth = AppSizes.rankingRowCoverWidth;
        // 保持封面纵横比，放大宽度时自动同步高度。
        final coverHeight = coverWidth / AppSizes.bookCoverRankingAspectRatio;
        final itemHeight = coverHeight;

        return GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            mainAxisExtent: itemHeight,
          ),
          itemCount: visibleBooks.length,
          itemBuilder: (context, index) {
            final book = visibleBooks[index];
            final heroTag = heroNamespace == null
                ? null
                : 'book-cover-$heroNamespace-${book.id}';
            return _RankingBookItem(
              title: book.title,
              category: book.category,
              coverAsset: book.coverAsset,
              coverWidth: coverWidth,
              coverHeight: coverHeight,
              rank: index + 1,
              heroTag: heroTag,
              onTap: onBookTap == null
                  ? null
                  : () => onBookTap!(book, heroTag ?? book.id),
            );
          },
        );
      },
    );
  }
}

class _RankingBookItem extends StatelessWidget {
  const _RankingBookItem({
    required this.title,
    required this.category,
    required this.coverAsset,
    required this.coverWidth,
    required this.coverHeight,
    required this.rank,
    this.heroTag,
    this.onTap,
  });

  final String title;
  final String category;
  final String coverAsset;
  final double coverWidth;
  final double coverHeight;
  final int rank;
  final Object? heroTag;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      pressScale: AppSizes.tapPressScaleSubtle,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              BookCover(
                assetPath: coverAsset,
                width: coverWidth,
                height: coverHeight,
                heroTag: heroTag,
              ),
              Positioned(top: 0, left: 0, child: RankingRankBadge(rank: rank)),
            ],
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: SizedBox(
              height: coverHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    title,
                    style: AppTextStyles.bookTitleDark.copyWith(
                      color: AppColors.textOnDark,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  AppText(
                    category,
                    style: AppTextStyles.bookTagDark.copyWith(
                      color: AppColors.textOnDarkMuted,
                    ),
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
