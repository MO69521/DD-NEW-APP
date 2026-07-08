import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_membership_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../../../shared/widgets/aurora_background.dart';
import '../../domain/entities/membership_hero_slide.dart';

/// L3 — 会员页 Hero 头图：固定纹理背景 + 主张文案轮播（左文右图）+ 指示点。
///
/// 背景为固定纹理图（不随轮播切换）；每页左侧主张文案、右侧主视觉插画贴右边缘；
/// 指示点水平居中（对齐 Figma 933:1120）。
/// 轮播跟手拖动 + 首尾橡皮筋，松手后一次最多切换 1 张。
class MembershipHero extends StatefulWidget {
  const MembershipHero({super.key, required this.slides});

  final List<MembershipHeroSlide> slides;

  static const String _bgAsset =
      'assets/images/membership/hero_texture.png';

  @override
  State<MembershipHero> createState() => _MembershipHeroState();
}

class _MembershipHeroState extends State<MembershipHero>
    with SingleTickerProviderStateMixin {
  /// 循环轮播：以大基数虚拟页中点起步，内容按取模映射，实现无限左右滑动。
  static const int _loopCycles = 1000;

  late final PageController _controller;
  late final int _baseIndex;
  late final AnimationController _imageScaleController;
  late final Animation<double> _imageScale;

  int _current = 0;
  double _dragDelta = 0;
  double? _viewportWidth;
  bool _isDragging = false;
  bool _isAnimating = false;

  int get _slideCount => widget.slides.length;

  @override
  void initState() {
    super.initState();
    _baseIndex = _loopCycles * _slideCount;
    _current = _baseIndex;
    _controller = PageController(initialPage: _baseIndex);
    _imageScaleController = AnimationController(
      vsync: this,
      duration: AppDurations.normal,
      value: 1,
    );
    _imageScale = CurvedAnimation(
      parent: _imageScaleController,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _imageScaleController.dispose();
    super.dispose();
  }

  /// 切到新一张时，右侧插画从 0 快速缩放弹入。
  void _playImagePop() => _imageScaleController.forward(from: 0);

  void _applyDragVisual() {
    final viewportWidth = _viewportWidth;
    if (viewportWidth == null || viewportWidth <= 0) return;

    // 循环轮播无首尾边界：仅限制单次跟手不超过相邻一页。
    final maxDrag = viewportWidth * AppSizes.membershipHeroMaxDragPageRatio;
    final clampedDrag = _dragDelta.clamp(-maxDrag, maxDrag);
    final targetPixels = (_current * viewportWidth - clampedDrag).clamp(
      (_current - 1) * viewportWidth,
      (_current + 1) * viewportWidth,
    );
    _controller.jumpTo(targetPixels);
  }

  Future<void> _settleDrag(DragEndDetails details) async {
    if (_isAnimating || _viewportWidth == null) return;

    final velocity = details.primaryVelocity ?? 0;
    final distanceThreshold = AppSizes.membershipHeroSwipeDistanceThreshold;
    final velocityThreshold = AppSizes.membershipHeroSwipeVelocityThreshold;

    int? target;
    if (_dragDelta <= -distanceThreshold || velocity <= -velocityThreshold) {
      target = _current + 1;
    } else if (_dragDelta >= distanceThreshold ||
        velocity >= velocityThreshold) {
      target = _current - 1;
    }

    setState(() => _isAnimating = true);

    if (target != null) {
      await _controller.animateToPage(
        target,
        duration: AppDurations.normal,
        curve: Curves.easeOutCubic,
      );
      if (mounted) {
        setState(() {
          _current = target!;
          _dragDelta = 0;
        });
      }
    } else {
      await _controller.animateToPage(
        _current,
        duration: AppDurations.fast,
        curve: Curves.easeOutBack,
      );
      if (mounted) {
        setState(() => _dragDelta = 0);
      }
    }

    if (mounted) {
      setState(() => _isAnimating = false);
    }
  }

  void _resetDrag() {
    if (_isAnimating) return;
    setState(() {
      _isDragging = false;
      _dragDelta = 0;
    });
    _controller.animateToPage(
      _current,
      duration: AppDurations.fast,
      curve: Curves.easeOutBack,
    );
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    if (_isAnimating) return;
    setState(() {
      _isDragging = true;
      _dragDelta = 0;
    });
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (_isAnimating || !_isDragging) return;

    setState(() {
      _dragDelta += details.primaryDelta ?? 0;
      _applyDragVisual();
    });
  }

  Future<void> _onHorizontalDragEnd(DragEndDetails details) async {
    if (_isAnimating) return;
    setState(() => _isDragging = false);
    await _settleDrag(details);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.membershipHeroHeight,
      child: Stack(
        children: [
          const Positioned.fill(
            child: ColoredBox(color: AppColors.backgroundDark),
          ),
          Positioned.fill(
            child: Image.asset(
              MembershipHero._bgAsset,
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          ),
          const Positioned.fill(
            child: AuroraBackground(
              opacity: 0.6,
              colorStops: [
                AppColors.auroraEdge,
                AppColors.auroraGlow,
                AppColors.auroraEdge,
              ],
            ),
          ),
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                _viewportWidth = constraints.maxWidth;
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onHorizontalDragStart: _onHorizontalDragStart,
                  onHorizontalDragUpdate: _onHorizontalDragUpdate,
                  onHorizontalDragEnd: _onHorizontalDragEnd,
                  onHorizontalDragCancel: _resetDrag,
                  child: PageView.builder(
                    controller: _controller,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _baseIndex * 2,
                    onPageChanged: (index) {
                      if (_isAnimating && index != _current) {
                        setState(() => _current = index);
                        _playImagePop();
                      }
                    },
                    itemBuilder: (context, index) {
                      final slide = widget.slides[index % _slideCount];
                      final isCurrent = index == _current;
                      return Stack(
                        children: [
                          Positioned(
                            right: 0,
                            top: AppSizes.membershipHeroSlideImageTop,
                            width: AppSizes.membershipHeroSlideImageWidth,
                            height: AppSizes.membershipHeroSlideImageHeight,
                            child: AnimatedBuilder(
                              animation: _imageScale,
                              builder: (context, child) => Transform.scale(
                                scale: isCurrent ? _imageScale.value : 1,
                                child: child,
                              ),
                              child: Image.asset(
                                slide.imageAsset,
                                fit: BoxFit.contain,
                                alignment: Alignment.center,
                                errorBuilder: (_, _, _) =>
                                    const SizedBox.shrink(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: AppSpacing.lg,
                              right: AppSpacing.lg,
                              top: AppSizes.membershipHeroTextTop,
                            ),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: _HeroSlideText(slide: slide),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: AppSizes.membershipDotsTop,
            child: IgnorePointer(
              child: Center(
                child: _Dots(
                  count: _slideCount,
                  current: _current % _slideCount,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSlideText extends StatelessWidget {
  const _HeroSlideText({required this.slide});

  final MembershipHeroSlide slide;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 单段落排版：主副字号在同一基线对齐，避免大号数字底部被
        // 行高 descent 抬高（Row + 交叉轴对齐无法保证不同字号视觉底对齐）。
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: slide.titlePrefix,
                style: AppTextStyles.membershipHeroEnergyLabel,
              ),
              const WidgetSpan(child: SizedBox(width: AppSpacing.xxs)),
              TextSpan(
                text: slide.titleHighlight,
                style: AppTextStyles.membershipHeroEnergyAmount,
              ),
              if (slide.titleSuffix.isNotEmpty) ...[
                const WidgetSpan(child: SizedBox(width: AppSpacing.xxs)),
                TextSpan(
                  text: slide.titleSuffix,
                  style: AppTextStyles.membershipHeroEnergyLabel,
                ),
              ],
            ],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              slide.subtitlePrefix,
              style: AppTextStyles.membershipHeroSubtitle.copyWith(
                color: AppColors.textOnDarkMuted,
              ),
            ),
            if (slide.subtitleValue.isNotEmpty) ...[
              const SizedBox(width: AppSpacing.xxs),
              AppText(
                slide.subtitleValue,
                style: AppTextStyles.membershipHeroSubtitle,
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < count; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.xxs),
          DecoratedBox(
            decoration: BoxDecoration(
              color: i == current
                  ? AppColors.textOnDark
                  : AppMembershipColors.dotInactive,
              borderRadius: BorderRadius.circular(
                AppSizes.membershipDotSize / 2,
              ),
            ),
            child: SizedBox(
              width: i == current
                  ? AppSizes.membershipDotsActiveWidth
                  : AppSizes.membershipDotSize,
              height: AppSizes.membershipDotSize,
            ),
          ),
        ],
      ],
    );
  }
}
