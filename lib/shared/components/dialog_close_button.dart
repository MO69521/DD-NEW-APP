import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import '../widgets/app_pressable.dart';

/// L2 — 统一居中弹窗关闭按钮：圆形玻璃底 + 关闭图标。
///
/// 放置在弹窗卡片下方居中位置；点击回调一般为 `AppRouter.pop`。
/// 货币说明、角色帮助、签到成功等居中弹窗统一复用。
class DialogCloseButton extends StatelessWidget {
  const DialogCloseButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      child: Container(
        width: AppSizes.topBarCircleSize,
        height: AppSizes.topBarCircleSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.overlayScrim,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.borderGlass,
            width: AppSizes.hairline,
          ),
        ),
        child: const Icon(
          Icons.close_rounded,
          size: AppSizes.topBarActionIconSize,
          color: AppColors.textOnDark,
        ),
      ),
    );
  }
}
