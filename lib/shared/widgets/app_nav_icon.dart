import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../core/constants/main_tab_config.dart';
import '../../core/theme/app_durations.dart';
import '../../core/theme/app_sizes.dart';
import '../components/app_lottie.dart';
import 'app_asset_image.dart';

/// Level 1 — 底部导航 Tab 图标（PNG / SVG / Lottie）。
///
/// - 有 [MainTabItem.selectedLottieAsset]（当前 `yellow_light`）：未选中静态图；
///   选中后播 Lottie 一次并停在末帧；再次点选重播。
/// - 其余主题：SVG active/inactive + 选中缩放微动效。
class AppNavIcon extends StatefulWidget {
  const AppNavIcon({
    super.key,
    required this.item,
    required this.isSelected,
    this.tapEpoch = 0,
    this.size,
  });

  final MainTabItem item;
  final bool isSelected;

  /// 每次点击自增的计数：即使已选中，变化时也重放一次微动画 / Lottie。
  final int tapEpoch;

  /// 未传时：有 Lottie 资源用 [AppSizes.bottomNavLottieIconSize]，否则 [AppSizes.bottomNavIconSize]。
  final double? size;

  @override
  State<AppNavIcon> createState() => _AppNavIconState();
}

class _AppNavIconState extends State<AppNavIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Animation<double>? _scale;
  bool _lottieReady = false;
  bool _playLottieWhenReady = false;

  bool get _usesLottie => widget.item.selectedLottieAsset != null;

  double get _iconSize =>
      widget.size ??
      (_usesLottie
          ? AppSizes.bottomNavLottieIconSize
          : AppSizes.bottomNavIconSize);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.normal,
      value: _usesLottie ? 0 : 1,
    );
    if (!_usesLottie) {
      _scale = _buildScaleAnimation();
    }
  }

  Animation<double> _buildScaleAnimation() {
    return TweenSequence<double>([
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

  void _onLottieLoaded(LottieComposition composition) {
    _controller.duration = composition.duration;
    _lottieReady = true;
    if (!mounted) return;
    if (!widget.isSelected) {
      _controller.value = 0;
      return;
    }
    if (_playLottieWhenReady) {
      _playLottieWhenReady = false;
      _controller.forward(from: 0);
    } else {
      // 冷启动已选中：直接末帧，避免进页自动播一遍。
      _controller.value = 1;
    }
  }

  void _playSelectionFeedback() {
    if (_usesLottie) {
      _playLottieWhenReady = true;
      if (_lottieReady) {
        _playLottieWhenReady = false;
        _controller.forward(from: 0);
      }
      return;
    }
    _controller.forward(from: 0);
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
      _playSelectionFeedback();
      return;
    }
    if (oldWidget.isSelected && !widget.isSelected) {
      if (_usesLottie) {
        _lottieReady = false;
        _playLottieWhenReady = false;
        _controller.value = 0;
      } else {
        _controller.value = 1;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_usesLottie) {
      if (!widget.isSelected) {
        return AppAssetImage(
          assetPath: widget.item.iconAsset,
          width: _iconSize,
          height: _iconSize,
          fit: BoxFit.contain,
        );
      }
      return AppLottie(
        asset: widget.item.selectedLottieAsset!,
        width: _iconSize,
        height: _iconSize,
        repeat: false,
        controller: _controller,
        onLoaded: _onLottieLoaded,
      );
    }

    final assetPath = widget.isSelected && widget.item.selectedIconAsset != null
        ? widget.item.selectedIconAsset!
        : widget.item.iconAsset;

    return ScaleTransition(
      scale: _scale!,
      child: AppAssetImage(
        assetPath: assetPath,
        width: _iconSize,
        height: _iconSize,
        fit: BoxFit.contain,
      ),
    );
  }
}
