import 'package:flutter/material.dart';

import '../../core/theme/app_brand_colors.dart';
import '../../core/theme/app_colors.dart';
import '../components/app_blurred_chrome_bar.dart';
import 'app_chrome_blur.dart';

/// L2 — 页面 Chrome 叠层：内容全屏可滚入顶栏下方。
///
/// - 浅色主题：顶栏默认纯白实底（[AppColors.topChromeBarScrolledScrim]），不随滚动开关。
/// - 深色主题：仅当内容滚入顶栏区域时启用毛玻璃底。
class AppPageChrome extends StatefulWidget {
  const AppPageChrome({super.key, required this.topBar, required this.body});

  final Widget topBar;
  final Widget body;

  @override
  State<AppPageChrome> createState() => _AppPageChromeState();
}

class _AppPageChromeState extends State<AppPageChrome> {
  bool _topBlurEnabled = false;

  bool get _chromeEnabled =>
      AppBrandColors.isLightExperiment || _topBlurEnabled;

  bool _onScrollNotification(ScrollNotification notification) {
    final enabled = AppChromeBlur.shouldBlurForScroll(notification.metrics);
    if (enabled != _topBlurEnabled) {
      setState(() => _topBlurEnabled = enabled);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _onScrollNotification,
      child: Stack(
        fit: StackFit.expand,
        children: [
          widget.body,
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBlurredChromeBar(
              enabled: _chromeEnabled,
              scrimColor: AppColors.topChromeBarScrolledScrim,
              child: widget.topBar,
            ),
          ),
        ],
      ),
    );
  }
}
