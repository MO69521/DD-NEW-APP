import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../widgets/app_icon.dart';
import '../widgets/app_pressable.dart';
import '../widgets/app_text.dart';

/// L2 — 设置/账号等导航列表行：标题 + 可选副标题/尾部 + 箭头。
class AppNavigationListRow extends StatelessWidget {
  const AppNavigationListRow({
    super.key,
    required this.label,
    this.subtitle,
    this.trailingText,
    this.trailing,
    this.onTap,
    this.showChevron = true,
  });

  final String label;
  final String? subtitle;
  final String? trailingText;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showChevron;

  bool get _hasSubtitle => subtitle != null && subtitle!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final isTappable = onTap != null;
    final showArrow = showChevron && isTappable;

    return AppPressable(
      onTap: onTap,
      pressScale: AppSizes.tapPressScaleSubtle,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: AppSizes.listRowMinHeight,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText(
                      label,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (_hasSubtitle) ...[
                      const SizedBox(height: AppSpacing.xxs),
                      AppText(
                        subtitle!,
                        style: AppTextStyles.captionMdDarkMuted,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                trailing!,
                if (showArrow) const SizedBox(width: AppSpacing.xxs),
              ] else if (trailingText != null) ...[
                AppText(
                  trailingText!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (showArrow) const SizedBox(width: AppSpacing.xxs),
              ],
              if (showArrow)
                const AppIcon(
                  assetPath: 'assets/icons/arrow_right.svg',
                  width: AppSpacing.sm,
                  height: AppSpacing.sm,
                  color: AppColors.textTertiary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
