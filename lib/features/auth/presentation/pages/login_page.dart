import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/social_app_launch_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_router.dart';
import '../../../../routes/app_routes.dart';
import '../../../../shared/components/app_blurred_dialog.dart';
import '../../../../shared/components/app_toast.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../application/login_cubit.dart';
import '../../application/login_state.dart';
import '../components/auth_agreement_confirm_dialog.dart';
import '../components/auth_back_button.dart';
import '../components/login_layout.dart';
import '../components/one_click_login_form.dart';
import '../components/phone_login_form.dart';
import '../components/social_app_not_installed_dialog.dart';
import '../components/social_login_section.dart';
import '../components/verification_code_view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      buildWhen: (previous, current) {
        final previousUi = previous.ui;
        final currentUi = current.ui;
        return previousUi.hasRequestedCode != currentUi.hasRequestedCode ||
            previousUi.detectedPhone != currentUi.detectedPhone ||
            previousUi.isDetectingLocalPhone !=
                currentUi.isDetectingLocalPhone ||
            previousUi.showOneClickLogin != currentUi.showOneClickLogin ||
            previousUi.canSendCode != currentUi.canSendCode ||
            previousUi.canOneClickLogin != currentUi.canOneClickLogin ||
            previousUi.isAgreementAccepted != currentUi.isAgreementAccepted ||
            previousUi.isSendingCode != currentUi.isSendingCode ||
            previousUi.isLoggingIn != currentUi.isLoggingIn ||
            previousUi.isOneClickLoggingIn != currentUi.isOneClickLoggingIn ||
            previousUi.countdownSeconds != currentUi.countdownSeconds;
      },
      listenWhen: (previous, current) =>
          previous.ui.actionMessage != current.ui.actionMessage ||
          previous.ui.loginSucceeded != current.ui.loginSucceeded ||
          previous.ui.pendingSocialAppInstall !=
              current.ui.pendingSocialAppInstall,
      listener: (context, state) {
        final cubit = context.read<LoginCubit>();
        if (state.ui.loginSucceeded) {
          cubit.consumeLoginSucceeded();
          AppRouter.go(AppRoutes.home);
          return;
        }

        final pendingInstall = state.ui.pendingSocialAppInstall;
        if (pendingInstall != null) {
          cubit.consumePendingSocialAppInstall();
          unawaited(
            _handleSocialAppNotInstalled(context, cubit, pendingInstall),
          );
          return;
        }

        final message = state.ui.actionMessage;
        if (message == null) return;
        AppToast.show(context, message);
        cubit.consumeActionMessage();
      },
      builder: (context, state) {
        return _LoginView(state: state);
      },
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView({required this.state});

  final LoginState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();
    final statusBarHeight = AppLayout.statusBarHeight(context);
    final showManualBackButton =
        state.ui.detectedPhone != null && state.ui.useManualPhoneLogin;
    final titleTop = AppLayout.figmaFrameTop(
      context,
      LoginLayout.titleFrameTop,
    );

    if (state.ui.hasRequestedCode) {
      return VerificationCodeView(
        state: state,
        statusBarHeight: statusBarHeight,
        onBack: cubit.returnToPhoneStep,
        onCodeChanged: cubit.onCodeChanged,
        onResendCode: cubit.sendCode,
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppAssetImage(
              assetPath: LoginLayout.topBackgroundAsset,
              fit: BoxFit.fitWidth,
            ),
          ),
          if (showManualBackButton)
            Positioned(
              top: statusBarHeight + AppSpacing.lg,
              left: LoginLayout.contentHorizontalInset - AppSpacing.xs,
              child: AuthBackButton(
                onTap: () => _handleManualLoginBack(context, cubit),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: LoginLayout.contentHorizontalInset,
            ),
            child: Column(
              children: [
                SizedBox(height: titleTop),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      if (!state.ui.showOneClickLogin) ...[
                        AppText(
                          '欢迎登录',
                          style: AppTextStyles.displayLarge.copyWith(
                            color: AppColors.textOnDark,
                            height: AppLineHeights.none,
                          ),
                        ),
                        const SizedBox(height: LoginLayout.titleToInputGap),
                      ],
                      if (state.ui.showOneClickLogin)
                        OneClickLoginForm(
                          state: state,
                          onOneClickLogin: () =>
                              _handleOneClickLogin(context, cubit, state),
                          onUseOtherPhone: cubit.switchToManualLogin,
                          onAgreementTap: cubit.toggleAgreementAccepted,
                        )
                      else
                        PhoneLoginForm(
                          state: state,
                          onPhoneChanged: cubit.onPhoneChanged,
                          onSendCode: () =>
                              _handleSendCode(context, cubit, state),
                          onSendCodeUnavailable: cubit.promptPhoneRequired,
                          onAgreementTap: cubit.toggleAgreementAccepted,
                        ),
                      if (state.ui.isDetectingLocalPhone &&
                          state.ui.detectedPhone == null) ...[
                        const SizedBox(height: AppSpacing.lg),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox.square(
                              dimension: AppSpacing.md,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            AppText(
                              '正在检测本机号码...',
                              style: AppTextStyles.bodyMediumDarkMuted,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                // 一键登录 / 手动登录两种入口都保留底部第三方登录区域。
                SocialLoginSection(
                  onTap: (provider) {
                    unawaited(
                      _handleSocialLogin(context, cubit, state, provider),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSendCode(
    BuildContext context,
    LoginCubit cubit,
    LoginState state,
  ) async {
    if (!state.ui.isAgreementAccepted) {
      final confirmed = await showAppBlurredDialog<bool>(
        context: context,
        builder: (_) => const AuthAgreementConfirmDialog(),
      );
      if (!context.mounted || confirmed != true) return;
      cubit.toggleAgreementAccepted();
    }

    await cubit.sendCode();
  }

  Future<void> _handleOneClickLogin(
    BuildContext context,
    LoginCubit cubit,
    LoginState state,
  ) async {
    if (!state.ui.isAgreementAccepted) {
      final confirmed = await showAppBlurredDialog<bool>(
        context: context,
        builder: (_) => const AuthAgreementConfirmDialog(),
      );
      if (!context.mounted || confirmed != true) return;
      cubit.toggleAgreementAccepted();
    }

    await cubit.oneClickLogin();
  }

  Future<void> _handleSocialLogin(
    BuildContext context,
    LoginCubit cubit,
    LoginState state,
    AuthSocialProvider provider,
  ) async {
    if (!state.ui.isAgreementAccepted) {
      final confirmed = await showAppBlurredDialog<bool>(
        context: context,
        builder: (_) => const AuthAgreementConfirmDialog(),
      );
      if (!context.mounted || confirmed != true) return;
      cubit.toggleAgreementAccepted();
    }

    await cubit.onSocialLoginTap(provider);
  }

  void _handleManualLoginBack(BuildContext context, LoginCubit cubit) {
    cubit.switchToOneClickLogin();
  }
}

Future<void> _handleSocialAppNotInstalled(
  BuildContext context,
  LoginCubit cubit,
  SocialAppTarget target,
) async {
  final goDownload = await showAppBlurredDialog<bool>(
    context: context,
    builder: (_) => SocialAppNotInstalledDialog(target: target),
  );
  if (!context.mounted || goDownload != true) return;
  await cubit.openSocialAppDownload(target);
}
