import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../application/login_state.dart';
import 'auth_agreement_notice.dart';
import 'login_layout.dart';
import 'login_text_field.dart';

/// 手机号 + 获取验证码表单。
class PhoneLoginForm extends StatelessWidget {
  const PhoneLoginForm({
    super.key,
    required this.state,
    required this.onPhoneChanged,
    required this.onSendCode,
    required this.onSendCodeUnavailable,
    required this.onAgreementTap,
  });

  final LoginState state;
  final ValueChanged<String> onPhoneChanged;
  final VoidCallback onSendCode;
  final VoidCallback onSendCodeUnavailable;
  final VoidCallback onAgreementTap;

  @override
  Widget build(BuildContext context) {
    final ui = state.ui;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LoginTextField(
          hintText: '请输入手机号',
          maxLength: AppConstants.phoneNumberLength,
          keyboardType: TextInputType.phone,
          initialValue: ui.phone,
          onChanged: onPhoneChanged,
        ),
        const SizedBox(height: LoginLayout.inputToButtonGap),
        if (!ui.hasRequestedCode)
          TextFieldTapRegion(
            child: AppButton(
              label: '获取验证码',
              variant: ui.canSendCode
                  ? AppButtonVariant.accent
                  : AppButtonVariant.secondary,
              isExpanded: true,
              isLoading: ui.isSendingCode,
              onPressed: ui.canSendCode ? onSendCode : null,
              onDisabledPressed: ui.canSendCode ? null : onSendCodeUnavailable,
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
