import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_durations.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import 'app_segmented_switch.dart';

/// 竖向选项轨：左侧指示条随选中项平滑移动（对标 [AppSegmentedSwitch] 横向滑块）。
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

  @override
  Widget build(BuildContext context) {
    if (itemCount == 0) {
      return const SizedBox.shrink();
    }

    final itemPadding = EdgeInsets.symmetric(
      horizontal: itemPaddingHorizontal,
      vertical: itemPaddingVertical,
    );
    final indicatorTop = itemSlotHeight * selectedIndex +
        (itemSlotHeight - indicatorHeight) / 2;

    return SizedBox(
      height: itemSlotHeight * itemCount,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          IgnorePointer(
            child: Opacity(
              opacity: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var index = 0; index < itemCount; index++)
                    SizedBox(
                      height: itemSlotHeight,
                      child: Padding(
                        padding: itemPadding,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: itemBuilder(
                            context,
                            index,
                            index == selectedIndex,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          AnimatedPositioned(
            duration: AppDurations.normal,
            curve: Curves.easeInOut,
            left: 0,
            top: indicatorTop,
            width: indicatorWidth,
            height: indicatorHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: indicatorColor,
                borderRadius: BorderRadius.circular(indicatorRadius),
              ),
            ),
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
                child: Padding(
                  padding: itemPadding,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: itemBuilder(
                      context,
                      index,
                      index == selectedIndex,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
