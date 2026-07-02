import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/help_feedback_tab.dart';

/// L3 — 帮助与反馈页顶部 Tab。
class HelpFeedbackTabBar extends StatelessWidget {
  const HelpFeedbackTabBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final HelpFeedbackTab selected;
  final ValueChanged<HelpFeedbackTab> onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (final tab in HelpFeedbackTab.values) ...[
            _HelpFeedbackTabItem(
              tab: tab,
              isSelected: tab == selected,
              onTap: () => onSelected(tab),
            ),
            if (tab != HelpFeedbackTab.values.last)
              const SizedBox(width: AppSpacing.xl),
          ],
        ],
      ),
    );
  }
}

class _HelpFeedbackTabItem extends StatelessWidget {
  const _HelpFeedbackTabItem({
    required this.tab,
    required this.isSelected,
    required this.onTap,
  });

  final HelpFeedbackTab tab;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            tab.label,
            style:
                (isSelected
                        ? AppTextStyles.tabActiveDark
                        : AppTextStyles.tabInactiveDark)
                    .copyWith(
                      color: isSelected
                          ? AppColors.textOnDark
                          : AppColors.textOnDarkMuted,
                    ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Container(
            width: AppSizes.tabIndicatorWidth,
            height: AppSizes.tabIndicatorHeight,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.accentYellow
                  : AppColors.gradientFadeStart,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
        ],
      ),
    );
  }
}
