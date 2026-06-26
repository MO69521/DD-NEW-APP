import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/book_discussion_filter.dart';
import '../../domain/entities/book_discussion_post.dart';

/// 讨论区主体：筛选条 + 帖子流（深色态）。
class BookDetailDiscussionSection extends StatelessWidget {
  const BookDetailDiscussionSection({
    super.key,
    required this.selectedFilter,
    required this.posts,
    required this.onFilterSelected,
    required this.onPostTap,
    required this.onPostLikeTap,
    required this.onPostBodyTap,
  });

  final BookDiscussionFilter selectedFilter;
  final List<BookDiscussionPost> posts;
  final ValueChanged<BookDiscussionFilter> onFilterSelected;
  final ValueChanged<BookDiscussionPost> onPostTap;
  final ValueChanged<BookDiscussionPost> onPostLikeTap;
  final ValueChanged<BookDiscussionPost> onPostBodyTap;

  @override
  Widget build(BuildContext context) {
    final visiblePosts = posts
        .where(
          (post) =>
              selectedFilter == BookDiscussionFilter.all ||
              post.filters.contains(selectedFilter),
        )
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              for (var i = 0; i < BookDiscussionFilter.values.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.md),
                _FilterChip(
                  filter: BookDiscussionFilter.values[i],
                  selected: selectedFilter == BookDiscussionFilter.values[i],
                  onTap: () => onFilterSelected(BookDiscussionFilter.values[i]),
                ),
              ],
            ],
          ),
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
                  post: visiblePosts[i],
                  onTap: () => onPostTap(visiblePosts[i]),
                  onLikeTap: () => onPostLikeTap(visiblePosts[i]),
                  onBodyTap: () => onPostBodyTap(visiblePosts[i]),
                ),
                if (i != visiblePosts.length - 1)
                  const SizedBox(height: AppSizes.bookDetailDiscussionListGap),
              ],
            ],
          ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.filter,
    required this.selected,
    required this.onTap,
  });

  final BookDiscussionFilter filter;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.bookDetailDiscussionFilterPaddingH,
          vertical: AppSizes.bookDetailDiscussionFilterPaddingV,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.discussionFilterSelectedBackground : null,
          borderRadius: BorderRadius.circular(
            AppRadius.bookDetailDiscussionFilter,
          ),
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

class _DiscussionCard extends StatelessWidget {
  const _DiscussionCard({
    required this.post,
    required this.onTap,
    required this.onLikeTap,
    required this.onBodyTap,
  });

  final BookDiscussionPost post;
  final VoidCallback onTap;
  final VoidCallback onLikeTap;
  final VoidCallback onBodyTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xxs,
        horizontal: AppSpacing.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(post: post, onLikeTap: onLikeTap),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: AppSizes.bookDetailDiscussionBodyIndent),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: onBodyTap,
                      behavior: HitTestBehavior.opaque,
                      child: _DiscussionBodyText(
                        title: post.title,
                        content: post.content,
                        highlightTag: post.highlightTag,
                      ),
                    ),
                    if (post.replyPreview != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      GestureDetector(
                        onTap: onTap,
                        behavior: HitTestBehavior.opaque,
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
        ],
      ),
    );
  }
}

class _DiscussionBodyText extends StatelessWidget {
  const _DiscussionBodyText({
    required this.title,
    required this.content,
    this.highlightTag,
  });

  final String title;
  final String content;
  final String? highlightTag;

  @override
  Widget build(BuildContext context) {
    final text = '$title\n$content';
    if (highlightTag == null) {
      return AppText(text, style: AppTextStyles.bookDetailDiscussionBody);
    }

    return RichText(
      text: TextSpan(
        style: AppTextStyles.bookDetailDiscussionBody,
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: const EdgeInsets.only(right: AppSpacing.xs),
              child: _Tag(label: highlightTag!),
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
        _Avatar(assetPath: post.authorAvatarAsset),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                post.authorName,
                style: AppTextStyles.bookDetailDiscussionAuthor,
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
        InkWell(
          onTap: onLikeTap,
          borderRadius: BorderRadius.circular(AppRadius.full),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: AppSpacing.xxs,
            ),
            child: Row(
              children: [
                Icon(
                  post.isLiked
                      ? Icons.thumb_up_alt
                      : Icons.thumb_up_alt_outlined,
                  size: AppSizes.bookDetailDiscussionLikeIconSize,
                  color: post.isLiked
                      ? AppColors.primary
                      : AppColors.discussionLikeIcon,
                ),
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

class _Tag extends StatelessWidget {
  const _Tag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxsHalf,
      ),
      decoration: BoxDecoration(
        color: AppColors.navBarBackground,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: AppText(label, style: AppTextStyles.bookDetailDiscussionTag),
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
