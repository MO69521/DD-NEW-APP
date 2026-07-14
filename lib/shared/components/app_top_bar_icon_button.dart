import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import '../widgets/app_icon.dart';
import '../widgets/app_pressable.dart';

/// L2 — 顶部栏通用图标按钮：32×32 纯白 4% 半透明模糊底框 + 4% 白描边 + 居中图标。
class AppTopBarIconButton extends StatelessWidget {
  const AppTopBarIconButton({
    super.key,
    required this.iconAsset,
    this.iconWidth = AppSizes.topBarActionIconDisplaySize,
    this.iconHeight,
    this.iconColor = AppColors.textOnDark,
    this.onTap,
  });

  final String iconAsset;
  final double iconWidth;
  final double? iconHeight;
  final Color iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      child: SizedBox(
        width: AppSizes.topBarCircleSize,
        height: AppSizes.topBarCircleSize,
        child: Center(
          child: SizedBox(
            width: AppSizes.topBarIconFrameSize,
            height: AppSizes.topBarIconFrameSize,
            child: ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: AppSizes.topBarIconFrameBlurSigma,
                  sigmaY: AppSizes.topBarIconFrameBlurSigma,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.topBarIconFrameBackground,
                    border: Border.all(
                      color: AppColors.topBarIconFrameBorder,
                      width: AppSizes.hairline,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: AppIcon(
                      assetPath: iconAsset,
                      width: iconWidth,
                      height: iconHeight ?? iconWidth,
                      color: iconColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
