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
  });

  final String label;
  final VoidCallback? onPressed;
  final VoidCallback? onDisabledPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final bool isExpanded;
  final Widget? leadingIcon;

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

  static const double _disabledForegroundOpacity = 0.4;

  Color get _foregroundColor => switch (variant) {
    AppButtonVariant.accent => AppColors.rankingSegmentedSelectedText,
    AppButtonVariant.secondary => AppColors.textOnDark,
    AppButtonVariant.outline => AppColors.textOnDark,
    AppButtonVariant.vip => AppBrandColors.vipOnGradientText,
  };

  Color _foregroundColorFor(bool enabled) {
    if (enabled || isLoading) return _foregroundColor;
    return _foregroundColor.withValues(alpha: _disabledForegroundOpacity);
  }

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

  TextStyle _textStyleFor(bool enabled) {
    final base = size == AppButtonSize.normal
        ? AppTextStyles.buttonLabel16
        : AppTextStyles.bodyMedium.copyWith(fontWeight: AppFontWeights.medium);
    return base.copyWith(color: _foregroundColorFor(enabled), height: AppLineHeights.none);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = !isLoading && onPressed != null;
    final tapHandler = isLoading ? null : onPressed ?? onDisabledPressed;
    final radius = BorderRadius.circular(_radius);
    final foregroundColor = _foregroundColorFor(enabled);

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
                const SizedBox(width: AppSizes.buttonIconLabelGap),
              ],
              Flexible(
                child: AppText(
                  label,
                  style: _textStyleFor(enabled),
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
          color: _gradient == null ? _backgroundColor : null,
          gradient: _gradient,
          borderRadius: radius,
          border: _hasBorder
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
