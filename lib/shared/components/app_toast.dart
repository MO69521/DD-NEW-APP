import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_durations.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_text_styles.dart';
import '../widgets/app_text.dart';

/// Level 2 — 全局轻提示 Toast（覆盖层 + 淡入淡出，自动消失）。
///
/// 用法：`AppToast.show(context, '加入成功')`。
abstract final class AppToast {
  static OverlayEntry? _current;

  static void show(BuildContext context, String message) {
    final overlay = Overlay.of(context, rootOverlay: true);

    _current?.remove();
    _current = null;

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _AppToastView(
        message: message,
        onDismissed: () {
          if (_current == entry) {
            _current = null;
          }
          entry.remove();
        },
      ),
    );

    _current = entry;
    overlay.insert(entry);
  }
}

class _AppToastView extends StatefulWidget {
  const _AppToastView({required this.message, required this.onDismissed});

  final String message;
  final VoidCallback onDismissed;

  @override
  State<_AppToastView> createState() => _AppToastViewState();
}

class _AppToastViewState extends State<_AppToastView> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _visible = true);
      Future.delayed(AppDurations.toastVisible, () {
        if (!mounted) return;
        setState(() => _visible = false);
      });
    });
  }

  void _onFadeEnd() {
    if (!_visible) widget.onDismissed();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.toastHorizontalMargin,
          ),
          child: Center(
            child: AnimatedOpacity(
              opacity: _visible ? 1 : 0,
              duration: AppDurations.fast,
              onEnd: _onFadeEnd,
              child: Material(
                type: MaterialType.transparency,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.accentYellow,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.toastPaddingHorizontal,
                      vertical: AppSizes.toastPaddingVertical,
                    ),
                    child: AppText(
                      widget.message,
                      style: AppTextStyles.toastMessage,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
