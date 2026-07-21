import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_icon_assets.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../widgets/app_text.dart';
import 'section_trailing_action.dart';

/// Level 2 — 区块标题 + 可选标题后缀 + 可选右侧尾随操作。
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.titleStyle,
    this.titleSuffix,
    this.actionLabel,
    this.actionIconAsset = AppIconAssets.arrowRight,
    this.onActionTap,
  });

  final String title;
  final TextStyle? titleStyle;

  /// 标题右侧附属（如角色介绍旁的说明图标），位于标题与 `Spacer` 之间。
  final Widget? titleSuffix;
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
        if (titleSuffix != null) ...[
          const SizedBox(width: AppSpacing.xxs),
          titleSuffix!,
        ],
        const Spacer(),
        if (actionLabel != null)
          SectionTrailingAction(
            label: actionLabel!,
            onTap: onActionTap,
            iconAsset: actionIconAsset,
          ),
      ],
    );
  }
}
