import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
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
  });

  final MyMessageTab selected;
  final ValueChanged<MyMessageTab> onSelected;

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
    required this.onTap,
  });

  final MyMessageTab tab;
  final bool isSelected;
  final double width;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
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
