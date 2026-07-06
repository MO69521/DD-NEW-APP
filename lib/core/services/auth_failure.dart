/// Auth service 统一失败类型，Repository 将其映射为页面可展示文案。
class AuthFailure implements Exception {
  const AuthFailure(this.type, [this.message]);

  final AuthFailureType type;
  final String? message;

  @override
  String toString() => message ?? type.defaultMessage;
}

enum AuthFailureType {
  invalidPhone,
  invalidCode,
  phoneNotRegistered,
  codeIncorrect,
  network,
  timeout,
  unauthorized,
  unknown,
}

extension AuthFailureTypeMessage on AuthFailureType {
  String get defaultMessage {
    return switch (this) {
      AuthFailureType.invalidPhone => '请输入正确的手机号',
      AuthFailureType.invalidCode => '请输入 6 位短信验证码',
      AuthFailureType.phoneNotRegistered => '该手机号尚未注册',
      AuthFailureType.codeIncorrect => '验证码错误，请重新输入',
      AuthFailureType.network => '网络异常，请稍后重试',
      AuthFailureType.timeout => '请求超时，请稍后重试',
      AuthFailureType.unauthorized => '登录已失效，请重新登录',
      AuthFailureType.unknown => '操作失败，请稍后重试',
    };
  }
}
