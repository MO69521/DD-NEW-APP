import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/account_security_binding.dart';

/// L3 组件 — 账号设置安全绑定行。
class AccountSettingsSecurityRow extends StatelessWidget {
  const AccountSettingsSecurityRow({
    super.key,
    required this.binding,
    this.onTap,
  });

  final AccountSecurityBinding binding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      pressScale: AppSizes.tapPressScaleSubtle,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: AppSizes.listRowMinHeight,
        ),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                AppIcon(
                  assetPath: binding.iconAsset,
                  width: AppSizes.accountSettingsBindingIconSize,
                  height: AppSizes.accountSettingsBindingIconSize,
                  color: AppColors.textOnDark,
                ),
                const SizedBox(width: AppSpacing.sm),
                AppText(
                  binding.isBound && binding.displayValue != null
                      ? binding.displayValue!
                      : binding.label,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textOnDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                AppText(
                  binding.actionLabel,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textOnDarkPlaceholder,
                  ),
                ),
                const SizedBox(width: AppSpacing.xxs),
                const AppIcon(
                  assetPath: 'assets/icons/arrow_right.svg',
                  width: AppSpacing.sm,
                  height: AppSpacing.sm,
                  color: AppColors.textOnDarkPlaceholder,
                ),
              ],
            ),
          ),
        ),
    );
  }
}
