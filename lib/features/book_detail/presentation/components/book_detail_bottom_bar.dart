import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_assets.dart';
import '../../../../shared/components/app_blurred_chrome_bar.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';

/// 底部固定操作栏：加入书架 / 送心 / 开始阅读（Figma 183:2036）。
class BookDetailBottomBar extends StatelessWidget {
  const BookDetailBottomBar({
    super.key,
    required this.isInShelf,
    required this.isGiftSent,
    required this.giftCount,
    this.onShelfTap,
    this.onGiftTap,
    this.onReadTap,
  });

  final bool isInShelf;
  final bool isGiftSent;
  final String giftCount;
  final VoidCallback? onShelfTap;
  final VoidCallback? onGiftTap;
  final VoidCallback? onReadTap;

  @override
  Widget build(BuildContext context) {
    return AppBlurredChromeBar(
      scrimColor: AppColors.bottomActionBarScrim,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppColors.borderGlass,
              width: AppSizes.hairline,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: _IconAction(
                          iconAsset: isInShelf
                              ? AppThemeAssets.bookDetailInShelf
                              : AppThemeAssets.bookDetailAddToShelf,
                          iconWidth: AppSizes.bookDetailBottomIconSize,
                          iconHeight: AppSizes.bookDetailBottomIconSize,
                          label: isInShelf ? '已加书架' : '加入书架',
                          onTap: onShelfTap,
                        ),
                      ),
                      Expanded(
                        child: _IconAction(
                          iconAsset: isGiftSent
                              ? AppThemeAssets.bookDetailSendHeartSent
                              : AppThemeAssets.bookDetailSendHeart,
                          iconWidth: AppSizes.bookDetailBottomIconSize,
                          iconHeight: AppSizes.bookDetailBottomIconSize,
                          label: isGiftSent ? '已送' : '送心',
                          badge: giftCount,
                          onTap: onGiftTap,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  flex: 2,
                  child: AppButton(
                    label: '开始阅读',
                    variant: AppButtonVariant.accent,
                    isExpanded: true,
                    onPressed: onReadTap,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({
    required this.iconAsset,
    required this.iconWidth,
    required this.iconHeight,
    required this.label,
    this.badge,
    this.onTap,
  });

  final String iconAsset;
  final double iconWidth;
  final double iconHeight;
  final String label;
  final String? badge;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      child: SizedBox(
        height: AppSizes.bookDetailBottomItemHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: AppSizes.bookDetailBottomIconSize,
              height: AppSizes.bookDetailBottomIconSize,
              child: Center(
                child: AppAssetImage(
                  assetPath: iconAsset,
                  width: iconWidth,
                  height: iconHeight,
                  fit: BoxFit.contain,
                  // 主题完整色稿（AppThemeAssets），不再运行时染色。
                ),
              ),
            ),
            const SizedBox(height: AppSizes.bottomNavIconLabelGap),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(label, style: AppTextStyles.bookDetailBottomLabel),
                if (badge != null) ...[
                  const SizedBox(width: AppSpacing.xxs),
                  AppText(badge!, style: AppTextStyles.bookDetailBottomLabel),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
