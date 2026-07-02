import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import 'app_blurred_chrome_bar.dart';
import '../widgets/app_icon.dart';
import '../widgets/app_text.dart';

/// 顶栏右侧动作（圆形图标按钮）配置。
class AppTopBarAction {
  const AppTopBarAction({
    this.iconAsset,
    this.label,
    this.onTap,
    this.iconSize = AppSizes.topBarActionIconSize,
  }) : assert(
         iconAsset != null || label != null,
         'Either iconAsset or label must be provided',
       );

  final String? iconAsset;
  final String? label;
  final VoidCallback? onTap;
  final double iconSize;
}

/// L2 — 通用二级页顶栏：返回圆钮 + 可选标题 + 右侧动作。
///
/// 可选 [showScrim] 渐变蒙版用于叠加在 hero 图上的沉浸式场景。
class AppTopBar extends StatelessWidget {
  const AppTopBar({
    super.key,
    this.statusBarHeight = 0,
    this.onBack,
    this.title,
    this.actions = const [],
    this.showScrim = false,
    this.chromeBlurEnabled = true,
    this.backIconAsset = 'assets/icons/ranking/back.svg',
  });

  final double statusBarHeight;
  final VoidCallback? onBack;
  final String? title;
  final List<AppTopBarAction> actions;
  final bool showScrim;
  final bool chromeBlurEnabled;
  final String backIconAsset;

  @override
  Widget build(BuildContext context) {
    final bar = Container(
      padding: EdgeInsets.only(top: statusBarHeight),
      decoration: showScrim
          ? const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.rankingHeroScrimMid,
                  AppColors.gradientFadeStart,
                ],
              ),
            )
          : null,
      child: SizedBox(
        height: AppSizes.topBarHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (title != null)
                Center(
                  child: AppText(
                    title!,
                    style: AppTextStyles.sectionTitleDark,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              if (onBack != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: _CircleButton(
                    onTap: onBack,
                    child: AppIcon(
                      assetPath: backIconAsset,
                      width: AppSizes.topBarBackIconWidth,
                      height: AppSizes.topBarBackIconHeight,
                      color: AppColors.textOnDark,
                    ),
                  ),
                ),
              if (actions.isNotEmpty)
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final action in actions) ...[
                        const SizedBox(width: AppSpacing.xs),
                        if (action.label != null)
                          _TextButton(action: action)
                        else
                          _CircleButton(
                            onTap: action.onTap,
                            child: AppIcon(
                              assetPath: action.iconAsset!,
                              width: action.iconSize,
                              height: action.iconSize,
                              color: AppColors.textOnDark,
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    return AppBlurredChromeBar(enabled: chromeBlurEnabled, child: bar);
  }
}

class _TextButton extends StatelessWidget {
  const _TextButton({required this.action});

  final AppTopBarAction action;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action.onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xs,
        ),
        child: AppText(
          action.label!,
          style: AppTextStyles.bodyMediumDark,
          maxLines: 1,
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: AppSizes.topBarCircleSize,
        height: AppSizes.topBarCircleSize,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: AppColors.overlayScrim,
          shape: BoxShape.circle,
        ),
        child: child,
      ),
    );
  }
}
