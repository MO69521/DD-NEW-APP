import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/domain/entities/book.dart';
import 'ranking_tabs.dart';

/// 榜单区块头部（Figma 456:12300）：Tab 行 + 「完整榜单」胶囊入口。
class RankingSectionHeader extends StatelessWidget {
  const RankingSectionHeader({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
    this.onFullListTap,
  });

  final RankingTab selectedTab;
  final ValueChanged<RankingTab> onTabSelected;
  final VoidCallback? onFullListTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: RankingTabs(selected: selectedTab, onSelected: onTabSelected),
        ),
        const SizedBox(width: AppSpacing.xs),
        GestureDetector(
          onTap: onFullListTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: const EdgeInsets.only(
              left: AppSpacing.sm,
              right: AppSpacing.xs,
              top: AppSpacing.xs,
              bottom: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(
                AppRadius.rankingFullListAction,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  '完整榜单',
                  style: AppTextStyles.linkSmallDark.copyWith(
                    color: AppColors.accentYellow,
                  ),
                ),
                AppIcon(
                  assetPath: 'assets/icons/arrow_right.svg',
                  width: AppSizes.rankingFullListIconSize,
                  height: AppSizes.rankingFullListIconSize,
                  color: AppColors.accentYellow,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
