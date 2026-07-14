import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_selection_mark.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/help_feedback_issue_type.dart';

/// 问题类型两列选择网格。
class HelpFeedbackIssueTypeGrid extends StatelessWidget {
  const HelpFeedbackIssueTypeGrid({
    super.key,
    required this.issueTypes,
    required this.selectedIssueTypeId,
    required this.onSelected,
  });

  final List<HelpFeedbackIssueType> issueTypes;
  final String? selectedIssueTypeId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < issueTypes.length; i += 2) {
      final first = issueTypes[i];
      final second = i + 1 < issueTypes.length ? issueTypes[i + 1] : null;
      rows.add(
        Padding(
          padding: EdgeInsets.only(
            bottom: i + 2 >= issueTypes.length ? 0 : AppSpacing.sm,
          ),
          child: Row(
            children: [
              Expanded(
                child: _IssueTypeOption(
                  issueType: first,
                  isSelected: first.id == selectedIssueTypeId,
                  onTap: () => onSelected(first.id),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: second == null
                    ? const SizedBox.shrink()
                    : _IssueTypeOption(
                        issueType: second,
                        isSelected: second.id == selectedIssueTypeId,
                        onTap: () => onSelected(second.id),
                      ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(children: rows);
  }
}

class _IssueTypeOption extends StatelessWidget {
  const _IssueTypeOption({
    required this.issueType,
    required this.isSelected,
    required this.onTap,
  });

  final HelpFeedbackIssueType issueType;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      child: Row(
        children: [
          AppSelectionMark(isSelected: isSelected),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: AppText(
              issueType.label,
              style: AppTextStyles.bodyMediumDarkMuted.copyWith(
                color: isSelected
                    ? AppColors.textOnDark
                    : AppColors.textOnDarkMuted,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
