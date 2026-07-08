import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';
import 'search_keyword_chip.dart';

/// L3 — 搜索关键词分区（搜索历史 / 热门搜索）。
///
/// 标题行 + 关键词 Wrap；[onClear] 非空时标题右侧显示清空按钮；
/// [highlightFirst] 为 true 时首个关键词以热词样式强调。
class SearchKeywordSection extends StatelessWidget {
  const SearchKeywordSection({
    super.key,
    required this.title,
    required this.keywords,
    this.highlightFirst = false,
    this.onClear,
    this.onKeywordTap,
  });

  final String title;
  final List<String> keywords;
  final bool highlightFirst;
  final VoidCallback? onClear;
  final ValueChanged<String>? onKeywordTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppText(
              title,
              style: AppTextStyles.sectionTitleDark.copyWith(
                color: AppColors.textOnDark,
              ),
            ),
            const Spacer(),
            if (onClear != null)
              GestureDetector(
                onTap: onClear,
                behavior: HitTestBehavior.opaque,
                child: const Icon(
                  Icons.delete_outline,
                  size: AppSizes.searchInputIconSize,
                  color: AppColors.sectionActionIcon,
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (var i = 0; i < keywords.length; i++)
              SearchKeywordChip(
                label: keywords[i],
                isHot: highlightFirst && i == 0,
                onTap: onKeywordTap == null
                    ? null
                    : () => onKeywordTap!(keywords[i]),
              ),
          ],
        ),
      ],
    );
  }
}
