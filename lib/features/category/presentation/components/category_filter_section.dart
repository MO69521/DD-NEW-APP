import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../domain/entities/category_filter.dart';
import 'category_filter_chip.dart';

/// L3 — 筛选区：多组可换行的单选标签。
class CategoryFilterSection extends StatelessWidget {
  const CategoryFilterSection({
    super.key,
    required this.groups,
    required this.selectedIndexFor,
    this.onSelect,
  });

  final List<CategoryFilterGroup> groups;
  final int Function(String groupId) selectedIndexFor;
  final void Function(String groupId, int index)? onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var g = 0; g < groups.length; g++) ...[
          if (g == 1) ...[
            const SizedBox(height: AppSizes.categoryFilterDividerTopGap),
            const _CategoryFilterDivider(),
            const SizedBox(height: AppSizes.categoryFilterDividerBottomGap),
          ] else if (g > 1)
            const SizedBox(height: AppSizes.categoryFilterGroupSpacing),
          _FilterGroupRow(
            group: groups[g],
            selectedIndex: selectedIndexFor(groups[g].id),
            emphasis: g == 0
                ? CategoryFilterChipEmphasis.primary
                : CategoryFilterChipEmphasis.secondary,
            onSelect: onSelect,
          ),
        ],
      ],
    );
  }
}

class _CategoryFilterDivider extends StatelessWidget {
  const _CategoryFilterDivider();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      height: AppSizes.hairline,
      child: ColoredBox(color: AppColors.dividerOnDark),
    );
  }
}

class _FilterGroupRow extends StatefulWidget {
  const _FilterGroupRow({
    required this.group,
    required this.selectedIndex,
    required this.emphasis,
    this.onSelect,
  });

  final CategoryFilterGroup group;
  final int selectedIndex;
  final CategoryFilterChipEmphasis emphasis;
  final void Function(String groupId, int index)? onSelect;

  @override
  State<_FilterGroupRow> createState() => _FilterGroupRowState();
}

class _FilterGroupRowState extends State<_FilterGroupRow>
    with SingleTickerProviderStateMixin {
  final GlobalKey _stackKey = GlobalKey();
  late final AnimationController _indicatorController;
  late List<GlobalKey> _itemKeys;
  Offset? _fromCenter;
  Offset? _toCenter;

  bool get _usesSharedUnderline =>
      widget.emphasis == CategoryFilterChipEmphasis.primary;

  @override
  void initState() {
    super.initState();
    _itemKeys = _buildItemKeys();
    _indicatorController = AnimationController(
      vsync: this,
      duration: AppDurations.normal,
    )..value = 1;
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncIndicator());
  }

  @override
  void didUpdateWidget(covariant _FilterGroupRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.group.options.length != widget.group.options.length) {
      _itemKeys = _buildItemKeys();
    }
    if (oldWidget.selectedIndex != widget.selectedIndex ||
        oldWidget.group != widget.group) {
      _fromCenter = _toCenter;
      WidgetsBinding.instance.addPostFrameCallback((_) => _syncIndicator());
    }
  }

  @override
  void dispose() {
    _indicatorController.dispose();
    super.dispose();
  }

  List<GlobalKey> _buildItemKeys() {
    return List<GlobalKey>.generate(
      widget.group.options.length,
      (_) => GlobalKey(),
    );
  }

  void _syncIndicator() {
    if (!_usesSharedUnderline || !mounted) return;
    final stackBox = _stackKey.currentContext?.findRenderObject() as RenderBox?;
    final itemBox =
        _itemKeys[widget.selectedIndex].currentContext?.findRenderObject()
            as RenderBox?;
    if (stackBox == null || itemBox == null) return;

    final itemTopLeft = itemBox.localToGlobal(Offset.zero, ancestor: stackBox);
    final nextCenter = Offset(
      itemTopLeft.dx + itemBox.size.width / 2,
      itemTopLeft.dy +
          itemBox.size.height +
          AppSizes.categoryFilterChipLabelToUnderlineGap +
          AppSizes.categoryFilterUnderlineHeight / 2,
    );

    setState(() {
      _fromCenter ??= nextCenter;
      _toCenter = nextCenter;
    });
    _indicatorController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final chips = Wrap(
      spacing: AppSizes.categoryFilterChipSpacing,
      runSpacing: AppSizes.categoryFilterChipRunSpacing,
      children: [
        for (var i = 0; i < widget.group.options.length; i++)
          KeyedSubtree(
            key: _itemKeys[i],
            child: CategoryFilterChip(
              label: widget.group.options[i],
              selected: i == widget.selectedIndex,
              emphasis: widget.emphasis,
              showUnderline: !_usesSharedUnderline,
              onTap: widget.onSelect == null
                  ? null
                  : () => widget.onSelect!(widget.group.id, i),
            ),
          ),
      ],
    );

    if (!_usesSharedUnderline) return chips;

    return Stack(
      key: _stackKey,
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom:
                AppSizes.categoryFilterChipLabelToUnderlineGap +
                AppSizes.categoryFilterUnderlineHeight,
          ),
          child: chips,
        ),
        if (_toCenter != null)
          _ElasticWrapIndicator(
            controller: _indicatorController,
            fromCenter: _fromCenter ?? _toCenter!,
            toCenter: _toCenter!,
          ),
      ],
    );
  }
}

class _ElasticWrapIndicator extends StatelessWidget {
  const _ElasticWrapIndicator({
    required this.controller,
    required this.fromCenter,
    required this.toCenter,
  });

  final Animation<double> controller;
  final Offset fromCenter;
  final Offset toCenter;

  static const double _stretchFactor = 0.75;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final rawProgress = controller.value;
        final progress = Curves.easeOutCubic.transform(rawProgress);
        final stretchProgress = _stretchProgress(rawProgress);
        final width =
            AppSizes.categoryFilterUnderlineWidth *
            (1 + _stretchFactor * stretchProgress.clamp(0, 1));
        final center = Offset.lerp(fromCenter, toCenter, progress)!;

        return Positioned(
          left: center.dx - width / 2,
          top: center.dy - AppSizes.categoryFilterUnderlineHeight / 2,
          child: Container(
            width: width,
            height: AppSizes.categoryFilterUnderlineHeight,
            decoration: BoxDecoration(
              color: AppColors.accentYellow,
              borderRadius: BorderRadius.circular(AppRadius.full),
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
