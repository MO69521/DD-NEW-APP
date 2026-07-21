import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_icon_assets.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../widgets/app_icon.dart';
import '../widgets/app_pressable.dart';
import '../widgets/app_text.dart';

/// Level 2 — 区块标题右侧尾随操作：文案 + 右箭头（目录状态 / 滑动提示 /「更多」等）。
class SectionTrailingAction extends StatelessWidget {
  const SectionTrailingAction({
    super.key,
    required this.label,
    this.onTap,
    this.labelStyle,
    this.iconAsset = AppIconAssets.arrowRight,
    this.iconColor,
  });

  final String label;
  final VoidCallback? onTap;
  final TextStyle? labelStyle;
  final String iconAsset;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText(
          label,
          style: labelStyle ?? AppTextStyles.sectionTrailingAction,
        ),
        const SizedBox(width: AppSpacing.xxs),
        AppIcon(
          assetPath: iconAsset,
          width: AppSizes.sectionTrailingIconSize,
          height: AppSizes.sectionTrailingIconSize,
          color: iconColor ?? AppColors.sectionActionIcon,
        ),
      ],
    );

    if (onTap == null) return content;

    return AppPressable(onTap: onTap, child: content);
  }
}
