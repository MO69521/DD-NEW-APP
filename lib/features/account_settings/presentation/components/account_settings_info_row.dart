import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../../../shared/widgets/app_network_avatar.dart';
import '../../../../shared/widgets/app_text.dart';

/// L3 组件 — 账号设置个人信息行（可导航 / 只读）。
class AccountSettingsInfoRow extends StatelessWidget {
  const AccountSettingsInfoRow({
    super.key,
    required this.label,
    this.value,
    this.avatarUrl,
    this.onTap,
    this.showChevron = true,
  });

  final String label;
  final String? value;
  final String? avatarUrl;
  final VoidCallback? onTap;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final isTappable = onTap != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: AppSizes.accountSettingsRowHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                AppText(
                  label,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textOnDark,
                  ),
                ),
                const Spacer(),
                if (avatarUrl != null)
                  AppNetworkAvatar(
                    imageUrl: avatarUrl!,
                    size: AppSizes.accountSettingsAvatarSize,
                  )
                else if (value != null)
                  AppText(
                    value!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isTappable
                          ? AppColors.textOnDarkMuted
                          : AppColors.textOnDarkMuted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (showChevron && isTappable) ...[
                  const SizedBox(width: AppSpacing.xxs),
                  const AppIcon(
                    assetPath: 'assets/icons/arrow_right.svg',
                    width: AppSpacing.sm,
                    height: AppSpacing.sm,
                    color: AppColors.textOnDarkPlaceholder,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
