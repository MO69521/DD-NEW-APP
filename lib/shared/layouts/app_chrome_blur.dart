import 'package:flutter/widgets.dart';

/// 顶/底 Chrome 毛玻璃是否启用的滚动判定。
abstract final class AppChromeBlur {
  /// 列表已滚动、内容进入 Chrome 区域时启用模糊。
  static bool shouldBlurForScroll(ScrollMetrics metrics) {
    if (metrics.axis != Axis.vertical) return false;
    return metrics.pixels > 0 || metrics.extentBefore > 0;
  }

  /// 吸顶 Sliver 头部：内容叠入或已发生位移时启用模糊。
  static bool shouldBlurForSliver({
    required double shrinkOffset,
    required bool overlapsContent,
  }) {
    return overlapsContent || shrinkOffset > 0;
  }
}
