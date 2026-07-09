import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/dress_up_tab.dart';

/// L3 — 我的装扮页 Tab（主页背景 / 头像 / 头像挂件 / 称号）。
///
/// 按文案实际宽度排布（非均分），项间距固定 16px；黄色指示器采用统一
/// 弹性动效（平移 + 宽度拉伸回弹，§3.5），并按实测中心点对齐。
class DressUpTabBar extends StatelessWidget {
  const DressUpTabBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final DressUpTab selected;
  final ValueChanged<DressUpTab> onSelected;

  @override
  Widget build(BuildContext context) {
    final tabs = DressUpTab.values;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: _IntrinsicElasticTabRow(
        selectedIndex: tabs.indexOf(selected),
        children: [
          for (var i = 0; i < tabs.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.md),
            _DressUpTabItem(
              tab: tabs[i],
              isSelected: tabs[i] == selected,
              onTap: () => onSelected(tabs[i]),
            ),
          ],
        ],
      ),
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
    setState(() => _centers = centers);
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
          ),
      ],
    );
  }
}

class _MeasuredElasticIndicator extends StatefulWidget {
  const _MeasuredElasticIndicator({
    required this.selectedIndex,
    required this.centers,
  });

  final int selectedIndex;
  final List<double> centers;

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
    _controller = AnimationController(vsync: this, duration: AppDurations.normal)
      ..value = 1;
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
        final width =
            AppSizes.tabIndicatorWidth *
            (1 + 0.75 * stretchProgress.clamp(0, 1));
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
              color: AppColors.accentYellow,
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

class _DressUpTabItem extends StatelessWidget {
  const _DressUpTabItem({
    required this.tab,
    required this.isSelected,
    required this.onTap,
  });

  final DressUpTab tab;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final style =
        (isSelected
                ? AppTextStyles.tabActiveDark
                : AppTextStyles.tabInactiveDark)
            .copyWith(
              color: isSelected
                  ? AppColors.textOnDark
                  : AppColors.textOnDarkMuted,
            );

    return AppPressable(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(tab.label, style: style, maxLines: 1),
          const SizedBox(height: AppSpacing.xs),
          const SizedBox(height: AppSizes.tabIndicatorHeight),
        ],
      ),
    );
  }
}
