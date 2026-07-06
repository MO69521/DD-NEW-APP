enum AuthEnvironment { mock, rest }

enum MockAuthScenario {
  success,
  phoneNotRegistered,
  codeIncorrect,
  networkError,
  timeout,
}

class AuthServiceConfig {
  const AuthServiceConfig({
    this.environment = AuthEnvironment.mock,
    this.mockScenario = MockAuthScenario.success,
  });

  final AuthEnvironment environment;
  final MockAuthScenario mockScenario;
}
