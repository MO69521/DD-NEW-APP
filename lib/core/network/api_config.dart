/// REST 接口全局配置。
///
/// `baseUrl` 通过编译期注入，避免把环境地址写死进源码：
/// `flutter run --dart-define=API_BASE_URL=https://api.example.com`
///
/// 未注入（空串）时 [isConfigured] 为 false，网络层会直接抛出可读错误，
/// 提示切回 Mock 环境或补齐配置——保证研发接入前不会静默失败。
abstract final class ApiConfig {
  /// 后端根地址（不带结尾斜杠），如 `https://api.example.com`。
  static const String baseUrl = String.fromEnvironment('API_BASE_URL');

  /// 单次请求超时时间。
  static const Duration timeout = Duration(seconds: 15);

  /// 是否已配置可用的 [baseUrl]。
  static bool get isConfigured => baseUrl.isNotEmpty;
}
