import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';

/// 按焦点 + 最小顶部露出比例裁切图片，宽屏时仍保留封面人物面部区域。
///
/// 当 [BoxFit.cover] 按宽度放大导致顶部露出不足 [minRevealHeightRatio] 时，
/// 自动降低缩放并以暗色底衬水平居中，确保头图「露出比例」稳定。
class AppFocalCoverImage extends StatelessWidget {
  const AppFocalCoverImage({
    super.key,
    required this.image,
    this.aspectRatio = AppSizes.bookCardLargeCoverAspectRatio,
    this.focalPoint = const Offset(
      AppSizes.rankingHeroFocalX,
      AppSizes.rankingHeroFocalY,
    ),
    this.minRevealHeightRatio = AppSizes.rankingHeroMinRevealHeightRatio,
    this.backgroundColor = AppColors.backgroundDark,
    this.errorWidget,
  });

  final ImageProvider image;
  final double aspectRatio;
  final Offset focalPoint;
  final double minRevealHeightRatio;
  final Color backgroundColor;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final layout = _computeLayout(
          containerWidth: constraints.maxWidth,
          containerHeight: constraints.maxHeight,
          imageAspectRatio: aspectRatio,
          focalPoint: focalPoint,
          minRevealHeightRatio: minRevealHeightRatio,
        );

        final imageWidget = Image(
          image: image,
          fit: BoxFit.fill,
          width: layout.scaledWidth,
          height: layout.scaledHeight,
          gaplessPlayback: true,
          errorBuilder: errorWidget == null
              ? null
              : (context, error, stackTrace) => SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: errorWidget,
                ),
        );

        if (layout.useLetterbox) {
          return ColoredBox(
            color: backgroundColor,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  top: 0,
                  left: layout.horizontalInset,
                  width: layout.scaledWidth,
                  height: constraints.maxHeight,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: imageWidget,
                  ),
                ),
              ],
            ),
          );
        }

        return ClipRect(
          child: OverflowBox(
            maxWidth: layout.scaledWidth,
            maxHeight: layout.scaledHeight,
            minWidth: layout.scaledWidth,
            minHeight: layout.scaledHeight,
            alignment: layout.alignment,
            child: imageWidget,
          ),
        );
      },
    );
  }

  static _FocalCoverLayout _computeLayout({
    required double containerWidth,
    required double containerHeight,
    required double imageAspectRatio,
    required Offset focalPoint,
    required double minRevealHeightRatio,
  }) {
    final imageWidth = imageAspectRatio;
    const imageHeight = 1.0;

    final coverScale = math.max(
      containerWidth / imageWidth,
      containerHeight / imageHeight,
    );
    final topRevealRatio = (containerHeight / coverScale) / imageHeight;

    final scale = topRevealRatio < minRevealHeightRatio
        ? containerHeight / (minRevealHeightRatio * imageHeight)
        : coverScale;

    final scaledWidth = imageWidth * scale;
    final scaledHeight = imageHeight * scale;

    if (scaledWidth < containerWidth) {
      return _FocalCoverLayout(
        scaledWidth: scaledWidth,
        scaledHeight: scaledHeight,
        useLetterbox: true,
        horizontalInset: (containerWidth - scaledWidth) / 2,
        alignment: Alignment.topCenter,
      );
    }

    final alignmentX =
        scaledWidth > containerWidth ? focalPoint.dx * 2 - 1 : 0.0;

    return _FocalCoverLayout(
      scaledWidth: scaledWidth,
      scaledHeight: scaledHeight,
      useLetterbox: false,
      horizontalInset: 0,
      alignment: Alignment(alignmentX, -1),
    );
  }
}

class _FocalCoverLayout {
  const _FocalCoverLayout({
    required this.scaledWidth,
    required this.scaledHeight,
    required this.useLetterbox,
    required this.horizontalInset,
    required this.alignment,
  });

  final double scaledWidth;
  final double scaledHeight;
  final bool useLetterbox;
  final double horizontalInset;
  final Alignment alignment;
}
