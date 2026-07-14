import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../application/login_cubit.dart';

/// 底部第三方登录区（微信 / QQ / 抖音），一键登录与手机号登录入口共用。
class SocialLoginSection extends StatelessWidget {
  const SocialLoginSection({super.key, required this.onTap});

  final ValueChanged<AuthSocialProvider> onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText('其他方式登录', style: AppTextStyles.bodyMediumDarkMuted),
        const SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _SocialLoginButton(
              provider: AuthSocialProvider.wechat,
              assetPath: 'assets/icons/account_settings/wechat.svg',
              onTap: onTap,
            ),
            const SizedBox(width: AppSpacing.xl),
            _SocialLoginButton(
              provider: AuthSocialProvider.qq,
              assetPath: 'assets/icons/account_settings/qq.svg',
              onTap: onTap,
            ),
            const SizedBox(width: AppSpacing.xl),
            _SocialLoginButton(
              provider: AuthSocialProvider.douyin,
              assetPath: 'assets/icons/account_settings/douyin.svg',
              onTap: onTap,
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  const _SocialLoginButton({
    required this.provider,
    required this.assetPath,
    required this.onTap,
  });

  final AuthSocialProvider provider;
  final String assetPath;
  final ValueChanged<AuthSocialProvider> onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: provider.label,
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppPressable(
              onTap: () => onTap(provider),
              child: Container(
                width: AppSpacing.xxl,
                height: AppSpacing.xxl,
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Center(
                  child: AppIcon(
                    assetPath: assetPath,
                    width: AppSizes.accountSettingsBindingIconSize,
                    height: AppSizes.accountSettingsBindingIconSize,
                    color: AppColors.textOnDark,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            AppText(
              provider.label,
              style: AppTextStyles.captionMdDarkMuted,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
