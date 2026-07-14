import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../application/login_state.dart';
import 'auth_agreement_notice.dart';
import 'login_layout.dart';

/// 一键登录表单（检测到本机号码时展示）。
class OneClickLoginForm extends StatelessWidget {
  const OneClickLoginForm({
    super.key,
    required this.state,
    required this.onOneClickLogin,
    required this.onUseOtherPhone,
    required this.onAgreementTap,
  });

  final LoginState state;
  final VoidCallback onOneClickLogin;
  final VoidCallback onUseOtherPhone;
  final VoidCallback onAgreementTap;

  @override
  Widget build(BuildContext context) {
    final ui = state.ui;
    final detectedPhone = ui.detectedPhone ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.settingsLogo),
            child: const AppAssetImage(
              assetPath: LoginLayout.appIconAsset,
              width: AppSizes.settingsLogoSize,
              height: AppSizes.settingsLogoSize,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: AppText(
            maskLoginPhone(detectedPhone),
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.textOnDark,
            ),
            maxLines: 1,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Center(
          child: AppText(
            '检测到本机号码，可一键登录',
            style: AppTextStyles.bodyMediumDarkMuted,
            maxLines: 1,
          ),
        ),
        const SizedBox(height: LoginLayout.inputToButtonGap),
        TextFieldTapRegion(
          child: AppButton(
            label: '本机号码一键登录',
            variant: AppButtonVariant.accent,
            isExpanded: true,
            isLoading: ui.isOneClickLoggingIn,
            onPressed: ui.canOneClickLogin ? onOneClickLogin : null,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextFieldTapRegion(
          child: AppButton(
            label: '其他手机号登录',
            variant: AppButtonVariant.secondary,
            isExpanded: true,
            onPressed: ui.isOneClickLoggingIn ? null : onUseOtherPhone,
          ),
        ),
        const SizedBox(height: LoginLayout.buttonToAgreementGap),
        TextFieldTapRegion(
          child: AuthAgreementNotice(
            isSelected: ui.isAgreementAccepted,
            onToggle: onAgreementTap,
          ),
        ),
      ],
    );
  }
}
