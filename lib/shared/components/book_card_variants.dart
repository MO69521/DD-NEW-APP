import 'package:flutter/material.dart';

import '../../core/domain/entities/book_cover_tag.dart';
import '../../core/domain/entities/book_cover_bottom_badge.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../widgets/app_pressable.dart';
import '../widgets/app_text.dart';
import '../widgets/book_cover.dart';
import '../../core/theme/app_colors.dart';
import 'book_card_surface.dart';
import 'book_cover_bottom_badge.dart';
import 'book_cover_tag_badge.dart';

/// 网格变体：上图下文。
class BookCardVertical extends StatelessWidget {
  const BookCardVertical({
    super.key,
    required this.title,
    required this.category,
    required this.coverAsset,
    this.coverTag,
    this.coverBottomBadge,
    this.onTap,
    this.heroTag,
    this.showCardBackground = false,
  });

  final String title;
  final String category;
  final String coverAsset;
  final BookCoverTag? coverTag;
  final BookCoverBottomBadge? coverBottomBadge;
  final VoidCallback? onTap;
  final Object? heroTag;

  /// 是否为整张卡片（封面 + 文本）铺一层卡面底（[BookCardSurface]）。
  /// 默认关闭。书架网格已关闭卡面底，与页底白面一体。
  final bool showCardBackground;

  @override
  Widget build(BuildContext context) {
    final cover = BookCover(
      assetPath: coverAsset,
      aspectRatio: AppSizes.bookCoverGridAspectRatio,
      heroTag: heroTag,
      topEndBadge: coverTag == null ? null : BookCoverTagBadge(tag: coverTag!),
      bottomEndBadge: coverBottomBadge == null
          ? null
          : BookCoverBottomBadgeView(badge: coverBottomBadge!),
    );
    final textContent = _BookCardTextContent(
      title: title,
      category: category,
      titleStyle: AppTextStyles.bookGridTitleDark.copyWith(
        color: AppColors.textOnDark,
      ),
      titleMaxLines: 2,
      titleCategoryGap: AppSizes.bookGridTitleCategoryGap,
      fixedHeight: AppSizes.bookGridTextBlockHeight,
      pinCategoryBottom: false,
    );

    final content = showCardBackground
        ? BookCardSurface(
            contentPadding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                cover,
                Padding(
                  padding: const EdgeInsets.only(
                    left: BookCardSurface.padding,
                    top: AppSizes.bookGridCoverToTextGap,
                    right: BookCardSurface.padding,
                    bottom: BookCardSurface.padding,
                  ),
                  child: textContent,
                ),
              ],
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              cover,
              const SizedBox(height: AppSizes.bookGridCoverToTextGap),
              textContent,
            ],
          );

    return AppPressable(onTap: onTap, child: content);
  }
}

/// 榜单紧凑变体（Figma 456:12299）：上图下文，封面 132:179。
class BookCardRankingCompact extends StatelessWidget {
  const BookCardRankingCompact({
    super.key,
    required this.title,
    required this.category,
    required this.coverAsset,
    this.onTap,
  });

  final String title;
  final String category;
  final String coverAsset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BookCover(
            assetPath: coverAsset,
            aspectRatio: AppSizes.bookCoverRankingAspectRatio,
          ),
          const SizedBox(height: AppSpacing.xs),
          _BookCardTextContent(
            title: title,
            category: category,
            titleStyle: AppTextStyles.bookTitleDark.copyWith(
              color: AppColors.textOnDark,
            ),
            titleMaxLines: 2,
            titleCategoryGap: AppSpacing.sm,
            fixedHeight: AppSizes.rankingCompactTextBlockHeight,
            pinCategoryBottom: false,
          ),
        ],
      ),
    );
  }
}

/// 榜单变体：左图右文（旧版，保留供回滚）。
class BookCardHorizontal extends StatelessWidget {
  const BookCardHorizontal({
    super.key,
    required this.title,
    required this.category,
    required this.coverAsset,
    this.coverWidth = AppSizes.bookCoverListWidth,
    this.coverHeight = AppSizes.bookCoverListHeight,
    this.onTap,
  });

  final String title;
  final String category;
  final String coverAsset;
  final double coverWidth;
  final double coverHeight;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BookCover(
            assetPath: coverAsset,
            width: coverWidth,
            height: coverHeight,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: _BookCardTextContent(
              title: title,
              category: category,
              titleStyle: AppTextStyles.bookTitleDark.copyWith(
                color: AppColors.textOnDark,
              ),
              titleMaxLines: 2,
              titleCategoryGap: AppSpacing.xs,
              fixedHeight: coverHeight,
              pinCategoryBottom: false,
            ),
          ),
        ],
      ),
    );
  }
}

/// 卡片公共文本区：标题 + 分类小字。
class _BookCardTextContent extends StatelessWidget {
  const _BookCardTextContent({
    required this.title,
    required this.category,
    required this.titleStyle,
    required this.titleMaxLines,
    required this.titleCategoryGap,
    required this.fixedHeight,
    required this.pinCategoryBottom,
  });

  final String title;
  final String category;
  final TextStyle titleStyle;
  final int titleMaxLines;
  final double titleCategoryGap;
  final double fixedHeight;
  final bool pinCategoryBottom;

  @override
  Widget build(BuildContext context) {
    final tagStyle = AppTextStyles.bookTagDark.copyWith(
      color: AppColors.textOnDarkMuted,
    );

    final content = pinCategoryBottom
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                title,
                style: titleStyle,
                maxLines: titleMaxLines,
                overflow: TextOverflow.ellipsis,
              ),
              AppText(
                category,
                style: tagStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                title,
                style: titleStyle,
                maxLines: titleMaxLines,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: titleCategoryGap),
              AppText(
                category,
                style: tagStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          );

    return SizedBox(height: fixedHeight, child: content);
  }
}
