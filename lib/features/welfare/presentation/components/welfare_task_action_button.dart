import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_welfare_colors.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/welfare_models.dart';
import '../mappers/welfare_asset_mapper.dart';

/// L3 组件 — 福利任务右侧动作按钮。
class WelfareTaskActionButton extends StatelessWidget {
  const WelfareTaskActionButton({super.key, required this.action, this.onTap});

  final WelfareTaskAction action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final background = action.isPrimary
        ? AppWelfareColors.checkInMilestoneBubbleEnd
        : AppWelfareColors.taskActionBg;
    final foreground = action.isPrimary
        ? AppWelfareColors.checkInCtaTextDark
        : AppColors.textOnDark;

    return AppPressable(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: AppSizes.welfareTaskActionMinWidth,
        ),
        child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(AppRadius.welfareCheckInCta),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (action.showVideoIcon) ...[
                  AppAssetImage(
                    assetPath: WelfareAssetMapper.taskVideoIconAsset(),
                    width: AppSizes.welfareTaskActionIconSize,
                    height: AppSizes.welfareTaskActionIconSize,
                    color: foreground,
                  ),
                  const SizedBox(width: AppSpacing.xxsHalf),
                ],
                AppText(
                  action.label,
                  style: AppTextStyles.welfareCtaText.copyWith(
                    color: foreground,
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
