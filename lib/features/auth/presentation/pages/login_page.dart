import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_router.dart';
import '../../../../routes/app_routes.dart';
import '../../../../shared/components/app_blurred_dialog.dart';
import '../../../../shared/components/app_toast.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../application/login_cubit.dart';
import '../../application/login_state.dart';
import '../components/auth_agreement_confirm_dialog.dart';
import '../components/login_text_field.dart';

abstract final class _LoginLayout {
  static const String topBackgroundAsset =
      'assets/images/auth/login_top_bg.png';
  static const double contentHorizontalInset = AppSpacing.xl + AppSpacing.xs;
  static const double titleFrameTop =
      AppSizes.statusBarPlaceholderHeight +
      AppSpacing.xxl +
      AppSpacing.lg +
      AppSpacing.xxs;
  static const double titleToInputGap =
      AppSpacing.xxl + AppSpacing.lg + AppSpacing.xxsHalf;
  static const double inputToButtonGap = AppSpacing.xxl + AppSpacing.xl;
  static const double buttonToAgreementGap = AppSpacing.xl;
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      buildWhen: (previous, current) {
        final previousUi = previous.ui;
        final currentUi = current.ui;
        return previousUi.hasRequestedCode != currentUi.hasRequestedCode ||
            previousUi.canSendCode != currentUi.canSendCode ||
            previousUi.isAgreementAccepted != currentUi.isAgreementAccepted ||
            previousUi.isSendingCode != currentUi.isSendingCode ||
            previousUi.isLoggingIn != currentUi.isLoggingIn ||
            previousUi.countdownSeconds != currentUi.countdownSeconds;
      },
      listenWhen: (previous, current) =>
          previous.ui.actionMessage != current.ui.actionMessage ||
          previous.ui.loginSucceeded != current.ui.loginSucceeded,
      listener: (context, state) {
        final cubit = context.read<LoginCubit>();
        if (state.ui.loginSucceeded) {
          cubit.consumeLoginSucceeded();
          AppRouter.go(AppRoutes.home);
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
    final titleTop = AppLayout.figmaFrameTop(
      context,
      _LoginLayout.titleFrameTop,
    );

    if (state.ui.hasRequestedCode) {
      return _VerificationCodeView(
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
              assetPath: _LoginLayout.topBackgroundAsset,
              fit: BoxFit.fitWidth,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: _LoginLayout.contentHorizontalInset,
            ),
            child: Column(
              children: [
                SizedBox(height: titleTop),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      AppText(
                        '欢迎登录',
                        style: AppTextStyles.displayLarge.copyWith(
                          color: AppColors.textOnDark,
                          height: AppLineHeights.none,
                        ),
                      ),
                      const SizedBox(height: _LoginLayout.titleToInputGap),
                      _PhoneLoginForm(
                        state: state,
                        onPhoneChanged: cubit.onPhoneChanged,
                        onSendCode: () =>
                            _handleSendCode(context, cubit, state),
                        onSendCodeUnavailable: cubit.promptPhoneRequired,
                        onAgreementTap: cubit.toggleAgreementAccepted,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                _SocialLoginSection(onTap: cubit.onSocialLoginTap),
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
}

class _PhoneLoginForm extends StatelessWidget {
  const _PhoneLoginForm({
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
        const SizedBox(height: _LoginLayout.inputToButtonGap),
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
        const SizedBox(height: _LoginLayout.buttonToAgreementGap),
        TextFieldTapRegion(
          child: _AuthAgreementNotice(
            isSelected: ui.isAgreementAccepted,
            onToggle: onAgreementTap,
          ),
        ),
      ],
    );
  }
}

class _AuthAgreementNotice extends StatefulWidget {
  const _AuthAgreementNotice({
    required this.isSelected,
    required this.onToggle,
  });

  final bool isSelected;
  final VoidCallback onToggle;

  @override
  State<_AuthAgreementNotice> createState() => _AuthAgreementNoticeState();
}

class _AuthAgreementNoticeState extends State<_AuthAgreementNotice> {
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
          child: Container(
            width: AppSizes.iconSm,
            height: AppSizes.iconSm,
            margin: const EdgeInsets.only(top: AppSpacing.xxsHalf),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? AppColors.accentYellow
                  : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: widget.isSelected
                    ? AppColors.accentYellow
                    : AppColors.textOnDarkMuted,
                width: AppSizes.hairline,
              ),
            ),
            child: widget.isSelected
                ? const Icon(
                    Icons.check_rounded,
                    size: AppSpacing.sm,
                    color: AppColors.rankingSegmentedSelectedText,
                  )
                : null,
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

class _VerificationCodeView extends StatelessWidget {
  const _VerificationCodeView({
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
                child: _BackButton(onTap: onBack),
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
                _maskedPhone(ui.phone),
                style: AppTextStyles.titleMediumDark,
              ),
              const SizedBox(height: AppSpacing.xl),
              _VerificationCodeInput(value: ui.code, onChanged: onCodeChanged),
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

  String _maskedPhone(String phone) {
    if (phone.length != AppConstants.phoneNumberLength) return phone;
    return '${phone.substring(0, 3)}****${phone.substring(7)}';
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      child: const Padding(
        padding: EdgeInsets.all(AppSpacing.xs),
        child: AppIcon(
          assetPath: 'assets/icons/ranking/back.svg',
          width: AppSizes.topBarBackIconWidth,
          height: AppSizes.topBarBackIconHeight,
          color: AppColors.textOnDark,
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
              : AppColors.accentYellow,
        ),
      ),
    );
  }
}

class _VerificationCodeInput extends StatefulWidget {
  const _VerificationCodeInput({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  State<_VerificationCodeInput> createState() => _VerificationCodeInputState();
}

class _VerificationCodeInputState extends State<_VerificationCodeInput> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.value,
  );
  late final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _requestKeyboard();
    });
  }

  @override
  void didUpdateWidget(covariant _VerificationCodeInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == _controller.text) return;
    _controller.text = widget.value;
    _controller.selection = TextSelection.collapsed(
      offset: _controller.text.length,
    );
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _requestKeyboard,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, textEditingValue, child) {
              final code = textEditingValue.text;
              return Row(
                children: [
                  for (
                    var index = 0;
                    index < AppConstants.smsCodeLength;
                    index++
                  ) ...[
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: _VerificationCodeBox(
                          value: index < code.length ? code[index] : '',
                          isActive: index == code.length,
                        ),
                      ),
                    ),
                    if (index < AppConstants.smsCodeLength - 1)
                      const SizedBox(width: AppSpacing.xs),
                  ],
                ],
              );
            },
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0,
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                maxLength: AppConstants.smsCodeLength,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: widget.onChanged,
                onTapOutside: (_) => _focusNode.unfocus(),
                decoration: const InputDecoration(counterText: ''),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleFocusChanged() {
    if (!_focusNode.hasFocus) return;
    _showKeyboard();
  }

  void _requestKeyboard() {
    if (!_focusNode.hasFocus) {
      _focusNode.requestFocus();
    }
    SystemChannels.textInput.invokeMethod<void>('TextInput.show');
    WidgetsBinding.instance.addPostFrameCallback((_) => _showKeyboard());
  }

  Future<void> _showKeyboard() async {
    await SystemChannels.textInput.invokeMethod<void>('TextInput.show');
    await Future<void>.delayed(AppDurations.keyboardShowRetryDelay);
    if (!mounted || !_focusNode.hasFocus) return;
    await SystemChannels.textInput.invokeMethod<void>('TextInput.show');
  }
}

class _VerificationCodeBox extends StatelessWidget {
  const _VerificationCodeBox({required this.value, required this.isActive});

  final String value;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isActive ? Colors.transparent : AppColors.white04,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: isActive
            ? Border.all(
                color: AppColors.accentYellow,
                width: AppSizes.borderWidthEmphasis,
              )
            : null,
      ),
      child: Center(
        child: value.isEmpty && isActive
            ? const _VerificationCursor()
            : AppText(value, style: AppTextStyles.titleMediumDark, maxLines: 1),
      ),
    );
  }
}

class _VerificationCursor extends StatefulWidget {
  const _VerificationCursor();

  @override
  State<_VerificationCursor> createState() => _VerificationCursorState();
}

class _VerificationCursorState extends State<_VerificationCursor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppDurations.normal,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: AppSizes.borderWidthEmphasis,
        height: AppSpacing.lg,
        decoration: BoxDecoration(
          color: AppColors.accentYellow,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
      ),
    );
  }
}

class _SocialLoginSection extends StatelessWidget {
  const _SocialLoginSection({required this.onTap});

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
                  color: AppColors.white04,
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
