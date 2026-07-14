import '../../../../core/domain/entities/book.dart';
import '../../domain/entities/bookshelf_page_content.dart';
import '../../domain/entities/bookshelf_tab.dart';
import 'bookshelf_data_source.dart';

/// Mock 数据源：Phase 1 静态数据；真实接口实现请照 bookstore/search 范例补 remote datasource。
class BookshelfMockDataSource implements BookshelfDataSource {
  const BookshelfMockDataSource();

  @override
  Future<BookshelfPageContent> fetchPageContent() async {
    return const BookshelfPageContent(
      todayReadingMinutes: 23,
      booksByTab: {
        BookshelfTab.shelf: _shelfBooks,
        BookshelfTab.history: _historyBooks,
      },
      recommendationBooks: _recommendationBooks,
    );
  }

  static const List<Book> _shelfBooks = [
    Book(
      id: 's1',
      title: '病态沉溺：少将军柔软可妻',
      category: '病娇总裁',
      coverAsset: 'assets/covers/cover_01.png',
    ),
    Book(
      id: 's2',
      title: '穿书后我成了团宠',
      category: '穿书甜宠',
      coverAsset: 'assets/covers/cover_02.png',
    ),
    Book(
      id: 's3',
      title: '重生之嫡女归来',
      category: '古言重生',
      coverAsset: 'assets/covers/cover_03.png',
    ),
    Book(
      id: 's4',
      title: '偏执大佬的掌心宠',
      category: '病娇总裁',
      coverAsset: 'assets/covers/cover_04.png',
    ),
    Book(
      id: 's5',
      title: '豪门千金她不装了',
      category: '豪门爽文',
      coverAsset: 'assets/covers/cover_05.png',
    ),
    Book(
      id: 's6',
      title: '我在异世开酒楼',
      category: '玄幻种田',
      coverAsset: 'assets/covers/cover_06.png',
    ),
  ];

  static const List<Book> _historyBooks = [
    Book(
      id: 'h1',
      title: '穿书后：将门六姝',
      category: '穿书古言',
      coverAsset: 'assets/covers/cover_04.png',
    ),
    Book(
      id: 'h2',
      title: '星际指挥官的掌心娇',
      category: '星际科幻',
      coverAsset: 'assets/covers/cover_05.png',
    ),
    Book(
      id: 'h3',
      title: '重生后我靠美食爆红',
      category: '美食种田',
      coverAsset: 'assets/covers/cover_06.png',
    ),
    Book(
      id: 'h4',
      title: '病娇影帝他又吃醋了',
      category: '娱乐圈',
      coverAsset: 'assets/covers/cover_01.png',
    ),
    Book(
      id: 'h5',
      title: '庶女逆袭记',
      category: '宅斗古言',
      coverAsset: 'assets/covers/cover_02.png',
    ),
    Book(
      id: 'h6',
      title: '我在末世开超市',
      category: '末世爽文',
      coverAsset: 'assets/covers/cover_03.png',
    ),
  ];

  static const List<Book> _recommendationBooks = [
    Book(
      id: 'br1',
      title: '全网都在磕我们 CP',
      category: '娱乐圈',
      coverAsset: 'assets/covers/cover_01.png',
      summary: '顶流女星和冷面影帝被迫同台，营业综艺里每一次对视都被全网放大。',
      annotations: ['甜宠', '娱乐圈', '双向暗恋'],
    ),
    Book(
      id: 'br2',
      title: '王爷他又吃醋了',
      category: '古言甜宠',
      coverAsset: 'assets/covers/cover_02.png',
      summary: '穿成和亲公主后，她只想躺平赚钱，却被傲娇王爷日日盯上。',
      annotations: ['古言', '轻松', '先婚后爱'],
    ),
    Book(
      id: 'br3',
      title: '快穿之反派逆袭',
      category: '快穿爽文',
      coverAsset: 'assets/covers/cover_03.png',
      summary: '绑定系统后，她穿进崩坏世界，替每个反派改写命运。',
      annotations: ['快穿', '爽文', '系统'],
    ),
    Book(
      id: 'br4',
      title: '清冷仙尊他破戒了',
      category: '仙侠言情',
      coverAsset: 'assets/covers/cover_04.png',
      summary: '人人敬畏的仙尊为护她入红尘，也第一次有了私心。',
      annotations: ['仙侠', '师徒', '救赎'],
    ),
    Book(
      id: 'br5',
      title: '退婚后我惊艳全场',
      category: '豪门爽文',
      coverAsset: 'assets/covers/cover_05.png',
      summary: '被退婚当天，她摘下面具亮出马甲，整个豪门圈都慌了。',
      annotations: ['豪门', '马甲', '逆袭'],
    ),
    Book(
      id: 'br6',
      title: '我在无限流里开店',
      category: '无限流',
      coverAsset: 'assets/covers/cover_06.png',
      summary: '别人忙着逃生，她在副本门口开起小店，连 Boss 都排队下单。',
      annotations: ['无限流', '经营', '脑洞'],
    ),
  ];
}
