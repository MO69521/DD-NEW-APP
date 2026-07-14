import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/theme/app_theme_context.dart';
import '../../../../shared/components/app_top_tab_bar.dart';
import '../../domain/entities/bookstore_top_tab.dart';

/// 书城顶栏一级 Tab（推荐 / 分类 / 排行）。统一复用 [AppTopTabBar]。
class BookstoreTopTabs extends StatelessWidget {
  const BookstoreTopTabs({
    super.key,
    required this.selected,
    this.onSelected,
    this.swipeProgress,
  });

  final BookstoreTopTab selected;
  final ValueChanged<BookstoreTopTab>? onSelected;
  final ValueListenable<double>? swipeProgress;

  @override
  Widget build(BuildContext context) {
    const tabs = BookstoreTopTab.values;
    final colors = context.appColors;

    return AppTopTabBar(
      items: [for (final tab in tabs) AppTopTabItem(label: tab.label)],
      selectedIndex: tabs.indexOf(selected),
      onSelected: (index) => onSelected?.call(tabs[index]),
      swipeProgress: swipeProgress,
      activeColor: colors.textPrimary,
      inactiveColor: colors.textMuted,
    );
  }
}
