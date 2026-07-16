import 'package:equatable/equatable.dart';

import '../domain/entities/search_recommendation_item.dart';
import '../domain/entities/search_result_item.dart';
import '../domain/entities/search_suggestion.dart';

/// 搜索页领域状态。
class SearchDomainState extends Equatable {
  const SearchDomainState({
    this.results = const [],
    this.recommendations = const [],
    this.hotKeywords = const [],
    this.searchHistory = const [],
    this.suggestions = const [],
  });

  final List<SearchResultItem> results;
  final List<SearchRecommendationItem> recommendations;
  final List<String> hotKeywords;
  final List<String> searchHistory;
  final List<SearchSuggestion> suggestions;

  SearchDomainState copyWith({
    List<SearchResultItem>? results,
    List<SearchRecommendationItem>? recommendations,
    List<String>? hotKeywords,
    List<String>? searchHistory,
    List<SearchSuggestion>? suggestions,
  }) {
    return SearchDomainState(
      results: results ?? this.results,
      recommendations: recommendations ?? this.recommendations,
      hotKeywords: hotKeywords ?? this.hotKeywords,
      searchHistory: searchHistory ?? this.searchHistory,
      suggestions: suggestions ?? this.suggestions,
    );
  }

  @override
  List<Object?> get props => [
    results,
    recommendations,
    hotKeywords,
    searchHistory,
    suggestions,
  ];
}
