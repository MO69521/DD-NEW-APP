import '../../../../core/domain/entities/book.dart';
import '../../../../core/domain/entities/book_cover_tag.dart';
import '../../domain/entities/bookstore_page_content.dart';

/// data 层 DTO：解析后端 JSON 字段，再 `toEntity()` 映射为 domain 领域模型。
/// domain 层保持纯净（不含 json），字段名/结构变化只影响本文件。
///
/// > 若多个 feature 复用 [BookDto]，可上提到 `lib/core/data/models/`。
class BookDto {
  const BookDto({
    required this.id,
    required this.title,
    required this.category,
    required this.cover,
    this.summary,
    this.annotations = const [],
    this.coverTag,
  });

  factory BookDto.fromJson(Map<String, Object?> json) {
    return BookDto(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String? ?? '',
      // 后端封面为 URL；映射到实体的 coverAsset 字段（见 book.dart 的 TODO）。
      cover: json['cover'] as String? ?? '',
      summary: json['summary'] as String?,
      annotations:
          (json['annotations'] as List<Object?>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      coverTag: json['coverTag'] as String?,
    );
  }

  final String id;
  final String title;
  final String category;
  final String cover;
  final String? summary;
  final List<String> annotations;
  final String? coverTag;

  Book toEntity() {
    return Book(
      id: id,
      title: title,
      category: category,
      coverAsset: cover,
      summary: summary,
      annotations: annotations,
      coverTag: BookCoverTag.fromLabel(coverTag),
    );
  }

  static List<Book> listToEntities(Object? jsonList) {
    if (jsonList is! List) return const [];
    return jsonList
        .map((e) => BookDto.fromJson(e as Map<String, Object?>).toEntity())
        .toList();
  }
}

/// 书城首页聚合 DTO。
class BookstorePageDto {
  const BookstorePageDto({
    required this.searchPlaceholder,
    required this.rankingBooksByTab,
    required this.editorPicks,
    required this.guessLikeBooks,
    this.continueReadingBook,
  });

  factory BookstorePageDto.fromJson(Map<String, Object?> json) {
    final rankingJson =
        json['rankingBooksByTab'] as Map<String, Object?>? ?? const {};
    final rankingByTab = <RankingTab, List<Book>>{};
    for (final entry in rankingJson.entries) {
      final tab = _rankingTabFromKey(entry.key);
      if (tab != null) {
        rankingByTab[tab] = BookDto.listToEntities(entry.value);
      }
    }

    final continueReading = json['continueReadingBook'];

    return BookstorePageDto(
      searchPlaceholder: json['searchPlaceholder'] as String? ?? '',
      rankingBooksByTab: rankingByTab,
      editorPicks: BookDto.listToEntities(json['editorPicks']),
      guessLikeBooks: BookDto.listToEntities(json['guessLikeBooks']),
      continueReadingBook: continueReading is Map<String, Object?>
          ? BookDto.fromJson(continueReading).toEntity()
          : null,
    );
  }

  final String searchPlaceholder;
  final Map<RankingTab, List<Book>> rankingBooksByTab;
  final List<Book> editorPicks;
  final List<Book> guessLikeBooks;
  final Book? continueReadingBook;

  BookstorePageContent toEntity() {
    return BookstorePageContent(
      searchPlaceholder: searchPlaceholder,
      rankingBooksByTab: rankingBooksByTab,
      editorPicks: editorPicks,
      guessLikeBooks: guessLikeBooks,
      continueReadingBook: continueReadingBook,
    );
  }

  /// 后端榜单 key（枚举名，如 `recommend`）→ [RankingTab]；未识别返回 null。
  static RankingTab? _rankingTabFromKey(String key) {
    for (final tab in RankingTab.values) {
      if (tab.name == key) return tab;
    }
    return null;
  }
}
