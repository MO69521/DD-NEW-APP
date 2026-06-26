import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_context.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../../../core/domain/entities/book.dart';

/// 榜单 Tab 切换（推荐榜 / 人气榜 / 飙升榜 / 完结榜）。
///
/// 与下方书单左对齐，Tab 间距固定 [AppSpacing.md]。
class RankingTabs extends StatelessWidget {
  const RankingTabs({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final RankingTab selected;
  final ValueChanged<RankingTab> onSelected;

  @override
  Widget build(BuildContext context) {
    final tabs = RankingTab.values;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for (var i = 0; i < tabs.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.md),
            _RankingTabItem(
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

class _RankingTabItem extends StatelessWidget {
  const _RankingTabItem({
    required this.tab,
    required this.isSelected,
    required this.onTap,
  });

  final RankingTab tab;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

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
              color: isSelected ? colors.textPrimary : colors.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Container(
            width: AppSizes.tabIndicatorWidth,
            height: AppSizes.tabIndicatorHeight,
            decoration: BoxDecoration(
              color: isSelected
                  ? colors.accent
                  : colors.accent.withValues(alpha: 0),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
        ],
      ),
    );
  }
}
