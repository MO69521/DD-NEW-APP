import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_context.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/bookshelf_tab.dart';

/// 书架页顶部 Tab 切换（书架 / 阅读历史）。
///
/// 视觉与交互模式对齐书城 [RankingTabs]，独立实现便于后续统一重构。
class BookshelfPageTabs extends StatelessWidget {
  const BookshelfPageTabs({
    super.key,
    required this.selected,
    required this.onSelected,
    this.swipeProgress,
  });

  final BookshelfTab selected;
  final ValueChanged<BookshelfTab> onSelected;
  final ValueListenable<double>? swipeProgress;

  @override
  Widget build(BuildContext context) {
    final tabs = BookshelfTab.values;

    return _IntrinsicElasticTabRow(
      selectedIndex: tabs.indexOf(selected),
      swipeProgress: swipeProgress,
      children: [
        for (var i = 0; i < tabs.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.md),
          _BookshelfTabItem(
            tab: tabs[i],
            isSelected: tabs[i] == selected,
            onTap: () => onSelected(tabs[i]),
          ),
        ],
      ],
    );
  }
}

class _IntrinsicElasticTabRow extends StatefulWidget {
  const _IntrinsicElasticTabRow({
    required this.selectedIndex,
    required this.children,
    this.swipeProgress,
  });

  final int selectedIndex;
  final List<Widget> children;
  final ValueListenable<double>? swipeProgress;

  @override
  State<_IntrinsicElasticTabRow> createState() =>
      _IntrinsicElasticTabRowState();
}

class _IntrinsicElasticTabRowState extends State<_IntrinsicElasticTabRow> {
  final GlobalKey _rowKey = GlobalKey();
  late List<GlobalKey> _tabKeys;
  List<double>? _centers;

  @override
  void initState() {
    super.initState();
    _tabKeys = _buildTabKeys();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureTabs());
  }

  @override
  void didUpdateWidget(covariant _IntrinsicElasticTabRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.children.length != widget.children.length) {
      _tabKeys = _buildTabKeys();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureTabs());
  }

  List<GlobalKey> _buildTabKeys() {
    return [
      for (final child in widget.children)
        if (child is! SizedBox) GlobalKey(),
    ];
  }

  void _measureTabs() {
    if (!mounted) return;
    final rowBox = _rowKey.currentContext?.findRenderObject() as RenderBox?;
    if (rowBox == null) return;

    final centers = <double>[];
    for (final key in _tabKeys) {
      final box = key.currentContext?.findRenderObject() as RenderBox?;
      if (box == null) continue;
      final topLeft = box.localToGlobal(Offset.zero, ancestor: rowBox);
      centers.add(topLeft.dx + box.size.width / 2);
    }
    if (centers.length != _tabKeys.length) return;
    setState(() {
      _centers = centers;
    });
  }

  @override
  Widget build(BuildContext context) {
    var keyIndex = 0;
    return Stack(
      key: _rowKey,
      clipBehavior: Clip.none,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final child in widget.children)
              if (child is SizedBox)
                child
              else
                KeyedSubtree(key: _tabKeys[keyIndex++], child: child),
          ],
        ),
        if (_centers != null)
          _MeasuredElasticIndicator(
            selectedIndex: widget.selectedIndex,
            centers: _centers!,
            swipeProgress: widget.swipeProgress,
          ),
      ],
    );
  }
}

class _MeasuredElasticIndicator extends StatefulWidget {
  const _MeasuredElasticIndicator({
    required this.selectedIndex,
    required this.centers,
    this.swipeProgress,
  });

  final int selectedIndex;
  final List<double> centers;
  final ValueListenable<double>? swipeProgress;

  @override
  State<_MeasuredElasticIndicator> createState() =>
      _MeasuredElasticIndicatorState();
}

class _MeasuredElasticIndicatorState extends State<_MeasuredElasticIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late int _fromIndex;
  late int _toIndex;

  @override
  void initState() {
    super.initState();
    _fromIndex = widget.selectedIndex;
    _toIndex = widget.selectedIndex;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..value = 1;
  }

  @override
  void didUpdateWidget(covariant _MeasuredElasticIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex == widget.selectedIndex) return;
    if (widget.swipeProgress != null) return;
    _fromIndex = oldWidget.selectedIndex;
    _toIndex = widget.selectedIndex;
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.swipeProgress ?? _controller,
      builder: (context, child) {
        final progressData = _progressData();
        final baseWidth = AppSizes.tabIndicatorWidth;
        final width = baseWidth * (1 + 0.75 * progressData.stretch.clamp(0, 1));
        final center = progressData.center;

        return Positioned(
          left: center - width / 2,
          bottom: 0,
          child: Container(
            width: width,
            height: AppSizes.tabIndicatorHeight,
            decoration: BoxDecoration(
              color: context.appColors.accent,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
        );
      },
    );
  }

  ({double center, double stretch}) _progressData() {
    final swipeProgress = widget.swipeProgress?.value;
    if (swipeProgress != null) {
      final clampedProgress = swipeProgress.clamp(
        0.0,
        widget.centers.length - 1,
      );
      final fromIndex = clampedProgress.floor();
      final toIndex = clampedProgress.ceil().clamp(
        0,
        widget.centers.length - 1,
      );
      final localProgress = clampedProgress - fromIndex;
      final center =
          widget.centers[fromIndex] +
          (widget.centers[toIndex] - widget.centers[fromIndex]) * localProgress;
      final stretch = localProgress <= 0.5
          ? localProgress / 0.5
          : (1 - localProgress) / 0.5;
      return (center: center, stretch: stretch);
    }

    final rawProgress = _controller.value;
    final progress = Curves.easeOutCubic.transform(rawProgress);
    final center =
        widget.centers[_fromIndex] +
        (widget.centers[_toIndex] - widget.centers[_fromIndex]) * progress;
    return (center: center, stretch: _stretchProgress(rawProgress));
  }

  double _stretchProgress(double progress) {
    if (progress <= 0.35) {
      return Curves.easeOutCubic.transform(progress / 0.35);
    }
    if (progress <= 0.62) {
      return 1 - Curves.easeInCubic.transform((progress - 0.35) / 0.27);
    }
    return 0;
  }
}

class _BookshelfTabItem extends StatelessWidget {
  const _BookshelfTabItem({
    required this.tab,
    required this.isSelected,
    required this.onTap,
  });

  final BookshelfTab tab;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return AppPressable(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppText(
            tab.label,
            style:
                (isSelected
                        ? AppTextStyles.tabActiveDark
                        : AppTextStyles.tabInactiveDark)
                    .copyWith(
                      color: isSelected ? colors.textPrimary : colors.textMuted,
                    ),
          ),
          const SizedBox(height: AppSpacing.xs),
          const SizedBox(height: AppSizes.tabIndicatorHeight),
        ],
      ),
    );
  }
}
