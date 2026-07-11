import '../domain/entities/auth_session.dart';
import 'auth_failure.dart';
import 'auth_service.dart';

/// 真实接口占位实现。请求/响应结构保持接近后端 REST API，便于后续替换网络层。
class RestAuthService implements AuthService {
  const RestAuthService();

  @override
  Future<String?> detectLocalPhone() async {
    // Phase 2: 接入运营商 SDK 或服务端预取能力后替换为真实实现。
    return null;
  }

  @override
  Future<void> sendCode(String phone) async {
    final request = SendCodeRequest(phone: phone);
    await _post('/auth/sms/send', request.toJson());
  }

  @override
  Future<AuthSession> login(String phone, String code) async {
    final request = LoginRequest(phone: phone, code: code);
    final response = await _post('/auth/sms/login', request.toJson());
    return LoginResponse.fromJson(response).session;
  }

  @override
  Future<AuthSession> oneClickLogin(String phone) async {
    final request = OneClickLoginRequest(phone: phone);
    final response = await _post('/auth/carrier/login', request.toJson());
    return LoginResponse.fromJson(response).session;
  }

  @override
  Future<void> logout() async {
    await _post('/auth/logout', const <String, Object?>{});
  }

  Future<Map<String, Object?>> _post(
    String path,
    Map<String, Object?> body,
  ) async {
    // Phase 2 接入 Dio/http 后在这里统一处理 headers、状态码与响应解析。
    throw const AuthFailure(AuthFailureType.network, '真实接口暂未配置，请切换到 Mock 环境');
  }
}

class SendCodeRequest {
  const SendCodeRequest({required this.phone});

  final String phone;

  Map<String, Object?> toJson() => {'phone': phone};
}

class LoginRequest {
  const LoginRequest({required this.phone, required this.code});

  final String phone;
  final String code;

  Map<String, Object?> toJson() => {'phone': phone, 'code': code};
}

class LoginResponse {
  const LoginResponse({required this.session});

  final AuthSession session;

  factory LoginResponse.fromJson(Map<String, Object?> json) {
    return LoginResponse(
      session: AuthSession.fromJson(json['data'] as Map<String, Object?>),
    );
  }
}

class OneClickLoginRequest {
  const OneClickLoginRequest({required this.phone});

  final String phone;

  Map<String, Object?> toJson() => {'phone': phone};
}
