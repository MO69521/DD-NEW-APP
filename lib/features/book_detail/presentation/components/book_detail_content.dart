import 'package:flutter/material.dart';

import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/book_detail.dart';
import '../../domain/entities/book_detail_tab.dart';
import '../../domain/entities/book_discussion_filter.dart';
import '../../domain/entities/book_discussion_post.dart';
import 'book_detail_catalog_entry.dart';
import 'book_detail_character_section.dart';
import 'book_detail_discussion_section.dart';
import 'book_detail_intro.dart';
import 'book_detail_placeholder_view.dart';
import 'book_detail_stats_bar.dart';
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
    required this.onTabSelected,
    required this.onDiscussionFilterSelected,
    required this.onDiscussionPostTap,
    required this.onDiscussionPostLikeTap,
    required this.onDiscussionPostBodyTap,
    required this.onCatalogTap,
    required this.onCharacterFavTap,
  });

  final BookDetail detail;
  final BookDetailTab selectedTab;
  final BookDiscussionFilter selectedDiscussionFilter;
  final ValueChanged<BookDetailTab> onTabSelected;
  final ValueChanged<BookDiscussionFilter> onDiscussionFilterSelected;
  final ValueChanged<BookDiscussionPost> onDiscussionPostTap;
  final ValueChanged<BookDiscussionPost> onDiscussionPostLikeTap;
  final ValueChanged<BookDiscussionPost> onDiscussionPostBodyTap;
  final VoidCallback onCatalogTap;
  final ValueChanged<String> onCharacterFavTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BookDetailSummaryCard(detail: detail),
        const SizedBox(height: AppSpacing.sm),
        BookDetailStatsBar(
          shelfCount: detail.shelfCount,
          popularity: detail.popularity,
          wordCount: detail.wordCount,
        ),
        const SizedBox(height: AppSizes.bookDetailSectionGap),
        BookDetailTabSwitcher(
          selectedTab: selectedTab,
          onTabSelected: onTabSelected,
          discussionCount: detail.discussionCount,
        ),
        const SizedBox(height: AppSizes.bookDetailSectionGap),
        if (selectedTab == BookDetailTab.detail)
          _DetailTabBody(
            detail: detail,
            onCatalogTap: onCatalogTap,
            onCharacterFavTap: onCharacterFavTap,
          )
        else if (selectedTab == BookDetailTab.discussion)
          BookDetailDiscussionSection(
            selectedFilter: selectedDiscussionFilter,
            posts: detail.discussionPosts,
            onFilterSelected: onDiscussionFilterSelected,
            onPostTap: onDiscussionPostTap,
            onPostLikeTap: onDiscussionPostLikeTap,
            onPostBodyTap: onDiscussionPostBodyTap,
          )
        else if (selectedTab == BookDetailTab.update)
          BookDetailUpdateSection(entries: detail.updateEntries)
        else
          BookDetailPlaceholderView(label: selectedTab.label),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

class _DetailTabBody extends StatelessWidget {
  const _DetailTabBody({
    required this.detail,
    required this.onCatalogTap,
    required this.onCharacterFavTap,
  });

  final BookDetail detail;
  final VoidCallback onCatalogTap;
  final ValueChanged<String> onCharacterFavTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BookDetailIntro(intro: detail.intro),
        const SizedBox(height: AppSizes.bookDetailSectionGap),
        BookDetailCatalogEntry(
          serialStatus: detail.serialStatus,
          onTap: onCatalogTap,
        ),
        const SizedBox(height: AppSizes.bookDetailSectionGap),
        BookDetailCharacterSection(
          characters: detail.characters,
          onCharacterFavTap: onCharacterFavTap,
        ),
      ],
    );
  }
}
