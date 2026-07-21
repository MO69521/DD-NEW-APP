import 'package:equatable/equatable.dart';

import '../domain/entities/book_discussion_filter.dart';
import '../domain/entities/book_discussion_sort.dart';
import '../domain/entities/book_detail_tab.dart';

/// 交互状态：当前 Tab、书架与送心状态。
class BookDetailInteractionState extends Equatable {
  const BookDetailInteractionState({
    this.selectedTab = BookDetailTab.detail,
    this.selectedDiscussionFilter = BookDiscussionFilter.all,
    this.selectedDiscussionSort = BookDiscussionSort.latest,
    this.isInShelf = false,
    this.isGiftSent = false,
    this.isPromoDismissed = false,
  });

  final BookDetailTab selectedTab;
  final BookDiscussionFilter selectedDiscussionFilter;
  final BookDiscussionSort selectedDiscussionSort;
  final bool isInShelf;
  final bool isGiftSent;

  /// 悬浮促销条本次进入详情页是否已被关闭（会话级，不持久化）。
  final bool isPromoDismissed;

  BookDetailInteractionState copyWith({
    BookDetailTab? selectedTab,
    BookDiscussionFilter? selectedDiscussionFilter,
    BookDiscussionSort? selectedDiscussionSort,
    bool? isInShelf,
    bool? isGiftSent,
    bool? isPromoDismissed,
  }) {
    return BookDetailInteractionState(
      selectedTab: selectedTab ?? this.selectedTab,
      selectedDiscussionFilter:
          selectedDiscussionFilter ?? this.selectedDiscussionFilter,
      selectedDiscussionSort:
          selectedDiscussionSort ?? this.selectedDiscussionSort,
      isInShelf: isInShelf ?? this.isInShelf,
      isGiftSent: isGiftSent ?? this.isGiftSent,
      isPromoDismissed: isPromoDismissed ?? this.isPromoDismissed,
    );
  }

  @override
  List<Object?> get props => [
    selectedTab,
    selectedDiscussionFilter,
    selectedDiscussionSort,
    isInShelf,
    isGiftSent,
    isPromoDismissed,
  ];
}
