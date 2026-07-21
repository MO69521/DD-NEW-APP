import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../domain/entities/welfare_models.dart';
import '../mappers/welfare_asset_mapper.dart';

/// L3 组件 — 福利任务右侧动作按钮（统一走 [AppButton]）。
///
/// 所有任务操作统一使用 `accent` 高亮可点击态；需要「看视频」提示时以
/// [AppButton.leadingIcon] 前置视频图标。
class WelfareTaskActionButton extends StatelessWidget {
  const WelfareTaskActionButton({super.key, required this.action, this.onTap});

  final WelfareTaskAction action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: action.label,
      variant: AppButtonVariant.accent,
      size: AppButtonSize.small,
      onPressed: onTap,
      iconLabelGap: AppSpacing.xxs,
      leadingIcon: action.showVideoIcon
          ? AppAssetImage(
              assetPath: WelfareAssetMapper.taskVideoIconAsset(),
              width: AppSizes.welfareTaskActionIconSize,
              height: AppSizes.welfareTaskActionIconSize,
              color: AppColors.onPrimary,
            )
          : null,
    );
  }
}
