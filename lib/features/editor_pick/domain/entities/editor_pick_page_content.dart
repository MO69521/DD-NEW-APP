import 'package:equatable/equatable.dart';

import 'editor_pick_book_item.dart';

/// 编辑推荐详情页内容聚合。
class EditorPickPageContent extends Equatable {
  const EditorPickPageContent({required this.items});

  final List<EditorPickBookItem> items;

  @override
  List<Object?> get props => [items];
}
