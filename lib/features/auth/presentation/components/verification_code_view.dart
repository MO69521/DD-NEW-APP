import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../application/login_state.dart';
import 'auth_back_button.dart';
import 'login_layout.dart';
import 'verification_code_input.dart';

/// 验证码输入页（发送验证码后展示）。
class VerificationCodeView extends StatelessWidget {
  const VerificationCodeView({
    super.key,
    required this.state,
    required this.statusBarHeight,
    required this.onBack,
    required this.onCodeChanged,
    required this.onResendCode,
  });

  final LoginState state;
  final double statusBarHeight;
  final VoidCallback onBack;
  final ValueChanged<String> onCodeChanged;
  final VoidCallback onResendCode;

  @override
  Widget build(BuildContext context) {
    final ui = state.ui;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: ListView(
            padding: EdgeInsets.only(
              top: statusBarHeight + AppSpacing.lg,
              bottom: AppSpacing.xl,
            ),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: AuthBackButton(onTap: onBack),
              ),
              const SizedBox(height: AppSpacing.xl),
              AppText(
                '请输入验证码',
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.textOnDark,
                ),
              ),
              const SizedBox(height: AppSpacing.authTitleContentGap),
              AppText('验证码已通过短信发送至：', style: AppTextStyles.bodyMediumDarkMuted),
              const SizedBox(height: AppSpacing.sm),
              AppText(
                maskLoginPhone(ui.phone),
                style: AppTextStyles.titleMediumDark,
              ),
              const SizedBox(height: AppSpacing.xl),
              VerificationCodeInput(value: ui.code, onChanged: onCodeChanged),
              const SizedBox(height: AppSpacing.md),
              _ResendCodeAction(
                countdownSeconds: ui.countdownSeconds,
                isLoading: ui.isSendingCode,
                onTap: ui.canSendCode ? onResendCode : null,
              ),
              if (ui.isLoggingIn) ...[
                const SizedBox(height: AppSpacing.xxl),
                const Center(child: CircularProgressIndicator()),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ResendCodeAction extends StatelessWidget {
  const _ResendCodeAction({
    required this.countdownSeconds,
    required this.isLoading,
    required this.onTap,
  });

  final int countdownSeconds;
  final bool isLoading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final label = countdownSeconds > 0
        ? '${countdownSeconds}s 后重新获取'
        : '重新获取验证码';

    return AppPressable(
      onTap: isLoading ? null : onTap,
      child: AppText(
        isLoading ? '发送中...' : label,
        style: AppTextStyles.bodyMedium.copyWith(
          color: onTap == null
              ? AppColors.textOnDarkMuted
              : AppColors.accentText,
        ),
      ),
    );
  }
}
