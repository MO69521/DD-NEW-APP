import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_icon_assets.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../../../shared/widgets/app_text.dart';

/// L3 — 搜索空态：插画占位 + 引导文案。
class SearchEmptyView extends StatelessWidget {
  const SearchEmptyView({super.key, required this.caption});

  final String caption;

  // 搜索图标占位 SVG，待 Figma 导出小熊放大镜插画后替换。
  static const String _placeholderIllustration = AppIconAssets.search;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(flex: AppSizes.searchEmptyTopFlex),
        const _IllustrationPlaceholder(),
        const SizedBox(height: AppSpacing.md),
        AppText(caption, style: AppTextStyles.searchEmptyCaption),
        const Spacer(flex: AppSizes.searchEmptyBottomFlex),
      ],
    );
  }
}

class _IllustrationPlaceholder extends StatelessWidget {
  const _IllustrationPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.searchEmptyIllustrationSize,
      height: AppSizes.searchEmptyIllustrationSize,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.surfaceCard,
        shape: BoxShape.circle,
      ),
      child: const AppIcon(
        assetPath: SearchEmptyView._placeholderIllustration,
        width: AppSizes.searchEmptyIconSize,
        height: AppSizes.searchEmptyIconSize,
        color: AppColors.textOnDarkMuted,
      ),
    );
  }
}
