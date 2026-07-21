import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/book_discussion_post.dart';

/// 讨论帖正文前内容标签（置顶红渐变 / 精选紫渐变 / 公告弱面）。
/// 内边距 / 圆角与 [BookDiscussionAuthorBadge] 一致。
class BookDiscussionContentTag extends StatelessWidget {
  const BookDiscussionContentTag({super.key, required this.badge});

  final BookDiscussionPostBadge badge;

  static const EdgeInsets _padding = EdgeInsets.symmetric(
    horizontal: AppSpacing.xxsHalf,
    vertical: AppSpacing.xxsHalf,
  );

  @override
  Widget build(BuildContext context) {
    final gradient = switch (badge) {
      BookDiscussionPostBadge.pinned => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.discussionPinnedTagGradientStart,
          AppColors.discussionPinnedTagGradientEnd,
        ],
      ),
      BookDiscussionPostBadge.featured => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.discussionFeaturedTagGradientStart,
          AppColors.discussionFeaturedTagGradientEnd,
        ],
      ),
      BookDiscussionPostBadge.notice => null,
    };

    final textStyle = switch (badge) {
      BookDiscussionPostBadge.notice => AppTextStyles.bookDetailDiscussionTag,
      _ => AppTextStyles.captionSm.copyWith(
        color: AppColors.discussionContentTagText,
        height: AppLineHeights.none,
      ),
    };
    final fontSize = switch (badge) {
      BookDiscussionPostBadge.notice => AppFontSizes.md,
      _ => AppFontSizes.xs,
    };

    return Container(
      padding: _padding,
      decoration: BoxDecoration(
        color: gradient == null ? AppColors.discussionTagBackground : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Text(
          badge.label,
          style: textStyle,
          textHeightBehavior: const TextHeightBehavior(
            applyHeightToFirstAscent: false,
            applyHeightToLastDescent: false,
          ),
          strutStyle: StrutStyle(
            fontSize: fontSize,
            height: AppLineHeights.none,
            forceStrutHeight: true,
          ),
        ),
    );
  }
}
