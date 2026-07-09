import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../domain/entities/welfare_models.dart';
import '../mappers/welfare_asset_mapper.dart';

/// L3 组件 — 福利任务右侧动作按钮（统一走 [AppButton]）。
///
/// 主操作用 `accent`（主黄 + 深字），次操作用 `secondary`（弱底 + 白字）；
/// 需要「看视频」提示时以 [AppButton.leadingIcon] 前置视频图标。
class WelfareTaskActionButton extends StatelessWidget {
  const WelfareTaskActionButton({super.key, required this.action, this.onTap});

  final WelfareTaskAction action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final variant = action.isPrimary
        ? AppButtonVariant.accent
        : AppButtonVariant.secondary;
    final iconColor = action.isPrimary
        ? AppColors.rankingSegmentedSelectedText
        : AppColors.textOnDark;

    return AppButton(
      label: action.label,
      variant: variant,
      size: AppButtonSize.small,
      onPressed: onTap,
      leadingIcon: action.showVideoIcon
          ? AppAssetImage(
              assetPath: WelfareAssetMapper.taskVideoIconAsset(),
              width: AppSizes.welfareTaskActionIconSize,
              height: AppSizes.welfareTaskActionIconSize,
              color: iconColor,
            )
          : null,
    );
  }
}
