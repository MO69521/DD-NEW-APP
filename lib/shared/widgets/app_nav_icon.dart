import 'package:flutter/material.dart';

import '../../core/constants/main_tab_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_durations.dart';
import '../../core/theme/app_sizes.dart';
import 'app_asset_image.dart';

/// Level 1 — 底部导航 Tab 图标（PNG / SVG）。
class AppNavIcon extends StatefulWidget {
  const AppNavIcon({
    super.key,
    required this.item,
    required this.isSelected,
    this.tapEpoch = 0,
    this.size = AppSizes.bottomNavIconSize,
  });

  final MainTabItem item;
  final bool isSelected;

  /// 每次点击自增的计数：即使已选中，变化时也重放一次微动画。
  final int tapEpoch;
  final double size;

  @override
  State<AppNavIcon> createState() => _AppNavIconState();
}

class _AppNavIconState extends State<AppNavIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.normal,
      value: 1,
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1,
          end: AppSizes.bottomNavSelectedIconPeakScale,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: AppSizes.bottomNavSelectedIconPeakScale,
          end: AppSizes.bottomNavSelectedIconDipScale,
        ).chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: AppSizes.bottomNavSelectedIconDipScale,
          end: 1,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 30,
      ),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant AppNavIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    final becameSelected = !oldWidget.isSelected && widget.isSelected;
    final retappedWhileSelected =
        widget.isSelected &&
        oldWidget.isSelected &&
        widget.tapEpoch != oldWidget.tapEpoch;
    if (becameSelected || retappedWhileSelected) {
      _controller.forward(from: 0);
      return;
    }
    if (oldWidget.isSelected && !widget.isSelected) {
      _controller.value = 1;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final assetPath = widget.isSelected && widget.item.selectedIconAsset != null
        ? widget.item.selectedIconAsset!
        : widget.item.iconAsset;

    return ScaleTransition(
      scale: _scale,
      child: AppAssetImage(
        assetPath: assetPath,
        width: widget.size,
        height: widget.size,
        fit: BoxFit.contain,
        color: widget.isSelected ? null : AppColors.textOnDarkPlaceholder,
      ),
    );
  }
}
