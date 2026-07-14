import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_network_avatar.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../../../shared/widgets/book_cover.dart';
import '../../domain/entities/my_message.dart';
import '../../domain/entities/my_message_tab.dart';

/// L3 组件 — 单条互动消息（回复 / 获赞）。
class MyMessageItem extends StatelessWidget {
  const MyMessageItem({super.key, required this.message});

  final MyMessage message;

  String get _actionLabel => switch (message.kind) {
    MyMessageTab.reply => '回复了你的书评',
    MyMessageTab.like => '赞了你的书评',
    MyMessageTab.notification => '',
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppNetworkAvatar(
          imageUrl: message.senderAvatarUrl,
          size: AppSizes.myMessagesAvatarSize,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeaderRow(name: message.senderName, isAuthor: message.isAuthor,
                  timeLabel: message.timeLabel),
              const SizedBox(height: AppSpacing.xs),
              if (message.isDeleted)
                const AppText(
                  '该评论已被删除',
                  style: AppTextStyles.bookDetailDiscussionMeta,
                )
              else ...[
                AppText(
                  _actionLabel,
                  style: AppTextStyles.bookDetailDiscussionMeta,
                ),
                if (message.replyContent != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  AppText(
                    message.replyContent!,
                    style: AppTextStyles.bookDetailDiscussionBody,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
              const SizedBox(height: AppSpacing.sm),
              _QuotedReview(text: message.quotedReview),
              const SizedBox(height: AppSpacing.sm),
              _BookRefBlock(bookRef: message.bookRef),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({
    required this.name,
    required this.isAuthor,
    required this.timeLabel,
  });

  final String name;
  final bool isAuthor;
  final String timeLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: AppText(
            name,
            style: AppTextStyles.bookDetailDiscussionAuthor,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (isAuthor) ...[
          const SizedBox(width: AppSpacing.xs),
          const _AuthorBadge(),
        ],
        const SizedBox(width: AppSpacing.xs),
        AppText(timeLabel, style: AppTextStyles.bookCardFooter),
      ],
    );
  }
}

class _AuthorBadge extends StatelessWidget {
  const _AuthorBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxsHalf,
      ),
      decoration: BoxDecoration(
        color: AppColors.authorBadgeBackground,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: AppText(
        '作者',
        style: AppTextStyles.captionSm.copyWith(
          color: AppColors.authorBadgeText,
        ),
      ),
    );
  }
}

class _QuotedReview extends StatelessWidget {
  const _QuotedReview({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: AppSizes.myMessagesQuoteBarWidth,
            decoration: BoxDecoration(
              color: AppColors.myMessagesQuoteBar,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: AppText(
              text,
              style: AppTextStyles.bookCardLargeDescription,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _BookRefBlock extends StatelessWidget {
  const _BookRefBlock({required this.bookRef});

  final MyMessageBookRef bookRef;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.myMessagesBookRefBackground,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          BookCover(
            assetPath: bookRef.coverAsset,
            width: AppSizes.myMessagesBookRefCoverWidth,
            height: AppSizes.myMessagesBookRefCoverHeight,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  bookRef.title,
                  style: AppTextStyles.bookDetailDiscussionReplyPreview,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (bookRef.chapterLabel != null) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  AppText(
                    bookRef.chapterLabel!,
                    style: AppTextStyles.bookCardFooter,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
