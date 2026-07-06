import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_router.dart';
import '../../../../routes/app_routes.dart';
import '../../../../shared/components/app_toast.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text.dart';

/// L3 — 登录前协议确认弹窗。
class AuthAgreementConfirmDialog extends StatefulWidget {
  const AuthAgreementConfirmDialog({super.key});

  @override
  State<AuthAgreementConfirmDialog> createState() =>
      _AuthAgreementConfirmDialogState();
}

class _AuthAgreementConfirmDialogState
    extends State<AuthAgreementConfirmDialog> {
  late final TapGestureRecognizer _mobileTermsRecognizer =
      TapGestureRecognizer()..onTap = _showMobileTermsTodo;
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
      TapGestureRecognizer()..onTap = _showMinorProtectionTodo;

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
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.dialogBackground,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: AppColors.borderGlass),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.xl,
                AppSpacing.xl,
                AppSpacing.lg,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    '服务协议及隐私保护',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.textOnDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _AgreementDescription(
                    mobileTermsRecognizer: _mobileTermsRecognizer,
                    userAgreementRecognizer: _userAgreementRecognizer,
                    privacyPolicyRecognizer: _privacyPolicyRecognizer,
                    minorProtectionRecognizer: _minorProtectionRecognizer,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(
                    label: '同意并登录',
                    variant: AppButtonVariant.accent,
                    isExpanded: true,
                    onPressed: () => AppRouter.pop(true),
                  ),
                ],
              ),
            ),
            Positioned(
              top: AppSpacing.md,
              right: AppSpacing.md,
              child: _DialogCloseButton(onTap: () => AppRouter.pop(false)),
            ),
          ],
        ),
      ),
    );
  }

  void _showMobileTermsTodo() {
    AppToast.show(context, '中国移动认证服务条款即将上线');
  }

  void _showMinorProtectionTodo() {
    AppToast.show(context, '未成年人保护规则即将上线');
  }
}

class _DialogCloseButton extends StatelessWidget {
  const _DialogCloseButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: const Icon(
        Icons.close_rounded,
        size: AppSizes.topBarActionIconSize,
        color: AppColors.textOnDarkMuted,
      ),
    );
  }
}

class _AgreementDescription extends StatelessWidget {
  const _AgreementDescription({
    required this.mobileTermsRecognizer,
    required this.userAgreementRecognizer,
    required this.privacyPolicyRecognizer,
    required this.minorProtectionRecognizer,
  });

  final TapGestureRecognizer mobileTermsRecognizer;
  final TapGestureRecognizer userAgreementRecognizer;
  final TapGestureRecognizer privacyPolicyRecognizer;
  final TapGestureRecognizer minorProtectionRecognizer;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: AppTextStyles.authAgreementDarkMuted,
        children: [
          const TextSpan(text: '为了更好地保障您的合法权益，请您阅读并同意'),
          TextSpan(
            text: '中国移动认证服务条款',
            style: AppTextStyles.authAgreementLinkDark,
            recognizer: mobileTermsRecognizer,
          ),
          const TextSpan(text: '、'),
          TextSpan(
            text: '用户协议',
            style: AppTextStyles.authAgreementLinkDark,
            recognizer: userAgreementRecognizer,
          ),
          const TextSpan(text: '、'),
          TextSpan(
            text: '隐私政策',
            style: AppTextStyles.authAgreementLinkDark,
            recognizer: privacyPolicyRecognizer,
          ),
          const TextSpan(text: '和'),
          TextSpan(
            text: '未成年人保护规则',
            style: AppTextStyles.authAgreementLinkDark,
            recognizer: minorProtectionRecognizer,
          ),
        ],
      ),
    );
  }
}
