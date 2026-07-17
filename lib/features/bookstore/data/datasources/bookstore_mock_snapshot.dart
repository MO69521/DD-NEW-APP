import '../../../../core/domain/entities/book.dart';
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
        (tab, books) => MapEntry(tab, _rotateBooks(books, snapshotIndex)),
      ),
    ),
    editorPicks: _rotateBooks(editorPicks, snapshotIndex),
    guessLikeBooks: _rotateBooks(guessLikeBooks, snapshotIndex),
    continueReadingBook: continueReadingBook,
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
