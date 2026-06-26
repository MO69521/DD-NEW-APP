import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/book.dart';

/// 交互状态：当前榜单 Tab 选中项。
class BookstoreInteractionState extends Equatable {
  const BookstoreInteractionState({
    this.selectedRankingTab = RankingTab.recommend,
  });

  final RankingTab selectedRankingTab;

  BookstoreInteractionState copyWith({
    RankingTab? selectedRankingTab,
  }) {
    return BookstoreInteractionState(
      selectedRankingTab: selectedRankingTab ?? this.selectedRankingTab,
    );
  }

  @override
  List<Object?> get props => [selectedRankingTab];
}
