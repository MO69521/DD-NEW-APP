import 'package:flutter/material.dart';

import '../../../../core/theme/app_sizes.dart';
import '../../../../shared/widgets/app_asset_image.dart';

/// 顶部氛围头图：375×219 固定比例自适应屏宽。
class BookDetailHeroCover extends StatelessWidget {
  const BookDetailHeroCover({super.key, required this.coverAsset});

  final String coverAsset;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: AppSizes.bookDetailHeroAspectRatio,
      child: AppAssetImage(
        assetPath: coverAsset,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}
