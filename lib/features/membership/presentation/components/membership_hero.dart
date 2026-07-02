import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_membership_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/membership_hero_slide.dart';

/// L3 — 会员页 Hero 头图：背景插画 + 主张文案轮播 + 指示点。
///
/// 背景熊插画按高度铺满并右对齐，左侧用暗色渐变衔接（消除接缝并衬托文案）；
/// 指示点水平居中（对齐 Figma 933:1120）。
/// 轮播跟手拖动 + 首尾橡皮筋，松手后一次最多切换 1 张。
class MembershipHero extends StatefulWidget {
  const MembershipHero({super.key, required this.slides});

  final List<MembershipHeroSlide> slides;

  static const String _bgAsset =
      'assets/images/membership/membership_hero_bg.png';

  @override
  State<MembershipHero> createState() => _MembershipHeroState();
}

class _MembershipHeroState extends State<MembershipHero> {
  final PageController _controller = PageController();
  int _current = 0;
  double _dragDelta = 0;
  double _rubberBandOffset = 0;
  double? _viewportWidth;
  bool _isDragging = false;
  bool _isAnimating = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _rubberBand(double overscroll, double viewportWidth) {
    final friction = AppSizes.membershipHeroRubberBandFriction;
    final ratio = overscroll / viewportWidth;
    return (1 - (1 / (ratio / friction + 1))) * viewportWidth;
  }

  void _applyDragVisual() {
    final viewportWidth = _viewportWidth;
    if (viewportWidth == null || viewportWidth <= 0) return;

    final lastIndex = widget.slides.length - 1;
    final atFirst = _current == 0;
    final atLast = _current == lastIndex;
    final maxDrag = viewportWidth * AppSizes.membershipHeroMaxDragPageRatio;

    if (atFirst && _dragDelta > 0) {
      _controller.jumpTo(0);
      _rubberBandOffset = _rubberBand(_dragDelta, viewportWidth);
      return;
    }

    if (atLast && _dragDelta < 0) {
      _controller.jumpTo(_current * viewportWidth);
      _rubberBandOffset = -_rubberBand(-_dragDelta, viewportWidth);
      return;
    }

    _rubberBandOffset = 0;
    final clampedDrag = _dragDelta.clamp(-maxDrag, maxDrag);
    final minPixels = atFirst ? 0.0 : (_current - 1) * viewportWidth;
    final maxPixels = atLast
        ? lastIndex * viewportWidth
        : (_current + 1) * viewportWidth;
    final targetPixels = (_current * viewportWidth - clampedDrag).clamp(
      minPixels,
      maxPixels,
    );
    _controller.jumpTo(targetPixels);
  }

  Future<void> _settleDrag(DragEndDetails details) async {
    if (_isAnimating || _viewportWidth == null) return;

    final velocity = details.primaryVelocity ?? 0;
    final distanceThreshold = AppSizes.membershipHeroSwipeDistanceThreshold;
    final velocityThreshold = AppSizes.membershipHeroSwipeVelocityThreshold;
    final lastIndex = widget.slides.length - 1;

    int? target;
    if (_current < lastIndex &&
        (_dragDelta <= -distanceThreshold || velocity <= -velocityThreshold)) {
      target = _current + 1;
    } else if (_current > 0 &&
        (_dragDelta >= distanceThreshold || velocity >= velocityThreshold)) {
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
          _rubberBandOffset = 0;
        });
      }
    } else {
      await _controller.animateToPage(
        _current,
        duration: AppDurations.fast,
        curve: Curves.easeOutBack,
      );
      if (mounted) {
        setState(() {
          _dragDelta = 0;
          _rubberBandOffset = 0;
        });
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
      _rubberBandOffset = 0;
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
      _rubberBandOffset = 0;
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
              fit: BoxFit.cover,
              alignment: Alignment.center,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          ),
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColors.gradientFadeEnd,
                    AppColors.gradientFadeStart,
                  ],
                  stops: [0.18, 0.62],
                ),
              ),
            ),
          ),
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.gradientFadeStart,
                    AppColors.gradientFadeEnd,
                  ],
                  stops: [0.62, 1.0],
                ),
              ),
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
                  child: Transform.translate(
                    offset: Offset(_rubberBandOffset, 0),
                    child: PageView.builder(
                      controller: _controller,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.slides.length,
                      onPageChanged: (index) {
                        if (_isAnimating) {
                          setState(() => _current = index);
                        }
                      },
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            left: AppSpacing.lg,
                            right: AppSpacing.lg,
                            top: AppSizes.membershipHeroTextTop,
                          ),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: _HeroSlideText(slide: widget.slides[index]),
                          ),
                        );
                      },
                    ),
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
                child: _Dots(count: widget.slides.length, current: _current),
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
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            AppText(
              slide.titlePrefix,
              style: AppTextStyles.membershipHeroEnergyLabel,
            ),
            const SizedBox(width: AppSpacing.xxs),
            AppText(
              slide.titleHighlight,
              style: AppTextStyles.membershipHeroEnergyAmount,
            ),
            const SizedBox(width: AppSpacing.xxs),
            AppText(
              slide.titleSuffix,
              style: AppTextStyles.membershipHeroEnergyLabel,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              slide.subtitlePrefix,
              style: AppTextStyles.membershipHeroSubtitle.copyWith(
                color: AppColors.textOnDarkMuted,
              ),
            ),
            const SizedBox(width: AppSpacing.xxs),
            AppText(
              slide.subtitleValue,
              style: AppTextStyles.membershipHeroSubtitle,
            ),
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
