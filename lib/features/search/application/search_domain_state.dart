import 'package:equatable/equatable.dart';

import '../domain/entities/search_recommendation_item.dart';
import '../domain/entities/search_result_item.dart';

/// 搜索页领域状态。
class SearchDomainState extends Equatable {
  const SearchDomainState({
    this.results = const [],
    this.recommendations = const [],
  });

  final List<SearchResultItem> results;
  final List<SearchRecommendationItem> recommendations;

  SearchDomainState copyWith({
    List<SearchResultItem>? results,
    List<SearchRecommendationItem>? recommendations,
  }) {
    return SearchDomainState(
      results: results ?? this.results,
      recommendations: recommendations ?? this.recommendations,
    );
  }

  @override
  List<Object?> get props => [results, recommendations];
}
