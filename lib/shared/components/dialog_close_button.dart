import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import '../widgets/app_pressable.dart';

/// L2 — 统一居中弹窗关闭按钮：弹窗右上角「X」图标。
///
/// 统一置于弹窗卡片右上角，距顶部 / 右侧 [AppSpacing.lg]（24）内边距；
/// 点击回调一般为 `AppRouter.pop` / `Navigator.pop`。所有居中弹窗复用。
class DialogCloseButton extends StatelessWidget {
  const DialogCloseButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      child: const Icon(
        Icons.close_rounded,
        size: AppSizes.topBarActionIconSize,
        color: AppColors.textOnDarkMuted,
      ),
    );
  }
}
