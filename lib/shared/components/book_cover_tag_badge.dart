import 'dart:ui';

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
/// 全局统一角标组件，由 [BookCoverTag] 驱动视觉；全主题统一 [BackdropFilter] 磨砂底，
/// 压在封面上更易辨认：
/// - 更新：主色黄底 + 深色字（强调）
/// - 完结 / 连载：半透明深底 + 白字 + 黑 4% 描边
class BookCoverTagBadge extends StatelessWidget {
  const BookCoverTagBadge({super.key, required this.tag});

  final BookCoverTag tag;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = switch (tag) {
      BookCoverTag.updated => AppColors.primary,
      BookCoverTag.completed ||
      BookCoverTag.serializing => AppColors.bookCoverTagCompletedScrim,
    };
    final textColor = switch (tag) {
      BookCoverTag.updated => AppColors.onPrimary,
      BookCoverTag.completed ||
      BookCoverTag.serializing => AppColors.bookCoverTagCompletedText,
    };
    final borderColor = switch (tag) {
      BookCoverTag.updated => AppColors.borderSubtle,
      BookCoverTag.completed ||
      BookCoverTag.serializing => AppColors.bookCoverTagCompletedBorder,
    };

    final borderRadius = BorderRadius.circular(AppRadius.xs);

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: AppSizes.bookCoverTagBlurSigma,
          sigmaY: AppSizes.bookCoverTagBlurSigma,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius,
            border: Border.all(color: borderColor, width: AppSizes.hairline),
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
        ),
      ),
    );
  }
}
