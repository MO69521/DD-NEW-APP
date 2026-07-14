import 'dart:convert';

import 'package:diandian_chuanshu/core/domain/entities/book.dart';
import 'package:diandian_chuanshu/core/domain/entities/book_cover_tag.dart';
import 'package:diandian_chuanshu/core/network/api_client.dart';
import 'package:diandian_chuanshu/features/bookstore/data/datasources/bookstore_remote_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// 书城真实接口数据源端到端解析测试：ApiClient → DTO → 领域模型。
/// 可作为其它 feature remote datasource 的测试范式。
void main() {
  const baseUrl = 'https://api.test';

  BookstoreRemoteDataSource buildDataSource(String responseBody) {
    final client = HttpApiClient(
      baseUrl: baseUrl,
      client: MockClient((request) async {
        expect(request.url.path, '/bookstore/home');
        return http.Response.bytes(utf8.encode(responseBody), 200);
      }),
    );
    return BookstoreRemoteDataSource(client);
  }

  test('解析 data 信封并映射为 BookstorePageContent', () async {
    final body = jsonEncode({
      'data': {
        'searchPlaceholder': '穿书后：将门六姝',
        'rankingBooksByTab': {
          'recommend': [
            {
              'id': 'r1',
              'title': '病态沉溺',
              'category': '病娇总裁',
              'cover': 'https://cdn.test/r1.png',
              'coverTag': '完结',
            },
          ],
          'popular': [
            {
              'id': 'p1',
              'title': '全网都在磕',
              'category': '娱乐圈',
              'cover': 'https://cdn.test/p1.png',
            },
          ],
          // 未知 key 应被忽略，不抛异常。
          'unknownTab': [],
        },
        'editorPicks': [
          {
            'id': 'e1',
            'title': '编辑推荐',
            'category': '病娇总裁',
            'cover': 'https://cdn.test/e1.png',
            'coverTag': '更新',
          },
        ],
        'guessLikeBooks': [
          {
            'id': 'g1',
            'title': '猜你喜欢',
            'category': '病娇总裁',
            'cover': 'https://cdn.test/g1.png',
            'summary': '简介文案',
            'annotations': ['纯爱', '升级流'],
          },
        ],
        'continueReadingBook': {
          'id': 'cr1',
          'title': '继续阅读',
          'category': '都市甜宠',
          'cover': 'https://cdn.test/cr1.png',
        },
      },
    });

    final content = await buildDataSource(body).fetchPageContent();

    expect(content.searchPlaceholder, '穿书后：将门六姝');

    final recommend = content.rankingBooksByTab[RankingTab.recommend]!;
    expect(recommend, hasLength(1));
    expect(recommend.first.title, '病态沉溺');
    expect(recommend.first.coverAsset, 'https://cdn.test/r1.png');
    expect(recommend.first.coverTag, BookCoverTag.completed);

    expect(content.rankingBooksByTab.containsKey(RankingTab.popular), isTrue);
    // 未知 key 不进入结果。
    expect(content.rankingBooksByTab.length, 2);

    expect(content.editorPicks.first.coverTag, BookCoverTag.updated);

    final guess = content.guessLikeBooks.first;
    expect(guess.summary, '简介文案');
    expect(guess.annotations, ['纯爱', '升级流']);

    expect(content.continueReadingBook, isA<Book>());
    expect(content.continueReadingBook!.title, '继续阅读');
  });

  test('缺少 data 字段时抛出可读异常', () {
    expect(
      () => buildDataSource(jsonEncode({'code': 500})).fetchPageContent(),
      throwsA(isA<Exception>()),
    );
  });
}
