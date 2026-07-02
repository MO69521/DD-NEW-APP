import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_durations.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_sizes.dart';

typedef AppSegmentedItemBuilder =
    Widget Function(BuildContext context, int index, bool isSelected);

class AppSegmentedSwitch extends StatelessWidget {
  const AppSegmentedSwitch({
    super.key,
    required this.itemCount,
    required this.selectedIndex,
    required this.onChanged,
    required this.itemBuilder,
    this.outerRadius = AppRadius.bookDetailTabBar,
    this.innerRadius = AppRadius.bookDetailTabItem,
    this.outerPadding = AppSizes.bookDetailTabOuterPadding,
    this.itemPaddingVertical = AppSizes.bookDetailTabItemPaddingVertical,
    this.blurSigma = AppSizes.bookDetailGlassBlurSigma,
  });

  final int itemCount;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final AppSegmentedItemBuilder itemBuilder;
  final double outerRadius;
  final double innerRadius;
  final double outerPadding;
  final double itemPaddingVertical;
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(outerRadius);

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: EdgeInsets.all(outerPadding),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: radius,
            border: Border.all(
              color: AppColors.borderGlass,
              width: AppSizes.hairline,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = constraints.maxWidth / itemCount;

              return Stack(
                children: [
                  IgnorePointer(
                    child: Opacity(
                      opacity: 0,
                      child: Row(
                        children: [
                          for (var index = 0; index < itemCount; index++)
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: itemPaddingVertical,
                                ),
                                child: Center(
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
                    left: itemWidth * selectedIndex,
                    top: 0,
                    bottom: 0,
                    width: itemWidth,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.segmentedSelectedFill,
                        borderRadius: BorderRadius.circular(innerRadius),
                        border: Border.all(
                          color: AppColors.segmentedSelectedBorder,
                          width: AppSizes.hairline,
                        ),
                      ),
                    ),
                  ),
                  for (var index = 0; index < itemCount; index++)
                    Positioned(
                      left: itemWidth * index,
                      top: 0,
                      bottom: 0,
                      width: itemWidth,
                      child: GestureDetector(
                        onTap: () => onChanged(index),
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: itemPaddingVertical,
                          ),
                          child: Center(
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
              );
            },
          ),
        ),
      ),
    );
  }
}
