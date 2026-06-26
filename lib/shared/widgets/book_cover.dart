import 'package:flutter/material.dart';

import '../../core/theme/app_radius.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_colors.dart';

/// Level 1 — 书籍封面图，支持固定尺寸或宽高比。
class BookCover extends StatelessWidget {
  const BookCover({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.aspectRatio,
  }) : assert(
          (width != null && height != null) || aspectRatio != null,
          'Provide width+height or aspectRatio',
        );

  final String assetPath;
  final double? width;
  final double? height;
  final double? aspectRatio;

  @override
  Widget build(BuildContext context) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    Widget image;
    if (width != null && height != null) {
      image = SizedBox(
        width: width,
        height: height,
        child: _buildImage((width! * devicePixelRatio).round()),
      );
    } else if (aspectRatio != null) {
      image = AspectRatio(
        aspectRatio: aspectRatio!,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            final cacheWidth = maxWidth.isFinite
                ? (maxWidth * devicePixelRatio).round()
                : null;
            return _buildImage(cacheWidth);
          },
        ),
      );
    } else {
      image = _buildImage(null);
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.coverSm),
        border: Border.all(
          color: AppColors.coverBorder,
          width: AppSizes.hairline,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.coverSm),
        child: image,
      ),
    );
  }

  /// 按显示尺寸解码并缓存，避免列表滚动时大图反复整图解码导致的闪烁/重载。
  /// [gaplessPlayback] 保留上一帧，杜绝重建瞬间的白屏。
  Widget _buildImage(int? cacheWidth) {
    return Image.asset(
      assetPath,
      fit: BoxFit.cover,
      gaplessPlayback: true,
      cacheWidth: cacheWidth,
    );
  }
}
