import '../domain/entities/auth_session.dart';
import '../network/api_client.dart';
import '../network/api_exception.dart';
import 'auth_failure.dart';
import 'auth_service.dart';

/// 真实接口实现：请求/响应结构对齐后端 REST API，网络细节委托给 [ApiClient]。
class RestAuthService implements AuthService {
  const RestAuthService(this._client);

  final ApiClient _client;

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
    try {
      return await _client.postJson(path, body: body);
    } on ApiException catch (e) {
      throw _mapToAuthFailure(e);
    }
  }

  AuthFailure _mapToAuthFailure(ApiException e) {
    final type = switch (e.type) {
      ApiErrorType.timeout => AuthFailureType.timeout,
      ApiErrorType.unauthorized => AuthFailureType.unauthorized,
      ApiErrorType.notConfigured || ApiErrorType.network => AuthFailureType.network,
      _ => AuthFailureType.unknown,
    };
    return AuthFailure(type, e.message);
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

  factory LoginResponse.fromJson(Map<String, Object?> json) {
    return LoginResponse(
      session: AuthSession.fromJson(json['data'] as Map<String, Object?>),
    );
  }
  const LoginResponse({required this.session});

  final AuthSession session;
}

class OneClickLoginRequest {
  const OneClickLoginRequest({required this.phone});

  final String phone;

  Map<String, Object?> toJson() => {'phone': phone};
}
