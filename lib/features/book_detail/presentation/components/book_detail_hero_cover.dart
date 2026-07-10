import 'package:flutter/material.dart';

import '../../../../core/theme/app_sizes.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/book_cover_hero.dart';

/// 顶部氛围头图：375×219 固定比例自适应屏宽。
class BookDetailHeroCover extends StatelessWidget {
  const BookDetailHeroCover({
    super.key,
    required this.coverAsset,
    this.heroTag,
  });

  final String coverAsset;

  /// 共享元素转场标签；与来源书卡封面同 tag 时形成飞行过渡。
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    final image = AppAssetImage(
      assetPath: coverAsset,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );

    return AspectRatio(
      aspectRatio: AppSizes.bookDetailHeroAspectRatio,
      child: heroTag == null
          ? image
          : Hero(
              tag: heroTag!,
              createRectTween: bookCoverHeroRectTween,
              flightShuttleBuilder: bookCoverHeroFlightShuttleBuilder,
              child: image,
            ),
    );
  }
}
