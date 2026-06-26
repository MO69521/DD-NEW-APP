import 'package:equatable/equatable.dart';

import '../domain/entities/search_result_item.dart';

/// 搜索页领域状态。
class SearchDomainState extends Equatable {
  const SearchDomainState({this.results = const []});

  final List<SearchResultItem> results;

  SearchDomainState copyWith({List<SearchResultItem>? results}) {
    return SearchDomainState(results: results ?? this.results);
  }

  @override
  List<Object?> get props => [results];
}
