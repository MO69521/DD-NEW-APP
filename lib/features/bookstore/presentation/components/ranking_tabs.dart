import 'package:flutter/material.dart';

import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_context.dart';
import '../../../../shared/components/elastic_tab_indicator.dart';
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
    final slotWidth = AppSizes.rankingTabSlotWidth;
    final slotPitch = slotWidth + AppSpacing.md;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: SizedBox(
        width: slotWidth * tabs.length + AppSpacing.md * (tabs.length - 1),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (var i = 0; i < tabs.length; i++) ...[
                  if (i > 0) const SizedBox(width: AppSpacing.md),
                  _RankingTabItem(
                    tab: tabs[i],
                    isSelected: tabs[i] == selected,
                    width: slotWidth,
                    onTap: () => onSelected(tabs[i]),
                  ),
                ],
              ],
            ),
            ElasticTabIndicator(
              selectedIndex: tabs.indexOf(selected),
              slotWidth: slotWidth,
              slotPitch: slotPitch,
            ),
          ],
        ),
      ),
    );
  }
}

class _RankingTabItem extends StatelessWidget {
  const _RankingTabItem({
    required this.tab,
    required this.isSelected,
    required this.width,
    required this.onTap,
  });

  final RankingTab tab;
  final bool isSelected;
  final double width;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: width,
        child: Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
          child: AppText(
            tab.label,
            style:
                (isSelected
                        ? AppTextStyles.tabActiveDark
                        : AppTextStyles.tabInactiveDark)
                    .copyWith(
                      color: isSelected ? colors.textPrimary : colors.textMuted,
                    ),
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
