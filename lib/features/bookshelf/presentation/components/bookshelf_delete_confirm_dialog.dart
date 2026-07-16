import 'package:flutter/material.dart';

import '../../../../shared/components/app_confirm_dialog.dart';
import '../../domain/entities/bookshelf_tab.dart';

/// L3 — 书架管理删除二次确认弹窗。
class BookshelfDeleteConfirmDialog extends StatelessWidget {
  const BookshelfDeleteConfirmDialog({
    super.key,
    required this.selectedTab,
    required this.selectedCount,
  });

  final BookshelfTab selectedTab;
  final int selectedCount;

  bool get _isHistory => selectedTab == BookshelfTab.history;

  String get _title {
    if (_isHistory) {
      return selectedCount > 1 ? '删除这 $selectedCount 条阅读历史？' : '删除这条阅读历史？';
    }
    return selectedCount > 1 ? '不再关注这 $selectedCount 本书籍？' : '不再关注该书籍？';
  }

  String get _description {
    if (_isHistory) {
      return '确认后将从阅读历史中移除，书籍仍会保留在书架中';
    }
    return '确认后将不再收到选中书籍的更新通知';
  }

  @override
  Widget build(BuildContext context) {
    return AppConfirmDialog(title: _title, message: _description);
  }
}
