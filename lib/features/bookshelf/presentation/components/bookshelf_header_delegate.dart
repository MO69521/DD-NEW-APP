import 'package:flutter/material.dart';

import '../../../../shared/components/app_blurred_chrome_bar.dart';
import '../../../../shared/layouts/app_chrome_blur.dart';

/// 吸顶 Sliver 头部委托：毛玻璃背景，内容可滚入下方。
class BookshelfHeaderDelegate extends SliverPersistentHeaderDelegate {
  BookshelfHeaderDelegate({required this.height, required this.child});

  final double height;
  final Widget child;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return AppBlurredChromeBar(
      enabled: AppChromeBlur.shouldBlurForSliver(
        shrinkOffset: shrinkOffset,
        overlapsContent: overlapsContent,
      ),
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant BookshelfHeaderDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}
