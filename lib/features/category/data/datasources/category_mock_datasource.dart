import '../../../../core/domain/entities/book.dart';
import '../../domain/entities/category_book_item.dart';
import '../../domain/entities/category_filter.dart';
import '../../domain/entities/category_page_content.dart';
import 'category_data_source.dart';

/// Mock 数据源：Phase 1 静态数据；真实接口实现请照 bookstore/search 范例补 remote datasource。
class CategoryMockDataSource implements CategoryDataSource {
  const CategoryMockDataSource();

  static const int _mockLatencyMs = 200;

  @override
  Future<CategoryPageContent> fetchPageContent() async {
    await Future<void>.delayed(const Duration(milliseconds: _mockLatencyMs));

    return CategoryPageContent(
      filterGroups: _filterGroups,
      items: _items,
    );
  }

  static const List<CategoryFilterGroup> _filterGroups = [
    CategoryFilterGroup(
      id: 'genre',
      options: [
        '全部', '古代', '现代', '纯爱', '仙侠', '宫斗', '末世',
        '娱乐圈', '豪门', '校园', '病娇', '重生', '穿越', '苏爽',
        '悬疑推理',
      ],
    ),
    CategoryFilterGroup(
      id: 'status',
      options: ['全部', '完结', '连载', '3日内更新'],
    ),
    CategoryFilterGroup(
      id: 'type',
      options: ['全部', '互动故事', '自由成长'],
    ),
    CategoryFilterGroup(
      id: 'sort',
      options: ['综合', '按热度', '按新作', '按互动'],
    ),
  ];

  static final List<CategoryBookItem> _items = [
    for (var i = 0; i < _templates.length; i++)
      CategoryBookItem(
        book: Book(
          id: 'category_${i + 1}',
          title: _templates[i].title,
          category: _templates[i].tags.join(' · '),
          coverAsset: _templates[i].cover,
        ),
        badgeLabel: _templates[i].badge,
        tags: _templates[i].tags,
        description: _templates[i].description,
        author: _templates[i].author,
      ),
  ];

  static const List<_CategoryTemplate> _templates = [
    _CategoryTemplate(
      title: '被病娇囚禁后：我混成了团宠',
      tags: ['生存', '病娇', '美强惨', '反派'],
      description: '【追逐监禁+生存+团宠】一夜间，成为反派病娇的白月光，'
          '并被他囚禁在地下室中！你意外发现，自己绑定了生存系统……',
      author: '野眠',
      badge: '更新',
      cover: 'assets/covers/cover_01.png',
    ),
    _CategoryTemplate(
      title: '一夜成孕：不婚总裁乖乖臣服',
      tags: ['生存', '病娇', '美强惨', '反派'],
      description: '睡了亿万总裁后你溜了，再次见面，你成了高冷总裁的贴身秘书，'
          '每天都在担心掉马甲，直到天才萌宝出生，宫家……',
      author: '白桃乌龙',
      badge: '完结',
      cover: 'assets/covers/cover_02.png',
    ),
    _CategoryTemplate(
      title: '豪门少爷：哥哥们太爱我了怎办',
      tags: ['生存', '病娇', '美强惨', '反派'],
      description: '这是一个小白兔掉进狼窝，被吃干抹净的故事。你家与顾家打定了'
          '娃娃亲，可谁知两家都生了男孩。你父母双亡……',
      author: '宅宅在家',
      badge: '更新',
      cover: 'assets/covers/cover_03.png',
    ),
    _CategoryTemplate(
      title: '清冷仙尊他破戒了',
      tags: ['仙侠', '纯爱', '苏爽', '修罗场'],
      description: '【先婚后爱+双洁+追妻火葬场】身为美貌仙尊，他从不近女色，'
          '直到那个魔界小公主缠了上来……',
      author: '青衫渡',
      badge: '完结',
      cover: 'assets/covers/cover_04.png',
    ),
    _CategoryTemplate(
      title: '退婚后我惊艳全场',
      tags: ['古代', '重生', '豪门', '爽文'],
      description: '【重生+打脸+逆袭】上一世被渣男贱女害得家破人亡，重活一世，'
          '她要让所有人血债血偿……',
      author: '一盏离茶',
      badge: '更新',
      cover: 'assets/covers/cover_05.png',
    ),
    _CategoryTemplate(
      title: '我在异世开酒楼',
      tags: ['玄幻', '种田', '轻松', '美食'],
      description: '【种田+美食+轻松日常】穿越到异世界，没有金手指，只有一手'
          '好厨艺，那就把酒楼开成全城第一吧！',
      author: '炊烟袅袅',
      badge: '连载',
      cover: 'assets/covers/cover_06.png',
    ),
  ];
}

class _CategoryTemplate {
  const _CategoryTemplate({
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
