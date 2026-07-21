import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';

/// L3 — 书架页顶部白色垂直渐隐底，随 [scrollController] 位移与内容同滚。
///
/// 须作为 [Stack] 子节点，叠在 [CustomScrollView] 之下；高度
/// [AppSizes.bookshelfPageGradientHeight]，顶 [AppColors.bookshelfPageGradientStart]
/// → 底 [AppColors.bookshelfPageGradientEnd]。
class BookshelfPageScrollGradient extends StatelessWidget {
  const BookshelfPageScrollGradient({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: scrollController,
      builder: (context, child) {
        final offset = scrollController.hasClients
            ? scrollController.offset
            : 0.0;
        return Transform.translate(
          offset: Offset(0, -offset),
          child: child,
        );
      },
      child: const Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: double.infinity,
          height: AppSizes.bookshelfPageGradientHeight,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.bookshelfPageGradientStart,
                    AppColors.bookshelfPageGradientEnd,
                  ],
                ),
              ),
              child: SizedBox.expand(),
            ),
          ),
        ),
      ),
    );
  }
}
