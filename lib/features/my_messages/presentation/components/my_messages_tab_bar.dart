import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/components/elastic_tab_indicator.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/my_message_tab.dart';

/// L3 组件 — 我的消息页 Tab（回复 / 获赞 / 通知）。
class MyMessagesTabBar extends StatelessWidget {
  const MyMessagesTabBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final MyMessageTab selected;
  final ValueChanged<MyMessageTab> onSelected;

  @override
  Widget build(BuildContext context) {
    final tabs = MyMessageTab.values;
    const slotWidth = AppSizes.tabSlotWidthSm;
    const slotPitch = slotWidth + AppSpacing.lg;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: SizedBox(
        width: slotWidth * tabs.length + AppSpacing.lg * (tabs.length - 1),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              children: [
                for (var i = 0; i < tabs.length; i++) ...[
                  if (i > 0) const SizedBox(width: AppSpacing.lg),
                  _MyMessagesTabItem(
                    tab: tabs[i],
                    isSelected: tabs[i] == selected,
                    width: slotWidth,
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
      ),
    );
  }
}

class _MyMessagesTabItem extends StatelessWidget {
  const _MyMessagesTabItem({
    required this.tab,
    required this.isSelected,
    required this.width,
    required this.onTap,
  });

  final MyMessageTab tab;
  final bool isSelected;
  final double width;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: width,
        child: Padding(
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
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
