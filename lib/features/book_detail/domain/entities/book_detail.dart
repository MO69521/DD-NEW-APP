import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/book.dart';
import 'book_catalog_chapter.dart';
import 'book_discussion_post.dart';
import 'book_update_entry.dart';

/// 角色介绍卡（穿书特色：可收藏/表白）。
class BookCharacter extends Equatable {
  const BookCharacter({
    required this.id,
    required this.name,
    required this.coverAsset,
  });

  final String id;
  final String name;
  final String coverAsset;

  @override
  List<Object?> get props => [id, name, coverAsset];
}

/// 书籍详情页聚合契约（纯 Dart）。
///
/// 统计类字段为展示就绪字符串（如 `235.6`），格式化由 mock/接口层负责。
class BookDetail extends Equatable {
  const BookDetail({
    required this.id,
    required this.title,
    required this.author,
    required this.authorAvatarAsset,
    required this.coverAsset,
    required this.tags,
    required this.shelfCount,
    required this.popularity,
    required this.wordCount,
    required this.intro,
    required this.serialStatus,
    required this.discussionCount,
    required this.discussionPosts,
    required this.updateEntries,
    required this.catalogChapters,
    required this.giftCount,
    required this.characters,
    required this.listedAtText,
    required this.copyrightText,
    this.authorOtherBooks = const [],
    this.recommendedBooks = const [],
  });

  final String id;
  final String title;
  final String author;
  final String authorAvatarAsset;

  /// 顶部全幅壁纸/封面资源。
  final String coverAsset;
  final List<String> tags;

  /// 数据条三列展示值。
  final String shelfCount;
  final String popularity;
  final String wordCount;

  final String intro;

  /// 目录入口副标题，如「连载中 · 更新至142章」。
  final String serialStatus;

  /// 讨论数（Tab 角标）。
  final int discussionCount;
  final List<BookDiscussionPost> discussionPosts;
  final List<BookUpdateEntry> updateEntries;
  final List<BookCatalogChapter> catalogChapters;

  /// 送心数（底部角标）。
  final String giftCount;

  final List<BookCharacter> characters;
  final String listedAtText;
  final String copyrightText;
  final List<Book> authorOtherBooks;
  final List<Book> recommendedBooks;

  BookDetail copyWith({
    String? title,
    String? coverAsset,
    List<BookDiscussionPost>? discussionPosts,
    List<BookUpdateEntry>? updateEntries,
    List<BookCatalogChapter>? catalogChapters,
    List<Book>? authorOtherBooks,
    List<Book>? recommendedBooks,
    String? listedAtText,
    String? copyrightText,
  }) {
    return BookDetail(
      id: id,
      title: title ?? this.title,
      author: author,
      authorAvatarAsset: authorAvatarAsset,
      coverAsset: coverAsset ?? this.coverAsset,
      tags: tags,
      shelfCount: shelfCount,
      popularity: popularity,
      wordCount: wordCount,
      intro: intro,
      serialStatus: serialStatus,
      discussionCount: discussionCount,
      discussionPosts: discussionPosts ?? this.discussionPosts,
      updateEntries: updateEntries ?? this.updateEntries,
      catalogChapters: catalogChapters ?? this.catalogChapters,
      giftCount: giftCount,
      characters: characters,
      listedAtText: listedAtText ?? this.listedAtText,
      copyrightText: copyrightText ?? this.copyrightText,
      authorOtherBooks: authorOtherBooks ?? this.authorOtherBooks,
      recommendedBooks: recommendedBooks ?? this.recommendedBooks,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    author,
    authorAvatarAsset,
    coverAsset,
    tags,
    shelfCount,
    popularity,
    wordCount,
    intro,
    serialStatus,
    discussionCount,
    discussionPosts,
    updateEntries,
    catalogChapters,
    giftCount,
    characters,
    listedAtText,
    copyrightText,
    authorOtherBooks,
    recommendedBooks,
  ];
}
