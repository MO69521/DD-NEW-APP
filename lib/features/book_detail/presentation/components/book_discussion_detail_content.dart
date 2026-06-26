import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/book_discussion_post.dart';

/// 书评详情主内容：主贴 + 全部回复。
class BookDiscussionDetailContent extends StatelessWidget {
  const BookDiscussionDetailContent({
    super.key,
    required this.post,
    required this.onPostLikeTap,
    required this.isPostLikePending,
    required this.onReplyLikeTap,
    required this.replyLikePendingIds,
  });

  final BookDiscussionPost post;
  final VoidCallback onPostLikeTap;
  final bool isPostLikePending;
  final ValueChanged<String> onReplyLikeTap;
  final List<String> replyLikePendingIds;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.xl,
      ),
      children: [
        _PostHeader(
          post: post,
          onLikeTap: onPostLikeTap,
          isLikePending: isPostLikePending,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppText(
          '${post.title}\n${post.content}',
          style: AppTextStyles.bookDetailDiscussionBody,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppText(
          '全部回复 · ${post.replyCount}',
          style: AppTextStyles.titleMediumDark,
        ),
        const SizedBox(height: AppSpacing.md),
        if (post.replies.isEmpty)
          const AppText('暂无回复', style: AppTextStyles.bodyMedium)
        else
          Column(
            children: [
              for (var i = 0; i < post.replies.length; i++) ...[
                _ReplyItem(
                  reply: post.replies[i],
                  onLikeTap: () => onReplyLikeTap(post.replies[i].id),
                  isLikePending: replyLikePendingIds.contains(
                    post.replies[i].id,
                  ),
                ),
                if (i != post.replies.length - 1)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    child: Divider(height: AppSizes.hairline),
                  ),
              ],
            ],
          ),
      ],
    );
  }
}

class _PostHeader extends StatelessWidget {
  const _PostHeader({
    required this.post,
    required this.onLikeTap,
    required this.isLikePending,
  });

  final BookDiscussionPost post;
  final VoidCallback onLikeTap;
  final bool isLikePending;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.full),
          child: AppAssetImage(
            assetPath: post.authorAvatarAsset,
            width: AppSizes.bookDetailDiscussionAvatarSize,
            height: AppSizes.bookDetailDiscussionAvatarSize,
            fit: BoxFit.cover,
          ),
        ),
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
        GestureDetector(
          onTap: isLikePending ? null : onLikeTap,
          behavior: HitTestBehavior.opaque,
          child: Row(
            children: [
              Icon(
                post.isLiked ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined,
                size: AppSizes.bookDetailDiscussionLikeIconSize,
                color: post.isLiked ? AppColors.primary : AppColors.iconMuted,
              ),
              const SizedBox(width: AppSpacing.xxsHalf),
              AppText(
                '${post.likeCount}',
                style: AppTextStyles.bookDetailDiscussionLike,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReplyItem extends StatelessWidget {
  const _ReplyItem({
    required this.reply,
    required this.onLikeTap,
    required this.isLikePending,
  });

  final BookDiscussionReply reply;
  final VoidCallback onLikeTap;
  final bool isLikePending;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.full),
          child: AppAssetImage(
            assetPath: reply.authorAvatarAsset,
            width: AppSizes.bookDiscussionDetailReplyAvatarSize,
            height: AppSizes.bookDiscussionDetailReplyAvatarSize,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(reply.authorName, style: AppTextStyles.labelMediumDark),
              const SizedBox(height: AppSpacing.xxs),
              AppText(reply.content, style: AppTextStyles.bodyMediumDark),
              const SizedBox(height: AppSpacing.xxs),
              AppText(
                reply.publishMeta,
                style: AppTextStyles.captionMdDarkMuted,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        GestureDetector(
          onTap: isLikePending ? null : onLikeTap,
          behavior: HitTestBehavior.opaque,
          child: Row(
            children: [
              Icon(
                reply.isLiked
                    ? Icons.thumb_up_alt
                    : Icons.thumb_up_alt_outlined,
                size: AppSizes.bookDetailDiscussionLikeIconSize,
                color: reply.isLiked ? AppColors.primary : AppColors.iconMuted,
              ),
              const SizedBox(width: AppSpacing.xxsHalf),
              AppText(
                '${reply.likeCount}',
                style: AppTextStyles.captionMdDarkMuted,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
