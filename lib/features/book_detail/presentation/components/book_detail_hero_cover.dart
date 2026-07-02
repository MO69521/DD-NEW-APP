import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../shared/widgets/app_asset_image.dart';

/// 顶部氛围头图：375×190 固定比例，底部长渐隐；图像向下延伸与摘要卡重叠区衔接。
class BookDetailHeroCover extends StatelessWidget {
  const BookDetailHeroCover({super.key, required this.coverAsset});

  final String coverAsset;

  static const List<Color> _scrimColors = [
    AppColors.bookDetailHeroScrimClear,
    AppColors.bookDetailHeroScrimLight,
    AppColors.bookDetailHeroScrimSoft,
    AppColors.bookDetailHeroScrimMid,
    AppColors.bookDetailHeroScrimHeavy,
    AppColors.bookDetailHeroScrimHeavy,
  ];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: AppSizes.bookDetailHeroAspectRatio,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;
          final bleed = AppSizes.bookDetailContentHeroOverlap;
          final imageHeight = height + bleed;
          final scrimHeight =
              height * AppSizes.bookDetailHeroScrimHeightRatio + bleed;

          return ClipRect(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: imageHeight,
                  child: AppAssetImage(
                    assetPath: coverAsset,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: imageHeight,
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: scrimHeight,
                  child: const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: _scrimColors,
                        stops: AppSizes.bookDetailHeroScrimStops,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
