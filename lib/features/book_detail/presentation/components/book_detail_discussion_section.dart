import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/components/app_segmented_switch.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/book_discussion_filter.dart';
import '../../domain/entities/book_discussion_post.dart';
import '../../domain/entities/book_discussion_sort.dart';
import 'book_discussion_author_badge.dart';
import 'book_discussion_content_tag.dart';
import 'book_discussion_like_icon.dart';

/// 讨论区主体：筛选条 + 帖子流（深色态）。
class BookDetailDiscussionSection extends StatelessWidget {
  const BookDetailDiscussionSection({
    super.key,
    required this.selectedFilter,
    required this.selectedSort,
    required this.posts,
    this.highlightedPostId,
    this.highlightedCommentKey,
    required this.onFilterSelected,
    required this.onSortSelected,
    required this.onPostTap,
    required this.onPostLikeTap,
    required this.onPostBodyTap,
  });

  final BookDiscussionFilter selectedFilter;
  final BookDiscussionSort selectedSort;
  final List<BookDiscussionPost> posts;
  final String? highlightedPostId;
  final GlobalKey? highlightedCommentKey;
  final ValueChanged<BookDiscussionFilter> onFilterSelected;
  final ValueChanged<BookDiscussionSort> onSortSelected;
  final ValueChanged<BookDiscussionPost> onPostTap;
  final ValueChanged<BookDiscussionPost> onPostLikeTap;
  final ValueChanged<BookDiscussionPost> onPostBodyTap;

  @override
  Widget build(BuildContext context) {
    final visiblePosts = _visiblePosts();
    final needsScrollReserve =
        selectedFilter != BookDiscussionFilter.all &&
        visiblePosts.length < posts.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    for (
                      var i = 0;
                      i < BookDiscussionFilter.values.length;
                      i++
                    ) ...[
                      if (i > 0) const SizedBox(width: AppSpacing.md),
                      _FilterText(
                        filter: BookDiscussionFilter.values[i],
                        selected:
                            selectedFilter == BookDiscussionFilter.values[i],
                        onTap: () => onFilterSelected(
                          BookDiscussionFilter.values[i],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            SizedBox(
              width: AppSizes.bookDetailDiscussionSortSwitchWidth,
              child: _SortSwitch(
                selected: selectedSort,
                onSelected: onSortSelected,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        if (visiblePosts.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
            child: Center(
              child: AppText(
                '暂无讨论内容',
                style: AppTextStyles.bookDetailPlaceholder,
              ),
            ),
          )
        else
          Column(
            children: [
              for (var i = 0; i < visiblePosts.length; i++) ...[
                _DiscussionCard(
                  key: visiblePosts[i].id == highlightedPostId
                      ? highlightedCommentKey
                      : null,
                  post: visiblePosts[i],
                  isHighlighted: visiblePosts[i].id == highlightedPostId,
                  onTap: () => onPostTap(visiblePosts[i]),
                  onLikeTap: () => onPostLikeTap(visiblePosts[i]),
                  onBodyTap: () => onPostBodyTap(visiblePosts[i]),
                ),
                if (i != visiblePosts.length - 1)
                  const SizedBox(height: AppSizes.bookDetailDiscussionListGap),
              ],
            ],
          ),
        if (needsScrollReserve)
          SizedBox(
            height:
                MediaQuery.sizeOf(context).height *
                AppSizes.bookDetailDiscussionShortListBottomReserveFactor,
          ),
      ],
    );
  }

  List<BookDiscussionPost> _visiblePosts() {
    final filtered = posts
        .where(
          (post) =>
              selectedFilter == BookDiscussionFilter.all ||
              post.filters.contains(selectedFilter),
        )
        .toList(growable: true);

    switch (selectedSort) {
      case BookDiscussionSort.latest:
        // Mock 列表已按时间序；置顶帖保持原相对位置靠前即可。
        break;
      case BookDiscussionSort.hottest:
        filtered.sort((a, b) {
          final pinnedCmp = _pinnedRank(b).compareTo(_pinnedRank(a));
          if (pinnedCmp != 0) return pinnedCmp;
          return b.likeCount.compareTo(a.likeCount);
        });
    }
    return List<BookDiscussionPost>.unmodifiable(filtered);
  }

  static int _pinnedRank(BookDiscussionPost post) =>
      post.badges.contains(BookDiscussionPostBadge.pinned) ? 1 : 0;
}

/// 纯文字筛选（对齐分类页 `CategoryFilterChip` 无下划线态）。
class _FilterText extends StatelessWidget {
  const _FilterText({
    required this.filter,
    required this.selected,
    required this.onTap,
  });

  final BookDiscussionFilter filter;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSizes.bookDetailDiscussionFilterPaddingV,
        ),
        child: AppText(
          filter.label,
          style: selected
              ? AppTextStyles.bookDetailDiscussionFilterSelected
              : AppTextStyles.bookDetailDiscussionFilterUnselected,
        ),
      ),
    );
  }
}

class _SortSwitch extends StatelessWidget {
  const _SortSwitch({required this.selected, required this.onSelected});

  final BookDiscussionSort selected;
  final ValueChanged<BookDiscussionSort> onSelected;

  @override
  Widget build(BuildContext context) {
    return AppSegmentedSwitch(
      itemCount: BookDiscussionSort.values.length,
      selectedIndex: BookDiscussionSort.values.indexOf(selected),
      onChanged: (index) => onSelected(BookDiscussionSort.values[index]),
      outerRadius: AppRadius.rankingSegmentedOuter,
      innerRadius: AppRadius.rankingSegmentedInner,
      outerPadding: AppSizes.rankingSegmentedOuterPadding,
      itemPaddingVertical: AppSizes.bookDetailDiscussionFilterPaddingV,
      blurSigma: AppSizes.rankingSegmentedBlurSigma,
      itemBuilder: (context, index, isSelected) {
        final sort = BookDiscussionSort.values[index];
        return AppText(
          sort.label,
          style: isSelected
              ? AppTextStyles.rankingChannelActive
              : AppTextStyles.rankingChannelInactive,
        );
      },
    );
  }
}

class _DiscussionCard extends StatelessWidget {
  const _DiscussionCard({
    super.key,
    required this.post,
    required this.isHighlighted,
    required this.onTap,
    required this.onLikeTap,
    required this.onBodyTap,
  });

  final BookDiscussionPost post;
  final bool isHighlighted;
  final VoidCallback onTap;
  final VoidCallback onLikeTap;
  final VoidCallback onBodyTap;

  @override
  Widget build(BuildContext context) {
    // AnimatedContainer / Container 均禁止负 margin（断言会整页红屏）。
    // 通栏高亮：Stack + Positioned 向两侧伸出内容区 inset。
    const bleed = AppSizes.bookDetailContentHInset;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: -bleed,
          right: -bleed,
          top: 0,
          bottom: 0,
          child: IgnorePointer(
            child: AnimatedContainer(
              duration: AppDurations.normal,
              curve: Curves.easeInOut,
              color: isHighlighted
                  ? AppColors.discussionNewCommentHighlight
                  : AppColors.white00,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Avatar(assetPath: post.authorAvatarAsset),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Header(post: post, onLikeTap: onLikeTap),
                    const SizedBox(height: AppSpacing.sm),
                    AppPressable(
                      onTap: onBodyTap,
                      pressScale: AppSizes.tapPressScaleSubtle,
                      child: _DiscussionBodyText(
                        title: post.title,
                        content: post.content,
                        badges: post.badges,
                      ),
                    ),
                    if (post.replyPreview != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      AppPressable(
                        onTap: onTap,
                        pressScale: AppSizes.tapPressScaleSubtle,
                        child: _ReplyPreview(
                          replyCount: post.replyCount,
                          preview: post.replyPreview!,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DiscussionBodyText extends StatelessWidget {
  const _DiscussionBodyText({
    required this.title,
    required this.content,
    this.badges = const [],
  });

  final String title;
  final String content;
  final List<BookDiscussionPostBadge> badges;

  @override
  Widget build(BuildContext context) {
    final text = content.isEmpty
        ? title
        : title.isEmpty
        ? content
        : '$title\n$content';
    final ordered = [
      for (final kind in BookDiscussionPostBadge.values)
        if (badges.contains(kind)) kind,
    ];

    if (ordered.isEmpty) {
      return AppText(text, style: AppTextStyles.bookDetailDiscussionBody);
    }

    return Text.rich(
      TextSpan(
        style: AppTextStyles.bookDetailDiscussionBody,
        children: [
          for (final badge in ordered)
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.only(right: AppSpacing.xxs),
                child: BookDiscussionContentTag(badge: badge),
              ),
            ),
          TextSpan(text: text),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.post, required this.onLikeTap});

  final BookDiscussionPost post;
  final VoidCallback onLikeTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: AppText(
                      post.authorName,
                      style: AppTextStyles.bookDetailDiscussionAuthor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (post.isAuthor) ...[
                    const SizedBox(width: AppSpacing.xs),
                    const BookDiscussionAuthorBadge(),
                  ],
                ],
              ),
              const SizedBox(height: AppSpacing.xxs),
              AppText(
                post.publishMeta,
                style: AppTextStyles.bookDetailDiscussionMeta,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        AppPressable(
          onTap: onLikeTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: AppSpacing.xxs,
            ),
            child: Row(
              children: [
                BookDiscussionLikeIcon(isLiked: post.isLiked),
                const SizedBox(width: AppSpacing.xxsHalf),
                AppText(
                  '${post.likeCount}',
                  style: AppTextStyles.bookDetailDiscussionLike,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ReplyPreview extends StatelessWidget {
  const _ReplyPreview({required this.replyCount, required this.preview});

  final int replyCount;
  final BookDiscussionReplyPreview preview;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.bookDetailDiscussionReplyPadding),
      decoration: BoxDecoration(
        color: AppColors.discussionItemReplyBackground,
        borderRadius: BorderRadius.circular(
          AppRadius.bookDetailDiscussionReply,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            '${preview.authorName}：${preview.content}',
            style: AppTextStyles.bookDetailDiscussionReplyPreview,
          ),
          const SizedBox(height: AppSpacing.xs),
          AppText(
            '查看全部$replyCount条回复',
            style: AppTextStyles.bookDetailDiscussionReplyAction,
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: SizedBox(
        width: AppSizes.bookDetailDiscussionListAvatarSize,
        height: AppSizes.bookDetailDiscussionListAvatarSize,
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const ColoredBox(
            color: AppColors.surfaceGlass,
            child: Icon(
              Icons.person_outline,
              color: AppColors.textOnDarkMuted,
              size: AppSizes.bookDetailDiscussionLikeIconSize,
            ),
          ),
        ),
      ),
    );
  }
}
