import '../../../../core/domain/entities/book.dart';
import '../../domain/entities/book_serialization_status.dart';
import '../../domain/entities/search_result_item.dart';

/// Mock 数据源：Phase 1 静态数据，Phase 2 替换为 API datasource。
class SearchMockDataSource {
  const SearchMockDataSource();

  /// 模拟网络延迟（毫秒）。
  static const int _mockLatencyMs = 320;

  Future<List<SearchResultItem>> search(String query) async {
    await Future<void>.delayed(const Duration(milliseconds: _mockLatencyMs));

    // Phase 1：忽略关键词匹配逻辑，返回固定模拟结果集。
    // Phase 2：由后端按 query 返回命中结果。
    return [
      for (var i = 0; i < _templates.length; i++)
        SearchResultItem(
          book: Book(
            id: 'search_${i + 1}',
            title: _templates[i].title,
            category: _templates[i].audienceTags.join(' / '),
            coverAsset: _templates[i].cover,
          ),
          audienceTags: _templates[i].audienceTags,
          description: _templates[i].description,
          status: _templates[i].status,
        ),
    ];
  }

  static const List<_SearchTemplate> _templates = [
    _SearchTemplate(
      title: '穿越修仙界，我从零开始碾压无敌',
      audienceTags: ['男性向', '古代', '仙侠', '轻松'],
      description: '【绝境逆袭+轻松+自由修炼+多女主】 穿越到了修仙界，成为了'
          '最普通的杂役弟子，在主角和气运之子横行的修仙界，觉醒系统的我该如何选择？',
      status: BookSerializationStatus.serializing,
      cover: 'assets/covers/cover_01.png',
    ),
    _SearchTemplate(
      title: '穿越兽世：四兽夫求我狠狠rua',
      audienceTags: ['女性向', '未来', '女尊', '甜宠'],
      description: '【np1V4+雄尊背景+甜撩不虐】思癌穿越，一睁眼，你成了星际时代'
          '一只珍贵的雌性。可惜……是个被流放的兔系废柴。',
      status: BookSerializationStatus.serializing,
      cover: 'assets/covers/cover_02.png',
    ),
    _SearchTemplate(
      title: '穿越返工记：病娇夫君太难哄',
      audienceTags: ['女性向', '架空', '快穿', '苏爽'],
      description: '周五、六、日更新【穿越+病娇+女强+疯批+钓系美人+全员黑化+修罗场'
          '+1V3】穿越到你曾经完成攻略的世界，当初的你威逼利诱顺利完成任务。',
      status: BookSerializationStatus.serializing,
      cover: 'assets/covers/cover_03.png',
    ),
    _SearchTemplate(
      title: '穿越之总有人对师尊以下犯上',
      audienceTags: ['纯爱', '仙侠'],
      description: '身为美貌师尊，慕容珏不是没栽过跟头。重来一次，疯批师弟照样'
          '仨禁锢倔强叫嚣，从不手软。',
      status: BookSerializationStatus.completed,
      cover: 'assets/covers/cover_04.png',
    ),
    _SearchTemplate(
      title: '误入兽世，六个兽夫跪求投喂！',
      audienceTags: ['女性向', '古代', '玄幻', '苏爽'],
      description: '一觉醒来，你成了兽世珍稀的雌性！开局就是地狱模式——前脚兽王要'
          '将你吃干抹净，后脚蛇男就缠上了你的身子！',
      status: BookSerializationStatus.serializing,
      cover: 'assets/covers/cover_05.png',
    ),
    _SearchTemplate(
      title: '浮生千劫渡',
      audienceTags: ['女性向', '古代', '玄幻', '苏爽'],
      description: '【疯批病娇+海王修罗场+共寝触摸+苏爽恋爱+自由抽卡+亲密撩拨】'
          '想复活？先攻略五个男人！',
      status: BookSerializationStatus.serializing,
      cover: 'assets/covers/cover_06.png',
    ),
  ];
}

class _SearchTemplate {
  const _SearchTemplate({
    required this.title,
    required this.audienceTags,
    required this.description,
    required this.status,
    required this.cover,
  });

  final String title;
  final List<String> audienceTags;
  final String description;
  final BookSerializationStatus status;
  final String cover;
}
