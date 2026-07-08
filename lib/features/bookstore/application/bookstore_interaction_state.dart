import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/book.dart';
import '../domain/entities/bookstore_top_tab.dart';

/// 交互状态：顶栏 Tab 与榜单区块 Tab 选中项。
class BookstoreInteractionState extends Equatable {
  const BookstoreInteractionState({
    this.selectedTopTab = BookstoreTopTab.recommend,
    this.selectedRankingTab = RankingTab.recommend,
    this.continueReadingDismissed = false,
  });

  final BookstoreTopTab selectedTopTab;
  final RankingTab selectedRankingTab;

  /// 「继续阅读」浮层是否被手动关闭。
  final bool continueReadingDismissed;

  BookstoreInteractionState copyWith({
    BookstoreTopTab? selectedTopTab,
    RankingTab? selectedRankingTab,
    bool? continueReadingDismissed,
  }) {
    return BookstoreInteractionState(
      selectedTopTab: selectedTopTab ?? this.selectedTopTab,
      selectedRankingTab: selectedRankingTab ?? this.selectedRankingTab,
      continueReadingDismissed:
          continueReadingDismissed ?? this.continueReadingDismissed,
    );
  }

  @override
  List<Object?> get props => [
    selectedTopTab,
    selectedRankingTab,
    continueReadingDismissed,
  ];
}
