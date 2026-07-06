import '../domain/entities/auth_session.dart';
import '../domain/entities/auth_user.dart';
import 'auth_failure.dart';
import 'auth_service.dart';
import 'auth_service_config.dart';

class MockAuthService implements AuthService {
  const MockAuthService({
    this.scenario = MockAuthScenario.success,
    this.delay = const Duration(seconds: 1),
  });

  final MockAuthScenario scenario;
  final Duration delay;

  @override
  Future<void> sendCode(String phone) async {
    await Future<void>.delayed(delay);
    _throwConfiguredFailure();
  }

  @override
  Future<AuthSession> login(String phone, String code) async {
    await Future<void>.delayed(delay);
    _throwConfiguredFailure();

    if (!RegExp(r'^\d{6}$').hasMatch(code)) {
      throw const AuthFailure(AuthFailureType.codeIncorrect);
    }

    final user = AuthUser(
      id: 'mock-user-10001',
      phone: phone,
      nickname: '点点读者',
      avatarUrl: 'https://i.pravatar.cc/150?img=32',
    );

    return AuthSession(
      accessToken: 'mock_access_token_10001',
      refreshToken: 'mock_refresh_token_10001',
      expiresAt: DateTime.now().add(const Duration(days: 30)),
      user: user,
    );
  }

  @override
  Future<void> logout() async {
    await Future<void>.delayed(delay);
    if (scenario == MockAuthScenario.networkError) {
      throw const AuthFailure(AuthFailureType.network);
    }
    if (scenario == MockAuthScenario.timeout) {
      throw const AuthFailure(AuthFailureType.timeout);
    }
  }

  void _throwConfiguredFailure() {
    switch (scenario) {
      case MockAuthScenario.success:
        return;
      case MockAuthScenario.phoneNotRegistered:
        throw const AuthFailure(AuthFailureType.phoneNotRegistered);
      case MockAuthScenario.codeIncorrect:
        throw const AuthFailure(AuthFailureType.codeIncorrect);
      case MockAuthScenario.networkError:
        throw const AuthFailure(AuthFailureType.network);
      case MockAuthScenario.timeout:
        throw const AuthFailure(AuthFailureType.timeout);
    }
  }
}
