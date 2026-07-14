import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/components/app_animated_tab_label.dart';
import '../../../../shared/components/elastic_tab_row.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../domain/entities/dress_up_tab.dart';

/// L3 — 我的装扮页 Tab（主页背景 / 头像 / 头像挂件 / 称号）。
///
/// 按文案实际宽度排布（非均分），项间距固定 16px；黄色指示器复用统一
/// [ElasticTabRow]（§3.5），按实测中心点对齐，并随 [swipeProgress] 跟手。
class DressUpTabBar extends StatelessWidget {
  const DressUpTabBar({
    super.key,
    required this.selected,
    required this.onSelected,
    this.swipeProgress,
  });

  final DressUpTab selected;
  final ValueChanged<DressUpTab> onSelected;

  /// 内容区左右滑动的连续进度（0..tabCount-1），驱动指示器跟手位移。
  final ValueListenable<double>? swipeProgress;

  @override
  Widget build(BuildContext context) {
    const tabs = DressUpTab.values;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: ElasticTabRow(
        selectedIndex: tabs.indexOf(selected),
        swipeProgress: swipeProgress,
        children: [
          for (var i = 0; i < tabs.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.md),
            _DressUpTabItem(
              tab: tabs[i],
              index: i,
              selectedIndex: tabs.indexOf(selected),
              swipeProgress: swipeProgress,
              onTap: () => onSelected(tabs[i]),
            ),
          ],
        ],
      ),
    );
  }
}

class _DressUpTabItem extends StatelessWidget {
  const _DressUpTabItem({
    required this.tab,
    required this.index,
    required this.selectedIndex,
    this.swipeProgress,
    required this.onTap,
  });

  final DressUpTab tab;
  final int index;
  final int selectedIndex;
  final ValueListenable<double>? swipeProgress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.xs),
        child: Center(
          heightFactor: 1.0,
          child: AppAnimatedTabLabel(
            index: index,
            selectedIndex: selectedIndex,
            label: tab.label,
            activeStyle: AppTextStyles.tabActiveDark.copyWith(
              color: AppColors.textOnDark,
            ),
            inactiveStyle: AppTextStyles.tabInactiveDark.copyWith(
              color: AppColors.textOnDarkMuted,
            ),
            swipeProgress: swipeProgress,
          ),
        ),
      ),
    );
  }
}
