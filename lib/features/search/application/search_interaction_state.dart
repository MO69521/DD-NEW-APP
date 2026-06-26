import 'package:equatable/equatable.dart';

/// 交互状态：已提交的搜索关键词。
class SearchInteractionState extends Equatable {
  const SearchInteractionState({this.committedQuery = ''});

  final String committedQuery;

  SearchInteractionState copyWith({String? committedQuery}) {
    return SearchInteractionState(
      committedQuery: committedQuery ?? this.committedQuery,
    );
  }

  @override
  List<Object?> get props => [committedQuery];
}
