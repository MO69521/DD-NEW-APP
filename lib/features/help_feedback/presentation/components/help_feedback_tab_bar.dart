import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
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
    const tabs = HelpFeedbackTab.values;
    const slotWidth = AppSizes.tabSlotWidthMd;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: SizedBox(
        width: slotWidth * tabs.length + AppSpacing.xl * (tabs.length - 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < tabs.length; i++) ...[
              if (i > 0) const SizedBox(width: AppSpacing.xl),
              _HelpFeedbackTabItem(
                tab: tabs[i],
                isSelected: tabs[i] == selected,
                width: slotWidth,
                onTap: () => onSelected(tabs[i]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HelpFeedbackTabItem extends StatelessWidget {
  const _HelpFeedbackTabItem({
    required this.tab,
    required this.isSelected,
    required this.width,
    required this.onTap,
  });

  final HelpFeedbackTab tab;
  final bool isSelected;
  final double width;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: width,
        child: AppText(
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
          maxLines: 1,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
