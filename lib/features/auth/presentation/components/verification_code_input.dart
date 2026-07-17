import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/app_digit_code_input.dart';

/// 短信验证码输入：复用共享分格数字输入，固定为 6 位明文数字。
class VerificationCodeInput extends StatelessWidget {
  const VerificationCodeInput({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppDigitCodeInput(
      value: value,
      onChanged: onChanged,
      length: AppConstants.smsCodeLength,
    );
  }
}
