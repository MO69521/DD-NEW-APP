import 'package:flutter/material.dart';

import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';

/// 推荐瀑布流底部加载态。
class BookshelfLoadMoreFooter extends StatelessWidget {
  const BookshelfLoadMoreFooter({super.key, required this.isVisible});

  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return const SizedBox.shrink();
    }

    return const Padding(
      padding: EdgeInsets.only(top: AppSpacing.md),
      child: Center(
        child: SizedBox(
          width: AppSizes.bookstoreLoadingIndicatorSize,
          height: AppSizes.bookstoreLoadingIndicatorSize,
          child: CircularProgressIndicator(
            strokeWidth: AppSizes.bookstoreLoadingIndicatorStrokeWidth,
          ),
        ),
      ),
    );
  }
}
