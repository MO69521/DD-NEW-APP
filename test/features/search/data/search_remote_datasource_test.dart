import 'dart:convert';

import 'package:diandian_chuanshu/core/network/api_client.dart';
import 'package:diandian_chuanshu/features/search/data/datasources/search_remote_datasource.dart';
import 'package:diandian_chuanshu/features/search/domain/entities/book_serialization_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// 搜索真实接口数据源端到端解析测试：覆盖列表 / 联想 / 推荐 / 热词 / 历史增删查
/// 等多类响应，示范多方法 feature 的 remote datasource 测试范式。
void main() {
  const baseUrl = 'https://api.test';

  /// 按路径 + 方法路由返回桩响应。
  SearchRemoteDataSource buildDataSource(
    Map<String, Object?> Function(http.Request request) handler,
  ) {
    final client = HttpApiClient(
      baseUrl: baseUrl,
      client: MockClient((request) async {
        final payload = jsonEncode(handler(request));
        return http.Response.bytes(utf8.encode(payload), 200);
      }),
    );
    return SearchRemoteDataSource(client);
  }

  test('search 映射结果项：分类由受众标签拼接、状态枚举解析', () async {
    final ds = buildDataSource((request) {
      expect(request.url.path, '/search');
      expect(request.url.queryParameters['q'], '仙侠');
      return {
        'data': [
          {
            'id': 's1',
            'title': '穿越修仙界',
            'cover': 'https://cdn.test/s1.png',
            'audienceTags': ['男性向', '仙侠'],
            'description': '简介',
            'status': 'completed',
          },
        ],
      };
    });

    final result = await ds.search('仙侠');
    expect(result, hasLength(1));
    expect(result.first.book.title, '穿越修仙界');
    expect(result.first.book.category, '男性向 / 仙侠');
    expect(result.first.audienceTags, ['男性向', '仙侠']);
    expect(result.first.status, BookSerializationStatus.completed);
  });

  test('fetchSuggestions 映射联想词条与角标', () async {
    final ds = buildDataSource((request) {
      expect(request.url.path, '/search/suggestions');
      expect(request.url.queryParameters['q'], '男主');
      return {
        'data': [
          {'keyword': '男主她好绝', 'badge': '热搜'},
          {'keyword': '男主消失后'},
        ],
      };
    });

    final result = await ds.fetchSuggestions('男主');
    expect(result, hasLength(2));
    expect(result.first.badge, '热搜');
    expect(result[1].badge, isNull);
  });

  test('fetchRecommendations 映射推荐项：分类由标签「·」拼接', () async {
    final ds = buildDataSource((request) {
      expect(request.url.path, '/search/recommendations');
      return {
        'data': [
          {
            'id': 'rec1',
            'title': '被病娇囚禁后',
            'cover': 'https://cdn.test/rec1.png',
            'badgeLabel': '更新',
            'tags': ['生存', '病娇'],
            'description': '简介',
            'author': '野眠',
          },
        ],
      };
    });

    final result = await ds.fetchRecommendations();
    expect(result.first.book.category, '生存 · 病娇');
    expect(result.first.author, '野眠');
    expect(result.first.badgeLabel, '更新');
  });

  test('fetchHotKeywords / fetchSearchHistory 解析字符串数组', () async {
    final hot = await buildDataSource(
      (_) => {
        'data': ['重生悬疑', '姜知'],
      },
    ).fetchHotKeywords();
    expect(hot, ['重生悬疑', '姜知']);

    final history = await buildDataSource(
      (_) => {
        'data': ['烧脑', '古风'],
      },
    ).fetchSearchHistory();
    expect(history, ['烧脑', '古风']);
  });

  test('addSearchHistory 提交关键词并返回更新后的历史', () async {
    final ds = buildDataSource((request) {
      expect(request.method, 'POST');
      expect(request.url.path, '/search/history');
      final body = jsonDecode(request.body) as Map<String, Object?>;
      expect(body['keyword'], '新词');
      return {
        'data': ['新词', '烧脑'],
      };
    });

    final result = await ds.addSearchHistory('新词');
    expect(result.first, '新词');
  });

  test('clearSearchHistory 返回空历史', () async {
    final ds = buildDataSource((request) {
      expect(request.url.path, '/search/history/clear');
      return {'data': <String>[]};
    });

    expect(await ds.clearSearchHistory(), isEmpty);
  });
}
