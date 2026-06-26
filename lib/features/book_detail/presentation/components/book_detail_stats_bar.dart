import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';

/// 数据条：加书架 / 热度 / 字数（Figma 185:2356）。
class BookDetailStatsBar extends StatelessWidget {
  const BookDetailStatsBar({
    super.key,
    required this.shelfCount,
    required this.popularity,
    required this.wordCount,
  });

  final String shelfCount;
  final String popularity;
  final String wordCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.bookDetailStatsBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.borderGlass,
          width: AppSizes.hairline,
        ),
      ),
      child: Row(
        children: [
          _StatItem(value: shelfCount, label: '加书架'),
          const _Divider(),
          _StatItem(value: popularity, label: '热度'),
          const _Divider(),
          _StatItem(value: wordCount, label: '字数'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText(value, style: AppTextStyles.bookDetailStatValue),
          const SizedBox(height: AppSpacing.sm),
          AppText(label, style: AppTextStyles.bookDetailStatLabel),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.hairline,
      height: AppSizes.bookDetailStatsDividerHeight,
      color: AppColors.borderGlass,
    );
  }
}
