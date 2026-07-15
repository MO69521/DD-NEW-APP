import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_icon_assets.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';

/// L3 — 搜索关键词标签（历史 / 热门共用）。
///
/// [isHot] 为置顶热词：橙色浅底 + 橙色文字 + 火焰图标强调（无描边）。
class SearchKeywordChip extends StatelessWidget {
  const SearchKeywordChip({
    super.key,
    required this.label,
    this.isHot = false,
    this.onTap,
  });

  final String label;
  final bool isHot;
  final VoidCallback? onTap;

  static const double _hotTintOpacity = 0.14;

  @override
  Widget build(BuildContext context) {
    final labelColor = isHot ? AppColors.searchHotAccent : AppColors.textOnDark;

    return AppPressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isHot
              ? AppColors.searchHotAccent.withValues(alpha: _hotTintOpacity)
              : AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: isHot
              ? null
              : Border.all(
                  color: AppColors.borderGlass,
                  width: AppSizes.hairline,
                ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isHot) ...[
              const AppAssetImage(
                assetPath: AppIconAssets.hotFlame,
                width: AppFontSizes.base,
                height: AppFontSizes.base,
                color: AppColors.searchHotAccent,
              ),
              const SizedBox(width: AppSpacing.xxs),
            ],
            AppText(
              label,
              style: AppTextStyles.bodyMedium.copyWith(color: labelColor),
            ),
          ],
        ),
      ),
    );
  }
}
