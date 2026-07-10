import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_partner_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/components/elastic_tab_indicator.dart';
import '../../../../shared/widgets/app_pressable.dart';
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
    this.swipeProgress,
  });

  final PartnerTopTab selected;
  final int messageUnreadCount;
  final int interactionUnreadCount;
  final ValueChanged<PartnerTopTab>? onSelected;
  final ValueListenable<double>? swipeProgress;

  @override
  Widget build(BuildContext context) {
    final tabs = PartnerTopTab.values;
    const slotWidth = AppSizes.tabSlotWidthMd;

    return SizedBox(
      width: slotWidth * tabs.length + AppSpacing.md * (tabs.length - 1),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
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
          ElasticTabIndicator(
            selectedIndex: tabs.indexOf(selected),
            slotWidth: slotWidth,
            slotPitch: slotWidth + AppSpacing.md,
            color: AppPartnerColors.primary,
            swipeProgress: swipeProgress,
          ),
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
    return AppPressable(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: AppText(
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
            ),
            if (badgeCount > 0)
              Positioned(
                top: -AppSpacing.sm,
                right: AppSpacing.xs,
                child: _NotificationBadge(count: badgeCount),
              ),
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
