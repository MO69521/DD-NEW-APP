import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/book.dart';
import '../domain/entities/bookstore_top_tab.dart';

/// 交互状态：顶栏 Tab 与榜单区块 Tab 选中项。
class BookstoreInteractionState extends Equatable {
  const BookstoreInteractionState({
    this.selectedTopTab = BookstoreTopTab.recommend,
    this.selectedRankingTab = RankingTab.recommend,
  });

  final BookstoreTopTab selectedTopTab;
  final RankingTab selectedRankingTab;

  BookstoreInteractionState copyWith({
    BookstoreTopTab? selectedTopTab,
    RankingTab? selectedRankingTab,
  }) {
    return BookstoreInteractionState(
      selectedTopTab: selectedTopTab ?? this.selectedTopTab,
      selectedRankingTab: selectedRankingTab ?? this.selectedRankingTab,
    );
  }

  @override
  List<Object?> get props => [selectedTopTab, selectedRankingTab];
}
