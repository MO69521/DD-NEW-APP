import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/domain/entities/book.dart';
import '../../../../shared/components/app_swipe_tab_switcher.dart';
import 'ranking_book_grid.dart';
import 'ranking_section_header.dart';
import '../../../../core/theme/app_colors.dart';

/// 推荐榜区块（Figma 697:8778）：Tab + 左图右文 2x3 宫格（最多 6 本）。
class RankingSection extends StatelessWidget {
  const RankingSection({
    super.key,
    required this.booksByTab,
    required this.selectedTab,
    required this.onTabSelected,
    this.onFullListTap,
    this.onBookTap,
  });

  final Map<RankingTab, List<Book>> booksByTab;
  final RankingTab selectedTab;
  final ValueChanged<RankingTab> onTabSelected;
  final VoidCallback? onFullListTap;

  /// 回调携带该卡封面的屏内唯一 Hero 标签，供详情页同 tag 飞行。
  final void Function(Book book, Object coverHeroTag)? onBookTap;

  @override
  Widget build(BuildContext context) {
    const tabs = RankingTab.values;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RankingSectionHeader(
            selectedTab: selectedTab,
            onTabSelected: onTabSelected,
            onFullListTap: onFullListTap,
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: RankingBookGrid.contentHeight,
            child: AppSwipeTabSwitcher(
              selectedIndex: tabs.indexOf(selectedTab),
              onIndexChanged: (index) => onTabSelected(tabs[index]),
              children: [
                for (final tab in tabs)
                  RankingBookGrid(
                    books: booksByTab[tab] ?? const [],
                    heroNamespace: 'ranking-${tab.name}',
                    onBookTap: onBookTap,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
