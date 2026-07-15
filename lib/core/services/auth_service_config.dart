import '../config/api_env.dart';

enum AuthEnvironment { mock, rest }

enum MockAuthScenario {
  success,
  phoneNotRegistered,
  codeIncorrect,
  networkError,
  timeout,
}

class AuthServiceConfig {
  /// [environment] 缺省跟随全局 `API_ENV`（`rest` → 真实登录，否则 Mock），
  /// 与各 feature 数据源开关保持一致；无后端时默认 Mock，不影响预览。
  const AuthServiceConfig({
    AuthEnvironment? environment,
    this.mockScenario = MockAuthScenario.success,
  }) : environment =
           environment ??
           (ApiEnvConfig.isRest ? AuthEnvironment.rest : AuthEnvironment.mock);

  final AuthEnvironment environment;
  final MockAuthScenario mockScenario;
}
