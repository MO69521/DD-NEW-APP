import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/app_list_load_more_footer.dart';

/// 推荐瀑布流底部加载态。
class BookshelfLoadMoreFooter extends StatelessWidget {
  const BookshelfLoadMoreFooter({super.key, required this.isVisible});

  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return AppListLoadMoreFooter(
      isLoading: isVisible,
      padding: const EdgeInsets.only(top: AppSpacing.md),
    );
  }
}
