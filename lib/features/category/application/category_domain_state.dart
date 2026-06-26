import 'package:equatable/equatable.dart';

import '../domain/entities/category_book_item.dart';
import '../domain/entities/category_filter.dart';

/// 分类页领域状态。
class CategoryDomainState extends Equatable {
  const CategoryDomainState({
    this.filterGroups = const [],
    this.seedItems = const [],
    this.items = const [],
  });

  final List<CategoryFilterGroup> filterGroups;

  /// 首屏结果，作为上拉加载更多时循环生成的种子。
  final List<CategoryBookItem> seedItems;

  /// 当前展示的结果列表（随上拉追加）。
  final List<CategoryBookItem> items;

  CategoryDomainState copyWith({
    List<CategoryFilterGroup>? filterGroups,
    List<CategoryBookItem>? seedItems,
    List<CategoryBookItem>? items,
  }) {
    return CategoryDomainState(
      filterGroups: filterGroups ?? this.filterGroups,
      seedItems: seedItems ?? this.seedItems,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [filterGroups, seedItems, items];
}
