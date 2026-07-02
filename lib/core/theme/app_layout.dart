import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'app_sizes.dart';

/// 跨平台布局辅助（状态栏、安全区等）。
abstract final class AppLayout {
  /// 顶栏 Chrome 总高度（状态栏 + 工具栏）。
  static double chromeTopHeight(
    BuildContext context, {
    double barHeight = AppSizes.topBarHeight,
  }) {
    return statusBarHeight(context) + barHeight;
  }

  /// 主 Tab 底栏 Chrome 预留高度（含底栏与安全区间隙）。
  static double chromeBottomHeight(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return AppSizes.bottomNavBarHeight + bottomInset;
  }

  /// 页面顶部状态栏占位高度。
  ///
  /// - 有系统 safe area inset 时直接使用（含移动端浏览器刘海区）
  /// - 原生 App 无 inset 时回退设计稿占位 [AppSizes.statusBarPlaceholderHeight]
  /// - Web 桌面预览无 inset 时为 0，避免顶部空白条
  static double statusBarHeight(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    if (topInset > 0) return topInset;
    if (kIsWeb) return 0;
    return AppSizes.statusBarPlaceholderHeight;
  }

  /// 将 Figma 全屏帧内纵坐标（含状态栏区域）转为当前平台的 layout top。
  ///
  /// 设计稿 Y 通常从物理屏幕顶边量起（含 44pt 状态栏）；Web 无状态栏占位时需上移差值。
  static double figmaFrameTop(BuildContext context, double figmaY) {
    return figmaY -
        (AppSizes.statusBarPlaceholderHeight - statusBarHeight(context));
  }

  /// 将 Figma 全屏帧内高度（含状态栏区域）转为当前平台 layout 高度。
  static double figmaFrameHeight(BuildContext context, double figmaHeight) {
    return figmaHeight -
        (AppSizes.statusBarPlaceholderHeight - statusBarHeight(context));
  }

  /// 榜单头图高度：按设计稿 375×160 等比缩放。
  static double rankingHeroHeight(double layoutWidth) {
    return layoutWidth *
        AppSizes.rankingHeroDesignHeight /
        AppSizes.rankingHeroDesignWidth;
  }

  /// 将设计稿纵坐标按 375 帧宽等比换算为 layout 尺寸。
  static double rankingScaledDesignY(double layoutWidth, double figmaY) {
    return layoutWidth * figmaY / AppSizes.rankingHeroDesignWidth;
  }

  /// 将设计稿水平尺寸按 375 帧宽等比换算。
  static double rankingScaledDesignX(double layoutWidth, double figmaX) {
    return layoutWidth * figmaX / AppSizes.rankingHeroDesignWidth;
  }
}
