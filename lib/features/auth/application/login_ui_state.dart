import 'package:equatable/equatable.dart';

import '../../../core/constants/app_constants.dart';

class LoginUiState extends Equatable {
  const LoginUiState({
    this.phone = '',
    this.code = '',
    this.detectedPhone,
    this.isDetectingLocalPhone = false,
    this.isSendingCode = false,
    this.isLoggingIn = false,
    this.isOneClickLoggingIn = false,
    this.countdownSeconds = 0,
    this.useManualPhoneLogin = false,
    this.hasRequestedCode = false,
    this.isAgreementAccepted = false,
    this.actionMessage,
    this.loginSucceeded = false,
  });

  final String phone;
  final String code;
  final String? detectedPhone;
  final bool isDetectingLocalPhone;
  final bool isSendingCode;
  final bool isLoggingIn;
  final bool isOneClickLoggingIn;
  final int countdownSeconds;
  final bool useManualPhoneLogin;
  final bool hasRequestedCode;
  final bool isAgreementAccepted;
  final String? actionMessage;
  final bool loginSucceeded;

  bool get showOneClickLogin => detectedPhone != null && !useManualPhoneLogin;

  bool get canSendCode =>
      !isSendingCode &&
      countdownSeconds == 0 &&
      RegExp(r'^1[3-9]\d{9}$').hasMatch(phone);

  bool get canOneClickLogin =>
      showOneClickLogin &&
      !isOneClickLoggingIn &&
      !isSendingCode &&
      !isLoggingIn;

  bool get canLogin =>
      !isLoggingIn &&
      !isSendingCode &&
      RegExp(r'^1[3-9]\d{9}$').hasMatch(phone) &&
      code.length == AppConstants.smsCodeLength &&
      RegExp(r'^\d+$').hasMatch(code);

  LoginUiState copyWith({
    String? phone,
    String? code,
    String? detectedPhone,
    bool? isSendingCode,
    bool? isDetectingLocalPhone,
    bool? isLoggingIn,
    bool? isOneClickLoggingIn,
    int? countdownSeconds,
    bool? useManualPhoneLogin,
    bool? hasRequestedCode,
    bool? isAgreementAccepted,
    String? actionMessage,
    bool? loginSucceeded,
    bool clearActionMessage = false,
    bool clearLoginSucceeded = false,
    bool clearDetectedPhone = false,
  }) {
    return LoginUiState(
      phone: phone ?? this.phone,
      code: code ?? this.code,
      detectedPhone: clearDetectedPhone
          ? null
          : detectedPhone ?? this.detectedPhone,
      isDetectingLocalPhone:
          isDetectingLocalPhone ?? this.isDetectingLocalPhone,
      isSendingCode: isSendingCode ?? this.isSendingCode,
      isLoggingIn: isLoggingIn ?? this.isLoggingIn,
      isOneClickLoggingIn: isOneClickLoggingIn ?? this.isOneClickLoggingIn,
      countdownSeconds: countdownSeconds ?? this.countdownSeconds,
      useManualPhoneLogin: useManualPhoneLogin ?? this.useManualPhoneLogin,
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
    detectedPhone,
    isDetectingLocalPhone,
    isSendingCode,
    isLoggingIn,
    isOneClickLoggingIn,
    countdownSeconds,
    useManualPhoneLogin,
    hasRequestedCode,
    isAgreementAccepted,
    actionMessage,
    loginSucceeded,
  ];
}
