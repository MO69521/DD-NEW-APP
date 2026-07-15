import 'package:flutter/material.dart';

import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_theme_assets.dart';
import '../widgets/app_asset_image.dart';

/// L2 — 一级 Tab（书城 / 福利 / 书架）顶部装饰纹理层。
///
/// 全宽、固定高度 [AppSizes.tabTopTextureHeight]，叠在滚动内容之下、不拦截点击。
/// [AppThemeAssets.tabTopTexture] 为 `null` 时只预留透明槽位（不填图、不染色）。
class AppTabTopTexture extends StatelessWidget {
  const AppTabTopTexture({super.key});

  @override
  Widget build(BuildContext context) {
    const assetPath = AppThemeAssets.tabTopTexture;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: AppSizes.tabTopTextureHeight,
      child: IgnorePointer(
        child: assetPath == null
            ? const SizedBox.expand()
            : AppAssetImage(
                assetPath: assetPath,
                width: double.infinity,
                height: AppSizes.tabTopTextureHeight,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
