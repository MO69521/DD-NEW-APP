import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Level 1 — SVG 图标（assets/icons 下文件为 SVG，勿用 Image.asset）。
class AppIcon extends StatelessWidget {
  const AppIcon({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.color,
  });

  final String assetPath;
  final double? width;
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetPath,
      width: width,
      height: height,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
}
