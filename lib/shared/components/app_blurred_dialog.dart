import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_durations.dart';

/// 全局居中弹窗入口：统一「80% 纯黑遮罩」（架构 §3.2），不加背景模糊。
///
/// 使用 [showGeneralDialog]，barrier 透明，由 [_AppDialogOverlay] 自绘
/// [ColoredBox] 遮罩（[AppColors.overlayScrim80]），保证所有弹窗遮罩一致。
Future<T?> showAppBlurredDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? barrierColor,
  bool barrierDismissible = true,
}) {
  final scrim = barrierColor ?? AppColors.overlayScrim80;

  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.transparent,
    transitionDuration: AppDurations.normal,
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      return _AppDialogOverlay(
        scrimColor: scrim,
        dismissible: barrierDismissible,
        child: builder(dialogContext),
      );
    },
  );
}

/// 与 [showAppBlurredDialog] 相同，保留别名便于语义区分。
Future<T?> showAppScrimDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? barrierColor,
  bool barrierDismissible = true,
}) {
  return showAppBlurredDialog<T>(
    context: context,
    builder: builder,
    barrierColor: barrierColor,
    barrierDismissible: barrierDismissible,
  );
}

class _AppDialogOverlay extends StatelessWidget {
  const _AppDialogOverlay({
    required this.scrimColor,
    required this.child,
    this.dismissible = true,
  });

  final Color scrimColor;
  final Widget child;
  final bool dismissible;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            // 关闭弹窗：弹窗经 showGeneralDialog 压入 Navigator，
            // 统一用 Navigator.pop 关闭（比 go_router pop 更稳，回到原页面）。
            // 非可关闭弹窗（如新手必填信息）点遮罩不关闭。
            onTap: dismissible ? () => Navigator.of(context).pop() : null,
            behavior: HitTestBehavior.opaque,
            child: ColoredBox(color: scrimColor),
          ),
          SafeArea(child: Center(child: child)),
        ],
      ),
    );
  }
}
