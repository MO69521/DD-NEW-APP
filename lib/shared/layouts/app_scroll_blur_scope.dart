import 'package:flutter/material.dart';

import 'app_chrome_blur.dart';

/// 监听子树滚动，向 [builder] 提供顶栏 Chrome 毛玻璃是否启用。
class AppScrollBlurScope extends StatefulWidget {
  const AppScrollBlurScope({super.key, required this.builder});

  final Widget Function(BuildContext context, bool blurEnabled) builder;

  @override
  State<AppScrollBlurScope> createState() => _AppScrollBlurScopeState();
}

class _AppScrollBlurScopeState extends State<AppScrollBlurScope> {
  bool _blurEnabled = false;

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical) return false;
    final enabled = AppChromeBlur.shouldBlurForScroll(notification.metrics);
    if (enabled != _blurEnabled) {
      setState(() => _blurEnabled = enabled);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _onScrollNotification,
      child: widget.builder(context, _blurEnabled),
    );
  }
}
