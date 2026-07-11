import 'package:flutter/material.dart';

import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacing.dart';

/// L2 — 列表底部上拉加载指示器。
///
/// [asSliver] 为 true 时包一层 [SliverToBoxAdapter]（分类 / 编辑精选等）。
class AppListLoadMoreFooter extends StatelessWidget {
  const AppListLoadMoreFooter({
    super.key,
    required this.isLoading,
    this.asSliver = false,
    this.padding = const EdgeInsets.symmetric(vertical: AppSpacing.lg),
  });

  final bool isLoading;
  final bool asSliver;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final body = Padding(
      padding: padding,
      child: Center(
        child: isLoading
            ? const SizedBox(
                width: AppSizes.bookstoreLoadingIndicatorSize,
                height: AppSizes.bookstoreLoadingIndicatorSize,
                child: CircularProgressIndicator(
                  strokeWidth: AppSizes.bookstoreLoadingIndicatorStrokeWidth,
                ),
              )
            : const SizedBox.shrink(),
      ),
    );

    if (asSliver) {
      return SliverToBoxAdapter(child: body);
    }
    return body;
  }
}
