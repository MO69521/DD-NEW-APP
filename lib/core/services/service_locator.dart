import '../domain/entities/auth_session.dart';
import '../domain/entities/auth_user.dart';
import 'auth_service.dart';
import 'auth_service_config.dart';
import 'auth_session_service.dart';
import 'bookshelf_membership_service.dart';
import 'membership_status_service.dart';
import 'mock_auth_service.dart';
import 'rest_auth_service.dart';

/// 全局服务注册入口，跨 feature 共享服务通过此处暴露。
///
/// 后续可替换为 get_it / riverpod 等 DI 方案。
abstract final class ServiceLocator {
  static const bool _skipAuthForPreview = bool.fromEnvironment(
    'SKIP_AUTH',
    defaultValue: false,
  );

  static bool _initialized = false;

  static MembershipStatusService? _membershipStatus;
  static BookshelfMembershipService? _bookshelfMembership;
  static AuthSessionService? _authSession;
  static AuthService? _authService;
  static const AuthServiceConfig _authConfig = AuthServiceConfig();

  /// 会员状态共享服务（单例）。
  static MembershipStatusService get membershipStatus =>
      _membershipStatus ??= MockMembershipStatusService();

  /// 书架状态共享服务（单例）。
  static BookshelfMembershipService get bookshelfMembership =>
      _bookshelfMembership ??= BookshelfMembershipService();

  /// 登录会话共享服务（单例）。
  static AuthSessionService get authSession =>
      _authSession ??= InMemoryAuthSessionService();

  /// 认证接口服务，可通过配置在 mock / rest 间切换。
  static AuthService get authService =>
      _authService ??= switch (_authConfig.environment) {
        AuthEnvironment.mock => MockAuthService(
          scenario: _authConfig.mockScenario,
        ),
        AuthEnvironment.rest => const RestAuthService(),
      };

  static Future<void> init() async {
    if (_initialized) return;
    _membershipStatus ??= MockMembershipStatusService();
    _bookshelfMembership ??= BookshelfMembershipService();
    _authSession ??= InMemoryAuthSessionService(
      initialSession: _skipAuthForPreview ? _previewSession : null,
    );
    _authService ??= switch (_authConfig.environment) {
      AuthEnvironment.mock => MockAuthService(
        scenario: _authConfig.mockScenario,
      ),
      AuthEnvironment.rest => const RestAuthService(),
    };
    _initialized = true;
  }

  static AuthSession get _previewSession {
    return AuthSession(
      accessToken: 'preview_access_token',
      refreshToken: 'preview_refresh_token',
      expiresAt: DateTime.now().add(const Duration(days: 30)),
      user: const AuthUser(
        id: 'preview-user',
        phone: '13800000000',
        nickname: '预览用户',
        avatarUrl: 'https://i.pravatar.cc/150?img=32',
      ),
    );
  }
}
