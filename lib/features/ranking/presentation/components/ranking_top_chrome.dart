import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_router.dart';
import '../../../../routes/app_routes.dart';
import '../../../../shared/components/app_blurred_chrome_bar.dart';
import '../../../../shared/components/app_top_bar_icon_button.dart';
import '../../../../shared/widgets/app_text.dart';

class RankingTopChrome extends StatelessWidget {
  const RankingTopChrome({
    super.key,
    required this.statusBarHeight,
    required this.blurEnabled,
  });

  final double statusBarHeight;
  final bool blurEnabled;

  static const String _searchIconAsset = 'assets/icons/search.svg';

  @override
  Widget build(BuildContext context) {
    return AppBlurredChromeBar(
      enabled: blurEnabled,
      child: Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: SizedBox(
          height: AppSizes.bookstoreTopHeaderHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const _RankingTopTabs(),
                Align(
                  alignment: Alignment.centerRight,
                  child: AppTopBarIconButton(
                    onTap: () => AppRouter.pushNamed(AppRoutes.searchName),
                    iconAsset: _searchIconAsset,
                    iconWidth: AppSizes.bookstoreSearchIconSize,
                    iconHeight: AppSizes.bookstoreSearchIconSize,
                    iconColor: AppColors.textOnDarkMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RankingTopTabs extends StatelessWidget {
  const _RankingTopTabs();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: const [
        _RankingTopTab(
          label: '推荐',
          style: AppTextStyles.tabInactiveDark,
          route: AppRoutes.home,
        ),
        SizedBox(width: AppSpacing.md),
        _RankingTopTab(
          label: '分类',
          style: AppTextStyles.tabInactiveDark,
          route: AppRoutes.category,
        ),
        SizedBox(width: AppSpacing.md),
        _RankingTopTab(label: '排行', style: AppTextStyles.tabActiveDark),
      ],
    );
  }
}

class _RankingTopTab extends StatelessWidget {
  const _RankingTopTab({required this.label, required this.style, this.route});

  final String label;
  final TextStyle style;
  final String? route;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: route == null ? null : () => AppRouter.go(route!),
      behavior: HitTestBehavior.opaque,
      child: AppText(label, style: style),
    );
  }
}
