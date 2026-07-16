import 'package:equatable/equatable.dart';

import 'category_book_item.dart';
import 'category_filter.dart';

/// 分类页内容聚合（筛选组定义 + 结果列表）。
class CategoryPageContent extends Equatable {
  const CategoryPageContent({required this.filterGroups, required this.items});

  final List<CategoryFilterGroup> filterGroups;
  final List<CategoryBookItem> items;

  @override
  List<Object?> get props => [filterGroups, items];
}
