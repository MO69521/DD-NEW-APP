import 'package:equatable/equatable.dart';

/// 搜索联想词条（输入实时匹配）。
class SearchSuggestion extends Equatable {
  const SearchSuggestion({required this.keyword, this.badge});

  final String keyword;

  /// 词条标签（如「热搜」「作者」），为空则不展示。
  final String? badge;

  @override
  List<Object?> get props => [keyword, badge];
}
