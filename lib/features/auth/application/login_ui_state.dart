import 'package:equatable/equatable.dart';

import '../../../core/constants/app_constants.dart';

class LoginUiState extends Equatable {
  const LoginUiState({
    this.phone = '',
    this.code = '',
    this.isSendingCode = false,
    this.isLoggingIn = false,
    this.countdownSeconds = 0,
    this.hasRequestedCode = false,
    this.isAgreementAccepted = false,
    this.actionMessage,
    this.loginSucceeded = false,
  });

  final String phone;
  final String code;
  final bool isSendingCode;
  final bool isLoggingIn;
  final int countdownSeconds;
  final bool hasRequestedCode;
  final bool isAgreementAccepted;
  final String? actionMessage;
  final bool loginSucceeded;

  bool get canSendCode =>
      !isSendingCode &&
      countdownSeconds == 0 &&
      RegExp(r'^1[3-9]\d{9}$').hasMatch(phone);

  bool get canLogin =>
      !isLoggingIn &&
      !isSendingCode &&
      RegExp(r'^1[3-9]\d{9}$').hasMatch(phone) &&
      code.length == AppConstants.smsCodeLength &&
      RegExp(r'^\d+$').hasMatch(code);

  LoginUiState copyWith({
    String? phone,
    String? code,
    bool? isSendingCode,
    bool? isLoggingIn,
    int? countdownSeconds,
    bool? hasRequestedCode,
    bool? isAgreementAccepted,
    String? actionMessage,
    bool? loginSucceeded,
    bool clearActionMessage = false,
    bool clearLoginSucceeded = false,
  }) {
    return LoginUiState(
      phone: phone ?? this.phone,
      code: code ?? this.code,
      isSendingCode: isSendingCode ?? this.isSendingCode,
      isLoggingIn: isLoggingIn ?? this.isLoggingIn,
      countdownSeconds: countdownSeconds ?? this.countdownSeconds,
      hasRequestedCode: hasRequestedCode ?? this.hasRequestedCode,
      isAgreementAccepted: isAgreementAccepted ?? this.isAgreementAccepted,
      actionMessage: clearActionMessage
          ? null
          : actionMessage ?? this.actionMessage,
      loginSucceeded: clearLoginSucceeded
          ? false
          : loginSucceeded ?? this.loginSucceeded,
    );
  }

  @override
  List<Object?> get props => [
    phone,
    code,
    isSendingCode,
    isLoggingIn,
    countdownSeconds,
    hasRequestedCode,
    isAgreementAccepted,
    actionMessage,
    loginSucceeded,
  ];
}
