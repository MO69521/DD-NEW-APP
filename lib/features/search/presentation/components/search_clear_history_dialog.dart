import 'package:flutter/material.dart';

import '../../../../shared/components/app_confirm_dialog.dart';

/// L3 — 清空搜索历史二次确认弹窗。
class SearchClearHistoryDialog extends StatelessWidget {
  const SearchClearHistoryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppConfirmDialog(title: '删除提示', message: '确认删除全部搜索历史吗？');
  }
}
