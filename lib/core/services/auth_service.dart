import '../domain/entities/auth_session.dart';

/// 登录接口抽象，对齐未来后端 REST API 的认证能力。
abstract interface class AuthService {
  Future<String?> detectLocalPhone();

  Future<void> sendCode(String phone);

  Future<AuthSession> login(String phone, String code);

  Future<AuthSession> oneClickLogin(String phone);

  Future<void> logout();
}
