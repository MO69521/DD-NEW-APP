import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_durations.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import 'app_segmented_switch.dart';
import 'elastic_tab_indicator.dart';

/// 竖向选项轨：左侧指示条随选中项平移，并沿高度先拉长再快速回弹。
///
/// 指示条效果复用 [ElasticTabIndicator]（`axis: Axis.vertical`），与横向 Tab
/// 黄条保持一致（架构 §3.5）。
class AppVerticalRailSwitch extends StatelessWidget {
  const AppVerticalRailSwitch({
    super.key,
    required this.itemCount,
    required this.selectedIndex,
    required this.onChanged,
    required this.itemBuilder,
    required this.itemSlotHeight,
    this.itemPaddingHorizontal = AppSpacing.sm,
    this.itemPaddingVertical = AppSpacing.md,
    this.indicatorWidth = 3,
    this.indicatorHeight = 16,
    this.indicatorColor = AppColors.accentYellow,
    this.indicatorRadius = AppRadius.full,
    this.duration = AppDurations.normal,
    this.stretchFactor = 1.6,
  });

  final int itemCount;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final AppSegmentedItemBuilder itemBuilder;
  final double itemSlotHeight;
  final double itemPaddingHorizontal;
  final double itemPaddingVertical;
  final double indicatorWidth;
  final double indicatorHeight;
  final Color indicatorColor;
  final double indicatorRadius;
  final Duration duration;
  final double stretchFactor;

  @override
  Widget build(BuildContext context) {
    if (itemCount == 0) {
      return const SizedBox.shrink();
    }

    final itemPadding = EdgeInsets.symmetric(
      horizontal: itemPaddingHorizontal,
      vertical: itemPaddingVertical,
    );

    Widget buildItem(int index) => SizedBox(
      height: itemSlotHeight,
      child: Padding(
        padding: itemPadding,
        child: Align(
          alignment: Alignment.centerLeft,
          child: itemBuilder(context, index, index == selectedIndex),
        ),
      ),
    );

    return SizedBox(
      height: itemSlotHeight * itemCount,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 占位测量层：撑开轨道尺寸（不可点，不可见）。
          IgnorePointer(
            child: Opacity(
              opacity: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var index = 0; index < itemCount; index++)
                    buildItem(index),
                ],
              ),
            ),
          ),
          ElasticTabIndicator(
            axis: Axis.vertical,
            selectedIndex: selectedIndex,
            slotWidth: itemSlotHeight,
            slotPitch: itemSlotHeight,
            width: indicatorWidth,
            height: indicatorHeight,
            color: indicatorColor,
            radius: indicatorRadius,
            duration: duration,
            stretchFactor: stretchFactor,
          ),
          for (var index = 0; index < itemCount; index++)
            Positioned(
              left: 0,
              right: 0,
              top: itemSlotHeight * index,
              height: itemSlotHeight,
              child: GestureDetector(
                onTap: () => onChanged(index),
                behavior: HitTestBehavior.opaque,
                child: buildItem(index),
              ),
            ),
        ],
      ),
    );
  }
}
