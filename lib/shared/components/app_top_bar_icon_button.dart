import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_brand_colors.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import '../widgets/app_icon.dart';
import '../widgets/app_pressable.dart';

/// L2 — 顶部栏通用图标按钮。
///
/// 默认用于右侧图标动作：仅显示图标并保留统一点击热区，不绘制背景填充。
/// 左侧返回按钮可传 [showFrame] 保留圆形磨砂框。
class AppTopBarIconButton extends StatelessWidget {
  const AppTopBarIconButton({
    super.key,
    required this.iconAsset,
    this.iconWidth = AppSizes.topBarActionIconDisplaySize,
    this.iconHeight,
    this.iconColor = AppColors.textOnDark,
    this.showFrame = false,
    this.onTap,
  });

  final String iconAsset;
  final double iconWidth;
  final double? iconHeight;
  final Color iconColor;
  final bool showFrame;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      child: SizedBox(
        width: AppSizes.topBarCircleSize,
        height: AppSizes.topBarCircleSize,
        child: Center(child: showFrame ? _buildFramedIcon() : _buildIcon()),
      ),
    );
  }

  Widget _buildIcon() {
    return AppIcon(
      assetPath: iconAsset,
      width: iconWidth,
      height: iconHeight ?? iconWidth,
      color: iconColor,
    );
  }

  Widget _buildFramedIcon() {
    final framedIcon = DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.topBarIconFrameBackground,
        border: Border.all(
          color: AppColors.topBarIconFrameBorder,
          width: AppSizes.hairline,
        ),
        shape: BoxShape.circle,
      ),
      child: Center(child: _buildIcon()),
    );

    return SizedBox(
      width: AppSizes.topBarIconFrameSize,
      height: AppSizes.topBarIconFrameSize,
      child: AppBrandColors.isLightExperiment
          ? framedIcon
          : ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: AppSizes.topBarIconFrameBlurSigma,
                  sigmaY: AppSizes.topBarIconFrameBlurSigma,
                ),
                child: framedIcon,
              ),
            ),
    );
  }
}
