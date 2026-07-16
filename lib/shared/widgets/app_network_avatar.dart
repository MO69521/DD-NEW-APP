import 'package:flutter/material.dart';

import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_theme_context.dart';

/// L1 组件 — 圆形网络头像，支持占位与加载失败回退。
class AppNetworkAvatar extends StatelessWidget {
  const AppNetworkAvatar({
    super.key,
    required this.imageUrl,
    required this.size,
    this.placeholderAsset = 'assets/images/profile/avatar_placeholder.png',
    this.borderWidth = AppSizes.hairline,
  });

  final String? imageUrl;
  final double size;
  final String placeholderAsset;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final radius = BorderRadius.circular(size / 2);
    final hasUrl = imageUrl != null && imageUrl!.isNotEmpty;

    Widget image;
    if (hasUrl) {
      image = Image.network(
        imageUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        gaplessPlayback: true,
        errorBuilder: (context, error, stackTrace) =>
            _Placeholder(size: size, assetPath: placeholderAsset),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _Placeholder(size: size, assetPath: placeholderAsset);
        },
      );
    } else {
      image = _Placeholder(size: size, assetPath: placeholderAsset);
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        border: Border.all(color: colors.coverBorder, width: borderWidth),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: SizedBox(width: size, height: size, child: image),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.size, required this.assetPath});

  final double size;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => ColoredBox(
        color: colors.surfaceGlass,
        child: Icon(Icons.person, size: size * 0.5, color: colors.textMuted),
      ),
    );
  }
}
