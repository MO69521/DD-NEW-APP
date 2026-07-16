import 'package:flutter/material.dart';

import '../widgets/app_button.dart';
import 'empty_state.dart';

/// L2 — 页面异步门闸：加载中 / 失败重试 / 空数据 / 内容。
///
/// 只负责 body 内容切换；外层 Scaffold / 顶栏由调用方自行包裹。
class AppAsyncPageBody extends StatelessWidget {
  const AppAsyncPageBody({
    super.key,
    required this.isLoading,
    this.errorMessage,
    this.onRetry,
    this.isEmpty = false,
    this.emptyTitle = '暂无数据',
    this.errorTitle = '加载失败',
    this.retryLabel = '重试',
    this.loadingColor,
    required this.child,
  });

  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final bool isEmpty;
  final String emptyTitle;
  final String errorTitle;
  final String retryLabel;
  final Color? loadingColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator(color: loadingColor));
    }

    if (errorMessage != null) {
      return EmptyState(
        title: errorTitle,
        description: errorMessage,
        action: onRetry == null
            ? null
            : AppButton(label: retryLabel, onPressed: onRetry),
      );
    }

    if (isEmpty) {
      return EmptyState(title: emptyTitle);
    }

    return child;
  }
}
