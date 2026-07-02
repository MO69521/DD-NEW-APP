import 'package:equatable/equatable.dart';

import '../domain/entities/editor_pick_book_item.dart';

/// 编辑推荐详情页领域状态。
class EditorPickDomainState extends Equatable {
  const EditorPickDomainState({
    this.seedItems = const [],
    this.items = const [],
  });

  /// 首屏结果，作为上拉加载更多时循环生成的种子。
  final List<EditorPickBookItem> seedItems;

  /// 当前展示的结果列表（随上拉追加）。
  final List<EditorPickBookItem> items;

  EditorPickDomainState copyWith({
    List<EditorPickBookItem>? seedItems,
    List<EditorPickBookItem>? items,
  }) {
    return EditorPickDomainState(
      seedItems: seedItems ?? this.seedItems,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [seedItems, items];
}
