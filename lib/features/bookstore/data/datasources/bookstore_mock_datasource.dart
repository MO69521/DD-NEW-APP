import '../../../../core/domain/entities/book.dart';
import '../../../../core/domain/entities/book_cover_tag.dart';
import '../../domain/entities/bookstore_page_content.dart';

/// Mock 数据源：Phase 1 静态数据，Phase 2 替换为 API datasource。
class BookstoreMockDataSource {
  const BookstoreMockDataSource();

  Future<BookstorePageContent> fetchPageContent() async {
    return BookstorePageContent(
      searchPlaceholder: _searchPlaceholder,
      rankingBooksByTab: _rankingBooksByTab,
      editorPicks: _editorPicks,
      guessLikeBooks: _guessYouLike,
      continueReadingBook: _continueReadingBook,
    );
  }

  static const Book _continueReadingBook = Book(
    id: 'cr1',
    title: '和前夫解绑后，黑莲花直播爆红了',
    category: '都市甜宠',
    coverAsset: 'assets/covers/cover_03.png',
  );

  static const String _searchPlaceholder = '穿书后：将门六姝';

  static const Map<RankingTab, List<Book>> _rankingBooksByTab = {
    RankingTab.recommend: [
      Book(
        id: 'r1',
        title: '病态沉溺：少将军柔软可妻',
        category: '病娇总裁',
        coverAsset: 'assets/covers/cover_01.png',
      ),
      Book(
        id: 'r2',
        title: '穿书后我成了团宠',
        category: '穿书甜宠',
        coverAsset: 'assets/covers/cover_02.png',
      ),
      Book(
        id: 'r3',
        title: '重生之嫡女归来',
        category: '古言重生',
        coverAsset: 'assets/covers/cover_03.png',
      ),
      Book(
        id: 'r4',
        title: '偏执大佬的掌心宠',
        category: '病娇总裁',
        coverAsset: 'assets/covers/cover_04.png',
      ),
      Book(
        id: 'r5',
        title: '豪门千金她不装了',
        category: '豪门爽文',
        coverAsset: 'assets/covers/cover_05.png',
      ),
      Book(
        id: 'r6',
        title: '我在异世开酒楼',
        category: '玄幻种田',
        coverAsset: 'assets/covers/cover_06.png',
      ),
    ],
    RankingTab.popular: [
      Book(
        id: 'p1',
        title: '全网都在磕我们 CP',
        category: '娱乐圈',
        coverAsset: 'assets/covers/cover_03.png',
      ),
      Book(
        id: 'p2',
        title: '清冷仙尊他破戒了',
        category: '仙侠言情',
        coverAsset: 'assets/covers/cover_01.png',
      ),
      Book(
        id: 'p3',
        title: '退婚后我惊艳全场',
        category: '豪门爽文',
        coverAsset: 'assets/covers/cover_05.png',
      ),
      Book(
        id: 'p4',
        title: '病娇竹马别过来',
        category: '病娇总裁',
        coverAsset: 'assets/covers/cover_02.png',
      ),
      Book(
        id: 'p5',
        title: '穿成反派后我躺赢了',
        category: '穿书甜宠',
        coverAsset: 'assets/covers/cover_06.png',
      ),
      Book(
        id: 'p6',
        title: '将军夫人是神医',
        category: '古言重生',
        coverAsset: 'assets/covers/cover_04.png',
      ),
    ],
    RankingTab.rising: [
      Book(
        id: 's1',
        title: '闪婚后大佬他真香了',
        category: '先婚后爱',
        coverAsset: 'assets/covers/cover_04.png',
      ),
      Book(
        id: 's2',
        title: '我在无限流里开店',
        category: '无限流',
        coverAsset: 'assets/covers/cover_06.png',
      ),
      Book(
        id: 's3',
        title: '被退婚后我马甲掉了',
        category: '豪门爽文',
        coverAsset: 'assets/covers/cover_02.png',
      ),
      Book(
        id: 's4',
        title: '穿书后我靠摆烂封神',
        category: '穿书甜宠',
        coverAsset: 'assets/covers/cover_01.png',
      ),
      Book(
        id: 's5',
        title: '偏执王爷的替嫁妃',
        category: '古言重生',
        coverAsset: 'assets/covers/cover_05.png',
      ),
      Book(
        id: 's6',
        title: '离婚后前夫他后悔了',
        category: '追妻火葬场',
        coverAsset: 'assets/covers/cover_03.png',
      ),
    ],
    RankingTab.completed: [
      Book(
        id: 'c1',
        title: '完结·病态沉溺',
        category: '病娇总裁',
        coverAsset: 'assets/covers/cover_01.png',
      ),
      Book(
        id: 'c2',
        title: '完结·穿书团宠',
        category: '穿书甜宠',
        coverAsset: 'assets/covers/cover_02.png',
      ),
      Book(
        id: 'c3',
        title: '完结·嫡女归来',
        category: '古言重生',
        coverAsset: 'assets/covers/cover_03.png',
      ),
      Book(
        id: 'c4',
        title: '完结·掌心宠',
        category: '病娇总裁',
        coverAsset: 'assets/covers/cover_04.png',
      ),
      Book(
        id: 'c5',
        title: '完结·千金不装',
        category: '豪门爽文',
        coverAsset: 'assets/covers/cover_05.png',
      ),
      Book(
        id: 'c6',
        title: '完结·异世酒楼',
        category: '玄幻种田',
        coverAsset: 'assets/covers/cover_06.png',
      ),
    ],
  };

  static const List<Book> _editorPicks = [
    Book(
      id: 'e1',
      title: '病态沉溺：少将军柔软可妻',
      category: '病娇总裁',
      coverAsset: 'assets/covers/cover_02.png',
      coverTag: BookCoverTag.completed,
    ),
    Book(
      id: 'e2',
      title: '病态沉溺：少将军柔软可妻',
      category: '病娇总裁',
      coverAsset: 'assets/covers/cover_03.png',
      coverTag: BookCoverTag.updated,
    ),
    Book(
      id: 'e3',
      title: '病态沉溺：少将军柔软可妻',
      category: '病娇总裁',
      coverAsset: 'assets/covers/cover_05.png',
      coverTag: BookCoverTag.completed,
    ),
    Book(
      id: 'e4',
      title: '病态沉溺：少将军柔软可妻',
      category: '病娇总裁',
      coverAsset: 'assets/covers/cover_04.png',
      coverTag: BookCoverTag.updated,
    ),
    Book(
      id: 'e5',
      title: '病态沉溺：少将军柔软可妻',
      category: '病娇总裁',
      coverAsset: 'assets/covers/cover_01.png',
      coverTag: BookCoverTag.completed,
    ),
    Book(
      id: 'e6',
      title: '病态沉溺：少将军柔软可妻',
      category: '病娇总裁',
      coverAsset: 'assets/covers/cover_06.png',
      coverTag: BookCoverTag.updated,
    ),
  ];

  static const List<Book> _guessYouLike = [
    Book(
      id: 'g1',
      title: '病态沉溺：少将军柔软可妻',
      category: '病娇总裁',
      coverAsset: 'assets/covers/cover_01.png',
      summary: '在这个充满竞争的商业世界里，病娇总裁李昊天以其独特魅力吸引众多追随者。',
      annotations: ['纯爱', '升级流', '系统', '开局巅峰', '脑洞'],
      coverTag: BookCoverTag.updated,
    ),
    Book(
      id: 'g2',
      title: '病态沉溺：少将军柔软可妻',
      category: '病娇总裁',
      coverAsset: 'assets/covers/cover_02.png',
      summary: '在这个充满竞争的商业世界里，病娇总裁李昊天以其独特魅力吸引众多追随者。',
      annotations: ['纯爱', '升级流', '系统', '开局巅峰', '脑洞'],
      coverTag: BookCoverTag.completed,
    ),
    Book(
      id: 'g3',
      title: '病态沉溺：少将军柔软可妻',
      category: '病娇总裁',
      coverAsset: 'assets/covers/cover_03.png',
      summary: '在这个充满竞争的商业世界里，病娇总裁李昊天以其独特魅力吸引众多追随者。',
      annotations: ['纯爱', '升级流', '系统', '开局巅峰', '脑洞'],
      coverTag: BookCoverTag.updated,
    ),
    Book(
      id: 'g4',
      title: '病态沉溺：少将军柔软可妻',
      category: '病娇总裁',
      coverAsset: 'assets/covers/cover_04.png',
      summary: '在这个充满竞争的商业世界里，病娇总裁李昊天以其独特魅力吸引众多追随者。',
      annotations: ['纯爱', '升级流', '系统', '开局巅峰', '脑洞'],
      coverTag: BookCoverTag.completed,
    ),
    Book(
      id: 'g5',
      title: '病态沉溺：少将军柔软可妻',
      category: '病娇总裁',
      coverAsset: 'assets/covers/cover_05.png',
      summary: '在这个充满竞争的商业世界里，病娇总裁李昊天以其独特魅力吸引众多追随者。',
      annotations: ['纯爱', '升级流', '系统', '开局巅峰', '脑洞'],
      coverTag: BookCoverTag.updated,
    ),
    Book(
      id: 'g6',
      title: '病态沉溺：少将军柔软可妻',
      category: '病娇总裁',
      coverAsset: 'assets/covers/cover_06.png',
      summary: '在这个充满竞争的商业世界里，病娇总裁李昊天以其独特魅力吸引众多追随者。',
      annotations: ['纯爱', '升级流', '系统', '开局巅峰', '脑洞'],
      coverTag: BookCoverTag.completed,
    ),
  ];
}
