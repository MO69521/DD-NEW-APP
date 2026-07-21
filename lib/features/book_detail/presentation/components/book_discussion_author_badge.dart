import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// 讨论区昵称旁「作者」红色小标（区别于消息页黄底 [AppColors.authorBadge*]）。
class BookDiscussionAuthorBadge extends StatelessWidget {
  const BookDiscussionAuthorBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxsHalf,
        vertical: AppSpacing.xxsHalf,
      ),
      decoration: BoxDecoration(
        color: AppColors.discussionAuthorBadgeBackground,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Text(
        '作者',
        style: AppTextStyles.captionSm.copyWith(
          color: AppColors.discussionAuthorBadgeText,
          height: AppLineHeights.none,
        ),
        textHeightBehavior: const TextHeightBehavior(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: false,
        ),
        strutStyle: const StrutStyle(
          fontSize: AppFontSizes.xs,
          height: AppLineHeights.none,
          forceStrutHeight: true,
        ),
      ),
    );
  }
}
