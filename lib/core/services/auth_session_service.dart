import '../domain/entities/auth_session.dart';

/// 当前登录会话的单一数据源。Phase 1 使用内存存储，后续可替换为安全存储。
abstract interface class AuthSessionService {
  AuthSession? get currentSession;

  bool get isAuthenticated;

  Future<void> save(AuthSession session);

  Future<void> clear();
}

class InMemoryAuthSessionService implements AuthSessionService {
  InMemoryAuthSessionService({AuthSession? initialSession})
    : _session = initialSession;

  AuthSession? _session;

  @override
  AuthSession? get currentSession => _session;

  @override
  bool get isAuthenticated {
    final session = _session;
    return session != null && !session.isExpired;
  }

  @override
  Future<void> save(AuthSession session) async {
    _session = session;
  }

  @override
  Future<void> clear() async {
    _session = null;
  }
}
