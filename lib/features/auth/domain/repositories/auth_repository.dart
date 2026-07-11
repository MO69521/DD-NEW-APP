import '../../../../core/domain/entities/auth_session.dart';

abstract interface class AuthRepository {
  AuthSession? get currentSession;

  bool get isAuthenticated;

  Future<void> sendCode(String phone);

  Future<AuthSession> login({required String phone, required String code});

  Future<String?> detectLocalPhone();

  Future<AuthSession> oneClickLogin({required String phone});

  Future<void> logout();
}
