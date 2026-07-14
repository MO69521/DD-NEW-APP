import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_router.dart';
import '../../../../routes/app_routes.dart';
import '../../../../shared/components/app_toast.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_selection_mark.dart';

/// 登录协议勾选与富文本条款入口（一键登录 / 手机号登录表单共用）。
class AuthAgreementNotice extends StatefulWidget {
  const AuthAgreementNotice({
    super.key,
    required this.isSelected,
    required this.onToggle,
  });

  final bool isSelected;
  final VoidCallback onToggle;

  @override
  State<AuthAgreementNotice> createState() => _AuthAgreementNoticeState();
}

class _AuthAgreementNoticeState extends State<AuthAgreementNotice> {
  late final TapGestureRecognizer _mobileTermsRecognizer =
      TapGestureRecognizer()
        ..onTap = () => AppToast.show(context, '中国移动认证服务条款即将上线');
  late final TapGestureRecognizer _userAgreementRecognizer =
      TapGestureRecognizer()
        ..onTap = () => AppRouter.pushNamed(
          AppRoutes.settingsDocumentName,
          pathParameters: {'type': 'user-agreement'},
        );
  late final TapGestureRecognizer _privacyPolicyRecognizer =
      TapGestureRecognizer()
        ..onTap = () => AppRouter.pushNamed(
          AppRoutes.settingsDocumentName,
          pathParameters: {'type': 'privacy-policy'},
        );
  late final TapGestureRecognizer _minorProtectionRecognizer =
      TapGestureRecognizer()
        ..onTap = () => AppToast.show(context, '未成年人保护规则即将上线');

  @override
  void dispose() {
    _mobileTermsRecognizer.dispose();
    _userAgreementRecognizer.dispose();
    _privacyPolicyRecognizer.dispose();
    _minorProtectionRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle = AppTextStyles.authAgreementDarkMuted;
    final linkStyle = AppTextStyles.authAgreementLinkDark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppPressable(
          onTap: widget.onToggle,
          child: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xxsHalf),
            child: AppSelectionMark(isSelected: widget.isSelected),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: baseStyle,
              children: [
                const TextSpan(text: '我已阅读并同意'),
                TextSpan(
                  text: '中国移动认证服务条款',
                  style: linkStyle,
                  recognizer: _mobileTermsRecognizer,
                ),
                const TextSpan(text: '、'),
                TextSpan(
                  text: '用户协议',
                  style: linkStyle,
                  recognizer: _userAgreementRecognizer,
                ),
                const TextSpan(text: '、'),
                TextSpan(
                  text: '隐私政策',
                  style: linkStyle,
                  recognizer: _privacyPolicyRecognizer,
                ),
                const TextSpan(text: '和'),
                TextSpan(
                  text: '未成年人保护规则',
                  style: linkStyle,
                  recognizer: _minorProtectionRecognizer,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
