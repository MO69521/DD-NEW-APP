import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';

/// L2 — 弹窗顶部彩头渐变（须放在 [Stack] 内）。
///
/// 仅 `yellow_light` 可见：顶部淡黄（`dialogTopHeaderGradientStart`）→ 底部透明；
/// 其余主题起止均为透明，不改变深色 / 浅粉弹窗外观。
class AppDialogTopTexture extends StatelessWidget {
  const AppDialogTopTexture({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: AppSizes.dialogTopTextureHeight,
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.dialogTopHeaderGradientStart,
                AppColors.dialogTopHeaderGradientEnd,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
