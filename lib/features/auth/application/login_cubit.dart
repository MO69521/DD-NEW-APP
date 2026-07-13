import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/services/auth_failure.dart';
import '../../../core/services/service_locator.dart';
import '../../../core/services/social_app_launch_service.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    AuthRepository? repository,
    SocialAppLaunchService? socialAppLaunchService,
  }) : _repository =
           repository ??
           AuthRepositoryImpl(
             authService: ServiceLocator.authService,
             sessionService: ServiceLocator.authSession,
           ),
       _socialAppLaunch =
           socialAppLaunchService ?? ServiceLocator.socialAppLaunch,
       super(const LoginState());

  final AuthRepository _repository;
  final SocialAppLaunchService _socialAppLaunch;
  Timer? _countdownTimer;

  Future<void> detectLocalPhone() async {
    if (state.ui.isDetectingLocalPhone) return;
    emit(
      state.copyWith(
        ui: state.ui.copyWith(
          isDetectingLocalPhone: true,
          clearActionMessage: true,
        ),
      ),
    );
    try {
      final detectedPhone = await _repository.detectLocalPhone();
      if (isClosed) return;
      emit(
        state.copyWith(
          ui: state.ui.copyWith(
            detectedPhone: detectedPhone,
            isDetectingLocalPhone: false,
          ),
        ),
      );
    } catch (_) {
      if (isClosed) return;
      emit(
        state.copyWith(
          ui: state.ui.copyWith(
            detectedPhone: null,
            isDetectingLocalPhone: false,
          ),
        ),
      );
    }
  }

  void onPhoneChanged(String value) {
    final phone = value.trim();
    final phoneChanged = phone != state.ui.phone;
    if (phoneChanged) {
      _countdownTimer?.cancel();
    }

    emit(
      state.copyWith(
        ui: state.ui.copyWith(
          phone: phone,
          code: phoneChanged ? '' : null,
          countdownSeconds: phoneChanged ? 0 : null,
          hasRequestedCode: phoneChanged ? false : null,
          useManualPhoneLogin: true,
          clearActionMessage: true,
          clearLoginSucceeded: true,
        ),
      ),
    );
  }

  void switchToManualLogin() {
    _countdownTimer?.cancel();
    emit(
      state.copyWith(
        ui: state.ui.copyWith(
          useManualPhoneLogin: true,
          phone: '',
          code: '',
          countdownSeconds: 0,
          hasRequestedCode: false,
          clearActionMessage: true,
          clearLoginSucceeded: true,
        ),
      ),
    );
  }

  void switchToOneClickLogin() {
    if (state.ui.detectedPhone == null) return;
    _countdownTimer?.cancel();
    emit(
      state.copyWith(
        ui: state.ui.copyWith(
          useManualPhoneLogin: false,
          phone: '',
          code: '',
          countdownSeconds: 0,
          hasRequestedCode: false,
          clearActionMessage: true,
          clearLoginSucceeded: true,
        ),
      ),
    );
  }

  void onCodeChanged(String value) {
    final code = value.trim();
    final nextState = state.copyWith(
      ui: state.ui.copyWith(
        code: code,
        clearActionMessage: true,
        clearLoginSucceeded: true,
      ),
    );

    emit(nextState);

    if (nextState.ui.canLogin) {
      unawaited(login());
    }
  }

  void returnToPhoneStep() {
    _countdownTimer?.cancel();
    emit(
      state.copyWith(
        ui: state.ui.copyWith(
          code: '',
          countdownSeconds: 0,
          hasRequestedCode: false,
          clearActionMessage: true,
          clearLoginSucceeded: true,
        ),
      ),
    );
  }

  Future<void> sendCode() async {
    if (state.ui.isSendingCode || state.ui.countdownSeconds > 0) return;

    emit(
      state.copyWith(
        ui: state.ui.copyWith(
          isSendingCode: true,
          clearActionMessage: true,
          clearLoginSucceeded: true,
        ),
      ),
    );

    try {
      await _repository.sendCode(state.ui.phone);
      if (isClosed) return;
      emit(
        state.copyWith(
          ui: state.ui.copyWith(
            isSendingCode: false,
            countdownSeconds: AppConstants.smsCodeCountdownSeconds,
            hasRequestedCode: true,
            actionMessage: '验证码已发送',
          ),
        ),
      );
      _startCountdown();
    } catch (error) {
      if (isClosed) return;
      emit(
        state.copyWith(
          ui: state.ui.copyWith(
            isSendingCode: false,
            actionMessage: _messageFor(error),
          ),
        ),
      );
    }
  }

  void promptPhoneRequired() {
    emit(state.copyWith(ui: state.ui.copyWith(actionMessage: '请输入手机号')));
  }

  void toggleAgreementAccepted() {
    emit(
      state.copyWith(
        ui: state.ui.copyWith(
          isAgreementAccepted: !state.ui.isAgreementAccepted,
        ),
      ),
    );
  }

  Future<void> login() async {
    if (state.ui.isLoggingIn) return;

    emit(
      state.copyWith(
        ui: state.ui.copyWith(
          isLoggingIn: true,
          clearActionMessage: true,
          clearLoginSucceeded: true,
        ),
      ),
    );

    try {
      await _repository.login(phone: state.ui.phone, code: state.ui.code);
      if (isClosed) return;
      emit(
        state.copyWith(
          ui: state.ui.copyWith(isLoggingIn: false, loginSucceeded: true),
        ),
      );
    } catch (error) {
      if (isClosed) return;
      emit(
        state.copyWith(
          ui: state.ui.copyWith(
            isLoggingIn: false,
            actionMessage: _messageFor(error),
          ),
        ),
      );
    }
  }

  Future<void> oneClickLogin() async {
    final detectedPhone = state.ui.detectedPhone;
    if (detectedPhone == null || state.ui.isOneClickLoggingIn) return;

    emit(
      state.copyWith(
        ui: state.ui.copyWith(
          isOneClickLoggingIn: true,
          clearActionMessage: true,
          clearLoginSucceeded: true,
        ),
      ),
    );

    try {
      await _repository.oneClickLogin(phone: detectedPhone);
      if (isClosed) return;
      emit(
        state.copyWith(
          ui: state.ui.copyWith(
            isOneClickLoggingIn: false,
            loginSucceeded: true,
          ),
        ),
      );
    } catch (error) {
      if (isClosed) return;
      emit(
        state.copyWith(
          ui: state.ui.copyWith(
            isOneClickLoggingIn: false,
            actionMessage: _messageFor(error),
          ),
        ),
      );
    }
  }

  void consumeActionMessage() {
    if (state.ui.actionMessage == null) return;
    emit(state.copyWith(ui: state.ui.copyWith(clearActionMessage: true)));
  }

  void consumeLoginSucceeded() {
    if (!state.ui.loginSucceeded) return;
    emit(state.copyWith(ui: state.ui.copyWith(clearLoginSucceeded: true)));
  }

  void consumePendingSocialAppInstall() {
    if (state.ui.pendingSocialAppInstall == null) return;
    emit(
      state.copyWith(
        ui: state.ui.copyWith(clearPendingSocialAppInstall: true),
      ),
    );
  }

  Future<void> onSocialLoginTap(AuthSocialProvider provider) async {
    emit(
      state.copyWith(
        ui: state.ui.copyWith(
          clearActionMessage: true,
          clearPendingSocialAppInstall: true,
        ),
      ),
    );

    final target = provider.target;
    final outcome = await _socialAppLaunch.openForAuthorization(target);
    if (isClosed) return;

    switch (outcome) {
      case SocialAppLaunchOutcome.launched:
        return;
      case SocialAppLaunchOutcome.notInstalled:
        emit(
          state.copyWith(
            ui: state.ui.copyWith(pendingSocialAppInstall: target),
          ),
        );
      case SocialAppLaunchOutcome.failed:
        emit(
          state.copyWith(
            ui: state.ui.copyWith(
              actionMessage: '打开${target.displayName}失败，请稍后重试',
            ),
          ),
        );
    }
  }

  Future<void> openSocialAppDownload(SocialAppTarget target) async {
    final opened = await _socialAppLaunch.openDownloadStore(target);
    if (isClosed || opened) return;
    emit(
      state.copyWith(
        ui: state.ui.copyWith(
          actionMessage: '无法打开下载页，请前往应用商店搜索${target.displayName}',
        ),
      ),
    );
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final nextSeconds = state.ui.countdownSeconds - 1;
      if (nextSeconds <= 0) {
        _countdownTimer?.cancel();
      }
      if (isClosed) return;
      emit(
        state.copyWith(
          ui: state.ui.copyWith(
            countdownSeconds: nextSeconds <= 0 ? 0 : nextSeconds,
          ),
        ),
      );
    });
  }

  String _messageFor(Object error) {
    if (error is AuthFailure) return error.toString();
    return AuthFailureType.unknown.defaultMessage;
  }

  @override
  Future<void> close() {
    _countdownTimer?.cancel();
    return super.close();
  }
}

enum AuthSocialProvider {
  wechat('微信登录', SocialAppTarget.wechat),
  qq('QQ 登录', SocialAppTarget.qq),
  douyin('抖音登录', SocialAppTarget.douyin);

  const AuthSocialProvider(this.label, this.target);

  final String label;
  final SocialAppTarget target;
}
