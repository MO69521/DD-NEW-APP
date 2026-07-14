import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'api_exception.dart';

/// 统一 REST 客户端抽象。feature 的 remote datasource 依赖此接口，
/// 便于替换实现或在测试中注入 fake。
///
/// 返回值为解码后的顶层 JSON Map；`data` 信封由各 service / datasource 自行读取，
/// 与既有 `LoginResponse.fromJson(json['data'])` 约定保持一致。
abstract interface class ApiClient {
  Future<Map<String, Object?>> postJson(
    String path, {
    Map<String, Object?>? body,
  });

  Future<Map<String, Object?>> getJson(
    String path, {
    Map<String, String>? query,
  });
}

/// 基于 `package:http` 的默认实现（跨平台，含 Web）。
///
/// 统一处理：baseUrl 拼接、JSON headers、可选 Bearer token 注入、超时、
/// 状态码与解析错误到 [ApiException] 的映射。
class HttpApiClient implements ApiClient {
  HttpApiClient({
    http.Client? client,
    this.accessTokenProvider,
    String? baseUrl,
    Duration? timeout,
  }) : _client = client ?? http.Client(),
       _baseUrl = baseUrl ?? ApiConfig.baseUrl,
       _timeout = timeout ?? ApiConfig.timeout;

  final http.Client _client;
  final String _baseUrl;
  final Duration _timeout;

  /// 返回当前访问令牌；非空时自动作为 `Authorization: Bearer` 头注入。
  final String? Function()? accessTokenProvider;

  @override
  Future<Map<String, Object?>> postJson(
    String path, {
    Map<String, Object?>? body,
  }) {
    return _send(
      () => _client.post(
        _uri(path),
        headers: _headers(),
        body: jsonEncode(body ?? const <String, Object?>{}),
      ),
    );
  }

  @override
  Future<Map<String, Object?>> getJson(
    String path, {
    Map<String, String>? query,
  }) {
    return _send(
      () => _client.get(_uri(path, query), headers: _headers()),
    );
  }

  Uri _uri(String path, [Map<String, String>? query]) {
    if (_baseUrl.isEmpty) {
      throw const ApiException(
        ApiErrorType.notConfigured,
        '未配置 API_BASE_URL，请通过 --dart-define 注入或切换到 Mock 环境',
      );
    }
    return Uri.parse('$_baseUrl$path').replace(queryParameters: query);
  }

  Map<String, String> _headers() {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json',
    };
    final token = accessTokenProvider?.call();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<Map<String, Object?>> _send(
    Future<http.Response> Function() request,
  ) async {
    final http.Response response;
    try {
      response = await request().timeout(_timeout);
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw const ApiException(ApiErrorType.timeout, '请求超时，请稍后重试');
    } on http.ClientException catch (e) {
      throw ApiException(ApiErrorType.network, '网络异常：${e.message}');
    } catch (e) {
      throw ApiException(ApiErrorType.unknown, '请求失败：$e');
    }

    final status = response.statusCode;
    if (status == 401) {
      throw const ApiException(ApiErrorType.unauthorized, '登录已失效，请重新登录');
    }
    if (status >= 500) {
      throw ApiException(
        ApiErrorType.server,
        '服务端异常（$status）',
        statusCode: status,
      );
    }
    if (status >= 400) {
      throw ApiException(
        ApiErrorType.badRequest,
        '请求失败（$status）',
        statusCode: status,
      );
    }

    return _decode(response.bodyBytes);
  }

  // JSON 按规范为 UTF-8，直接按 UTF-8 解码字节，避免依赖响应的 charset 头。
  Map<String, Object?> _decode(List<int> bytes) {
    if (bytes.isEmpty) return const <String, Object?>{};
    try {
      final decoded = jsonDecode(utf8.decode(bytes));
      if (decoded is Map<String, Object?>) return decoded;
      throw const ApiException(ApiErrorType.parse, '响应格式不是 JSON 对象');
    } on FormatException catch (e) {
      throw ApiException(ApiErrorType.parse, '响应解析失败：${e.message}');
    }
  }
}
