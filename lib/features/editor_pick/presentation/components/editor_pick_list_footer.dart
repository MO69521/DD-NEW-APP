import 'package:flutter/material.dart';

import '../../../../shared/components/app_list_load_more_footer.dart';

/// L3 — 编辑推荐详情页列表底部上拉加载指示器（sliver）。
class EditorPickListFooter extends StatelessWidget {
  const EditorPickListFooter({super.key, required this.isLoadingMore});

  final bool isLoadingMore;

  @override
  Widget build(BuildContext context) {
    return AppListLoadMoreFooter(
      isLoading: isLoadingMore,
      asSliver: true,
    );
  }
}
