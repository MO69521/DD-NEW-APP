import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/domain/entities/book.dart';
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
  final ValueChanged<Book>? onBookTap;

  @override
  Widget build(BuildContext context) {
    final visibleBooks =
        booksByTab[selectedTab] ?? booksByTab[RankingTab.recommend] ?? const [];

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
          RankingBookGrid(books: visibleBooks, onBookTap: onBookTap),
        ],
      ),
    );
  }
}
