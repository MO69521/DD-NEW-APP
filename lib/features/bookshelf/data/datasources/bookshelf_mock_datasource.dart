import '../../../../core/domain/entities/book.dart';
import '../../domain/entities/bookshelf_page_content.dart';
import '../../domain/entities/bookshelf_tab.dart';

/// Mock 数据源：Phase 1 静态数据，Phase 2 替换为 API datasource。
class BookshelfMockDataSource {
  const BookshelfMockDataSource();

  Future<BookshelfPageContent> fetchPageContent() async {
    return const BookshelfPageContent(
      todayReadingMinutes: 23,
      booksByTab: {
        BookshelfTab.shelf: _shelfBooks,
        BookshelfTab.history: _historyBooks,
      },
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
    Book(
      id: 's7',
      title: '全网都在磕我们 CP',
      category: '娱乐圈',
      coverAsset: 'assets/covers/cover_01.png',
    ),
    Book(
      id: 's8',
      title: '王爷他又吃醋了',
      category: '古言甜宠',
      coverAsset: 'assets/covers/cover_02.png',
    ),
    Book(
      id: 's9',
      title: '快穿之反派逆袭',
      category: '快穿爽文',
      coverAsset: 'assets/covers/cover_03.png',
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
}
