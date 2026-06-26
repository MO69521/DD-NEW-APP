import 'package:equatable/equatable.dart';

import '../domain/entities/bookshelf_tab.dart';

/// 交互状态：当前 Tab、管理模式（预留）。
class BookshelfInteractionState extends Equatable {
  const BookshelfInteractionState({
    this.selectedTab = BookshelfTab.shelf,
    this.isManaging = false,
  });

  final BookshelfTab selectedTab;
  final bool isManaging;

  BookshelfInteractionState copyWith({
    BookshelfTab? selectedTab,
    bool? isManaging,
  }) {
    return BookshelfInteractionState(
      selectedTab: selectedTab ?? this.selectedTab,
      isManaging: isManaging ?? this.isManaging,
    );
  }

  @override
  List<Object?> get props => [selectedTab, isManaging];
}
