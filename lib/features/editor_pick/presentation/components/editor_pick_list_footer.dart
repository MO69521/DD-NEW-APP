import 'package:flutter/material.dart';

import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';

/// L3 — 编辑推荐详情页列表底部上拉加载指示器（sliver）。
class EditorPickListFooter extends StatelessWidget {
  const EditorPickListFooter({super.key, required this.isLoadingMore});

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
