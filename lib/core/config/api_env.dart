/// 数据源环境开关。
///
/// 通过 `--dart-define=API_ENV=rest` 切换到真实接口；缺省为 `mock`，
/// 保证无后端时预览 / 演示不受影响。各 feature 的默认注入点据此在
/// Mock 与 Remote 数据源之间选择。
///
/// 用法：
/// ```bash
/// flutter run --dart-define=API_ENV=rest --dart-define=API_BASE_URL=https://api.example.com
/// ```
enum ApiEnv { mock, rest }

abstract final class ApiEnvConfig {
  static const String _name = String.fromEnvironment(
    'API_ENV',
    defaultValue: 'mock',
  );

  /// 是否启用真实接口（`API_ENV=rest`）。编译期常量。
  static const bool isRest = _name == 'rest';

  static ApiEnv get current => isRest ? ApiEnv.rest : ApiEnv.mock;
}
