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

/// L2 — 通用顶栏（单一控件多变体）。
///
/// 三个对齐槽位组合出全部形态：
/// - [leading]（左对齐，缺省为 [onBack] 返回钮）
/// - [center]（居中，缺省为 [title] 文案）
/// - [trailing]（右对齐，缺省为 [actions] 动作行）
///
/// 变体示例：
/// - 二级页：`onBack` + `title` + `actions`
/// - Tab 根页（居中 Tab）：`center: 自定义 Tab` + `trailing: 搜索按钮`
/// - Tab 根页（左对齐 Tab）：`leading: 自定义 Tab` + `trailing: 搜索按钮`
///
/// 布局参数 [height] / [horizontalPadding] 允许按页面复刻既有尺寸；
/// [chromeBlurEnabled] 为 false 时不包裹毛玻璃（供已在外层处理 blur 的 Tab 页使用）。
///
/// 可选 [showScrim] 渐变蒙版用于叠加在 hero 图上的沉浸式场景。
class AppTopBar extends StatelessWidget {
  const AppTopBar({
    super.key,
    this.statusBarHeight = 0,
    this.onBack,
    this.title,
    this.actions = const [],
    this.leading,
    this.center,
    this.trailing,
    this.height = AppSizes.topBarHeight,
    this.horizontalPadding = AppSpacing.md,
    this.showScrim = false,
    this.chromeBlurEnabled = true,
    this.backIconAsset = 'assets/icons/ranking/back.svg',
  });

  final double statusBarHeight;
  final VoidCallback? onBack;
  final String? title;
  final List<AppTopBarAction> actions;

  /// 左对齐槽位；提供时覆盖 [onBack] 返回钮。
  final Widget? leading;

  /// 居中槽位；提供时覆盖 [title] 文案。
  final Widget? center;

  /// 右对齐槽位；提供时覆盖 [actions] 动作行。
  final Widget? trailing;

  final double height;
  final double horizontalPadding;
  final bool showScrim;
  final bool chromeBlurEnabled;
  final String backIconAsset;

  @override
  Widget build(BuildContext context) {
    final centerChild = center ?? (title != null ? _buildTitle() : null);
    final leadingChild =
        leading ?? (onBack != null ? _buildBackButton() : null);
    final trailingChild =
        trailing ?? (actions.isNotEmpty ? _buildActions() : null);

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
        height: height,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (centerChild != null) Center(child: centerChild),
              if (leadingChild != null)
                Align(alignment: Alignment.centerLeft, child: leadingChild),
              if (trailingChild != null)
                Align(alignment: Alignment.centerRight, child: trailingChild),
            ],
          ),
        ),
      ),
    );

    return AppBlurredChromeBar(enabled: chromeBlurEnabled, child: bar);
  }

  Widget _buildTitle() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: AppSizes.topBarTitleMaxWidth),
      child: AppText(
        title!,
        style: AppTextStyles.sectionTitleDark,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildBackButton() {
    return AppTopBarIconButton(
      onTap: onBack,
      iconAsset: backIconAsset,
      iconWidth: AppSizes.topBarBackIconWidth,
      iconHeight: AppSizes.topBarBackIconHeight,
      showFrame: true,
    );
  }

  Widget _buildActions() {
    return Row(
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
    );
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
