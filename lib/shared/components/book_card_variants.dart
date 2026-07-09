import 'package:flutter/material.dart';

import '../../core/domain/entities/book_cover_tag.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../widgets/app_pressable.dart';
import '../widgets/app_text.dart';
import '../widgets/book_cover.dart';
import '../../core/theme/app_colors.dart';
import 'book_cover_tag_badge.dart';

/// 网格变体：上图下文。
class BookCardVertical extends StatelessWidget {
  const BookCardVertical({
    super.key,
    required this.title,
    required this.category,
    required this.coverAsset,
    this.coverTag,
    this.onTap,
    this.heroTag,
  });

  final String title;
  final String category;
  final String coverAsset;
  final BookCoverTag? coverTag;
  final VoidCallback? onTap;
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BookCover(
            assetPath: coverAsset,
            aspectRatio: AppSizes.bookCoverGridAspectRatio,
            heroTag: heroTag,
            topEndBadge: coverTag == null
                ? null
                : BookCoverTagBadge(tag: coverTag!),
          ),
          const SizedBox(height: AppSizes.bookGridCoverToTextGap),
          _BookCardTextContent(
            title: title,
            category: category,
            titleStyle: AppTextStyles.bookGridTitleDark.copyWith(
              color: AppColors.textOnDark,
            ),
            titleMaxLines: 2,
            titleCategoryGap: AppSizes.bookGridTitleCategoryGap,
            fixedHeight: AppSizes.bookGridTextBlockHeight,
            pinCategoryBottom: false,
          ),
        ],
      ),
    );
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
