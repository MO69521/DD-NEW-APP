import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_context.dart';
import '../../../../shared/components/elastic_tab_indicator.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../domain/entities/bookstore_top_tab.dart';

/// 书城顶栏一级 Tab（推荐 / 分类 / 排行）。
class BookstoreTopTabs extends StatelessWidget {
  const BookstoreTopTabs({
    super.key,
    required this.selected,
    this.onSelected,
    this.swipeProgress,
  });

  final BookstoreTopTab selected;
  final ValueChanged<BookstoreTopTab>? onSelected;
  final ValueListenable<double>? swipeProgress;

  @override
  Widget build(BuildContext context) {
    final tabs = BookstoreTopTab.values;
    final textScaler = MediaQuery.textScalerOf(context);
    final textStyle = AppTextStyles.tabActiveDark;
    final slotWidth = _maxTabTextWidth(tabs, textStyle, textScaler);
    final slotPitch = slotWidth + AppSpacing.md;

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
                _BookstoreTopTabItem(
                  tab: tabs[i],
                  isSelected: tabs[i] == selected,
                  width: slotWidth,
                  onTap: onSelected == null ? null : () => onSelected!(tabs[i]),
                ),
              ],
            ],
          ),
          ElasticTabIndicator(
            selectedIndex: tabs.indexOf(selected),
            slotWidth: slotWidth,
            slotPitch: slotPitch,
            swipeProgress: swipeProgress,
          ),
        ],
      ),
    );
  }

  double _maxTabTextWidth(
    List<BookstoreTopTab> tabs,
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

class _BookstoreTopTabItem extends StatelessWidget {
  const _BookstoreTopTabItem({
    required this.tab,
    required this.isSelected,
    required this.width,
    this.onTap,
  });

  final BookstoreTopTab tab;
  final bool isSelected;
  final double width;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final style =
        (isSelected
                ? AppTextStyles.tabActiveDark
                : AppTextStyles.tabInactiveDark)
            .copyWith(
              color: isSelected ? colors.textPrimary : colors.textMuted,
            );

    return AppPressable(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
          child: Text(
            tab.label,
            style: style,
            textAlign: TextAlign.center,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.visible,
          ),
        ),
      ),
    );
  }
}
