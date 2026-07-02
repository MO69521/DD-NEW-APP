import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/my_message_tab.dart';

/// L3 组件 — 我的消息页 Tab（回复 / 获赞 / 通知）。
class MyMessagesTabBar extends StatelessWidget {
  const MyMessagesTabBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final MyMessageTab selected;
  final ValueChanged<MyMessageTab> onSelected;

  @override
  Widget build(BuildContext context) {
    final tabs = MyMessageTab.values;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          for (var i = 0; i < tabs.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.lg),
            _MyMessagesTabItem(
              tab: tabs[i],
              isSelected: tabs[i] == selected,
              onTap: () => onSelected(tabs[i]),
            ),
          ],
        ],
      ),
    );
  }
}

class _MyMessagesTabItem extends StatelessWidget {
  const _MyMessagesTabItem({
    required this.tab,
    required this.isSelected,
    required this.onTap,
  });

  final MyMessageTab tab;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppText(
            tab.label,
            style: (isSelected
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
                  : AppColors.accentYellow.withValues(alpha: 0),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
        ],
      ),
    );
  }
}
