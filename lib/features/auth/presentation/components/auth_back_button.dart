import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../../../shared/widgets/app_pressable.dart';

/// 登录流程返回按钮（手动登录返回 / 验证码页返回共用）。
class AuthBackButton extends StatelessWidget {
  const AuthBackButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      child: const Padding(
        padding: EdgeInsets.all(AppSpacing.xs),
        child: AppIcon(
          assetPath: 'assets/icons/ranking/back.svg',
          width: AppSizes.topBarBackIconWidth,
          height: AppSizes.topBarBackIconHeight,
          color: AppColors.textOnDark,
        ),
      ),
    );
  }
}
