import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/components/elastic_tab_indicator.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/bookshelf_tab.dart';
import '../../../../core/theme/app_theme_context.dart';

/// 书架页顶部 Tab 切换（书架 / 阅读历史）。
///
/// 视觉与交互模式对齐书城 [RankingTabs]，独立实现便于后续统一重构。
class BookshelfPageTabs extends StatelessWidget {
  const BookshelfPageTabs({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final BookshelfTab selected;
  final ValueChanged<BookshelfTab> onSelected;

  @override
  Widget build(BuildContext context) {
    final tabs = BookshelfTab.values;

    return _IntrinsicElasticTabRow(
      selectedIndex: tabs.indexOf(selected),
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
  });

  final int selectedIndex;
  final List<Widget> children;

  @override
  State<_IntrinsicElasticTabRow> createState() =>
      _IntrinsicElasticTabRowState();
}

class _IntrinsicElasticTabRowState extends State<_IntrinsicElasticTabRow> {
  final GlobalKey _rowKey = GlobalKey();
  late List<GlobalKey> _tabKeys;
  List<double>? _centers;
  List<double>? _widths;

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
    final widths = <double>[];
    for (final key in _tabKeys) {
      final box = key.currentContext?.findRenderObject() as RenderBox?;
      if (box == null) continue;
      final topLeft = box.localToGlobal(Offset.zero, ancestor: rowBox);
      centers.add(topLeft.dx + box.size.width / 2);
      widths.add(box.size.width);
    }
    if (centers.length != _tabKeys.length) return;
    setState(() {
      _centers = centers;
      _widths = widths;
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
        if (_centers != null && _widths != null)
          _MeasuredElasticIndicator(
            selectedIndex: widget.selectedIndex,
            centers: _centers!,
            widths: _widths!,
          ),
      ],
    );
  }
}

class _MeasuredElasticIndicator extends StatefulWidget {
  const _MeasuredElasticIndicator({
    required this.selectedIndex,
    required this.centers,
    required this.widths,
  });

  final int selectedIndex;
  final List<double> centers;
  final List<double> widths;

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
      animation: _controller,
      builder: (context, child) {
        final rawProgress = _controller.value;
        final progress = Curves.easeOutCubic.transform(rawProgress);
        final stretchProgress = _stretchProgress(rawProgress);
        final baseWidth = AppSizes.tabIndicatorWidth;
        final width = baseWidth * (1 + 0.75 * stretchProgress.clamp(0, 1));
        final center =
            widget.centers[_fromIndex] +
            (widget.centers[_toIndex] - widget.centers[_fromIndex]) * progress;

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

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
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
