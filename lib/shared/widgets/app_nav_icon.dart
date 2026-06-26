import 'package:flutter/material.dart';

import '../../core/constants/main_tab_config.dart';
import '../../core/theme/app_sizes.dart';
import 'app_asset_image.dart';

/// Level 1 — 底部导航 Tab 图标（PNG / SVG）。
class AppNavIcon extends StatelessWidget {
  const AppNavIcon({
    super.key,
    required this.item,
    required this.isSelected,
    this.size = AppSizes.bottomNavIconSize,
  });

  final MainTabItem item;
  final bool isSelected;
  final double size;

  @override
  Widget build(BuildContext context) {
    final assetPath = isSelected && item.selectedIconAsset != null
        ? item.selectedIconAsset!
        : item.iconAsset;

    return AppAssetImage(
      assetPath: assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
