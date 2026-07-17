import '../domain/entities/auth_session.dart';
import '../domain/entities/auth_user.dart';
import '../network/api_client.dart';
import 'auth_service.dart';
import 'auth_service_config.dart';
import 'auth_session_service.dart';
import 'bookshelf_membership_service.dart';
import 'image_picker_service.dart';
import 'membership_status_service.dart';
import 'mock_auth_service.dart';
import 'onboarding_service.dart';
import 'rest_auth_service.dart';
import 'social_app_launch_service.dart';
import 'teen_mode_service.dart';

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
  static ApiClient? _apiClient;
  static OnboardingService? _onboarding;
  static ImagePickerService? _imagePicker;
  static SocialAppLaunchService? _socialAppLaunch;
  static TeenModeService? _teenMode;
  static const AuthServiceConfig _authConfig = AuthServiceConfig();

  /// 会员状态共享服务（单例）。
  static MembershipStatusService get membershipStatus =>
      _membershipStatus ??= MockMembershipStatusService();

  /// 书架状态共享服务（单例）。
  static BookshelfMembershipService get bookshelfMembership =>
      _bookshelfMembership ??= BookshelfMembershipService();

  /// 新手基础信息收集状态服务（单例）。
  static OnboardingService get onboarding =>
      _onboarding ??= OnboardingService();

  /// 系统相册图片选择服务（单例）。
  static ImagePickerService get imagePicker =>
      _imagePicker ??= ImagePickerService();

  /// 第三方登录宿主 App 拉起 / 下载引导服务（单例）。
  static SocialAppLaunchService get socialAppLaunch =>
      _socialAppLaunch ??= const SocialAppLaunchService();

  /// 青少年模式共享状态服务（单例）。
  static TeenModeService get teenMode => _teenMode ??= TeenModeService();

  /// 登录会话共享服务（单例）。
  static AuthSessionService get authSession =>
      _authSession ??= InMemoryAuthSessionService();

  /// 统一 REST 客户端（单例）。自动注入当前会话 token 作为 Bearer 鉴权头。
  /// 各 feature 后续接入真实接口的 remote datasource 依赖此客户端。
  static ApiClient get apiClient => _apiClient ??= HttpApiClient(
    accessTokenProvider: () => authSession.currentSession?.accessToken,
  );

  /// 认证接口服务，可通过配置在 mock / rest 间切换。
  static AuthService get authService =>
      _authService ??= switch (_authConfig.environment) {
        AuthEnvironment.mock => MockAuthService(
          scenario: _authConfig.mockScenario,
        ),
        AuthEnvironment.rest => RestAuthService(apiClient),
      };

  static Future<void> init() async {
    if (_initialized) return;
    _membershipStatus ??= MockMembershipStatusService();
    _bookshelfMembership ??= BookshelfMembershipService();
    _onboarding ??= OnboardingService();
    _teenMode ??= TeenModeService();
    _authSession ??= InMemoryAuthSessionService(
      initialSession: _skipAuthForPreview ? _previewSession : null,
    );
    _authService ??= switch (_authConfig.environment) {
      AuthEnvironment.mock => MockAuthService(
        scenario: _authConfig.mockScenario,
      ),
      AuthEnvironment.rest => RestAuthService(apiClient),
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
