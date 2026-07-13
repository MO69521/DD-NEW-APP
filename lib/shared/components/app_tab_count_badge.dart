import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../widgets/app_text.dart';

/// L2 — Tab 悬浮数字角标。
///
/// 用于 Tab 文字右上角的未读/讨论数等计数展示；不参与 Tab 文案布局，
/// 由宿主通过 [Positioned] 放置。
class AppTabCountBadge extends StatelessWidget {
  const AppTabCountBadge({
    super.key,
    required this.count,
    this.color = AppColors.badgeCount,
  });

  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: AppSizes.tabBadgeMinSize,
        minHeight: AppSizes.tabBadgeMinSize,
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: AppText(
        count > 99 ? '99+' : '$count',
        style: AppTextStyles.captionSm.copyWith(color: AppColors.textPrimary),
        maxLines: 1,
      ),
    );
  }
}
