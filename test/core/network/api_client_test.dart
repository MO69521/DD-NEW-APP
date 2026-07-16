import 'dart:convert';

import 'package:diandian_chuanshu/core/network/api_client.dart';
import 'package:diandian_chuanshu/core/network/api_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// `HttpApiClient` 单测：用 `MockClient` 注入桩响应，验证信封解析、鉴权头注入
/// 与状态码 → [ApiException] 的映射。可作为各 feature remote datasource 的测试范式。
void main() {
  const baseUrl = 'https://api.test';

  HttpApiClient buildClient(
    MockClient mock, {
    String? Function()? tokenProvider,
  }) {
    return HttpApiClient(
      client: mock,
      baseUrl: baseUrl,
      accessTokenProvider: tokenProvider,
    );
  }

  group('HttpApiClient.postJson', () {
    test('2xx 返回解码后的顶层 JSON Map', () async {
      final client = buildClient(
        MockClient((request) async {
          expect(request.url.toString(), '$baseUrl/auth/sms/login');
          expect(request.headers['Content-Type'], contains('application/json'));
          return http.Response(
            jsonEncode({
              'data': {'ok': true},
            }),
            200,
          );
        }),
      );

      final result = await client.postJson('/auth/sms/login', body: {'a': 1});
      expect(result['data'], {'ok': true});
    });

    test('注入 accessToken 时带上 Bearer 鉴权头', () async {
      late String? authHeader;
      final client = buildClient(
        MockClient((request) async {
          authHeader = request.headers['Authorization'];
          return http.Response('{}', 200);
        }),
        tokenProvider: () => 'token-123',
      );

      await client.postJson('/ping');
      expect(authHeader, 'Bearer token-123');
    });

    test('401 → ApiException(unauthorized)', () async {
      final client = buildClient(
        MockClient((_) async => http.Response('{}', 401)),
      );

      expect(
        () => client.postJson('/ping'),
        throwsA(
          isA<ApiException>().having(
            (e) => e.type,
            'type',
            ApiErrorType.unauthorized,
          ),
        ),
      );
    });

    test('5xx → ApiException(server) 且带状态码', () async {
      final client = buildClient(
        MockClient((_) async => http.Response('boom', 503)),
      );

      expect(
        () => client.postJson('/ping'),
        throwsA(
          isA<ApiException>()
              .having((e) => e.type, 'type', ApiErrorType.server)
              .having((e) => e.statusCode, 'statusCode', 503),
        ),
      );
    });

    test('响应非 JSON 对象 → ApiException(parse)', () async {
      final client = buildClient(
        MockClient((_) async => http.Response('not-json', 200)),
      );

      expect(
        () => client.postJson('/ping'),
        throwsA(
          isA<ApiException>().having((e) => e.type, 'type', ApiErrorType.parse),
        ),
      );
    });
  });

  test('未配置 baseUrl → ApiException(notConfigured)', () async {
    final client = HttpApiClient(
      client: MockClient((_) async => http.Response('{}', 200)),
      baseUrl: '',
    );

    expect(
      () => client.postJson('/ping'),
      throwsA(
        isA<ApiException>().having(
          (e) => e.type,
          'type',
          ApiErrorType.notConfigured,
        ),
      ),
    );
  });
}
