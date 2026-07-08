import 'package:flutter/material.dart';

import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/search_suggestion.dart';
import 'search_suggestion_row.dart';

/// L3 — 搜索联想列表（输入实时匹配）。
class SearchSuggestionList extends StatelessWidget {
  const SearchSuggestionList({
    super.key,
    required this.suggestions,
    required this.query,
    this.onSelect,
  });

  final List<SearchSuggestion> suggestions;
  final String query;
  final ValueChanged<String>? onSelect;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppLayout.chromeTopHeight(context) + AppSpacing.xs,
        AppSpacing.md,
        AppSpacing.xxl,
      ),
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return SearchSuggestionRow(
          suggestion: suggestion,
          query: query,
          onTap: onSelect == null ? null : () => onSelect!(suggestion.keyword),
        );
      },
    );
  }
}
