import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_partner_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/partner_top_tab.dart';

/// L3 — 顶栏「探索 / 消息 / 互动」同级切换。
///
/// 视觉与交互对齐书架 [BookshelfPageTabs]，选中指示条为紫色。
class PartnerTopTabs extends StatelessWidget {
  const PartnerTopTabs({
    super.key,
    required this.selected,
    required this.messageUnreadCount,
    this.interactionUnreadCount = 0,
    this.onSelected,
  });

  final PartnerTopTab selected;
  final int messageUnreadCount;
  final int interactionUnreadCount;
  final ValueChanged<PartnerTopTab>? onSelected;

  @override
  Widget build(BuildContext context) {
    final tabs = PartnerTopTab.values;
    const slotWidth = AppSizes.tabSlotWidthMd;

    return SizedBox(
      width: slotWidth * tabs.length + AppSpacing.md * (tabs.length - 1),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < tabs.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.md),
            _PartnerTopTabItem(
              tab: tabs[i],
              isSelected: tabs[i] == selected,
              width: slotWidth,
              badgeCount: switch (tabs[i]) {
                PartnerTopTab.message => messageUnreadCount,
                PartnerTopTab.interaction => interactionUnreadCount,
                _ => 0,
              },
              onTap: onSelected == null ? null : () => onSelected!(tabs[i]),
            ),
          ],
        ],
      ),
    );
  }
}

class _PartnerTopTabItem extends StatelessWidget {
  const _PartnerTopTabItem({
    required this.tab,
    required this.isSelected,
    required this.width,
    required this.badgeCount,
    this.onTap,
  });

  final PartnerTopTab tab;
  final bool isSelected;
  final double width;
  final int badgeCount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: width,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(
              tab.label,
              style:
                  (isSelected
                          ? AppTextStyles.tabActiveDark
                          : AppTextStyles.tabInactiveDark)
                      .copyWith(
                        color: isSelected
                            ? AppColors.textOnDark
                            : AppColors.textOnDarkMuted,
                      ),
            ),
            if (badgeCount > 0) ...[
              const SizedBox(width: AppSpacing.xxs),
              _NotificationBadge(count: badgeCount),
            ],
          ],
        ),
      ),
    );
  }
}

class _NotificationBadge extends StatelessWidget {
  const _NotificationBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final label = count > 99 ? '99+' : '$count';

    return Container(
      constraints: const BoxConstraints(
        minWidth: AppSizes.partnerNotificationBadgeMinSize,
        minHeight: AppSizes.partnerNotificationBadgeMinSize,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.partnerNotificationBadgePaddingH,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppPartnerColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: AppText(label, style: AppTextStyles.partnerNotificationBadge),
    );
  }
}
