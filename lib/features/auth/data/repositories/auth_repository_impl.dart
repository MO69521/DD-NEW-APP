import '../../../../core/domain/entities/auth_session.dart';
import '../../../../core/services/auth_failure.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/auth_session_service.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required this.authService,
    required this.sessionService,
  });

  final AuthService authService;
  final AuthSessionService sessionService;

  @override
  AuthSession? get currentSession => sessionService.currentSession;

  @override
  bool get isAuthenticated => sessionService.isAuthenticated;

  @override
  Future<void> sendCode(String phone) async {
    _validatePhone(phone);
    await authService.sendCode(phone);
  }

  @override
  Future<AuthSession> login({
    required String phone,
    required String code,
  }) async {
    _validatePhone(phone);
    _validateCode(code);

    final session = await authService.login(phone, code);
    await sessionService.save(session);
    return session;
  }

  @override
  Future<void> logout() async {
    try {
      await authService.logout();
    } finally {
      await sessionService.clear();
    }
  }

  void _validatePhone(String phone) {
    if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(phone)) {
      throw const AuthFailure(AuthFailureType.invalidPhone);
    }
  }

  void _validateCode(String code) {
    if (!RegExp(r'^\d{6}$').hasMatch(code)) {
      throw const AuthFailure(AuthFailureType.invalidCode);
    }
  }
}
