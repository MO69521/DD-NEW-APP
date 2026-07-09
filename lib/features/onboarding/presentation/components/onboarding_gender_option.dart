import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';

/// L3 组件 — 性别选项（圆形头像 + 文字标签）。
///
/// 选中显示彩色头像 [activeAsset]、黄色描边高亮（参照装扮选中）+ 白色文字；
/// 未选显示灰色头像 [inactiveAsset]、细描边 + 60% 白文字。不填充底色。
class OnboardingGenderOption extends StatelessWidget {
  const OnboardingGenderOption({
    super.key,
    required this.label,
    required this.activeAsset,
    required this.inactiveAsset,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String activeAsset;
  final String inactiveAsset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final avatar = ClipOval(
      child: AppAssetImage(
        assetPath: selected ? activeAsset : inactiveAsset,
        fit: BoxFit.cover,
      ),
    );

    return AppPressable(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: AppSizes.onboardingGenderAvatarSize,
            height: AppSizes.onboardingGenderAvatarSize,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? AppColors.accentYellow
                      : AppColors.borderGlass,
                  width: selected
                      ? AppSizes.borderWidthEmphasis
                      : AppSizes.hairline,
                ),
              ),
              // 选中态：描边与头像间留间隙，形成黄色描边环。
              child: selected
                  ? Padding(
                      padding: const EdgeInsets.all(AppSpacing.xxs),
                      child: avatar,
                    )
                  : avatar,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          AppText(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: selected
                  ? AppColors.textOnDark
                  : AppColors.textOnDarkPlaceholder,
            ),
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
