import 'package:flutter/material.dart';

import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';

/// L3 — 列表底部上拉加载指示器（sliver）。
class CategoryListFooter extends StatelessWidget {
  const CategoryListFooter({super.key, required this.isLoadingMore});

  final bool isLoadingMore;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        child: Center(
          child: isLoadingMore
              ? const SizedBox(
                  width: AppSizes.bookstoreLoadingIndicatorSize,
                  height: AppSizes.bookstoreLoadingIndicatorSize,
                  child: CircularProgressIndicator(
                    strokeWidth: AppSizes.bookstoreLoadingIndicatorStrokeWidth,
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
