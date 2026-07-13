import 'package:flutter/material.dart';

import '../../core/theme/app_brand_colors.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_text_styles.dart';
import 'app_pressable.dart';
import 'app_text.dart';

/// 按钮视觉变体。
enum AppButtonVariant {
  /// 暗色页主 CTA（黄色胶囊）。
  accent,

  /// 次操作 / 弱强调面按钮（4% 白底、无描边、胶囊）。
  secondary,

  /// 描边按钮（透明底 + 细边框）。
  outline,

  /// VIP 粉色渐变胶囊（粉金渐变 + 深粉字），会员 / 福利 VIP 领取类操作。
  vip,
}

/// 按钮尺寸。
enum AppButtonSize { normal, small, compact }

/// L1 — 统一按钮，支持多视觉变体与尺寸。
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.onDisabledPressed,
    this.variant = AppButtonVariant.secondary,
    this.size = AppButtonSize.normal,
    this.isLoading = false,
    this.isExpanded = false,
    this.leadingIcon,
    this.iconLabelGap,
    this.fitLabel = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final VoidCallback? onDisabledPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final bool isExpanded;
  final Widget? leadingIcon;
  final double? iconLabelGap;

  /// 窄容器内完整显示：为 true 时标签随宽度自动缩小而非省略号截断。
  final bool fitLabel;

  Color get _backgroundColor => switch (variant) {
    AppButtonVariant.accent => AppColors.accentYellow,
    AppButtonVariant.secondary => AppColors.surfaceCard,
    AppButtonVariant.outline => Colors.transparent,
    AppButtonVariant.vip => Colors.transparent,
  };

  /// VIP 变体用粉金渐变填充（其它变体为纯色，返回 null）。
  LinearGradient? get _gradient => switch (variant) {
    AppButtonVariant.vip => const LinearGradient(
      colors: [
        AppBrandColors.vipGradientStart,
        AppBrandColors.vipGradientEnd,
      ],
    ),
    _ => null,
  };

  Color get _foregroundColor => switch (variant) {
    // 深色态：黄底深字（#202020，不变）；浅色实验态：粉底白字（保证对比）。
    AppButtonVariant.accent => AppBrandColors.isLightExperiment
        ? AppColors.white100
        : AppColors.rankingSegmentedSelectedText,
    AppButtonVariant.secondary => AppColors.textOnDark,
    AppButtonVariant.outline => AppColors.textOnDark,
    AppButtonVariant.vip => AppBrandColors.vipOnGradientText,
  };

  bool get _hasBorder => variant == AppButtonVariant.outline;

  double get _radius => AppRadius.full;

  EdgeInsets get _padding => switch (size) {
    AppButtonSize.normal => const EdgeInsets.symmetric(
      horizontal: AppSizes.buttonPaddingHNormal,
      vertical: AppSizes.buttonPaddingVNormal,
    ),
    AppButtonSize.small => const EdgeInsets.symmetric(
      horizontal: AppSizes.buttonPaddingHSmall,
      vertical: AppSizes.buttonPaddingVSmall,
    ),
    AppButtonSize.compact => const EdgeInsets.symmetric(
      horizontal: AppSizes.buttonPaddingHNormal,
      vertical: AppSizes.buttonPaddingVSmall,
    ),
  };

  TextStyle _textStyle(Color color) {
    final base = size == AppButtonSize.normal
        ? AppTextStyles.buttonLabel16
        : AppTextStyles.bodyMedium.copyWith(fontWeight: AppFontWeights.medium);
    return base.copyWith(color: color, height: AppLineHeights.none);
  }

  @override
  Widget build(BuildContext context) {
    final tapHandler = isLoading ? null : onPressed ?? onDisabledPressed;
    final radius = BorderRadius.circular(_radius);

    // 不可点击（禁用）态：非 loading 且无 onPressed。统一样式——4% 纯白填充 +
    // 30% 白字，无渐变、无描边（全局一致，覆盖各变体）。
    final isDisabled = onPressed == null && !isLoading;
    final backgroundColor = isDisabled
        ? AppColors.buttonDisabledFill
        : _backgroundColor;
    final gradient = isDisabled ? null : _gradient;
    final showBorder = _hasBorder && !isDisabled;
    final foregroundColor = isDisabled
        ? AppColors.buttonDisabledText
        : _foregroundColor;

    Widget content = isLoading
        ? SizedBox(
            width: AppSizes.buttonLoadingIndicatorSize,
            height: AppSizes.buttonLoadingIndicatorSize,
            child: CircularProgressIndicator(
              strokeWidth: AppSizes.bookstoreLoadingIndicatorStrokeWidth,
              color: foregroundColor,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leadingIcon != null) ...[
                leadingIcon!,
                SizedBox(width: iconLabelGap ?? AppSizes.buttonIconLabelGap),
              ],
              Flexible(
                child: fitLabel
                    ? FittedBox(
                        fit: BoxFit.scaleDown,
                        child: AppText(
                          label,
                          style: _textStyle(foregroundColor),
                          maxLines: 1,
                          textAlign: TextAlign.center,
                        ),
                      )
                    : AppText(
                        label,
                        style: _textStyle(foregroundColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
              ),
            ],
          );

    // heightFactor: 1.0 让按钮高度恒随内容收缩；置于 Row 等有界高度容器中时
    // 不会被拉伸至父级最大高度（否则 accent CTA 会撑满整屏）。
    content = Align(
      alignment: Alignment.center,
      widthFactor: isExpanded ? null : 1.0,
      heightFactor: 1.0,
      child: content,
    );
    if (isExpanded) {
      content = SizedBox(width: double.infinity, child: content);
    }

    return AppPressable(
      onTap: tapHandler,
      child: Container(
        decoration: BoxDecoration(
          color: gradient == null ? backgroundColor : null,
          gradient: gradient,
          borderRadius: radius,
          border: showBorder
              ? Border.all(
                  color: AppColors.borderGlass,
                  width: AppSizes.hairline,
                )
              : null,
        ),
        padding: _padding,
        child: content,
      ),
    );
  }
}
