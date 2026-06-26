import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// L1 组件 — 按文件扩展名自动选择图片加载方式。
///
/// | 扩展名 | 加载方式 |
/// |--------|----------|
/// | `.svg` | `SvgPicture.asset` |
/// | 其他   | `Image.asset`（PNG / JPEG 等） |
///
/// 福利页 Figma 导出资源多为 SVG，**不可**用 `Image.asset` 直接加载。
class AppAssetImage extends StatelessWidget {
  const AppAssetImage({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
  });

  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;

  bool get _isSvg => assetPath.toLowerCase().endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    if (_isSvg) {
      final picture = SvgPicture.asset(
        assetPath,
        width: width,
        height: height,
        fit: fit,
        colorFilter: color != null
            ? ColorFilter.mode(color!, BlendMode.srcIn)
            : null,
        placeholderBuilder: (_) => SizedBox(width: width, height: height),
      );

      if (width != null && height != null) {
        return SizedBox(width: width, height: height, child: picture);
      }

      return picture;
    }

    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      color: color,
      gaplessPlayback: true,
      errorBuilder: (context, error, stackTrace) =>
          SizedBox(width: width, height: height),
    );
  }
}
