import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../shared/widgets/app_asset_image.dart';

/// 顶部全幅书籍封面（Figma 185:2343）：向下渐隐融入暗色背景。
///
/// 渐隐效果复用「我的页」头图同款 mask（[AppColors.profileHeroImageMask*]）。
/// 封面来源于被点击的书籍，禁止写死。
class BookDetailHeroCover extends StatelessWidget {
  const BookDetailHeroCover({super.key, required this.coverAsset});

  final String coverAsset;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.bookDetailHeroHeight,
      width: double.infinity,
      child: ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.profileHeroImageMaskOpaque,
            AppColors.profileHeroImageMaskOpaque,
            AppColors.profileHeroImageMaskSoft,
            AppColors.profileHeroImageMaskTransparent,
          ],
          stops: AppSizes.profileHeroImageMaskStops,
        ).createShader(bounds),
        blendMode: BlendMode.dstIn,
        child: AppAssetImage(
          assetPath: coverAsset,
          fit: BoxFit.cover,
          width: double.infinity,
          height: AppSizes.bookDetailHeroHeight,
        ),
      ),
    );
  }
}
