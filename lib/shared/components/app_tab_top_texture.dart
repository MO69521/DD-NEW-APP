import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_theme_assets.dart';
import '../widgets/app_asset_image.dart';

/// L2 — 福利页顶部装饰纹理层。
///
/// 全宽、高度默认 [AppSizes.tabTopTextureHeight]（页面可传语义 token 覆写，如
/// 福利页 [AppSizes.welfareTabTopTextureHeight]），叠在滚动内容之下、不拦截点击。
/// [AppThemeAssets.tabTopTexture] 为 `null` 时铺主题头部渐变
/// [AppColors.tabTopHeaderGradientStart]。该组件仅由福利页调用；仅
/// `yellow_light` 解析为主黄 → 白 0% 垂直渐隐，其余主题起止均透明。
class AppTabTopTexture extends StatelessWidget {
  const AppTabTopTexture({
    super.key,
    this.height = AppSizes.tabTopTextureHeight,
  });

  /// 装饰层高度；按页面语义传 `AppSizes` token，禁止写死数值。
  final double height;

  @override
  Widget build(BuildContext context) {
    const assetPath = AppThemeAssets.tabTopTexture;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: height,
      child: IgnorePointer(
        child: assetPath == null
            ? const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.tabTopHeaderGradientStart,
                      AppColors.tabTopHeaderGradientEnd,
                    ],
                  ),
                ),
                child: SizedBox.expand(),
              )
            : AppAssetImage(
                assetPath: assetPath,
                width: double.infinity,
                height: height,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
