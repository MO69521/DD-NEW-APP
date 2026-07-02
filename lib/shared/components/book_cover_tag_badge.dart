import 'package:flutter/material.dart';

import '../../core/domain/entities/book_cover_tag.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../widgets/app_text.dart';

/// Level 2 — 封面右上角状态角标（Figma 1335:12223）。
///
/// 全局统一角标组件，由 [BookCoverTag] 驱动视觉：
/// - 更新：主色黄底 + 深色字（强调）
/// - 完结 / 连载：半透明深底 + 白字
class BookCoverTagBadge extends StatelessWidget {
  const BookCoverTagBadge({super.key, required this.tag});

  final BookCoverTag tag;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = switch (tag) {
      BookCoverTag.updated => AppColors.accentYellow,
      BookCoverTag.completed ||
      BookCoverTag.serializing => AppColors.bookCoverTagCompletedScrim,
    };
    final textColor = switch (tag) {
      BookCoverTag.updated => AppColors.navActiveText,
      BookCoverTag.completed ||
      BookCoverTag.serializing => AppColors.textOnDark,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.xs),
        border: Border.all(
          color: AppColors.borderGlass,
          width: AppSizes.hairline,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
        child: AppText(
          tag.label,
          style: AppTextStyles.bookCoverTagLabel.copyWith(color: textColor),
        ),
      ),
    );
  }
}
