import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/app_blurred_chrome_bar.dart';
import '../../../../shared/widgets/app_button.dart';

/// L3 — 我的装扮页底部操作栏。
///
/// 选中项即为当前使用中时，按钮置灰禁用并显示「已装扮」；否则可点击装扮。
class DressUpBottomBar extends StatelessWidget {
  const DressUpBottomBar({super.key, required this.isEquipped, this.onEquip});

  final bool isEquipped;
  final VoidCallback? onEquip;

  @override
  Widget build(BuildContext context) {
    return AppBlurredChromeBar(
      scrimColor: AppColors.bottomActionBarScrim,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppColors.borderGlass,
              width: AppSizes.hairline,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: AppButton(
              label: isEquipped ? '已装扮' : '立即装扮',
              variant: isEquipped
                  ? AppButtonVariant.secondary
                  : AppButtonVariant.accent,
              isExpanded: true,
              onPressed: isEquipped ? null : onEquip,
            ),
          ),
        ),
      ),
    );
  }
}
