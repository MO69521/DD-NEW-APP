import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/components/elastic_tab_indicator.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/my_message_tab.dart';

/// L3 组件 — 我的消息页 Tab（回复 / 获赞 / 通知）。
class MyMessagesTabBar extends StatelessWidget {
  const MyMessagesTabBar({
    super.key,
    required this.selected,
    required this.onSelected,
    this.unreadCounts = const {},
  });

  final MyMessageTab selected;
  final ValueChanged<MyMessageTab> onSelected;

  /// 各 Tab 未读数；选中的 Tab 视为已读不展示红点。
  final Map<MyMessageTab, int> unreadCounts;

  @override
  Widget build(BuildContext context) {
    final tabs = MyMessageTab.values;
    final textScaler = MediaQuery.textScalerOf(context);
    final slotWidth = _maxTabTextWidth(
      tabs,
      AppTextStyles.tabActiveDark,
      textScaler,
    );
    final slotPitch = slotWidth + AppSpacing.lg;

    return SizedBox(
      width: slotWidth * tabs.length + AppSpacing.lg * (tabs.length - 1),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < tabs.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.lg),
                _MyMessagesTabItem(
                  tab: tabs[i],
                  isSelected: tabs[i] == selected,
                  width: slotWidth,
                  unreadCount: unreadCounts[tabs[i]] ?? 0,
                  onTap: () => onSelected(tabs[i]),
                ),
              ],
            ],
          ),
          ElasticTabIndicator(
            selectedIndex: tabs.indexOf(selected),
            slotWidth: slotWidth,
            slotPitch: slotPitch,
          ),
        ],
      ),
    );
  }

  double _maxTabTextWidth(
    List<MyMessageTab> tabs,
    TextStyle style,
    TextScaler textScaler,
  ) {
    var maxWidth = 0.0;
    for (final tab in tabs) {
      final painter = TextPainter(
        text: TextSpan(text: tab.label, style: style),
        textDirection: TextDirection.ltr,
        maxLines: 1,
        textScaler: textScaler,
      )..layout();
      if (painter.width > maxWidth) maxWidth = painter.width;
    }
    return maxWidth + AppSpacing.xs;
  }
}

class _MyMessagesTabItem extends StatelessWidget {
  const _MyMessagesTabItem({
    required this.tab,
    required this.isSelected,
    required this.width,
    required this.unreadCount,
    required this.onTap,
  });

  final MyMessageTab tab;
  final bool isSelected;
  final double width;
  final int unreadCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
          child: Stack(
            clipBehavior: Clip.none,
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
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
              if (unreadCount > 0)
                Positioned(
                  top: -AppSpacing.sm,
                  right: -AppSpacing.md,
                  child: _UnreadBadge(count: unreadCount),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UnreadBadge extends StatelessWidget {
  const _UnreadBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: AppSizes.myMessagesUnreadBadgeMinSize,
        minHeight: AppSizes.myMessagesUnreadBadgeMinSize,
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
      decoration: BoxDecoration(
        color: AppColors.badgeCount,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: AppText(
        count > 99 ? '99+' : '$count',
        style: AppTextStyles.captionSm.copyWith(color: AppColors.textOnDark),
        maxLines: 1,
      ),
    );
  }
}
