import 'package:equatable/equatable.dart';

import '../domain/entities/book_discussion_filter.dart';
import '../domain/entities/book_detail_tab.dart';

/// 交互状态：当前 Tab、书架与送心状态。
class BookDetailInteractionState extends Equatable {
  const BookDetailInteractionState({
    this.selectedTab = BookDetailTab.detail,
    this.selectedDiscussionFilter = BookDiscussionFilter.all,
    this.isInShelf = false,
    this.isGiftSent = false,
  });

  final BookDetailTab selectedTab;
  final BookDiscussionFilter selectedDiscussionFilter;
  final bool isInShelf;
  final bool isGiftSent;

  BookDetailInteractionState copyWith({
    BookDetailTab? selectedTab,
    BookDiscussionFilter? selectedDiscussionFilter,
    bool? isInShelf,
    bool? isGiftSent,
  }) {
    return BookDetailInteractionState(
      selectedTab: selectedTab ?? this.selectedTab,
      selectedDiscussionFilter:
          selectedDiscussionFilter ?? this.selectedDiscussionFilter,
      isInShelf: isInShelf ?? this.isInShelf,
      isGiftSent: isGiftSent ?? this.isGiftSent,
    );
  }

  @override
  List<Object?> get props => [
    selectedTab,
    selectedDiscussionFilter,
    isInShelf,
    isGiftSent,
  ];
}
