import '../core/domain/entities/book.dart';

/// 书籍详情路由的 extra 载荷：携带书籍实体与是否已在书架，供详情页渲染真实封面。
class BookDetailRouteExtra {
  const BookDetailRouteExtra({
    required this.book,
    this.isInShelf = false,
    this.coverHeroTag,
  });

  final Book book;
  final bool isInShelf;

  /// 入口书卡封面的 Hero 标签；传入后详情头图用同 tag 飞行（缺省回退书 id）。
  /// 用于同一屏内同书多次出现的场景（如书城首页），保证 tag 屏内唯一不冲突。
  final Object? coverHeroTag;
}
