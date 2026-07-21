import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_assets.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/components/app_swipe_tab_switcher.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/book_detail.dart';
import '../../domain/entities/book_detail_tab.dart';
import '../../domain/entities/book_discussion_filter.dart';
import '../../domain/entities/book_discussion_post.dart';
import '../../domain/entities/book_discussion_sort.dart';
import 'book_detail_catalog_entry.dart';
import 'book_detail_character_section.dart';
import 'book_detail_discussion_section.dart';
import 'book_detail_intro.dart';
import 'book_detail_recommendation_section.dart';
import 'book_detail_summary_card.dart';
import 'book_detail_tab_switcher.dart';
import 'book_detail_update_section.dart';

/// 书籍详情正文区：头部信息 + Tab 内容。
class BookDetailContent extends StatelessWidget {
  const BookDetailContent({
    super.key,
    required this.detail,
    required this.selectedTab,
    required this.selectedDiscussionFilter,
    required this.selectedDiscussionSort,
    this.highlightedDiscussionPostId,
    this.highlightedCommentKey,
    required this.onTabSelected,
    required this.onDiscussionFilterSelected,
    required this.onDiscussionSortSelected,
    required this.onDiscussionPostTap,
    required this.onDiscussionPostLikeTap,
    required this.onDiscussionPostBodyTap,
    required this.onCatalogTap,
    required this.onCharacterFavTap,
    required this.onRecommendationRefreshTap,
  });

  final BookDetail detail;
  final BookDetailTab selectedTab;
  final BookDiscussionFilter selectedDiscussionFilter;
  final BookDiscussionSort selectedDiscussionSort;
  final String? highlightedDiscussionPostId;
  final GlobalKey? highlightedCommentKey;
  final ValueChanged<BookDetailTab> onTabSelected;
  final ValueChanged<BookDiscussionFilter> onDiscussionFilterSelected;
  final ValueChanged<BookDiscussionSort> onDiscussionSortSelected;
  final ValueChanged<BookDiscussionPost> onDiscussionPostTap;
  final ValueChanged<BookDiscussionPost> onDiscussionPostLikeTap;
  final ValueChanged<BookDiscussionPost> onDiscussionPostBodyTap;
  final VoidCallback onCatalogTap;
  final ValueChanged<String> onCharacterFavTap;
  final VoidCallback onRecommendationRefreshTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BookDetailSummaryCard(detail: detail),
        const SizedBox(height: AppSizes.bookDetailSectionGap),
        BookDetailTabSwitcher(
          selectedTab: selectedTab,
          onTabSelected: onTabSelected,
          discussionCount: detail.discussionCount,
        ),
        const SizedBox(height: AppSizes.bookDetailSectionGap),
        AppSwipeTabSwitcher(
          selectedIndex: BookDetailTab.values.indexOf(selectedTab),
          tabCount: BookDetailTab.values.length,
          onIndexChanged: (index) => onTabSelected(BookDetailTab.values[index]),
          child: _buildTabBody(),
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  Widget _buildTabBody() {
    return switch (selectedTab) {
      BookDetailTab.detail => _DetailTabBody(
        detail: detail,
        onCatalogTap: onCatalogTap,
        onCharacterFavTap: onCharacterFavTap,
        onRecommendationRefreshTap: onRecommendationRefreshTap,
      ),
      BookDetailTab.discussion => BookDetailDiscussionSection(
        selectedFilter: selectedDiscussionFilter,
        selectedSort: selectedDiscussionSort,
        posts: detail.discussionPosts,
        highlightedPostId: highlightedDiscussionPostId,
        highlightedCommentKey: highlightedCommentKey,
        onFilterSelected: onDiscussionFilterSelected,
        onSortSelected: onDiscussionSortSelected,
        onPostTap: onDiscussionPostTap,
        onPostLikeTap: onDiscussionPostLikeTap,
        onPostBodyTap: onDiscussionPostBodyTap,
      ),
      BookDetailTab.update => BookDetailUpdateSection(
        entries: detail.updateEntries,
      ),
    };
  }
}

class _DetailTabBody extends StatelessWidget {
  const _DetailTabBody({
    required this.detail,
    required this.onCatalogTap,
    required this.onCharacterFavTap,
    required this.onRecommendationRefreshTap,
  });

  final BookDetail detail;
  final VoidCallback onCatalogTap;
  final ValueChanged<String> onCharacterFavTap;
  final VoidCallback onRecommendationRefreshTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BookDetailIntro(intro: detail.intro),
        const Divider(
          height: AppSpacing.xxl,
          thickness: AppSizes.hairline,
          color: AppColors.divider,
        ),
        BookDetailCatalogEntry(
          serialStatus: detail.serialStatus,
          onTap: onCatalogTap,
        ),
        const Divider(
          height: AppSpacing.xxl,
          thickness: AppSizes.hairline,
          color: AppColors.divider,
        ),
        BookDetailCharacterSection(
          characters: detail.characters,
          onCharacterFavTap: onCharacterFavTap,
        ),
        const SizedBox(height: AppSizes.bookDetailSectionGap),
        BookDetailRecommendationSection(
          title: '作者其他作品',
          books: detail.authorOtherBooks,
          heroNamespace: 'detail-author',
          actionLabel: '查看全部',
          onBookTap: (book, heroTag) =>
              AppRouter.goBookDetail(book, coverHeroTag: heroTag),
        ),
        const SizedBox(height: AppSizes.bookDetailSectionGap),
        BookDetailRecommendationSection(
          title: '猜你喜欢',
          books: detail.recommendedBooks,
          heroNamespace: 'detail-recommend',
          actionLabel: '换一换',
          actionIconAsset: AppThemeAssets.bookDetailRefresh,
          rotateActionIconOnTap: true,
          onActionTap: onRecommendationRefreshTap,
          onBookTap: (book, heroTag) =>
              AppRouter.goBookDetail(book, coverHeroTag: heroTag),
        ),
        const SizedBox(height: AppSizes.bookDetailSectionGap),
        _BookDetailLegalInfo(detail: detail),
      ],
    );
  }
}

class _BookDetailLegalInfo extends StatelessWidget {
  const _BookDetailLegalInfo({required this.detail});

  final BookDetail detail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          detail.listedAtText,
          style: AppTextStyles.authAgreementDarkMuted,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppText(
          detail.copyrightText,
          style: AppTextStyles.authAgreementDarkMuted,
        ),
      ],
    );
  }
}
