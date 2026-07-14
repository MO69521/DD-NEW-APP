/// 网络层统一异常。各 feature 的 Repository 捕获后再映射为本领域的失败类型
/// （如 [AuthFailure]）供 UI 展示，data 层不直接抛 http 细节。
class ApiException implements Exception {
  const ApiException(this.type, this.message, {this.statusCode});

  final ApiErrorType type;
  final String message;
  final int? statusCode;

  @override
  String toString() => 'ApiException($type, $statusCode): $message';
}

enum ApiErrorType {
  /// 未配置 baseUrl 等使用前置条件缺失。
  notConfigured,

  /// 连接失败 / 无网络。
  network,

  /// 请求超时。
  timeout,

  /// 401：鉴权失效。
  unauthorized,

  /// 4xx（除 401）：客户端请求错误。
  badRequest,

  /// 5xx：服务端错误。
  server,

  /// 响应解析失败。
  parse,

  /// 其它未归类错误。
  unknown,
}
