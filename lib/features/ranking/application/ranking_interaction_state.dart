import 'package:equatable/equatable.dart';

import '../domain/entities/ranking_channel.dart';
import '../domain/entities/ranking_dimension.dart';

/// 交互状态：当前选中的维度与频道。
class RankingInteractionState extends Equatable {
  const RankingInteractionState({
    this.selectedDimension = RankingDimension.recommend,
    this.selectedChannel = RankingChannel.all,
  });

  final RankingDimension selectedDimension;
  final RankingChannel selectedChannel;

  RankingInteractionState copyWith({
    RankingDimension? selectedDimension,
    RankingChannel? selectedChannel,
  }) {
    return RankingInteractionState(
      selectedDimension: selectedDimension ?? this.selectedDimension,
      selectedChannel: selectedChannel ?? this.selectedChannel,
    );
  }

  @override
  List<Object?> get props => [selectedDimension, selectedChannel];
}
