import '../../../../core/domain/entities/book.dart';
import '../../domain/entities/book_serialization_status.dart';
import '../../domain/entities/search_recommendation_item.dart';
import '../../domain/entities/search_result_item.dart';

/// Mock 数据源：Phase 1 静态数据，Phase 2 替换为 API datasource。
class SearchMockDataSource {
  const SearchMockDataSource();

  /// 模拟网络延迟（毫秒）。
  static const int _mockLatencyMs = 320;
  static const int _recommendationLatencyMs = 200;

  Future<List<SearchRecommendationItem>> fetchRecommendations() async {
    await Future<void>.delayed(
      const Duration(milliseconds: _recommendationLatencyMs),
    );

    return [
      for (var i = 0; i < _recommendationTemplates.length; i++)
        SearchRecommendationItem(
          book: Book(
            id: 'search_recommend_${i + 1}',
            title: _recommendationTemplates[i].title,
            category: _recommendationTemplates[i].tags.join(' · '),
            coverAsset: _recommendationTemplates[i].cover,
          ),
          badgeLabel: _recommendationTemplates[i].badge,
          tags: _recommendationTemplates[i].tags,
          description: _recommendationTemplates[i].description,
          author: _recommendationTemplates[i].author,
        ),
    ];
  }

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

  static const List<_RecommendationTemplate> _recommendationTemplates = [
    _RecommendationTemplate(
      title: '被病娇囚禁后：我混成了团宠',
      tags: ['生存', '病娇', '美强惨', '反派'],
      description: '【追逐监禁+生存+团宠】一夜间，成为反派病娇的白月光，'
          '并被他囚禁在地下室中！你意外发现，自己绑定了生存系统……',
      author: '野眠',
      badge: '更新',
      cover: 'assets/covers/cover_01.png',
    ),
    _RecommendationTemplate(
      title: '一夜成孕：不婚总裁乖乖臣服',
      tags: ['生存', '病娇', '美强惨', '反派'],
      description: '睡了亿万总裁后你溜了，再次见面，你成了高冷总裁的贴身秘书，'
          '每天都在担心掉马甲，直到天才萌宝出生，宫家……',
      author: '白桃乌龙',
      badge: '完结',
      cover: 'assets/covers/cover_02.png',
    ),
    _RecommendationTemplate(
      title: '豪门少爷：哥哥们太爱我了怎办',
      tags: ['生存', '病娇', '美强惨', '反派'],
      description: '这是一个小白兔掉进狼窝，被吃干抹净的故事。你家与顾家打定了'
          '娃娃亲，可谁知两家都生了男孩。你父母双亡……',
      author: '宅宅在家',
      badge: '更新',
      cover: 'assets/covers/cover_03.png',
    ),
    _RecommendationTemplate(
      title: '清冷仙尊他破戒了',
      tags: ['仙侠', '纯爱', '苏爽', '修罗场'],
      description: '【先婚后爱+双洁+追妻火葬场】身为美貌仙尊，他从不近女色，'
          '直到那个魔界小公主缠了上来……',
      author: '青衫渡',
      badge: '完结',
      cover: 'assets/covers/cover_04.png',
    ),
    _RecommendationTemplate(
      title: '退婚后我惊艳全场',
      tags: ['古代', '重生', '豪门', '爽文'],
      description: '【重生+打脸+逆袭】上一世被渣男贱女害得家破人亡，重活一世，'
          '她要让所有人血债血偿……',
      author: '一盏离茶',
      badge: '更新',
      cover: 'assets/covers/cover_05.png',
    ),
    _RecommendationTemplate(
      title: '我在异世开酒楼',
      tags: ['玄幻', '种田', '轻松', '美食'],
      description: '【种田+美食+轻松日常】穿越到异世界，没有金手指，只有一手'
          '好厨艺，那就把酒楼开成全城第一吧！',
      author: '炊烟袅袅',
      badge: '连载',
      cover: 'assets/covers/cover_06.png',
    ),
  ];

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

class _RecommendationTemplate {
  const _RecommendationTemplate({
    required this.title,
    required this.tags,
    required this.description,
    required this.author,
    required this.badge,
    required this.cover,
  });

  final String title;
  final List<String> tags;
  final String description;
  final String author;
  final String badge;
  final String cover;
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
