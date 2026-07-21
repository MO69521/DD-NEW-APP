import 'package:flutter/cupertino.dart';

import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_shared_assets.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/app_asset_image.dart';

/// 页面进入时提前解码全部帧，避免首次拖动才加载导致动画停在首帧。
void precacheBookstoreRefreshFrames(BuildContext context) {
  for (final frame in AppSharedAssets.bookstoreRefreshBearFrames) {
    precacheImage(AssetImage(frame), context);
  }
}

/// 书城刷新视觉插槽：拖动未松手及刷新中均循环播放奔跑小熊。
class BookstoreRefreshVisual extends StatefulWidget {
  const BookstoreRefreshVisual({
    super.key,
    required this.refreshState,
    required this.progress,
  });

  final RefreshIndicatorMode refreshState;
  final double progress;

  @override
  State<BookstoreRefreshVisual> createState() => _BookstoreRefreshVisualState();
}

class _BookstoreRefreshVisualState extends State<BookstoreRefreshVisual>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppDurations.slow + AppDurations.normal,
  );
  bool _didPrecacheFrames = false;

  bool get _shouldLoop => widget.refreshState != RefreshIndicatorMode.inactive;

  @override
  void initState() {
    super.initState();
    _syncAnimation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didPrecacheFrames) return;
    _didPrecacheFrames = true;
    precacheBookstoreRefreshFrames(context);
  }

  @override
  void didUpdateWidget(BookstoreRefreshVisual oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncAnimation();
  }

  void _syncAnimation() {
    if (_shouldLoop) {
      if (!_controller.isAnimating) _controller.repeat();
      return;
    }
    _controller
      ..stop()
      ..value = widget.progress.clamp(0.0, 1.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.refreshState == RefreshIndicatorMode.inactive) {
      return const SizedBox.shrink();
    }

    final opacity = switch (widget.refreshState) {
      RefreshIndicatorMode.drag || RefreshIndicatorMode.done => widget.progress,
      _ => 1.0,
    };
    final scaleProgress = switch (widget.refreshState) {
      RefreshIndicatorMode.armed || RefreshIndicatorMode.refresh => 1.0,
      _ => Curves.easeOutCubic.transform(widget.progress.clamp(0.0, 1.0)),
    };
    const minimumScale =
        (AppSpacing.lg + AppSpacing.sm) /
        AppSizes.bookstoreRefreshAnimationSize;
    final scale = minimumScale + (1 - minimumScale) * scaleProgress;

    return Transform.translate(
      key: const ValueKey('bookstore-refresh-visual'),
      offset: const Offset(0, AppSpacing.xxl + AppSpacing.xl + AppSpacing.lg),
      child: Transform.scale(
        key: const ValueKey('bookstore-refresh-scale'),
        scale: scale,
        child: Opacity(
          opacity: opacity,
          child: SizedBox.square(
            dimension: AppSizes.bookstoreRefreshAnimationSize,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                const frames = AppSharedAssets.bookstoreRefreshBearFrames;
                final rawFrameIndex = (_controller.value * frames.length)
                    .floor();
                final frameIndex = _shouldLoop
                    ? rawFrameIndex % frames.length
                    : rawFrameIndex.clamp(0, frames.length - 1).toInt();
                return AppAssetImage(
                  assetPath: frames[frameIndex],
                  width: AppSizes.bookstoreRefreshAnimationSize,
                  height: AppSizes.bookstoreRefreshAnimationSize,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
