import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'elastic_tab_indicator.dart';

/// L2 — 变宽（按文案实测）横向 Tab 行 + 统一 [ElasticTabIndicator]。
///
/// 用于非等宽、左对齐排布的 Tab（书架 / 装扮等）：内部测量各 Tab 中心点，
/// 叠加统一弹性指示线，并可随 [swipeProgress] 跟手位移。等宽 Tab 请直接用
/// [ElasticTabIndicator] 的 `slotWidth` + `slotPitch` 档位。
class ElasticTabRow extends StatefulWidget {
  const ElasticTabRow({
    super.key,
    required this.selectedIndex,
    required this.children,
    this.swipeProgress,
    this.indicatorColor = AppColors.accentYellow,
  });

  final int selectedIndex;

  /// Tab item 与间距 [SizedBox] 交错排列；[SizedBox] 不参与中心点测量。
  final List<Widget> children;

  /// 内容区左右滑动的连续进度（0..tabCount-1），驱动指示器跟手位移。
  final ValueListenable<double>? swipeProgress;
  final Color indicatorColor;

  @override
  State<ElasticTabRow> createState() => _ElasticTabRowState();
}

class _ElasticTabRowState extends State<ElasticTabRow> {
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
  void didUpdateWidget(covariant ElasticTabRow oldWidget) {
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
          ElasticTabIndicator(
            selectedIndex: widget.selectedIndex,
            centers: _centers!,
            swipeProgress: widget.swipeProgress,
            color: widget.indicatorColor,
          ),
      ],
    );
  }
}
