import '../../../../core/domain/entities/book.dart';
import '../../../../core/domain/entities/book_cover_bottom_badge.dart';
import '../../domain/entities/bookstore_page_content.dart';

/// 模拟服务端每次刷新返回新的内容快照，让预览环境可见数据更新。
BookstorePageContent buildBookstoreMockSnapshot({
  required int snapshotIndex,
  required String searchPlaceholder,
  required Map<RankingTab, List<Book>> rankingBooksByTab,
  required List<Book> editorPicks,
  required List<Book> guessLikeBooks,
  required Book continueReadingBook,
}) {
  return BookstorePageContent(
    searchPlaceholder: searchPlaceholder,
    rankingBooksByTab: Map.unmodifiable(
      rankingBooksByTab.map(
        (tab, books) => MapEntry(
          tab,
          _rotateBooks(_withBottomBadges(books), snapshotIndex),
        ),
      ),
    ),
    editorPicks: _rotateBooks(_withBottomBadges(editorPicks), snapshotIndex),
    guessLikeBooks: _rotateBooks(
      _withBottomBadges(guessLikeBooks),
      snapshotIndex,
    ),
    continueReadingBook: continueReadingBook,
  );
}

List<Book> _withBottomBadges(List<Book> books) {
  return List.unmodifiable(
    List.generate(books.length, (index) {
      final book = books[index];
      final popularity = index % 3 == 0;
      return Book(
        id: book.id,
        title: book.title,
        category: book.category,
        coverAsset: book.coverAsset,
        summary: book.summary,
        annotations: book.annotations,
        coverTag: book.coverTag,
        coverBottomBadge: BookCoverBottomBadge(
          type: popularity
              ? BookCoverBottomBadgeType.popularity
              : BookCoverBottomBadgeType.promotion,
          label: popularity
              ? '${(index + 5) * 11}.0万'
              : index.isEven
              ? '2.3万人在读'
              : '连续更新15周',
        ),
      );
    }),
  );
}

List<Book> _rotateBooks(List<Book> books, int offset) {
  if (books.isEmpty) return const [];
  final normalizedOffset = offset % books.length;
  return List.unmodifiable([
    ...books.skip(normalizedOffset),
    ...books.take(normalizedOffset),
  ]);
}
