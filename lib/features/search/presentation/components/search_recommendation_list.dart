import 'package:flutter/material.dart';

import '../../../../core/domain/entities/book.dart';
import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/layouts/app_bottom_nav.dart';
import '../../domain/entities/search_recommendation_item.dart';
import 'search_recommendation_row.dart';

/// L3 — 搜索默认推荐列表（builder 渲染，行间 16px 间距）。
class SearchRecommendationList extends StatelessWidget {
  const SearchRecommendationList({
    super.key,
    required this.items,
    this.onItemTap,
  });

  final List<SearchRecommendationItem> items;
  final void Function(Book book)? onItemTap;

  static const double _bottomReserve = AppBottomNav.barHeight + AppSpacing.xl;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppLayout.chromeTopHeight(context),
        AppSpacing.md,
        _bottomReserve,
      ),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        return SearchRecommendationRow(item: items[index], onTap: onItemTap);
      },
    );
  }
}
