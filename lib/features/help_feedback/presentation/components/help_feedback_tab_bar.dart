import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/components/elastic_tab_indicator.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/help_feedback_tab.dart';

/// L3 — 帮助与反馈页顶部 Tab（常见问题 / 意见反馈）。
class HelpFeedbackTabBar extends StatelessWidget {
  const HelpFeedbackTabBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final HelpFeedbackTab selected;
  final ValueChanged<HelpFeedbackTab> onSelected;

  @override
  Widget build(BuildContext context) {
    const tabs = HelpFeedbackTab.values;
    final textScaler = MediaQuery.textScalerOf(context);
    final slotWidth = _maxTabTextWidth(
      tabs,
      AppTextStyles.tabActiveDark,
      textScaler,
    );
    final slotPitch = slotWidth + AppSpacing.xl;

    return SizedBox(
      width: slotWidth * tabs.length + AppSpacing.xl * (tabs.length - 1),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < tabs.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.xl),
                _HelpFeedbackTabItem(
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
    List<HelpFeedbackTab> tabs,
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

class _HelpFeedbackTabItem extends StatelessWidget {
  const _HelpFeedbackTabItem({
    required this.tab,
    required this.isSelected,
    required this.width,
    required this.onTap,
  });

  final HelpFeedbackTab tab;
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
