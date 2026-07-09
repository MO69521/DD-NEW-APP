import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';

/// 书评详情底部回复输入栏。
class BookDiscussionReplyInputBar extends StatelessWidget {
  const BookDiscussionReplyInputBar({
    super.key,
    required this.authorName,
    required this.draft,
    required this.draftRevision,
    required this.canSend,
    required this.isSubmitting,
    required this.onDraftChanged,
    required this.onSend,
  });

  final String authorName;
  final String draft;
  final int draftRevision;
  final bool canSend;
  final bool isSubmitting;
  final ValueChanged<String> onDraftChanged;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: AppSizes.bookDiscussionDetailInputBarHeight,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: const BoxDecoration(
          color: AppColors.backgroundDark,
          border: Border(top: BorderSide(color: AppColors.borderGlass)),
        ),
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xxs,
          ),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  key: ValueKey(draftRevision),
                  initialValue: draft,
                  onChanged: onDraftChanged,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textOnDark,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: '回复 $authorName:',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textOnDarkMuted,
                    ),
                  ),
                ),
              ),
              AppPressable(
                onTap: canSend ? onSend : null,
                child: AppText(
                  isSubmitting ? '发送中...' : '发送',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: canSend
                        ? AppColors.accentYellow
                        : AppColors.textOnDarkMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
