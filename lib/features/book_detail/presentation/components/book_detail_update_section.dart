import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/book_update_entry.dart';

/// 更新 tab 深色时间线区。
class BookDetailUpdateSection extends StatelessWidget {
  const BookDetailUpdateSection({super.key, required this.entries});

  final List<BookUpdateEntry> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
        child: Center(
          child: AppText('暂无更新记录', style: AppTextStyles.bookDetailPlaceholder),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.bookDetailUpdateSectionPadding),
      child: Column(
        children: [
          for (var i = 0; i < entries.length; i++)
            _UpdateTimelineItem(
              entry: entries[i],
              isLast: i == entries.length - 1,
            ),
        ],
      ),
    );
  }
}

class _UpdateTimelineItem extends StatelessWidget {
  const _UpdateTimelineItem({required this.entry, required this.isLast});

  final BookUpdateEntry entry;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final dateStyle = entry.isHighlighted
        ? AppTextStyles.bookDetailUpdateDateHighlighted
        : AppTextStyles.bookDetailUpdateDate;
    final titleStyle = entry.isHighlighted
        ? AppTextStyles.bookDetailUpdateTitleHighlighted
        : AppTextStyles.bookDetailUpdateTitle;
    final detailStyle = entry.isHighlighted
        ? AppTextStyles.bookDetailUpdateDetailHighlighted
        : AppTextStyles.bookDetailUpdateDetail;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppSizes.bookDetailUpdateDateColumnWidth,
            height: AppSizes.bookDetailUpdateHeaderRowHeight,
            child: Align(
              alignment: Alignment.centerLeft,
              child: AppText(entry.dateLabel, style: dateStyle),
            ),
          ),
          SizedBox(
            width: AppSizes.bookDetailUpdateTimelineWidth,
            child: Column(
              children: [
                SizedBox(
                  height: AppSizes.bookDetailUpdateHeaderRowHeight,
                  child: Center(
                    child: _TimelineNode(isHighlighted: entry.isHighlighted),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: AppSizes.bookDetailUpdateLineWidth,
                        color: AppColors.bookDetailUpdateLine,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: isLast ? 0 : AppSizes.bookDetailUpdateItemGap,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(entry.title, style: titleStyle),
                  if (entry.detail != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    AppText(entry.detail!, style: detailStyle),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineNode extends StatelessWidget {
  const _TimelineNode({required this.isHighlighted});

  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final borderColor = isHighlighted
        ? AppColors.bookDetailUpdateDotBorderHighlighted
        : AppColors.bookDetailUpdateDotBorder;
    // 高亮（最新）节点：中心圆点同步为橙色高亮色，与日期 / 描边一致。
    final innerColor = isHighlighted
        ? AppColors.bookDetailUpdateDotBorderHighlighted
        : AppColors.bookDetailUpdateDotInner;

    return Container(
      width: AppSizes.bookDetailUpdateDotOuterSize,
      height: AppSizes.bookDetailUpdateDotOuterSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: AppSizes.bookDetailUpdateDotBorderWidth,
        ),
      ),
      alignment: Alignment.center,
      child: Container(
        width: AppSizes.bookDetailUpdateDotInnerSize,
        height: AppSizes.bookDetailUpdateDotInnerSize,
        decoration: BoxDecoration(shape: BoxShape.circle, color: innerColor),
      ),
    );
  }
}
