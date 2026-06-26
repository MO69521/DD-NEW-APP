import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text.dart';

/// 底部固定操作栏：加入书架 / 送心 / 开始阅读（Figma 183:2036）。
class BookDetailBottomBar extends StatelessWidget {
  const BookDetailBottomBar({
    super.key,
    required this.isInShelf,
    required this.giftCount,
    this.onShelfTap,
    this.onGiftTap,
    this.onReadTap,
  });

  final bool isInShelf;
  final String giftCount;
  final VoidCallback? onShelfTap;
  final VoidCallback? onGiftTap;
  final VoidCallback? onReadTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundDark,
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
                        icon: isInShelf
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        label: isInShelf ? '已在书架' : '加入书架',
                        onTap: onShelfTap,
                      ),
                    ),
                    Expanded(
                      child: _IconAction(
                        icon: Icons.favorite_border,
                        label: '送心',
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
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({
    required this.icon,
    required this.label,
    this.badge,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String? badge;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: AppSizes.bookDetailBottomItemHeight,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: AppSizes.bookDetailBottomIconSize,
                  color: AppColors.iconMutedSecondary,
                ),
                const SizedBox(height: AppSizes.bottomNavIconLabelGap),
                AppText(label, style: AppTextStyles.bookDetailBottomLabel),
              ],
            ),
            if (badge != null)
              Positioned(
                top: 0,
                right: AppSpacing.lg,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.bookDetailGiftBadgePaddingH,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundDark,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: AppText(
                    badge!,
                    style: AppTextStyles.bookDetailGiftBadge,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
