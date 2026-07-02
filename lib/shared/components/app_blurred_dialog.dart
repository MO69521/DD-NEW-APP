import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_durations.dart';
import '../../routes/app_router.dart';

/// 全局弹窗入口：80% 不透明遮罩，无背景模糊。
///
/// 使用 [showGeneralDialog] + 自绘 [ColoredBox] 遮罩，避免 Web/原生
/// [showDialog] 遮罩层可能附带的模糊效果。
Future<T?> showAppBlurredDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? barrierColor,
}) {
  final scrim = barrierColor ?? AppColors.overlayScrim80;

  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.transparent,
    transitionDuration: AppDurations.normal,
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      return _AppDialogOverlay(
        scrimColor: scrim,
        onDismiss: () => AppRouter.pop(),
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
}) {
  return showAppBlurredDialog<T>(
    context: context,
    builder: builder,
    barrierColor: barrierColor,
  );
}

class _AppDialogOverlay extends StatelessWidget {
  const _AppDialogOverlay({
    required this.scrimColor,
    required this.onDismiss,
    required this.child,
  });

  final Color scrimColor;
  final VoidCallback onDismiss;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: onDismiss,
            behavior: HitTestBehavior.opaque,
            child: ColoredBox(color: scrimColor),
          ),
          SafeArea(child: Center(child: child)),
        ],
      ),
    );
  }
}
