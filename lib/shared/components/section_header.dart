import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_icon_assets.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../widgets/app_icon.dart';
import '../widgets/app_pressable.dart';
import '../widgets/app_text.dart';

/// Level 2 — 区块标题 + 可选右侧操作链接。
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.titleStyle,
    this.actionLabel,
    this.actionIconAsset = AppIconAssets.arrowRight,
    this.onActionTap,
  });

  final String title;
  final TextStyle? titleStyle;
  final String? actionLabel;
  final String actionIconAsset;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppText(
          title,
          style:
              titleStyle ??
              AppTextStyles.sectionTitleDark.copyWith(
                color: AppColors.textOnDark,
              ),
        ),
        const Spacer(),
        if (actionLabel != null)
          AppPressable(
            onTap: onActionTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  actionLabel!,
                  style: AppTextStyles.bookTagDark.copyWith(
                    color: AppColors.textOnDarkMuted,
                  ),
                ),
                const SizedBox(width: AppSpacing.xxs),
                AppIcon(
                  assetPath: actionIconAsset,
                  width: AppSpacing.sm,
                  height: AppSpacing.sm,
                  color: AppColors.sectionActionIcon,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
