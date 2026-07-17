import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/main_tab_config.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/components/app_top_bar.dart';
import '../../../../shared/layouts/app_page_chrome.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_digit_code_input.dart';
import '../../../../shared/widgets/app_text.dart';

/// 开启青少年模式前设置 4 位独立密码。
class TeenModePasswordPage extends StatefulWidget {
  const TeenModePasswordPage({super.key});

  @override
  State<TeenModePasswordPage> createState() => _TeenModePasswordPageState();
}

class _TeenModePasswordPageState extends State<TeenModePasswordPage> {
  String _password = '';

  bool get _canSubmit =>
      _password.length == AppConstants.teenModePasswordLength;

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = AppLayout.statusBarHeight(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: AppPageChrome(
          topBar: AppTopBar(
            statusBarHeight: statusBarHeight,
            onBack: AppRouter.pop,
          ),
          body: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppLayout.chromeTopHeight(context) + AppSpacing.xl,
              AppSpacing.xl,
              AppSpacing.xxl,
            ),
            children: [
              AppText(
                '设置密码',
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.authTitleContentGap),
              AppText(
                '启动青少年模式，需先设置4位独立密码',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              AppDigitCodeInput(
                value: _password,
                length: AppConstants.teenModePasswordLength,
                obscureText: true,
                onChanged: _onPasswordChanged,
              ),
              const SizedBox(height: AppSpacing.xxl),
              AppButton(
                label: '确定',
                variant: AppButtonVariant.accent,
                isExpanded: true,
                onPressed: _canSubmit ? _submit : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onPasswordChanged(String value) {
    setState(() => _password = value);
  }

  void _submit() {
    FocusManager.instance.primaryFocus?.unfocus();
    ServiceLocator.teenMode.enable();
    AppRouter.goMainTab(MainTabConfig.profileIndex, toastMessage: '青少年模式已开启');
  }
}
