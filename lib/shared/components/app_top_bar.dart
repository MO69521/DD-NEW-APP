import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import 'app_blurred_chrome_bar.dart';
import 'app_top_bar_icon_button.dart';
import 'app_top_bar_text_button.dart';
import '../widgets/app_text.dart';

/// 顶栏右侧动作（图标按钮）配置。
class AppTopBarAction {
  const AppTopBarAction({
    this.iconAsset,
    this.label,
    this.onTap,
    this.iconSize = AppSizes.topBarActionIconDisplaySize,
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
                  AppColors.topBarHeroScrimStart,
                  AppColors.topBarHeroScrimEnd,
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
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: AppSizes.topBarTitleMaxWidth,
                    ),
                    child: AppText(
                      title!,
                      style: AppTextStyles.sectionTitleDark,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              if (onBack != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: AppTopBarIconButton(
                    onTap: onBack,
                    iconAsset: backIconAsset,
                    iconWidth: AppSizes.topBarBackIconWidth,
                    iconHeight: AppSizes.topBarBackIconHeight,
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
                          AppTopBarTextButton(
                            label: action.label!,
                            style: AppTextStyles.bodyMediumDark,
                            onTap: action.onTap,
                          )
                        else
                          _ActionIconButton(action: action),
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

/// 右上角动作图标：图标按原始设计尺寸展示，保留统一点击热区。
class _ActionIconButton extends StatelessWidget {
  const _ActionIconButton({required this.action});

  final AppTopBarAction action;

  @override
  Widget build(BuildContext context) {
    return AppTopBarIconButton(
      onTap: action.onTap,
      iconAsset: action.iconAsset!,
      iconWidth: action.iconSize,
      iconHeight: action.iconSize,
    );
  }
}
