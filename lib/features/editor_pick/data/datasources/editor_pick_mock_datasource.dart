import '../../../../core/domain/entities/book.dart';
import '../../domain/entities/editor_pick_book_item.dart';
import '../../domain/entities/editor_pick_page_content.dart';

/// Mock 数据源：Phase 1 静态数据，Phase 2 替换为 API datasource。
class EditorPickMockDataSource {
  const EditorPickMockDataSource();

  static const int _mockLatencyMs = 200;

  Future<EditorPickPageContent> fetchPageContent() async {
    await Future<void>.delayed(const Duration(milliseconds: _mockLatencyMs));

    return EditorPickPageContent(items: _items);
  }

  static final List<EditorPickBookItem> _items = [
    for (var i = 0; i < _templates.length; i++)
      EditorPickBookItem(
        book: Book(
          id: 'editor_pick_${i + 1}',
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

  static const List<_EditorPickTemplate> _templates = [
    _EditorPickTemplate(
      title: '病态沉溺：少将军柔软可妻',
      tags: ['生存', '病娇', '美强惨', '反派'],
      description: '【追逐监禁+生存+团宠】一夜间，成为反派病娇的白月光，'
          '并被他囚禁在地下室中！你意外发现，自己绑定了生存系统……',
      author: '野眠',
      badge: '更新',
      cover: 'assets/covers/cover_01.png',
    ),
    _EditorPickTemplate(
      title: '偏执大佬的掌心宠',
      tags: ['病娇', '豪门', '追妻', '苏爽'],
      description: '【偏执+甜宠+双向救赎】她以为自己是替身，直到某天'
          '撞见他藏在抽屉里的日记，每一页都写满了她的名字……',
      author: '白桃乌龙',
      badge: '完结',
      cover: 'assets/covers/cover_04.png',
    ),
    _EditorPickTemplate(
      title: '穿书后我成了团宠',
      tags: ['穿书', '甜宠', '团宠', '系统'],
      description: '【穿书+团宠+打脸】穿成恶毒女配后，她决定摆烂躺平，'
          '没想到全家大佬都把她宠上了天……',
      author: '宅宅在家',
      badge: '更新',
      cover: 'assets/covers/cover_02.png',
    ),
    _EditorPickTemplate(
      title: '穿成反派后我躺赢了',
      tags: ['穿书', '反派', '升级流', '脑洞'],
      description: '【穿书+反派+系统】穿成注定被主角团灭门的反派，'
          '她绑定摆烂系统，越躺赢越多……',
      author: '青衫渡',
      badge: '连载',
      cover: 'assets/covers/cover_06.png',
    ),
    _EditorPickTemplate(
      title: '重生之嫡女归来',
      tags: ['古代', '重生', '宫斗', '爽文'],
      description: '【重生+打脸+逆袭】上一世被渣男贱女害得家破人亡，'
          '重活一世，她要让所有人血债血偿……',
      author: '一盏离茶',
      badge: '完结',
      cover: 'assets/covers/cover_03.png',
    ),
    _EditorPickTemplate(
      title: '偏执王爷的替嫁妃',
      tags: ['古言', '替嫁', '病娇', '甜宠'],
      description: '【替嫁+先婚后爱+双洁】替姐姐嫁入王府，'
          '她只想安稳度日，谁知冷面王爷竟对她动了心……',
      author: '墨染流年',
      badge: '更新',
      cover: 'assets/covers/cover_05.png',
    ),
    _EditorPickTemplate(
      title: '豪门千金她不装了',
      tags: ['豪门', '爽文', '马甲', '打脸'],
      description: '【豪门+马甲+打脸】被退婚后她不再伪装，'
          '一个个马甲掉落，全场震惊……',
      author: '苏晚晚',
      badge: '更新',
      cover: 'assets/covers/cover_05.png',
    ),
    _EditorPickTemplate(
      title: '退婚后我惊艳全场',
      tags: ['豪门', '重生', '逆袭', '苏爽'],
      description: '【重生+打脸+逆袭】上一世被渣男贱女害得家破人亡，'
          '重活一世，她要让所有人血债血偿……',
      author: '一盏离茶',
      badge: '完结',
      cover: 'assets/covers/cover_03.png',
    ),
    _EditorPickTemplate(
      title: '我在异世开酒楼',
      tags: ['玄幻', '种田', '轻松', '美食'],
      description: '【种田+美食+轻松日常】穿越到异世界，没有金手指，'
          '只有一手好厨艺，那就把酒楼开成全城第一吧！',
      author: '炊烟袅袅',
      badge: '连载',
      cover: 'assets/covers/cover_06.png',
    ),
    _EditorPickTemplate(
      title: '闪婚后大佬他真香了',
      tags: ['先婚后爱', '病娇', '甜宠', '豪门'],
      description: '【闪婚+真香+甜宠】为救家族她闪婚了传闻中的冷面大佬，'
          '婚后才发现，这位大佬竟是她的头号粉丝……',
      author: '桃夭夭',
      badge: '更新',
      cover: 'assets/covers/cover_04.png',
    ),
  ];
}

class _EditorPickTemplate {
  const _EditorPickTemplate({
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
